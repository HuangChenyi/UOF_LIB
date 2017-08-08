<%@ WebService Language="C#" Class="BegainOverTimeCancel" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;

[WebService(Namespace = "http://www.1st-excellence.com")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
public class BegainOverTimeCancel  : System.Web.Services.WebService {

    [WebMethod]
    public string CheckOverTimeCancel(string formInfo) 
    {
        formInfo = HttpUtility.UrlDecode(formInfo);
        Ede.Uof.WKF.DutyForm.OverTime.OverTimeUCO overTimeUCO = new Ede.Uof.WKF.DutyForm.OverTime.OverTimeUCO();

        return overTimeUCO.BegainOverTimeCancelWS(formInfo);
    }     
}