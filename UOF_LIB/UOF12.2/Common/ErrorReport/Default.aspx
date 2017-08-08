<%@ Page Language="C#" AutoEventWireup="true" Inherits="Common_ErrorReport_Default" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="Default.aspx.cs" %>

<!DOCTYPE html>
<html>
    <head runat="server">
        <meta http-equiv="X-UA-Compatible" content="IE=edge" >
        <title>Error Report</title>    
        <link href="../../App_Themes/DefaultTheme/StyleSheet.css" type="text/css" rel="stylesheet" />
        <style>
            pre {
                white-space: pre-wrap; /* css-3 */
white-space: -moz-pre-wrap; /* Mozilla, since 1999 */
white-space: -pre-wrap; /* Opera 4-6 */
white-space: -o-pre-wrap; /* Opera 7 */
word-wrap: break-word; /* Internet Explorer 5.5+ */
            }
        </style>
    </head>
<body>
    <form id="form1" runat="server">
         <telerik:RadScriptManager  ID="ScriptManager1" runat="server" EnablePageMethods="True" AsyncPostBackTimeOut="36000" >
             <Scripts>
            <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.Core.js" />
                <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQuery.js" />
                <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQueryInclude.js" />
        </Scripts>
    </telerik:RadScriptManager>
       <table  class="PopTable" style="width: 1000px;margin: 0 auto">
            <tr>
                <td colspan="2" style="text-align: left;width: 1024px;">
                    <asp:Label ID="Desc" runat=server ForeColor="Red" meta:resourcekey="DescResource1" Text="發生尚未處理的錯誤"></asp:Label>
                </td>
            </tr>
            <tr>
                <td nowrap >
                    <asp:Label ID="Label1" runat="server" Text="錯誤內容" meta:resourcekey="Label1Resource1"></asp:Label></td>
                <td style="width: 800px">
                    <pre contenteditable="true" STYLE="width:800px;left:0;"><asp:Literal ID="ltErrorMessage" runat="server"></asp:Literal></pre>
                    <asp:Literal ID="ltVerson" runat="server"></asp:Literal>

                </td>
            </tr>
            <tr>
                <td>
                    <span style="color: #ff0000">
                    *</span><asp:Label ID="Label2" runat="server" Text="請詳細說明您做了那些操作而遇到此錯誤" meta:resourcekey="Label2Resource1"></asp:Label></td>
                <td STYLE="word-wrap:break-word;width:800px;left:0">
                    <asp:TextBox ID="TextBoxDesc" runat="server" Columns="80" Rows="10" TextMode="MultiLine" meta:resourcekey="TextBoxDescResource1"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="TextBoxDesc"
                        Display="Dynamic" ErrorMessage="請輸入說明" meta:resourcekey="RequiredFieldValidator1Resource1"></asp:RequiredFieldValidator></td>
            </tr>
            <tr>
                <td>
                </td>
                <td>
                    <asp:Button ID="Button1" runat="server" Text="將錯誤回報給系統管理員" OnClick="Button1_Click" meta:resourcekey="Button1Resource1" />
                    <asp:CustomValidator ID="cvFail" runat="server" Display="Dynamic" ErrorMessage="很抱歉回報失敗,無法自動將內容傳送給系統管理員,請您將錯誤訊息複製到電子郵件中傳送給系統管理員" meta:resourcekey="cvFailResource1"></asp:CustomValidator>
                    <asp:CustomValidator ID="cvSuccess" runat="server" Display="Dynamic" ErrorMessage="回報完成,感謝您的協助,請關閉視窗或回到上一頁繼續完成您的工作" meta:resourcekey="cvSuccessResource1"></asp:CustomValidator></td>
            </tr>
        </table>
    </form>
</body>
</html>
