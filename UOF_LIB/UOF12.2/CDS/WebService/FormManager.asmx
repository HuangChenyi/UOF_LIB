<%@ WebService Language="C#" Class="FormManager" %>

using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.IO;
using Ede.Uof.DMS.Data;
using Ede.Uof.DMS;
using Ede.Uof.DMS.DocStore;
using Ede.Uof.Utility.Page.Common;
using Ede.Uof.EIP.Organization.Util;
using System.Text;
using Ede.Uof.Utility.Configuration;
using Ede.Uof.WKF.Design.Data;
using Ede.Uof.WKF.ExternalUtility;
using Ede.Uof.WKF.Utility;
using Ede.Uof.Controls.Upload;
using Telerik.Web.UI;
using Ede.Uof.EIP.SystemInfo;
using System.Collections.Generic;
using Ede.Uof.DMS.Exceptions;
using Ede.Uof.Utility.Log;
using System.Dynamic;
using Ede.Uof.Utility.FileCenter.V3;
using System.Data.SqlTypes;
using Ede.Uof.EIP.PrivateMessage;
using System.Xml;
using System.Web.Services;
using System.Web.Services.Protocols;
using Ede.Uof.WKF.Engine;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// 若要允許使用 ASP.NET AJAX 從指令碼呼叫此 Web 服務，請取消註解下列一行。
// [System.Web.Script.Services.ScriptService]
public class FormManager  : System.Web.Services.WebService {

        Ede.Uof.EIP.Security.WebService.Authentication m_webserviceAuth = new Ede.Uof.EIP.Security.WebService.Authentication();
   

    [WebMethod]
    public string ReturnForm(string taskId, string reason)
    {
        Ede.Uof.WKF.Engine.Task task = new Ede.Uof.WKF.Engine.Task(taskId);
        Ede.Uof.WKF.Engine.ApplyResult oldApplyResult = task.TaskResult;
        ResponsibleUCO responseibleUCO = new ResponsibleUCO();
        responseibleUCO.ReturnForm(taskId);
        responseibleUCO.UpdateExternalTask(taskId, -1);

        responseibleUCO.Log_GUID = Guid.NewGuid().ToString();
        responseibleUCO.User_GUID = "admin";
        responseibleUCO.ContentMethod = ((int)ContentMethod.ReturnForm).ToString();
        responseibleUCO.ExecuteTime = UserTime.GetSystemNowForDb();
        responseibleUCO.taskId = taskId;
        responseibleUCO.formVersionId = task.FormVersionId;
        responseibleUCO.FORM_ID = task.FormId;
        responseibleUCO.DOC_NBR = task.FormNumber;
        responseibleUCO.ModifyPrior = ((int)oldApplyResult).ToString();
        responseibleUCO.ModifyLater = ((int)Ede.Uof.WKF.Engine.ApplyResult.UnKnow).ToString();
        responseibleUCO.EXECUTE_COMMENT = reason;

        responseibleUCO.InsertLog(taskId, task.FormVersionId);
        return "";
    }

    [WebMethod]
    public string EndForm(string taskId, string ApplyResult, string reason)
    {
        Ede.Uof.WKF.Engine.Task task = new Ede.Uof.WKF.Engine.Task(taskId);
        Ede.Uof.WKF.Engine.ApplyResult oldApplyResult = task.TaskResult;
        ResponsibleUCO responsibleUCO = new ResponsibleUCO();
        int newApplyResult = 0;

        Ede.Uof.WKF.Engine.SignResult signResult = Ede.Uof.WKF.Engine.SignResult.Approve;

        switch (ApplyResult)
        {
            case "Reject":
                newApplyResult = 1;
                signResult = Ede.Uof.WKF.Engine.SignResult.Disapprove;
                break;
            case "Cancel":
                //newApplyResult = 2;
                signResult = Ede.Uof.WKF.Engine.SignResult.Cancel;
                break;
            case "Adopt":
                signResult = Ede.Uof.WKF.Engine.SignResult.Approve;

                break;
        }

      
       
        UserSet userSet = new UserSet();
        userSet.SetXML("<UserSet></UserSet>");

        //找出所有未簽核的使用者
        DataTable DT = responsibleUCO.QueryALLSigner(taskId);

        Ede.Uof.WKF.Engine.Task taskObj = new Ede.Uof.WKF.Engine.Task(taskId);

        /*
         * 邏輯
         * 並簽(同意):只要一個人同意就結案
         * 並簽(否決):要全部人同時否決才結案
         * 
         * 會簽(同意):要全部人同時同意才結案
         * 會簽(否決):只要一個人否決就結案
        */

        string formVersionId = "", formId = "", docNbr = "";
        int m_raskResult = 0;

        if (DT != null)
        {
            #region =====否決=====
            if (signResult == SignResult.Disapprove)
            {
                m_raskResult = 1;
                //如果是並簽時,需要全部人否決才結案
                if (taskObj.CurrentSite.SignType == SignType.Or)
                {
                    foreach (DataRow dr in DT.Rows)
                    {
                        task = new Task(taskId, dr["SITE_ID"].ToString(), Convert.ToInt32(dr["NODE_SEQ"]));
                        task.CurrentSite.CurrentNode.IsOnceModifyDoc = false;
                        formVersionId = task.FormVersionId;
                        formId = task.FormId;
                        docNbr = task.FormNumber;
                        task.Sign(dr["SITE_ID"].ToString(), Convert.ToInt32(dr["NODE_SEQ"]), signResult, "admin", true, task.CurrentSite.SignType, 0, userSet, userSet, Source.PC.ToString());

                        //把操作者當成代理人員寫入資料庫
                        responsibleUCO.UpdateAgentSignUser(dr["SITE_ID"].ToString(), Convert.ToInt32(dr["NODE_SEQ"]), "admin");
                    }
                }

                //如果不是並簽,只要一人否決就結案
                if (taskObj.CurrentSite.SignType != SignType.Or)
                {
                    DataRow dr = DT.Rows[0];
                    task = new Task(taskId, dr["SITE_ID"].ToString(), Convert.ToInt32(dr["NODE_SEQ"]));
                    task.CurrentSite.CurrentNode.IsOnceModifyDoc = false;
                    formVersionId = task.FormVersionId;
                    formId = task.FormId;
                    docNbr = task.FormNumber;
                    task.Sign(dr["SITE_ID"].ToString(), Convert.ToInt32(dr["NODE_SEQ"]), signResult, "admin", true, task.CurrentSite.SignType, 0, userSet, userSet, Source.PC.ToString());

                    //把操作者當成代理人員寫入資料庫
                    responsibleUCO.UpdateAgentSignUser(dr["SITE_ID"].ToString(), Convert.ToInt32(dr["NODE_SEQ"]), "admin");
                }


            }
            #endregion

            #region =====同意=====
            if (signResult == SignResult.Approve)
            {
                m_raskResult = 0;
                //如果是並簽只要一個簽核就可以了
                if (taskObj.CurrentSite.SignType == SignType.Or)
                {
                    DataRow dr = DT.Rows[0];
                    task = new Task(taskId, dr["SITE_ID"].ToString(), Convert.ToInt32(dr["NODE_SEQ"]));
                    task.CurrentSite.CurrentNode.IsOnceModifyDoc = false;
                    formVersionId = task.FormVersionId;
                    formId = task.FormId;
                    docNbr = task.FormNumber;
                    task.Sign(dr["SITE_ID"].ToString(), Convert.ToInt32(dr["NODE_SEQ"]), signResult, "admin", true, task.CurrentSite.SignType, 0, userSet, userSet, Source.PC.ToString());

                    //把操作者當成代理人員寫入資料庫
                    responsibleUCO.UpdateAgentSignUser(dr["SITE_ID"].ToString(), Convert.ToInt32(dr["NODE_SEQ"]), "admin");
                }

                //如果不是就要每個都簽核
                if (taskObj.CurrentSite.SignType != SignType.Or)
                {
                    foreach (DataRow dr in DT.Rows)
                    {
                        task = new Task(taskId, dr["SITE_ID"].ToString(), Convert.ToInt32(dr["NODE_SEQ"]));
                        task.CurrentSite.CurrentNode.IsOnceModifyDoc = false;
                        formVersionId = task.FormVersionId;
                        formId = task.FormId;
                        docNbr = task.FormNumber;
                        task.Sign(dr["SITE_ID"].ToString(), Convert.ToInt32(dr["NODE_SEQ"]), signResult, "admin", true, task.CurrentSite.SignType, 0, userSet, userSet, Source.PC.ToString());

                        //把操作者當成代理人員寫入資料庫
                        responsibleUCO.UpdateAgentSignUser(dr["SITE_ID"].ToString(), Convert.ToInt32(dr["NODE_SEQ"]), "admin");
                    }
                }
            }
            #endregion
        }

        //Bug Fix 2990-07-21 @Allen
        //強制結案也要回寫到TB_WKF_EXTERNAL_TASK
        responsibleUCO.UpdateExternalTask(taskId, m_raskResult);

        //成功
        responsibleUCO.Log_GUID = Guid.NewGuid().ToString();
        responsibleUCO.User_GUID = "admin";
        responsibleUCO.ContentMethod = ((int)ContentMethod.EndForm).ToString();
        responsibleUCO.ExecuteTime = UserTime.GetSystemNowForDb();
        responsibleUCO.taskId = taskId;
        responsibleUCO.formVersionId = formVersionId;
        responsibleUCO.FORM_ID = formId;
        responsibleUCO.DOC_NBR = docNbr;
        responsibleUCO.EXECUTE_COMMENT = reason;
        responsibleUCO.ModifyPrior = ((int)Ede.Uof.WKF.Engine.ApplyResult.UnKnow).ToString();
        responsibleUCO.ModifyLater = ((int)signResult).ToString();
        responsibleUCO.InsertLog(taskId, formVersionId);

        return "Succ";
    }

    [WebMethod]
    public string ChangedForm(string taskId, string applyResult, string reason)
    {
        ResponsibleUCO responseibleUCO = new ResponsibleUCO();
        Task task = new Task(taskId);
        //原來的審核結果
        ApplyResult oldApplyResult = task.TaskResult;
        int newApplyResult = 0;
        int m_taskResult = 0;
        if (task.TaskResult.ToString() == "Adopt")
        {
            //如果原本是同意的，要改為否決
            if (applyResult == "Reject")
            {
                newApplyResult = (int)ApplyResult.Reject;
                m_taskResult = 1;
            }
            //如果原本是同意的，要改為作廢
            if (applyResult == "Cancel")
            {
                newApplyResult = (int)ApplyResult.Cancel;
                m_taskResult = 2;
            }

            if (responseibleUCO.ChangeSignResult(taskId, newApplyResult, reason, "admin") == 0)
            {
                //失敗
            //    csm.RegisterClientScriptBlock(this.GetType(), Guid.NewGuid().ToString(), "<script>alert('" + lblFailunChangeSignResultForm.Text + "');</script>");

                return "Fail";
            }
            else
            {
                //成功

                responseibleUCO.UpdateExternalTask(taskId, m_taskResult);

                //呼叫Trigger
                //responseibleUCO.CallFormTrigger(oldApplyResult, taskId, "CHANGES_FORM");
                if (!String.IsNullOrEmpty(task.CurrentDocument.FormVersion.CHANGE_FORM_RESULT_GUID))
                {
                    responseibleUCO.CallFormTrigger(oldApplyResult, task.CurrentDocument.FormVersion.CHANGE_FORM_RESULT_GUID, taskId, false);
                }

                //送訊息
                responseibleUCO.SendMessage("Change", taskId);

                responseibleUCO.Log_GUID = Guid.NewGuid().ToString();
                responseibleUCO.User_GUID = "admin";
                responseibleUCO.ContentMethod = ((int)ContentMethod.ChangeResult).ToString();
                responseibleUCO.ExecuteTime = UserTime.GetSystemNowForDb();
                responseibleUCO.taskId = taskId;
                responseibleUCO.formVersionId = task.FormVersionId;
                responseibleUCO.FORM_ID = task.FormId;
                responseibleUCO.DOC_NBR = task.FormNumber;
                responseibleUCO.EXECUTE_COMMENT = reason;
                responseibleUCO.ModifyPrior = "0";
                responseibleUCO.ModifyLater = ((int)newApplyResult).ToString();
                responseibleUCO.ContentLog = string.Format("<content><SignResult>{0}</SignResult ></content><taskId>{1}</taskId><formVersionId>{2}</formVersionId>", ((int)ApplyResult.Reject).ToString(), taskId, task.FormVersionId);
                responseibleUCO.InsertLog();
                return "Succ";
             //   csm.RegisterClientScriptBlock(this.GetType(), Guid.NewGuid().ToString(), "<script>alert('" + lblSuccessunChangeSignResultForm.Text + "');</script>");
            }
        }
        else if (task.TaskResult.ToString() == ApplyResult.Reject.ToString())
        {
            //如果原本是否決的，要改為同意
            if (applyResult =="Adopt")
            {
                newApplyResult = (int)ApplyResult.Adopt;
                m_taskResult = 0;
            }
            //如果原本是否決的，要改為作廢
            if (applyResult == "Cancel")
            {
                newApplyResult = (int)ApplyResult.Cancel;
                m_taskResult = 2;
            }

            if (responseibleUCO.ChangeSignResult(taskId, newApplyResult, reason, "admin") == 0)
            {
                //失敗
              //  csm.RegisterClientScriptBlock(this.GetType(), Guid.NewGuid().ToString(), "<script>alert('" + lblFailunChangeSignResultForm.Text + "');</script>");

                return "Fail";
            }
            else
            {
                //成功

                responseibleUCO.UpdateExternalTask(taskId, m_taskResult);

                //呼叫Trigger
                //responseibleUCO.CallFormTrigger(oldApplyResult, taskId, "CHANGES_FORM");
                if (!String.IsNullOrEmpty(task.CurrentDocument.FormVersion.CHANGE_FORM_RESULT_GUID))
                {
                    responseibleUCO.CallFormTrigger(oldApplyResult, task.CurrentDocument.FormVersion.CHANGE_FORM_RESULT_GUID, taskId, false);
                }

                //送訊息
                responseibleUCO.SendMessage("Change", taskId);

                responseibleUCO.Log_GUID = Guid.NewGuid().ToString();
                responseibleUCO.User_GUID = "admin";
                responseibleUCO.ContentMethod = ((int)ContentMethod.ChangeResult).ToString();
                responseibleUCO.ExecuteTime = UserTime.GetSystemNowForDb();
                responseibleUCO.taskId = taskId;
                responseibleUCO.formVersionId = task.FormVersionId;
                responseibleUCO.FORM_ID = task.FormId;
                responseibleUCO.DOC_NBR = task.FormNumber;
                responseibleUCO.EXECUTE_COMMENT = reason;
                responseibleUCO.ModifyPrior = "1";
                responseibleUCO.ModifyLater = ((int)newApplyResult).ToString();
                responseibleUCO.ContentLog = string.Format("<content><SignResult>{0}</SignResult ></content><taskId>{1}</taskId><formVersionId>{2}</formVersionId>", ((int)ApplyResult.Reject).ToString(), taskId, task.FormVersionId);
                responseibleUCO.InsertLog();
                return "Succ";
            //    csm.RegisterClientScriptBlock(this.GetType(), Guid.NewGuid().ToString(), "<script>alert('" + lblSuccessunChangeSignResultForm.Text + "');</script>");
            }
        }
        else if (task.TaskResult == ApplyResult.Cancel)
        {
            //如果原本是作廢的，要改為同意
            if (applyResult == "Adopt")
            {
                newApplyResult = (int)ApplyResult.Adopt;
            }
            //如果原本是作廢的，要改為否決
            if (applyResult == "Reject")
            {
                newApplyResult = (int)ApplyResult.Reject;
            }

            if (responseibleUCO.ChangeSignResult(taskId, newApplyResult, reason, "admin") == 0)
            {
                //失敗
               // csm.RegisterClientScriptBlock(this.GetType(), Guid.NewGuid().ToString(), "<script>alert('" + lblFailunChangeSignResultForm.Text + "');</script>");
                return "Fail";
            }
            else
            {
                //成功

                //呼叫Trigger
                //responseibleUCO.CallFormTrigger(oldApplyResult, taskId, "CHANGES_FORM");
                if (!String.IsNullOrEmpty(task.CurrentDocument.FormVersion.CHANGE_FORM_RESULT_GUID))
                {
                    responseibleUCO.CallFormTrigger(oldApplyResult, task.CurrentDocument.FormVersion.CHANGE_FORM_RESULT_GUID, taskId, false);
                }

                //送訊息
                responseibleUCO.SendMessage("Change", taskId);

                responseibleUCO.Log_GUID = Guid.NewGuid().ToString();
                responseibleUCO.User_GUID = "admin";
                responseibleUCO.ContentMethod = ((int)ContentMethod.ChangeResult).ToString();
                responseibleUCO.ExecuteTime = UserTime.GetSystemNowForDb();
                responseibleUCO.taskId = taskId;
                responseibleUCO.formVersionId = task.FormVersionId;
                responseibleUCO.FORM_ID = task.FormId;
                responseibleUCO.DOC_NBR = task.FormNumber;
                responseibleUCO.EXECUTE_COMMENT = reason;
                responseibleUCO.ModifyPrior = ("2").ToString();
                responseibleUCO.ModifyLater = ((int)newApplyResult).ToString();
                responseibleUCO.ContentLog = string.Format("<content><SignResult>{0}</SignResult ></content><taskId>{1}</taskId><formVersionId>{2}</formVersionId>", ((int)ApplyResult.Reject).ToString(), taskId, task.FormVersionId);
                responseibleUCO.InsertLog();

                return "Succ";
               // csm.RegisterClientScriptBlock(this.GetType(), Guid.NewGuid().ToString(), "<script>alert('" + lblSuccessunChangeSignResultForm.Text + "');</script>");
            }
        }
        return "";
    }

    

   

}