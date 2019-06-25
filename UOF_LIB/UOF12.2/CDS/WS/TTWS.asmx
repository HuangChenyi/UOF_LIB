<%@ WebService Language="C#" Class="TTWS" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// 若要允許使用 ASP.NET AJAX 從指令碼呼叫此 Web 服務，請取消註解下列一行。
// [System.Web.Script.Services.ScriptService]
public class TTWS  : System.Web.Services.WebService {

    [WebMethod]
    public string SenTipTopForm(string xml)
    {
        Lib.TipTop.WKFFormUtil wkf = new Lib.TipTop.WKFFormUtil();
        try
        {
            string formXML = wkf.ConvertUOFFormXml(xml);

            Ede.Uof.WKF.Utility.TaskUtilityUCO uco = new Ede.Uof.WKF.Utility.TaskUtilityUCO();

            return uco.WebService_CreateTask(formXML);
        }
        catch (Exception ce)
        {
            return ce.ToString();
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