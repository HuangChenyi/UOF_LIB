<%@ WebService Language="C#" Class="BeginLeaveCancel" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;

[WebService(Namespace = "http://www.1st-excellence.com")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
public class BeginLeaveCancel  : System.Web.Services.WebService {

    [WebMethod]
    public string CheckLeaveCancel(string formInfo)
    {
        formInfo = HttpUtility.UrlDecode(formInfo);
        Ede.Uof.WKF.DutyForm.Leave.LeaveUCO lformUCO = new Ede.Uof.WKF.DutyForm.Leave.LeaveUCO();
        return lformUCO.BeginLeaveCancelWS(formInfo);
    }    
}