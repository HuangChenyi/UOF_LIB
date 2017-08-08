<%@ WebHandler Language="C#" Class="WatermarkHandler" %>

using System;
using System.Data;
using System.Linq;
using System.Net.Http;
using System.Runtime.Serialization;
using System.Web;
using System.IO;
using System.Text;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Imaging;
using Ede.Uof.DMS;
using Ede.Uof.DMS.DocStore;
using Ede.Uof.DMS.PDF;
using Ede.Uof.EIP.ResourceLibrary;
using Ede.Uof.EIP.SystemInfo;
using Ede.Uof.WKF.Engine;
using Newtonsoft.Json;

public class WatermarkHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        if (string.IsNullOrEmpty(context.Request["p"]))
        {
            HandleErrorResponse(context, Encoding.UTF8.GetBytes("Request[p] is empty!"));
            return;
        }

        var jsonRequest = HttpUtility.UrlDecode(context.Request["p"]).Replace("|", "&");
        var dicRequest = JsonConvert.DeserializeObject<Dictionary<string, string>>(jsonRequest);

        // 2013-04-22 ELTON, add action check
        var action = string.Empty;
        if (!dicRequest.TryGetValue("action", out action))
        {
            var error = "Failed to get action from json[" + jsonRequest + "]";
            HandleErrorResponse(context, Encoding.UTF8.GetBytes(error));
            return;
        }

        // Delete
        if (action.Equals("delete"))
        {
            var sWatermarkPdfId = (string)dicRequest["download_pdf_id"];
            var dmsPdf = new DMSPdf();
            try
            {
                dmsPdf.DeletePDFDownload(sWatermarkPdfId, true);
            }
            catch (Exception ex)
            {
                LogFailure(ex, sWatermarkPdfId);
            }
            return;
        }

        // get parameters from p
        string docId = string.Empty, docVersion = string.Empty, viewerId = string.Empty, xpsFileId;
        var isGetDocId = dicRequest.TryGetValue("docid", out docId);
        var isGetDocVersion = dicRequest.TryGetValue("docversion", out docVersion);
        var isGetViewerId = dicRequest.TryGetValue("viewerid", out viewerId);
        var isGetXpsId = dicRequest.TryGetValue("xpsid", out xpsFileId);
        if (!isGetDocId || !isGetDocVersion || !isGetViewerId)
        {
            var error = "Failed to get doc information from json[" + jsonRequest + "]";
            LogFailure(error, docId);
            HandleErrorResponse(context, Encoding.UTF8.GetBytes(error));
            return;
        }

        // get culture
        string culture;
        dicRequest.TryGetValue("culture", out culture);
        if (string.IsNullOrEmpty(culture)) { culture = "zh-TW";}

        // 2012-12-03 ELTON, 回 UOF 抓浮水印資料
        string jsonParam = string.Empty, jsonWatermark = string.Empty, coverType = string.Empty, coverHtml = string.Empty, taskId = string.Empty;
        int watermarkWidth = 0, watermarkHeight = 0;
        bool isApprovalRecord = false, isAddDocVersionHistory = false;

        var userZone = Ede.Uof.EIP.Organization.Util.UserTime.SetZone(viewerId);
        var nowDateFormated = userZone.FromDb(userZone.GetNowForDb()).ToString();
        string modifyDateFormated;

        var dicParam = new Dictionary<string, object>();
        try
        {
            using (var helper = new DmsWatermarkHelper())
            {
                jsonParam = helper.GetDmsPdfWatermarkInformation(docId, docVersion, viewerId, culture);
                dicParam = JsonConvert.DeserializeObject<Dictionary<string, object>>(jsonParam);
                watermarkWidth = Convert.ToInt32(dicParam["watermarkwidth"]);
                watermarkHeight = Convert.ToInt32(dicParam["watermarkheight"]);
                dicParam.Add("WATERMARK_IMAGE_WIDTH", watermarkWidth);
                dicParam.Add("WATERMARK_IMAGE_HEIGHT", watermarkHeight);
                dicParam.Add("WATERMARK_IMAGE_ROTATE", Convert.ToBoolean(dicParam["rotated"]));

                object obj;
                if (dicParam.TryGetValue("COVER_TYPE", out obj))
                {
                    coverType = Convert.ToString(obj);
                }

                if (dicParam.TryGetValue("DocCoverHtml", out obj))
                {
                    coverHtml = Convert.ToString(obj);
                }

                if (dicParam.TryGetValue("WKF_APPROVAL_RECORD", out obj))
                {
                    isApprovalRecord = Convert.ToBoolean(obj);
                }

                if (dicParam.TryGetValue("WKF_TASK_ID", out obj))
                {
                    taskId = Convert.ToString(obj);
                }

                if (dicParam.TryGetValue("v_MODIFY_DATE", out obj))
                {
                    var modifyDateStr = Convert.ToString(obj);
                    DateTimeOffset modifyDateOff;
                    DateTimeOffset.TryParse(modifyDateStr, out modifyDateOff);

                    modifyDateFormated = userZone.FromDb(modifyDateOff).ToString();
                }             

                if (dicParam.TryGetValue("ADD_VERSION_HISTORY", out obj))
                {
                    isAddDocVersionHistory = Convert.ToBoolean(obj);
                }
            }
        }
        catch (Exception ex)
        {
            LogFailure(ex, docId);
            var byteArray = Encoding.UTF8.GetBytes(ex.Message + " trace:" + ex.StackTrace);
            HandleErrorResponse(context, byteArray);
            return;
        }

        // get parameters from p
        viewerId = (string)dicParam["VIEWER_ID"];
        var dmsDocId = (string)dicParam["DOC_ID"];
        var dmsDocVersion = (string)dicParam["DOC_VERSION"];
        var watermarkFont = (string)dicParam["WATERMARK_FONT"];
        var isUseCryptInterfaceDll = (bool)dicParam["USE_CRYPT_INTERFACE_DLL"];
        var isAddSummary = (bool) dicParam["ADD_PDF_SUMMARY"];

        // if add summary, get summary json from UOF
        // in UOF implement by call DLL, in Proxy implement by call WS
        if (isAddSummary || (bool)dicParam["DEF_TXT_USE"])
        {
            try
            {
                using (var helper = new DmsWatermarkHelper())
                {
                    jsonWatermark = helper.GetWatermarkInformation(dmsDocId, dmsDocVersion, viewerId, culture);
                }
            }
            catch (Exception ex)
            {
                LogFailure(ex, docId);
                var byteArray = Encoding.UTF8.GetBytes(ex.Message + " trace:" + ex.StackTrace);
                HandleErrorResponse(context, byteArray);
                return;
            }
        }

        // get rotated watermark image
        byte[] watermarkBytes = null;
        var isWatermarkRotated = false;
        try
        {
            using (var helper = new WatermarkHelper(isUseCryptInterfaceDll))
            {
                // get watermark image
                var result = helper.GetRotatedWatermarkImage(dmsDocVersion
                                                            , jsonWatermark
                                                            , dicParam
                                                            , watermarkFont);
                watermarkBytes = result.Item1;
                isWatermarkRotated = result.Item2;
            }
        }
        catch (Exception ex)
        {
            LogFailure(ex, docId);
            var byteArray = Encoding.UTF8.GetBytes(ex.Message + " trace:" + ex.StackTrace);
            HandleErrorResponse(context, byteArray);
            return;
        }


        var historyImagesCnt = 0;
        var historyImageStringList = new List<string>();

        #region Doc Version History Image

        if (isAddSummary && isAddDocVersionHistory)
        {
            var uco = new DocHistoryUCO();
            var table = uco.GetPublishDocHistoryRecordForViewer(docId, culture);
            var historyText = ResourceHelper.Exec(culture, @"DMSVersionHistory");
            var versionImages = WatermarkHelper.GetDocVersionImage(table
                                                                , watermarkWidth
                                                                , watermarkHeight
                                                                , culture
                                                                , historyText
                                                                ,viewerId);
            if (versionImages != null)
            {
                historyImagesCnt += versionImages.Count;

                if (versionImages.Any())
                {
                    historyImageStringList = versionImages.Select(
                        bytes => Convert.ToBase64String(bytes, Base64FormattingOptions.InsertLineBreaks)).ToList();
                }
            }
        }

        #endregion


        #region get wkf sign comment

        var internalSiteUrl =
            string.Format("{0}{1}",
                context.Request.Url.GetLeftPart(UriPartial.Authority),
                VirtualPathUtility.ToAbsolute("~/"));
                
        if (isAddSummary && isApprovalRecord)
        {
            var formNumber = string.Empty;
            if (!string.IsNullOrEmpty(taskId))
            {
                var task = new Task(taskId);
                if (task != null)
                {
                    formNumber = task.FormNumber;
                }
            }

            if (!string.IsNullOrEmpty(formNumber))
            {
                Uri commentUri = null;
                var url = string.Format("{0}/dms/service/GetSignComment.aspx?id={1}&c={2}&userid={3}"
                    , internalSiteUrl
                    , taskId
                    , culture
                    ,viewerId);

                if (Uri.TryCreate(url, UriKind.Absolute, out commentUri))
                {
                    using (var client = new HttpClient())
                    {
                        var response = client.GetAsync(url).Result;

                        if (response.IsSuccessStatusCode)
                        {
                            // by calling .Result you are performing a synchronous call
                            var responseContent = response.Content;

                            // by calling .Result you are synchronously reading the result
                            var responseString = responseContent.ReadAsStringAsync().Result;
                            var table = JsonConvert.DeserializeObject<DataTable>(responseString);

                            var dicSummary = JsonConvert.DeserializeObject<Dictionary<string, object>>(jsonWatermark);

                            var recordText = (string) dicSummary["Resource.WKFSignInfo"];
                            var siteText = (string) dicSummary["Resource.WKFSite"];
                            var approverText = (string) dicSummary["Resource.WKFActualSigner"];
                            var statusText = (string) dicSummary["Resource.WKFSignStatus"];
                            var timeText = (string) dicSummary["Resource.WKFMailSignTime"];
                            var numberText = (string) dicSummary["Resource.DMSFormNumber"];
                            var signatureText = (string) dicSummary["Resource.DMSElectronicSignature"];

                            var historyImages = WatermarkHelper.GetDocApproveImage(table
                                                                                    , recordText
                                                                                    , numberText
                                                                                    , siteText
                                                                                    , approverText
                                                                                    , timeText
                                                                                    , statusText
                                                                                    , signatureText
                                                                                    , formNumber
                                                                                    , watermarkWidth
                                                                                    , watermarkHeight
                                                                                    , internalSiteUrl);

                            if (historyImages != null)
                            {
                                historyImagesCnt += historyImages.Item1;

                                if (historyImages.Item1 > 0)
                                {
                                    historyImageStringList.AddRange(
                                        historyImages.Item2.Select(
                                            bytes =>
                                                Convert.ToBase64String(bytes, Base64FormattingOptions.InsertLineBreaks))
                                            .ToList());
                                }
                            }
                        }
                    }
                }
            }
        }

        #endregion

        #region action=m, 只丟 pdf 檔給 UOF-M 下載

        if (action.Equals("m"))
        {
            using (var helper = new WatermarkHelper(isUseCryptInterfaceDll))
            {
                var pdfBytes = helper.AddWatermarkToPdfWithWpf(dmsDocVersion
                                                                , jsonWatermark
                                                                , dicParam
                                                                , watermarkFont
                                                                , coverType
                                                                , coverHtml
                                                                , historyImagesCnt
                                                                , historyImageStringList);

                var name = dicParam["v_DOC_NAME"].ToString();
                var dotIndex = name.IndexOf(".");
                if (dotIndex > -1)
                {
                    name = name.Substring(0, dotIndex);
                }
                name += ".pdf";

                context.Response.AddHeader("content-disposition", "attachment;filename=" + context.Server.UrlPathEncode(name));
                context.Response.ContentType = "application/pdf ";
                context.Response.AddHeader("Content-Length", pdfBytes.Length.ToString());
                context.Response.BinaryWrite(pdfBytes);
                context.Response.End();

                return;
            }
        }

        #endregion


        // 用 DataContractSerializer 將 List<byte[]> 序列化成 byte[] 傳給 silverlight                    
        var list = new List<byte[]> {null, watermarkBytes};
        switch (action)
        {
            case "watermark":
                context.Response.BinaryWrite(watermarkBytes);
                context.Response.End();
                break;

            case "pdf":
                using (var helper = new WatermarkHelper(isUseCryptInterfaceDll))
                {
                    var pdfBytes = helper.AddWatermarkToPdfWithWpf(dmsDocVersion
                                                                    , jsonWatermark
                                                                    , dicParam
                                                                    , watermarkFont
                                                                    , coverType
                                                                    , coverHtml
                                                                    , historyImagesCnt
                                                                    , historyImageStringList);
                    var name = dicParam["v_DOC_NAME"].ToString();
                    var dotIndex = name.IndexOf(".");
                    if (dotIndex > -1)
                    {
                        name = name.Substring(0, dotIndex);
                    }
                    name += ".pdf";

                    context.Response.AddHeader("content-disposition", string.Format("attachment;filename=\"{0}\"", context.Server.UrlPathEncode(name)));
                    context.Response.ContentType = @"application/pdf";
                    context.Response.AddHeader("Content-Length", pdfBytes.Length.ToString());
                    context.Response.BinaryWrite(pdfBytes);
                    context.Response.End();
                }
                break;

            default:
                using (var ms = new MemoryStream())
                {
                    var serializer = new DataContractSerializer(typeof (List<byte[]>));
                    serializer.WriteObject(ms, list);

                    context.Response.BinaryWrite(ms.ToArray());
                    context.Response.End();
                }
                break;
        }

    }

    static void HandleErrorResponse(HttpContext context, byte[] errorBytes)
    {
        var listError = new List<byte[]> {errorBytes};

        var serializer = new DataContractSerializer(typeof(List<byte[]>));
        using (var ms = new MemoryStream())
        {
            serializer.WriteObject(ms, listError);

            context.Response.Clear();
            context.Response.BinaryWrite(ms.ToArray());
            context.Response.End();
        }
    }

    static void LogFailure(Exception exception, string docId)
    {
        Ede.Uof.Utility.Log.Logger.Write("AddWatermark", @"DocID：{1}，error: {0}", exception.Message + " " + exception.StackTrace, docId);
    }

    static void LogFailure(string sMessage, string docId)
    {
        Ede.Uof.Utility.Log.Logger.Write("AddWatermark", @"DocID：{1}，error:{0}", sMessage, docId);
    }

    public bool IsReusable
    {
        get { return false; }
    }
}
