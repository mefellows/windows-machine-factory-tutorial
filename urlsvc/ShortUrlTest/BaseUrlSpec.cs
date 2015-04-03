namespace ShortUrlTest
{
	using System.Linq;
	using Nancy;
	using Nancy.Testing;
	using ShortUrl;
	using Xunit;

	public class BaseUrlSpec
	{
		private Browser app;

		public BaseUrlSpec()
		{
			app = new Browser(new Bootstrapper());
		}

		[Fact]
		public void should_respond_ok()
		{
			var response = app.Get("/", with => with.HttpRequest());
			var statusCode = response.StatusCode;
			Assert.Equal(HttpStatusCode.OK, statusCode);
		}

		[Fact]
		public void should_contain_a_form_with_an_input_field_for_a_url_and_a_button()
		{
			//when
			var baseUrlGetResponse = app.Get("/", with => with.HttpRequest());

			//then
			baseUrlGetResponse.Body["form"]
				.ShouldExist();

			baseUrlGetResponse.Body["input#url"]
				.ShouldExistOnce();

			baseUrlGetResponse.Body["label"]
				.ShouldExistOnce().And
				.ShouldContain("Url: ");

			baseUrlGetResponse.Body["input#submit"]
				.ShouldExistOnce();
		}

		[Fact]
		public void should_return_shortened_url_when_posting_url()
		{
			//when
			var baseUrlPostResponse = app.Post("/",
				with =>
				{
					with.FormValue("url", "http://www.longurlplease.com/");
					with.HttpRequest();
				});

			baseUrlPostResponse.Body["a#shorturl"]
				.ShouldExist().And
				.ShouldContain("http://");
		}

		[Fact]
		public void should_redirect_to_original_url_when_getting_short_url()
		{
			//when
			var baseUrlPostResponse = app.Post("/",
				with =>
				{
					with.FormValue("url", "http://www.longurlplease.com/");
					with.HttpRequest();
				}).GetBodyAsXml();

			var shortUrl = baseUrlPostResponse
				.Element("html").Element("body").Element("a")
				.Attribute("href").Value
				.Split('/')
				.Last();

			//then
			app.Get("/" + shortUrl, with => with.HttpRequest())
				.ShouldHaveRedirectedTo("http://www.longurlplease.com/");
		}
	}
}
