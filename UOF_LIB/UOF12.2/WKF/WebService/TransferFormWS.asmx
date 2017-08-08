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

        string msg = String.Format("�I�s��k�G{0}\n���A�G{1}\n���G�G{2}", "SendForm", resultTxT, xmlFormInfo);

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

        string msg = String.Format("�I�s��k�G{0}\n���A�G{1}\n���G�G{2}", "SetRelayFormData", resultTxT, relayFormData);

        Logger.Write("WKF-WebService", msg);
        return resultTxT;
    }
    /// <summary>
    /// ���j���(�P�N�B�_�M�B�@�o)
    /// </summary>
    /// <param name="taskId">Task ID</param>
    /// <param name="account">�ϥΪ̱b��</param>
    /// <param name="result">���n���檺�ʧ@Adopt�BReject�BCancel | �P�N�B�_�M�B����</param>
    /// <param name="reason">��]</param>
    /// <returns>XML���c</returns>
    [WebMethod()]
    public string TerminateTask(string taskId, string account, string result, string reason)
    {
        ResponsibleUCO responsibleUCO = new ResponsibleUCO();

        // �n�^�Ǫ�XML
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
                case "Adopt"://�P�N����
                    signResult = SignResult.Approve;
                    break;
                case "Reject"://�_�M����                        
                    signResult = SignResult.Disapprove;
                    break;
                case "Cancel"://�@�o                        
                    signResult = SignResult.Cancel;
                    break;
            }
        }
        else
        {
            statusElement.InnerText = "0";
            messageElement.InnerText += "���n���檺�ʧ@�榡���~�A�п�JAdopt�BReject�BCancel�C";
        }

        if (!string.IsNullOrEmpty(taskId))
        {
            try
            {
                Task task = new Task(taskId);

                //��Ӫ��f�ֵ��G
                ApplyResult oldApplyResult = task.TaskResult;

                //���o�ާ@��GUID
                string userGuid = string.Empty;
                if (!string.IsNullOrEmpty(account))
                {
                    userGuid = new UserUCO().GetGUID(account);
                    if (!string.IsNullOrEmpty(userGuid))
                    {
                        task.CurrentUser = userGuid;
                        // === �@�o ===
                        if (signResult == SignResult.Cancel)
                        {
                            try
                            {
                                //�p�G��Ӫ���楼����,�N�I�s���ת�Trigger,
                                //�p�G�@�o�ɤw����,�N�I�s�ܧ󪬺A��Trigger.
                                if (oldApplyResult != ApplyResult.Cancel)
                                {
                                    if (task.TaskStatus == ActiveStatus.End)
                                    {
                                        task.CancelForm(false, userGuid);

                                        //�I�sTrigger
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
                                    messageElement.InnerText = "���@�o���\";
                                }
                                else
                                {
                                    statusElement.InnerText = "0";
                                    messageElement.InnerText = "���i���w�@�o�L";
                                }
                            }
                            catch (Ede.Uof.EIP.PrivateMessage.ParamValueErrorException)
                            {
                                statusElement.InnerText = "1";
                                messageElement.InnerText = "���@�o���\";
                            }
                            catch (Exception ex)
                            {
                                //����
                                statusElement.InnerText = "0";
                                messageElement.InnerText = "���@�o����__" + ex.Message;
                            }
                        }

                        UserSet userSet = new UserSet();
                        userSet.SetXML("<UserSet></UserSet>");

                        //��X�Ҧ���ñ�֪��ϥΪ�
                        DataTable DT = responsibleUCO.QueryALLSigner(taskId);
                        string formVersionId;
                        string formId;
                        string docNbr;
                        /*
                         * �޿�
                         * ��ñ(�P�N):�u�n�@�ӤH�P�N�N����
                         * ��ñ(�_�M):�n�����H�P�ɧ_�M�~����
                         * 
                         * �|ñ(�P�N):�n�����H�P�ɦP�N�~����
                         * �|ñ(�_�M):�u�n�@�ӤH�_�M�N����
                        */
                        int m_raskResult = 0;

                        try
                        {
                            if (DT != null)
                            {
                                if (signResult == SignResult.Disapprove) // === �_�M ===
                                {
                                    m_raskResult = 1;
                                    //�p�G�O��ñ��,�ݭn�����H�_�M�~����
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

                                            //��ާ@�̷��N�z�H���g�J��Ʈw
                                            responsibleUCO.UpdateAgentSignUser(dr["SITE_ID"].ToString(), Convert.ToInt32(dr["NODE_SEQ"]), userGuid);
                                        }
                                    }

                                    //�p�G���O��ñ,�u�n�@�H�_�M�N����
                                    if (task.CurrentSite.SignType != SignType.Or)
                                    {
                                        DataRow dr = DT.Rows[0];
                                        task = new Task(taskId, dr["SITE_ID"].ToString(), Convert.ToInt32(dr["NODE_SEQ"]));
                                        task.CurrentSite.CurrentNode.IsOnceModifyDoc = false;
                                        formVersionId = task.FormVersionId;
                                        formId = task.FormId;
                                        docNbr = task.FormNumber;
                                        task.Sign(dr["SITE_ID"].ToString(), Convert.ToInt32(dr["NODE_SEQ"]), signResult, userGuid, true, task.CurrentSite.SignType, 0, userSet, userSet);

                                        //��ާ@�̷��N�z�H���g�J��Ʈw
                                        responsibleUCO.UpdateAgentSignUser(dr["SITE_ID"].ToString(), Convert.ToInt32(dr["NODE_SEQ"]), userGuid);
                                    }
                                }
                                else if (signResult == SignResult.Approve) // === �P�N ===
                                {
                                    m_raskResult = 0;
                                    //�p�G�O��ñ�u�n�@��ñ�ִN�i�H�F
                                    if (task.CurrentSite.SignType == SignType.Or)
                                    {

                                        DataRow dr = DT.Rows[0];
                                        task = new Task(taskId, dr["SITE_ID"].ToString(), Convert.ToInt32(dr["NODE_SEQ"]));
                                        task.CurrentSite.CurrentNode.IsOnceModifyDoc = false;
                                        formVersionId = task.FormVersionId;
                                        formId = task.FormId;
                                        docNbr = task.FormNumber;
                                        task.Sign(dr["SITE_ID"].ToString(), Convert.ToInt32(dr["NODE_SEQ"]), signResult, userGuid, true, task.CurrentSite.SignType, 0, userSet, userSet);

                                        //��ާ@�̷��N�z�H���g�J��Ʈw
                                        responsibleUCO.UpdateAgentSignUser(dr["SITE_ID"].ToString(), Convert.ToInt32(dr["NODE_SEQ"]), userGuid);
                                    }

                                    //�p�G���O�N�n�C�ӳ�ñ��
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

                                            //��ާ@�̷��N�z�H���g�J��Ʈw
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

                                if (signResult == SignResult.Cancel) // === �@�o�@===
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
                                        messageElement.InnerText = "���i���w�@�o�L";
                                    }
                                }
                                else if (signResult == SignResult.Disapprove) // === �_�M ===
                                {
                                    responsibleUCO.ModifyPrior = ((int)ApplyResult.UnKnow).ToString();
                                    responsibleUCO.ModifyLater = ((int)signResult).ToString();

                                    //�w���ת�����A�j��P�N�Χ_�M
                                    if ((oldApplyResult != ApplyResult.Cancel) && (oldApplyResult != ApplyResult.Adopt) && (oldApplyResult != ApplyResult.Reject))
                                    {
                                        //�P�N&�_�M�@��檬�A�g�J"�j���"
                                        responsibleUCO.ContentMethod = ((int)ContentMethod.EndForm).ToString();
                                        statusElement.InnerText = "1";
                                        messageElement.InnerText = "���_�M���\";
                                    }
                                    else
                                    {
                                        statusElement.InnerText = "0";
                                        messageElement.InnerText = "���i���w����";
                                    }
                                }
                                else if (signResult == SignResult.Approve) // === �P�N ===
                                {
                                    responsibleUCO.ModifyPrior = ((int)ApplyResult.UnKnow).ToString();
                                    responsibleUCO.ModifyLater = ((int)signResult).ToString();

                                    //�w���ת�����A�j��P�N�Χ_�M
                                    if ((oldApplyResult != ApplyResult.Cancel) && (oldApplyResult != ApplyResult.Adopt) && (oldApplyResult != ApplyResult.Reject))
                                    {
                                        //�P�N&�_�M�@��檬�A�g�J"�j���"
                                        responsibleUCO.ContentMethod = ((int)ContentMethod.EndForm).ToString();
                                        statusElement.InnerText = "1";
                                        messageElement.InnerText = "���P�N���\";
                                    }
                                    else
                                    {
                                        statusElement.InnerText = "0";
                                        messageElement.InnerText = "���i���w����";
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
                            if (signResult == SignResult.Disapprove) // === �_�M ===
                            {
                                statusElement.InnerText = "0";
                                messageElement.InnerText = "���_�M����__" + ex.Message;
                            }
                            else if (signResult == SignResult.Approve) // === �P�N ===
                            {
                                statusElement.InnerText = "0";
                                messageElement.InnerText = "���P�N����__" + ex.Message;
                            }
                        }
                    }
                    else
                    {
                        statusElement.InnerText = "0";
                        messageElement.InnerText = "�䤣�즹�ާ@��";
                    }
                }
                else
                {
                    statusElement.InnerText = "0";
                    messageElement.InnerText = "�нT�{�ާ@�̱b���O�_����g";
                }
            }
            catch
            {
                statusElement.InnerText = "0";
                messageElement.InnerText = "�䤣������";
            }
        }
        else
        {
            statusElement.InnerText = "0";
            messageElement.InnerText = "Task Id���i���ŭ�";
        }

        exceptionElement.AppendChild(messageElement);
        returnValueElement.AppendChild(statusElement);
        returnValueElement.AppendChild(exceptionElement);
        returnXmlDoc.AppendChild(returnValueElement);

        return returnXmlDoc.OuterXml;
    }

    Task task;

    /// <summary>
    ///���o���C�ӯ��I��ñ�ֵ��G
    /// </summary>
    /// <param name="taskId">Task ID</param>
    /// <param name="isContainFormData">�^�ǭȬO�_�]�t��椺�e��T true,false | �]�t,���]�t</param>
    /// <returns></returns>
    [WebMethod()]
    public string GetTaskResult(string taskId, string isContainFormData)
    {
        // �n�^�Ǫ�XML
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
                    task.IsCallBackXmlWithContent = isFormInfo;//���o��椺�e
                    task.IsCallBackXmlWithComment = true;//���oñ�ַN��

                    formInfo = GetFormSignRecord();

                    if (string.IsNullOrEmpty(formInfo))
                    {
                        statusElement.InnerText = "0";
                        messageElement.InnerText = "�䤣��Ӫ�檺�C�ӯ��Iñ�ֵ��G";
                    }
                }
                else
                {
                    statusElement.InnerText = "0";
                    messageElement.InnerText = "�^�ǭȬO�_�]�t��椺�e��T-�榡���~true | false";
                }
            }
            catch
            {
                statusElement.InnerText = "0";
                messageElement.InnerText = "�䤣������";
            }
        }
        else
        {
            statusElement.InnerText = "0";
            messageElement.InnerText = "TaskId���i���ŭ�";
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
    /// ���o���ñ�־��{
    /// </summary>
    public string GetFormSignRecord()
    {
        XmlDocument xDoc = new XmlDocument();
        xDoc.AppendChild(xDoc.CreateElement("FormResult"));
        //���o�Q�hñ����
        string filterStr = "SIGN_TYPE=" + ((int)SignType.Apply).ToString();
        DataRow[] drs = task.TaskDs.TB_WKF_TASK_SITE.Select(filterStr);
        int returnApplicantCount = drs.Length - 1;

        // ================== �ӽи�T ==================

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


        //  ================== ��椺�e ==================
        //�p�G�]�w�n���o��椺�e��T
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

        // ================== ñ�ַN�� ==================
        //�p�G�]�w�n���oñ�ַN��            
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

                    //ñ�֦����I
                    if ((sDrSite.SITE_TYPE == 0) && (sDrSite.IsPARENT_SITE_IDNull()))
                    {
                        type = "sign";
                        AddXmlElemSiteComment(userUco, xElemComment, sDrSite, sDtNode, order, type);

                        order++;
                    }
                    //�Ƭy�{���I
                    else if (sDrSite.SITE_TYPE == 1)
                    {
                        type = "flow";
                        AddXmlElemSubSiteComment(userUco, xElemComment, sDrSite, sDtSite, sDtNode, order, type);

                        order++;
                    }
                    //���æ����I
                    else if (sDrSite.SITE_TYPE == 2)
                    {
                        type = "branch";
                        AddXmlElemSubSiteComment(userUco, xElemComment, sDrSite, sDtSite, sDtNode, order, type);

                        order++;
                    }
                    //�[ñ���I
                    else if (sDrSite.SITE_TYPE == 3)
                    {
                        type = "additional";
                        AddXmlElemSiteComment(userUco, xElemComment, sDrSite, sDtNode, order, type);

                        order++;
                    }
                    //����y�{
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
    /// [�إ�XmlElement] �NXmlElement�[�Jxml Node ����
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
    ///[�إ�Attribute] �N�ݩʻP�ȡA��Jxml Node ����
    /// </summary>
    /// <param name="xmlNode"></param>
    /// <param name="xmlAttributeName"></param>
    /// <param name="settingValue"></param>
    internal void AddXmlAttribute(XmlNode xmlNode, string xmlAttributeName, string settingValue)
    {
        //�P�_�O�_�����ݩʡA�p�G�S���h�إߤ@�ӷs��
        if (xmlNode.Attributes[xmlAttributeName] == null)
        {
            xmlNode.Attributes.Append(xmlNode.OwnerDocument.CreateAttribute(xmlAttributeName));
        }

        //�]�w Attribute ��
        xmlNode.Attributes[xmlAttributeName].Value = settingValue;
    }

    /// <summary>
    /// �[�J Xml �������
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
                //�p�G�O�ӽЪ̦ۤv�@�o,ACTUAL_SIGNER�ONULL
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
            AddXmlAttribute(xElemSigner, "signTime", signTime);//ñ�֮ɶ�
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

            //�Ƭy�{
            foreach (DataRow drNode in dtNode.Select(String.Format("SITE_ID = '{0}'", sDrSubSite.SITE_ID)))
            {
                TaskDataSet.TB_WKF_TASK_NODERow sDrNode = (TaskDataSet.TB_WKF_TASK_NODERow)drNode;

                string comment = String.Empty;
                string signResult = String.Empty;
                string account = String.Empty;
                string signTime = string.Empty;//ñ�֮ɶ�

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
                AddXmlAttribute(xElemSigner, "signTime", signTime);//ñ�֮ɶ�
                AddXmlElement(xElemSigner, "Account", account);
                AddXmlElement(xElemSigner, "Result", signResult);
                AddXmlElement(xElemSigner, "Text", comment);
                xElemSubSite.AppendChild(xElemSigner);
            }
        }
    }

    /// <summary>
    /// ���o�ϥΪ̱b��
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