<%@ WebService Language="C#" Class="WatermarkInformationService" %>

using System.Collections.Generic;
using System.Web.Services;
using Ede.Uof.DMS;

[WebService(Namespace = "http://www.edetw.com/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
public class WatermarkInformationService : WebService
{
    [WebMethod]
    public string GetDmsPdfWatermarkInformation(string sDocId, string sDocVersion, string sViewerId, string culture)
    {
        using (var helper = new DmsWatermarkHelper())
        {
            return helper.GetDmsPdfWatermarkInformation(sDocId, sDocVersion, sViewerId, culture);
        }
    }

    [WebMethod]
    public string GetWatermarkInformation(string sDocId, string sDocVersion, string sViewerId, string culture)
    {
        using (var helper = new DmsWatermarkHelper())
        {
            return helper.GetWatermarkInformation(sDocId, sDocVersion, sViewerId, culture);
        }
    }

    [WebMethod]
    public string GetPublishDocHistoryRecordForViewer(string docId, string culture)
    {
        var uco = new Ede.Uof.DMS.DocStore.DocHistoryUCO();
        return Newtonsoft.Json.JsonConvert.SerializeObject(uco.GetPublishDocHistoryRecordForViewer(docId, culture));
    }

    [WebMethod]
    public string GetDmsResourseText(string culture)
    {
        var historyText = Ede.Uof.EIP.ResourceLibrary.ResourceHelper.Exec(culture, @"DMSVersionHistory");
        var dic = new Dictionary<string, string> {{"DMSVersionHistory", historyText}};

        return Newtonsoft.Json.JsonConvert.SerializeObject(dic);
    }
}