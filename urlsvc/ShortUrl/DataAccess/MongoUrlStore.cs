namespace ShortUrl.DataAccess
{
    using System.Linq;
    using MongoDB.Bson;
    using MongoDB.Driver;
    using MongoDB.Driver.Builders;

    public class MongoUrlStore : UrlStore
	{
		private MongoDatabase database;
		private MongoCollection<BsonDocument> urls;

		public MongoUrlStore(string connectionString)
		{
			database = MongoDatabase.Create(connectionString);
			urls = database.GetCollection("urls");
		}

		public void SaveUrl(string url, string shortenedUrl)
		{
      urls.Save(new { Id = url, url, shortenedUrl });
    }

		public string GetUrlFor(string shortenedUrl)
		{
			var urlDocument =  
				urls
				.Find(Query.EQ("shortenedUrl", shortenedUrl))
				.FirstOrDefault();

			return 
				urlDocument == null ? 
				null : urlDocument["url"].AsString;
		}
	}
}
