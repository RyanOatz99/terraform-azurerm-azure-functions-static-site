namespace Reifnir.StaticSite.Content
{
    public interface IContentHelper
    {
        IContentResult GetContent(string relativePath);
    }
}
