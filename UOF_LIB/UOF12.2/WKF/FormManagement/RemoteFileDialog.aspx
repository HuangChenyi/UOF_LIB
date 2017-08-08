<%@ Page Title="上傳檔案" Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" Inherits="WKF_FormManagement_RemoteFileDialog" culture="auto" meta:resourcekey="PageResource1" uiculture="auto" Codebehind="RemoteFileDialog.aspx.cs" %>

<%@ Register Src="~/Common/FileCenter/V3/UC_FileCenter.ascx" TagPrefix="uc1" TagName="UC_FileCenter" %>
<%@ Register TagPrefix="cc2" Namespace="Ede.Uof.Controls.Upload" Assembly="Ede.Uof.Utility.Controls" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
   <script type="text/javascript">


   </script>    
    <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server" OnAjaxRequest="RadAjaxManager1_AjaxRequest" ></telerik:RadAjaxManager>
    <asp:Panel ID="pnlMultiSite" runat="server">

    <asp:HiddenField ID="hfFileGroupID" runat="server" />
    <asp:HiddenField ID="hfLinkUrl" runat="server" />            
<iframe id="dmsDLFrame" style="display:none; width: 87px; height: 33px;"></iframe>

    <asp:Label ID="lblLocalhost" runat="server" Text="本地端" Visible="False" 
        meta:resourcekey="lblLocalhostResource1"></asp:Label>
        <asp:Label ID="lblDeleteErrorMsg" runat="server" Text="異地檔案刪除失敗!!" 
        Visible="False" meta:resourcekey="lblDeleteErrorMsgResource1"></asp:Label>
         <asp:Label ID="lblCopyMsg" runat="server" Text="檔案複製中" Visible="False" 
        meta:resourcekey="lblCopyMsgResource1"></asp:Label>
         <asp:Label ID="lblFileNotFound" runat="server" Text="原始檔案已被刪除" 
        Visible="False" meta:resourcekey="lblFileNotFoundResource1"></asp:Label>
    </asp:Panel>

    <asp:Panel ID="pnlProxy" runat="server">
        
        <table cellpadding=0 cellspacing=1 class="PopTable">
            <tr>
                <td>
                     <asp:Label ID="Label3" runat="server" Text="檔案上傳" meta:resourcekey="Label2Resource1"></asp:Label>
                </td>
                <td>
                    <uc1:UC_FileCenter runat="server" ID="ucFileProxy" ProxyEnabled="true"/>
                </td>
            </tr>
        </table>

    </asp:Panel>

    <asp:Label ID="lblFileType" runat="server" Text="" Visible="false"></asp:Label>
     <asp:Label ID="lblReturn" runat="server" Text="返回" Visible="false"></asp:Label>
</asp:Content>

