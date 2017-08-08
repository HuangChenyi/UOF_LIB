<%@ Page Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" Inherits="DMS_Admin_ChangeClass" Title="變更文件類別" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="ChangeClass.aspx.cs" %>

<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/jscript">

        $(function () {

            var CustomValidator1 = $("#<%=CustomValidator1.ClientID %>");

        CustomValidator1.css("position", "absolute");
        CustomValidator1.css("left", 180);
        CustomValidator1.css("top", 200);
        CustomValidator1.css("backgroundColor", "#FFFFFF");

    });

    </script>
    <asp:CustomValidator ID="CustomValidator1" runat="server" Display="Dynamic" ErrorMessage="沒有選擇要搬移的文件" meta:resourcekey="CustomValidator1Resource1"></asp:CustomValidator>
    <asp:CustomValidator ID="CustomValidator2" runat="server" Display="Dynamic" ErrorMessage="請選擇類別" meta:resourcekey="CustomValidator2Resource1"></asp:CustomValidator>
    <telerik:RadTreeView runat="server" ID="treeClass">
    </telerik:RadTreeView>
    <input id="hidGridKey" runat="server" type="hidden" />
    <asp:Label ID="lblClass" runat="server" Text="文件類別" Visible="False" meta:resourcekey="lblClassResource1"></asp:Label>
</asp:Content>

