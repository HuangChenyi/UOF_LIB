using Lib.WKF.PO;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace Lib.WKF
{
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

        public void GetResult(string externalTaskId, string tableName, string log)
        {

            XmlDocument xmlDoc = new XmlDocument();

            xmlDoc.LoadXml(log);

            string status = xmlDoc.SelectSingleNode("./ReturnValue/Status").InnerText;
            using (var po = new ExternalFormPO())
            {

                if (status == "1")
                {
                    string taskId = xmlDoc.SelectSingleNode("./ReturnValue/TaskId").InnerText;
                    string formNbr = xmlDoc.SelectSingleNode("./ReturnValue/FormNumber").InnerText;
                    po.UpdateFormStatus(externalTaskId, tableName, status, taskId, formNbr, "");
                }
                else
                {
                    po.UpdateFormStatus(externalTaskId, tableName, status, "", "", log);
                }
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

        public  string GetFormXML(DataRow applyFormDr, DataRow externalFormsDr)
        {
            FieldUtility fieldUtil = new FieldUtility();
            FormUtitlity formUtility = new FormUtitlity();
            XmlDocument xmlDoc = new XmlDocument();
            XmlDocument versionFieldsXml = new XmlDocument();
            fieldUtil.XmlDoc = xmlDoc;
            formUtility.XmlDoc = xmlDoc;


            string versionFields ="";
            using (var po = new ExternalFormPO())
            {
                versionFields = po.QueryVersionFields(externalFormsDr["FORM_VERSION_ID"].ToString());
            }
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
    }
    
}
