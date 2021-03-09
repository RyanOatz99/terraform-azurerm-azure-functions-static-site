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

        const string fileAtRootRelativePath = "test.json";
        readonly FileInfo fileAtRoot;
        readonly string fileAtRootContents;

        const string fileInSubdirectoryRelativePath = "subdirectory/test.html";
        readonly FileInfo fileInSubdirectory;
        readonly string fileInSubdirectoryContents;

        const string fileDoesNotExistRelativePath = "not-not-exist.txt";
        readonly FileInfo fileDoesNotExist;

        public ContentHelperTests()
        {

            var executingAssembly = new FileInfo(System.Reflection.Assembly.GetExecutingAssembly().Location);
            var executionDir = executingAssembly.Directory.FullName;
            contentRoot = new DirectoryInfo(Path.Combine(executionDir, "TestResources"));

            fileAtRoot = new FileInfo(Path.Combine(contentRoot.FullName, fileAtRootRelativePath));
            fileAtRootContents = ReadContents(fileAtRoot);

            fileInSubdirectory = new FileInfo(Path.Combine(contentRoot.FullName, fileInSubdirectoryRelativePath));
            fileInSubdirectoryContents = ReadContents(fileInSubdirectory);
            
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
            Assert.True(fileAtRoot.Exists);
            Assert.True(fileInSubdirectory.Exists);
            Assert.False(fileDoesNotExist.Exists);
        }

        [Fact]
        public void ReadContentsTest()
        {
            var expected = "{\"isSuccess\": true}";
            var actual = ReadContents(fileAtRoot);
            Assert.Equal(expected, actual);
        }

        [Fact]
        public void CreateOkResult_ReturnsObjectFoundResult()
        {
            var result = ContentHelper.CreateOkResult(fileAtRoot.FullName);
            Assert.IsType<ContentFoundResult>(result);
        }
        
        [Fact]
        public void CreateOkResult_WhenFileExistsReturnsStreamOfThatObject()
        {
            var result = (ContentFoundResult)ContentHelper.CreateOkResult(fileAtRoot.FullName);
            
            string actual;
            using (var reader = new StreamReader(result.Content))
            {
                actual = reader.ReadToEnd();
                reader.Close();
            }

            Assert.Equal(fileAtRootContents, actual);
        }

        [Fact]
        public void CreateOkResult_JsonExtensionReturnsExpectedMimeType()
        {
            var expected = "application/json";
            var result = (ContentFoundResult)ContentHelper.CreateOkResult(fileAtRoot.FullName);

            var actual = result.MimeType;

            Assert.Equal(expected, actual);
        }

        [Fact]
        public void CreateOkResult_HtmlExtensionReturnsExpectedMimeType()
        {
            var expected = "text/html";
            var result = (ContentFoundResult)ContentHelper.CreateOkResult(fileInSubdirectory.FullName);

            var actual = result.MimeType;

            Assert.Equal(expected, actual);
        }

        [Fact]
        public void GetContentAbsolutePath_FileAtRoot()
        {
            var sut = new ContentHelper(contentRoot.FullName);
            var expected = fileAtRoot.FullName;
            var actual = sut.GetContentAbsolutePath(fileAtRootRelativePath);
            Assert.Equal(expected, actual);
        }

        [Fact]
        public void GetContentAbsolutePath_FileInSubdirectory()
        {
            var sut = new ContentHelper(contentRoot.FullName);
            var expected = fileInSubdirectory.FullName;
            var actual = sut.GetContentAbsolutePath(fileInSubdirectoryRelativePath);
            Assert.Equal(expected, actual);
        }

        [Fact]
        public void GetContentAbsolutePath_LeadingSlashDoesNotReturnActualRoot()
        {
            var sut = new ContentHelper(contentRoot.FullName);
            var expected = fileAtRoot.FullName;
            var actual = sut.GetContentAbsolutePath($"/{fileAtRootRelativePath}");
            Assert.Equal(expected, actual);
        }

        [Fact]
        public void GetContentAbsolutePath_LeadingBackslashDoesNotReturnActualRoot()
        {
            var sut = new ContentHelper(contentRoot.FullName);
            var expected = fileAtRoot.FullName;
            var actual = sut.GetContentAbsolutePath($"\\{fileAtRootRelativePath}");
            Assert.Equal(expected, actual);
        }
    }
}
