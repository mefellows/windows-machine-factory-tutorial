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
            var hostName = System.Environment.GetEnvironmentVariable("HOSTNAME");
            var port = System.Environment.GetEnvironmentVariable("PORT");
            var nancyHost = new NancyHost(new Uri("http://" + hostName + ":" + port));
            nancyHost.Start();
            Console.WriteLine ("Starting on port 8080");
            Thread.Sleep(Timeout.Infinite);
            Console.WriteLine ("Shutting down...");
            nancyHost.Stop();
			      Console.WriteLine ("done");
        }
    }
}
