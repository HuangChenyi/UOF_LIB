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
        string ttUrl = "";
        bool isTTEmpNo = false; 
        public WKFFormUtil()
        {
            Setting set = new Setting();

            filePath = set["UOFTT_UploadFilePath"];// "D:\\技轉暫存_鈊象\\UOF_Training\\UOF13.1\\CDS\\TTAttach";
             url = set["UOFTT_UploadFileURL"]; //"http://localhost/UOF_IGS/CDS/TTAttach/";
            ttUrl = set["TT_UploadFileURL"]; //"http://192.168.2.20/cgi-bin/fglccgi/toptest/tiptop/";

            if(!string.IsNullOrEmpty(set["TT_IsEmpNo"]))
            { 
                isTTEmpNo = Convert.ToBoolean( set["TT_IsEmpNo"]);
            }
            else
            {

            }
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

            string userGuid = ""; 
            string userName = "";

            if(!isTTEmpNo)
            {
                userGuid= userUCO.GetGUID(account);
                userName = userUCO.GetEBUser(userGuid).Name;
            }
            else
            {
                userGuid = userUCO.GetGUIDByEmpNo(account);
                userName = userUCO.GetEBUser(userGuid).Name;
                account = userUCO.GetEBUser(userGuid).Account;
            }

            var form= Ede.Uof.WKF.Utility.Document.GetEmptyDocument(fromVersionId);
            
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

                //加入下拉選單的處理
                switch(form.Fields[node.Name.LocalName].FieldType )
                {
                    case Ede.Uof.WKF.Design.FieldType.dropDownList:
                        A01Element.SetAttribute("fieldValue", node.Value.Trim()+"@"+ node.Value.Trim());
                        break;
                    default:
                        A01Element.SetAttribute("fieldValue", node.Value.Trim());
                        break;
                }

                A01Element.SetAttribute("fieldId", node.Name.LocalName);
              
                A01Element.SetAttribute("realValue", "");
                A01Element.SetAttribute("fillerName", userName);
                A01Element.SetAttribute("fillerUserGuid", userGuid);
                A01Element.SetAttribute("fillerAccount", account);
                A01Element.SetAttribute("fillSiteId", "");

                formFieldValueElement.AppendChild(A01Element);

            }

            int bodySeq = 1;
            //表單Detail欄位
            foreach (var node in xdoc.Element("Request").Element("RequestContent").Element("Form").Element("ContentText").Elements("body"))
            {
                XmlElement A01Element = xmlDoc.CreateElement("FieldItem");

                if (node.Attribute("id") != null)
                {
                    A01Element.SetAttribute("fieldId", node.Attribute("id").Value);
                }
                else
                {
                    A01Element.SetAttribute("fieldId", "detail"+ bodySeq);
                }
                bodySeq++;
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

                    string content = "";
                    switch (detail.Attribute("type").Value)
                    {
                        case "DOC":
                            string key = detail.Attribute("content").Value.Substring(0, detail.Attribute("content").Value.IndexOf('.')).Replace("/u1/out/", "");
                            cellElement.SetAttribute("fieldValue", DownloadFile(key , PlantID));
                            break;
                        case "URL":

                            //如果開頭是四個\要換成是http
                             content = detail.Attribute("content").Value;
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
                        //case "DOC":

                        //    //如果開頭是四個\要換成是http
                        //     content = detail.Attribute("content").Value;
                          
                        //    content = content.Replace("u1", ttUrl);
                        //    cellElement.SetAttribute("fieldValue", DownloadFileUrl(content));
                           
                            

                        //    cellElement.SetAttribute("fieldValue", $"{ detail.Attribute("filename").Value}@{content}");
                        //    break;
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
            Logger.Write("TTURL", fileURL);
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

            Logger.Write("TT" , $"KEY={key},PLANT_ID={PlantID},OracleVersion={conn.ServerVersion}");


            //因為BLOB在撈資料會有問題，改變為OFFSET的寫法
            //OracleCommand comm = new OracleCommand($@"select GCB07,GCB09 from {PlantID}.gcb_file
            //where gcb01 =:key
            //", conn);
            //comm.Parameters.Add("gcb01", OracleDbType.Varchar2).Value = key;

            OracleCommand comm = new OracleCommand($@"select GCB07 from {PlantID}.gcb_file
            where gcb01 =:key
            ", conn);
            comm.Parameters.Add("gcb01", OracleDbType.Varchar2).Value = key;
           // Logger.Write();
            string fileName = comm.ExecuteScalar().ToString();


            comm = new OracleCommand($@"WITH
                                    INFO
                                    AS
                                    (
                                        SELECT
                                            dbms_lob.getlength(A.GCB09) AS GCB09_LENGTH, 
                                            MOD(dbms_lob.getlength(A.GCB09),2000) AS MOD,
                                            CASE
                                                WHEN MOD(dbms_lob.getlength(A.GCB09),2000) > 0 THEN TRUNC((dbms_lob.getlength(A.GCB09)/2000) + 1)
                                                ELSE TRUNC(dbms_lob.getlength(A.GCB09)/2000)
                                            END INTERATION_COUNT,
                                            A.GCB09,
                                            A.gcb01
                                          FROM atp_tw.gcb_file A WHERE gcb01=:key)
                                    ,OFFSETS AS
                                    (
                                        SELECT
                                            (2000 * (ROWNUM-1)) + 1 AS OFFSET,
                                            I.MOD,
                                            I.GCB09_LENGTH,
                                            I.GCB09,
                                            I.gcb01,
                                            I.INTERATION_COUNT
                                        FROM INFO I
                                        CONNECT BY LEVEL <= I.INTERATION_COUNT
                                    )
                                    ,RESULT AS
                                    (
                                        SELECT
                                            DBMS_LOB.SUBSTR(O.GCB09, 2000, O.OFFSET) AS CONTENT,
                                            O.OFFSET,
                                            O.MOD,
                                            O.GCB09_LENGTH,
                                            O.gcb01,
                                            O.INTERATION_COUNT
                                        FROM OFFSETS O
                                    )
                                    SELECT * FROM RESULT R ORDER BY R.OFFSET ASC", conn);

            FileStream fs = new FileStream($"{filePath}\\{year}\\{month}\\{day}\\{fileName}", FileMode.OpenOrCreate);
            try
            {
                comm.Parameters.Add("gcb01", OracleDbType.Varchar2).Value = key;

                DataTable dt = new DataTable();
                dt.Load(comm.ExecuteReader());

                Console.WriteLine(dt.Rows[0]["GCB09_LENGTH"].ToString());

                // 產生一個空白暫存檔
               

                byte[] bs = new byte[64 * 1024];
                Array.Clear(bs, 0, bs.Length);

                int xInt = 0;
                int yInt = 0;

                xInt = (Convert.ToInt32(dt.Rows[0]["GCB09_LENGTH"].ToString())) / bs.Length;
                yInt = (Convert.ToInt32(dt.Rows[0]["GCB09_LENGTH"].ToString())) % bs.Length;

                for (long i = 0; i < xInt; i++)
                    fs.Write(bs, 0, bs.Length);

                if (yInt > 0)
                    fs.Write(bs, 0, yInt);

                fs.Close();


                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    WriteFileSession($"{filePath}\\{year}\\{month}\\{day}\\{fileName}", Convert.ToInt32(dt.Rows[i]["OFFSET"]), (byte[])dt.Rows[i]["CONTENT"]);
                }

            }
            catch (Exception ce)
            {
                Logger.Write("TT", ce.ToString());
            }

            conn.Close();
    
            fs.Close();

     
            return fileName + "@" + $"{url}\\{year}\\{month}\\{day}\\{fileName}";

        }


        public  void WriteFileSession(string fielName, int offset, byte[] buffer)
        {


            FileStream fs = new FileStream(fielName, FileMode.Open);

            fs.Seek(offset - 1, SeekOrigin.Begin);  // Seek 到定位

            try
            {
                fs.Write(buffer, 0, buffer.Length);
            }
            catch (Exception ce)
            {
                // string errorStr = String.Format("[EBSystem] WriteFileSession() : Write file [{0}] failure, error reason :\r\n{1}", fileStr, ce.Message);
                fs.Close();
                throw;
            }
            finally
            {
                fs.Close();
            }
        }
    }
}
