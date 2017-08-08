<%@ Page Title="行程資訊" Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" CodeBehind="MaintainTravelDetails.aspx.cs" Inherits="Ede.Uof.Web.EIP.Duty.WKFOptionalFields104.MaintainTravelDetails" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <table class="PopTable">
        <tr>
            <td>
                <asp:Label ID="Label2" runat="server" Text="啟程時間"></asp:Label>
            </td>
            <td>
                <table>
                    <tr>
                        <td>
                            <telerik:RadDatePicker ID="rdStartDate" runat="server"  AutoPostBack="False"  >
                            </telerik:RadDatePicker>
                        </td>
                        <td>
                            <asp:Label ID="lblStartDate" runat="server" Visible="False" ></asp:Label>
                            <telerik:RadTimePicker ID="rdStartTime" runat="server">
                            </telerik:RadTimePicker>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label4" runat="server" Text="迄程時間"></asp:Label>
            </td>
            <td>
                <table>
                    <tr>
                        <td>
                            <telerik:RadDatePicker ID="rdEndDate" runat="server"  AutoPostBack="False"  >
                            </telerik:RadDatePicker>
                        </td>
                        <td>
                            <asp:Label ID="lblEndDate" runat="server" Visible="False" ></asp:Label>
                            <telerik:RadTimePicker ID="rdEndTime" runat="server">
                            </telerik:RadTimePicker>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label5" runat="server" Text="出發地點"></asp:Label>
            </td>
            <td>
                <asp:DropDownList ID="ddlDepature" runat="server"></asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label6" runat="server" Text="停留地點"></asp:Label>
            </td>
            <td>
                <asp:DropDownList ID="ddlDestnation" runat="server"></asp:DropDownList>
            </td>
        </tr>
    </table>
    <asp:TextBox ID="txtDetail" runat="server" Style="display:none"></asp:TextBox>
    <asp:HiddenField ID="hfUI" runat="server" />
    <asp:Label  ID="lblGoBack" runat="server" Text="返回" Visible="false"></asp:Label>
</asp:Content>
