<%@ Control Language="C#" AutoEventWireup="true" CodeFile="OptionFieldUC2.ascx.cs" Inherits="WKF_OptionalFields_OptionFieldUC2" %>
<%@ Reference Control="~/WKF/FormManagement/VersionFieldUserControl/VersionFieldUC.ascx" %>

<table class="PopTable">
    <tr>
        <td nowrap="nowrap">
            <asp:Label ID="Label4" runat="server" Text="*" ForeColor="Red" ></asp:Label>
            <asp:Label ID="Label2" runat="server" Text="類別"></asp:Label>
        </td>
        
        <td>
            <asp:RadioButtonList ID="RadioButtonList1" runat="server" RepeatDirection="Horizontal">
                <asp:ListItem Value="A"></asp:ListItem>
                 <asp:ListItem Value="B"></asp:ListItem>
                 <asp:ListItem Value="C"></asp:ListItem>
            </asp:RadioButtonList>
            <asp:TextBox ID="txtType" runat="server" Visible="false"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td nowrap="nowrap">
              <asp:Label ID="Label5" runat="server" Text="*" ForeColor="Red" ></asp:Label>
            <asp:Label ID="Label1" runat="server" Text="品項"></asp:Label>
        </td>
        
        <td>
            <asp:TextBox ID="txtItem" runat="server"></asp:TextBox>
        </td>
    </tr>

        <tr>
        <td nowrap="nowrap">
              <asp:Label ID="Label6" runat="server" Text="*" ForeColor="Red" ></asp:Label>
            <asp:Label ID="Label3" runat="server" Text="金額"></asp:Label>
        </td>
        
        <td>
            <asp:TextBox ID="txtAmount" runat="server"></asp:TextBox>
        </td>
    </tr>
</table>

<asp:Label ID="lblHasNoAuthority" runat="server" Text="無填寫權限" ForeColor="Red" Visible="False" meta:resourcekey="lblHasNoAuthorityResource1"></asp:Label>
<asp:Label ID="lblToolTipMsg" runat="server" Text="不允許修改(唯讀)" Visible="False" meta:resourcekey="lblToolTipMsgResource1"></asp:Label>
<asp:Label ID="lblModifier" runat="server" Visible="False" meta:resourcekey="lblModifierResource1"></asp:Label>
<asp:Label ID="lblMsgSigner" runat="server" Text="填寫者" Visible="False" meta:resourcekey="lblMsgSignerResource1"></asp:Label>
<asp:Label ID="lblAuthorityMsg" runat="server" Text="具填寫權限人員" Visible="False" meta:resourcekey="lblAuthorityMsgResource1"></asp:Label>