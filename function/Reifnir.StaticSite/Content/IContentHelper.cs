using System;
using System.Collections.Generic;
using System.Text;

namespace Reifnir.StaticSite.Content
{
    public interface IContentHelper
    {
        IContentResult GetContent(string relativePath);
    }
}
