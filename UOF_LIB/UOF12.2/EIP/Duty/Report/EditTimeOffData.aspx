<%@ Page Title="補休時數維護" Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" CodeBehind="EditTimeOffData.aspx.cs" Inherits="Ede.Uof.Web.EIP.Duty.Report.EditTimeOffData" meta:resourcekey="PageResource1" culture="auto" uiculture="auto" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script>
        function compareHours(sender, args) {
            var rnhours = $("#<%=rnHours.ClientID%>").val();
            var rnUsedhours = $("#<%=rnUsedHours.ClientID%>").val();            
            if (rnhours - rnUsedhours < 0) {
                args.IsValid = false;
            }
        }

        function compareDate(sender, args) {            
            var rdStartDate = $find("<%=rdStartDate.ClientID%>").get_dateInput().get_selectedDate();
            var rdEndDate = $find("<%=rdEndDate.ClientID%>").get_dateInput().get_selectedDate();
            if (rdStartDate > rdEndDate) {
                args.IsValid = false;
            }
        }

        function changehours(sender, args) {            
            if (args.get_newValue() === "") {
                args.set_newValue(args.get_oldValue())
            }            
        }
    </script>

    <table class="PopTable" border="1">
        <tr>
            <td class="PopTableLeftTD" style="white-space:nowrap">
                <asp:Label ID="Label1" runat="server" Text="帳號" meta:resourcekey="Label1Resource1"></asp:Label>
            </td>
            <td class="PopTableRightTD">
                <asp:Label ID="lblAccount" runat="server" meta:resourcekey="lblAccountResource1"></asp:Label>
            </td>
        </tr>
        <tr>
            <td class="PopTableLeftTD" style="white-space:nowrap">
                <asp:Label ID="Label2" runat="server" Text="姓名" meta:resourcekey="Label2Resource1"></asp:Label>
            </td>
            <td class="PopTableRightTD">
                <asp:Label ID="lblUserName" runat="server" meta:resourcekey="lblUserNameResource1"></asp:Label>
            </td>
        </tr>
        <tr>
            <td class="PopTableLeftTD" style="white-space:nowrap">
                <asp:Label ID="Label3" runat="server" Text="開始日" meta:resourcekey="Label3Resource1"></asp:Label>
            </td>
            <td class="PopTableRightTD">
                <telerik:RadDatePicker ID="rdStartDate" runat="server" Width="120px" Culture="zh-TW" meta:resourcekey="rdStartDateResource1">
                </telerik:RadDatePicker>
            </td>
        </tr>
        <tr>
            <td class="PopTableLeftTD" style="white-space:nowrap">
                <asp:Label ID="Label4" runat="server" Text="到期日" meta:resourcekey="Label4Resource1"></asp:Label>
            </td>
            <td class="PopTableRightTD">
                <telerik:RadDatePicker ID="rdEndDate" runat="server" Width="120px" Culture="zh-TW" meta:resourcekey="rdEndDateResource1">
                </telerik:RadDatePicker>
            </td>
        </tr>
        <tr>
            <td class="PopTableLeftTD" style="white-space:nowrap">
                <asp:Label ID="Label5" runat="server" Text="可用時數" meta:resourcekey="Label5Resource1"></asp:Label>
            </td>
            <td class="PopTableRightTD">
                <telerik:RadNumericTextBox runat="server" ID="rnHours" MinValue="0" Culture="zh-TW" DbValueFactor="1" LabelWidth="100px" Width="100px" MaxValue="999" meta:resourcekey="rnHoursResource1">
                    <NumberFormat DecimalDigits="2" />
                    <ClientEvents OnValueChanging="changehours" />
                </telerik:RadNumericTextBox>
                <asp:Label ID="Label7" runat="server" Text="小時" meta:resourcekey="Label7Resource1"></asp:Label>
            </td>
        </tr>
        <tr>
            <td class="PopTableLeftTD" style="white-space:nowrap">
                <asp:Label ID="Label6" runat="server" Text="已用時數" meta:resourcekey="Label6Resource1"></asp:Label>
            </td>
            <td class="PopTableRightTD">
                <telerik:RadNumericTextBox runat="server" ID="rnUsedHours" MinValue="0" Culture="zh-TW" DbValueFactor="1" LabelWidth="100px" Width="100px" ReadOnly="True" meta:resourcekey="rnUsedHoursResource1">
                    <NumberFormat DecimalDigits="2" />
                </telerik:RadNumericTextBox>
                <asp:Label ID="Label8" runat="server" Text="小時" meta:resourcekey="Label8Resource1"></asp:Label>
            </td>
        </tr>
    </table>
    <asp:Customvalidator ID="checkEndDate" runat="server" ErrorMessage="到期日不可早於開始日<br>" ClientValidationFunction="compareDate" Display="Dynamic" meta:resourcekey="checkEndDateResource1"></asp:Customvalidator>
    <asp:Customvalidator ID="checkrnHours" runat="server" ErrorMessage="可用時數不可小於已用時數" ClientValidationFunction="compareHours" Display="Dynamic" meta:resourcekey="checkrnHoursResource1"></asp:Customvalidator>
    <asp:Label ID="lblBefore" runat="server" Text="修改前" Visible="False" meta:resourcekey="lblBeforeResource1"></asp:Label>
    <asp:Label ID="lblAfter" runat="server" Text="修改後" Visible="False" meta:resourcekey="lblAfterResource1"></asp:Label>
    <asp:Label ID="lblModifier" runat="server" Text="修改者" Visible="False" meta:resourcekey="lblModifierResource1"></asp:Label>
    <asp:Label ID="lblEmotion" runat="server" Text="動作" Visible="False" meta:resourcekey="lblEmotionResource1"></asp:Label>
    <asp:Label ID="lblModify" runat="server" Text="修改" Visible="False" meta:resourcekey="lblModifyResource1"></asp:Label>
</asp:Content>
