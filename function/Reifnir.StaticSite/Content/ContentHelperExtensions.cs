using Microsoft.Azure.WebJobs.Host.Bindings;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using System.IO;

namespace Reifnir.StaticSite.Content
{
    public static class ContentHelperExtensions
    {
        public static void AddContentHelper(this IServiceCollection services, string staticContentSubdirectory)
        {
            //Get the execution context to know where we're starting
            var sp = services.BuildServiceProvider();
            var options = sp.GetService<IOptions<ExecutionContextOptions>>();
            var appDirectory = options.Value.AppDirectory;

            var staticContentRootPath = Path.Combine(appDirectory, staticContentSubdirectory);

            services.AddSingleton<IContentHelper, ContentHelper>((x) => new ContentHelper(staticContentRootPath));
        }
    }
}
