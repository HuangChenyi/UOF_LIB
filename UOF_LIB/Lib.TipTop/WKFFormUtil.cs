using Ede.Uof.EIP.Organization.Util;
using Ede.Uof.Utility.Configuration;
using Ede.Uof.Utility.Log;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;

using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Linq;

namespace Lib.TipTop
{
    public class WKFFormUtil
    {
        string filePath = "";
        string url = "";
        public WKFFormUtil()
        {
            Setting set = new Setting();

            filePath = set["IGS_UploadFilePath"];// "D:\\技轉暫存_鈊象\\UOF_Training\\UOF13.1\\CDS\\TTAttach";
             url = set["IGS_UploadFileURL"]; //"http://localhost/UOF_IGS/CDS/TTAttach/";
        }


        public string ConvertUOFFormXml(string xml )
        {
           
            XDocument xdoc = XDocument.Parse(xml);

            //取得單別
            string ProgramID = xdoc.Element("Request").Element("RequestContent").Element("Form").Element("ProgramID").Value;
            WKFPO po = new WKFPO();
            string fromVersionId = po.GetFormVersionID(ProgramID);

            //申請者的帳號 USER_GUID 姓名  作為記錄填寫資訊用
            string account = xdoc.Element("Request").Element("RequestContent").Element("Form").Element("FormOwnerID").Value;
            UserUCO userUCO = new UserUCO();

            string userGuid = userUCO.GetGUID(account);
            string userName = userUCO.GetEBUser(userGuid).Name;


            //urgentLevel 緊急程度0:緊急 1:急 2:普通
            XmlDocument xmlDoc = new XmlDocument();
            XmlElement formElement = xmlDoc.CreateElement("Form");
            formElement.SetAttribute("formVersionId", fromVersionId);
            formElement.SetAttribute("urgentLevel", "2");

            XmlElement applicantElement = xmlDoc.CreateElement("Applicant");

            //<!--account:申請者UOF帳號 groupId部門代號(可不填) jobTitleId:職稱代號(可不填)-->
            applicantElement.SetAttribute("account", account);
            applicantElement.SetAttribute("groupId", "");
            applicantElement.SetAttribute("jobTitleId", "");

            //申請者意見
            XmlElement commentElement = xmlDoc.CreateElement("Comment");
            commentElement.InnerText = "";

            applicantElement.AppendChild(commentElement);

            formElement.AppendChild(applicantElement);



            XmlElement formFieldValueElement = xmlDoc.CreateElement("FormFieldValue");
            formElement.AppendChild(formFieldValueElement);


            //表單編欄位
            XmlElement NOElement = xmlDoc.CreateElement("FieldItem");
            NOElement.SetAttribute("fieldId", "NO");
            NOElement.SetAttribute("fieldValue", xdoc.Element("Request").Element("RequestContent").Element("Form").Element("SourceFormNum").Value);
            NOElement.SetAttribute("realValue", "");
            NOElement.SetAttribute("IsNeedAutoNbr", "True");
            
            formFieldValueElement.AppendChild(NOElement);


            //隱藏欄位
            //PlantID
            string PlantID = xdoc.Element("Request").Element("RequestContent").Element("Form").Element("PlantID").Value;

            XmlElement PlantIDElement = xmlDoc.CreateElement("FieldItem");
            PlantIDElement.SetAttribute("fieldId", "PlantID");
            PlantIDElement.SetAttribute("fieldValue", PlantID);
            PlantIDElement.SetAttribute("realValue", "");
   
            formFieldValueElement.AppendChild(PlantIDElement);
            //ProgramID
            XmlElement ProgramIDElement = xmlDoc.CreateElement("FieldItem");
            ProgramIDElement.SetAttribute("fieldId", "ProgramID");
            ProgramIDElement.SetAttribute("fieldValue", xdoc.Element("Request").Element("RequestContent").Element("Form").Element("ProgramID").Value);
            ProgramIDElement.SetAttribute("realValue", "");

            formFieldValueElement.AppendChild(ProgramIDElement);
            //SourceFormID
            XmlElement SourceFormIDElement = xmlDoc.CreateElement("FieldItem");
            SourceFormIDElement.SetAttribute("fieldId", "SourceFormID");
            SourceFormIDElement.SetAttribute("fieldValue", xdoc.Element("Request").Element("RequestContent").Element("Form").Element("SourceFormID").Value);
            SourceFormIDElement.SetAttribute("realValue", "");

            formFieldValueElement.AppendChild(SourceFormIDElement);
            //SourceFormNum
            XmlElement SourceFormNumElement = xmlDoc.CreateElement("FieldItem");
            SourceFormNumElement.SetAttribute("fieldId", "SourceFormNum");
            SourceFormNumElement.SetAttribute("fieldValue", xdoc.Element("Request").Element("RequestContent").Element("Form").Element("SourceFormNum").Value);
            SourceFormNumElement.SetAttribute("realValue", "");

            formFieldValueElement.AppendChild(SourceFormNumElement);

            //表單Header欄位
            foreach (var node in xdoc.Element("Request").Element("RequestContent").Element("Form").Element("ContentText").Element("head").Elements())
            {
                XmlElement A01Element = xmlDoc.CreateElement("FieldItem");
                A01Element.SetAttribute("fieldId", node.Name.LocalName);
                A01Element.SetAttribute("fieldValue", node.Value.Trim());
                A01Element.SetAttribute("realValue", "");
                A01Element.SetAttribute("fillerName", userName);
                A01Element.SetAttribute("fillerUserGuid", userGuid);
                A01Element.SetAttribute("fillerAccount", account);
                A01Element.SetAttribute("fillSiteId", "");

                formFieldValueElement.AppendChild(A01Element);

            }


            //表單Detail欄位
            foreach (var node in xdoc.Element("Request").Element("RequestContent").Element("Form").Element("ContentText").Elements("body"))
            {
                XmlElement A01Element = xmlDoc.CreateElement("FieldItem");
                A01Element.SetAttribute("fieldId", node.Attribute("id").Value);
               
                A01Element.SetAttribute("realValue", "");
                A01Element.SetAttribute("fillerName", userName);
                A01Element.SetAttribute("fillerUserGuid", userGuid);
                A01Element.SetAttribute("fillerAccount", account);
                A01Element.SetAttribute("fillSiteId", "");


                XmlElement DataGridElement = xmlDoc.CreateElement("DataGrid");
                A01Element.AppendChild(DataGridElement);
                int index = 0;
                foreach (var detail in node.Elements("record"))
                {
                    //<DataGrid>
                    //  <Row order="0">
                    //    <Cell fieldId="A12_1" fieldValue="33" realValue="" />
                    //  </Row>
                    //</DataGrid>
                    XmlElement rowElement = xmlDoc.CreateElement("Row");
                    rowElement.SetAttribute("order", index.ToString());

                    DataGridElement.AppendChild(rowElement);

                    foreach(var cell in detail.Elements())
                    {
                        XmlElement cellElement = xmlDoc.CreateElement("Cell");
                        cellElement.SetAttribute("fieldId", cell.Name.LocalName);
                        cellElement.SetAttribute("fieldValue", cell.Value.Trim());
                        cellElement.SetAttribute("realValue", "");
                        cellElement.SetAttribute("fillerName", userName);
                        cellElement.SetAttribute("fillerUserGuid", userGuid);
                        cellElement.SetAttribute("fillerAccount", account);
                        cellElement.SetAttribute("fillSiteId", "");

                        rowElement.AppendChild(cellElement);
                    }

                    index++;
                }


                formFieldValueElement.AppendChild(A01Element);

            }


            //表單attach(連結)欄位
            foreach (var node in xdoc.Element("Request").Element("RequestContent").Element("Form").Element("ContentText").Elements("attachment"))
            {
                XmlElement A01Element = xmlDoc.CreateElement("FieldItem");
                A01Element.SetAttribute("fieldId", "attach");

                A01Element.SetAttribute("realValue", "");
                A01Element.SetAttribute("fillerName", userName);
                A01Element.SetAttribute("fillerUserGuid", userGuid);
                A01Element.SetAttribute("fillerAccount", account);
                A01Element.SetAttribute("fillSiteId", "");


                XmlElement DataGridElement = xmlDoc.CreateElement("DataGrid");
                A01Element.AppendChild(DataGridElement);
                int index = 0;
                foreach (var detail in node.Elements("document"))
                {
                    //<DataGrid>
                    //  <Row order="0">
                    //    <Cell fieldId="A12_1" fieldValue="33" realValue="" />
                    //  </Row>
                    //</DataGrid>
                    XmlElement rowElement = xmlDoc.CreateElement("Row");
                    rowElement.SetAttribute("order", index.ToString());

                    DataGridElement.AppendChild(rowElement);

                
                        XmlElement cellElement = xmlDoc.CreateElement("Cell");


                    switch(detail.Attribute("type").Value)
                    {
                        case "HTTP":
                            string key = detail.Attribute("content").Value.Substring(0, detail.Attribute("content").Value.IndexOf('.'));
                            cellElement.SetAttribute("fieldValue", DownloadFile(key , PlantID));
                            break;
                        case "URL":

                            //如果開頭是四個\要換成是http
                            string content = detail.Attribute("content").Value;
                            if (content.IndexOf("\\\\\\\\") ==0)
                            {
                                content= content.Replace("\\\\\\\\", "http://").Replace("\\","/");
                                cellElement.SetAttribute("fieldValue", DownloadFileUrl(content));
                                break;
                                
                            }

                            cellElement.SetAttribute("fieldValue", $"{content}@{content}");
                            break;
                        case "TXT":
                            cellElement.SetAttribute("fieldValue", $"{detail.Attribute("content").Value}@javascript:void(0)");
                            break;
                    }

                        cellElement.SetAttribute("fieldId", "link");
                     
                        cellElement.SetAttribute("realValue", "");
                        cellElement.SetAttribute("fillerName", userName);
                        cellElement.SetAttribute("fillerUserGuid", userGuid);
                        cellElement.SetAttribute("fillerAccount", account);
                        cellElement.SetAttribute("fillSiteId", "");

                        rowElement.AppendChild(cellElement);
                    

                    index++;
                }


                formFieldValueElement.AppendChild(A01Element);

            }


            return XElement.Parse(formElement.OuterXml).ToString();
        }

        public string DownloadFileUrl(string fileURL)
        {
           

            string year = DateTime.Today.Year.ToString();
            string month = DateTime.Today.Month.ToString("d2");
            string day = DateTime.Today.Day.ToString("d2");
            DirectoryInfo dirInfo = new DirectoryInfo($"{filePath}\\{year}");

            if (!dirInfo.Exists)
                dirInfo.Create();

            dirInfo = new DirectoryInfo($"{filePath}\\{year}\\{month}");

            if (!dirInfo.Exists)
                dirInfo.Create();

            dirInfo = new DirectoryInfo($"{filePath}\\{year}\\{month}\\{day}");

            if (!dirInfo.Exists)
                dirInfo.Create();

            WebClient MyWebClient = new WebClient();
            MyWebClient.Credentials = CredentialCache.DefaultCredentials;
            Byte[] pageData = MyWebClient.DownloadData(fileURL); //從指定網站下載數據

            string fileName = fileURL.Substring(fileURL.LastIndexOf("/") + 1, fileURL.Length - fileURL.LastIndexOf("/") - 1);
            FileStream fs = new FileStream($"{filePath}\\{year}\\{month}\\{day}\\{fileName}", FileMode.OpenOrCreate);
            fs.Write(pageData, 0, pageData.Length - 1);
            fs.Close();


            return $"{fileName}@{url}/{year}/{month}/{day}/{fileName}";
        }

        public string  DownloadFile(string key , string PlantID)
        {
            //先寫死
          
            string year= DateTime.Today.Year.ToString();
            string month = DateTime.Today.Month.ToString("d2");
            string day = DateTime.Today.Day.ToString("d2");

            DirectoryInfo dirInfo = new DirectoryInfo($"{filePath}\\{year}" );

            if (!dirInfo.Exists)
                dirInfo.Create();

            dirInfo = new DirectoryInfo($"{filePath}\\{year}\\{month}");

            if (!dirInfo.Exists)
                dirInfo.Create();

            dirInfo = new DirectoryInfo($"{filePath}\\{year}\\{month}\\{day}");

            if (!dirInfo.Exists)
                dirInfo.Create();

            string connStr = System.Configuration.ConfigurationManager.ConnectionStrings["connectionstringTOOracle"].ConnectionString;
            OracleConnection conn = new OracleConnection(connStr);
            conn.Open();

            Logger.Write("TT" , $"KEY={key},PLANT_ID={PlantID}");

           OracleCommand comm = new OracleCommand($@"select GCB07,GCB09 from {PlantID}.gcb_file
where gcb01 =:key
", conn);
              comm.Parameters.Add("gcb01" , key);
            DataTable dt = new DataTable();
            dt.Load(comm.ExecuteReader());

            Byte[] pageData = (Byte[])dt.Rows[0]["GCB09"];
            FileStream fs = new FileStream($"{filePath}\\{year}\\{month}\\{day}\\{dt.Rows[0]["GCB07"].ToString()}", FileMode.OpenOrCreate);
            fs.Write(pageData, 0, pageData.Length - 1);
            fs.Close();

            Console.Write(conn.ServerVersion);
            conn.Close();
            return dt.Rows[0]["GCB07"].ToString() + "@" + $"{url}\\{year}\\{month}\\{day}\\{dt.Rows[0]["GCB07"].ToString()}";

        }
    }
}
