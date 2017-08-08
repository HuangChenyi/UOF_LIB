<%@ Control Language="C#" AutoEventWireup="true" Inherits="EIP_Duty_Configuration_Setting_UC_Setting" CodeBehind="UC_Setting.ascx.cs" %>
<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<script id="settingJS" type="text/javascript">
    Sys.Application.add_load(function () {
        SetEnableWorkDayOT();
        SetEnableDayoffOT();
        SetEnableRoutineOT();
        SetEnableHolidayOT();
    });
    function OnValueChanging(sender, args) {
        if (args.get_newValue() === "" || isNaN(args.get_newValue())) {
            args.set_newValue(args.get_oldValue());
        }
    }
    function NewKeyPress(sender, args) {

        var keyCharacter = args.get_keyCharacter();

        if (keyCharacter == sender.get_numberFormat().DecimalSeparator ||
            keyCharacter == sender.get_numberFormat().NegativeSign) {

            args.set_cancel(true);
        }
    }
    function Setting_chbParentSetting_Click() {
        var toolbarbutton = $find("<%=settingToolBar.ClientID%>").findItemByValue("useParent");
        var settingCheckBox = $telerik.findElement(toolbarbutton.get_element(), ("chbParentSetting"));
        if (settingCheckBox.checked) {
            if (!confirm('<%=lbConfirmCheckBox.Text%>'))
                settingCheckBox.checked = false;
            return false;
        }
    }

    function CheckInputDays(sender, args) {
        var rbTimeOffdays = $("#<%=rbTimeOffdays.ClientID%>");
        var rnTimeOff = $find("<%=rnTimeOff.ClientID%>").get_value();
        if (rbTimeOffdays.is(":checked")) {
            if (rnTimeOff === "") {
                args.IsValid = false;
            }
        }
    }

    function CheckMHourIsEmpty(e, args) {
        var m_MDay = $find("<%=rdMaleOTHour.ClientID%>").get_value();
        var m_WDay = $find("<%=rdMaleOTHourWDay.ClientID%>").get_value();
        var m_HDay = $find("<%=rdMaleOTHourHDay.ClientID%>").get_value();

        if (m_MDay === '' || m_WDay === '' || m_HDay === '') {
            args.IsValid = false;
            return;
        }
    }

    function CheckFHourIsEmpty(e, args) {
        var f_MDay = $find("<%=rdFemaleOTHour.ClientID%>").get_value();
        var f_WDay = $find("<%=rdFemaleOTHourWDay.ClientID%>").get_value();
        var f_HDay = $find("<%=rdFemaleOTHourHDay.ClientID%>").get_value();

        if (f_MDay === '' || f_WDay === '' || f_HDay === '') {
            args.IsValid = false;
            return;
        }
    }

    function CopyWorkDayLevel1UpHoursToDown(e, args)
    {
        $find("<%=rncWorkDayLevel2Down.ClientID%>").set_value(args.get_newValue());    
        $find("<%=rncWorkDayLevel1Set.ClientID%>").set_value(args.get_newValue());        
    }

    function CopyWorkDayLevel2UpHoursToDown(e, args)
    {
        $find('<%=rncWorkDayLevel3Down.ClientID %>').set_value(args.get_newValue());
        $find("<%=rncWorkDayLevel2Set.ClientID%>").set_value(args.get_newValue()); 
    }

    function CopyWorkDayLevel3UpHoursToDown(e, args)
    {
        $find("<%=rncWorkDayLevel3Set.ClientID%>").set_value(args.get_newValue()); 
    }

    function CopyDayoffLevel1UpHoursToDown(e, args)
    {        
        $find('<%=rncDayoffLevel2Down.ClientID %>').set_value(args.get_newValue());
        $find("<%=rncDayoffLevel1Set.ClientID%>").set_value(args.get_newValue());
    }

    function CopyDayoffLevel2UpHoursToDown(e, args)
    {
        $find('<%=rncDayoffLevel3Down.ClientID %>').set_value(args.get_newValue());
        $find("<%=rncDayoffLevel2Set.ClientID%>").set_value(args.get_newValue());
    }

    function CopyDayoffLevel3UpHoursToDown(e, args)
    {
        $find("<%=rncDayoffLevel3Set.ClientID%>").set_value(args.get_newValue());
    }

    function CopyRoutineLevel1UpHoursToDown(e, args)
    {        
        $find('<%=rncRoutineLevel2Down.ClientID %>').set_value(args.get_newValue());
        $find("<%=rncRoutineLevel1Set.ClientID%>").set_value(args.get_newValue());
    }

    function CopyRoutineLevel2UpHoursToDown(e, args)
    {
        $find('<%=rncRoutineLevel3Down.ClientID %>').set_value(args.get_newValue());
        $find("<%=rncRoutineLevel2Set.ClientID%>").set_value(args.get_newValue());
    }

    function CopyRoutineLevel3UpHoursToDown(e, args)
    {
        $find("<%=rncRoutineLevel3Set.ClientID%>").set_value(args.get_newValue());
    }

    function CopyHolidayLevel1UpHoursToDown(e, args)
    {        
        $find('<%=rncHolidayLevel2Down.ClientID %>').set_value(args.get_newValue());
        $find("<%=rncHolidayLevel1Set.ClientID%>").set_value(args.get_newValue());
    }

    function CopyHolidayLevel2UpHoursToDown(e, args)
    {
        $find('<%=rncHolidayLevel3Down.ClientID %>').set_value(args.get_newValue());
        $find("<%=rncHolidayLevel2Set.ClientID%>").set_value(args.get_newValue());
    }

    function CopyHolidayLevel3UpHoursToDown(e, args)
    {
        $find("<%=rncHolidayLevel3Set.ClientID%>").set_value(args.get_newValue());
    }

    function CheckWorkDaySetting(e, args)
    {
        var level1Up = $find("<%=rncWorkDayLevel1Up.ClientID%>").get_value();
        var level1Set = $find("<%=rncWorkDayLevel1Set.ClientID%>").get_value();
        var level2Up = $find("<%=rncWorkDayLevel2Up.ClientID%>").get_value();
        var level2Set = $find("<%=rncWorkDayLevel2Set.ClientID%>").get_value();
        var level3Up = $find("<%=rncWorkDayLevel3Up.ClientID%>").get_value();
        var level3Set = $find("<%=rncWorkDayLevel3Set.ClientID%>").get_value();

        var level1Down = $find('<%=rncWorkDayLevel1Down.ClientID %>').get_value();
        var level2Down = $find("<%=rncWorkDayLevel2Down.ClientID%>").get_value();
        var level3Down = $find('<%=rncWorkDayLevel3Down.ClientID %>').get_value();

        //判斷訖跟進位後的值都要填
        if ((level1Up === '' && level1Set != '') ||
            (level1Up != '' && level1Set === '') ||
            (level2Up === '' && level2Set != '') ||
            (level2Up != '' && level2Set === '') ||
            (level3Up === '' && level3Set != '') ||
            (level3Up != '' && level3Set === ''))
        {
            args.IsValid = false;
            return;
        }

        //判斷第一階或第二階沒填，就不能填第三階。
        if ((level3Up != '' || level3Set != '') && (level1Up === '' || level1Set === '' || level2Up === '' || level2Set === ''))
        {
            args.IsValid = false;
            return;
        }

        //判斷第一階沒填，就不能填第二階。
        if ((level2Up != '' || level2Set != '') && (level1Up === '' || level1Set === ''))
        {
            args.IsValid = false;
            return;
        }

        //判斷設定值訖不能大於起
        if ((level1Up != '' && level1Up <= level1Down) ||
            (level2Up != '' && level2Up <= level2Down) ||
            (level3Up != '' && level3Up <= level3Down))
        {
            args.IsValid = false;
            return;
        }
    }

    function CheckDayoffSetting(e, args)
    {
        var level1Up = $find("<%=rncDayoffLevel1Up.ClientID%>").get_value();
        var level1Set = $find("<%=rncDayoffLevel1Set.ClientID%>").get_value();
        var level2Up = $find("<%=rncDayoffLevel2Up.ClientID%>").get_value();
        var level2Set = $find("<%=rncDayoffLevel2Set.ClientID%>").get_value();
        var level3Up = $find("<%=rncDayoffLevel3Up.ClientID%>").get_value();
        var level3Set = $find("<%=rncDayoffLevel3Set.ClientID%>").get_value();

        var level1Down = $find('<%=rncDayoffLevel1Down.ClientID %>').get_value();
        var level2Down = $find('<%=rncDayoffLevel2Down.ClientID %>').get_value();
        var level3Down = $find('<%=rncDayoffLevel3Down.ClientID %>').get_value();

        //判斷訖跟進位後的值都要填
        if ((level1Up === '' && level1Set != '') ||
            (level1Up != '' && level1Set === '') ||
            (level2Up === '' && level2Set != '') ||
            (level2Up != '' && level2Set === '') ||
            (level3Up === '' && level3Set != '') ||
            (level3Up != '' && level3Set === ''))
        {
            args.IsValid = false;
            return;
        }

        //判斷第一階或第二階沒填，就不能填第三階。
        if ((level3Up != '' || level3Set != '') && (level1Up === '' || level1Set === '' || level2Up === '' || level2Set === ''))
        {
            args.IsValid = false;
            return;
        }

        //判斷第一階沒填，就不能填第二階。
        if ((level2Up != '' || level2Set != '') && (level1Up === '' || level1Set === ''))
        {
            args.IsValid = false;
            return;
        }

        //判斷設定值訖不能大於起
        if ((level1Up != '' && level1Up <= level1Down) ||
            (level2Up != '' && level2Up <= level2Down) ||
            (level3Up != '' && level3Up <= level3Down))
        {
            args.IsValid = false;
            return;
        }
    }

    function CheckRoutineSetting(e, args)
    {
        var level1Up = $find("<%=rncRoutineLevel1Up.ClientID%>").get_value();
        var level1Set = $find("<%=rncRoutineLevel1Set.ClientID%>").get_value();
        var level2Up = $find("<%=rncRoutineLevel2Up.ClientID%>").get_value();
        var level2Set = $find("<%=rncRoutineLevel2Set.ClientID%>").get_value();
        var level3Up = $find("<%=rncRoutineLevel3Up.ClientID%>").get_value();
        var level3Set = $find("<%=rncRoutineLevel3Set.ClientID%>").get_value();

        var level1Down = $find('<%=rncRoutineLevel1Down.ClientID %>').get_value();
        var level2Down = $find('<%=rncRoutineLevel2Down.ClientID %>').get_value();
        var level3Down = $find('<%=rncRoutineLevel3Down.ClientID %>').get_value();

        //判斷訖跟進位後的值都要填
        if ((level1Up === '' && level1Set != '') ||
            (level1Up != '' && level1Set === '') ||
            (level2Up === '' && level2Set != '') ||
            (level2Up != '' && level2Set === '') ||
            (level3Up === '' && level3Set != '') ||
            (level3Up != '' && level3Set === ''))
        {
            args.IsValid = false;
            return;
        }

        //判斷第一階或第二階沒填，就不能填第三階。
        if ((level3Up != '' || level3Set != '') && (level1Up === '' || level1Set === '' || level2Up === '' || level2Set === ''))
        {
            args.IsValid = false;
            return;
        }

        //判斷第一階沒填，就不能填第二階。
        if ((level2Up != '' || level2Set != '') && (level1Up === '' || level1Set === ''))
        {
            args.IsValid = false;
            return;
        }

        //判斷設定值訖不能大於起
        if ((level1Up != '' && level1Up <= level1Down) ||
            (level2Up != '' && level2Up <= level2Down) ||
            (level3Up != '' && level3Up <= level3Down))
        {
            args.IsValid = false;
            return;
        }
    }

    function CheckHolidaySetting(e, args)
    {
        var level1Up = $find("<%=rncHolidayLevel1Up.ClientID%>").get_value();
        var level1Set = $find("<%=rncHolidayLevel1Set.ClientID%>").get_value();
        var level2Up = $find("<%=rncHolidayLevel2Up.ClientID%>").get_value();
        var level2Set = $find("<%=rncHolidayLevel2Set.ClientID%>").get_value();
        var level3Up = $find("<%=rncHolidayLevel3Up.ClientID%>").get_value();
        var level3Set = $find("<%=rncHolidayLevel3Set.ClientID%>").get_value();

        var level1Down = $find('<%=rncHolidayLevel1Down.ClientID %>').get_value();
        var level2Down = $find('<%=rncHolidayLevel2Down.ClientID %>').get_value();
        var level3Down = $find('<%=rncHolidayLevel3Down.ClientID %>').get_value();

        //判斷訖跟進位後的值都要填
        if ((level1Up === '' && level1Set != '') ||
            (level1Up != '' && level1Set === '') ||
            (level2Up === '' && level2Set != '') ||
            (level2Up != '' && level2Set === '') ||
            (level3Up === '' && level3Set != '') ||
            (level3Up != '' && level3Set === ''))
        {
            args.IsValid = false;
            return;
        }

        //判斷第一階或第二階沒填，就不能填第三階。
        if ((level3Up != '' || level3Set != '') && (level1Up === '' || level1Set === '' || level2Up === '' || level2Set === ''))
        {
            args.IsValid = false;
            return;
        }

        //判斷第一階沒填，就不能填第二階。
        if ((level2Up != '' || level2Set != '') && (level1Up === '' || level1Set === ''))
        {
            args.IsValid = false;
            return;
        }

        //判斷設定值訖不能大於起
        if ((level1Up != '' && level1Up <= level1Down) ||
            (level2Up != '' && level2Up <= level2Down) ||
            (level3Up != '' && level3Up <= level3Down))
        {
            args.IsValid = false;
            return;
        }
    }
    function SetEnableWorkDayOT() {
        var toolbarbutton = $find("<%=settingToolBar.ClientID%>").findItemByValue("useParent");
        var settingCheckBox = $telerik.findElement(toolbarbutton.get_element(), ("chbParentSetting"));

        var bothcheck = $('#<%=cbWorkDayOTBoth.ClientID %>').is(":checked");
        var timeoff = $('#<%=cbWorkDayTimeoff.ClientID %>');
        var payment = $('#<%=cbWorkDayPayment.ClientID %>');

        if (!settingCheckBox.checked) {
            if (bothcheck == true) {
                timeoff.attr("checked", false);
                payment.attr("checked", false);
            }
        }
    }

    function SetWorkDayOTCheck() {
        var toolbarbutton = $find("<%=settingToolBar.ClientID%>").findItemByValue("useParent");
        var settingCheckBox = $telerik.findElement(toolbarbutton.get_element(), ("chbParentSetting"));

        var both = $('#<%=cbWorkDayOTBoth.ClientID %>');
        var timeoffcheck = $('#<%=cbWorkDayTimeoff.ClientID %>').is(":checked");
        var paymentcheck = $('#<%=cbWorkDayPayment.ClientID %>').is(":checked");

        if (!settingCheckBox.checked) {
            if (timeoffcheck == true || paymentcheck == true) {
                both.attr("checked", false);
            }
        }
    }

    function SetEnableDayoffOT()
    {
       var toolbarbutton = $find("<%=settingToolBar.ClientID%>").findItemByValue("useParent");
        var settingCheckBox = $telerik.findElement(toolbarbutton.get_element(), ("chbParentSetting"));

        var bothcheck = $('#<%=cbDayoffOTBoth.ClientID %>').is(":checked");
        var timeoff = $('#<%=cbDayoffTimeoff.ClientID %>');
        var payment = $('#<%=cbDayoffPayment.ClientID %>');

        if (!settingCheckBox.checked) {
            if (bothcheck == true) {
                timeoff.attr("checked", false);
                payment.attr("checked", false);
            }
        }
    }

    function SetDayoffOTCheck()
    {
       var toolbarbutton = $find("<%=settingToolBar.ClientID%>").findItemByValue("useParent");
        var settingCheckBox = $telerik.findElement(toolbarbutton.get_element(), ("chbParentSetting"));

        var both = $('#<%=cbDayoffOTBoth.ClientID %>');
        var timeoffcheck = $('#<%=cbDayoffTimeoff.ClientID %>').is(":checked");
        var paymentcheck = $('#<%=cbDayoffPayment.ClientID %>').is(":checked");

        if (!settingCheckBox.checked) {
            if (timeoffcheck == true || paymentcheck == true) {
                both.attr("checked", false);
            }
        }
    }

    function SetEnableRoutineOT()
    {
        var toolbarbutton = $find("<%=settingToolBar.ClientID%>").findItemByValue("useParent");
        var settingCheckBox = $telerik.findElement(toolbarbutton.get_element(), ("chbParentSetting"));
        var bothcheck = $('#<%=cbRoutineOTBoth.ClientID %>').is(":checked");
        var timeoff = $('#<%=cbRoutineTimeoff.ClientID %>');
        var payment = $('#<%=cbRoutinePayment.ClientID %>');

        if (!settingCheckBox.checked) {
            if (bothcheck == true) {
                timeoff.attr("checked", false);
                payment.attr("checked", false);
            }
        }
    }

    function SetRoutineOTCheck()
    {
        var toolbarbutton = $find("<%=settingToolBar.ClientID%>").findItemByValue("useParent");
        var settingCheckBox = $telerik.findElement(toolbarbutton.get_element(), ("chbParentSetting"));
        var both = $('#<%=cbRoutineOTBoth.ClientID %>');
        var timeoffcheck = $('#<%=cbRoutineTimeoff.ClientID %>').is(":checked");
        var paymentcheck = $('#<%=cbRoutinePayment.ClientID %>').is(":checked");

        if (!settingCheckBox.checked) {
            if (timeoffcheck == true || paymentcheck == true) {
                both.attr("checked", false);
            }
        }
    }

    function SetEnableHolidayOT() {
        var toolbarbutton = $find("<%=settingToolBar.ClientID%>").findItemByValue("useParent");
        var settingCheckBox = $telerik.findElement(toolbarbutton.get_element(), ("chbParentSetting"));
        var bothcheck = $('#<%=cbHolidayOTBoth.ClientID %>').is(":checked");
        var timeoff = $('#<%=cbHolidayTimeoff.ClientID %>');
        var payment = $('#<%=cbHolidayPayment.ClientID %>');

        if (!settingCheckBox.checked) {
            if (bothcheck == true) {
                timeoff.attr("checked", false);
                payment.attr("checked", false);
            }
        }
    }

    function SetHolidayOTCheck()
    {
        var toolbarbutton = $find("<%=settingToolBar.ClientID%>").findItemByValue("useParent");
        var settingCheckBox = $telerik.findElement(toolbarbutton.get_element(), ("chbParentSetting"));
        var both = $('#<%=cbHolidayOTBoth.ClientID %>');
        var timeoffcheck = $('#<%=cbHolidayTimeoff.ClientID %>').is(":checked");
        var paymentcheck = $('#<%=cbHolidayPayment.ClientID %>').is(":checked");

        if (!settingCheckBox.checked) {
            if (timeoffcheck == true || paymentcheck == true) {
                both.attr("checked", false);
            }
        }
    }

    function CheckWorkDayChangeType(sender, args) {        
        var overTimeCheck = $('#<%=cbOverTimeWorkDay.ClientID %>').is(":checked");//可加班
        var timeoffCheck = $('#<%=cbWorkDayTimeoff.ClientID %>').is(":checked");//轉補休
        var paymentCheck = $('#<%=cbWorkDayPayment.ClientID %>').is(":checked");//轉費用
        var bothCheck = $('#<%=cbWorkDayOTBoth.ClientID %>').is(":checked");//轉補休及費用
        
        if (overTimeCheck == true) {
            if (timeoffCheck == false && paymentCheck == false && bothCheck == false) {
                args.IsValid = false;
            }
            else {
                args.IsValid = true;
            }
        }
        else {
            args.IsValid = true;
        }
    }

    function CheckDayoffChangeType(sender, args) {        
        var overTimeCheck = $('#<%=cbOverTimeDayoff.ClientID %>').is(":checked");//可加班
        var timeoffCheck = $('#<%=cbDayoffTimeoff.ClientID %>').is(":checked");//轉補休
        var paymentCheck = $('#<%=cbDayoffPayment.ClientID %>').is(":checked");//轉費用
        var bothCheck = $('#<%=cbDayoffOTBoth.ClientID %>').is(":checked");//轉補休及費用
        
        if (overTimeCheck == true) {
            if (timeoffCheck == false && paymentCheck == false && bothCheck == false) {
                args.IsValid = false;
            }
            else {
                args.IsValid = true;
            }
        }
        else {
            args.IsValid = true;
        }
    }

    function CheckRoutineChangeType(sender, args) {        
        var overTimeCheck = $('#<%=cbOverTimeRoutine.ClientID %>').is(":checked");//可加班
        var timeoffCheck = $('#<%=cbRoutineTimeoff.ClientID %>').is(":checked");//轉補休
        var paymentCheck = $('#<%=cbRoutinePayment.ClientID %>').is(":checked");//轉費用
        var bothCheck = $('#<%=cbRoutineOTBoth.ClientID %>').is(":checked");//轉補休及費用
        
        if (overTimeCheck == true) {
            if (timeoffCheck == false && paymentCheck == false && bothCheck == false) {
                args.IsValid = false;
            }
            else {
                args.IsValid = true;
            }
        }
        else {
            args.IsValid = true;
        }
    }

    function CheckHolidayChangeType(sender, args) {        
        var overTimeCheck = $('#<%=cbOverTimeHoliday.ClientID %>').is(":checked");//可加班
        var timeoffCheck = $('#<%=cbHolidayTimeoff.ClientID %>').is(":checked");//轉補休
        var paymentCheck = $('#<%=cbHolidayPayment.ClientID %>').is(":checked");//轉費用
        var bothCheck = $('#<%=cbHolidayOTBoth.ClientID %>').is(":checked");//轉補休及費用
        
        if (overTimeCheck == true) {
            if (timeoffCheck == false && paymentCheck == false && bothCheck == false) {
                args.IsValid = false;
            }
            else {
                args.IsValid = true;
            }
        }
        else {
            args.IsValid = true;
        }
    }
</script>
<style type="text/css">
    .RightAligned {
        text-align: right;
    }
</style>
<telerik:RadToolBar ID="settingToolBar" runat="server" Width="100%" OnButtonClick="settingToolBar_OnButtonClick" meta:resourcekey="settingToolBarResource1" SingleClick="None">
    <Items>
        <telerik:RadToolBarButton runat="server" Value="useParent" meta:resourcekey="RadToolBarButtonResource1">
            <ItemTemplate>
                <asp:CheckBox ID="chbParentSetting" runat="server" Text="使用上一部門設定" AutoPostBack="True"
                    OnCheckedChanged="chbParentSetting_CheckedChanged" onClick="Setting_chbParentSetting_Click()" meta:resourcekey="chbParentSettingResource1" />
            </ItemTemplate>
        </telerik:RadToolBarButton>
        <telerik:RadToolBarButton IsSeparator="True" meta:resourcekey="RadToolBarButtonResource2"></telerik:RadToolBarButton>
        <telerik:RadToolBarButton runat="server" Text="儲存" Value="Save" ValidationGroup="vgCheckInputDays"
            CheckedImageUrl="~/Common/Images/Icon/icon_m01.png"
            DisabledImageUrl="~/Common/Images/Icon/icon_m01.png"
            HoveredImageUrl="~/Common/Images/Icon/icon_m01.png"
            ImageUrl="~/Common/Images/Icon/icon_m01.png"
            meta:resourcekey="settingToolBarSaveResource1">
        </telerik:RadToolBarButton>
        <telerik:RadToolBarButton IsSeparator="true" meta:resourcekey="RadToolBarButtonResource3"></telerik:RadToolBarButton>
    </Items>
</telerik:RadToolBar>
<table width="100%" class="PopTable">
    <tr>
        <td style="white-space: nowrap;">
            <span style="color: #ff0000">*</span><asp:Label ID="Label3" runat="server"
                Text="男性加班時數上限" meta:resourcekey="Label3Resource1"></asp:Label>
        </td>
        <td style="white-space: nowrap;">
            <table>
                <tr>
                    <td>
                        <asp:Label ID="Label9" runat="server" Text="每月:" meta:resourcekey="Label9Resource1"></asp:Label>
                    </td>
                    <td>
                        <telerik:RadNumericTextBox ID="rdMaleOTHour" runat="server" Value="0" MinValue="0" MaxValue="999.9" MaxLength="5" Width="100px" CssClass="RightAligned" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="40px" meta:resourcekey="rdMaleOTHourResource1">
                            <ClientEvents OnValueChanging="OnValueChanging" />
                        </telerik:RadNumericTextBox>
                    </td>
                    <td>
                        <asp:Label ID="Label2" runat="server" Text="小時"
                            meta:resourcekey="Label2Resource1"></asp:Label>
                    </td>
                    <td style="width: 30px;"></td>
                    <td>
                        <asp:Label ID="Label11" runat="server" Text="平日每日:" meta:resourcekey="Label11Resource1"></asp:Label>
                    </td>
                    <td>
                        <telerik:RadNumericTextBox ID="rdMaleOTHourWDay" runat="server" CssClass="RightAligned" Value="0" MinValue="0" Width="100px" MaxValue="999.9" MaxLength="5" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="40px" meta:resourcekey="rdMaleOTHourWDayResource1">
                            <ClientEvents OnValueChanging="OnValueChanging" />
                        </telerik:RadNumericTextBox>
                    </td>
                    <td>
                        <asp:Label ID="Label12" runat="server" Text="小時" meta:resourcekey="Label12Resource1"></asp:Label>
                    </td>
                    <td style="width: 30px;"></td>
                    <td>
                        <asp:Label ID="Label20" runat="server" Text="假日每日:" meta:resourcekey="Label20Resource1"></asp:Label>
                    </td>
                    <td>
                        <telerik:RadNumericTextBox ID="rdMaleOTHourHDay" runat="server" CssClass="RightAligned" Value="0" MinValue="0" Width="100px" MaxValue="999.9" MaxLength="5" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="40px" meta:resourcekey="rdMaleOTHourHDayResource1">
                            <ClientEvents OnValueChanging="OnValueChanging" />
                        </telerik:RadNumericTextBox>
                    </td>
                    <td>
                        <asp:Label ID="Label21" runat="server" Text="小時" meta:resourcekey="Label21Resource1"></asp:Label>
                    </td>
                    <td style="width: 30px;"></td>
                    <td>
                        <asp:CustomValidator ID="cvCheckMHourIsEmpty" runat="server" ErrorMessage="時數上限不可為空白" Display="Dynamic" ClientValidationFunction="CheckMHourIsEmpty" ValidationGroup="vgCheckInputDays" meta:resourcekey="cvCheckMHourIsEmptyResource1"></asp:CustomValidator>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>
            <span style="color: #ff0000">*</span><asp:Label ID="Label5" runat="server"
                Text="女性加班時數上限" meta:resourcekey="Label5Resource1"></asp:Label>
        </td>
        <td>
            <table>
                <tr>
                    <td>
                        <asp:Label ID="Label17" runat="server" Text="每月:" meta:resourcekey="Label17Resource1"></asp:Label>
                    </td>
                    <td>
                        <telerik:RadNumericTextBox ID="rdFemaleOTHour" runat="server" CssClass="RightAligned" Value="0" MinValue="0" Width="100px" MaxValue="999.9" MaxLength="5" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="40px" meta:resourcekey="rdFemaleOTHourResource1">
                            <ClientEvents OnValueChanging="OnValueChanging" />
                        </telerik:RadNumericTextBox>
                    </td>
                    <td>
                        <asp:Label ID="Label15" runat="server" Text="小時"
                            meta:resourcekey="Label15Resource1"></asp:Label>
                    </td>
                    <td style="width: 30px;"></td>
                    <td>
                        <asp:Label ID="Label18" runat="server" Text="平日每日:" meta:resourcekey="Label18Resource1"></asp:Label>
                    </td>
                    <td>
                        <telerik:RadNumericTextBox ID="rdFemaleOTHourWDay" runat="server" CssClass="RightAligned" Value="0" MinValue="0" Width="100px" MaxValue="999.9" MaxLength="5" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="40px" meta:resourcekey="rdFemaleOTHourWDayResource1">
                            <ClientEvents OnValueChanging="OnValueChanging" />
                        </telerik:RadNumericTextBox>
                    </td>
                    <td>
                        <asp:Label ID="Label19" runat="server" Text="小時" meta:resourcekey="Label19Resource1"></asp:Label>
                    </td>
                    <td style="width: 30px;"></td>
                    <td>
                        <asp:Label ID="Label22" runat="server" Text="假日每日:" meta:resourcekey="Label22Resource1"></asp:Label>
                    </td>
                    <td>
                        <telerik:RadNumericTextBox ID="rdFemaleOTHourHDay" runat="server" CssClass="RightAligned" Value="0" MinValue="0" Width="100px" MaxValue="999.9" MaxLength="5" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="40px" meta:resourcekey="rdFemaleOTHourHDayResource1">
                            <ClientEvents OnValueChanging="OnValueChanging" />
                        </telerik:RadNumericTextBox>
                    </td>
                    <td>
                        <asp:Label ID="Label23" runat="server" Text="小時" meta:resourcekey="Label23Resource1"></asp:Label>
                    </td>
                    <td style="width: 30px;"></td>
                    <td>
                        <asp:CustomValidator ID="cvCheckFHourIsEmpty" runat="server" ErrorMessage="時數上限不可為空白" Display="Dynamic" ClientValidationFunction="CheckFHourIsEmpty" ValidationGroup="vgCheckInputDays" meta:resourcekey="cvCheckFHourIsEmptyResource1"></asp:CustomValidator>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>
            <span style="color: #ff0000">*</span><asp:Label ID="Label8" runat="server"
                Text="每日允許遲到分鐘數" meta:resourcekey="Label8Resource1"></asp:Label>
        </td>
        <td>
            <table>
                <tr>
                    <td>
                        <telerik:RadNumericTextBox ID="rdLateMin" runat="server" CssClass="RightAligned" Value="0" MaxValue="999" MinValue="0" Width="100px" MaxLength="3" DataType="System.Int32" Culture="zh-TW" DbValueFactor="1" LabelWidth="40px" meta:resourcekey="rdLateMinResource1">
                            <NumberFormat GroupSeparator="" DecimalDigits="0"></NumberFormat>
                            <ClientEvents OnValueChanging="OnValueChanging" OnKeyPress="NewKeyPress" />
                        </telerik:RadNumericTextBox>
                    </td>
                    <td>
                        <asp:Label ID="Label16" runat="server" Text="分鐘"
                            meta:resourcekey="Label16Resource1"></asp:Label>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>
            <span style="color: #ff0000">*</span><asp:Label ID="Label4" runat="server"
                Text="每期可遲到次數" meta:resourcekey="Label4Resource1"></asp:Label>
        </td>
        <td>
            <table>
                <tr>
                    <td>
                        <telerik:RadNumericTextBox ID="rdLateTimes" runat="server" CssClass="RightAligned" Value="0" MaxValue="999" MinValue="0" Width="100px" MaxLength="3" DataType="System.Int32" Culture="zh-TW" DbValueFactor="1" LabelWidth="40px" meta:resourcekey="rdLateTimesResource1">
                            <NumberFormat GroupSeparator="" DecimalDigits="0"></NumberFormat>
                            <ClientEvents OnValueChanging="OnValueChanging" OnKeyPress="NewKeyPress" />
                        </telerik:RadNumericTextBox>
                    </td>
                    <td>
                        <asp:Label ID="Label6" runat="server" Text="次"
                            meta:resourcekey="Label6Resource1"></asp:Label>
                        <asp:Label ID="Label7" runat="server"
                            Text="(若遲到次數在允許次數之內,該次遲到列入遲到記錄,但不需要請假.如果超出次數,該次遲到不列入遲到記錄,且以曠職計)"
                            CssClass="SizeMemo" meta:resourcekey="Label7Resource1"></asp:Label>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>
            <span style="color: #ff0000">*</span><asp:Label ID="Label10" runat="server"
                Text="工時" meta:resourcekey="Label10Resource1"></asp:Label>
        </td>
        <td>
            <table>
                <tr>
                    <td>
                        <asp:Label ID="Label" runat="server" Text="全天:"
                            meta:resourcekey="LabelResource1"></asp:Label>
                    </td>
                    <td>
                        <telerik:RadNumericTextBox ID="rdAllDayHours" runat="server" CssClass="RightAligned" MinValue="0.5" Width="100px" MaxValue="24" MaxLength="4" Value="8" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="40px" meta:resourcekey="rdAllDayHoursResource1">
                            <NumberFormat ZeroPattern="n" DecimalDigits="2"></NumberFormat>
                            <ClientEvents OnValueChanging="OnValueChanging" />
                        </telerik:RadNumericTextBox>
                    </td>
                    <td>
                        <asp:Label ID="Label13" runat="server" Text="小時"
                            meta:resourcekey="Label13Resource1"></asp:Label>
                    </td>
                    <td width="30"></td>
                    <td>
                        <asp:Label ID="Label1" runat="server" Text="半天:"
                            meta:resourcekey="Label1Resource1"></asp:Label>
                    </td>
                    <td>
                        <telerik:RadNumericTextBox ID="rdHalfDayHours" runat="server" CssClass="RightAligned" MinValue="0.5" Width="100px" MaxValue="24" Value="4" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="40px" meta:resourcekey="rdHalfDayHoursResource1">
                            <ClientEvents OnValueChanging="OnValueChanging" />
                        </telerik:RadNumericTextBox>
                    </td>
                    <td>
                        <asp:Label ID="Label14" runat="server" Text="小時" meta:resourcekey="Label14Resource1"></asp:Label>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>
            <asp:Label ID="lblTimeOffTitle" runat="server" Text="補休假可用期限" meta:resourcekey="lblTimeOffTitleResource1"></asp:Label>
        </td>
        <td>
            <table style="text-align: left;">
                <tr>
                    <td>
                        <asp:RadioButton ID="rbTimeOffBySystem" runat="server" GroupName="TimeOffSelect" meta:resourcekey="rbTimeOffBySystemResource1" />
                    </td>
                    <td colspan="4">
                        <asp:Label ID="lblTimeOffBySystem" runat="server" Text="依系統設定" meta:resourcekey="lblTimeOffBySystemResource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:RadioButton ID="rbTimeOffdays" runat="server" GroupName="TimeOffSelect" meta:resourcekey="rbTimeOffdaysResource1" />
                    </td>
                    <td>
                        <asp:Label ID="lblTimeOffAfter" runat="server" Text="加班日起" meta:resourcekey="lblTimeOffAfterResource1"></asp:Label>
                    </td>
                    <td>
                        <telerik:RadNumericTextBox ID="rnTimeOff" MaxLength="4" MinValue="0" MaxValue="9999"
                            Width="40px" runat="server" DataType="System.Decimal" Culture="zh-TW"
                            DbValueFactor="1" LabelWidth="64px" meta:resourcekey="rnTimeOffResource1">
                            <NegativeStyle Resize="None" />
                            <NumberFormat DecimalDigits="0" ZeroPattern="n" />
                            <ClientEvents OnValueChanging="OnValueChanging" />
                            <EmptyMessageStyle Resize="None" />
                            <ReadOnlyStyle Resize="None" />
                            <FocusedStyle Resize="None" />
                            <DisabledStyle Resize="None" />
                            <InvalidStyle Resize="None" />
                            <HoveredStyle Resize="None" />
                            <EnabledStyle HorizontalAlign="Right" Resize="None" />
                        </telerik:RadNumericTextBox>
                    </td>
                    <td style="text-align: left">
                        <asp:Label ID="lblTimeOffDay" runat="server" Text="天" meta:resourcekey="lblTimeOffDayResource1"></asp:Label>
                    </td>
                    <td>
                        <asp:CustomValidator ID="cvCheckInputDays" runat="server" ErrorMessage="請輸入天數" Display="Dynamic" ClientValidationFunction="CheckInputDays" ValidationGroup="vgCheckInputDays" meta:resourcekey="cvCheckInputDaysResource1"></asp:CustomValidator>
                    </td>
                </tr>
            </table>
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <table style="text-align: left;">
                        <tr>
                            <td>
                                <asp:RadioButton ID="rbTimeOffdate" runat="server" GroupName="TimeOffSelect" meta:resourcekey="rbTimeOffdateResource1" />
                            </td>
                            <td>
                                <asp:Label ID="lblTimeOffEnd" runat="server" Text="截止日" meta:resourcekey="lblTimeOffEndResource1"></asp:Label>
                            </td>
                            <td>
                                <asp:UpdatePanel ID="UpdatePanel13" runat="server">
                                    <ContentTemplate>
                                        <asp:DropDownList ID="ddlTimeOffMonth" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlTimeOffMonth_SelectedIndexChanged" meta:resourcekey="ddlTimeOffMonthResource1"></asp:DropDownList>
                                        <asp:DropDownList ID="ddlTimeOffDay" runat="server" meta:resourcekey="ddlTimeOffDayResource1"></asp:DropDownList>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
            </asp:UpdatePanel>
        </td>
    </tr>
    <tr>
        <td>
            <asp:Label ID="Label28" runat="server" Text="加班時數算法" meta:resourcekey="Label28Resource1"></asp:Label>
        </td>
        <td>
            <table style="width: 400px" cellspacing="5">
                <tr>
                    <td style=" white-space:nowrap;">
                        <asp:Label ID="Label24" runat="server" Text="工作日:" meta:resourcekey="Label24Resource1"></asp:Label>                    
                    </td>
                    <td style=" white-space:nowrap;" height="30">
                        <asp:CheckBox ID="cbOverTimeWorkDay" runat="server" Text="可加班" meta:resourcekey="cbOverTimeWorkDayResource1" />&nbsp;&nbsp;&nbsp;
                        <asp:CheckBox ID="cbWorkDayTimeoff" runat="server" Text="轉補休" onclick="SetWorkDayOTCheck()" meta:resourcekey="cbWorkDayTimeoffResource1" />&nbsp;
                        <asp:CheckBox ID="cbWorkDayPayment" runat="server" Text="轉費用" onclick="SetWorkDayOTCheck()" meta:resourcekey="cbWorkDayPaymentResource1" />&nbsp;
                        <asp:CheckBox ID="cbWorkDayOTBoth" runat="server" Text="轉補休及費用" onclick="SetEnableWorkDayOT()" meta:resourcekey="cbWorkDayOTBothResource1"/>
                        <asp:CustomValidator ID="cvWorkDayChangeType" runat="server" ErrorMessage="請勾選給付方式" Display="Dynamic" ClientValidationFunction="CheckWorkDayChangeType" ValidationGroup="vgCheckInputDays" meta:resourcekey="cvWorkDayChangeTypeResource1"></asp:CustomValidator>
                    </td>
                </tr>
                <tr>
                    <td>
                    </td>
                    <td style=" white-space:nowrap;">
                        <telerik:RadNumericTextBox ID="rncWorkDayLevel1Down" runat="server" CssClass="RightAligned" MinValue="0" Value="0" ReadOnly="True" BorderStyle="None" Width="45px" MaxValue="24" MaxLength="4" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="20px" meta:resourcekey="rncWorkDayLevel2UpResource1">
                            <NumberFormat ZeroPattern="n" DecimalDigits="0"></NumberFormat>
                        </telerik:RadNumericTextBox>
                        <asp:Label ID="Label29" runat="server" Text="小時" meta:resourcekey="Label29Resource1"></asp:Label>
                        <asp:Label ID="Label30" runat="server" Text="~" meta:resourcekey="Label30Resource1"></asp:Label>
                        <telerik:RadNumericTextBox ID="rncWorkDayLevel1Up" runat="server" CssClass="RightAligned" MinValue="0" Width="50px" MaxValue="24" MaxLength="4" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="20px" meta:resourcekey="rncWorkDayLevel1UpResource1">
                            <NumberFormat ZeroPattern="n" DecimalDigits="1"></NumberFormat>
                            <ClientEvents OnValueChanging="CopyWorkDayLevel1UpHoursToDown"/>
                        </telerik:RadNumericTextBox>
                        <asp:Label ID="Label35" runat="server" Text="小時(含)" meta:resourcekey="Label35Resource1"></asp:Label>
                        <asp:Label ID="Label41" runat="server" Text="，以" meta:resourcekey="Label41Resource1"></asp:Label>
                        <telerik:RadNumericTextBox ID="rncWorkDayLevel1Set" runat="server" CssClass="RightAligned" MinValue="0" Width="50px" MaxValue="24" MaxLength="4" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="20px" meta:resourcekey="rncWorkDayLevel1SetResource1">
                            <NumberFormat ZeroPattern="n" DecimalDigits="1"></NumberFormat>
                        </telerik:RadNumericTextBox>
                        <asp:Label ID="Label38" runat="server" Text="小時" meta:resourcekey="Label38Resource1"></asp:Label>
                        <asp:Label ID="Label46" runat="server" Text="計算" meta:resourcekey="Label46Resource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td>
                        <telerik:RadNumericTextBox ID="rncWorkDayLevel2Down" runat="server" CssClass="RightAligned" MinValue="0" ReadOnly="True" BorderStyle="None" Width="45px" MaxValue="24" MaxLength="4" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="20px" meta:resourcekey="rncWorkDayLevel2UpResource1">
                            <NumberFormat ZeroPattern="n" DecimalDigits="1"></NumberFormat>
                        </telerik:RadNumericTextBox>
                        <asp:Label ID="Label31" runat="server" Text="小時" meta:resourcekey="Label31Resource1"></asp:Label>
                        <asp:Label ID="Label32" runat="server" Text="~" meta:resourcekey="Label32Resource1"></asp:Label>
                        <telerik:RadNumericTextBox ID="rncWorkDayLevel2Up" runat="server" CssClass="RightAligned" MinValue="0" Width="50px" MaxValue="24" MaxLength="4" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="20px" meta:resourcekey="rncWorkDayLevel2UpResource1">
                            <NumberFormat ZeroPattern="n" DecimalDigits="1"></NumberFormat>
                            <ClientEvents OnValueChanging="CopyWorkDayLevel2UpHoursToDown"/>
                        </telerik:RadNumericTextBox>
                        <asp:Label ID="Label36" runat="server" Text="小時(含)" meta:resourcekey="Label36Resource1"></asp:Label>
                        <asp:Label ID="Label42" runat="server" Text="，以" meta:resourcekey="Label42Resource1"></asp:Label>
                        <telerik:RadNumericTextBox ID="rncWorkDayLevel2Set" runat="server" CssClass="RightAligned" MinValue="0" Width="50px" MaxValue="24" MaxLength="4" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="20px" meta:resourcekey="rncWorkDayLevel2SetResource1">
                            <NumberFormat ZeroPattern="n" DecimalDigits="1"></NumberFormat>
                        </telerik:RadNumericTextBox>
                        <asp:Label ID="Label39" runat="server" Text="小時" meta:resourcekey="Label39Resource1"></asp:Label>
                        <asp:Label ID="Label45" runat="server" Text="計算" meta:resourcekey="Label45Resource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td>
                        <telerik:RadNumericTextBox ID="rncWorkDayLevel3Down" runat="server" CssClass="RightAligned" MinValue="0" ReadOnly="True" BorderStyle="None" Width="45px" MaxValue="24" MaxLength="4" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="20px" meta:resourcekey="rncWorkDayLevel2UpResource1">
                            <NumberFormat ZeroPattern="n" DecimalDigits="1"></NumberFormat>
                        </telerik:RadNumericTextBox>
                        <asp:Label ID="Label33" runat="server" Text="小時" meta:resourcekey="Label33Resource1"></asp:Label>
                        <asp:Label ID="Label34" runat="server" Text="~" meta:resourcekey="Label34Resource1"></asp:Label>
                        <telerik:RadNumericTextBox ID="rncWorkDayLevel3Up" runat="server" CssClass="RightAligned" MinValue="0" Width="50px" MaxValue="24" MaxLength="4" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="20px" meta:resourcekey="rncWorkDayLevel3UpResource1">
                            <NumberFormat ZeroPattern="n" DecimalDigits="1"></NumberFormat>
                            <ClientEvents OnValueChanging="CopyWorkDayLevel3UpHoursToDown"/>
                        </telerik:RadNumericTextBox>
                        <asp:Label ID="Label37" runat="server" Text="小時(含)" meta:resourcekey="Label37Resource1"></asp:Label>
                        <asp:Label ID="Label43" runat="server" Text="，以" meta:resourcekey="Label43Resource1"></asp:Label>
                        <telerik:RadNumericTextBox ID="rncWorkDayLevel3Set" runat="server" CssClass="RightAligned" MinValue="0" Width="50px" MaxValue="24" MaxLength="4" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="20px" meta:resourcekey="rncWorkDayLevel3SetResource1">
                            <NumberFormat ZeroPattern="n" DecimalDigits="1"></NumberFormat>
                        </telerik:RadNumericTextBox>
                        <asp:Label ID="Label40" runat="server" Text="小時" meta:resourcekey="Label40Resource1"></asp:Label>
                        <asp:Label ID="Label44" runat="server" Text="計算" meta:resourcekey="Label44Resource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td>
                        <asp:CustomValidator ID="cvCheckWorkDay" runat="server" ErrorMessage="時數進位設定不正確" Display="Dynamic" ClientValidationFunction="CheckWorkDaySetting" ValidationGroup="vgCheckInputDays" meta:resourcekey="cvCheckWorkDayResource1"></asp:CustomValidator>
                    </td>
                </tr>
                <tr>
                    <td style=" white-space:nowrap;">
                        <asp:Label ID="Label25" runat="server" Text="休息日:" meta:resourcekey="Label25Resource1"></asp:Label>
                    </td>
                    <td style=" white-space:nowrap;" height="30">
                        <asp:CheckBox ID="cbOverTimeDayoff" runat="server" Text="可加班" meta:resourcekey="cbOverTimeDayoffResource1"/>&nbsp;&nbsp;&nbsp;
                        <asp:CheckBox ID="cbDayoffTimeoff" runat="server" Text="轉補休" onclick="SetDayoffOTCheck()" meta:resourcekey="cbDayoffTimeoffResource1" />&nbsp;
                        <asp:CheckBox ID="cbDayoffPayment" runat="server" Text="轉費用" onclick="SetDayoffOTCheck()" meta:resourcekey="cbDayoffPaymentResource1" />&nbsp;
                        <asp:CheckBox ID="cbDayoffOTBoth" runat="server" Text="轉補休及費用" onclick="SetEnableDayoffOT()" meta:resourcekey="cbDayoffOTBothResource1"/>
                        <asp:CustomValidator ID="cvDayoffChangeType" runat="server" ErrorMessage="請勾選給付方式" Display="Dynamic" ClientValidationFunction="CheckDayoffChangeType" ValidationGroup="vgCheckInputDays"  meta:resourcekey="cvDayoffChangeTypeResource1"></asp:CustomValidator>
                    </td>
                </tr>
                <tr>
                    <td>
                        &nbsp;</td>
                    <td style=" white-space:nowrap;">
                        <telerik:RadNumericTextBox ID="rncDayoffLevel1Down" runat="server" CssClass="RightAligned" MinValue="0" Value="0" ReadOnly="True" BorderStyle="None" Width="45px" MaxValue="24" MaxLength="4" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="20px" meta:resourcekey="rncWorkDayLevel2UpResource1">
                            <NumberFormat ZeroPattern="n" DecimalDigits="0"></NumberFormat>
                        </telerik:RadNumericTextBox>
                        <asp:Label ID="Label47" runat="server" Text="小時" meta:resourcekey="Label47Resource1"></asp:Label>
                        <asp:Label ID="Label48" runat="server" Text="~" meta:resourcekey="Label48Resource1"></asp:Label>
                        <telerik:RadNumericTextBox ID="rncDayoffLevel1Up" runat="server" CssClass="RightAligned" MinValue="0" Width="50px" MaxValue="24" MaxLength="4" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="20px" meta:resourcekey="rncDayoffLevel1UpResource1">
                            <NumberFormat ZeroPattern="n" DecimalDigits="1"></NumberFormat>
                            <ClientEvents OnValueChanging="CopyDayoffLevel1UpHoursToDown"/>
                        </telerik:RadNumericTextBox>
                        <asp:Label ID="Label53" runat="server" Text="小時(含)" meta:resourcekey="Label53Resource1"></asp:Label>
                        <asp:Label ID="Label54" runat="server" Text="，以" meta:resourcekey="Label54Resource1"></asp:Label>
                        <telerik:RadNumericTextBox ID="rncDayoffLevel1Set" runat="server" CssClass="RightAligned" MinValue="0" Width="50px" MaxValue="24" MaxLength="4" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="20px" meta:resourcekey="rncDayoffLevel1SetResource1">
                            <NumberFormat ZeroPattern="n" DecimalDigits="1"></NumberFormat>
                        </telerik:RadNumericTextBox>
                        <asp:Label ID="Label59" runat="server" Text="小時" meta:resourcekey="Label59Resource1"></asp:Label>
                        <asp:Label ID="Label60" runat="server" Text="計算" meta:resourcekey="Label60Resource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td>
                        <telerik:RadNumericTextBox ID="rncDayoffLevel2Down" runat="server" CssClass="RightAligned" MinValue="0" ReadOnly="True" BorderStyle="None" Width="45px" MaxValue="24" MaxLength="4" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="20px" meta:resourcekey="rncWorkDayLevel2UpResource1">
                            <NumberFormat ZeroPattern="n" DecimalDigits="1"></NumberFormat>
                        </telerik:RadNumericTextBox>
                        <asp:Label ID="Label49" runat="server" Text="小時" meta:resourcekey="Label49Resource1"></asp:Label>
                        <asp:Label ID="Label50" runat="server" Text="~" meta:resourcekey="Label50Resource1"></asp:Label>
                        <telerik:RadNumericTextBox ID="rncDayoffLevel2Up" runat="server" CssClass="RightAligned" MinValue="0" Width="50px" MaxValue="24" MaxLength="4" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="20px" meta:resourcekey="rncDayoffLevel2UpResource1">
                            <NumberFormat ZeroPattern="n" DecimalDigits="1"></NumberFormat>
                            <ClientEvents OnValueChanging="CopyDayoffLevel2UpHoursToDown"/>
                        </telerik:RadNumericTextBox>
                        <asp:Label ID="Label55" runat="server" Text="小時(含)" meta:resourcekey="Label55Resource1"></asp:Label>
                        <asp:Label ID="Label56" runat="server" Text="，以" meta:resourcekey="Label56Resource1"></asp:Label>
                        <telerik:RadNumericTextBox ID="rncDayoffLevel2Set" runat="server" CssClass="RightAligned" MinValue="0" Width="50px" MaxValue="24" MaxLength="4" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="20px" meta:resourcekey="rncDayoffLevel2SetResource1">
                            <NumberFormat ZeroPattern="n" DecimalDigits="1"></NumberFormat>
                        </telerik:RadNumericTextBox>
                        <asp:Label ID="Label61" runat="server" Text="小時" meta:resourcekey="Label61Resource1"></asp:Label>
                        <asp:Label ID="Label62" runat="server" Text="計算" meta:resourcekey="Label62Resource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td>
                        <telerik:RadNumericTextBox ID="rncDayoffLevel3Down" runat="server" CssClass="RightAligned" MinValue="0" ReadOnly="True" BorderStyle="None" Width="45px" MaxValue="24" MaxLength="4" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="20px" meta:resourcekey="rncWorkDayLevel2UpResource1">
                            <NumberFormat ZeroPattern="n" DecimalDigits="1"></NumberFormat>
                        </telerik:RadNumericTextBox>
                        <asp:Label ID="Label51" runat="server" Text="小時" meta:resourcekey="Label51Resource1"></asp:Label>
                        <asp:Label ID="Label52" runat="server" Text="~" meta:resourcekey="Label52Resource1"></asp:Label>
                        <telerik:RadNumericTextBox ID="rncDayoffLevel3Up" runat="server" CssClass="RightAligned" MinValue="0" Width="50px" MaxValue="24" MaxLength="4" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="20px" meta:resourcekey="rncDayoffLevel3UpResource1">
                            <NumberFormat ZeroPattern="n" DecimalDigits="1"></NumberFormat>
                            <ClientEvents OnValueChanging="CopyDayoffLevel3UpHoursToDown"/>
                        </telerik:RadNumericTextBox>
                        <asp:Label ID="Label57" runat="server" Text="小時(含)" meta:resourcekey="Label57Resource1"></asp:Label>
                        <asp:Label ID="Label58" runat="server" Text="，以" meta:resourcekey="Label58Resource1"></asp:Label>
                        <telerik:RadNumericTextBox ID="rncDayoffLevel3Set" runat="server" CssClass="RightAligned" MinValue="0" Width="50px" MaxValue="24" MaxLength="4" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="20px" meta:resourcekey="rncDayoffLevel3SetResource1">
                            <NumberFormat ZeroPattern="n" DecimalDigits="1"></NumberFormat>
                        </telerik:RadNumericTextBox>
                        <asp:Label ID="Label63" runat="server" Text="小時" meta:resourcekey="Label63Resource1"></asp:Label>
                        <asp:Label ID="Label64" runat="server" Text="計算" meta:resourcekey="Label64Resource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td>
                        <asp:CustomValidator ID="cvCheckDayoff" runat="server" ErrorMessage="時數進位設定不正確" Display="Dynamic" ClientValidationFunction="CheckDayoffSetting" ValidationGroup="vgCheckInputDays" meta:resourcekey="cvCheckDayoffResource1"></asp:CustomValidator>
                    </td>
                </tr>
                <tr>
                    <td style=" white-space:nowrap;">
                        <asp:Label ID="Label26" runat="server" Text="例假日:" meta:resourcekey="Label26Resource1"></asp:Label>
                    </td>
                    <td style=" white-space:nowrap;" height="30">
                        <asp:CheckBox ID="cbOverTimeRoutine" runat="server" Text="可加班" meta:resourcekey="cbOverTimeRoutineResource1"/>&nbsp;&nbsp;&nbsp;
                        <asp:CheckBox ID="cbRoutineTimeoff" runat="server" Text="轉補休" onclick="SetRoutineOTCheck()" meta:resourcekey="cbRoutineTimeoffResource1" />&nbsp;
                        <asp:CheckBox ID="cbRoutinePayment" runat="server" Text="轉費用" onclick="SetRoutineOTCheck()" meta:resourcekey="cbRoutinePaymentResource1" />&nbsp;
                        <asp:CheckBox ID="cbRoutineOTBoth" runat="server" Text="轉補休及費用" onclick="SetEnableRoutineOT()" meta:resourcekey="cbRoutineOTBothResource1"/>
                        <asp:CustomValidator ID="cvRoutineChangeType" runat="server" ErrorMessage="請勾選給付方式" Display="Dynamic" ClientValidationFunction="CheckRoutineChangeType" ValidationGroup="vgCheckInputDays" meta:resourcekey="cvRoutineChangeTypeResource1"></asp:CustomValidator>
                    </td>
                </tr>
                <tr>
                    <td>
                        &nbsp;</td>
                    <td style=" white-space:nowrap;">
                        <telerik:RadNumericTextBox ID="rncRoutineLevel1Down" runat="server" CssClass="RightAligned" MinValue="0" Value="0" ReadOnly="True" BorderStyle="None" Width="45px" MaxValue="24" MaxLength="4" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="20px" meta:resourcekey="rncWorkDayLevel2UpResource1">
                            <NumberFormat ZeroPattern="n" DecimalDigits="0"></NumberFormat>
                        </telerik:RadNumericTextBox>
                        <asp:Label ID="Label65" runat="server" Text="小時" meta:resourcekey="Label65Resource1"></asp:Label>
                        <asp:Label ID="Label66" runat="server" Text="~" meta:resourcekey="Label66Resource1"></asp:Label>
                        <telerik:RadNumericTextBox ID="rncRoutineLevel1Up" runat="server" CssClass="RightAligned" MinValue="0" Width="50px" MaxValue="24" MaxLength="4" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="20px" meta:resourcekey="rncRoutineLevel1UpResource1">
                            <NumberFormat ZeroPattern="n" DecimalDigits="1"></NumberFormat>
                            <ClientEvents OnValueChanging="CopyRoutineLevel1UpHoursToDown"/>
                        </telerik:RadNumericTextBox>
                        <asp:Label ID="Label71" runat="server" Text="小時(含)" meta:resourcekey="Label71Resource1"></asp:Label>
                        <asp:Label ID="Label72" runat="server" Text="，以" meta:resourcekey="Label72Resource1"></asp:Label>
                        <telerik:RadNumericTextBox ID="rncRoutineLevel1Set" runat="server" CssClass="RightAligned" MinValue="0" Width="50px" MaxValue="24" MaxLength="4" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="20px" meta:resourcekey="rncRoutineLevel1SetResource1">
                            <NumberFormat ZeroPattern="n" DecimalDigits="1"></NumberFormat>
                        </telerik:RadNumericTextBox>
                        <asp:Label ID="Label77" runat="server" Text="小時" meta:resourcekey="Label77Resource1"></asp:Label>
                        <asp:Label ID="Label78" runat="server" Text="計算" meta:resourcekey="Label78Resource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td>
                        <telerik:RadNumericTextBox ID="rncRoutineLevel2Down" runat="server" CssClass="RightAligned" MinValue="0" ReadOnly="True" BorderStyle="None" Width="45px" MaxValue="24" MaxLength="4" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="20px" meta:resourcekey="rncWorkDayLevel2UpResource1">
                            <NumberFormat ZeroPattern="n" DecimalDigits="1"></NumberFormat>
                        </telerik:RadNumericTextBox>
                        <asp:Label ID="Label67" runat="server" Text="小時" meta:resourcekey="Label67Resource1"></asp:Label>
                        <asp:Label ID="Label68" runat="server" Text="~" meta:resourcekey="Label68Resource1"></asp:Label>
                        <telerik:RadNumericTextBox ID="rncRoutineLevel2Up" runat="server" CssClass="RightAligned" MinValue="0" Width="50px" MaxValue="24" MaxLength="4" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="20px" meta:resourcekey="rncRoutineLevel2UpResource1">
                            <NumberFormat ZeroPattern="n" DecimalDigits="1"></NumberFormat>
                            <ClientEvents OnValueChanging="CopyRoutineLevel2UpHoursToDown"/>
                        </telerik:RadNumericTextBox>
                        <asp:Label ID="Label73" runat="server" Text="小時(含)" meta:resourcekey="Label73Resource1"></asp:Label>
                        <asp:Label ID="Label74" runat="server" Text="，以" meta:resourcekey="Label74Resource1"></asp:Label>
                        <telerik:RadNumericTextBox ID="rncRoutineLevel2Set" runat="server" CssClass="RightAligned" MinValue="0" Width="50px" MaxValue="24" MaxLength="4" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="20px" meta:resourcekey="rncRoutineLevel2SetResource1">
                            <NumberFormat ZeroPattern="n" DecimalDigits="1"></NumberFormat>
                        </telerik:RadNumericTextBox>
                        <asp:Label ID="Label79" runat="server" Text="小時" meta:resourcekey="Label79Resource1"></asp:Label>
                        <asp:Label ID="Label80" runat="server" Text="計算" meta:resourcekey="Label80Resource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td>
                        <telerik:RadNumericTextBox ID="rncRoutineLevel3Down" runat="server" CssClass="RightAligned" MinValue="0" ReadOnly="True" BorderStyle="None" Width="45px" MaxValue="24" MaxLength="4" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="20px" meta:resourcekey="rncWorkDayLevel2UpResource1">
                            <NumberFormat ZeroPattern="n" DecimalDigits="1"></NumberFormat>
                        </telerik:RadNumericTextBox>
                        <asp:Label ID="Label69" runat="server" Text="小時" meta:resourcekey="Label69Resource1"></asp:Label>
                        <asp:Label ID="Label70" runat="server" Text="~" meta:resourcekey="Label70Resource1"></asp:Label>
                        <telerik:RadNumericTextBox ID="rncRoutineLevel3Up" runat="server" CssClass="RightAligned" MinValue="0" Width="50px" MaxValue="24" MaxLength="4" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="20px" meta:resourcekey="rncRoutineLevel3UpResource1">
                            <NumberFormat ZeroPattern="n" DecimalDigits="1"></NumberFormat>
                            <ClientEvents OnValueChanging="CopyRoutineLevel3UpHoursToDown"/>
                        </telerik:RadNumericTextBox>
                        <asp:Label ID="Label75" runat="server" Text="小時(含)" meta:resourcekey="Label75Resource1"></asp:Label>
                        <asp:Label ID="Label76" runat="server" Text="，以" meta:resourcekey="Label76Resource1"></asp:Label>
                        <telerik:RadNumericTextBox ID="rncRoutineLevel3Set" runat="server" CssClass="RightAligned" MinValue="0" Width="50px" MaxValue="24" MaxLength="4" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="20px" meta:resourcekey="rncRoutineLevel3SetResource1">
                            <NumberFormat ZeroPattern="n" DecimalDigits="1"></NumberFormat>
                        </telerik:RadNumericTextBox>
                        <asp:Label ID="Label81" runat="server" Text="小時" meta:resourcekey="Label81Resource1"></asp:Label>
                        <asp:Label ID="Label82" runat="server" Text="計算" meta:resourcekey="Label82Resource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td>
                        <asp:CustomValidator ID="cvCheckRoutine" runat="server" ErrorMessage="時數進位設定不正確" Display="Dynamic" ClientValidationFunction="CheckRoutineSetting" ValidationGroup="vgCheckInputDays" meta:resourcekey="cvCheckRoutineResource1"></asp:CustomValidator>
                    </td>
                </tr>
                <tr>
                    <td style=" white-space:nowrap;">
                        <asp:Label ID="Label27" runat="server" Text="國定假日:" meta:resourcekey="Label27Resource1"></asp:Label>
                    </td>
                    <td style=" white-space:nowrap;" height="30">
                        <asp:CheckBox ID="cbOverTimeHoliday" runat="server" Text="可加班" meta:resourcekey="cbOverTimeHolidayResource1"/>&nbsp;&nbsp;&nbsp;
                        <asp:CheckBox ID="cbHolidayTimeoff" runat="server" Text="轉補休" onclick="SetHolidayOTCheck()" meta:resourcekey="cbHolidayTimeoffResource1" />&nbsp;
                        <asp:CheckBox ID="cbHolidayPayment" runat="server" Text="轉費用" onclick="SetHolidayOTCheck()" meta:resourcekey="cbHolidayPaymentResource1" />&nbsp;
                        <asp:CheckBox ID="cbHolidayOTBoth" runat="server" Text="轉補休及費用" onclick="SetEnableHolidayOT()" meta:resourcekey="cbHolidayOTBothResource1"/>
                        <asp:CustomValidator ID="cvHolidayChangeType" runat="server" ErrorMessage="請勾選給付方式" Display="Dynamic" ClientValidationFunction="CheckHolidayChangeType" ValidationGroup="vgCheckInputDays" meta:resourcekey="cvHolidayChangeTypeResource1"></asp:CustomValidator>
                    </td>
                </tr>
                <tr>
                    <td>
                        &nbsp;</td>
                    <td style=" white-space:nowrap;">
                        <telerik:RadNumericTextBox ID="rncHolidayLevel1Down" runat="server" CssClass="RightAligned" MinValue="0" Value="0" ReadOnly="True" BorderStyle="None" Width="45px" MaxValue="24" MaxLength="4" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="20px" meta:resourcekey="rncWorkDayLevel2UpResource1">
                            <NumberFormat ZeroPattern="n" DecimalDigits="0"></NumberFormat>
                        </telerik:RadNumericTextBox>
                        <asp:Label ID="Label83" runat="server" Text="小時" meta:resourcekey="Label83Resource1"></asp:Label>
                        <asp:Label ID="Label84" runat="server" Text="~" meta:resourcekey="Label84Resource1"></asp:Label>
                        <telerik:RadNumericTextBox ID="rncHolidayLevel1Up" runat="server" CssClass="RightAligned" MinValue="0" Width="50px" MaxValue="24" MaxLength="4" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="20px" meta:resourcekey="rncHolidayLevel1UpResource1">
                            <NumberFormat ZeroPattern="n" DecimalDigits="1"></NumberFormat>
                            <ClientEvents OnValueChanging="CopyHolidayLevel1UpHoursToDown"/>
                        </telerik:RadNumericTextBox>
                        <asp:Label ID="Label89" runat="server" Text="小時(含)" meta:resourcekey="Label89Resource1"></asp:Label>
                        <asp:Label ID="Label90" runat="server" Text="，以" meta:resourcekey="Label90Resource1"></asp:Label>
                        <telerik:RadNumericTextBox ID="rncHolidayLevel1Set" runat="server" CssClass="RightAligned" MinValue="0" Width="50px" MaxValue="24" MaxLength="4" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="20px" meta:resourcekey="rncHolidayLevel1SetResource1">
                            <NumberFormat ZeroPattern="n" DecimalDigits="1"></NumberFormat>
                        </telerik:RadNumericTextBox>
                        <asp:Label ID="Label95" runat="server" Text="小時" meta:resourcekey="Label95Resource1"></asp:Label>
                        <asp:Label ID="Label96" runat="server" Text="計算" meta:resourcekey="Label96Resource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td>
                        <telerik:RadNumericTextBox ID="rncHolidayLevel2Down" runat="server" CssClass="RightAligned" MinValue="0" Value="0" ReadOnly="True" BorderStyle="None" Width="45px" MaxValue="24" MaxLength="4" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="20px" meta:resourcekey="rncWorkDayLevel2UpResource1">
                            <NumberFormat ZeroPattern="n" DecimalDigits="1"></NumberFormat>
                        </telerik:RadNumericTextBox>
                        <asp:Label ID="Label85" runat="server" Text="小時" meta:resourcekey="Label85Resource1"></asp:Label>
                        <asp:Label ID="Label86" runat="server" Text="~" meta:resourcekey="Label86Resource1"></asp:Label>
                        <telerik:RadNumericTextBox ID="rncHolidayLevel2Up" runat="server" CssClass="RightAligned" MinValue="0" Width="50px" MaxValue="24" MaxLength="4" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="20px" meta:resourcekey="rncHolidayLevel2UpResource1">
                            <NumberFormat ZeroPattern="n" DecimalDigits="1"></NumberFormat>
                            <ClientEvents OnValueChanging="CopyHolidayLevel2UpHoursToDown"/>
                        </telerik:RadNumericTextBox>
                        <asp:Label ID="Label91" runat="server" Text="小時(含)" meta:resourcekey="Label91Resource1"></asp:Label>
                        <asp:Label ID="Label92" runat="server" Text="，以" meta:resourcekey="Label92Resource1"></asp:Label>
                        <telerik:RadNumericTextBox ID="rncHolidayLevel2Set" runat="server" CssClass="RightAligned" MinValue="0" Width="50px" MaxValue="24" MaxLength="4" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="20px" meta:resourcekey="rncHolidayLevel2SetResource1">
                            <NumberFormat ZeroPattern="n" DecimalDigits="1"></NumberFormat>
                        </telerik:RadNumericTextBox>
                        <asp:Label ID="Label97" runat="server" Text="小時" meta:resourcekey="Label97Resource1"></asp:Label>
                        <asp:Label ID="Label98" runat="server" Text="計算" meta:resourcekey="Label98Resource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td>
                        <telerik:RadNumericTextBox ID="rncHolidayLevel3Down" runat="server" CssClass="RightAligned" MinValue="0" Value="0" ReadOnly="True" BorderStyle="None" Width="45px" MaxValue="24" MaxLength="4" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="20px" meta:resourcekey="rncWorkDayLevel2UpResource1">
                            <NumberFormat ZeroPattern="n" DecimalDigits="1"></NumberFormat>
                        </telerik:RadNumericTextBox>
                        <asp:Label ID="Label87" runat="server" Text="小時" meta:resourcekey="Label87Resource1"></asp:Label>
                        <asp:Label ID="Label88" runat="server" Text="~" meta:resourcekey="Label88Resource1"></asp:Label>
                        <telerik:RadNumericTextBox ID="rncHolidayLevel3Up" runat="server" CssClass="RightAligned" MinValue="0" Width="50px" MaxValue="24" MaxLength="4" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="20px" meta:resourcekey="rncHolidayLevel3UpResource1">
                            <NumberFormat ZeroPattern="n" DecimalDigits="1"></NumberFormat>
                            <ClientEvents OnValueChanging="CopyHolidayLevel3UpHoursToDown"/>
                        </telerik:RadNumericTextBox>
                        <asp:Label ID="Label93" runat="server" Text="小時(含)" meta:resourcekey="Label93Resource1"></asp:Label>
                        <asp:Label ID="Label94" runat="server" Text="，以" meta:resourcekey="Label94Resource1"></asp:Label>
                        <telerik:RadNumericTextBox ID="rncHolidayLevel3Set" runat="server" CssClass="RightAligned" MinValue="0" Width="50px" MaxValue="24" MaxLength="4" DataType="System.Decimal" Culture="zh-TW" DbValueFactor="1" LabelWidth="20px" meta:resourcekey="rncHolidayLevel3SetResource1">
                            <NumberFormat ZeroPattern="n" DecimalDigits="1"></NumberFormat>
                        </telerik:RadNumericTextBox>
                        <asp:Label ID="Label99" runat="server" Text="小時" meta:resourcekey="Label99Resource1"></asp:Label>
                        <asp:Label ID="Label100" runat="server" Text="計算" meta:resourcekey="Label100Resource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td>
                        <asp:CustomValidator ID="cvCheckHoliday" runat="server" ErrorMessage="時數進位設定不正確" Display="Dynamic" ClientValidationFunction="CheckHolidaySetting" ValidationGroup="vgCheckInputDays" meta:resourcekey="cvCheckHolidayResource1"></asp:CustomValidator>
                    </td>
                </tr>
            </table>
            <asp:Label ID="Label102" runat="server" Text="1.未輸入表示以實際加班時數計算" CssClass="SizeMemo" meta:resourcekey="Label102Resource1"></asp:Label><br />
            <asp:Label ID="Label101" runat="server" Text="2.允許加班時至少需設定一種給付方式，而所勾選的項目會顯示於加班單3.0的欄位中供申請者選擇，若加班能同時轉補休又轉費用，請勾選「轉補休及費用」選項。" CssClass="SizeMemo" meta:resourcekey="Label101Resource1"></asp:Label>
        </td>
    </tr>
</table>
<asp:Label ID="lbConfirmCheckBox" runat="server"
    Text="確定要使用上一部門設定?     \r\n注意:確認後會刪除此部門所有的自訂資料!!" Visible="False"
    meta:resourcekey="lbConfirmCheckBoxResource1"></asp:Label>
<asp:Label ID="lblDay" runat="server" Text="日" Visible="False" meta:resourcekey="lblDayResource1"></asp:Label>
<asp:Label ID="lblMonth" runat="server" Text="月" Visible="False" meta:resourcekey="lblMonthResource1"></asp:Label>
<asp:HiddenField ID="hfIsDDLselect" runat="server" Value="false" />
<asp:HiddenField ID="hfUserGuid" runat="server" />