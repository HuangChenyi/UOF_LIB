using Ede.Uof.Utility.Log;
using Ede.Uof.Utility.Task;
using Lib.WKF.PO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lib.WKF
{
    public class CreateFormTask : BaseTask
    {
        public override void Run(params string[] args)
        {

            using (var po = new ExternalFormPO())
            {
                //先取得所有可以起單的TABLE
                DataTable externalFormsDt = po.QueryExernalForms();

                DataTable dt = new DataTable();
                dt.Columns.Add("RESULT");

                //根據定義的表單來起單
                foreach (DataRow externalFormsDr in externalFormsDt.Rows)
                {
                    //根據自訂TABLE來找出要起單的資料
                    DataTable applyFormDt = po.QueryAllApplyForms(externalFormsDr["EXTERNAL_TABLE_NAME"].ToString());

                    foreach (DataRow applyFormDr in applyFormDt.Rows)
                    {

                        try
                        {
                            FormUtitlity formUtil = new FormUtitlity();

                            string formXml = formUtil.GetFormXML(applyFormDr, externalFormsDr);

                            //直接起單
                            Ede.Uof.WKF.Utility.TaskUtilityUCO taskUtli = new Ede.Uof.WKF.Utility.TaskUtilityUCO();

                            string log = taskUtli.WebService_CreateTask(formXml);


                            formUtil.GetResult(applyFormDr["EXTERNAL_TASK_ID"].ToString(), externalFormsDr["EXTERNAL_TABLE_NAME"].ToString(), log);

                            dt.Rows.Add(new object[] { log });
                        }
                        catch (Exception ce)
                        {
                            //讓例外發生時表單還可以正常起單
                                    po.UpdateFormStatus(applyFormDr["EXTERNAL_TASK_ID"].ToString(), externalFormsDr["EXTERNAL_TABLE_NAME"].ToString(), "0", "", "", ce.ToString());
                               
                            
                        }
                    }
                }
            }

        }
    }
}
