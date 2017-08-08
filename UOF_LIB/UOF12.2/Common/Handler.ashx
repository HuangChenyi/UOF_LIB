<%@ WebHandler Language="C#" Class="Handler" %>

using System;
using System.Threading;
using System.Web;
using Telerik.Web.UI;
using System.Data;
using System.Drawing;
using System.Drawing.Imaging;
using System.Data.SqlClient;
using System.IO;

public class Handler : AsyncUploadHandler, System.Web.SessionState.IRequiresSessionState
{

    protected override IAsyncUploadResult Process(UploadedFile file, HttpContext context, IAsyncUploadConfiguration configuration, string tempFileName)
    {
        //var queryStringParam1 = context.Request.QueryString["saveToFolder"];
        string targetFolder = context.Server.MapPath("~/Uploads/");
        string fileName = file.GetName();
        
        var result = CreateDefaultUploadResult<CustomAsyncUploadResult>(file);
        try
        {
            // STORE FILE IN DATABASE
            file.SaveAs(targetFolder + fileName);
        }
        catch (Exception e)
        {
            result.ErrorMessage = e.Message;
        }

        return result;
    }
}

public class CustomAsyncUploadResult : AsyncUploadResult
{
    public string ErrorMessage { get; set; }
}