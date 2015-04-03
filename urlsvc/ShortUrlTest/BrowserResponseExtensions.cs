namespace ShortUrlTest
{
    using System.IO;
    using System.Xml.Linq;
    using Nancy.Testing;
    
    public static class BrowserResponseExtensions
    {
        public static XDocument GetBodyAsXml(this BrowserResponse response)
        {
            using (var contentsStream = new MemoryStream())
            {
                response.Context.Response.Contents.Invoke(contentsStream);
                contentsStream.Position = 0;
                return XDocument.Load(contentsStream);
            }
        } 
    }
}
