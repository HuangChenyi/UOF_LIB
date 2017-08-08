<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="TravelCancelInfoUC.ascx.cs" Inherits="Ede.Uof.Web.EIP.Duty.WKFOptionalFields104.TravelCancelInfoUC" %>
<%@ Register Src="~/Common/ChoiceCenter/UC_ChoiceList.ascx" TagPrefix="uc1" TagName="UC_ChoiceList" %>
<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Fast" %>
<%@ Register Src="~/Common/ChoiceCenter/UC_ChoiceListMobile.ascx" TagPrefix="uc2" TagName="UC_ChoiceListMobile" %>

<script type="text/javascript">
    function ValidateApply_<%=ClientID%>(source, arguments) {
        var applicantEmployeeNo = $("#<%=hfApplicantEmployeeNo.ClientID%>").val();
        var applicantCompanyNo = $("#<%=hfApplicantCompanyNo.ClientID%>").val();
        var tripId = $("#<%=ddlTravelList.ClientID%> option:selected").val();

        var lblchooseTravelForm = '<%=lblChooseTravelForm.Text%>';
        //if (tripId == "null") {
        //    source.textContent =lblchooseTravelForm;
        //    arguments.IsValid = false;
        //    return;
        //}
        var data = [applicantCompanyNo, applicantEmployeeNo, tripId];
        var result = $uof.pageMethod.syncUc("EIP/Duty/WKFOptionalFields104/TravelCancelInfoUC.ascx", "ValidateApply", data);
        if (result != '') {
            if (result === "@tripIdNotFound")
                source.textContent = '<%=lblTravelFormNotFound.Text%>';
            else
                source.textContent = result;
            arguments.IsValid = false;
            return;
        }
    }
</script>
<asp:UpdatePanel ID="UpdatePanel1"  runat="server">
    <ContentTemplate>
        <table class="PopTable" style="width: 700px">
            <tr>
                <td>
                    <asp:Label ID="Label8" runat="server" Text="*" ForeColor="Red"></asp:Label>
                    <asp:Label ID="Label1" runat="server" Text="出差時間"></asp:Label>
                </td>
                <td colspan="3">
                    <table>
                        <tr>
                            <td>
                                <telerik:RadDropDownList ID="ddlMTravelList" runat="server" OnSelectedIndexChanged="ddlMTravelList_SelectedIndexChanged" AutoPostBack="true"  EnableTheming="true" CausesValidation="false" style="display:none"></telerik:RadDropDownList>
                                <asp:DropDownList ID="ddlTravelList" runat="server" OnSelectedIndexChanged="ddlTravelList_SelectedIndexChanged" AutoPostBack="true">
                                </asp:DropDownList>
                                <asp:Label ID="lblTravelTime" runat="server"></asp:Label>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="lblType" runat="server" Text="類別"></asp:Label>
                </td>
                <td colspan="3">
                    <asp:Label ID="lblTypeValue" runat="server"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="lblAdvanceCurreny" runat="server" Text="預支幣別"></asp:Label>
                </td>
                <td colspan="3">
                    <asp:Label ID="lblAdvanceCurrenyValue" runat="server"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="lblAdvanceAmount" runat="server" Text="預支金額"></asp:Label>
                </td>
                <td colspan="3">
                    <asp:Label ID="lblAdvanceAmountValue" runat="server"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="lblTravelDetail" runat="server" Text="出差行程資訊"></asp:Label>
                </td>
                <td colspan="3">
                    <Fast:Grid ID="Grid1" runat="server" AutoGenerateCheckBoxColumn="False"
                        AllowSorting="False" AutoGenerateColumns="False"
                        DataKeyOnClientWithCheckBox="False" DefaultSortDirection="Ascending"
                        EmptyDataText="沒有資料" EnhancePager="True"
                        KeepSelectedRows="False" OnRowDataBound="Grid1_RowDataBound" PageSize="15">

                        <EnhancePagerSettings ShowHeaderPager="True" />
                        <ExportExcelSettings
                            AllowExportToExcel="False" />
                        <Columns>
                            <asp:TemplateField HeaderText="啟程日期">
                                <ItemTemplate>
                                    <asp:Label ID="lblStartDate" runat="server"></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle Wrap="False" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="啟程時間">
                                <ItemTemplate>
                                    <asp:Label ID="lblStartTime" runat="server"></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle Wrap="False" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="迄程日期">
                                <ItemTemplate>
                                    <asp:Label ID="lblEndDate" runat="server"></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle Wrap="False" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="迄程時間">
                                <ItemTemplate>
                                    <asp:Label ID="lblEndTime" runat="server"></asp:Label>
                                </ItemTemplate>
                                <HeaderStyle Wrap="False" />
                            </asp:TemplateField>
                            <asp:BoundField HeaderText="出發地點" DataField="START_BUSINESS_TRIP_SITE" />
                            <asp:BoundField HeaderText="停留地點" DataField="END_BUSINESS_TRIP_SITE" />
                        </Columns>
                    </Fast:Grid>
                    <asp:TextBox ID="txtDetail" runat="server" Visible="false"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Label ID="lblAgent" runat="server" Text="職務代理人"></asp:Label>
                </td>
                <td colspan="3">
                    <uc1:UC_ChoiceList ID="choicelistAgent" runat="server" ChioceType="User" IsAllowEdit="false" />
                    <div style="display: none">
                        <uc2:UC_ChoiceListMobile runat="server" ID="choicelistAgentM" ChoiceType="User" IsAllowEdit="false" />
                    </div>
                </td>
            </tr>
        </table>
    </ContentTemplate>
</asp:UpdatePanel>


<asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="" Display="Dynamic"></asp:CustomValidator>
<asp:Label ID="lblHasNoAuthority" runat="server" Text="無填寫權限" ForeColor="Red" Visible="False" meta:resourcekey="lblHasNoAuthorityResource1"></asp:Label>
<asp:Label ID="lblToolTipMsg" runat="server" Text="不允許修改(唯讀)" Visible="False" meta:resourcekey="lblToolTipMsgResource1"></asp:Label>
<asp:Label ID="lblModifier" runat="server" Visible="False" meta:resourcekey="lblModifierResource1"></asp:Label>
<asp:Label ID="lblMsgSigner" runat="server" Text="填寫者" Visible="False" meta:resourcekey="lblMsgSignerResource1"></asp:Label>
<asp:Label ID="lblAuthorityMsg" runat="server" Text="具填寫權限人員" Visible="False" meta:resourcekey="lblAuthorityMsgResource1"></asp:Label>
<asp:Label ID="lblComfirm" runat="server" Text="確定要刪除?" Visible="False"></asp:Label>
<asp:HiddenField ID="hfApplicantEmployeeNo" Value="" runat="server" />
<asp:HiddenField ID="hfApplicantCompanyNo" Value="" runat="server" />
<asp:HiddenField ID="hfAgentName" Value="" runat="server" />
<asp:HiddenField ID="hfApplicant" Value="" runat="server" />
<asp:Label ID="lblTripId" runat="server" Visible="false" />
<asp:HiddenField ID="hfStartDateTime" Value="" runat="server" />
<asp:HiddenField ID="hfEndDateTime" Value="" runat="server" />
<asp:CustomValidator ID="cvApply" runat="server" ErrorMessage="" Display="Dynamic"  ></asp:CustomValidator>

<asp:Label ID="lblTravelAbroad" runat="server" Text="國外出差" Visible="false"></asp:Label>
<asp:Label ID="lblTravelDomestic" runat="server" Text="國內出差" Visible="false"></asp:Label>
<asp:Label Visible="false" ID="lblStartDate" Text="啟程日期" runat="server"></asp:Label>
<asp:Label Visible="false" ID="lblStartTime" Text="啟程時間" runat="server"></asp:Label>
<asp:Label Visible="false" ID="lblEndDate" Text="迄程日期" runat="server"></asp:Label>
<asp:Label Visible="false" ID="lblEndTime" Text="迄程時間" runat="server"></asp:Label>
<asp:Label Visible="false" ID="lblDeparture" Text="出發地點" runat="server"></asp:Label>
<asp:Label Visible="false" ID="lblDestination" Text="停留地點" runat="server"></asp:Label>
<asp:Label Visible="false" ID="lblChooseTravelForm" Text="請選擇出差單" runat="server"></asp:Label>
<asp:Label Visible="false" ID="lblTravelFormNotFound" Text="找無此出差單，請確認是否已銷單" runat="server"></asp:Label>