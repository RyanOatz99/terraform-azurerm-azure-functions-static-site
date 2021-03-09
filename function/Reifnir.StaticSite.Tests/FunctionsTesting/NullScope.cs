using System;
using System.Collections.Generic;
using System.Text;

namespace Reifnir.StaticSite.Tests.FunctionsTesting
{
    public class NullScope : IDisposable
    {
        public static NullScope Instance { get; } = new NullScope();

        private NullScope() { }

        public void Dispose() { }
    }
}
