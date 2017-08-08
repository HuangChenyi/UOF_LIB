<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="LeaveInfoUC.ascx.cs" Inherits="Ede.Uof.Web.EIP.Duty.WKFOptionalFields104.LeaveInfoUC" %>
<%@ Register Src="~/Common/ChoiceCenter/UC_ChoiceList.ascx" TagPrefix="uc1" TagName="UC_ChoiceList" %>
<%@ Register Src="~/Common/ChoiceCenter/UC_ChoiceListMobile.ascx" TagPrefix="uc1" TagName="UC_ChoiceListMobile" %>

<script>
    Sys.Application.add_load(function () {
        if ($("#<%=hfFieldMode.ClientID%>").val() == "Design" || typeof $("#<%=hfFieldMode.ClientID%>").val() == 'undefined') {
            return;
        }

        var applicantEmployeeNo = $("#<%=hfApplicantEmployeeNo.ClientID%>").val();
        var applicantCompanyNo = $("#<%=hfApplicantCompanyNo.ClientID%>").val();
        if (applicantEmployeeNo == '' || applicantCompanyNo == '') {
            return;
        }

        AddChangeEvent_<%=ClientID%>();
        CheckEventDate_<%=ClientID%>();
    });

    function AddChangeEvent_<%=ClientID%>() {
        $('#<%=ddlLeaveCode.ClientID%>').on('change', function () {
            ClearHours_<%=ClientID%>();
            CheckEventDate_<%=ClientID%>();
        });
    }

    function OnDateSelected_<%=ClientID%>(sender, eventArgs) {
        ClearHours_<%=ClientID%>();
    }

    function ClearHours_<%=ClientID%>()
    {
        $("#<%=lblHours.ClientID%>").text('');
        $("#<%=txtHours.ClientID%>").val('');
        $("#<%=txtUnit.ClientID%>").val('');
        $("#<%=txtError.ClientID%>").val('');
    }

    function CalLeaveHours_<%=ClientID%>() {
        var unit = '';
        var hours = '';
        var hoursResult = '';
        var arrayResult;
        var startDate = $find("<%=rdStartDate.ClientID%>").get_dateInput().get_value();
        var endDate = $find("<%=rdEndDate.ClientID%>").get_dateInput().get_value();
        var startTime = $find("<%=rdStartTime.ClientID%>").get_dateInput().get_value();
        var endTime = $find("<%=rdEndTime.ClientID%>").get_dateInput().get_value();
        var applicantEmployeeNo = $("#<%=hfApplicantEmployeeNo.ClientID%>").val();
        var applicantCompanyNo = $("#<%=hfApplicantCompanyNo.ClientID%>").val();
        var leaCode = $("#<%=ddlLeaveCode.ClientID%>").val();
        var data = [applicantCompanyNo, applicantEmployeeNo, startDate, startTime, endDate, endTime, leaCode];
        var result = $uof.pageMethod.syncUc("EIP/Duty/WKFOptionalFields104/LeaveInfoUC.ascx", "CalHours", data);

        if (result !== "") {
            arrayResult = result.split('|');
            if (arrayResult.length > 0) {
                if (arrayResult[0] == arrayResult[1] && arrayResult[1] == arrayResult[2] && arrayResult[2] == arrayResult[0])
                {
                    $("#<%=lblHours.ClientID%>").text('');
                    $("#<%=txtHours.ClientID%>").val('');
                    $("#<%=txtUnit.ClientID%>").val('');
                    $("#<%=txtError.ClientID%>").val(arrayResult[0]);

                }
                else {
                    $("#<%=lblHours.ClientID%>").text(arrayResult[0]);
                    $("#<%=txtHours.ClientID%>").val(arrayResult[1]);
                    $("#<%=txtUnit.ClientID%>").val(arrayResult[2]);
                    $("#<%=txtError.ClientID%>").val('');
                }
                
            }
            else {
                $("#<%=lblHours.ClientID%>").text('');
                $("#<%=txtHours.ClientID%>").val('');
                $("#<%=txtUnit.ClientID%>").val('');
                $("#<%=txtError.ClientID%>").val(result);
            }
            
        }
    }

    function CheckEventDate_<%=ClientID%>()
    {
        var applicantEmployeeNo = $("#<%=hfApplicantEmployeeNo.ClientID%>").val();
        var applicantCompanyNo = $("#<%=hfApplicantCompanyNo.ClientID%>").val();
        var leaCode = $("#<%=ddlLeaveCode.ClientID%>").val();
        var data = [applicantCompanyNo, applicantEmployeeNo, leaCode];
        var result = $uof.pageMethod.syncUc("EIP/Duty/WKFOptionalFields104/LeaveInfoUC.ascx", "CheckEventDate", data);
        if (result == "true") {
            $("#tdlblEventDate").show();
            $("#tdEventDate").show();
            $("#tdHours").removeAttr("colspan");
            $("#<%=lblEventDateStar.ClientID%>").show();
        }
        else {
            $("#tdlblEventDate").hide();
            $("#tdEventDate").hide();
            $("#tdHours").attr("colspan", "3");
            $("#<%=lblEventDateStar.ClientID%>").hide();
        }
        return result;
    }

    function ValidateHours_<%=ClientID%>(source, arguments) {
        var error = $("#<%=txtError.ClientID%>").val();
        var hours = $("#<%=txtHours.ClientID%>").val();

        if(error == '' && hours=='')
        {
            arguments.IsValid = false;
            return;
        }
    }

    function ValidateLeaveCode_<%=ClientID%>(source, arguments) {
        var leaCode = $("#<%=ddlLeaveCode.ClientID%>").val();
        if (leaCode == "")
        {
            arguments.IsValid = false;
            return;
        }
    }

    function ValidateApply_<%=ClientID%>(source, arguments) {
        
        var startDate = $find("<%=rdStartDate.ClientID%>").get_dateInput().get_value();
        var endDate = $find("<%=rdEndDate.ClientID%>").get_dateInput().get_value();
        var startTime = $find("<%=rdStartTime.ClientID%>").get_dateInput().get_value();
        var endTime = $find("<%=rdEndTime.ClientID%>").get_dateInput().get_value();
        var eventDate = $find("<%=rdEventDate.ClientID%>").get_dateInput().get_value();
        var applicantEmployeeNo = $("#<%=hfApplicantEmployeeNo.ClientID%>").val();
        var applicantCompanyNo = $("#<%=hfApplicantCompanyNo.ClientID%>").val();
        var reason = $("#<%=hfApplicantCompanyNo.ClientID%>").val();
        var leaCode = $("#<%=ddlLeaveCode.ClientID%>").val();
        var agnetJSON = $("#<%=UC_ChoiceList.ClientID%>_hiddenJSON").val();
        var result = '';
        var data = [$("#<%=hfFormNumber.ClientID%>").val()]

        if ($("#<%=hfFieldMode.ClientID%>").val() == "ReturnApplicant")
        {
            $uof.pageMethod.syncUc("EIP/Duty/WKFOptionalFields104/LeaveInfoUC.ascx", "UpdateStatus", data);
        }
        
        data = [applicantCompanyNo, applicantEmployeeNo, agnetJSON, startDate, startTime, endDate, endTime, leaCode, reason, eventDate, 'false'];
        result = $uof.pageMethod.syncUc("EIP/Duty/WKFOptionalFields104/LeaveInfoUC.ascx", "ValidateApply", data);
        
        if(result != '')
        {
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

    function CalBtnClick_<%=ClientID%>(sender, args)
    {
        CalLeaveHours_<%=ClientID%>();
    }
</script>
<table class="PopTable" style="width: 100%">
    <tr>
        <td>
            <asp:Label ID="Label8" runat="server" Text="*" ForeColor="Red"></asp:Label>
            <asp:Label ID="Label1" runat="server" Text="假別"></asp:Label>
        </td>
        <td colspan="3">
            <table>
                <tr>
                    <td>
                        <asp:Label ID="lblLeaveCode" runat="server" Visible="false" ></asp:Label>
                        <asp:DropDownList ID="ddlLeaveCode" runat="server">
                            
                        </asp:DropDownList>
                    </td>
                    <td>
                        <asp:LinkButton ID="lbtnUserLeaveData" runat="server" Text="可休假餘額" ></asp:LinkButton>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>
            <asp:Label ID="Label9" runat="server" Text="*" ForeColor="Red"></asp:Label>
            <asp:Label ID="Label2" runat="server" Text="請假時間(起)"></asp:Label>
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
        <td>
            <asp:Label ID="Label10" runat="server" Text="*" ForeColor="Red"></asp:Label>
            <asp:Label ID="Label3" runat="server" Text="請假時間(訖)"></asp:Label>
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
                        <telerik:RadTimePicker ID="rdEndTime" runat="server" >
                        </telerik:RadTimePicker>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td id="tdlblEventDate">
            <asp:Label ID="lblEventDateStar" runat="server" Text="*" ForeColor="Red" style="display:none"></asp:Label>
            <asp:Label ID="Label5" runat="server" Text="事件發生日"></asp:Label>
        </td>
        <td id="tdEventDate">
            <asp:Label ID="lblEventDate" runat="server"></asp:Label>
            <telerik:RadDatePicker ID="rdEventDate" runat="server"  AutoPostBack="False"  >
            </telerik:RadDatePicker>
        </td>
        <td>
            <asp:Label ID="Label11" runat="server" Text="*" ForeColor="Red"></asp:Label>
            <asp:Label ID="Label4" runat="server" Text="請假時(天)數"></asp:Label>
        </td>
        <td id="tdHours">
            <table>
                <tr>
                    <td>
                        <asp:Label ID="lblHours" runat="server" ></asp:Label>
                        <asp:TextBox ID="txtHours" runat="server" style="display:none"></asp:TextBox>
                        <asp:TextBox ID="txtUnit" runat="server" style="display:none"></asp:TextBox>
                        <asp:TextBox ID="txtError" runat="server" style="display:none"></asp:TextBox>
                        
                    </td>
                    <td>
                         <telerik:RadButton ID="rdbtnCal" CausesValidation="False" OnClientClicked="CalBtnClick" runat="server" Text="計算" AutoPostBack="false">
                        </telerik:RadButton>
                    </td>
                </tr>
            </table>
            
        </td>
    </tr>

    <tr>
        <td>
            <asp:Label ID="Label7" runat="server" Text="事由"></asp:Label>
        </td>
        <td colspan="3">
            <asp:Label ID="lblReason" runat="server" Visible="False"></asp:Label>
            <asp:TextBox ID="txtReason" runat="server"  Width="100%" TextMode="MultiLine" Rows="4"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td>
            <asp:Label ID="Label6" runat="server" Text="職務代理人"></asp:Label>
        </td>
        <td colspan="3">
            <uc1:UC_ChoiceListMobile runat="server" ID="UC_ChoiceListMobile" ChioceType="User"/>
            <uc1:UC_ChoiceList runat="server" ID="UC_ChoiceList" ChioceType="User"/>
        </td>
    </tr>
</table>
<table>
    <tr>
        <td>
            <asp:CustomValidator ID="cvMissingInfo" runat="server" ErrorMessage="申請者無員工編號或公司統一編號資訊" Display="Dynamic"  ></asp:CustomValidator>
        </td>
    </tr>
    <tr>
        <td>
            <asp:CustomValidator ID="cvSelect" runat="server" ErrorMessage="請選擇假別" Display="Dynamic"  ></asp:CustomValidator>
        </td>
    </tr>
    <tr>
        <td>
            <asp:CustomValidator ID="cvCal" runat="server" ErrorMessage="請計算請假時(天)數" Display="Dynamic"  ></asp:CustomValidator>
        </td>
    </tr>
        <tr>
        <td>
            <asp:CustomValidator ID="cvApply" runat="server" ErrorMessage="" Display="Dynamic"  ></asp:CustomValidator>
        </td>
    </tr>
</table>
<asp:Label ID="lblSelect" runat="server" Text="請選擇" Visible="False" ></asp:Label>
<asp:Label ID="lblCal" runat="server" Text="請先計算請假時(天)數" Visible="False" ></asp:Label>
<asp:Label ID="lblHasNoAuthority" runat="server" Text="無填寫權限" ForeColor="Red" Visible="False" meta:resourcekey="lblHasNoAuthorityResource1"></asp:Label>
<asp:Label ID="lblToolTipMsg" runat="server" Text="不允許修改(唯讀)" Visible="False" meta:resourcekey="lblToolTipMsgResource1"></asp:Label>
<asp:Label ID="lblModifier" runat="server" Visible="False" meta:resourcekey="lblModifierResource1"></asp:Label>
<asp:Label ID="lblMsgSigner" runat="server" Text="填寫者" Visible="False" meta:resourcekey="lblMsgSignerResource1"></asp:Label>
<asp:Label ID="lblAuthorityMsg" runat="server" Text="具填寫權限人員" Visible="False" meta:resourcekey="lblAuthorityMsgResource1"></asp:Label>
<asp:HiddenField ID="hfApplicantEmployeeNo" Value="" runat="server" />
<asp:HiddenField ID="hfApplicantCompanyNo" Value="" runat="server" />
<asp:HiddenField ID="hfApplicant" Value="" runat="server" />
<asp:HiddenField ID="hfFieldMode" Value="" runat="server" />
<asp:HiddenField ID="hfFormNumber" Value="" runat="server" />

