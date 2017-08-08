<%@ Page Language="C#" culture="auto" meta:resourcekey="PageResource1" uiculture="auto" %>

<%@ Import Namespace="Ede.Uof.EIP.SystemInfo" %>
<%@ Import Namespace="Ede.Uof.EIP.PrivateMessage.Exceptions" %>
<%@ Import Namespace="Ede.Uof.EIP.PrivateMessage" %>

<script runat="server">
    
    protected string themePath;

    protected void Page_Load(object sender, EventArgs e)
    {
        string tempUrl = Request["r"];
        if (string.IsNullOrEmpty(tempUrl))
        {
            Response.Redirect(Request.ApplicationPath);
        }
        else
        {

            try
            {
                string path = MessageLinkHelper.GetRealUrl(tempUrl);
                Response.Redirect(path);
            }
            catch (UrlExpiredExpection)
            {
                cvUrl.ErrorMessage = lbLinkEXpired.Text;
                cvUrl.IsValid = false;
            }
            catch (FormatException)
            {
                cvUrl.ErrorMessage = lbLinkError.Text;
                cvUrl.IsValid = false;
            }


        }

        themePath = Request.ApplicationPath + "/App_Themes/" + Page.Theme;
    }

    protected void Page_PreInit(object sender, EventArgs e)
    {


        string theme = string.Empty;
        if (Request.Cookies["UOFSettings"] != null)
        {
            if (Request.Cookies["UOFSettings"]["UserTheme"] != null)
                theme = Request.Cookies["UOFSettings"]["UserTheme"];
        }

        if (!string.IsNullOrEmpty(theme))
        {
            Page.Theme = Request.Cookies["EB_Theme"].Value;
        }
        else
        {

            Page.Theme = Current.Theme;
        }      


    }


</script>

<html>
<head id="Head1" runat="server" />
<body>
    <form id="form1" runat="server">
    <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="tbbg01">
        <tr>
            <td >
                <table border="0" cellpadding="0" cellspacing="0" width="50%" align="center">
        <tr>
            <td style="height: 23px" width="15">
                <img src="<%=themePath %>/images/tab21.gif" width="15" /></td>
            <td background="<%=themePath %>/images/tab22.gif" class="e" style="height: 23px"
                valign="baseline">
                <asp:Label ID="Label1" runat="server" Text="快速連結" 
                    meta:resourcekey="Label1Resource1"></asp:Label></td>
            <td style="height: 23px" width="15">
                <img height="23" src="<%=themePath %>/images/tab23.gif" width="15" /></td>
        </tr>
        <tr>
            <td>
                <img height="9" src="<%=themePath %>/images/tab24.gif" width="15" /></td>
            <td background="<%=themePath %>/images/tab25.gif">
                <img height="9" src="<%=themePath %>/images/tab25.gif" width="1" /></td>
            <td>
                <img height="9" src="<%=themePath %>/images/tab26.gif" width="15" /></td>
        </tr>
        <tr>
            <td background="<%=themePath %>/images/tab27.gif" valign="top">
                <img height="1" src="<%=themePath %>/images/tab27.gif" width="15" /></td>
            <td align="center" bgcolor="#ffffff">
                            <br />
                            <asp:CustomValidator ID="cvUrl" runat="server" Display="Dynamic" 
                                meta:resourcekey="cvUrlResource1"></asp:CustomValidator>
                            <br />
                            <br />
                            <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~" Target="_top" 
                                meta:resourcekey="HyperLink1Resource1">按這裡回到首頁</asp:HyperLink>
                            <br />
                         </td>
            <td background="<%=themePath %>/images/tab28.gif" valign="top">
                <img height="1" src="<%=themePath %>/images/tab28.gif" width="15" /></td>
        </tr>
        <tr>
            <td><img height="18" src="<%=themePath %>/images/tab29.gif" width="15" /></td>
            <td background="<%=themePath %>/images/tab30.gif">&nbsp;</td>
            <td><img height="18" src="<%=themePath %>/images/tab31.gif" width="15" /></td>
        </tr>
    </table>
    </td>
    </tr>
    
    </table>
    <asp:Label ID="lbLinkEXpired" runat="server" Visible="False" Text="連結已過期無法使用" 
        meta:resourcekey="lbLinkEXpiredResource1"></asp:Label>
    <asp:Label ID="lbLinkError" runat="server" Visible="False" Text="連結內容錯誤無法使用" 
        meta:resourcekey="lbLinkErrorResource1"></asp:Label>
    </form>
</body>
</html>
