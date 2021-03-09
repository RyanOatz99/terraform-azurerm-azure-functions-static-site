using Reifnir.StaticSite.Content;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using Xunit;

namespace Reifnir.StaticSite.Tests.Content
{
    public class ContentHelperTests
    {
        readonly DirectoryInfo contentRoot;

        const string jsonFileAtRootRelativePath = "test.json";
        readonly FileInfo jsonFileAtRoot;
        readonly string jsonFileAtRootContents;

        const string indexHtmlFileInSubdirectoryRelativePath = "subdirectory/index.html";
        readonly FileInfo indexHtmlFileInSubdirectory;
        //readonly string indexHtmlFileInSubdirectoryContents;

        const string fileDoesNotExistRelativePath = "not-not-exist.txt";
        readonly FileInfo fileDoesNotExist;

        public ContentHelperTests()
        {

            var executingAssembly = new FileInfo(System.Reflection.Assembly.GetExecutingAssembly().Location);
            var executionDir = executingAssembly.Directory.FullName;
            contentRoot = new DirectoryInfo(Path.Combine(executionDir, "TestResources"));

            jsonFileAtRoot = new FileInfo(Path.Combine(contentRoot.FullName, jsonFileAtRootRelativePath));
            jsonFileAtRootContents = ReadContents(jsonFileAtRoot);

            indexHtmlFileInSubdirectory = new FileInfo(Path.Combine(contentRoot.FullName, indexHtmlFileInSubdirectoryRelativePath));
            //indexHtmlFileInSubdirectoryContents = ReadContents(indexHtmlFileInSubdirectory);
            
            fileDoesNotExist = new FileInfo(Path.Combine(contentRoot.FullName, fileDoesNotExistRelativePath));
        }

        private static string ReadContents(FileInfo fi)
        {
            using (var fileStream = fi.OpenRead())
            using (var reader = new StreamReader(fileStream))
            {
                var results = reader.ReadToEnd();
                reader.Close();
                fileStream.Close();
                return results;
            }
        }

        [Fact]
        public void TestAssumptionsAboutTestFilesExistence()
        {
            Assert.True(jsonFileAtRoot.Exists);
            Assert.True(indexHtmlFileInSubdirectory.Exists);
            Assert.False(fileDoesNotExist.Exists);
        }

        [Fact]
        public void ReadContentsTest()
        {
            var expected = "{\"isSuccess\": true}";
            var actual = ReadContents(jsonFileAtRoot);
            Assert.Equal(expected, actual);
        }

        [Fact]
        public void CreateOkResult_ReturnsObjectFoundResult()
        {
            var result = ContentHelper.CreateOkResult(jsonFileAtRoot.FullName);
            Assert.IsType<ContentFoundResult>(result);
        }
        
        [Fact]
        public void CreateOkResult_WhenFileExistsReturnsStreamOfThatObject()
        {
            var result = (ContentFoundResult)ContentHelper.CreateOkResult(jsonFileAtRoot.FullName);
            
            string actual;
            using (var reader = new StreamReader(result.Content))
            {
                actual = reader.ReadToEnd();
                reader.Close();
            }

            Assert.Equal(jsonFileAtRootContents, actual);
        }

        [Fact]
        public void CreateOkResult_JsonExtensionReturnsExpectedMimeType()
        {
            var expected = "application/json";
            var result = (ContentFoundResult)ContentHelper.CreateOkResult(jsonFileAtRoot.FullName);

            var actual = result.MimeType;

            Assert.Equal(expected, actual);
        }

        [Fact]
        public void CreateOkResult_HtmlExtensionReturnsExpectedMimeType()
        {
            var expected = "text/html";
            var result = (ContentFoundResult)ContentHelper.CreateOkResult(indexHtmlFileInSubdirectory.FullName);

            var actual = result.MimeType;

            Assert.Equal(expected, actual);
        }

        [Fact]
        public void GetContentAbsolutePath_FileAtRoot()
        {
            var sut = new ContentHelper(contentRoot.FullName);
            var expected = jsonFileAtRoot.FullName;
            var actual = sut.GetContentAbsolutePath(jsonFileAtRootRelativePath);
            Assert.Equal(expected, actual);
        }

        [Fact]
        public void GetContentAbsolutePath_FileInSubdirectory()
        {
            var sut = new ContentHelper(contentRoot.FullName);
            var expected = indexHtmlFileInSubdirectory.FullName;
            var actual = sut.GetContentAbsolutePath(indexHtmlFileInSubdirectoryRelativePath);
            Assert.Equal(expected, actual);
        }

        [Fact]
        public void GetContentAbsolutePath_LeadingSlashDoesNotReturnActualRoot()
        {
            var sut = new ContentHelper(contentRoot.FullName);
            var expected = jsonFileAtRoot.FullName;
            var actual = sut.GetContentAbsolutePath($"/{jsonFileAtRootRelativePath}");
            Assert.Equal(expected, actual);
        }

        [Fact]
        public void GetContentAbsolutePath_LeadingBackslashDoesNotReturnActualRoot()
        {
            var sut = new ContentHelper(contentRoot.FullName);
            var expected = jsonFileAtRoot.FullName;
            var actual = sut.GetContentAbsolutePath($"\\{jsonFileAtRootRelativePath}");
            Assert.Equal(expected, actual);
        }

        [Fact]
        public void GetContentAbsolutePath_PassingRootOfADirectoryReturnsDefaultPage()
        {
            var sut = new ContentHelper(contentRoot.FullName);
            var expected = indexHtmlFileInSubdirectory.FullName;
            var actual = sut.GetContentAbsolutePath($"{indexHtmlFileInSubdirectory.Directory.FullName}/");
            Assert.Equal(expected, actual);
        }

        [Fact]
        public void Constructor_ThrowsExceptionWhenRootPathDoesNotExist()
        {
            Assert.Throws<ArgumentException>(() => new ContentHelper("/does-not-exist"));
        }

        [Fact]
        public void PathOutsideOfContentDirectory_PathInRootOfContentDirectory()
        {
            var sut = new ContentHelper(contentRoot.FullName);
            var actual = sut.PathOutsideOfContentDirectory(jsonFileAtRoot.FullName);
            Assert.False(actual);
        }

        [Fact]
        public void PathOutsideOfContentDirectory_PathInSubDirectoryOfContentDirectory()
        {
            var sut = new ContentHelper(contentRoot.FullName);
            var actual = sut.PathOutsideOfContentDirectory(indexHtmlFileInSubdirectory.FullName);
            Assert.False(actual);
        }

        [Fact]
        public void PathOutsideOfContentDirectory_FileInSameDirectoryAsContentRoot()
        {
            var sut = new ContentHelper(contentRoot.FullName);
            var actual = sut.PathOutsideOfContentDirectory(System.Reflection.Assembly.GetExecutingAssembly().Location);
            Assert.True(actual);
        }

        [Fact]
        public void PathOutsideOfContentDirectory_StartsInContentDirectoryButTraversesParentDirectory()
        {
            var sut = new ContentHelper(contentRoot.FullName);
            var actual = sut.PathOutsideOfContentDirectory($"{indexHtmlFileInSubdirectory.Directory.FullName}/../../something.txt");
            Assert.True(actual);
        }
    }
}
