using Ede.Uof.Utility.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lib.WKF
{
    public class ExternalForm
    {
        public string SendForm(string formInfo)
        {
            Setting setting = new Setting();
            Form.TransferFormWS ws = new Form.TransferFormWS();
            ws.Url = setting["SiteUrl"] + "/WKF/WebService/TransferFormWS.asmx";

            return ws.SendForm(formInfo);
        }


        public string EndForm(string taskId,string account, string result, string reason)
        {
            Setting setting = new Setting();
            Form.TransferFormWS ws = new Form.TransferFormWS();
            ws.Url = setting["SiteUrl"] + "/WKF/WebService/TransferFormWS.asmx";

            return ws.TerminateTask(taskId,account,result,reason);
        }

    }
}
