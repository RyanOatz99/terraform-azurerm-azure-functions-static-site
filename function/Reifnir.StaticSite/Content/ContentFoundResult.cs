using System.IO;

namespace Reifnir.StaticSite.Content
{
    public class ContentFoundResult : IContentResult
    {
        public Stream Content { get; set; }
        public string MimeType { get; set; }
    }
}
