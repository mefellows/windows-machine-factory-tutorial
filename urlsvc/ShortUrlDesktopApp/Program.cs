namespace ShortUrl
{
    using System;
    using Nancy.Hosting.Self;
    using System.Threading;
    using ShortUrl;

    class Program
    {
        static void Main(string[] args)
        {
            ShortUrlModule artificialReference;
            // var nancyHost = new NancyHost(new Uri("http://localhost:8080/"));
            var nancyHost = new NancyHost(new Uri("http://docker:8080/"));
            nancyHost.Start();
            Console.WriteLine ("Starting on port 8080");
            Thread.Sleep(Timeout.Infinite);
            Console.WriteLine ("Shutting down...");
            nancyHost.Stop();
			      Console.WriteLine ("done");
        }
    }
}
