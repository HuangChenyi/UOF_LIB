<%@ WebHandler Language="C#" Class="DownloadLicenseAshx" %>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;


    /// <summary>
    /// DownloadLicense 的摘要描述
    /// </summary>
    public class DownloadLicenseAshx : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ClearContent();
            context.Response.Clear();
            context.Response.ContentType = "text/plain";
            context.Response.AddHeader("Content-Disposition",
                               "attachment; filename=License.xml;");
            context.Response.TransmitFile(context.Server.MapPath("~/app_data/license.xml"));
            context.Response.Flush();
            context.Response.End();
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
