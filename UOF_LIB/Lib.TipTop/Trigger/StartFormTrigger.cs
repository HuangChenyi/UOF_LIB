using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Linq;
using Ede.Uof.EIP.Organization.Util;
using Ede.Uof.EIP.SystemInfo;
using Ede.Uof.Utility.Configuration;
using Ede.Uof.Utility.Log;
using Ede.Uof.WKF.ExternalUtility;

namespace Lib.TipTop.Trigger
{
    public class StartFormTrigger : Ede.Uof.WKF.ExternalUtility.ICallbackTriggerPlugin
    {
        public void Finally()
        {
           // throw new NotImplementedException();
        }

        public string GetFormResult(ApplyTask applyTask)
        {
            //  throw new NotImplementedException();

            //XDocument xd = XDocument.Parse(applyTask.CurrentDocXML);
            //string empno = (from x1 in xd.Elements("Form").Elements("FormFieldValue").Elements("FieldItem")
            //                where x1.Attribute("fieldId").Value == "EmpNo"
            //                select x1).FirstOrDefault().Attribute("fieldValue").Value;
            //TT_WS tt = new TT_WS();
            //string empname = tt.getEmployData(empno);

            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.LoadXml(applyTask.CurrentDocXML);

            string account = applyTask.Task.Applicant.Account;

            Setting set = new Setting();
            //判斷TT是不是要傳工號

            if (!string.IsNullOrEmpty(set["TT_IsEmpNo"]))
            {
                if (Convert.ToBoolean(set["TT_IsEmpNo"]))
                {
                    EBUser ebUSer = new UserUCO().GetEBUser(applyTask.Task.Applicant.UserGUID);
                    account = ebUSer.EmployeeNo;
                }
                else
                {
                    account = applyTask.Task.Applicant.Account;
                }
            }
            else
            {
                account = applyTask.Task.Applicant.Account;
            }


            string RequestMethod = "SetStatus";
            string SenderIP = Current.UserIPAddress;
            string ReceiverIP = "192.168.100.30";
            string EFSiteName = "EIP";
            string EFLogonID = applyTask.Task.Applicant.Account;
            string ProgramID = xmlDoc.SelectSingleNode(string.Format("./Form/FormFieldValue/FieldItem[@fieldId='ProgramID']")).Attributes["fieldValue"].Value;
            string PlantID = xmlDoc.SelectSingleNode(string.Format("./Form/FormFieldValue/FieldItem[@fieldId='PlantID']")).Attributes["fieldValue"].Value;
            string SourceFormID = xmlDoc.SelectSingleNode(string.Format("./Form/FormFieldValue/FieldItem[@fieldId='SourceFormID']")).Attributes["fieldValue"].Value;
            string SourceFormNum = xmlDoc.SelectSingleNode(string.Format("./Form/FormFieldValue/FieldItem[@fieldId='SourceFormNum']")).Attributes["fieldValue"].Value;
            string Date = DateTime.Now.ToString("yy/MM/dd");
            string Time = DateTime.Now.ToString("HH:mm:ss");
            string Status = "1";
           
            string FormCreatorID = applyTask.Task.Applicant.Account;
            string FormOwnerID = applyTask.Task.Applicant.Account;
            string TargetFormID = applyTask.Task.FormName;
            string TargetSheetNo = applyTask.FormNumber;
            string Description = "";

            XDocument xDoc = new XDocument(
                             new XElement("Request"
                           , new XElement("RequestMethod", RequestMethod)
                           , new XElement("LogOnInfo", new XElement("SenderIP", SenderIP)
                                                     , new XElement("ReceiverIP", ReceiverIP)
                                                     , new XElement("EFSiteName", EFSiteName)
                                                     , new XElement("EFLogonID", EFLogonID)
                                                     , new XElement("RequestContent", new XElement("ContentText", new XElement("Form", new XElement("ProgramID", ProgramID)
                                                                                                                , new XElement("PlantID", PlantID)
                                                                                                                , new XElement("SourceFormID", SourceFormID)
                                                                                                                , new XElement("SourceFormNum", SourceFormNum)
                                                                                                                , new XElement("Date", Date)
                                                                                                                , new XElement("Time", Time)
                                                                                                                , new XElement("Status", Status)
                                                                                                                , new XElement("FormCreatorID", FormCreatorID)
                                                                                                                , new XElement("FormOwnerID", FormOwnerID)
                                                                                                                , new XElement("TargetFormID", TargetFormID)
                                                                                                                , new XElement("TargetSheetNo", TargetSheetNo)
                                                                                                                , new XElement("Description", Description)))))));

            string xmlstr = xDoc.ToString();

            ERP.CallERP erp = new ERP.CallERP();

            string result = "";

            try
            {
                result = erp.TIPTOPGateWay(xmlstr);
                //                 result= erp.TIPTOPGateWay(@"<Response>
                // <ResponseType>SetStatus</ResponseType>
                // <ResponseInfo>
                //  <SenderIP>TIPTOPAP</SenderIP>
                //  <ReceiverIP>192.168.10.74</ReceiverIP>
                // </ResponseInfo>
                // <ResponseContent>
                //  <ReturnInfo>
                //   <ReturnStatus>Y</ReturnStatus>
                //   <ReturnDescribe>No error.</ReturnDescribe>
                //  </ReturnInfo>
                //  <ContentText>
                //   <Form>
                //    <Status>3</Status>
                //    <PlantID>LTTW</PlantID>
                //    <ProgramID>apmt420</ProgramID>
                //    <SourceFormID>AC08</SourceFormID>
                //    <SourceFormNum>AC08-2001140001</SourceFormNum>
                //    <FormCreatorID>T106031</FormCreatorID>
                //    <FormOwnerID>T105013</FormOwnerID>
                //    <TargetFormID>apmt420</TargetFormID>
                //    <TargetSheetNo>4a01d004e6a9100486c3659ac351cf14</TargetSheetNo>
                //   </Form>
                //  </ContentText>
                // </ResponseContent>
                //</Response>");


                string log = string.Format("表單編號{0} \r\n 輸入資料 \r\n {1} \r\n 回傳資料 \r\n {2} ", applyTask.FormNumber, result, xDoc.ToString());

                Logger.Write("TTLog", log);  //已寫好的LOG元件
            }
            catch (Exception ce)
            {
                result = ce.ToString();
                string log = string.Format("表單編號{0} \r\n 輸入資料 \r\n {1} \r\n 回傳資料 \r\n {2} ", applyTask.FormNumber, result, xDoc.ToString());

                Logger.Write("TTLog", log);  //已寫好的LOG元件
                throw;
            }


            return "";
        }

        public void OnError(Exception errorException)
        {
          //  throw new NotImplementedException();
        }
    }
}
