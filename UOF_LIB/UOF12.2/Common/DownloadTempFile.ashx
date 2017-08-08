<%@ WebHandler Language="C#" Class="DownloadReport" %>

using System;
using System.IO;
using System.Web;

public class DownloadReport : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
      
        int bufferSize = 4096;
        try
        {
            string file = context.Request["file"];
            string fileName = context.Request["filename"];
            string fileExt=Path.GetExtension(file).ToLower();
            string contentType = "";
            if(fileExt==".xls")
            {
                contentType = "application/ms-excel";
            }
            else if(fileExt==".pdf")
            {
                contentType = "application/pdf";
            }
            else if(fileExt==".gif")
            {
                contentType = "image/gif";
            }
            else if(fileExt==".jpg" || fileExt==".jpeg")
            {
                contentType = "image/jpeg";
            }
            else if(fileExt==".tiff")
            {
                contentType = "image/tiff";
            }
            else if(fileExt==".doc")
            {
                contentType = "application/msword";
            }
            else if(fileExt==".rtf")
            {
                contentType = "application/rtf";
            }
            else if(fileExt==".zip")
            {
                contentType = "application/zip";
            }
            
            string fullFileName = Path.Combine(Path.GetTempPath(), file);
            FileInfo fi=new FileInfo(fullFileName);

            long filesize = fi.Length;
            
            using (Stream s = new FileStream(fullFileName, FileMode.Open, FileAccess.Read, FileShare.Read, bufferSize))
            {
                byte[] buffer = new byte[bufferSize];
                int count = 0;
                int offset = 0;

                if (context.Request.Browser.Browser == "InternetExplorer" || context.Request.Browser.Browser == "IE" || context.Request.Browser.Browser == "Mozilla")
                {
                    fileName = context.Server.UrlPathEncode(fileName);
                }
                else if (context.Request.UserAgent != null && context.Request.UserAgent.ToLower().Contains("edge"))
                {
                    fileName = context.Server.UrlPathEncode(fileName);
                }

                context.Response.AddHeader("content-disposition", "attachment;filename=\"" + fileName +"\"");
                context.Response.ContentType = contentType;
                context.Response.AddHeader("Content-Length", filesize.ToString());

                while ((count = s.Read(buffer, offset, buffer.Length)) > 0)
                {
                    context.Response.OutputStream.Write(buffer, offset, count);
                    context.Response.Flush();
                }


            }
        }
        catch 
        {}
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}