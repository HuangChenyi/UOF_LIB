<%@ WebService Language="C#" Class="DcsService" %>

using System;
using System.Collections.Generic;
using System.Configuration;
using System.Net;
using System.Web;
using System.Web.Services;
using Ede.Uof.DMS;
using Ede.Uof.Utility;
using Ede.Uof.Utility.Page.Common;
using Newtonsoft.Json;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// 若要允許使用 ASP.NET AJAX 從指令碼呼叫此 Web 服務，請取消註解下列一行。
// [System.Web.Script.Services.ScriptService]
public class DcsService  : System.Web.Services.WebService {

    [WebMethod]
    public void AddDcsJob(string docId, string docVersion)
    {
        var doc = new DMSDoc(docId, docVersion);
        var dmsPdf = new DMSPdf();
        
        dmsPdf.DecryptSourceAsync(doc.v_FILE_ID, isFromBatch: true);
    }

    [WebMethod]
    public int GetDcsJob(string action)
    {
        var lic = new License(License.GetLicenseFilePath());
        string cus = string.IsNullOrEmpty(lic.CustomerId) ? lic.CompanyName : lic.CustomerId;
        string sub = lic.SubId;

        using (var client = GetWebClient())
        {
            if (client != null)
            {
                var result = client.DownloadString(string.Format("dynamic/{0}/{1}/{2}"
                    , action
                    , HttpUtility.UrlEncode(cus)
                    , HttpUtility.UrlEncode(sub)));

                var list = JsonConvert.DeserializeObject<List<dynamic>>(result);
                return list.Count;
            }
            return 0;
        }
    }

    private WebClient GetWebClient()
    {
        var serviceUrl = ConfigurationManager.AppSettings.Get("DocEngineSerivceUrl");
        
        if (Uri.IsWellFormedUriString(serviceUrl, UriKind.Absolute))
        {
            return new WebClient
            {
                Encoding = System.Text.Encoding.UTF8,
                BaseAddress = serviceUrl
            };
        }

        return null;
    }
}