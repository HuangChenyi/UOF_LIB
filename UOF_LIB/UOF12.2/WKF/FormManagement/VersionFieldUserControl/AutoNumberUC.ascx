<%@ Control Language="C#" AutoEventWireup="true" Inherits="WKF_FormManagement_VersionFieldUserControl_AutoNumberUC" Codebehind="AutoNumberUC.ascx.cs" %>
<%@ Reference Control="VersionFieldUC.ascx" %>
<style>
    .AutoNumber{
        background-color:initial;
    }
</style>
		
<table style="width:97%">
    <tr>
        <td>
            <asp:TextBox ID="tbxAutoNumber" runat="server" CssClass="AutoNumber" ReadOnly="True" ToolTip="自動編號(唯讀)" EnableViewState="False" Enabled="False" meta:resourcekey="tbxAutoNumberResource1" Text="由系統自動產生" Width="100%"></asp:TextBox><asp:Label ID="lblAutoNumber" runat="server" meta:resourcekey="lblAutoNumberResource1"></asp:Label>
        </td>
    </tr>
</table>


