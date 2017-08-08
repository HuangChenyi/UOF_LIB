<%@ WebHandler Language="C#" Class="PdfViewerSLDeleteHandler" %>

using System;
using System.IO;
using System.Web;
using Ede.Uof.Utility;
using Ede.Uof.Web.DMS.DocStore;

public class PdfViewerSLDeleteHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        // delete temp pdf/xps from uof temp folder
        var uniqueId = context.Request["uid"];
        try
        {
            File.Delete(PathHelper.GetUofTempFile(uniqueId) + ".p");
        }
        catch { }

        try
        {
            File.Delete(PathHelper.GetUofTempFile(uniqueId) + ".x");
        }
        catch { }
        
        try
        {
            PdfImageViewer.RemoveWatermark(uniqueId);
        }
        catch { }
    }

    public bool IsReusable {get { return false; }}
}