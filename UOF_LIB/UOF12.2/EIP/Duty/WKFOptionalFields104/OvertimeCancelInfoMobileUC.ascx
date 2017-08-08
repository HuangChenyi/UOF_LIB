<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="OvertimeCancelInfoUC.ascx.cs" Inherits="Ede.Uof.Web.EIP.Duty.WKFOptionalFields104.OvertimeCancelInfoUC" %>
<%@ Reference Control="~/WKF/FormManagement/VersionFieldUserControl/VersionFieldUC.ascx" %>
<%@ Register Src="../../../Common/ChoiceCenter/UC_BtnChoiceOnce.ascx" TagName="UC_BtnChoiceOnce" TagPrefix="uc1" %>
<style>
    .OvertimeCancelTable104 > tbody > tr:nth-child(even) > td {
        padding-left: 10px;
        padding-bottom: 15px;
    }

    .OvertimeCancelTable104 > tbody > tr:nth-child(odd) > td {
        padding-left: 10px;
        padding-bottom: 5px;
    }
</style>
<script type="text/javascript">

    function CheckDeleteOvertimeData_<%=ClientID%>(source, args) {

        var askId = $("#<%=lblAskId.ClientID %>").text(); //表單代碼

        if (askId == '') {
            source.textContent = $('#<%=lblErrorLeaveNbr.ClientID%>').text();
            args.IsValid = false;
            return;
        }
        var data = [askId];
        var errormsg = $uof.pageMethod.syncUc("EIP/Duty/WKFOptionalFields104/LeaveCancelInfoUC.ascx", "CheckDeleteLeaveData", data);
        if (errormsg != '') {
            source.textContent = errormsg;
            args.IsValid = false;
            return;
        }

    }
</script>

<asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>
        <table class="OvertimeCancelTable104" style="width: 100%">
            <tr>
                <td>
                    <asp:Label ID="Label1" runat="server" Text="加班時間"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    <telerik:RadDropDownList ID="rddlOverTime" runat="server" EnableTheming="true"
                        AutoPostBack="true" CausesValidation="false"
                        OnSelectedIndexChanged="ddlLeaveNbr_SelectedIndexChanged">
                    </telerik:RadDropDownList>
                    <asp:Label ID="lblLeaveTime" runat="server"></asp:Label>
                    <asp:Label ID="lblAskId" runat="server" Style="display: none"></asp:Label>

                </td>
            </tr>


            <tr>
                <td>
                    <asp:Label ID="Label5" runat="server" Text="加班時數"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="lblOvertimeHours" runat="server"></asp:Label>
                    <asp:HiddenField ID="hfUnit" runat="server" />
                    <asp:HiddenField ID="hfDays" runat="server" Value="0" />
                    <asp:HiddenField ID="hfHours" runat="server" Value="0" />
                </td>
            </tr>
        </table>
        <asp:CustomValidator ID="cvCheckDeleteOvertimeData" Display="Dynamic" runat="server" ErrorMessage="CustomValidator" EnableTheming="true"></asp:CustomValidator>

        <asp:HiddenField ID="hfIsSendValue" runat="server" />
        <asp:HiddenField ID="hfApplicantGuid" runat="server" />
        <asp:HiddenField ID="hfStartTime" runat="server" />
        <asp:HiddenField ID="hfEndTime" runat="server" />
        <asp:Label ID="lblFieldValue" runat="server" Visible="False"></asp:Label>
    </ContentTemplate>
</asp:UpdatePanel>

<asp:Label ID="lblErrlrLeaveDiffUse1" runat="server" Text="已被其他請假單接續使用" Style="display: none"></asp:Label>
<asp:Label ID="lblErrlrLeaveDiffUse2" runat="server" Text="，不能銷單" Style="display: none"></asp:Label>
<asp:Label ID="lblErrorLeaveNbr" runat="server" Text="請選擇請加班時間" Style="display: none" ForeColor="Red"></asp:Label>
<asp:Label ID="lblDay" runat="server" Text="天" Visible="False"></asp:Label>
<asp:Label ID="lblHour" runat="server" Text="時" Visible="False"></asp:Label>
<asp:Label ID="lblLeaveCodeMiss" runat="server" Text="該假別已被修改或移除" Visible="False"></asp:Label>
<asp:Label ID="lblSelectMsg" runat="server" Text="請選擇" Visible="False"></asp:Label>
<asp:Label ID="lblHasNoAuthority" runat="server" Text="無填寫權限" ForeColor="Red"></asp:Label>
<asp:Label ID="lblToolTipMsg" runat="server" Text="不允許修改(唯讀)" Visible="False"></asp:Label>
<asp:Label ID="lblModifier" runat="server" Visible="False"></asp:Label>
<asp:Label ID="lblMsgSigner" runat="server" Text="填寫者" Visible="False"></asp:Label>
<asp:Label ID="lblAuthorityMsg" runat="server" Text="具填寫權限人員" Visible="False"></asp:Label>