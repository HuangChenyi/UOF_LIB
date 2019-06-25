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
    public class EndFormTrigger : Ede.Uof.WKF.ExternalUtility.ICallbackTriggerPlugin
    {
        public void Finally()
        {
            //throw new NotImplementedException();
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

            string account= applyTask.Task.Applicant.Account;
            
            Setting set = new Setting();
            //判斷TT是不是要傳工號

            if (!string.IsNullOrEmpty(set["TT_IsEmpNo"]))
            {
                if( Convert.ToBoolean(set["TT_IsEmpNo"]))
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
            string Status = "";
            switch (applyTask.FormResult) //2:抽單, 撤簽 ; 3:同意 ; 4:不同意
            {
                case Ede.Uof.WKF.Engine.ApplyResult.Adopt:
                    Status = "3";
                    break;

                case Ede.Uof.WKF.Engine.ApplyResult.Reject:
                    Status = "4";
                    break;

                case Ede.Uof.WKF.Engine.ApplyResult.Cancel:
                    Status = "2";
                    break;
            }
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

            string result = erp.TIPTOPGateWay(xmlstr);

            string log = string.Format("表單編號{0} \r\n 輸入資料 \r\n {1} \r\n 回傳資料 \r\n {2} ", applyTask.FormNumber, result, xDoc.ToString());

            Logger.Write("TTLog", log);  //已寫好的LOG元件

            return "";
        }

        public void OnError(Exception errorException)
        {
           // throw new NotImplementedException();
        }
    }
}
