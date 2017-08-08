using Ede.Uof.EIP.Organization;
using Ede.Uof.EIP.Organization.Util;
using Ede.Uof.Utility.Log;
using Ede.Uof.Utility.Page;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

public partial class CDS_Default : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    DB db = new DB();

    protected void Button1_Click(object sender, EventArgs e)
    {

        //先取得所有可以起單的TABLE
        DataTable externalFormsDt = db.QueryExernalForms();

        DataTable dt = new DataTable();
        dt.Columns.Add("RESULT");

        //根據定義的表單來起單
        foreach (DataRow externalFormsDr in externalFormsDt.Rows)
        {
            //根據自訂TABLE來找出要起單的資料
            DataTable applyFormDt = db.QueryAllApplyForms(externalFormsDr["EXTERNAL_TABLE_NAME"].ToString());

            foreach (DataRow applyFormDr in applyFormDt.Rows)
            {
                string formXml = GetFormXML(applyFormDr, externalFormsDr);

                //直接起單
                Ede.Uof.WKF.Utility.TaskUtilityUCO taskUtli = new Ede.Uof.WKF.Utility.TaskUtilityUCO();

                string log = taskUtli.WebService_CreateTask(formXml);


                GetResult(applyFormDr["EXTERNAL_TASK_ID"].ToString(), externalFormsDr["EXTERNAL_TABLE_NAME"].ToString(), log);

                dt.Rows.Add(new object[] {log});
            }
        }


        Grid1.DataSource = dt;
        Grid1.DataBind();

        



    }

    private void GetResult(string externalTaskId, string tableName ,string log)
    {

        XmlDocument xmlDoc = new XmlDocument();

        xmlDoc.LoadXml(log);

        string status = xmlDoc.SelectSingleNode("./ReturnValue/Status").InnerText;

        if (status == "1")
        {
            string taskId  = xmlDoc.SelectSingleNode("./ReturnValue/TaskId").InnerText;
             string formNbr  = xmlDoc.SelectSingleNode("./ReturnValue/FormNumber").InnerText;
             db.UpdateFormStatus(externalTaskId, tableName, status, taskId, formNbr, "");
        }
        else
        {
            db.UpdateFormStatus(externalTaskId,tableName, status, "", "", log);
        }



        //<?xml version="1.0" encoding="utf-8"?>
        //<ReturnValue>
        //  <Status>0</Status>
        //  <Exception>
        //    <Type>VersionIdNoMatchException</Type>
        //    <Message>
        //    </Message>
        //  </Exception>
        //</ReturnValue>

        //<?xml version="1.0" encoding="utf-8"?>
        //<ReturnValue>
        //  <Status>1</Status>
        //  <FormNumber>WKF170500001</FormNumber>
        //  <TaskId>f8b126f2-c52c-438f-8c61-080695db4eb0</TaskId>
        //</ReturnValue>
    }

    private string GetFormXML(DataRow applyFormDr, DataRow externalFormsDr)
    {
        FieldUtility fieldUtil = new FieldUtility();
        FormUtitlity formUtility = new FormUtitlity();
        XmlDocument xmlDoc = new XmlDocument();
        XmlDocument versionFieldsXml = new XmlDocument();
        fieldUtil.XmlDoc = xmlDoc;
        formUtility.XmlDoc = xmlDoc;


        string versionFields = db.QueryVersionFields(externalFormsDr["FORM_VERSION_ID"].ToString());
        versionFieldsXml.LoadXml(versionFields);
        //建立表頭資訊
        //注意 applyFormDr["URGENT_LEVEL"].ToString() --> 一定要0 1 2 之後檢查
        XmlElement formElement = formUtility.GetFormInfoXmlCode(externalFormsDr["FORM_VERSION_ID"].ToString(), applyFormDr["URGENT_LEVEL"].ToString());

        //建立申請資訊
        // 有缺部門ID轉換   職級要換成中文
        // 有缺意見欄位
        XmlElement applicantElement = formUtility.GetApplicantXmlCode(applyFormDr["APPLICANT"].ToString(), "", "", "", applyFormDr["ATTACH_PATH"].ToString());
        //建立欄位資訊
        XmlElement formFieldValueElement = xmlDoc.CreateElement("FormFieldValue");


        foreach (DataColumn dc in applyFormDr.Table.Columns)
        {
            //預設欄位要跳過
            switch (dc.ColumnName)
            {
                case "EXTERNAL_TASK_ID":
                case "URGENT_LEVEL":
                case "APPLICANT":
                case "GROUP_PATH":
                case "JOB_TITLE_ID":
                case "EXCEPTION_MSG":
                case "ATTACH_PATH":
                case "FORM_NUMBER":
                case "TASK_ID":
                case "STATUS":
                case "FORM_RESULT":
                case "CREATE_TIME":
                case "MODIFY_TIME":
                    continue;
            }


            string fieldType = versionFieldsXml.SelectSingleNode(string.Format("./VersionField/FieldItem[@fieldId='{0}']", dc.ColumnName)).Attributes["fieldType"].Value;

            XmlElement fieldElement = null;

            switch (fieldType)
            {
                case "autoNumber":
                    //表單編號欄位
                    fieldElement = fieldUtil.GetAutoNumberField(dc.ColumnName, applyFormDr[dc.ColumnName].ToString());
                    break;
                case "optionalField":
                    //外掛欄位   {"FieldValue":"" ,"ConditionValue":"" , "RealValue" : "" }
                    fieldElement = fieldUtil.GetOptionalFieldXml(dc.ColumnName, applyFormDr[dc.ColumnName].ToString(), applyFormDr["APPLICANT"].ToString());
                    break;
                case "dataGrid":
                    //明細欄位 - 因為匯出的表頭沒有所以要另外處理
                    break;

                case "fileButton":
                    //檔案欄位
                    fieldElement = fieldUtil.GetFileFieldElement(dc.ColumnName, applyFormDr[dc.ColumnName].ToString(), applyFormDr["APPLICANT"].ToString());
                    break;
                case "checkBox":
                    //核選方塊  選項A@B
                    fieldElement = fieldUtil.GetCommonField(dc.ColumnName, applyFormDr[dc.ColumnName].ToString(), "", applyFormDr["APPLICANT"].ToString());
                    break;

                case "dropDownList":
                    //下拉選單  選項A
                    fieldElement = fieldUtil.GetDropDownListField(dc.ColumnName, applyFormDr[dc.ColumnName].ToString(), "", applyFormDr["APPLICANT"].ToString());
                    break;
                case "htmlEditor":
                    //文字編輯
                    fieldElement = fieldUtil.GetCommonField(dc.ColumnName, applyFormDr[dc.ColumnName].ToString(), "", applyFormDr["APPLICANT"].ToString());
                    break;
                case "hyperLink":
                    //超連結   連結文字@連結目標
                    fieldElement = fieldUtil.GetCommonField(dc.ColumnName, applyFormDr[dc.ColumnName].ToString(), "", applyFormDr["APPLICANT"].ToString());
                    break;
                case "allUser":
                    //所有人員 {"UserSetItems" : [ {"Type":"" , "isDepth":"" , "Value":"" , "Value2":"" }]}
                    fieldElement = fieldUtil.GetAllUserField(dc.ColumnName, applyFormDr[dc.ColumnName].ToString(), "", applyFormDr["APPLICANT"].ToString());
                    break;
                case "allDept":
                    //所有部門 {"UserSetItems" : [ {"Type":"" , "isDepth":"" , "Value":"" , "Value2":"" }]}
                    fieldElement = fieldUtil.GetAllDeptField(dc.ColumnName, applyFormDr[dc.ColumnName].ToString(), "", applyFormDr["APPLICANT"].ToString());
                    break;
                case "allFunction":
                    //所有職務 {"UserSetItems" : [ {"Type":"" , "isDepth":"" , "Value":"" , "Value2":"" }]}
                    fieldElement = fieldUtil.GetAllFuncField(dc.ColumnName, applyFormDr[dc.ColumnName].ToString(), "", applyFormDr["APPLICANT"].ToString());
                    break;
                case "allRank":
                    //所有職級 {"UserSetItems" : [ {"Type":"" , "isDepth":"" , "Value":"" , "Value2":"" }]}
                    fieldElement = fieldUtil.GetAllTitleField(dc.ColumnName, applyFormDr[dc.ColumnName].ToString(), "", applyFormDr["APPLICANT"].ToString());
                    break;
                case "userProposer":
                    //申請者 ->ACCOUNT
                    fieldElement = fieldUtil.GetUserProposerField(dc.ColumnName, applyFormDr[dc.ColumnName].ToString(), "", applyFormDr["APPLICANT"].ToString());
                    break;
                case "userDept":
                    //申請者部門 ->DeptPath
                    fieldElement = fieldUtil.GetUserDeptField(dc.ColumnName, applyFormDr[dc.ColumnName].ToString(), "", applyFormDr["APPLICANT"].ToString());
                    break;
                case "userRank":
                    //申請者職級 
                    fieldElement = fieldUtil.GetUserRankField(dc.ColumnName, applyFormDr[dc.ColumnName].ToString(), "", applyFormDr["APPLICANT"].ToString());
                    break;
                case "userSetField":
                    //人員組織 {"UserSetItems" : [ {"Type":"" , "isDepth":"" , "Value":"" , "Value2":"" }]}
                    fieldElement = fieldUtil.GetUserSetField(dc.ColumnName, applyFormDr[dc.ColumnName].ToString(), "", applyFormDr["APPLICANT"].ToString());
                    break;
                case "allMember":
                    //所有會員 {"UserSetItems" : [ {"Type":"" , "isDepth":"" , "Value":"" , "Value2":"" }]}
                    fieldElement = fieldUtil.GetAllMemberField(dc.ColumnName, applyFormDr[dc.ColumnName].ToString(), "", applyFormDr["APPLICANT"].ToString());
                    break;
                case "userAgent":
                    //代理人 ACCOUNT
                    fieldElement = fieldUtil.GetUserAgentField(dc.ColumnName, applyFormDr[dc.ColumnName].ToString(), "", applyFormDr["APPLICANT"].ToString());
                    break;

                default:
                    //一般欄位 - 所見即所得
                    fieldElement = fieldUtil.GetCommonField(dc.ColumnName, applyFormDr[dc.ColumnName].ToString(), "", applyFormDr["APPLICANT"].ToString());
                    break;
            }

            if (fieldElement == null) continue;

            formFieldValueElement.AppendChild(fieldElement);
     
        }

        //明細欄位處理
        if (!string.IsNullOrEmpty(externalFormsDr["EXTERNAL_GRID_TABLES_NAME"].ToString()))
        {
            DataGridFields fields = (DataGridFields)JsonConvert.DeserializeObject(externalFormsDr["EXTERNAL_GRID_TABLES_NAME"].ToString(), typeof(DataGridFields));

            //找出所有明細欄位的TABLE
            foreach (DataGridList item in fields.DataGridList)
            {
                XmlElement fieldElement = fieldUtil.GetDataGridField(item.FieldId, item.TableName, applyFormDr["EXTERNAL_TASK_ID"].ToString(), versionFields, applyFormDr["APPLICANT"].ToString());

                formFieldValueElement.AppendChild(fieldElement);
            }

           
            
        }


        formElement.AppendChild(applicantElement);
        formElement.AppendChild(formFieldValueElement);
        return formElement.OuterXml;
    }
    protected void Button2_Click(object sender, EventArgs e)
    {
        UserSetPlus useSetPlus = new UserSetPlus();
        UserSetItem item = new UserSetItem();
        item.Type = "user";
        item.Value = "HR";
        useSetPlus.UserSetItems.Add(item);
        TextBox2.Text = JsonConvert.SerializeObject(useSetPlus);
    }
}



public class UserSetPlus
{

    public UserSetPlus()
    {
        UserSetItems = new List<UserSetItem>();
    }

    public List<UserSetItem> UserSetItems { get; set; } 

    public UserSet ConverToUserSet()
    {
        UserSet userUset = new UserSet();
        OrganizationPlus orgP = new OrganizationPlus();
        foreach (UserSetItem item in UserSetItems)
        {
            switch (item.Type)
            { 
                case "user":
                    UserSetUser user = new UserSetUser();
                    user.USER_GUID = orgP.GetUserGuid(item.Value);
                    userUset.Items.Add(user);
                    break;
                case "group":
                    UserSetGroup userSetGroup = new UserSetGroup();
                    userSetGroup.GROUP_ID = orgP.getDeptGuid(item.Value);
                    userSetGroup.IS_DEPTH = item.isDepth;
                    userUset.Items.Add(userSetGroup);
                    break;
                case "jobTitle":
                    UserSetTitle userSetTitle = new UserSetTitle();
                    userSetTitle.TITLE_ID = orgP.GetTitleGuid(item.Value);
                    userUset.Items.Add(userSetTitle);
                    break;
            
                case "jobFunction":
                    UserSetFunction userSetFunc = new UserSetFunction();
                    userSetFunc.FUNC_ID = orgP.GetFuncGuid(item.Value);
                    userUset.Items.Add(userSetFunc);
                   break;
                case "jobTitleOfGroup":
                   UserSetTitleOfGroup userSetTitleOfGroup = new UserSetTitleOfGroup();
                   userSetTitleOfGroup.TITLE_ID = orgP.GetTitleGuid(item.Value);
                   userSetTitleOfGroup.GROUP_ID = orgP.getDeptGuid(item.Value2);
                   userSetTitleOfGroup.IS_DEPTH = item.isDepth;
                   userUset.Items.Add(userSetTitleOfGroup);
                   break;

                case "jobFunctionOfGroup":
                   UserSetFunctionOfGroup userSetFuncOfGroup = new UserSetFunctionOfGroup();
                   userSetFuncOfGroup.FUNC_ID = orgP.GetFuncGuid(item.Value);
                   userSetFuncOfGroup.GROUP_ID = orgP.getDeptGuid(item.Value2);
                   userSetFuncOfGroup.IS_DEPTH = item.isDepth;
                   userUset.Items.Add(userSetFuncOfGroup);
                   break;

            
            
            }
        }


      
        return userUset;
    }


    public string GetFieldValue()
    {
        string returnValue = String.Empty;
        List<String> userList = new List<string>();

        UserSet userSet = ConverToUserSet();
        #region ================= 群組 =================
        foreach (UserSetGroup userSetGroup in userSet.Items.GetGroupArray())
        {
            userList.Add(userSetGroup.GetGroupName());
        }
        #endregion

        #region ================= 人員 =================
        foreach (UserSetUser userSetUser in userSet.Items.GetUserAaary())
        {
            userList.Add(userSetUser.GetName());
        }
        #endregion

        #region ================= 職稱 =================
        foreach (UserSetTitle userSetTitle in userSet.Items.GetTitleArray())
        {
            userList.Add(userSetTitle.GetTitleName());
        }
        #endregion

        #region ================= 職務 =================
        foreach (UserSetFunction userSetFunction in userSet.Items.GetFunctionArray())
        {
            userList.Add(userSetFunction.GetFunctionName());
        }
        #endregion

        #region ================= 部門+職級 =================
        foreach (UserSetTitleOfGroup userSetTitleOfGroup in userSet.Items.GetTitleOfGroupArray())
        {
            userList.Add(userSetTitleOfGroup.GetGroupName() +"-" +userSetTitleOfGroup.GetTitleName() );
        }
        #endregion

        #region ================= 部門+職務 =================
        foreach (UserSetFunctionOfGroup userSetFunctionOfGroup in userSet.Items.GetFunctionOfGroupArray())
        {
            userList.Add(userSetFunctionOfGroup.GetGroupName() + "-" + userSetFunctionOfGroup.GetFunctionName());
        }
        #endregion


        foreach (string str in userList)
        {
            returnValue += str + "、";
        }

        if (returnValue != String.Empty)
        {
            returnValue = returnValue.Substring(0, returnValue.LastIndexOf("、"));
        }

        return returnValue;
    }
}

public class UserSetItem
{
    public string Type { get; set; }
    public bool isDepth { get; set; }
    public string Value { get; set; }
    public string Value2 { get; set; }
}


public class OrganizationPlus
{
    /// <summary>
    /// 取得人員GUID
    /// </summary>
    /// <param name="account"></param>
    /// <returns></returns>
    public string GetUserGuid(string account)
    {
        UserUCO userUCO = new UserUCO();
        string userGuid = userUCO.GetGUID(account);

        if (string.IsNullOrEmpty(userGuid))
        { 
            //再丟例外
        }

        return userGuid;
    }

    /// <summary>
    /// 取得職務GUID
    /// </summary>
    /// <param name="account"></param>
    /// <returns></returns>
    public string GetFuncGuid(string funcName)
    {
        Ede.Uof.EIP.Organization.FunctionUCO uco = new Ede.Uof.EIP.Organization.FunctionUCO();

        string funcId = uco.GetFunctionID(funcName);

        if (string.IsNullOrEmpty(funcId))
        { 
            //丟例外
        }

        return funcId;

    }

    /// <summary>
    /// 取得職級GUID
    /// </summary>
    /// <param name="account"></param>
    /// <returns></returns>
    public string GetTitleGuid(string titleName)
    {
        Ede.Uof.EIP.Organization.TitleUCO uco = new Ede.Uof.EIP.Organization.TitleUCO();

        string titleId = uco.GetTitleID(titleName);

        if (string.IsNullOrEmpty(titleId))
        {
            //丟例外
        }

        return titleId;

    }

    /// <summary>
    /// 取得部門Guid
    /// </summary>
    /// <param name="deptName"></param>
    /// <returns></returns>
    public string getDeptGuid(string deptPath)
    {
        //如果是空的部門的話就給個GUID
        if (string.IsNullOrEmpty(deptPath))
        {
            //丟例外
        }

        string[] deptNames = deptPath.Split('/');
        GroupUCO groupData = new GroupUCO(GroupType.Department);
        string groupId = null;
        string parentGroupID = "Company";

        string tmp = groupData.GetRootGroupID(deptNames[1].Trim());
        if (tmp != parentGroupID) //取得第0階的GroupID,如果不等於 "Company" 則抛出例外
        {
            //丟例外
            return "";
        }
        else if (deptNames.Length == 2)
        {
            return tmp;
        }

        for (int i = 2; i < deptNames.Length; i++)
        {
            if (string.IsNullOrEmpty(deptNames[i]))
                continue;

            string name = deptNames[i];
            groupId = groupData.GetGroupID(name.Trim(), parentGroupID);

            parentGroupID = groupId;
        }
        return groupId;
    }

}

public class OptionFieldObj
{
    public string FieldValue { get; set; }
    public string ConditionValue { get; set; }
    public string RealValue { get; set; }
}


public class FormUtitlity
{
    public XmlDocument XmlDoc { get; set; }

    public XmlElement GetFormInfoXmlCode(string formversionId, string urgentLevel)
    {



        //urgentLevel 緊急程度0:緊急 1:急 2:普通

        XmlElement formElement = XmlDoc.CreateElement("Form");
        formElement.SetAttribute("formVersionId", formversionId);
        formElement.SetAttribute("urgentLevel", urgentLevel);


        return formElement;

    }

    public XmlElement GetApplicantXmlCode(string applicant, string groupId, string titleId, string common, string filePath)
    {


        XmlElement applicantElement = XmlDoc.CreateElement("Applicant");

        //<!--account:申請者UOF帳號 groupId部門代號(可不填) jobTitleId:職稱代號(可不填)-->
        applicantElement.SetAttribute("account", applicant);
        applicantElement.SetAttribute("groupId", groupId);
        applicantElement.SetAttribute("jobTitleId", titleId);

        //申請者意見
        XmlElement commentElement = XmlDoc.CreateElement("Comment");
        commentElement.InnerText = common;

        applicantElement.AppendChild(commentElement);

        if (filePath != "")
        {

            XmlElement appachElement = XmlDoc.CreateElement("Attach");
            appachElement.SetAttribute("IsNeedTransfer", "true");
            appachElement.SetAttribute("IsDeleteTemp", "true");

            //如果多個附件請加入多個AttachItem
            XmlElement attachItemElement = XmlDoc.CreateElement("AttachItem");
            //放置檔案路徑(appSettings/wkfFileTransferTemp)
            attachItemElement.SetAttribute("filePath", filePath);

            appachElement.AppendChild(attachItemElement);
            applicantElement.AppendChild(appachElement);

        }


        return applicantElement;



    }



    internal string GetFormFieldValueXmlCode()
    {

        return @"

            XmlElement formFieldValueElement = xmlDoc.CreateElement(""FormFieldValue""); 
            formElement.AppendChild(formFieldValueElement);

            ";


    }

    internal string GetDLLInitCode()
    {
        return @"

            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.LoadXml(applyTask.CurrentDocXML);

            ";
    }

    internal string GetFieldDLLCode(XmlNode versionField)
    {
        return string.Format(@"
            //{1}
            dr.{0} = xmlDoc.SelectSingleNode(""/Form/FormFieldValue/FieldItem[@fieldId='{0}']"").Attributes[""fieldValue""].Value;
", versionField.Attributes["fieldId"].Value, versionField.Attributes["fieldName"].Value);
    }
}

public class FieldUtility
{

    public XmlDocument XmlDoc { get; set; }

    string commonFieldXmlStr = "";

    public bool IsDataGrid { get; set; }

    public FieldUtility()
    {
        IsDataGrid = false;
    }

    /// <summary>
    /// 所見即所得的通用欄位
    /// </summary>
    /// <param name="fieldId"></param>
    /// <param name="fieldValue"></param>
    /// <param name="realValue"></param>
    /// <param name="applicant"></param>
    /// <returns></returns>
    public XmlElement GetCommonField(string fieldId, string fieldValue, string realValue, string applicant )
    {
        //通用欄位的XML物件


        string userName = "";
        string userGuid = "";
        string account = "";

        //有值要放填寫者資訊
        if (fieldValue != "")
        {
            UserUCO userUCO = new UserUCO();
            userGuid = userUCO.GetGUID(applicant);
            EBUser ebUser = userUCO.GetEBUser(userGuid);
            account = applicant;
            userName = ebUser.Name;
        }
            return GetFieldElement(fieldId,fieldValue,realValue, userName, userGuid,account);
    }


    /// <summary>
    /// 表單編號欄位
    /// </summary>
    /// <param name="fieldId"></param>
    /// <param name="formNumber"></param>
    /// <returns></returns>
    internal XmlElement GetAutoNumberField(string fieldId, string formNumber)
    {

        //表單編號節點
        //如果要用UOF系統的表單流水號
        //isNeedAutoNbr 給 false，fieldValue 保持空白
        //如果要用UOF系統的表單流水號
        //isNeedAutoNbr 給 true，fieldValue 給對應的表單編號
        XmlElement autoNumberElement = XmlDoc.CreateElement("FieldItem");
        autoNumberElement.SetAttribute("fieldId", fieldId);
        autoNumberElement.SetAttribute("fieldValue", formNumber);
        autoNumberElement.SetAttribute("realValue", "");

        if (formNumber != "")
        {
            autoNumberElement.SetAttribute("isNeedAutoNbr", "true");
        }
        else
        {
            autoNumberElement.SetAttribute("isNeedAutoNbr", "false");
        }

        return autoNumberElement;


    }


    /// <summary>
    /// 檔案欄位
    /// </summary>
    /// <param name="fieldId"></param>
    /// <param name="filePath"></param>
    /// <param name="applicant"></param>
    /// <returns></returns>
    internal XmlElement GetFileFieldElement(string fieldId, string filePath, string applicant)
    {
        string userName = "";
        string userGuid = "";
        string account = applicant;

        //有值要放填寫者資訊
        if (filePath != "")
        {
            UserUCO userUCO = new UserUCO();
            userGuid = userUCO.GetGUID(applicant);
            EBUser ebUser = userUCO.GetEBUser(userGuid);

            userName = ebUser.Name;
        }

        XmlElement fileElement = XmlDoc.CreateElement("FieldItem");
        fileElement.SetAttribute("fieldId", "{0}");
        fileElement.SetAttribute("IsNeedTransfer", "true");
        fileElement.SetAttribute("IsDeleteTemp", "true");
        fileElement.SetAttribute("realValue", "");
        fileElement.SetAttribute("fieldValue", "");
        fileElement.SetAttribute("fillerName", userName);
        fileElement.SetAttribute("fillerUserGuid", userGuid);
        fileElement.SetAttribute("fillerAccount", account);
        fileElement.SetAttribute("fillSiteId", "");

        //如果多個附件請加入多個AttachItem，如果沒附件可不加入
        XmlElement attachItemElement = XmlDoc.CreateElement("AttachItem");

        attachItemElement.SetAttribute("filePath", filePath);
        fileElement.AppendChild(attachItemElement);

        return fileElement;

    }

    /// <summary>
    /// 外掛欄位
    /// </summary>
    /// <param name="fieldId"></param>
    /// <param name="optionData"></param>
    /// <param name="applicant"></param>
    /// <returns></returns>
    internal XmlElement GetOptionalFieldXml(string fieldId, string optionData, string applicant)
    {

        OptionFieldObj obj = null;


        
        if (optionData != "")
        {
            obj = (OptionFieldObj)JsonConvert.DeserializeObject(optionData);
        }
        else
        {
            obj = new OptionFieldObj();
        }
        string userName = "";
        string userGuid = "";
        string account = applicant;

        XmlElement OptionalElement = XmlDoc.CreateElement("FieldItem");
        //有值要放填寫者資訊
        if (optionData != "")
        {
            UserUCO userUCO = new UserUCO();
            userGuid = userUCO.GetGUID(account);
            EBUser ebUser = userUCO.GetEBUser(userGuid);

            userName = ebUser.Name;

            OptionalElement.SetAttribute("fieldId", fieldId);
            OptionalElement.InnerXml = obj.FieldValue;
            OptionalElement.SetAttribute("realValue", "");
            OptionalElement.SetAttribute("fillerName", userName);
            OptionalElement.SetAttribute("fillerUserGuid", userGuid);
            OptionalElement.SetAttribute("fillerAccount", account);
            OptionalElement.SetAttribute("fillSiteId", "");
            OptionalElement.SetAttribute("ConditionValue", obj.ConditionValue);
            OptionalElement.SetAttribute("realValue", obj.RealValue);
        }
        else
        {
            OptionalElement.SetAttribute("fieldId", fieldId);
            OptionalElement.InnerXml = "";
            OptionalElement.SetAttribute("realValue", "");
            OptionalElement.SetAttribute("fillerName", userName);
            OptionalElement.SetAttribute("fillerUserGuid", userGuid);
            OptionalElement.SetAttribute("fillerAccount", account);
            OptionalElement.SetAttribute("fillSiteId", "");
            OptionalElement.SetAttribute("ConditionValue", "");
            OptionalElement.SetAttribute("realValue", "");
        }





        return OptionalElement;

    }


    /// <summary>
    /// 通用欄位 -> 特殊的欄位都用這METHOD 
    /// </summary>
    /// <param name="fieldId"></param>
    /// <param name="fieldValue"></param>
    /// <param name="realValue"></param>
    /// <param name="userName"></param>
    /// <param name="userGuid"></param>
    /// <param name="account"></param>
    /// <returns></returns>
    private XmlElement GetFieldElement(string fieldId, string fieldValue, string realValue, string userName, string userGuid, string account)
    {
        XmlElement fieldElement = null;

        if (IsDataGrid)
        {
            fieldElement= XmlDoc.CreateElement("Cell");
        }
        else
        {
            fieldElement = XmlDoc.CreateElement("FieldItem");
        }
        fieldElement.SetAttribute("fieldId", fieldId);
        fieldElement.SetAttribute("fieldValue", fieldValue);
        fieldElement.SetAttribute("realValue", realValue);
        fieldElement.SetAttribute("fillerName", userName);
        fieldElement.SetAttribute("fillerUserGuid", userGuid);
        fieldElement.SetAttribute("fillerAccount", account);
        fieldElement.SetAttribute("fillSiteId", "");
        return fieldElement;
    }

        /// <summary>
    /// 通用欄位 -> 特殊的欄位都用這METHOD  (明細子欄位專用
    /// </summary>
    /// <param name="fieldId"></param>
    /// <param name="fieldValue"></param>
    /// <param name="realValue"></param>
    /// <param name="userName"></param>
    /// <param name="userGuid"></param>
    /// <param name="account"></param>
    /// <returns></returns>
    private XmlElement GetCellElement(string fieldId, string fieldValue, string realValue)
    {
        XmlElement cellElement = XmlDoc.CreateElement("Cell");
        cellElement.SetAttribute("fieldId", fieldId);
        cellElement.SetAttribute("fieldValue", fieldValue);
        cellElement.SetAttribute("realValue", realValue);
        return cellElement;
    }

    /// <summary>
    /// 下拉選單
    /// </summary>
    /// <param name="fieldId"></param>
    /// <param name="fieldValue"></param>
    /// <param name="realValue"></param>
    /// <param name="applicant"></param>
    /// <returns></returns>
    internal XmlElement GetDropDownListField(string fieldId, string fieldValue, string realValue, string applicant)
    {
        string userName = "";
        string userGuid = "";
        string account = "";

        //有值要放填寫者資訊
        if (fieldValue != "")
        {
            UserUCO userUCO = new UserUCO();
            userGuid = userUCO.GetGUID(applicant);
            EBUser ebUser = userUCO.GetEBUser(userGuid);
            account = applicant;
            userName = ebUser.Name;
        }

        //下拉選單欄位值特性為 選項A@選項A
        return GetFieldElement(fieldId, fieldValue + "@" + fieldValue, realValue, userName, userGuid, account);

        
    }

    /// <summary>
    /// 所有人員欄位
    /// </summary>
    /// <param name="fieldId"></param>
    /// <param name="fieldValue"></param>
    /// <param name="realValue"></param>
    /// <param name="applicant"></param>
    /// <returns></returns>
    internal XmlElement GetAllUserField(string fieldId, string fieldValue, string realValue, string applicant)
    {
        
        //所有人員欄位特性為 姓名(帳號)、姓名(帳號)  還有RealValue的UserSet
        return GetOrgField(fieldId, fieldValue, realValue, applicant);
    }

    internal XmlElement GetAllDeptField(string fieldId, string fieldValue, string realValue, string applicant)
    {

        //所有部門欄位特性為 部門、部門  還有RealValue的UserSet
        return GetOrgField(fieldId, fieldValue, realValue, applicant);
    }

    internal XmlElement GetAllFuncField(string fieldId, string fieldValue, string realValue, string applicant)
    {
        //所有部門欄位特性為 職務、職務  還有RealValue的UserSet
        return GetOrgField(fieldId, fieldValue, realValue, applicant);
    }

    internal XmlElement GetAllTitleField(string fieldId, string fieldValue, string realValue, string applicant)
    {
   

        //所有職級欄位特性為 職級、職級  還有RealValue的UserSet
        return GetOrgField(fieldId, fieldValue, realValue, applicant);
    }

    internal XmlElement GetUserProposerField(string fieldId, string fieldValue, string realValue, string applicant)
    {
        string userName = "";
        string userGuid = "";
        string account = "";

        //有值要放填寫者資訊
        if (fieldValue != "")
        {
            UserUCO userUCO = new UserUCO();
            userGuid = userUCO.GetGUID(applicant);
            EBUser ebUser = userUCO.GetEBUser(userGuid);
            account = applicant;
            userName = ebUser.Name;
        }
        else
        {
            return GetFieldElement(fieldId, "", "", userName, userGuid, account);
        }


        OrganizationPlus orgP = new OrganizationPlus();
        userGuid = orgP.GetUserGuid(fieldValue);
        UserSet userSet = new UserSet();
        UserSetUser userSetUser = new UserSetUser();
        userSetUser.USER_GUID = userGuid;
        userSet.Items.Add(userSetUser);

        //申請者欄位特性 fieldValue -< 姓名(帳號 realValue -<USERSET
        return GetFieldElement(fieldId, userSetUser.GetName(), userSet.GetXML(), userName, userGuid, account);
    }

    internal XmlElement GetUserDeptField(string fieldId, string fieldValue, string realValue, string applicant)
    {
        string userName = "";
        string userGuid = "";
        string account = "";

        //有值要放填寫者資訊
        if (fieldValue != "")
        {
            UserUCO userUCO = new UserUCO();
            userGuid = userUCO.GetGUID(applicant);
            EBUser ebUser = userUCO.GetEBUser(userGuid);
            account = applicant;
            userName = ebUser.Name;
        }
        else
        {
            return GetFieldElement(fieldId, "", "", userName, userGuid, account);
        }


        OrganizationPlus orgP = new OrganizationPlus();
        string groupId = orgP.getDeptGuid(fieldValue);
        UserSet userSet = new UserSet();
        UserSetGroup userSetGroup= new UserSetGroup();
        userSetGroup.GROUP_ID = groupId;
        //userSet.Items.Add(userSetUser);

        //申請者部門特性 fieldValue -< 部門名稱  realValue -< 部門ID,部門名稱,False
        return GetFieldElement(fieldId, userSetGroup.GetGroupName(), 
            string.Format("{0},{1},False", groupId, userSetGroup.GetGroupName())
            ,userName, userGuid, account);
    }

    internal XmlElement GetUserRankField(string fieldId, string fieldValue, string realValue, string applicant)
    {
        string userName = "";
        string userGuid = "";
        string account = "";

        //有值要放填寫者資訊
        if (fieldValue != "")
        {
            UserUCO userUCO = new UserUCO();
            userGuid = userUCO.GetGUID(applicant);
            EBUser ebUser = userUCO.GetEBUser(userGuid);
            account = applicant;
            userName = ebUser.Name;
        }
        else
        {
            return GetFieldElement(fieldId, "", "", userName, userGuid, account);
        }


 

        //申請者職級欄位特性 fieldValue -< 職級 realValue -<空白
        return GetFieldElement(fieldId, fieldValue, "", userName, userGuid, account);
    }

    internal XmlElement GetUserSetField(string fieldId, string fieldValue, string realValue, string applicant)
    {


        //所有職級欄位特性為 職級、職級  還有RealValue的UserSet
        return GetOrgField(fieldId, fieldValue, realValue, applicant);
    }

    internal XmlElement GetAllMemberField(string fieldId, string fieldValue, string realValue, string applicant)
    {
        return GetOrgField(fieldId, fieldValue, realValue, applicant);
    }

    internal XmlElement GetOrgField(string fieldId, string fieldValue, string realValue, string applicant)
    {
        string userName = "";
        string userGuid = "";
        string account = "";

        //有值要放填寫者資訊
        if (fieldValue != "")
        {
            UserUCO userUCO = new UserUCO();
            userGuid = userUCO.GetGUID(applicant);
            EBUser ebUser = userUCO.GetEBUser(userGuid);
            account = applicant;
            userName = ebUser.Name;
        }
        else
        {
            return GetFieldElement(fieldId, "", "", userName, userGuid, account);
        }


        OrganizationPlus orgP = new OrganizationPlus();
        UserSetPlus userSetP = (UserSetPlus)JsonConvert.DeserializeObject(fieldValue, typeof(UserSetPlus));
        UserSet userSet = userSetP.ConverToUserSet();

  
        return GetFieldElement(fieldId, userSetP.GetFieldValue(), userSet.GetXML(), userName, userGuid, account);
    }

    internal XmlElement GetUserAgentField(string fieldId, string fieldValue, string realValue, string applicant)
    {
        string userName = "";
        string userGuid = "";
        string account = "";

        //有值要放填寫者資訊
        if (fieldValue != "")
        {
            UserUCO userUCO = new UserUCO();
            userGuid = userUCO.GetGUID(applicant);
            EBUser ebUser = userUCO.GetEBUser(userGuid);
            account = applicant;
            userName = ebUser.Name;
        }
        else
        {
            return GetFieldElement(fieldId, "", "", userName, userGuid, account);
        }


        OrganizationPlus orgP = new OrganizationPlus();
        userGuid = orgP.GetUserGuid(fieldValue);
        UserSet userSet = new UserSet();
        UserSetUser userSetUser = new UserSetUser();
        userSetUser.USER_GUID = userGuid;
        userSet.Items.Add(userSetUser);

        //代理人欄位特性 fieldValue -< USER_GUID@USER_NAME realValue -<USERSET
        return GetFieldElement(fieldId, userGuid +"@"+userSetUser.GetName(), userSet.GetXML(), userName, userGuid, account);
    }

    /// <summary>
    /// 明細欄位
    /// </summary>
    /// <param name="fieldId"></param>
    /// <param name="externalTaskId"></param>
    /// <param name="applicant"></param>
    /// <returns></returns>
    internal XmlElement GetDataGridField(string fieldId, string tableName, string externalTaskId, string versionFields, string applicant)
    {
        IsDataGrid = true;
        XmlDocument versionFieldsXml = new XmlDocument();
        versionFieldsXml.LoadXml(versionFields);

        XmlElement fieldElement = XmlDoc.CreateElement("FieldItem");
        fieldElement.SetAttribute("fieldId", fieldId);

        DB db = new DB();
        DataTable dt = db.QueryDataGridFieldData(tableName, externalTaskId);
        string userName = "";
        string userGuid = "";
        string account = "";
        if (dt.Rows.Count > 0)
        {

            UserUCO userUCO = new UserUCO();
            userGuid = userUCO.GetGUID(applicant);
            EBUser ebUser = userUCO.GetEBUser(userGuid);
            account = applicant;
            userName = ebUser.Name;

            XmlElement dataGridElement = XmlDoc.CreateElement("DataGrid");
            int seq = 0;
            foreach (DataRow dr in dt.Rows)
            {

                XmlElement rowElement = XmlDoc.CreateElement("Row");
                rowElement.SetAttribute("order", seq.ToString());


                foreach (DataColumn dc in dr.Table.Columns)
                {
                    //預設欄位要跳過
                    switch (dc.ColumnName)
                    {
                        case "EXTERNAL_TASK_ID":
                        case "GRID_SEQ":
                            continue;
                    }


                    string fieldType = versionFieldsXml.SelectSingleNode(string.Format("./VersionField/FieldItem[@fieldId='{0}']/dataGrid/DataGridItem[@fieldId='{1}']", fieldId, dc.ColumnName)).Attributes["fieldType"].Value;

                    XmlElement cellElement = null;

                    switch (fieldType)
                    {

                        case "checkBox":
                            //核選方塊  選項A@B
                            cellElement = GetCommonField(dc.ColumnName, dr[dc.ColumnName].ToString(), "", applicant);
                            break;

                        case "dropDownList":
                            //下拉選單  選項A
                            cellElement = GetDropDownListField(dc.ColumnName, dr[dc.ColumnName].ToString(), "", applicant);
                            break;

                        case "hyperLink":
                            //超連結   連結文字@連結目標
                            cellElement = GetCommonField(dc.ColumnName, dr[dc.ColumnName].ToString(), "", applicant);
                            break;
                        case "allUser":
                            //所有人員 {"UserSetItems" : [ {"Type":"" , "isDepth":"" , "Value":"" , "Value2":"" }]}
                            cellElement = GetAllUserField(dc.ColumnName, dr[dc.ColumnName].ToString(), "", applicant);
                            break;
                        case "allDept":
                            //所有部門 {"UserSetItems" : [ {"Type":"" , "isDepth":"" , "Value":"" , "Value2":"" }]}
                            cellElement = GetAllDeptField(dc.ColumnName, dr[dc.ColumnName].ToString(), "", applicant);
                            break;
                        case "allFunction":
                            //所有職務 {"UserSetItems" : [ {"Type":"" , "isDepth":"" , "Value":"" , "Value2":"" }]}
                            cellElement = GetAllFuncField(dc.ColumnName, dr[dc.ColumnName].ToString(), "", applicant);
                            break;
                        case "allRank":
                            //所有職級 {"UserSetItems" : [ {"Type":"" , "isDepth":"" , "Value":"" , "Value2":"" }]}
                            cellElement = GetAllTitleField(dc.ColumnName, dr[dc.ColumnName].ToString(), "", applicant);
                            break;
                        case "userProposer":
                            //申請者 ->ACCOUNT
                            cellElement = GetUserProposerField(dc.ColumnName, dr[dc.ColumnName].ToString(), "", applicant);
                            break;
                        case "userDept":
                            //申請者部門 ->DeptPath
                            cellElement = GetUserDeptField(dc.ColumnName, dr[dc.ColumnName].ToString(), "", applicant);
                            break;
                        case "userRank":
                            //申請者職級 
                            cellElement = GetUserRankField(dc.ColumnName, dr[dc.ColumnName].ToString(), "", applicant);
                            break;
                        case "userSetField":
                            //人員組織 {"UserSetItems" : [ {"Type":"" , "isDepth":"" , "Value":"" , "Value2":"" }]}
                            cellElement = GetUserSetField(dc.ColumnName, dr[dc.ColumnName].ToString(), "", applicant);
                            break;
                        case "allMember":
                            //所有會員 {"UserSetItems" : [ {"Type":"" , "isDepth":"" , "Value":"" , "Value2":"" }]}
                            cellElement = GetAllMemberField(dc.ColumnName, dr[dc.ColumnName].ToString(), "", applicant);
                            break;
                        case "userAgent":
                            //代理人 ACCOUNT
                            cellElement = GetUserAgentField(dc.ColumnName, dr[dc.ColumnName].ToString(), "", applicant);
                            break;

                        default:
                            //一般欄位 - 所見即所得
                            cellElement = GetCommonField(dc.ColumnName, dr[dc.ColumnName].ToString(), "", applicant);
                           
                            break;
                    }

                    if (cellElement == null) continue;

                    rowElement.AppendChild(cellElement);
                }





                dataGridElement.AppendChild(rowElement);
                seq++;
            }


            fieldElement.AppendChild(dataGridElement);

        }


        fieldElement.SetAttribute("fillerName", userName);
        fieldElement.SetAttribute("fillerUserGuid", userGuid);
        fieldElement.SetAttribute("fillerAccount", account);
        fieldElement.SetAttribute("fillSiteId", "");




        IsDataGrid = false;
        return fieldElement;
    }


    #region ==================封存區=============================

    /*
    internal string GetHyperLinkFieldXml(string fieldId, string fieldName)
    {
        return string.Format(commonFieldXmlStr, fieldId, fieldName, @"，此為超連結欄位，fieldValue值的對應方式為連結名稱@連結網址");
    }

    internal string GetCalculateTextFieldXml(string fieldId, string fieldName)
    {
        return string.Format(commonFieldXmlStr, fieldId, fieldName, "，此為計算欄位，注意fileValue對應的值也是數值格式的字串");
    }

    internal string GetAggregateTextFieldXml(string fieldId, string fieldName)
    {
        return string.Format(commonFieldXmlStr, fieldId, fieldName, "，此為加總平均欄位，注意fileValue對應的值也是數值格式的字串");
    }

    internal string GetUserDeptFieldXml(string fieldId, string fieldName)
    {
        return string.Format(commonFieldXmlStr, fieldId, fieldName, @"，此為申請者部門欄位，注意fileValue對應的值是部門的名稱
            //realValue對應的值為部門GUID,部門名稱,False");
    }

    internal string GetUserProposerFieldXml(string fieldId, string fieldName)
    {
        return string.Format(commonFieldXmlStr, fieldId, fieldName, @"，此為申請者欄位，注意fileValue對應的值是申請者姓名(帳號)
            //realValue對應的值為申請者的UserSet");
    }

    internal string GetUserRankFieldXml(string fieldId, string fieldName)
    {
        return string.Format(commonFieldXmlStr, fieldId, fieldName, @"，此為申請者職級欄位，注意fileValue對應的值是申請者職級");
    }

    internal string GetUserAgentFieldXml(string fieldId, string fieldName)
    {
        return string.Format(commonFieldXmlStr, fieldId, fieldName, @"，此為代理人欄位，注意fileValue對應的值是代理人GUID@代理人部門 姓名
            //realValue對應的值為代理人的UserSet");
    }

    internal string GetAllDeptFieldXml(string fieldId, string fieldName)
    {
        return string.Format(commonFieldXmlStr, fieldId, fieldName, @"，此為所有部門欄位，注意fileValue對應的值是所選的部門
            //(EX:選擇產品部和研發部則顯示產品部、研發部)
            //realValue對應的值為所選的部門的UserSet");
    }

    internal string GetaAlRankFieldXml(string fieldId, string fieldName)
    {
        return string.Format(commonFieldXmlStr, fieldId, fieldName, @"，此為所有職級欄位，注意fileValue對應的值是所選的職級
            //(EX:選擇經理和副理則顯示經理、副理)
            //realValue對應的值為所選的職級的UserSet");
    }

    internal string GetAllFunctionFieldXml(string fieldId, string fieldName)
    {
        return string.Format(commonFieldXmlStr, fieldId, fieldName, @"，此為所有職務欄位，注意fileValue對應的值是所選的職務
            //(EX:選擇茶水小妹和送報小弟則顯示茶水小妹、送報小弟)
            //realValue對應的值為所選的職務的UserSet");
    }

    internal string GetAllUserFieldXml(string fieldId, string fieldName)
    {
        return string.Format(commonFieldXmlStr, fieldId, fieldName, @"，此為所有人員欄位，注意fileValue對應的值是所選的人員
            //(EX:選擇員工A和員工B則顯示員工A(員工A的帳號)、員工B(員工B的帳號))
            //realValue對應的值為所所選的人員的UserSet");
    }

    internal string GetDisplayFieldXml(string fieldId, string fieldName)
    {
        return string.Format(commonFieldXmlStr, fieldId, fieldName, @"，此為純顯示欄位");
    }

    internal string GetHiddenFieldXml(string fieldId, string fieldName)
    {
        return string.Format(commonFieldXmlStr, fieldId, fieldName, @"，此為隱蔵欄位");
    }
    */
    #endregion




}

public class DataGridFields
{
    public List<DataGridList> DataGridList { get; set; }


    public DataGridFields()
    {
        DataGridList = new List<global::DataGridList>();
    }


}

public class DataGridList
{
    public string FieldId { get; set; }
    public string TableName { get; set; }
}

public class DB : Ede.Uof.Utility.Data.BasePersistentObject
{

    internal DataTable QueryExernalForms()
    {
        string cmdTxt = @" SELECT 
	 [FORM_VERSION_ID] , 
	 [EXTERNAL_TABLE_NAME] , 
	 [EXTERNAL_GRID_TABLES_NAME]  
 FROM [dbo].[TB_CDS_EXTERNAL_FORM_MAPPING] ";

        DataTable dt = new DataTable();
        dt.Load(this.m_db.ExecuteReader(cmdTxt), LoadOption.OverwriteChanges);
        return dt;


    }

    internal DataTable QueryAllApplyForms(string tableName)
    {
        //格式不定，只能用*
        string cmdTxt = @" SELECT 
       *
 FROM [dbo].[{0}] 
WHERE STATUS IS NULL";

        cmdTxt = string.Format(cmdTxt, tableName);

        DataTable dt = new DataTable();
        dt.Load(this.m_db.ExecuteReader(cmdTxt), LoadOption.OverwriteChanges);
        return dt;
    }

    /// <summary>
    /// 找明細資料
    /// </summary>
    /// <param name="tableName"></param>
    /// <param name="externalTaskId"></param>
    /// <returns></returns>
    internal DataTable QueryDataGridFieldData(string tableName , string externalTaskId)
    {
        //格式不定，只能用*
        string cmdTxt = @" SELECT 
       *
 FROM [dbo].[{0}] 
WHERE  EXTERNAL_TASK_ID=@EXTERNAL_TASK_ID 
ORDER BY GRID_SEQ";

        cmdTxt = string.Format(cmdTxt, tableName);

        DataTable dt = new DataTable();
        this.m_db.AddParameter("EXTERNAL_TASK_ID", externalTaskId);
        dt.Load(this.m_db.ExecuteReader(cmdTxt), LoadOption.OverwriteChanges);
        return dt;
    }


    internal string QueryVersionFields(string formVersionId)
    {
        string cmdTxt = @"SELECT VERSION_FIELD FROM TB_WKF_FORM_VERSION
                            WHERE FORM_VERSION_ID = @FORM_VERSION_ID";

        this.m_db.AddParameter("FORM_VERSION_ID", formVersionId);

        object obj = this.m_db.ExecuteScalar(cmdTxt);

        return obj.ToString();

    }

    internal void UpdateFormStatus(string externalTaskId, string tableName,string status, string taskId, string formNbr, string exception)
    {
        string cmdTxt = string.Format(@"  UPDATE [dbo].[{0}]  
 SET 
	 [EXCEPTION_MSG] = @EXCEPTION_MSG , 
	 [FORM_NUMBER] = @FORM_NUMBER , 
	 [TASK_ID] = @TASK_ID , 
	 [STATUS] = @STATUS , 
	 [MODIFY_TIME] = @MODIFY_TIME  

WHERE 
	[EXTERNAL_TASK_ID] = @EXTERNAL_TASK_ID" , tableName);

        this.m_db.AddParameter("@EXCEPTION_MSG", exception);
        this.m_db.AddParameter("@FORM_NUMBER", formNbr);
        this.m_db.AddParameter("@TASK_ID", taskId);
        this.m_db.AddParameter("@STATUS", status);
        this.m_db.AddParameter("@MODIFY_TIME", DateTime.Now);
        this.m_db.AddParameter("@EXTERNAL_TASK_ID", externalTaskId);

        this.m_db.ExecuteNonQuery(cmdTxt);

    }
}