using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Reifnir.StaticSite.Content;
using System.Net.Http;
using System.Web;
using System.Net;
using System.Net.Http.Headers;

namespace Reifnir.StaticSite
{
    public class StaticSiteFunction
    {
        readonly IContentHelper contentHelper;
        public StaticSiteFunction(IContentHelper _contentHelper)
        {
            contentHelper = _contentHelper;
        }

        [FunctionName("StaticSiteFunction")]
        public HttpResponseMessage Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = null)] HttpRequestMessage req,
            ILogger log)
        {
            var fileRelativePath = ParseFileArgument(req?.RequestUri?.Query);
            log.LogInformation($"fileRelativePath={fileRelativePath}");
            return Run(fileRelativePath, log);
        }

        internal HttpResponseMessage Run(string fileRelativePath, ILogger log)
        {
            log.LogDebug("Executing StaticContentServer.Run method...");

            var contentResult = contentHelper.GetContent(fileRelativePath);
            log.LogInformation($"contentResult type={contentResult?.GetType()?.Name}");

            switch (contentResult)
            {
                case ContentNotFoundResult notFound:
                    log.LogError($"Returning 404: {notFound.Message}");
                    return new HttpResponseMessage(HttpStatusCode.NotFound);

                case ContentFoundResult found:
                    var result = new HttpResponseMessage(HttpStatusCode.OK)
                    {
                        Content = new StreamContent(found.Content)
                    };
                    result.Content.Headers.ContentType = new MediaTypeHeaderValue(found.MimeType);
                    return result;

                default:
                    throw new NotImplementedException($"No implementation for IContentResult of type {contentResult?.GetType()?.FullName}");
            }
        }

        internal string ParseFileArgument(string queryString)
        {
            var queryArguments = HttpUtility.ParseQueryString(queryString);
            return queryArguments.Get("file") ?? "";
        }
    }
}
