using Moq;
using Reifnir.StaticSite.Content;
using Reifnir.StaticSite.Tests.FunctionsTesting;
using System;
using System.IO;
using System.Net;
using System.Text;
using Xunit;

namespace Reifnir.StaticSite.Tests
{
    public class StaticSiteFunctionTests
    {
        [Fact]
        public void ParseFileArgument_ContentFoundReturnsHttpStatusOk()
        {
            var queryString = "anything";
            var contentHelper = new Mock<IContentHelper>();
            contentHelper
                .Setup(x => x.GetContent(queryString))
                .Returns(SetupContentFoundResult("", "text/html"));

            var logger = TestFactory.CreateLogger();

            var sut = new StaticSiteFunction(contentHelper.Object);
            var result = sut.Run(queryString, logger);

            Assert.Equal(HttpStatusCode.OK, result.StatusCode);
        }

        [Fact]
        public void ParseFileArgument_ContentFoundReturnsContentHelpersMimeType()
        {
            var queryString = "anything";
            var expected = "application/json";
            var contentHelper = new Mock<IContentHelper>();
            contentHelper
                .Setup(x => x.GetContent(queryString))
                .Returns(SetupContentFoundResult("", expected));

            var logger = TestFactory.CreateLogger();

            var sut = new StaticSiteFunction(contentHelper.Object);
            var result = sut.Run(queryString, logger);

            Assert.Equal(expected, result.Content.Headers.ContentType.ToString());
        }

        [Fact]
        public async void ParseFileArgument_ContentFoundReturnsContentHelpersStream()
        {
            var queryString = "anything";
            var expected = "just some content";
            var contentHelper = new Mock<IContentHelper>();
            contentHelper
                .Setup(x => x.GetContent(queryString))
                .Returns(SetupContentFoundResult(expected, "application/json"));

            var logger = TestFactory.CreateLogger();

            var sut = new StaticSiteFunction(contentHelper.Object);
            var result = sut.Run(queryString, logger);
            var actual = await result.Content.ReadAsStringAsync();

            Assert.Equal(expected, actual);
        }

        [Fact]
        public void ParseFileArgument_UnimplimentedContentTypeThrowsException()
        {
            var queryString = "anything";
            var contentHelper = new Mock<IContentHelper>();
            contentHelper
                .Setup(x => x.GetContent(queryString))
                .Returns(new UnimplementedContentResult());

            var logger = TestFactory.CreateLogger();

            var sut = new StaticSiteFunction(contentHelper.Object);

            Assert.Throws<NotImplementedException>(() => sut.Run(queryString, logger));
        }

        private ContentFoundResult SetupContentFoundResult(string contentString, string mimeType)
        {
            
            return new ContentFoundResult()
            {
                Content = new MemoryStream(Encoding.UTF8.GetBytes(contentString)),
                MimeType = mimeType
            };
        }

        private class UnimplementedContentResult : IContentResult
        {
        }
    }
}
