<%@ Page Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" Inherits="EIP_Personal_Briefcase_SharingFolder" Title="目錄分享" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="SharingFolder.aspx.cs" %>

<%@ Register Src="../../../Common/ChoiceCenter/UC_ChoiceList.ascx" TagName="UC_ChoiceList" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <table  class="PopTable" cellspacing="1">
        <tr>
            <td colspan="2" style=" width:100%; text-align:left; white-space:nowrap;">
                <asp:CheckBox ID="chkShare" runat="server" Text="共用此目錄" meta:resourcekey="chkShareResource1" />
            </td>
        </tr>
        <tr>
            <td style="width: 100px">
                <font color="red">*</font><asp:Label ID="Label1" runat="server" Text="共用名稱" meta:resourcekey="Label1Resource1"></asp:Label></td>
            <td style="width: 100px">
                <asp:TextBox ID="shareNameTB" runat="server" meta:resourcekey="shareNameTBResource1"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="shareNameTB"
                    Display="Dynamic" ErrorMessage="不允許空白" meta:resourcekey="RequiredFieldValidator1Resource1"></asp:RequiredFieldValidator></td>
        </tr>
        <tr>
            <td style="width: 100px;white-space:nowrap;"">
                <asp:Label ID="Label2" runat="server" Text="分享的對象" meta:resourcekey="Label2Resource1"></asp:Label></td>
            <td style="width: 180px">
                <uc1:UC_ChoiceList ID="UC_ChoiceList1" runat="server" TreeHeight="350" />
            </td>
        </tr>
    </table>
</asp:Content>

