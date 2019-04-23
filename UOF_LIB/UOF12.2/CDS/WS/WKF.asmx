<%@ WebService Language="C#" Class="WKF" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.IO;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// 若要允許使用 ASP.NET AJAX 從指令碼呼叫此 Web 服務，請取消註解下列一行。
// [System.Web.Script.Services.ScriptService]
public class WKF  : System.Web.Services.WebService {


    Ede.Uof.EIP.Security.WebService.Authentication m_webserviceAuth = new Ede.Uof.EIP.Security.WebService.Authentication();

    /// <summary>
    /// 儲存的目地
    /// </summary>
    public enum FileTarget
    {
        /// <summary>
        /// 相簿
        /// </summary>
        Album,
        /// <summary>
        /// 我的公事包
        /// </summary>
        Briefcase,
        /// <summary>
        /// 公告
        /// </summary>
        Bulletin,
        /// <summary>
        /// 文件管理 (Source 檔)
        /// </summary>
        DMS_SOURCE,
        /// <summary>
        /// 系統
        /// </summary>
        EIP,
        /// <summary>
        /// 討論區
        /// </summary>
        Forum,
        /// <summary>
        /// 影音
        /// </summary>
        OMS,
        /// <summary>
        /// 個人資訊
        /// </summary>
        Personal,
        /// <summary>
        /// 專案管理
        /// </summary>
        PMS,
        /// <summary>
        /// 私人訊息
        /// </summary>
        PrivateMessage,
        /// <summary>
        /// 問卷調查
        /// </summary>
        QUE,
        /// <summary>
        /// 電子簽核
        /// </summary>
        WKF,
        /// <summary>
        /// 聊天室
        /// </summary>
        UChat
    }



    [WebMethod]
    public string CopyFileSessionToWKFTempFolder(string token,FileTarget fileTarget, string fileSessionId, string fileName ) {



        //========= 從認證 Token 取得 USER_GUID ========
        string userGuid = null;
        try
        {
            userGuid = m_webserviceAuth.GetUserGuidFromToken(token);
        }
        catch { }

        if (userGuid == null)
        {
            throw new Exception("[EBSystem] CopyFileSessionToWKFTempFolder() : Token is invalid, please check your authentication !");
        }

        string pathStr = GetTempPath(fileTarget);
        string tempFileStr = String.Format("{0}\\{1}.tmp", pathStr, fileSessionId);


        string WKFFolder = System.Configuration.ConfigurationManager.AppSettings["wkfFileTransferTemp"];


        //確認年是否存在
        DirectoryInfo dirInfo = new DirectoryInfo(string.Format("{0}\\{1}" , WKFFolder, DateTime.Today.Year.ToString()));

        if(!dirInfo.Exists)
        {
            dirInfo.Create();
        }
        //確認月是否存在
        dirInfo = new DirectoryInfo(string.Format("{0}\\{1}\\{2}" , WKFFolder, DateTime.Today.Year.ToString(), DateTime.Today.Month.ToString("d2")));

        if (!dirInfo.Exists)
        {
            dirInfo.Create();
        }
        if(!dirInfo.Exists)
        {
            dirInfo.Create();
        }

        FileInfo info = new FileInfo(string.Format("{0}\\{1}\\{2}\\{3}" , WKFFolder, DateTime.Today.Year.ToString(), DateTime.Today.Month.ToString("d2"), fileName));

        string convertFileName = info.FullName;
        //判斷檔案是否存在

        if (info.Exists)
        {
            throw new Exception("[EBSystem] CopyFileSessionToWKFTempFolder() :File is Exists !");
        }

        info = new FileInfo(tempFileStr);

            info.CopyTo(convertFileName);

            info.Delete();
        return   convertFileName.Replace(WKFFolder,"");
        // return fileIdStr;
    }

    private string GetTempPath(FileTarget fileTarget)
    {
        string pathStr = "";
        switch (fileTarget)
        {
            case FileTarget.Album:
                pathStr = @"ALBUM";
                break;
            case FileTarget.Briefcase:
                pathStr = @"BRIEFCASE";
                break;
            case FileTarget.Bulletin:
                pathStr = @"BULLETIN";
                break;
            case FileTarget.DMS_SOURCE:
                pathStr = @"DMS_SOURCE";
                break;
            case FileTarget.EIP:
                pathStr = @"EIP";
                break;
            case FileTarget.Forum:
                pathStr = @"FORUM";
                break;
            case FileTarget.OMS:
                pathStr = @"OMS";
                break;
            case FileTarget.Personal:
                pathStr = @"PERSONAL";
                break;
            case FileTarget.PrivateMessage:
                pathStr = @"PRIVATEMESSAGE";
                break;
            case FileTarget.QUE:
                pathStr = @"QUE";
                break;
            case FileTarget.UChat:
                pathStr = @"UCHAT";
                break;
            case FileTarget.WKF:
                pathStr = @"WKF";
                break;
        }

        // 可能的暫存目錄
        // Ex: C:\WINDOWS\Temp\ALBUM_TEMP
        string tempPathStr = String.Format("{0}\\{1}_TEMP", Path.GetTempPath(), pathStr);

        return tempPathStr;
    }




}