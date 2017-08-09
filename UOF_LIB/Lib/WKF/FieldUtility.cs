using Ede.Uof.EIP.Organization.Util;
using Lib.Organization;
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
        public XmlElement GetCommonField(string fieldId, string fieldValue, string realValue, string applicant)
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
            return GetFieldElement(fieldId, fieldValue, realValue, userName, userGuid, account);
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
                fieldElement = XmlDoc.CreateElement("Cell");
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
            UserSetGroup userSetGroup = new UserSetGroup();
            userSetGroup.GROUP_ID = groupId;
            //userSet.Items.Add(userSetUser);

            //申請者部門特性 fieldValue -< 部門名稱  realValue -< 部門ID,部門名稱,False
            return GetFieldElement(fieldId, userSetGroup.GetGroupName(),
                string.Format("{0},{1},False", groupId, userSetGroup.GetGroupName())
                , userName, userGuid, account);
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
            return GetFieldElement(fieldId, userGuid + "@" + userSetUser.GetName(), userSet.GetXML(), userName, userGuid, account);
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

            ExternalFormPO db = new ExternalFormPO();
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
    }

    public class OptionFieldObj
    {
        public string FieldValue { get; set; }
        public string ConditionValue { get; set; }
        public string RealValue { get; set; }
    }

    public class DataGridFields
    {
        public List<DataGridList> DataGridList { get; set; }


        public DataGridFields()
        {
            DataGridList = new List<DataGridList>();
        }


    }

    public class DataGridList
    {
        public string FieldId { get; set; }
        public string TableName { get; set; }
    }
}
