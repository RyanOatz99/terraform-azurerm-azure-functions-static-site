namespace Reifnir.StaticSite.Content
{
    public class ContentNotFoundResult : IContentResult
    {
        public string Message { get; }

        public ContentNotFoundResult(string message)
        {
            Message = message;
        }
    }
}
