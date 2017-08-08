using Ede.Uof.Utility.Configuration;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PochenPOC.Trigger
{
    public class EndDMSFormTrigger :Ede.Uof.WKF.ExternalUtility.ICallbackTriggerPlugin
    {
        public void Finally()
        {
          //  throw new NotImplementedException();
        }

        public string GetFormResult(Ede.Uof.WKF.ExternalUtility.ApplyTask applyTask)
        {
          //  throw new NotImplementedException();


            if (applyTask.FormResult == Ede.Uof.WKF.Engine.ApplyResult.Adopt)
            {
                Setting setting = new Setting();
                //  var bytes = Ede.Uof.Utility.Doc.DocConvertHelper.UrlToImage(setting ["SiteUrl"]+ "/Test/Upload.aspx", 0);

                var bytes = Ede.Uof.Utility.Doc.DocConvertHelper.UrlToImage(setting["SiteUrl"] + "/CDS/TEST/Upload.aspx?taskId=" + applyTask.TaskId, 0);
            
                Authentication auth = new Authentication();
   

                //取得TOKEN
                string token = auth.GetToken("ERP", "admin","123456");

                FileSystem fs = new FileSystem(token);
                DMSS dms = new DMSS(token);
                MemoryStream ms = new MemoryStream(bytes);
                //建立暫存檔
                string fileGroupId = fs.UploadFileToUOF(ms, applyTask.FormNumber);

                dms.AddNewDOC("DMSRoot", applyTask.FormNumber + ".png", fileGroupId); 


            }

            return "";
        }

        public void OnError(Exception errorException)
        {
          //  throw new NotImplementedException();
        }
    }
}
