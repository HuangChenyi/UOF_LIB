<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="OverTimeInfoUC.ascx.cs" Inherits="Ede.Uof.Web.EIP.Duty.WKFOptionalFields104.OverTimeInfoUC" %>
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

        ShowMealAllowance_<%=ClientID%>();
        AddChangeEvent_<%=ClientID%>();
        
    });

    function AddChangeEvent_<%=ClientID%>() {
        $('input[type=checkbox][id*=<%=cblExcludeHours.ClientID%>]').on('change', function () {
            ClearHours_<%=ClientID%>();
        });

        $('input[type=radio][id*=<%=rblOverTimeType.ClientID%>]').on('change', function () {
            ShowMealAllowance_<%=ClientID%>();
            ClearHours_<%=ClientID%>();
        });
    }

    function ClearHours_<%=ClientID%>()
    {
        $("#<%=lblHours.ClientID%>").text('');
        $("#<%=txtHours.ClientID%>").val('');
        $("#<%=txtUnit.ClientID%>").val('');
        $("#<%=txtError.ClientID%>").val('');
    }

    function OnDateSelected_<%=ClientID%>(sender, eventArgs) {
        ClearHours_<%=ClientID%>();
    }

    function ShowMealAllowance_<%=ClientID%>()
    {
        var value = $("#<%= rblOverTimeType.ClientID %> input:checked").val();
        var value2 = $("#<%= hfOverTimeType.ClientID %>").val();
        if (value === 'TimeOff' || value2 === 'TimeOff') {
            $("#tdOverTimeType").attr("colspan", "3");
            $("#tdlblMealAllowance").attr("style", "display:none");
            $("#tdMealAllowance").attr("style", "display:none");
        }
        else {
            $("#tdOverTimeType").removeAttr("colspan");
            $("#tdlblMealAllowance").removeAttr("style");
            $("#tdMealAllowance").removeAttr("style");
        }
    }

    function CalBtnClick_<%=ClientID%>(sender, args)
    {
        CalOverTimeHours_<%=ClientID%>();
    }

    function CalOverTimeHours_<%=ClientID%>()
    {
        var unit = '';
        var hours = '';
        var hoursResult = '';
        var arrayResult;
        var startDate = $find("<%=rdStartDate.ClientID%>").get_dateInput().get_value();
        var endDate = $find("<%=rdEndDate.ClientID%>").get_dateInput().get_value();
        var startTime = $find("<%=rdStartTime.ClientID%>").get_dateInput().get_value();
        var endTime = $find("<%=rdEndTime.ClientID%>").get_dateInput().get_value();
        var deductibleHours = CalExcludeHours_<%=ClientID%>();
        var applicantEmployeeNo = $("#<%=hfApplicantEmployeeNo.ClientID%>").val();
        var applicantCompanyNo = $("#<%=hfApplicantCompanyNo.ClientID%>").val();

        var data = [applicantCompanyNo, applicantEmployeeNo, startDate, startTime, endDate, endTime, deductibleHours];
        var result = $uof.pageMethod.syncUc("EIP/Duty/WKFOptionalFields104/OverTimeInfoUC.ascx", "CalHours", data);
        
    
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

    function CalExcludeHours_<%=ClientID%>()
    {
        var totalHours = 0;
        $('input[type=checkbox][id*=<%=cblExcludeHours.ClientID%>]:checked').map(function () {

            return totalHours += parseInt($(this).val().split('|')[1], 10);
        })

        return totalHours;
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

    function ValidateApply_<%=ClientID%>(source, arguments) {
        var startDate = $find("<%=rdStartDate.ClientID%>").get_dateInput().get_value();
        var endDate = $find("<%=rdEndDate.ClientID%>").get_dateInput().get_value();
        var startTime = $find("<%=rdStartTime.ClientID%>").get_dateInput().get_value();
        var endTime = $find("<%=rdEndTime.ClientID%>").get_dateInput().get_value();
        var deductibleHours = CalExcludeHours_<%=ClientID%>();
        var applicantEmployeeNo = $("#<%=hfApplicantEmployeeNo.ClientID%>").val();
        var applicantCompanyNo = $("#<%=hfApplicantCompanyNo.ClientID%>").val();
        var punchCheck = $("#<%= rblPunchCheck.ClientID %> input:checked").val();
        var overTimeType = $("#<%= rblOverTimeType.ClientID %> input:checked").val();
        var reason = $("#<%=txtRemark.ClientID %>").val();
        var mealAllowanceType = $("#<%= rblMealAllowance.ClientID %> input:checked").val();

        var data = [$("#<%=hfFormNumber.ClientID%>").val()]
        if ($("#<%=hfFieldMode.ClientID%>").val() == "ReturnApplicant")
        {
            $uof.pageMethod.syncUc("EIP/Duty/WKFOptionalFields104/OverTimeInfoUC.ascx", "UpdateStatus", data);
        }

        data = [applicantCompanyNo, applicantEmployeeNo, startDate, startTime, endDate, endTime, overTimeType, reason, mealAllowanceType, deductibleHours, punchCheck];
        var result = $uof.pageMethod.syncUc("EIP/Duty/WKFOptionalFields104/OverTimeInfoUC.ascx", "ValidateApply", data);
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
</script>
<table class="PopTable" style="width: 100%">
    <tr>
        <td>
            <asp:Label ID="Label9" runat="server" Text="*" ForeColor="Red"></asp:Label>
            <asp:Label ID="Label5" runat="server" Text="加班折換方式"></asp:Label>
        </td>
        <td id="tdOverTimeType" style="width: 35%">
            <asp:RadioButtonList ID="rblOverTimeType" runat="server" RepeatDirection="Horizontal">
                <asp:ListItem Text="轉加班費" Value="Payment" Selected="True"></asp:ListItem>
                <asp:ListItem Text="轉補休" Value="TimeOff"></asp:ListItem>
            </asp:RadioButtonList>
            <asp:Label ID="lblOverTimeType" runat="server" Text="" Visible="false"></asp:Label>
        </td>
        <td id="tdlblMealAllowance">
            <asp:Label ID="Label8" runat="server" Text="*" ForeColor="Red"></asp:Label>
            <asp:Label ID="Label6" runat="server" Text="是否發放誤餐費"></asp:Label>
        </td>
        <td id="tdMealAllowance" style="width: 35%">
            <asp:RadioButtonList ID="rblMealAllowance" runat="server" RepeatDirection="Horizontal">
                <asp:ListItem Text="是" Value="Yes" Selected="True"></asp:ListItem>
                <asp:ListItem Text="否" Value="No"></asp:ListItem>
            </asp:RadioButtonList>
            <asp:Label ID="lblMealAllowance" runat="server" Text="" Visible="false"></asp:Label>
        </td>
    </tr>
    <tr>
        <td>
            <asp:Label ID="Label10" runat="server" Text="*" ForeColor="Red"></asp:Label>
            <asp:Label ID="Label1" runat="server" Text="加班時間(起)"></asp:Label>
        </td>
        <td style="width: 35%">
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
             <asp:Label ID="Label11" runat="server" Text="*" ForeColor="Red"></asp:Label>
            <asp:Label ID="Label2" runat="server" Text="加班時間(訖)"></asp:Label>
        </td>
        <td style="width: 35%">
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
            <asp:Label ID="Label12" runat="server" Text="*" ForeColor="Red"></asp:Label>
            <asp:Label ID="Label4" runat="server" Text="扣除時數"></asp:Label>
        </td>
        <td style="width: 35%">
            <asp:CheckBoxList ID="cblExcludeHours" runat="server" RepeatDirection="Horizontal">
                <asp:ListItem Text="午餐(1)" Value="Lunch|1" Selected="True"></asp:ListItem>
                <asp:ListItem Text="晚餐(2)" Value="Dinner|2" Selected="True"></asp:ListItem>
                <asp:ListItem Text="宵夜(4)" Value="Supper|4" Selected="True"></asp:ListItem>
                <asp:ListItem Text="其他(8)" Value="Other|8" Selected="True"></asp:ListItem>
            </asp:CheckBoxList>
            <asp:Label ID="lblExcludeHours" runat="server" Visible="False" ></asp:Label>
        </td>
        <td>
            <asp:Label ID="Label15" runat="server" Text="*" ForeColor="Red"></asp:Label>
            <asp:Label ID="Label14" runat="server" Text="檢查刷卡資料"></asp:Label>
        </td>
        <td style="width: 35%">
            <asp:Label ID="lblPunchCheck" runat="server" Text="" Visible="false"></asp:Label>
            <asp:RadioButtonList ID="rblPunchCheck" runat="server" RepeatDirection="Horizontal">
                <asp:ListItem Text="是" Value="Yes"></asp:ListItem>
                <asp:ListItem Text="否" Value="No" Selected="True"></asp:ListItem>
            </asp:RadioButtonList>
        </td>
    </tr>
    <tr>
        <td>
             <asp:Label ID="Label13" runat="server" Text="*" ForeColor="Red"></asp:Label>
            <asp:Label ID="Label3" runat="server" Text="加班時數"></asp:Label>
        </td>
        <td colspan="3">
            <asp:Label ID="lblHours" runat="server" Text=""></asp:Label>
            <asp:TextBox ID="txtHours" runat="server" Text="" style="display:none"></asp:TextBox>
            <asp:TextBox ID="txtUnit" runat="server" Text="" style="display:none"></asp:TextBox>
            <asp:TextBox ID="txtError" runat="server" style="display:none"></asp:TextBox>

            <telerik:RadButton ID="rbtnCal" runat="server" CausesValidation="False" Text="計算"  AutoPostBack="false"  >
            </telerik:RadButton>
           
        </td>
    </tr>
    <tr>
        <td>
            <asp:Label ID="Label7" runat="server" Text="事由"></asp:Label>
        </td>
        <td colspan="3">
            <asp:Label ID="lblRemark" runat="server" Visible="False" ></asp:Label>
            <asp:TextBox ID="txtRemark" runat="server" Width="100%" TextMode="MultiLine" Rows="4" ></asp:TextBox>
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
            <asp:CustomValidator ID="cvCal" runat="server" ErrorMessage="請先計算請假時(天)數" Display="Dynamic"  ></asp:CustomValidator>
        </td>
    </tr>
        <tr>
        <td>
            <asp:CustomValidator ID="cvApply" runat="server" ErrorMessage="" Display="Dynamic"  ></asp:CustomValidator>
        </td>
    </tr>
</table>
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
<asp:HiddenField ID="hfOverTimeType" Value="" runat="server" />
<asp:HiddenField ID="hfCheckPunch" Value="" runat="server" />
