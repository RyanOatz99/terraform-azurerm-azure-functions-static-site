using HeyRed.Mime;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

namespace Reifnir.StaticSite.Content
{
    public class ContentHelper : IContentHelper
    {
        readonly string contentRootPath;
        public ContentHelper(string _contentRootPath)
        {
            contentRootPath = _contentRootPath;
        }

        public IContentResult GetContent(string relativePath)
        {
            throw new NotImplementedException();
        }

        internal static IContentResult CreateOkResult(string contentPath)
        {
            var fileStream = new FileStream(contentPath, FileMode.Open, FileAccess.Read);

            return new ContentFoundResult()
            {
                Content = fileStream,
                MimeType = MimeTypesMap.GetMimeType(contentPath)
            };
        }

        internal string GetContentAbsolutePath(string relativePath)
        {
            // Without the wrapping in FileInfo, slashes and backslashes aren't set to system type
            return new FileInfo(Path.Combine(contentRootPath, relativePath?.TrimStart('/', '\\'))).FullName;
        }
    }
}
