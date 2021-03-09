using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

namespace Reifnir.StaticSite.Content
{
    public class ContentFoundResult : IContentResult
    {
        public Stream Content { get; set; }
        public string MimeType { get; set; }
    }
}
