using System;
using System.Security.Cryptography.X509Certificates;
using System.Threading.Tasks;
using System.Timers;
using Raven.Client.Documents;
using Raven.Client.Documents.Operations;

namespace dotnet
{
    class Program
    {
        private static DocumentStore Store;
        static void Main(string[] args)
        {
            var certificate = new X509Certificate2("../../install_files/client.pfx");
            Store = new DocumentStore() { Database = "TestDb", Urls = new[] { "https://raven1.mooo.com:8080/" }, Certificate = certificate };
            Store.Initialize();
            
            var timer = new System.Threading.Timer((e) =>
            {
                Save();   
            }, null, TimeSpan.Zero, TimeSpan.FromSeconds(1));
            Console.WriteLine("end");
            Console.ReadLine();
        }

        private static void Save()
        {
            using (var session = Store.OpenSession())
            {
                var message = new Message();
                message.Date = DateTime.UtcNow;
                session.Store(message);
                session.SaveChanges();
                Console.WriteLine($"saved new message with Id {message.Id}");
            }
        }

    }


}
