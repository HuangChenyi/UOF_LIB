<%@ WebService Language="C#" Class="TransferFormWS" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using Ede.Uof.WKF.Engine;
using Ede.Uof.WKF.Utility;
using Ede.Uof.Utility.Log;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Data;
using Ede.Uof.EIP.Organization.Util;
using Ede.Uof.WKF.Data;

[WebService(Namespace = "http://www.1st-excellence.com")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
public class TransferFormWS : System.Web.Services.WebService
{

    [WebMethod()]
    public string SendForm(string xmlFormInfo)
    {
        TaskUtilityUCO taskUtilityUCO = new TaskUtilityUCO();
        taskUtilityUCO.IsExternalData = 1;
        string resultTxT = taskUtilityUCO.WebService_CreateTask(xmlFormInfo);

        string msg = String.Format("呼叫方法：{0}\n狀態：{1}\n結果：{2}", "SendForm", resultTxT, xmlFormInfo);

        Logger.Write("WKF-WebService", msg);

        return resultTxT;
    }

    [WebMethod()]
    public string GetFormList()
    {
        FormVersionUtilityUCO formVersionUtilityUco = new FormVersionUtilityUCO();
        return formVersionUtilityUco.GetFormWithRecentVersion();
    }

    [WebMethod()]
    public string GetExternalFormList()
    {
        FormVersionUtilityUCO formVersionUtilityUco = new FormVersionUtilityUCO();
        return formVersionUtilityUco.GetFormExternalWithRecentVersion();
    }

    [WebMethod()]
    public string GetFormStructure(string formVersionId)
    {
        FormVersionUtilityUCO formVersionUtilityUco = new FormVersionUtilityUCO();
        formVersionUtilityUco.PluginPath = Server.MapPath("~/App_Data");
        return formVersionUtilityUco.GetFormStructure(formVersionId);
    }

    [WebMethod()]
    public string GetFormStructureByFormId(string formId)
    {
        FormVersionUtilityUCO formVersionUtilityUco = new FormVersionUtilityUCO();
        formVersionUtilityUco.PluginPath = Server.MapPath("~/App_Data");
        return formVersionUtilityUco.GetFormStructureByFormId(formId);
    }

    [WebMethod()]
    public string GetTaskData(string taskId)
    {
        try
        {
            Task task = new Task(taskId);
            return task.GetCallbackSendData();
        }
        catch (Exception ex)
        {
            return ex.Message;
        }
    }

    [WebMethod()]
    public string SetRelayFormData(string relayFormData)
    {
        Ede.Uof.WKF.Relay.RelayFormUCO relayFormUco = new Ede.Uof.WKF.Relay.RelayFormUCO();

        string resultTxT = relayFormUco.SetRelayFormData(relayFormData);

        string msg = String.Format("呼叫方法：{0}\n狀態：{1}\n結果：{2}", "SetRelayFormData", resultTxT, relayFormData);

        Logger.Write("WKF-WebService", msg);
        return resultTxT;
    }
    /// <summary>
    /// 表單強制結案(同意、否決、作廢)
    /// </summary>
    /// <param name="taskId">Task ID</param>
    /// <param name="account">使用者帳號</param>
    /// <param name="result">表單要執行的動作Adopt、Reject、Cancel | 同意、否決、結案</param>
    /// <param name="reason">原因</param>
    /// <returns>XML結構</returns>
    [WebMethod()]
    public string TerminateTask(string taskId, string account, string result, string reason)
    {
        ResponsibleUCO responsibleUCO = new ResponsibleUCO();

        // 要回傳的XML
        XmlDocument returnXmlDoc = new XmlDocument();
        XmlElement returnValueElement = returnXmlDoc.CreateElement("ReturnValue");
        XmlElement statusElement = returnXmlDoc.CreateElement("Status");
        XmlElement exceptionElement = returnXmlDoc.CreateElement("Exception");
        XmlElement messageElement = returnXmlDoc.CreateElement("Message");
        statusElement.InnerText = "1";

        SignResult signResult = SignResult.Approve;

        if (!string.IsNullOrEmpty(result) && (result == "Adopt" || result == "Reject" || result == "Cancel"))
        {
            switch (result)
            {
                case "Adopt"://同意結案
                    signResult = SignResult.Approve;
                    break;
                case "Reject"://否決結案                        
                    signResult = SignResult.Disapprove;
                    break;
                case "Cancel"://作廢                        
                    signResult = SignResult.Cancel;
                    break;
            }
        }
        else
        {
            statusElement.InnerText = "0";
            messageElement.InnerText += "表單要執行的動作格式錯誤，請輸入Adopt、Reject、Cancel。";
        }

        if (!string.IsNullOrEmpty(taskId))
        {
            try
            {
                Task task = new Task(taskId);

                //原來的審核結果
                ApplyResult oldApplyResult = task.TaskResult;

                //取得操作者GUID
                string userGuid = string.Empty;
                if (!string.IsNullOrEmpty(account))
                {
                    userGuid = new UserUCO().GetGUID(account);
                    if (!string.IsNullOrEmpty(userGuid))
                    {
                        task.CurrentUser = userGuid;
                        // === 作廢 ===
                        if (signResult == SignResult.Cancel)
                        {
                            try
                            {
                                //如果原來的表單未結案,就呼叫結案的Trigger,
                                //如果作廢時已結案,就呼叫變更狀態的Trigger.
                                if (oldApplyResult != ApplyResult.Cancel)
                                {
                                    if (task.TaskStatus == ActiveStatus.End)
                                    {
                                        task.CancelForm(false, userGuid);

                                        //呼叫Trigger
                                        if (!String.IsNullOrEmpty(task.CurrentDocument.FormVersion.CHANGE_FORM_RESULT_GUID))
                                        {
                                            responsibleUCO.CallFormTrigger(oldApplyResult, task.CurrentDocument.FormVersion.CHANGE_FORM_RESULT_GUID, taskId, false);
                                        }
                                    }
                                    else
                                    {
                                        task.GetBackFirstSiteForm("", false);
                                    }

                                    statusElement.InnerText = "1";
                                    messageElement.InnerText = "表單作廢成功";
                                }
                                else
                                {
                                    statusElement.InnerText = "0";
                                    messageElement.InnerText = "此張表單已作廢過";
                                }
                            }
                            catch (Ede.Uof.EIP.PrivateMessage.ParamValueErrorException)
                            {
                                statusElement.InnerText = "1";
                                messageElement.InnerText = "表單作廢成功";
                            }
                            catch (Exception ex)
                            {
                                //失敗
                                statusElement.InnerText = "0";
                                messageElement.InnerText = "表單作廢失敗__" + ex.Message;
                            }
                        }

                        UserSet userSet = new UserSet();
                        userSet.SetXML("<UserSet></UserSet>");

                        //找出所有未簽核的使用者
                        DataTable DT = responsibleUCO.QueryALLSigner(taskId);
                        string formVersionId;
                        string formId;
                        string docNbr;
                        /*
                         * 邏輯
                         * 並簽(同意):只要一個人同意就結案
                         * 並簽(否決):要全部人同時否決才結案
                         * 
                         * 會簽(同意):要全部人同時同意才結案
                         * 會簽(否決):只要一個人否決就結案
                        */
                        int m_raskResult = 0;

                        try
                        {
                            if (DT != null)
                            {
                                if (signResult == SignResult.Disapprove) // === 否決 ===
                                {
                                    m_raskResult = 1;
                                    //如果是並簽時,需要全部人否決才結案
                                    if (task.CurrentSite.SignType == SignType.Or)
                                    {
                                        foreach (DataRow dr in DT.Rows)
                                        {
                                            task = new Task(taskId, dr["SITE_ID"].ToString(), Convert.ToInt32(dr["NODE_SEQ"]));
                                            task.CurrentSite.CurrentNode.IsOnceModifyDoc = false;
                                            formVersionId = task.FormVersionId;
                                            formId = task.FormId;
                                            docNbr = task.FormNumber;
                                            task.Sign(dr["SITE_ID"].ToString(), Convert.ToInt32(dr["NODE_SEQ"]), signResult, userGuid, true, task.CurrentSite.SignType, 0, userSet, userSet);

                                            //把操作者當成代理人員寫入資料庫
                                            responsibleUCO.UpdateAgentSignUser(dr["SITE_ID"].ToString(), Convert.ToInt32(dr["NODE_SEQ"]), userGuid);
                                        }
                                    }

                                    //如果不是並簽,只要一人否決就結案
                                    if (task.CurrentSite.SignType != SignType.Or)
                                    {
                                        DataRow dr = DT.Rows[0];
                                        task = new Task(taskId, dr["SITE_ID"].ToString(), Convert.ToInt32(dr["NODE_SEQ"]));
                                        task.CurrentSite.CurrentNode.IsOnceModifyDoc = false;
                                        formVersionId = task.FormVersionId;
                                        formId = task.FormId;
                                        docNbr = task.FormNumber;
                                        task.Sign(dr["SITE_ID"].ToString(), Convert.ToInt32(dr["NODE_SEQ"]), signResult, userGuid, true, task.CurrentSite.SignType, 0, userSet, userSet);

                                        //把操作者當成代理人員寫入資料庫
                                        responsibleUCO.UpdateAgentSignUser(dr["SITE_ID"].ToString(), Convert.ToInt32(dr["NODE_SEQ"]), userGuid);
                                    }
                                }
                                else if (signResult == SignResult.Approve) // === 同意 ===
                                {
                                    m_raskResult = 0;
                                    //如果是並簽只要一個簽核就可以了
                                    if (task.CurrentSite.SignType == SignType.Or)
                                    {

                                        DataRow dr = DT.Rows[0];
                                        task = new Task(taskId, dr["SITE_ID"].ToString(), Convert.ToInt32(dr["NODE_SEQ"]));
                                        task.CurrentSite.CurrentNode.IsOnceModifyDoc = false;
                                        formVersionId = task.FormVersionId;
                                        formId = task.FormId;
                                        docNbr = task.FormNumber;
                                        task.Sign(dr["SITE_ID"].ToString(), Convert.ToInt32(dr["NODE_SEQ"]), signResult, userGuid, true, task.CurrentSite.SignType, 0, userSet, userSet);

                                        //把操作者當成代理人員寫入資料庫
                                        responsibleUCO.UpdateAgentSignUser(dr["SITE_ID"].ToString(), Convert.ToInt32(dr["NODE_SEQ"]), userGuid);
                                    }

                                    //如果不是就要每個都簽核
                                    if (task.CurrentSite.SignType != SignType.Or)
                                    {
                                        foreach (DataRow dr in DT.Rows)
                                        {
                                            task = new Task(taskId, dr["SITE_ID"].ToString(), Convert.ToInt32(dr["NODE_SEQ"]));
                                            task.CurrentSite.CurrentNode.IsOnceModifyDoc = false;
                                            formVersionId = task.FormVersionId;
                                            formId = task.FormId;
                                            docNbr = task.FormNumber;
                                            task.Sign(dr["SITE_ID"].ToString(), Convert.ToInt32(dr["NODE_SEQ"]), signResult, userGuid, true, task.CurrentSite.SignType, 0, userSet, userSet);

                                            //把操作者當成代理人員寫入資料庫
                                            responsibleUCO.UpdateAgentSignUser(dr["SITE_ID"].ToString(), Convert.ToInt32(dr["NODE_SEQ"]), userGuid);
                                        }
                                    }
                                }
                            }

                            if (statusElement.InnerText != "0")
                            {
                                responsibleUCO.Log_GUID = Guid.NewGuid().ToString();
                                responsibleUCO.User_GUID = userGuid;
                                responsibleUCO.ExecuteTime = UserTime.SetZone(userGuid).GetNowForDb();
                                responsibleUCO.taskId = taskId;
                                responsibleUCO.formVersionId = task.FormVersionId;
                                responsibleUCO.FORM_ID = task.FormId;
                                responsibleUCO.DOC_NBR = task.FormNumber;
                                responsibleUCO.EXECUTE_COMMENT = reason;

                                if (signResult == SignResult.Cancel) // === 作廢　===
                                {
                                    if (oldApplyResult != ApplyResult.Cancel)
                                    {
                                        responsibleUCO.ContentMethod = ((int)ContentMethod.CancelForm).ToString();
                                        responsibleUCO.ModifyPrior = ((int)oldApplyResult).ToString();
                                        responsibleUCO.ModifyLater = ((int)ApplyResult.Cancel).ToString();
                                    }
                                    else
                                    {
                                        statusElement.InnerText = "0";
                                        messageElement.InnerText = "此張表單已作廢過";
                                    }
                                }
                                else if (signResult == SignResult.Disapprove) // === 否決 ===
                                {
                                    responsibleUCO.ModifyPrior = ((int)ApplyResult.UnKnow).ToString();
                                    responsibleUCO.ModifyLater = ((int)signResult).ToString();

                                    //已結案的不能再強制同意或否決
                                    if ((oldApplyResult != ApplyResult.Cancel) && (oldApplyResult != ApplyResult.Adopt) && (oldApplyResult != ApplyResult.Reject))
                                    {
                                        //同意&否決　表單狀態寫入"強制結案"
                                        responsibleUCO.ContentMethod = ((int)ContentMethod.EndForm).ToString();
                                        statusElement.InnerText = "1";
                                        messageElement.InnerText = "表單否決成功";
                                    }
                                    else
                                    {
                                        statusElement.InnerText = "0";
                                        messageElement.InnerText = "此張表單已結案";
                                    }
                                }
                                else if (signResult == SignResult.Approve) // === 同意 ===
                                {
                                    responsibleUCO.ModifyPrior = ((int)ApplyResult.UnKnow).ToString();
                                    responsibleUCO.ModifyLater = ((int)signResult).ToString();

                                    //已結案的不能再強制同意或否決
                                    if ((oldApplyResult != ApplyResult.Cancel) && (oldApplyResult != ApplyResult.Adopt) && (oldApplyResult != ApplyResult.Reject))
                                    {
                                        //同意&否決　表單狀態寫入"強制結案"
                                        responsibleUCO.ContentMethod = ((int)ContentMethod.EndForm).ToString();
                                        statusElement.InnerText = "1";
                                        messageElement.InnerText = "表單同意成功";
                                    }
                                    else
                                    {
                                        statusElement.InnerText = "0";
                                        messageElement.InnerText = "此張表單已結案";
                                    }
                                }
                                if ((oldApplyResult != ApplyResult.Cancel) && (oldApplyResult != ApplyResult.Adopt) && (oldApplyResult != ApplyResult.Reject))
                                {
                                    responsibleUCO.InsertLog(taskId, task.FormVersionId);
                                }
                            }
                        }
                        catch (Exception ex)
                        {
                            if (signResult == SignResult.Disapprove) // === 否決 ===
                            {
                                statusElement.InnerText = "0";
                                messageElement.InnerText = "表單否決失敗__" + ex.Message;
                            }
                            else if (signResult == SignResult.Approve) // === 同意 ===
                            {
                                statusElement.InnerText = "0";
                                messageElement.InnerText = "表單同意失敗__" + ex.Message;
                            }
                        }
                    }
                    else
                    {
                        statusElement.InnerText = "0";
                        messageElement.InnerText = "找不到此操作者";
                    }
                }
                else
                {
                    statusElement.InnerText = "0";
                    messageElement.InnerText = "請確認操作者帳號是否有填寫";
                }
            }
            catch
            {
                statusElement.InnerText = "0";
                messageElement.InnerText = "找不到表單資料";
            }
        }
        else
        {
            statusElement.InnerText = "0";
            messageElement.InnerText = "Task Id不可為空值";
        }

        exceptionElement.AppendChild(messageElement);
        returnValueElement.AppendChild(statusElement);
        returnValueElement.AppendChild(exceptionElement);
        returnXmlDoc.AppendChild(returnValueElement);

        return returnXmlDoc.OuterXml;
    }

    Task task;

    /// <summary>
    ///取得表單每個站點的簽核結果
    /// </summary>
    /// <param name="taskId">Task ID</param>
    /// <param name="isContainFormData">回傳值是否包含表單內容資訊 true,false | 包含,不包含</param>
    /// <returns></returns>
    [WebMethod()]
    public string GetTaskResult(string taskId, string isContainFormData)
    {
        // 要回傳的XML
        XmlDocument returnXmlDoc = new XmlDocument();
        XmlElement returnValueElement = returnXmlDoc.CreateElement("ReturnValue");
        XmlElement statusElement = returnXmlDoc.CreateElement("Status");
        XmlElement exceptionElement = returnXmlDoc.CreateElement("Exception");
        XmlElement messageElement = returnXmlDoc.CreateElement("Message");
        statusElement.InnerText = "1";

        string formInfo = string.Empty;

        if (!string.IsNullOrEmpty(taskId))
        {
            try
            {
                task = new Task(taskId);

                if (!string.IsNullOrEmpty(isContainFormData) && (isContainFormData == "true" || isContainFormData == "false") || (isContainFormData == "True" || isContainFormData == "False"))
                {
                    bool isFormInfo = bool.Parse(isContainFormData);
                    task.IsCallBackXmlWithContent = isFormInfo;//取得表單內容
                    task.IsCallBackXmlWithComment = true;//取得簽核意見

                    formInfo = GetFormSignRecord();

                    if (string.IsNullOrEmpty(formInfo))
                    {
                        statusElement.InnerText = "0";
                        messageElement.InnerText = "找不到該表單的每個站點簽核結果";
                    }
                }
                else
                {
                    statusElement.InnerText = "0";
                    messageElement.InnerText = "回傳值是否包含表單內容資訊-格式錯誤true | false";
                }
            }
            catch
            {
                statusElement.InnerText = "0";
                messageElement.InnerText = "找不到表單資料";
            }
        }
        else
        {
            statusElement.InnerText = "0";
            messageElement.InnerText = "TaskId不可為空值";
        }

        exceptionElement.AppendChild(messageElement);
        returnValueElement.AppendChild(statusElement);
        returnValueElement.AppendChild(exceptionElement);
        returnXmlDoc.AppendChild(returnValueElement);

        if (statusElement.InnerText == "0")
        {
            return returnXmlDoc.OuterXml;
        }
        else
        {
            return formInfo;
        }
    }

    /// <summary>
    /// 取得表單簽核歷程
    /// </summary>
    public string GetFormSignRecord()
    {
        XmlDocument xDoc = new XmlDocument();
        xDoc.AppendChild(xDoc.CreateElement("FormResult"));
        //取得被退簽次數
        string filterStr = "SIGN_TYPE=" + ((int)SignType.Apply).ToString();
        DataRow[] drs = task.TaskDs.TB_WKF_TASK_SITE.Select(filterStr);
        int returnApplicantCount = drs.Length - 1;

        // ================== 申請資訊 ==================

        XmlElement xElemApplicant = xDoc.CreateElement("Applicant");
        xDoc.DocumentElement.AppendChild(xElemApplicant);

        AddXmlElement(xElemApplicant, "TaskId", task.TaskId);
        AddXmlElement(xElemApplicant, "FormNumber", task.FormNumber);
        AddXmlElement(xElemApplicant, "Account", task.Applicant.Account);
        AddXmlElement(xElemApplicant, "FormId", task.FormId);
        AddXmlElement(xElemApplicant, "FormVersionId", task.FormVersionId);
        AddXmlElement(xElemApplicant, "Result", task.TaskResult.ToString());
        AddXmlElement(xElemApplicant, "ResultDate", task.EndTime.ToString());
        AddXmlElement(xElemApplicant, "RaCount", returnApplicantCount.ToString());
        // ===============================================


        //  ================== 表單內容 ==================
        //如果設定要取得表單內容資訊
        if (task.IsCallBackXmlWithContent)
        {
            XmlElement xElementFormFieldValue = xDoc.CreateElement("FormFieldValue");
            xDoc.DocumentElement.AppendChild(xElementFormFieldValue);

            foreach (Ede.Uof.WKF.Design.VersionField vf in task.CurrentDocument.Fields.FieldList)
            {
                XmlElement xElemFiled = xDoc.CreateElement("FieldItem");
                AddXmlAttribute(xElemFiled, "fieldId", vf.FieldID);
                AddXmlAttribute(xElemFiled, "fieldName", vf.FieldName);

                if (vf.FieldType != Ede.Uof.WKF.Design.FieldType.dataGrid)
                {
                    if (vf.FieldType == Ede.Uof.WKF.Design.FieldType.optionalField)
                    {
                        if (vf.FieldValue != null)
                        {
                            if (vf.FieldSecType == "StudyDocFields" || vf.FieldSecType == "SingleText")
                            {
                                AddXmlAttribute(xElemFiled, "fieldValue", vf.FieldValue);
                            }
                            else
                            {
                                xElemFiled.InnerXml = vf.FieldValue;
                            }
                        }
                    }
                    else if (vf.FieldType == Ede.Uof.WKF.Design.FieldType.multiLineText)
                    {
                        if (vf.FieldValue != null)
                        {
                            AddXmlAttribute(xElemFiled, "fieldValue", vf.FieldValue);
                        }
                    }
                    else
                    {
                        AddXmlAttribute(xElemFiled, "fieldValue", vf.FieldValue);
                    }
                }

                xElementFormFieldValue.AppendChild(xElemFiled);

                if (vf.FieldType == Ede.Uof.WKF.Design.FieldType.dataGrid)
                {
                    int count = 0;
                    Dictionary<string, string> dictField = new Dictionary<string, string>();
                    XmlElement xElemDg = xDoc.CreateElement("DataGrid");
                    xElemFiled.AppendChild(xElemDg);

                    Ede.Uof.WKF.Design.FieldDataGrid fieldDg = (Ede.Uof.WKF.Design.FieldDataGrid)vf;
                    foreach (Ede.Uof.WKF.Design.FieldDataGrid.GridRowValue rowValue in fieldDg.FieldDataGridValue.RowValueList)
                    {
                        foreach (Ede.Uof.WKF.Design.FieldDataGrid.GridCellValue cellValue in rowValue.CellValueList)
                        {
                            dictField.Add(cellValue.fieldId, cellValue.fieldValue);
                        }

                        AddXmlElementFieldDgRow(xElemDg, fieldDg, count, dictField);
                        count++;
                        dictField.Clear();
                    }
                }
            }
        }

        //  =============================================

        // ================== 簽核意見 ==================
        //如果設定要取得簽核意見            
        if (task.IsCallBackXmlWithComment)
        {
            UserUCO userUco = new UserUCO();

            XmlElement xElemComment = xDoc.CreateElement("Comment");
            xDoc.DocumentElement.AppendChild(xElemComment);

            TaskDataSet.TB_WKF_TASK_SITEDataTable sDtSite = task.TaskDs.TB_WKF_TASK_SITE;
            TaskDataSet.TB_WKF_TASK_NODEDataTable sDtNode = task.TaskDs.TB_WKF_TASK_NODE;

            int order = 0;
            string type = string.Empty;
            foreach (DataRow drSite in sDtSite.Rows)
            {
                TaskDataSet.TB_WKF_TASK_SITERow sDrSite = (TaskDataSet.TB_WKF_TASK_SITERow)drSite;

                if (sDrSite.IsSOURCE_SITE_IDNull() || sDrSite.SOURCE_SITE_ID != string.Empty)
                {

                    //簽核式站點
                    if ((sDrSite.SITE_TYPE == 0) && (sDrSite.IsPARENT_SITE_IDNull()))
                    {
                        type = "sign";
                        AddXmlElemSiteComment(userUco, xElemComment, sDrSite, sDtNode, order, type);

                        order++;
                    }
                    //副流程站點
                    else if (sDrSite.SITE_TYPE == 1)
                    {
                        type = "flow";
                        AddXmlElemSubSiteComment(userUco, xElemComment, sDrSite, sDtSite, sDtNode, order, type);

                        order++;
                    }
                    //分岔式站點
                    else if (sDrSite.SITE_TYPE == 2)
                    {
                        type = "branch";
                        AddXmlElemSubSiteComment(userUco, xElemComment, sDrSite, sDtSite, sDtNode, order, type);

                        order++;
                    }
                    //加簽站點
                    else if (sDrSite.SITE_TYPE == 3)
                    {
                        type = "additional";
                        AddXmlElemSiteComment(userUco, xElemComment, sDrSite, sDtNode, order, type);

                        order++;
                    }
                    //平行流程
                    else if (sDrSite.SITE_TYPE == 4)
                    {
                        type = "parallelFlow";
                        AddXmlElemSubSiteComment(userUco, xElemComment, sDrSite, sDtSite, sDtNode, order, type);

                        order++;
                    }
                }
            }
        }
        //  =============================================

        FormVersionUtilityUCO.StringWriterWithEncoding sw = new FormVersionUtilityUCO.StringWriterWithEncoding(Encoding.UTF8);
        xDoc.Save(sw);
        return sw.ToString();
    }
    /// <summary>
    /// [建立XmlElement] 將XmlElement加入xml Node 之中
    /// </summary>
    /// <param name="xParentNode"></param>
    /// <param name="elementName"></param>
    /// <param name="elementInnerText"></param>
    /// <returns></returns>
    private XmlElement AddXmlElement(XmlNode xParentNode, string elementName, string elementInnerText)
    {
        XmlElement xElement = xParentNode.OwnerDocument.CreateElement(elementName);

        if (!String.IsNullOrEmpty(elementInnerText))
        {
            xElement.InnerText = elementInnerText;
        }

        xParentNode.AppendChild(xElement);
        return xElement;
    }
    /// <summary>
    ///[建立Attribute] 將屬性與值，放入xml Node 之中
    /// </summary>
    /// <param name="xmlNode"></param>
    /// <param name="xmlAttributeName"></param>
    /// <param name="settingValue"></param>
    internal void AddXmlAttribute(XmlNode xmlNode, string xmlAttributeName, string settingValue)
    {
        //判斷是否有此屬性，如果沒有則建立一個新的
        if (xmlNode.Attributes[xmlAttributeName] == null)
        {
            xmlNode.Attributes.Append(xmlNode.OwnerDocument.CreateAttribute(xmlAttributeName));
        }

        //設定 Attribute 值
        xmlNode.Attributes[xmlAttributeName].Value = settingValue;
    }

    /// <summary>
    /// 加入 Xml 明細欄位
    /// </summary>
    /// <param name="xNodeDg"></param>
    /// <param name="filedDg"></param>
    /// <param name="order"></param>
    /// <param name="dictField"></param>
    private void AddXmlElementFieldDgRow(XmlNode xNodeDg, Ede.Uof.WKF.Design.FieldDataGrid filedDg, int order, Dictionary<string, string> dictField)
    {
        XmlElement xElemRow = xNodeDg.OwnerDocument.CreateElement("Row");
        AddXmlAttribute(xElemRow, "order", order.ToString());
        xNodeDg.AppendChild(xElemRow);

        foreach (Ede.Uof.WKF.Design.VersionField vfDg in filedDg.DataGridFieldCollection.FieldList)
        {
            XmlElement xElemDgCell = xNodeDg.OwnerDocument.CreateElement("Cell");
            AddXmlAttribute(xElemDgCell, "fieldId", vfDg.FieldID);
            AddXmlAttribute(xElemDgCell, "fieldName", vfDg.FieldName);
            if (dictField.ContainsKey(vfDg.FieldID))
            {
                AddXmlAttribute(xElemDgCell, "fieldValue", dictField[vfDg.FieldID]);
            }
            else
            {
                AddXmlAttribute(xElemDgCell, "fieldValue", "");
            }
            xElemRow.AppendChild(xElemDgCell);
        }
    }
    /// <summary>
    /// AddXmlElemSiteComment
    /// </summary>
    /// <param name="userUco"></param>
    /// <param name="xNodeComment"></param>
    /// <param name="sDrSite"></param>
    /// <param name="sDtNode"></param>
    /// <param name="order"></param>
    private void AddXmlElemSiteComment(UserUCO userUco, XmlNode xNodeComment, TaskDataSet.TB_WKF_TASK_SITERow sDrSite, TaskDataSet.TB_WKF_TASK_NODEDataTable sDtNode, int order, string type)
    {
        XmlDocument xDoc = xNodeComment.OwnerDocument;
        XmlElement xElemSite = xDoc.CreateElement("Site");
        xNodeComment.AppendChild(xElemSite);
        AddXmlAttribute(xElemSite, "order", order.ToString());
        AddXmlAttribute(xElemSite, "type", type);

        foreach (DataRow drNode in sDtNode.Select(String.Format("SITE_ID = '{0}'", sDrSite.SITE_ID)))
        {
            TaskDataSet.TB_WKF_TASK_NODERow sDrNode = (TaskDataSet.TB_WKF_TASK_NODERow)drNode;

            string comment = String.Empty;
            string signResult = String.Empty;
            string account = String.Empty;
            string signTime = string.Empty;

            if (!sDrNode.IsFINISH_TIMENull())
            {
                signTime = sDrNode.FINISH_TIME.ToString("yyyy/MM/dd HH:mm");
            }

            if (!sDrNode.IsSIGN_STATUSNull())
            {
                signResult = ((SignResult)sDrNode.SIGN_STATUS).ToString();
                //Bug Fix 2009-07-21 @ Allen
                //如果是申請者自己作廢,ACTUAL_SIGNER是NULL
                if (!sDrNode.IsACTUAL_SIGNERNull())
                {
                    account = GetUserAccount(userUco, sDrNode.ACTUAL_SIGNER);
                }
                else
                {
                    if (Ede.Uof.EIP.SystemInfo.Current.UserGUID == null)
                    {
                        account = GetUserAccount(userUco, task.Signer);
                    }
                    else
                    {
                        account = GetUserAccount(userUco, Ede.Uof.EIP.SystemInfo.Current.UserGUID);
                    }
                }

                if (!sDrNode.IsCOMMENTNull())
                {
                    comment = sDrNode.COMMENT;
                }
            }
            else
            {
                signResult = string.Empty;

                if (!sDrNode.IsCOMMENTNull())
                {
                    comment = sDrNode.COMMENT;
                }

                account = GetUserAccount(userUco, sDrNode.ORIGINAL_SIGNER);
            }

            XmlElement xElemSigner = xDoc.CreateElement("Signer");
            AddXmlAttribute(xElemSigner, "signTime", signTime);//簽核時間
            AddXmlElement(xElemSigner, "Account", account);
            AddXmlElement(xElemSigner, "Result", signResult);
            AddXmlElement(xElemSigner, "Text", comment);

            xElemSite.AppendChild(xElemSigner);
        }
    }
    /// <summary>
    /// AddXmlElemSubSiteComment
    /// </summary>
    /// <param name="userUco"></param>
    /// <param name="xNodeComment"></param>
    /// <param name="rowSite"></param>
    /// <param name="dtSite"></param>
    /// <param name="dtNode"></param>
    /// <param name="order"></param>
    private void AddXmlElemSubSiteComment(UserUCO userUco, XmlNode xNodeComment, TaskDataSet.TB_WKF_TASK_SITERow rowSite, TaskDataSet.TB_WKF_TASK_SITEDataTable dtSite, TaskDataSet.TB_WKF_TASK_NODEDataTable dtNode, int order, string type)
    {
        XmlDocument xDoc = xNodeComment.OwnerDocument;
        XmlElement xElemSite = xDoc.CreateElement("Site");
        xNodeComment.AppendChild(xElemSite);
        AddXmlAttribute(xElemSite, "order", order.ToString());
        AddXmlAttribute(xElemSite, "type", type);

        int subOrder = 0;
        foreach (DataRow drSubSite in dtSite.Select(String.Format("PARENT_SITE_ID = '{0}'", rowSite.SITE_ID)))
        {
            TaskDataSet.TB_WKF_TASK_SITERow sDrSubSite = (TaskDataSet.TB_WKF_TASK_SITERow)drSubSite;

            XmlElement xElemSubSite = xDoc.CreateElement("SubSite");
            AddXmlAttribute(xElemSubSite, "order", subOrder.ToString());
            xElemSite.AppendChild(xElemSubSite);
            subOrder++;

            //副流程
            foreach (DataRow drNode in dtNode.Select(String.Format("SITE_ID = '{0}'", sDrSubSite.SITE_ID)))
            {
                TaskDataSet.TB_WKF_TASK_NODERow sDrNode = (TaskDataSet.TB_WKF_TASK_NODERow)drNode;

                string comment = String.Empty;
                string signResult = String.Empty;
                string account = String.Empty;
                string signTime = string.Empty;//簽核時間

                if (!sDrNode.IsFINISH_TIMENull())
                {
                    signTime = sDrNode.FINISH_TIME.ToString("yyyy/MM/dd HH:mm");
                }

                if (!sDrNode.IsSIGN_STATUSNull())
                {
                    signResult = ((SignResult)sDrNode.SIGN_STATUS).ToString();
                    account = GetUserAccount(userUco, sDrNode.ACTUAL_SIGNER);

                    if (!sDrNode.IsCOMMENTNull())
                    {
                        comment = sDrNode.COMMENT;
                    }
                }
                else
                {
                    signResult = string.Empty;

                    if (!sDrNode.IsCOMMENTNull())
                    {
                        comment = sDrNode.COMMENT;
                    }

                    account = GetUserAccount(userUco, sDrNode.ORIGINAL_SIGNER);
                }

                XmlElement xElemSigner = xDoc.CreateElement("Signer");
                AddXmlAttribute(xElemSigner, "signTime", signTime);//簽核時間
                AddXmlElement(xElemSigner, "Account", account);
                AddXmlElement(xElemSigner, "Result", signResult);
                AddXmlElement(xElemSigner, "Text", comment);
                xElemSubSite.AppendChild(xElemSigner);
            }
        }
    }

    /// <summary>
    /// 取得使用者帳號
    /// </summary>
    /// <param name="userUco"></param>
    /// <param name="userGuid"></param>
    /// <returns></returns>
    private string GetUserAccount(UserUCO userUco, string userGuid)
    {
        EBUser ebUser = userUco.GetEBUser(userGuid);

        if (ebUser != null)
        {
            return ebUser.Account;
        }
        else
        {
            return String.Empty;
        }
    }
}