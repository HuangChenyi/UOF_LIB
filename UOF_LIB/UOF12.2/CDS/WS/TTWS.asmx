<%@ WebService Language="C#" Class="TTWS" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Xml.Linq;
using System.Linq;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// 若要允許使用 ASP.NET AJAX 從指令碼呼叫此 Web 服務，請取消註解下列一行。
// [System.Web.Script.Services.ScriptService]
public class TTWS  : System.Web.Services.WebService {

    [WebMethod]
    public string SendTipTopForm(string xml)
    {
        Lib.TipTop.WKFFormUtil wkf = new Lib.TipTop.WKFFormUtil();
        string log = "";
        try
        {
            log += "傳入的XML" + xml+"\r\n";
            // Ede.Uof.Utility.Log.Logger.Write("TTFormLog", "傳入的XML" + xml);
            string formXML = wkf.ConvertUOFFormXml(xml);

            Ede.Uof.WKF.Utility.TaskUtilityUCO uco = new Ede.Uof.WKF.Utility.TaskUtilityUCO();

            //接收回傳訊息
            string result = uco.WebService_CreateTask(formXML);
            // Ede.Uof.Utility.Log.Logger.Write("TTFormLog", "完成起單作業的XML" + result);
            log += "完成起單作業的XML" + result+"\r\n";
            XElement resultXe = XElement.Parse(result);

            if (resultXe.Element("Status").Value == "1")
            {
                XElement inputElement = XElement.Parse(xml);
                //起單成功
                var logOnInfoElement = inputElement.Element("LogOnInfo");
                var formElement =  inputElement.Element("RequestContent").Element("Form");

                string SenderIP = logOnInfoElement.Element("SenderIP").Value ;
                string ReceiverIP = logOnInfoElement.Element("ReceiverIP").Value;
                string PlantID = formElement.Element("PlantID").Value;
                string ProgramID = formElement.Element("ProgramID").Value;
                string SourceFormID = formElement.Element("SourceFormID").Value;
                string SourceFormNum = formElement.Element("SourceFormNum").Value;
                string Date = DateTime.Now.ToString("yy/MM/dd");
                string Time = DateTime.Now.ToString("HH:mm:ss");
                string Status = "1";
                string FormCreatorID = formElement.Element("FormCreatorID").Value;
                string FormOwnerID = formElement.Element("FormOwnerID").Value;
                string TargetFormID = "";
                string TargetSheetNo = "";
                string ProcessSNo = "";
                string Description = "";
                string ActionStatus = "Y";
                string ActionDescribe = "Success";
                string TPServerIP = "192.168.10.212";
                string TPServerEnv = "toptest";


                XElement xe = new XElement("Response"
                                                , new XElement("ResponseType", "CreateForm")
                                                 , new XElement("ResponseInfo"
                                                            , new XElement("SenderIP", SenderIP)
                                                            , new XElement("ReceiverIP", ReceiverIP))
                                                 , new XElement("ResponseContent"
                                                            , new XElement("ReturnInfo"
                                                                    , new XElement("ReturnStatus", "Y")
                                                                    , new XElement("ReturnDescribe", "NO ERROR")))
                                                            , new XElement("ContentText"
                                                                    , new XElement("Form"
                                                                           , new XElement("StatSlip")
                                                                           , new XElement("PlantID",PlantID)
                                                                           , new XElement("ProgramID",ProgramID)
                                                                           , new XElement("SourceFormID",SourceFormID)
                                                                           , new XElement("SourceFormNum",SourceFormNum)
                                                                           , new XElement("Date",Date)
                                                                           , new XElement("Time",Time)
                                                                           , new XElement("Status",Status)
                                                                           , new XElement("FormCreatorID",FormCreatorID)
                                                                           , new XElement("FormOwnerID",FormOwnerID)
                                                                           , new XElement("TargetFormID",TargetFormID)
                                                                           , new XElement("TargetSheetNo",TargetSheetNo)
                                                                           , new XElement("ProcessSNo",ProcessSNo)
                                                                           , new XElement("Description",Description)
                                                                           , new XElement("ActionStatus",ActionStatus)
                                                                           , new XElement("ActionDescribe",ActionDescribe)
                                                                           , new XElement("TPServerIP",TPServerIP)
                                                                           , new XElement("TPServerEnv",TPServerEnv)
                                                                           )
                                                                           )
                                                                    );

                log += "回傳的XML" + xe.ToString()+"\r\n";
                Ede.Uof.Utility.Log.Logger.Write("TTFormLog",log);
                return xe.ToString();
            }
            else
            {
                //起單失敗

                log += "起單失敗"+resultXe.Element("Exception").Element("Message").Value+"\r\n";

                Ede.Uof.Utility.Log.Logger.Write("TTFormLog",log);
                return "";
            }


        }
        catch (Exception ce)
        {
            log += "發生例外"+ce.ToString()+"\r\n";
            Ede.Uof.Utility.Log.Logger.Write("TTFormLog",log);
            return "";
        }
    }

    [WebMethod]
    public string GetCreateTTFormXML(string xml)
    {
        Lib.TipTop.WKFFormUtil wkf = new Lib.TipTop.WKFFormUtil();
        try
        {
            string formXML = wkf.ConvertUOFFormXml(xml);

            return formXML;
        }
        catch (Exception ce)
        {
            return ce.ToString();
        }
    }

}