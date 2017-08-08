<%@ Page Title="新增/維護自訂屬性" Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" CodeBehind="DMSPropertyCustomizeEdit.aspx.cs" Inherits="Ede.Uof.Web.DMS.DocStore.DMSPropertyCustomizeEdit" culture="auto" meta:resourcekey="PageResource2" uiculture="auto" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script type="text/javascript">
        function AlertExistPropertyName() {
            alert('<%=lblPropertyNameExist.Text%>');
        }
    </script>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table class="PopTable">
                <tr>
                    <td style="white-space: nowrap">
                        <asp:Label ID="Label1" runat="server" Text="*" ForeColor="Red" meta:resourcekey="Label1Resource2"></asp:Label>
                        <asp:Label ID="Label2" runat="server" Text="屬性標題" meta:resourcekey="Label2Resource2"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="txtPropertyName" runat="server" meta:resourcekey="txtPropertyNameResource2"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rftxtPropertyName" runat="server" ErrorMessage="不可空白" ForeColor="Red" Display="Dynamic" ControlToValidate="txtPropertyName" meta:resourcekey="rftxtPropertyNameResource2"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td style="white-space: nowrap">
                        <asp:Label ID="Label3" runat="server" Text="*" ForeColor="Red" meta:resourcekey="Label3Resource2"></asp:Label>
                        <asp:Label ID="Label4" runat="server" Text="屬性型態" meta:resourcekey="Label4Resource2"></asp:Label>
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlPropertyType" runat="server" AutoPostBack="True" meta:resourcekey="ddlPropertyTypeResource2">
                            <asp:ListItem Value="TextBox" Text="文字" meta:resourcekey="ListItemResource5"></asp:ListItem>
                            <asp:ListItem Value="Date" Text="日期" meta:resourcekey="ListItemResource6"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td style="white-space: nowrap">
                        <asp:Label ID="Label5" runat="server" Text="*" ForeColor="Red" meta:resourcekey="Label5Resource2"></asp:Label>
                        <asp:Label ID="Label6" runat="server" Text="是否必填" meta:resourcekey="Label6Resource2"></asp:Label>
                    </td>
                    <td>
                        <asp:RadioButtonList ID="rblIsMandatory" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" meta:resourcekey="rblIsMandatoryResource2">
                            <asp:ListItem Value="True" Text="是" Selected="True" meta:resourcekey="ListItemResource7"></asp:ListItem>
                            <asp:ListItem Value="False" Text="否" meta:resourcekey="ListItemResource8"></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                </tr>
            </table>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:Label ID="lblPropertyNameExist" runat="server" Text="屬性標題重複" style="display:none" meta:resourcekey="lblPropertyNameExistResource2"></asp:Label>
</asp:Content>
