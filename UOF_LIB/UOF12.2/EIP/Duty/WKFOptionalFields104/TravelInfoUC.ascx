<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="TravelInfoUC.ascx.cs" Inherits="Ede.Uof.Web.EIP.Duty.WKFOptionalFields104.TravelInfoUC" %>
<%@ Register Src="~/Common/ChoiceCenter/UC_ChoiceList.ascx" TagPrefix="uc1" TagName="UC_ChoiceList" %>
<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Fast" %>
<%@ Register Src="~/Common/ChoiceCenter/UC_ChoiceListMobile.ascx" TagPrefix="uc2" TagName="UC_ChoiceListMobile" %>

<script>
    function ValidateApply_<%=ClientID%>(source, arguments) {
        var startDate = $find("<%=rdStartDate.ClientID%>").get_dateInput().get_value();
        var endDate = $find("<%=rdEndDate.ClientID%>").get_dateInput().get_value();
        var startTime = $find("<%=rdStartTime.ClientID%>").get_dateInput().get_value();
        var endTime = $find("<%=rdEndTime.ClientID%>").get_dateInput().get_value();
        var applicantEmployeeNo = $("#<%=hfApplicantEmployeeNo.ClientID%>").val();
        var applicantCompanyNo = $("#<%=hfApplicantCompanyNo.ClientID%>").val();
        var reason = $("#<%=txtReason.ClientID%>").val();
        var leaCode = $("#<%= rblTravelType.ClientID %> input:checked").val();
        var agnetJSON = $("#<%=UC_ChoiceList.ClientID%>_hiddenJSON").val();
        var currencyCode = $("#<%=ddlCurrency.ClientID%>").val();
        var cashAdvance = $find("<%=txtCashAdvance.ClientID%>").get_value();
        var details = $("#<%=txtDetail.ClientID%>").val();


        var data = [applicantCompanyNo, applicantEmployeeNo, agnetJSON, reason, leaCode, startDate, startTime, endDate, endTime, currencyCode, cashAdvance.toString(), details];
        var result = $uof.pageMethod.syncUc("EIP/Duty/WKFOptionalFields104/TravelInfoUC.ascx", "ValidateApply", data);
        if (result != '') {
            source.textContent = result;
            arguments.IsValid = false;
            return;
        }
    }

    function ValidateMissingInfo_<%=ClientID%>(source, arguments) {
        var applicantEmployeeNo = $("#<%=hfApplicantEmployeeNo.ClientID%>").val();
        var applicantCompanyNo = $("#<%=hfApplicantCompanyNo.ClientID%>").val();

        if (applicantEmployeeNo == '' || applicantCompanyNo == '') {
            arguments.IsValid = false;
            return;
        }
    }
</script>
<table class="PopTable">
    <tr>
        <td>
            <asp:Label ID="Label5" runat="server" Text="出差類別"></asp:Label>
        </td>
        <td colspan="3">
            <asp:Label ID="lblTravelType" runat="server" Text="" Visible="false"></asp:Label>
            <asp:RadioButtonList ID="rblTravelType" runat="server" RepeatDirection="Horizontal">
                <asp:ListItem Text="國內出差" Value="S0013-1" Selected="True"></asp:ListItem>
                <asp:ListItem Text="國外出差" Value="S0013-2"></asp:ListItem>
            </asp:RadioButtonList>
        </td>
    </tr>
    <tr>
        <td>
            <asp:Label ID="Label1" runat="server" Text="預計出差時間(起)"></asp:Label>
        </td>
        <td>
            <table>
                <tr>
                    <td>
                        <telerik:RadDatePicker ID="rdStartDate" runat="server" AutoPostBack="False">
                        </telerik:RadDatePicker>
                    </td>
                    <td>
                        <asp:Label ID="lblStartDate" runat="server" Visible="False"></asp:Label>
                        <telerik:RadTimePicker ID="rdStartTime" runat="server">
                        </telerik:RadTimePicker>
                    </td>
                </tr>
            </table>
        </td>
        <td>
            <asp:Label ID="Label2" runat="server" Text="預計出差時間(訖)"></asp:Label>
        </td>
        <td>
            <table>
                <tr>
                    <td>
                        <telerik:RadDatePicker ID="rdEndDate" runat="server" AutoPostBack="False">
                        </telerik:RadDatePicker>
                    </td>
                    <td>
                        <asp:Label ID="lblEndDate" runat="server" Visible="False"></asp:Label>
                        <telerik:RadTimePicker ID="rdEndTime" runat="server">
                        </telerik:RadTimePicker>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>
            <asp:Label ID="Label6" runat="server" Text="預支幣別"></asp:Label>
        </td>
        <td>
            <asp:Label ID="lblCurrency" runat="server" Text="" Visible="false"></asp:Label>
            <asp:DropDownList ID="ddlCurrency" runat="server"></asp:DropDownList>
        </td>
        <td>
            <asp:Label ID="Label7" runat="server" Text="預支金額"></asp:Label>
        </td>
        <td>
            <asp:Label ID="lblCashAdcance" runat="server" Text="" Visible="false"></asp:Label>
            <telerik:RadNumericTextBox ID="txtCashAdvance" runat="server" Width="115px" MinValue="0">
                <NumberFormat ZeroPattern="n" AllowRounding="False"></NumberFormat>
            </telerik:RadNumericTextBox>
        </td>
    </tr>

    <tr>
        <td>
            <asp:Label ID="Label3" runat="server" Text="事由"></asp:Label>
        </td>
        <td colspan="3">
            <asp:Label ID="lblReason" runat="server" Visible="False"></asp:Label>
            <asp:TextBox ID="txtReason" runat="server" Width="100%" TextMode="MultiLine" Rows="4"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td>
            <asp:Label ID="Label9" runat="server" Text="行程資訊"></asp:Label>
        </td>
        <td colspan="3">
            <table>
                <tr>
                    <td>
                        <telerik:RadButton ID="rdbtnAddDetail" runat="server" Text="新增明細" CausesValidation="False" OnClick="rdbtnAddDetail_Click"></telerik:RadButton>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:UpdatePanel ID="updatepanel1" runat="server">
                            <ContentTemplate>
                                <Fast:Grid ID="Grid1" runat="server" AutoGenerateCheckBoxColumn="False"
                                    AllowSorting="False" AutoGenerateColumns="False"
                                    DataKeyOnClientWithCheckBox="False" DefaultSortDirection="Ascending"
                                    EmptyDataText="沒有資料" EnhancePager="True"
                                    KeepSelectedRows="False" OnRowCommand="Grid1_RowCommand"
                                    OnRowDataBound="Grid1_RowDataBound" PageSize="15" OnRowDeleting="Grid1_RowDeleting" Width="100%">

                                    <EnhancePagerSettings ShowHeaderPager="True" />
                                    <ExportExcelSettings
                                        AllowExportToExcel="False" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="操作">
                                            <ItemTemplate>
                                                <asp:LinkButton ID="lbtnModify" CommandName="Modify" runat="server" Text="修改" CausesValidation="False"></asp:LinkButton>
                                                <asp:LinkButton ID="lbtnDelete" CommandName="Delete" runat="server" Text="刪除" CausesValidation="False"></asp:LinkButton>
                                            </ItemTemplate>
                                            <HeaderStyle Wrap="False" />
                                            <ItemStyle Wrap="False" />
                                        </asp:TemplateField>
                                        <asp:BoundField HeaderText="啟程日期" DataField="startDate" />
                                        <asp:BoundField HeaderText="啟程時間" DataField="startTime" />
                                        <asp:BoundField HeaderText="迄程日期" DataField="endDate" />
                                        <asp:BoundField HeaderText="迄程時間" DataField="endTime" />
                                        <asp:TemplateField HeaderText="出發地點">
                                            <ItemTemplate>
                                                <asp:Label ID="lblDepature" runat="server" Text=""></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Wrap="False" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="停留地點">
                                            <ItemTemplate>
                                                <asp:Label ID="lblDestination" runat="server" Text=""></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle Wrap="False" />
                                        </asp:TemplateField>
                                    </Columns>
                                </Fast:Grid>
                                <asp:TextBox ID="txtDetail" runat="server" Style="display: none"></asp:TextBox>
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="rdbtnAddDetail" EventName="Click" />
                            </Triggers>
                        </asp:UpdatePanel>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>
            <asp:Label ID="Label8" runat="server" Text="職務代理人"></asp:Label>
        </td>
        <td colspan="3">
            <uc1:UC_ChoiceList runat="server" ID="UC_ChoiceList" ChioceType="User" />
            <div style="display: none">
                <uc2:UC_ChoiceListMobile runat="server" ID="UC_ChoiceListMobile" ChioceType="User" />
            </div>
        </td>
    </tr>
</table>
<table>
    <tr>
        <td>
            <asp:CustomValidator ID="cvMissingInfo" runat="server" ErrorMessage="申請者無員工編號或公司統一編號資訊" Display="Dynamic"></asp:CustomValidator>
        </td>
    </tr>
    <tr>
        <td>
            <asp:CustomValidator ID="cvApply" runat="server" ErrorMessage="" Display="Dynamic"></asp:CustomValidator>
        </td>
    </tr>
</table>
<asp:Label ID="lblHasNoAuthority" runat="server" Text="無填寫權限" ForeColor="Red" Visible="False"></asp:Label>
<asp:Label ID="lblToolTipMsg" runat="server" Text="不允許修改(唯讀)" Visible="False"></asp:Label>
<asp:Label ID="lblModifier" runat="server" Visible="False"></asp:Label>
<asp:Label ID="lblMsgSigner" runat="server" Text="填寫者" Visible="False"></asp:Label>
<asp:Label ID="lblAuthorityMsg" runat="server" Text="具填寫權限人員" Visible="False"></asp:Label>
<asp:Label ID="lblComfirm" runat="server" Text="確定要刪除?" Visible="False"></asp:Label>
<asp:Label ID="lblStartDateText" runat="server" Text="啟程日期" Visible="False"></asp:Label>
<asp:Label ID="lblStartTimeText" runat="server" Text="啟程時間" Visible="False"></asp:Label>
<asp:Label ID="lblEndDateText" runat="server" Text="迄程日期" Visible="False"></asp:Label>
<asp:Label ID="lblEndTimeText" runat="server" Text="迄程時間" Visible="False"></asp:Label>
<asp:Label ID="lblDepatureText" runat="server" Text="出發地點" Visible="False"></asp:Label>
<asp:Label ID="lblDestinationText" runat="server" Text="停留地點" Visible="False"></asp:Label>
<asp:HiddenField ID="hfApplicantEmployeeNo" Value="" runat="server" />
<asp:HiddenField ID="hfApplicantCompanyNo" Value="" runat="server" />
<asp:HiddenField ID="hfApplicant" Value="" runat="server" />
<asp:HiddenField ID="hfFieldMode" Value="" runat="server" />
