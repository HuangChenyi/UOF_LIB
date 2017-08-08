<%@ Page Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" Inherits="EIP_Customer_AdvancedExportData" Title="匯出客戶資料" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="AdvancedExportData.aspx.cs" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
   <asp:ValidationSummary ID="ValidationSummary1" runat="server" />

    <table  class ="PopTable" cellspacing="1"  width="100%">
        <tr>
            <td style="text-align:left">
                <asp:Label ID="Label1" runat="server" Text="匯出資料內容" meta:resourcekey="Label1Resource1"></asp:Label></td>
        </tr>
        <tr>
            <td style="text-align:left">
                <asp:RadioButton ID="rblExport" runat="server" GroupName="1" Text="只匯出客戶資料" Width="200px" meta:resourcekey="rblExportResource1" /></td>
        </tr>
        <tr>
            <td style="text-align:left">
                <asp:RadioButton ID="rblExportAll" runat="server" GroupName="1" Text="匯出客戶及聯絡人資料"
                    Width="200px" meta:resourcekey="rblExportAllResource1" /></td>
        </tr>
    </table>
        <asp:CustomValidator ID="cvMessage" runat="server" BackColor="Red" Display="None"
        ForeColor="White" Visible="False"></asp:CustomValidator>
    <asp:Label ID="lblFail" runat="server" Text="匯出資料失敗" Visible="False" meta:resourcekey="lblFailResource1"></asp:Label>
</asp:Content>

