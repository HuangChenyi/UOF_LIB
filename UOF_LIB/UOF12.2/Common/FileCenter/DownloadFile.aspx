<%@ Import Namespace="Ede.Uof.Utility.FileCenter.V3" %>
<script language="C#" runat="server">
    public void Page_Load(object sender, EventArgs e)
    {
        /* Redirect to Common/FileCenterV3/FileControlHandler.ashx
         * 1.確認系統及使用者 Proxy 設定
         * 2.決定是由 UOF 本地端或是 Proxy 端 DownloadHandler 丟出檔案供下載
         */
        var url = ResolveUrl(string.Format(FileCenterSetting.DefaultFileControlHandler, Request["id"]));
        if (!string.IsNullOrEmpty(Request["inline"]))
        {
            url += "&inline=" + Request["inline"];
        }
        if (!string.IsNullOrEmpty(Request["exists"]))
        {
            url += "&exists=" + Request["exists"];
        }
        Response.Redirect(url);
    }

</script>
