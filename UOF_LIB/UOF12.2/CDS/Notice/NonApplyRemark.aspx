<%@ Page Title="" Language="C#" MasterPageFile="~/Master/DefaultMasterPage.master" AutoEventWireup="true" CodeFile="NonApplyRemark.aspx.cs" Inherits="CDS_Notice_NonApplyRemark" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
        <telerik:RadToolBar ID="toolBar" runat="server" OnButtonClick="toolBar_ButtonClick" Width="100%">
        <Items>
            <telerik:RadToolBarButton Text="送出" Value="Send"></telerik:RadToolBarButton>
            <telerik:RadToolBarButton IsSeparator="true"></telerik:RadToolBarButton>
        </Items>
    </telerik:RadToolBar>
    <table class="PopTable" style="width:500px">
        <tr>
            <td>
                <asp:Label ID="Label1" runat="server" Text="姓名"></asp:Label>
            </td>
            <td>
                <asp:Label ID="lblName" runat="server" Text=""></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label2" runat="server" Text="日期"></asp:Label>
            </td>
            <td>
                <asp:Label ID="lblDate" runat="server" Text=""></asp:Label>
            </td>
        </tr>
        <tr>
            <td nowrap="nowrap">
                <asp:Label ID="Label3" runat="server" Text="不申請原因"></asp:Label>
            </td>
            <td>
                <asp:TextBox ID="txtRemmark" runat="server" TextMode="MultiLine" Height="300px"
                    Width="100%"></asp:TextBox>
            </td>
        </tr>
    </table>
    <asp:Label ID="lblSend" runat="server" Text="資料已送出" Visible="false";></asp:Label>

</asp:Content>

