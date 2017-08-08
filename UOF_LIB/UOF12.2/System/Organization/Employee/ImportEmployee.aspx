<%@ Page Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" Inherits="System_Organization_Employee_ImportEmployee" Title="匯入人員" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="ImportEmployee.aspx.cs" %>

<%@ Register Src="~/Common/FileCenter/V3/UC_FileCenter.ascx" TagPrefix="uc1" TagName="UC_FileCenter" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <table width="100%">
        <tr>
            <td>
                <asp:Label ID="Label1" runat="server" ForeColor="Blue" Text="已匯入" Visible="False" meta:resourcekey="Label1Resource1"></asp:Label>
                <asp:Label ID="lbSuccess" runat="server" Font-Bold="True" ForeColor="Blue" Visible="False" meta:resourcekey="lbSuccessResource1"></asp:Label>
                <asp:Label ID="Label2" runat="server" ForeColor="Blue" Text="筆資料" Visible="False" meta:resourcekey="Label2Resource1"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                <asp:TextBox ID="TextBox1" runat="server" Height="120px" ReadOnly="True" Width="80%" TextMode="MultiLine" meta:resourcekey="TextBox1Resource1"></asp:TextBox></td>
        </tr>
        <tr>
            <td>
                <uc1:UC_FileCenter runat="server" ID="UC_FileCenter" AllowedFileType="Excel" AllowedMultipleFileSelection="false" />
            </td>
        </tr>
    </table> 
     <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/System/Organization/Employee/Import Employee Sample.xls" Text="下載Excel範例" Target="_blank" meta:resourcekey="btnDownloadResource1"></asp:HyperLink>             
    <asp:Label ID="lbExcelVersion" runat="server" Text="v4.0" meta:resourcekey="lbExcelVersionResource1"></asp:Label><br />

            <asp:Panel ID="panSendPW" runat="server" meta:resourcekey="panSendPWResource1">
            <asp:CheckBox ID="cbSendPW" runat="server" Text="帳號建立後立即發送密碼通知函給該使用者" Checked="True" meta:resourcekey="cbSendPWResource1" /> <br/>
            <asp:Label ID="Label39" runat="server"  CssClass="SizeMemo" Text="若不勾選，亦可於帳號建立後到主畫面點選批次發送密碼函" meta:resourcekey="Label39Resource1" ></asp:Label> 
            </asp:Panel> 
    <asp:Label ID="lbNotAllowNull" runat="server" Text="Name & Department 欄位不得為空" Visible="False" meta:resourcekey="lbNotAllowNullResource1"></asp:Label>
    <asp:Label ID="lbAccountExist" runat="server" Text="帳號已存在" Visible="False" meta:resourcekey="lbAccountExistResource1"></asp:Label>
    <asp:Label ID="lbAccountFormatError" runat="server" Text="帳號格式不正確" Visible="False" meta:resourcekey="lbAccountFormatErrorResource1"></asp:Label>
    <asp:Label ID="lbError" runat="server" Text="匯入發生錯誤" Visible="False" meta:resourcekey="lbErrorResource1"></asp:Label>
    <asp:Label ID="lbModifyXLS" runat="server" Text="請修正XLS" Visible="False" meta:resourcekey="lbModifyXLSResource1" ></asp:Label>    
    <asp:Label ID="lbFormatErrorMsg" runat="server" Text="格式不正確" Visible="False" meta:resourcekey="lbFormatErrorMsgResource1" ></asp:Label>
    <asp:Label ID="lblDepNameErr" runat="server" Text="部門名稱錯誤" Visible="False" meta:resourcekey="lblDepNameErrResource1" ></asp:Label>
    <asp:Label ID="lblDomainError" runat="server" Text="網域名稱不存在" Visible="False" meta:resourcekey="lblDomainErrorResource1" ></asp:Label>
    <asp:Label ID="lblImportFail" runat="server" Text="請檢查檔案是否為Excel 97-2003 活頁簿(*.xls)格式" Visible="False" meta:resourcekey="lblImportFailResource1" ></asp:Label>
    <asp:HiddenField ID="hfCurrentUser" runat="server" />
</asp:Content>


