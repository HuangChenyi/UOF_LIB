using Ede.Uof.Utility.Task;
using Ede.Uof.WKF.Engine;
using Ede.Uof.WKF.Utility;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lib.TipTop.Trigger
{
    public class ReSendForm : BaseTask
    {
        public override void Run(params string[] args)
        {
            CallDllUCO m_CallDllUCO = new CallDllUCO();
            m_CallDllUCO.BatchRecallDll(args, CallDLLKind.END_FORM, args);
            // throw new NotImplementedException();
        }
    }
}
