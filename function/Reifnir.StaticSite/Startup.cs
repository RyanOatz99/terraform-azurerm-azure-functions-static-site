using Microsoft.Azure.Functions.Extensions.DependencyInjection;
using Reifnir.StaticSite.Content;

[assembly: FunctionsStartup(typeof(Reifnir.StaticSite.Startup))]

namespace Reifnir.StaticSite
{
    public class Startup : FunctionsStartup
    {
        public override void Configure(IFunctionsHostBuilder builder)
        {
            builder.Services.AddContentHelper("www");
        }
    }
}
