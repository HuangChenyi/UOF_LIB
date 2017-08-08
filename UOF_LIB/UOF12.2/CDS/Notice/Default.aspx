<%@ Page Title="" Language="C#" MasterPageFile="~/Master/DefaultMasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="CDS_Notice_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <telerik:RadToolBar ID="toolBar" runat="server" OnButtonClick="toolBar_ButtonClick" Width="100%">
        <Items>
            <telerik:RadToolBarButton Text="儲存" Value="Save"></telerik:RadToolBarButton>
            <telerik:RadToolBarButton IsSeparator="true"></telerik:RadToolBarButton>
        </Items>
    </telerik:RadToolBar>

    <table class="PopTable">
        <tr>
            <td nowrap="nowrap" >
                <asp:Label ID="Label2" runat="server" Text="超時設定"></asp:Label>
            </td>
            <td>
                <asp:Label ID="Label1" runat="server" Text="異常工時訊息通知"></asp:Label>
                <telerik:RadNumericTextBox ID="rnumDay"  NumberFormat-DecimalDigits="0" runat="server" Width="100px"></telerik:RadNumericTextBox>
                <asp:Label ID="Label3" runat="server" Text="天內,實際工時加上請假時數超過應有工時 "></asp:Label>
                <telerik:RadNumericTextBox ID="rnumHours"  NumberFormat-DecimalDigits="1" runat="server" Width="100px"></telerik:RadNumericTextBox>
                <asp:Label ID="Label4" runat="server" Text="小時以上"></asp:Label>
            </td>
        </tr>
              <tr>
            <td nowrap="nowrap" >
                <asp:Label ID="Label5" runat="server" Text="EXCEL路徑設定"></asp:Label>
            </td>
            <td>
                <asp:TextBox ID="txtPath" runat="server" Width="500px"></asp:TextBox>
           </td>
        </tr>
    </table>
</asp:Content>

