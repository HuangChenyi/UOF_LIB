<%@ WebService Language="C#" Class="WebService" %>

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
public class WebService  : System.Web.Services.WebService {

        Ede.Uof.EIP.Security.WebService.Authentication m_webserviceAuth = new Ede.Uof.EIP.Security.WebService.Authentication();
    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
    }

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

    [WebMethod]
    public string GetFileId(string fileGroupId, string fileName)
    {
        FileGroup fg = FileCenter.GetFileGroup(fileGroupId);

     
        string fileId = "";
        foreach (UofFile file in fg)
        {
            if (file.Name == fileName)
            {
                fileId = file.Id;
            }
        }

        return fileId;

    }

    /// <summary>
    /// 初始化 Ede.Uof.EIP.SystemInfo.Current 物件, 當 WebService 使用到與 Web 平台有相依性的 UCO, 則需先呼叫此 Method
    /// </summary>
    /// <param name="userGuid"></param>
    private void InitialAuthentication(string userGuid)
    {
        UserUCO ucoCheckuser = new UserUCO();

        //取得 user 的 guid 存入 FormsAuthentication中;
        EBUser ebUser = ucoCheckuser.GetEBUser(userGuid);
        Setting setting = new Setting();
        int userTimeOut = int.Parse(setting["UserTimeOut"]);

        string currentCurrent = ebUser.Culture;

        System.Web.Security.FormsAuthenticationTicket ticket;
        ticket = new System.Web.Security.FormsAuthenticationTicket(1,
                                               userGuid,
                                               DateTime.Now,
                                               DateTime.Now.AddMinutes(userTimeOut),
                                               false,
                                               string.Format(
                                                   "Culture={0}|Theme={1}|Name={2}|Account={3}|UserType={4}"
                                                   , currentCurrent
                                                   , ebUser.Theme
                                                   , ebUser.DisplayName
                                                   , ebUser.Account
                                                   , ebUser.UserType.ToString()
                                                   ),
                                               System.Web.Security.FormsAuthentication.FormsCookiePath);




        // 建立 Identity 物件
        System.Web.Security.FormsIdentity id = new System.Web.Security.FormsIdentity(ticket);

        // 建立 GenericPrincipal 物件, 儲存到 HttpContext 中
        string[] roles = new string[0];
        System.Security.Principal.GenericPrincipal principal = new System.Security.Principal.GenericPrincipal(id, roles);

        Context.User = principal;
    }

    /// <summary>
    /// 取得 Folder 的審核參數
    /// 返回值 :
    /// returnValue[0] = appParentID;    (最上層的審核代碼)        
    /// returnValue[1] = ApproveRmID;    (權限代碼)
    /// returnValue[2] = needApprove;    (true 或 false)
    /// returnValue[3] = APPROVE_TYPE;   (WKF or DMS)
    /// </summary>
    /// <param name="folderId"></param>
    /// <param name="containSelf"></param>
    /// <returns></returns>
    private string[] GetApproveRM(string folderId, bool containSelf)
    {
        string[] approveValue;
        ApproveUCO approve = new ApproveUCO();
        approveValue = approve.GetApproveRM(folderId, true);

        return approveValue;
    }

    /// <summary>
    /// 取得目錄的發佈條件, 只要有任一個條件成立, 就不能使用 WebService 執行上傳
    /// </summary>
    /// <param name="token"></param>
    /// <param name="folderId"></param>
    /// <returns></returns>
    [WebMethod]
    public string[] GetFolderLimit(
        string token,
        string folderId)
    {
        //========= 從認證 Token 取得 USER_GUID ========
        string userGuid = null;
        try
        {
            userGuid = m_webserviceAuth.GetUserGuidFromToken(token);
        }
        catch { }

        if (userGuid == null)
        {
            throw new Exception("[Dms] GetFolderLimit() : Token is invalid, please check your authentication !");
        }

        // 取出 Folder 的檢查項目, 如果有一項就不支援批次上傳後發佈
        ArrayList al = new ArrayList();

        // 檢查 Folder Publish 的限制
        DMSPropertyLimit dmsProLim = new DMSPropertyLimit(folderId, true);

        // 是否輸入文件編號
        if (dmsProLim.IsLimDocSerial)
        {
            al.Add("IsLimDocSerial");
        }

        //是否有限制發行單位的輸入
        if (dmsProLim.IsLimPublishUnit)
        {
            al.Add("IsLimPublishUnit");
        }

        //是否有限制保管者的輸入
        if (dmsProLim.IsLimCustodyUser)
        {
            al.Add("IsLimCustodyUser");
        }

        //是否有限制摘要的輸入
        if (dmsProLim.IsLimDocComment)
        {
            al.Add("IsLimDocComment");
        }

        //是否有限制關鍵字的輸入
        if (dmsProLim.IsLimDocKeyword)
        {
            al.Add("IsLimDocKeyword");
        }

        //是否有限制文件類別的輸入
        if (dmsProLim.IsLimDocType)
        {
            al.Add("IsLimDocType");
        }

        // 是否需要輸入參考文件
        if (dmsProLim.IsLimDocReflink)
        {
            al.Add("IsLimDocReflink");
        }

        // 檢查審核方式, 如果使用 WKF 簽核, 就不能發佈
        string[] approveStrs = GetApproveRM(folderId, true);
        if (approveStrs[2] == "true" && approveStrs[3] == "WKF")
        {
            al.Add("ApproveTypeIsWKF");
        }

        // 檢查身分, 如果是讀者, 或是無權限, 則無法上傳
        if (true)
        {
            DMSFolder dmsFolderprv = new DMSFolder();
            DMSAuthority folderAuthority = dmsFolderprv.GetFolderPrivilege(folderId, userGuid);

            if (folderAuthority == DMSAuthority.DMSNone ||
                folderAuthority == DMSAuthority.DMSReader)
            {
                al.Add("WithoutWritePermission");
            }
        }


        //// 檢查是否 PDF 轉換, 如果有就不能上傳     
        //if (true)
        //{
        //    Setting setting = new Setting();
        //    DMSFolder dmsFolder = new DMSFolder();
        //    FolderDS.TBFolderSourceControlRow folderRow = dmsFolder.GetFolderSourceControl(folderId, true);

        //    if (setting["DMSPDF"].ToLower() != "false" && folderRow.CONVERT_PDF == true)
        //    {
        //        al.Add("NeedConvertToPDF");
        //    }
        //}                       

        // 準備返回值
        string[] strs = new string[al.Count];
        for (int i = 0; i < al.Count; i++)
        {
            strs[i] = al[i].ToString();
        }

        return strs;
    }


    /// <summary>
    /// 檢查在 Folder 之中, 是否有 Document Name 重覆,
    /// 用於在上傳之前的檢查
    /// </summary>
    /// <param name="token"></param>
    /// <param name="folderId"></param>
    /// <param name="docName"></param>
    /// <returns></returns>
    [WebMethod]
    public bool GetDocNameDuplicate(string token, string folderId, string docName)
    {
        //========= 從認證 Token 取得 USER_GUID ========
        string userGuid = null;
        try
        {
            Ede.Uof.EIP.Security.WebService.Authentication m_webserviceAuth = new Ede.Uof.EIP.Security.WebService.Authentication();
            userGuid = m_webserviceAuth.GetUserGuidFromToken(token);
        }
        catch { }

        if (userGuid == null)
        {
            throw new Exception("[Dms] GetDocNameDuplicate() : Token is invalid, please check your authentication !");
        }

        DefaultUCO uco = new DefaultUCO();
        DMSDocDS ds = uco.GetFolderAllDocument(folderId, "", userGuid, "");

        // 應取得 docDS.TBDocProperty
        for (int i = 0; i < ds.TBDocProperty.Rows.Count; i++)
        {
            DMSDocDS.TBDocPropertyRow row = ds.TBDocProperty[i];
            if (row["DOC_NAME"].ToString() == docName)
            {
                return true;
            }
        }

        return false;
    }

    /// <summary>
    /// 取得類別下的所有資料
    /// </summary>
    /// <param name="token"></param>
    /// <param name="classInfo">json 格式 : {"1": "類別名稱", "2":"類別名稱"}</param>
    /// <returns></returns>
    [WebMethod]
    public string GetClassDocList(string token, string classInfo)
    {
        DMSClass dmsClass = new DMSClass();
        string classId = string.Empty;
        string userGuid = string.Empty;
        try
        {
            userGuid = m_webserviceAuth.GetUserGuidFromToken(token);
        }
        catch { }

        if (userGuid == null)
        {
            throw new Exception("[Dms] GetClassDocList() : Token is invalid, please check your authentication !");
        }

        try
        {
            classId = dmsClass.GetClassIdByJson(classInfo);
        }
        catch (JsonFormatException)
        {
            throw new Exception("Json format error");
        }
        catch (ClassPathException)
        {
            throw new Exception("Document category layer errors");
        }
        catch (NoClassException)
        {
            throw new Exception("Document category is not existed");
        }
        catch (Exception ex)
        {
            throw new Exception(ex.Message + Environment.NewLine + ex.StackTrace);
        }

        DMSClassDS classDS = dmsClass.GetClassAllDocDocumentForAPI(classId, true, userGuid);

        return Newtonsoft.Json.JsonConvert.SerializeObject(classDS.TBDocProperty);
    }



    [WebMethod]
    public string AddDoc(string token, string docName, string content, string folderId, string fileGroupId, List<string> refIds)
    {

        Ede.Uof.EIP.Security.WebService.Authentication m_webserviceAuth = new Ede.Uof.EIP.Security.WebService.Authentication();
        string userGuid = null;
        try
        {
            userGuid = m_webserviceAuth.GetUserGuidFromToken(token);
        }
        catch { }

        if (userGuid == null)
        {
            throw new Exception("[Dms] AddNewDoc() : Token is invalid, please check your authentication !");
        }

        // 初始化 Ede.Uof.EIP.SystemInfo.Current 物件, 解決呼叫到 Web 高相依性的 UCO 問題
        this.InitialAuthentication(userGuid);

        // 建立 UCO
        FolderDS folderDS = new FolderDS();
        DMSFolder dmsFolder = new DMSFolder();
        DMSDoc dmsDOC = new DMSDoc();

        string docContentId = Guid.NewGuid().ToString();

        // 取得發佈參數
        string[] approveStrs = GetApproveRM(folderId, true);

        // 檢查目錄是否可以上傳
        if (true)
        {
            string[] limitStrs = GetFolderLimit(token, folderId);   // 取出目錄的限制
            if (limitStrs.Length > 0)
            {
                string errorStr = String.Format("[Dms] AddNewDoc() : Folder not support upload for WebService, reason : {0}",
                    String.Join(",", limitStrs));
                throw new Exception(errorStr);
            }
        }

        // 檢查文件名稱是否重覆
        if (true)
        {
            if (GetDocNameDuplicate(token, folderId, docName))
            {
                string errorStr = String.Format("[Dms] AddNewDoc() : DocName [{0}] is duplicate at the same folder !", docName);
                throw new Exception(errorStr);
            }
        }

        //========== 設定 DocProperty 屬性 =========
        AddNewDocUCO addUCO = new AddNewDocUCO();
        DMSDocDS docDS = new DMSDocDS();

        DMSDocDS.TBDocPropertyRow docr = docDS.TBDocProperty.NewTBDocPropertyRow();
        DMSDocDS.TB_DMS_LENDRow LendROW = docDS.TB_DMS_LEND.NewTB_DMS_LENDRow();

        docr.FOLDER_ID = folderId;      //目錄ID
        docr.DOC_ID = System.Guid.NewGuid().ToString();               //文件ID
        docr.DOC_SERIAL = "";           //文件編號
        docr.DOC_AUTHOR = userGuid;     //作者

        // 文件是存回還是公怖

        docr.DOC_STATUS = DocStatus.Publish.ToString(); // 公佈


        // 電子檔
        docr.DOC_TYPE = "file";

        // 版本控制
        docr.VER_MANUAL_CONTROL = false;    // 自動設定版本

        docr.VERSION_COMMENT = "";

        // 版本手動控制序號
        docr.MANUAL_VERSION = "1.0";

        // 發行單位
        docr.PUBLISH_UNIT = "<UserSet />";

        // 保管者
        docr.CUSTODY_USER = "<UserSet />";

        // 文件備註
        docr.DOC_COMMENT = "";


        DateTime miniValue = new DateTime(1911, 1, 1);
        DateTime maxValue = new DateTime(9999, 12, 31);

        docr.DOC_KEYWORD = "";  //關鍵字


        // 保存期限
        // 生效日 (立刻生效)        
        DateTimeOffset offsetMiniValue = new DateTimeOffset(miniValue);
        docr.ACTIVE_DAY = offsetMiniValue;
        docr.ACTIVE_STATUS = "Active";

        // 失效日 (永不過期)
        DateTimeOffset offsetMaxValue = new DateTimeOffset(maxValue);
        docr.INVALID_DAY = offsetMaxValue;

        //============= 設定機密資訊 =============                           
        // 取得機密資訊    
        FolderDS.TBFolderSourceControlRow folderRow = dmsFolder.GetFolderSourceControl(folderId, true);

        docr.SECRET_RANK = folderRow.SECRET_RANK;   // 機密設定          
        docr.COMMON_EDIT = folderRow.AUTH_COMMON_EDIT;    // 設定共同編輯

        //不轉成PDF
        docr.SOURCE_CONTROL = "Source";
        docr.SECRET_DEFINE = false;

        //調閱設定            
        LendROW.INHERIT_PARENT = true;
        LendROW.DOC_ID = docr.DOC_ID;

        // 文件類別
        docr.DOC_CLASS = "";

        // 檔案屬性
        docr.FILE_ID = "";
        docr.DOC_NAME = docName;

        DateTimeOffset now = UserTime.SetZone(userGuid).GetNowForDb();
        //修改日
        docr.MODIFY_DATE = now;
        //公佈日
        docr.PUBLISH_DATE = now;

        docr.IS_ACTIVE_EQUALTO_PUBLISH = false;

        docr.DOC_MODE = "CONT";
        docr.DOC_CONTENT_ID = docContentId;
            docr.DOC_CONTENT = content;
            docr.CONTENT_FILE_GROUP_ID = fileGroupId;

        //=========== 將資料寫入 DB ===========
        docDS.TBDocProperty.Rows.Add(docr);
        docDS.TB_DMS_LEND.Rows.Add(LendROW);
        foreach (string refId in refIds)
        {
                
            DMSDocDS.TB_DMS_DOC_REFLINKRow RefLinkRow = docDS.TB_DMS_DOC_REFLINK.NewTB_DMS_DOC_REFLINKRow();
            RefLinkRow.DOC_ID = docr.DOC_ID;
            RefLinkRow.REF_DOC_ID = refId;
            RefLinkRow.SYS_VERSION = "1.0";
            RefLinkRow.SYNC_STATUS = true;
            RefLinkRow.SOURCE = Ede.Uof.DMS.DocStore.DocRefUCO.RefSource.DMSRef.ToString();

                docDS.TB_DMS_DOC_REFLINK.AddTB_DMS_DOC_REFLINKRow(RefLinkRow);
        }



        string taskIdStr = "";
        string rmIdStr = approveStrs[1];
        bool needApproveBool = Convert.ToBoolean(approveStrs[2]);

        addUCO.AddDOC(docDS, taskIdStr, rmIdStr, needApproveBool, userGuid);



        return docr.DOC_ID; // 返回 DOC_ID


    }

    /// <summary>
    /// 取得ContentType
    /// </summary>
    /// <param name="fileName"></param>
    /// <returns></returns>
    string GetContentTypeForFileName(string fileName)
    {
        string ext = System.IO.Path.GetExtension(fileName);
        using (Microsoft.Win32.RegistryKey registryKey = Microsoft.Win32.Registry.ClassesRoot.OpenSubKey(ext))
        {
            if (registryKey == null)
                return "application / octet - stream";
            string value = registryKey.GetValue("Content Type").ToString();
            return (value == null) ? "application/octet-stream" : value;
        }
    }

}