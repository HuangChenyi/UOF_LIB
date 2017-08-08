<%@ WebHandler Language="C#" Class="DownloadfileAshx" %>

using System.Text;
using System.Web;
using Ede.Uof.Utility.FileCenter.V3;

public class DownloadfileAshx : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        var fileId = context.Request["id"];
        if (!string.IsNullOrEmpty(fileId))
        {
            var isGetEnc = false; // get encrypted file
            if (!string.IsNullOrEmpty(context.Request["enc"]))
            {
                isGetEnc = context.Request["enc"].Equals("1");
            }

            // if Authenticated, redirect to Common/FileCenterV3/FileControlHandler.ashx (support proxy)
            if (!isGetEnc && context.User.Identity.IsAuthenticated)
            {
                context.Response.Redirect(VirtualPathUtility.ToAbsolute(string.Format(FileCenterSetting.DefaultFileControlHandler, fileId)));
                context.Response.End();
                return;
            }

            // if get enc or without Authenticated, redirect to Common/FileCenterV3/DownloadHandler.ashx
            var file = FileCenter.GetFile(fileId);
            var builder = new StringBuilder();
            builder.Append(file.Locations.Get().GetAbsoluteUri(FileCenterSetting.DefaultName, useVirtualPath: true, resizeTo: ImageResizeTo.NotSet));
            builder.Append("&act=");
            builder.Append(isGetEnc ? "enc" : string.Empty);
            builder.Append("&inline=");
            builder.Append(context.Request["inline"] ?? string.Empty);
            builder.Append("&exists=");
            builder.Append(context.Request["exists"] ?? string.Empty);

            context.Response.Redirect(builder.ToString());
        }

        context.Response.StatusCode = 404;
        context.Response.End();
    }

    public bool IsReusable
    {
        get { return false; }
    }

}