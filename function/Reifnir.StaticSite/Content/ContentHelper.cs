using HeyRed.Mime;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

namespace Reifnir.StaticSite.Content
{
    public class ContentHelper : IContentHelper
    {
        //TODO: allow this to be set via environment variables, possibly take array
        const string defaultPage = "index.html";

        readonly DirectoryInfo contentRoot;
        public ContentHelper(string contentRootPath)
        {
            contentRoot = new DirectoryInfo(contentRootPath);
            if (!contentRoot.Exists)
                throw new ArgumentException($"The directory {contentRootPath} does not exist.");
        }

        public IContentResult GetContent(string relativePath)
        {
            try
            {
                var contentPath = GetContentAbsolutePath(relativePath);

                if (PathOutsideOfContentDirectory(contentPath))
                    return new ContentNotFoundResult($"relativePath with value of {relativePath ?? "null"} is outside of the allowed confines of {contentRoot.FullName}.");

                if (!File.Exists(contentPath))
                    return new ContentNotFoundResult($"For requested relativePath of {relativePath}, unable to locate file with absolute path of {contentPath}");

                return CreateOkResult(contentPath);
            }
            catch (Exception ex)
            {
                return new ContentNotFoundResult(ex.ToString());
            }
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
            var fullPath = Path.GetFullPath(Path.Combine(contentRoot.FullName, relativePath.TrimStart('/', '\\')));

            var contentFullPath = Directory.Exists(fullPath)
                ? Path.Combine(fullPath, defaultPage)
                : fullPath;

            return contentFullPath;

        }

        internal bool PathOutsideOfContentDirectory(string fullPath)
        {
            var absoluteResourcePath = Path.GetFullPath(fullPath);
            var absoluteContentRootPath = contentRoot.FullName;

            return !absoluteResourcePath.StartsWith(absoluteContentRootPath);            
        }
    }
}
