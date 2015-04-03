namespace ShortUrlTest
{
    using System.Linq;
    using MongoDB.Bson;
    using MongoDB.Driver;
    using MongoDB.Driver.Builders;
    using ShortUrl.DataAccess;
    using Xunit;

    public class MongoUrlStoreTest
	{
		private string connectionString = "mongodb://localhost:27010/short_url_test";
		private MongoDatabase database;
		private MongoCollection<BsonDocument> urlCollection;

		public MongoUrlStoreTest()
		{
			//given
			database = MongoDatabase.Create(connectionString);
			urlCollection = database.GetCollection("urls");
		}

		[Fact]
		public void should_store_urls_in_mongo()
		{
			//when
			var store = new MongoUrlStore(connectionString);
			store.SaveUrl("http://somelongurl.com/", "http://shorturl/abc");

			//then
			var urlFromDB = urlCollection
				.Find(Query.EQ("url", "http://somelongurl.com/"))
				.FirstOrDefault();

			Assert.NotNull(urlFromDB);
			Assert.Equal(urlFromDB["shortenedUrl"], "http://shorturl/abc");
		}

		[Fact]
		public void should_be_able_to_find_shortened_urls()
		{
			//given
			var store = new MongoUrlStore(connectionString);
			store.SaveUrl("http://somelongurl.com/", "http://shorturl/abc");

			//when
			var longUrl = store.GetUrlFor("http://shorturl/abc");

			//then
			Assert.Equal("http://somelongurl.com/", longUrl);
		}
	}
}
