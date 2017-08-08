<%@ Page Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" Inherits="Basic_Personal_PrivateMessage_ReplyMessage" Title="回覆訊息" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="ReplyMessage.aspx.cs" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Register Src="~/Common/FileCenter/V3/UC_FileCenter.ascx" TagPrefix="uc2" TagName="UC_FileCenter" %>

<%@ Register src="../../../Common/HtmlEditor/UC_HtmlEditor.ascx" tagname="UC_HtmlEditor" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:CustomValidator ID="CustomValidator1" runat="server" Display="Dynamic" ErrorMessage="無法寄出" ForeColor="Red" meta:resourcekey="CustomValidator1Resource1"></asp:CustomValidator>
    <table width="100%"  class="PopTable" cellspacing="1" style="line-height:normal">

        <tr>
            <td style="width:120px;white-space:nowrap;" >
                <asp:Label ID="lbLeftReceive" runat="server" Text="收件人" meta:resourcekey="lbLeftReceiveResource1"></asp:Label></td>
            <td >
                <asp:Label ID="lbReceive" runat="server" meta:resourcekey="lbReceiveResource1"></asp:Label>
                <asp:Label ID="lbReaderGuid" runat="server" Visible="False" meta:resourcekey="lbReaderGuidResource1"></asp:Label></td>
        </tr>
        <tr>
            <td style="width:120px;white-space:nowrap;" >
                <span style="color: #ff0000">*</span><asp:Label ID="lbLeftTopic" runat="server" Text="主旨" meta:resourcekey="lbLeftTopicResource1"></asp:Label></td>
            <td >
                <asp:TextBox ID="txbTopic" runat="server" Width="100%" meta:resourcekey="txbTopicResource1" MaxLength="255"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txbTopic" ForeColor="Red"
                    Display="Dynamic" ErrorMessage="必須輸入主旨" meta:resourcekey="RequiredFieldValidator1Resource1"></asp:RequiredFieldValidator></td>
        </tr>
        <tr>
            <td style="width:120px;white-space:nowrap;" >
                <asp:Label ID="lbMsgContent" runat="server" Text="內容" meta:resourcekey="lbMsgContentResource1"></asp:Label></td>
            <td >
                
                <uc1:UC_HtmlEditor ID="UC_HtmlEditor1" runat="server" Height="800px" Width="100%"/>
                
            </td>
        </tr>
    </table>
    <asp:Label ID="lbMsgId" runat="server" Visible="False" meta:resourcekey="lbMsgIdResource1"></asp:Label><br />
    <asp:Label ID="msgNotsend" runat="server" Text="無法寄出" Visible="False" meta:resourcekey="msgNotsendResource1"></asp:Label>
</asp:Content>

