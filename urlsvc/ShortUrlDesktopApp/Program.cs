namespace ShortUrlDesktopApp
{
    using System;
    using Nancy.Hosting.Self;
    using ShortUrl;

    class Program
    {
        static void Main(string[] args)
        {
            ShortUrlModule artificiaReference;
            var nancyHost = new NancyHost(new Uri("http://localhost:8080/"));
            nancyHost.Start();

            Console.ReadKey();

            nancyHost.Stop();
        }
    }
}
