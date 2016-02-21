﻿namespace ShortUrl
{
  using Nancy;
  using Nancy.Bootstrapper;
  using Nancy.ViewEngines;
  using DataAccess;

  public class Bootstrapper : DefaultNancyBootstrapper
  {
    protected override void ConfigureApplicationContainer(TinyIoC.TinyIoCContainer container)
    {
      base.ConfigureApplicationContainer(container);

      var mongoUrl = System.Environment.GetEnvironmentVariable("DATABASE_URL");
      if (mongoUrl == null) {
        mongoUrl = "mongodb://localhost:27017/short_url";
      }
      var mongoUrlStore = new MongoUrlStore(mongoUrl);
      container.Register<UrlStore>(mongoUrlStore);
    }

    protected override NancyInternalConfiguration InternalConfiguration
    {
      get
      {
        return NancyInternalConfiguration.WithOverrides(
          x => x.ViewLocationProvider = typeof (ResourceViewLocationProvider));
      }
    }
  }
}
