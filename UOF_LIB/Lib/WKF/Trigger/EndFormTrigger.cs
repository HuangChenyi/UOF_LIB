using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Ede.Uof.WKF.ExternalUtility;
using Lib.WKF.PO;

namespace Lib.WKF.Trigger
{
    public class EndFormTrigger : Ede.Uof.WKF.ExternalUtility.ICallbackTriggerPlugin
    {
        public void Finally()
        {
          //  throw new NotImplementedException();
        }

        public string GetFormResult(ApplyTask applyTask)
        {
            //  throw new NotImplementedException();

            ExternalFormPO po = new ExternalFormPO();

            string tableName = po.QueryExernalForms(applyTask.Task.FormVersionId);

            po.UpdateExernalFormResult(tableName, applyTask.TaskId,(int)applyTask.FormResult);


            return "";
        }

        public void OnError(Exception errorException)
        {
          //  throw new NotImplementedException();
        }
    }
}
