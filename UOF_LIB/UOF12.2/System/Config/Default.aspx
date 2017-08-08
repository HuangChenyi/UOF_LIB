<%@ Page Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" Inherits="System_Config_Default" Title="系統組態設定" Culture="auto"
    meta:resourcekey="PageResource1" UICulture="auto" Codebehind="Default.aspx.cs" %>

<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Fast" %>

<%@ Register Src="../../Common/ChoiceCenter/UC_ChoiceList.ascx" TagName="UC_ChoiceList"
    TagPrefix="uc2" %>
<%@ Register Src="~/Common/FileCenter/V3/UC_FileCenter.ascx" TagPrefix="uc2" TagName="UC_FileCenter" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript">

        function ConfirmUpdate(sender, args){
            if (!confirm("<%= lblConfirmUpdate.Text%>")) {
                args.set_cancel(true);
            }
            else {
                args.set_cancel(false);
            }
        }

        function StrongPWDisplayDescription() {
            var cbStrongPW = $("#<%=cbStrongPW.ClientID%>");
            var disablePanel = $("#<%=panDisableStrongPW.ClientID %>");
            var enablePanel = $("#<%=panEnableStrongPW.ClientID %>");
            if (cbStrongPW.is(":checked")) {
                disablePanel.hide();
                enablePanel.show();
            }
            else {
                disablePanel.show();
                enablePanel.hide();
            }

        }
        function DisplayEnableAutoStartUser() {
            var cbEnableAutoStartUser = $("#<%=cbEnableAutoStartUser.ClientID%>");
            var panDisableAutoStartUser = $("#<%=panDisableAutoStartUser.ClientID %>");
            var panEnableAutoStartUser = $("#<%=panEnableAutoStartUser.ClientID %>");

            if (cbEnableAutoStartUser.is(":checked")) {

                panDisableAutoStartUser.hide();
                panEnableAutoStartUser.show();
            }
            else {

                panDisableAutoStartUser.show();
                panEnableAutoStartUser.hide();
            }
        }

        function CheckIPAddress(source, args) {
            if (args.Value != "") {
                var re = /^(\d+)\.(\d+)\.(\d+)\.(\d+)$/g
                if (re.test(args.Value)) {
                    if (RegExp.$1 < 256 && RegExp.$2 < 256 && RegExp.$3 < 256 && RegExp.$4 < 256) {
                        args.IsValid = true;
                        return;
                    }
                }
            }
            args.IsValid = false;
        }

        function CheckNumber(source, args) {
            args.IsValid = true;
            if (args.Value != "") {
                var p = args.Value;
                if (isNaN(p)) {
                    args.IsValid = false;
                }
                else {
                    if (p > 10 || p < 1) {
                        args.IsValid = false;
                    }
                }
            }
            return;
        }

        function getContainingTabIndex(targetControl) {
            var multiPage = $find("<%=RadMultiPage1.ClientID %>");
            var testControl = targetControl;

            while (targetControl != null) {
                testControl = testControl.parentNode;
                var tabIndex;
                for (tabIndex = 0; tabIndex < multiPage.get_pageViews().get_count() ; tabIndex++) {
                    if (multiPage.get_pageViews().getPageView(tabIndex).get_element() == testControl.parentNode) {

                        return tabIndex;
                    }
                }
            }
            return -1;
        }

        function focusInvalid(badControl) {            
            var tabIndexToFocus = getContainingTabIndex(badControl);
            if (tabIndexToFocus > -1) {
                var ultraTab = $find("<%=RadMultiPage1.ClientID %>");
                ultraTab.set_selectedIndex(tabIndexToFocus);
                badControl.focus();
            }
        }

        function preValidate() {
            var i;            
            for (i = 0; i < Page_Validators.length; i++) {
                ValidatorValidate(Page_Validators[i]);
                if (!Page_Validators[i].isvalid) {
                    var badControl = $("#" + Page_Validators[i].controltovalidate);
                    focusInvalid(badControl[0]);
                    return;
                }
            }
        }

        function btnSave_Click(oButton, oEvent) {
            preValidate();
        }

        function RadToolBar_ButtonClicking(sender, args) {
            var Key = args.get_item().get_value();
            if (Key == "Insert") {
                var Domain = "";
                args.set_cancel(true);
                $uof.dialog.open2("~/System/Config/CreateDomain.aspx", args.get_item(), "<%= Label88.Text %>", 470, 160, OpenDialogResult, { "domain": "Domain" });   
            }

            if (Key == "InsertMultiSites") {
                var menuID = "";
                var mode = "Insert";
                args.set_cancel(true);
                $uof.dialog.open2("~/System/Config/ModifyMultiSitesUrl.aspx", args.get_item(), "<%= lblMultiDialogTitle.Text %>", 650, 350, OpenDialogResult, { "MenuID": menuID, "Mode": mode });
            }

            if (Key == "DeleteMultiSites") {

                if (!confirm('<%= lblDelMultiUrl.Text%>')) {
                    args.set_cancel(true);
                }
                else {
                    args.set_cancel(false);
                }
            }

            if (Key == "InsertLymaServer") {
                var mode = "Insert";
                args.set_cancel(true);
                $uof.dialog.open2("~/System/Config/ModifyLyma.aspx", args.get_item(), "<%= lblLymaTitle.Text%>", 550, 300, OpenDialogResult, { "Mode": mode });
              }

              if (Key == "DeleteLymaServer") {

                  if (!confirm('<%= lblDeleteTitle.Text%>')) {
                    args.set_cancel(true);
                }
                else {
                    args.set_cancel(false);
                }
            }

        }

        function ChangeNotShowControl() {
            var rbDefaultByNotShow = $("#<%=rbDefaultByNotShow.ClientID%>");
              var cvNotShowErrorMsg = $("#<%=cvNotShowErrorMsg.ClientID %>");
              if (rbDefaultByNotShow.is(":checked")) {
                  cvNotShowErrorMsg.hide();
              } else {
                  cvNotShowErrorMsg.show();
              }

          }

        $(function () {

            var cb = $("#<%=cbDMSPdfControl.ClientID %>");
            var isverydoc = $("#<%=hideDMSConvert.ClientID %>").val();
            CheckPDFControl(cb, isverydoc);
            cb.change(function () {
                CheckPDFControl(cb, isverydoc);
            });
            ControlScanerOCR();
            var timeZonecb = $("#<%=cbEnableTimeZone.ClientID %>");
            var strTextDisplay = $("#<%=hfTimeZoneTextDisplayControl.ClientID %>").val();
            CheckTimeZoneDisplayControl(timeZonecb, strTextDisplay);
            timeZonecb.change(function () {
                CheckTimeZoneDisplayControl(timeZonecb, strTextDisplay);
            });
        });

        function CheckTimeZoneDisplayControl(cbEnableTimeZone, strTextDisplay) {
            if (cbEnableTimeZone.is(":checked")) {
                $("#<%=rdbtnTimeZoneTextDisplayControl.ClientID %>").find("input").prop('disabled', false);
                if (strTextDisplay == "DISPLAY")
                    $('#<%=rdbtnTimeZoneTextDisplayControl.ClientID %>').find("input[value='DISPLAY']").prop('checked', true);
                else
                    $('#<%=rdbtnTimeZoneTextDisplayControl.ClientID %>').find("input[value='NON_DISPLAY']").prop('checked', true);
            }
            else {

                $("#<%=rdbtnTimeZoneTextDisplayControl.ClientID %>").find("input").prop('disabled', true);
            }
        }

        function CheckPDFControl(rdocontrol, isenable) {
            var boolenable = isenable.toLowerCase() == "true" ? true : false;
            if (rdocontrol.is(":checked") && boolenable) {
                //$("#<%=rdoPDFControl.ClientID %>").prop('disabled', false);
            $("#<%=rdoPDFControl.ClientID %>").find("input").prop('disabled', false);
            if ($('#<%=hidePDFControl.ClientID %>').val() == "")
                $('#<%=rdoPDFControl.ClientID %>').find("input[value='STANDARD']").prop('checked', true);
                else
                    $('#<%=rdoPDFControl.ClientID %>').find("input[value='" + $('#<%=hidePDFControl.ClientID %>').val() + "']").prop('checked', true);
            }
            else {
                var checkvalue = $('#<%=rdoPDFControl.ClientID %> input:checked').val();
            // $('#<%=rdoPDFControl.ClientID %>').find("input[value='" + checkvalue + "']").prop('checked', false);
            if (!boolenable)
                $('#<%=rdoPDFControl.ClientID %>').find("input[value='UOF']").prop('disabled', true);
                else {
                    $("#<%=rdoPDFControl.ClientID %>").find("input").prop('disabled', true);
                }
            }
        }

        function RadToolBarProxy_ButtonClicking(sender, args) {
            var Key = args.get_item().get_value();
            if (Key == "AddProxy") {
                var Domain = "";
                args.set_cancel(true);
                $uof.dialog.open2("~/System/config/EditProxy.aspx", args.get_item(), "", 470, 210, OpenDialogResult);
            }
        }

        function OnValueChanging(sender, args) {
            if (args.get_newValue() == "") {
                args.set_newValue(0);
            }
        }

        function ReserveDayChanging(sender, args) {
            if (args.get_newValue() == "") {
                args.set_newValue(365);
            }
        }

        function OpenDialogResult(returnValue) {

            if (typeof (returnValue) == "undefined" || returnValue == null) {
                return false;
            }
            else {
                return true;
            }
        }

        function rbtnSetConnParam_Clicking(sender, args) {
            args.set_cancel(true);
            var smtpServer = $("#<%= txbSmtp.ClientID %>").val();
            var smtpPort = $("#<%= txbPort.ClientID %>").val();
            var smtpAccount = $("#<%= txbAccount.ClientID %>").val();
            var SmtpPwd = $("#<%= txbPwd0.ClientID %>").val();
            var Sender = $("#<%= txbSender.ClientID %>").val();
            var ssl = $("#<%= chkSSL.ClientID %>").is(':checked');
            $uof.dialog.open2("~/System/Config/SmtpConn.aspx", args, "", 500, 330, SetConnDialogResult,
                { "SmtpServer": smtpServer, "SmtpPort": smtpPort, "SmtpAccount": smtpAccount, "SmtpPwd": SmtpPwd, "Sender": Sender, "SSL": ssl });
        }

        function SetConnDialogResult(returnValue) {
            if (typeof (returnValue) != 'undefined' && returnValue != null) {
                var results = returnValue.split(',');
                $("#<%= txbSmtp.ClientID %>").val(results[0]);
                $("#<%= txbPort.ClientID %>").val(results[1]);
                $("#<%= txbAccount.ClientID %>").val(results[2]);
                $("#<%= txbPwd0.ClientID %>").val(results[3]);
                $("#<%= txbSender.ClientID %>").val(results[4]);

                $("#<%= txbPwd0.ClientID %>").val($("#<%= txbPwd0.ClientID %>").val());
            }

        }

        function RemoveImage() {
            $("#<%=imgLogo.ClientID %>").attr('src', '').hide();
        }        

        function removeByNotShow() {
            $("#<%=imgByNotShow.ClientID %>").attr('src', '').hide();
        }
        
        function OnClientClicking(sender, args) {
            var fid = $("#<%=hideFileGroupID.ClientID %>").val();
            $uof.dialog.open2("~/System/Config/EditLogo.aspx", sender,
          "", 500, 400, OpenDialogResult, { 'filegroupid': fid });
        }
        function OpenDialogResult(returnValue) {
            if (typeof (returnValue) == "undefined")
                return false;
            else
                return true;
        }

        function bigPictureDelete(sender, args) {
            if (confirm("<%=lbConfirmDelete.Text%>")) {
                args.set_cancel(false);
            }
            else {
                args.set_cancel(true);
            }
        }

        function toolbarAPI_ButtonClicking(sender, args) {
            var Key = args.get_item().get_value();
            if (Key == "NewAPIPrivateKey") {
                args.set_cancel(true);
                $uof.dialog.open2("~/System/config/MaintainAPIPrivateKey.aspx", args.get_item(), "", 470, 160, OpenDialogResult);
            }
            else if (Key == "DeleteAPIPrivateKey") {
                if (!confirm('<%= lblDeleteTitle.Text%>')) {
                    args.set_cancel(true);
                }
                else {
                    args.set_cancel(false);
                }
            }
        }


        function ControlScanerOCR()
        {
            var filescan = $('#<%=ckbEnableFileScan.ClientID%>')
            var scanocr = $('#<%=showFileScanOCR.ClientID%>')
            if (filescan.is(":checked"))
                scanocr.show();
            else
                scanocr.hide();
        }


    </script>
    <telerik:RadTabStrip ID="RadTabStrip1" MultiPageID="RadMultiPage1" BackColor="White"
        runat="server" SelectedIndex="0" meta:resourcekey="RadTabStrip1Resource1">
        <Tabs>
            <telerik:RadTab Text="基本設定" Value="basicSet"
                meta:resourcekey="RadTabResource1" Selected="True">
            </telerik:RadTab>
            <telerik:RadTab Text="登入設定" Value="loginSet" meta:resourcekey="RadTabResource2"></telerik:RadTab>
            <telerik:RadTab Text="模組設定" Value="moduleSet"
                meta:resourcekey="RadTabResource3">
            </telerik:RadTab>
            <telerik:RadTab Text="整合服務" Value="CommSet" meta:resourcekey="RadTabResource4"></telerik:RadTab>
            <telerik:RadTab Text="集團設定" Value="MultiSitesSet"
                meta:resourcekey="RadTabResource5">
            </telerik:RadTab>
            <telerik:RadTab Text="Proxy設定" Value="Proxy" meta:resourcekey="RadTabResource6"></telerik:RadTab>
        </Tabs>
    </telerik:RadTabStrip>
    <telerik:RadMultiPage ID="RadMultiPage1" runat="server" SelectedIndex="0"
        BackColor="White" meta:resourcekey="RadMultiPage1Resource1">
        <telerik:RadPageView ID="basicSet" runat="server"
            meta:resourcekey="basicSetResource1" Selected="True">
            <table border="0"  class="PopTable" style="width:100%">
                <tr>
                    <td style="text-align: left" colspan="4" class="PopTableLeftTD">
                        <asp:CustomValidator ID="CustomValidator1" runat="server" Display="Dynamic" ErrorMessage="已順利完成"
                            ForeColor="Blue" meta:resourcekey="CustomValidator1Resource1"></asp:CustomValidator>
                    </td>
                </tr>
                <tr>
                    <td colspan="4" class="PopTableHeader" style="text-align:left">
                        <asp:Label ID="lbLeftMailSetting" runat="server" Text="郵件設定" meta:resourcekey="lbLeftMailSettingResource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td  style="width: 13%; word-break: break-all; white-space:nowrap" class="PopTableLeftTD">
                        <asp:Label ID="Label2" runat="server" Text="*" ForeColor="Red" meta:resourcekey="Label2Resource1"></asp:Label><asp:Label
                            ID="lbLeftSmtp" runat="server" Text="SMTP Server" meta:resourcekey="lbLeftSmtpResource1"></asp:Label>
                    </td>
                    <td style="width: 87%; word-break: break-all" class="PopTableRightTD">
                        <asp:TextBox ID="txbSmtp" runat="server" MaxLength="50" Columns="50" meta:resourcekey="txbSmtpResource1"></asp:TextBox><asp:RequiredFieldValidator
                            ID="RequiredFieldValidator4" runat="server" ControlToValidate="txbSmtp" Display="Dynamic"
                            ErrorMessage="SMTP Server 不允許為空白" meta:resourcekey="RequiredFieldValidator4Resource1"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td style="width: 13%; word-break: break-all; white-space:nowrap" class="PopTableLeftTD">
                        <asp:Label ID="lbLeftAccount" runat="server" Text="SMTP認證帳號" meta:resourcekey="lbLeftAccountResource1"></asp:Label>
                    </td>
                    <td style="width: 87%; word-break: break-all" class="PopTableRightTD">
                        <asp:TextBox ID="txbAccount" runat="server" MaxLength="50" Width="160px" meta:resourcekey="txbAccountResource1"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 13%; word-break: break-all; white-space:nowrap" class="PopTableLeftTD">
                        <asp:Label ID="lbLeftPwd" runat="server" Text="SMTP認證密碼" meta:resourcekey="lbLeftPwdResource1"></asp:Label>
                    </td>
                    <td style="width: 87%; word-break: break-all" class="PopTableRightTD">
                        <asp:TextBox ID="txbPwd0" runat="server" MaxLength="50" TextMode="Password" Width="160px"
                            meta:resourcekey="txbPwd0Resource1"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td  style="width: 13%; word-break: break-all; white-space:nowrap" class="PopTableLeftTD">
                        <asp:Label ID="Label5" runat="server" Text="*" ForeColor="Red" meta:resourcekey="Label5Resource1"></asp:Label><asp:Label
                            ID="lbLeftPort" runat="server" Text="Port" meta:resourcekey="lbLeftPortResource1"></asp:Label>
                    </td>
                    <td style="width: 87%; word-break: break-all" class="PopTableRightTD">
                        <asp:TextBox ID="txbPort" runat="server" MaxLength="50" Width="40px" meta:resourcekey="txbPortResource1"></asp:TextBox><asp:RequiredFieldValidator
                            ID="RequiredFieldValidator5" runat="server" ControlToValidate="txbPort" Display="Dynamic"
                            ErrorMessage="Port 不允許為空白" meta:resourcekey="RequiredFieldValidator5Resource1"></asp:RequiredFieldValidator><asp:CompareValidator
                                ID="CompareValidator5" runat="server" ControlToValidate="txbPort" Display="Dynamic"
                                ErrorMessage="請輸入數字" Operator="DataTypeCheck" Type="Integer" meta:resourcekey="CompareValidator5Resource1"></asp:CompareValidator>
                    </td>
                </tr>
                 <tr>
                    <td  style="width: 13%; word-break: break-all; white-space:nowrap" class="PopTableLeftTD">
                        <asp:Label ID="lblSSL" runat="server" Text="啟用SSL" meta:resourcekey="lblSSLResource1"></asp:Label>
                    </td>
                    <td style="width: 87%; word-break: break-all" class="PopTableRightTD">
                        <asp:CheckBox ID="chkSSL" runat="server" meta:resourcekey="chkSSLResource2" />&nbsp;
                    </td>
                </tr>
                <tr>
                    <td style="width: 13%; word-break: break-all; white-space:nowrap" class="PopTableLeftTD">
                        <asp:Label ID="Label8" runat="server" Text="*" ForeColor="Red" meta:resourcekey="Label8Resource1"></asp:Label><asp:Label
                            ID="lbLeftSender" runat="server" Text="預設寄件人信箱" meta:resourcekey="lbLeftSenderResource1"></asp:Label>
                    </td>
                    <td style="width: 87%; word-break: break-all" class="PopTableRightTD">
                        <asp:CheckBox ID="cbAlwaysDefaultSender" runat="server" Text="對外郵件一律使用此信箱" meta:resourcekey="cbAlwaysDefaultSenderResource1" />
                        <br />
                        <asp:TextBox ID="txbSender" runat="server" MaxLength="300" Columns="50" meta:resourcekey="txbSenderResource1"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="txbSender"
                            Display="Dynamic" ErrorMessage="寄件人不允許為空白" meta:resourcekey="RequiredFieldValidator6Resource1"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txbSender"
                            Display="Dynamic" ErrorMessage="請輸入正確的Email格式" ValidationExpression="^([0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+[a-zA-Z]{2,9})$|^.+\&lt;([0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+[a-zA-Z]{2,9})\&gt;$"
                            meta:resourcekey="RegularExpressionValidator1Resource1"></asp:RegularExpressionValidator>
                        <br />
                        <asp:Label ID="Label11" runat="server" Text="ex: abc@mail.com or name<abc@mail.com>"
                            CssClass="SizeMemo" meta:resourcekey="Label11Resource1"></asp:Label>
                        <br />

                        <telerik:RadButton ID="rbtnSetConnParam" runat="server" Text="測試連線"
                            CausesValidation="False"
                            meta:resourcekey="rbtnSetConnParamResource1" OnClientClicking="rbtnSetConnParam_Clicking">
                        </telerik:RadButton>

                    </td>
                </tr>
                <tr>
                    <td style="width: 13%; word-break: break-all; white-space:nowrap" class="PopTableLeftTD">
                        <asp:Label ID="Label12" runat="server" Text="*" ForeColor="Red" meta:resourcekey="Label12Resource1"></asp:Label><asp:Label
                            ID="lblSystemAdminEmail" runat="server" Text="系統管理員信箱" meta:resourcekey="lblSystemAdminEmailResource1"></asp:Label>
                    </td>
                    <td style="width: 87%; word-break: break-all" class="PopTableRightTD">
                        <asp:TextBox ID="txbSystemAdminEmail" runat="server" MaxLength="50" Columns="40"
                            meta:resourcekey="txbSystemAdminEmailResource1"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ControlToValidate="txbSystemAdminEmail"
                            ErrorMessage="系統管理員信箱不允許為空白" meta:resourcekey="RequiredFieldValidator7Resource1"
                            Display="Dynamic"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="txbSystemAdminEmail"
                            ErrorMessage="請輸入正確的Email格式" ValidationExpression="^([0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+[a-zA-Z]{2,9})$"
                            meta:resourcekey="RegularExpressionValidator2Resource1" Display="Dynamic"></asp:RegularExpressionValidator>
                    </td>
                </tr>
                <tr>
                    <td  style="width: 13%; word-break: break-all; white-space:nowrap" class="PopTableLeftTD">
                        <asp:Label ID="Label13" runat="server" Text="*" ForeColor="Red" meta:resourcekey="Label13Resource1"></asp:Label><asp:Label
                            ID="lbSiteUrl" runat="server" Text="站台網址" meta:resourcekey="lbSiteUrlResource1"></asp:Label>
                    </td>
                    <td style="width: 87%; word-break: break-all" class="PopTableRightTD">
                        <asp:TextBox ID="txbSiteUrl" runat="server" Columns="50" MaxLength="255" meta:resourcekey="txbSiteUrlResource1"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ControlToValidate="txbSiteUrl"
                            Display="Dynamic" ErrorMessage="請輸入網址" SetFocusOnError="True" meta:resourcekey="RequiredFieldValidator8Resource1"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator6" runat="server" ControlToValidate="txbSiteUrl"
                            Display="Dynamic" ErrorMessage="網址格式不正確請重新輸入" SetFocusOnError="True" ValidationExpression="^((((H|h)(T|t)|(F|f))(T|t)(P|p)((S|s)?))\://)?[a-zA-Z0-9\-\.]+(\:[0-9]{1,5})*(/($|[a-zA-Z0-9\.\,\;\?\'\\\+&amp;%\$#\=~_\-]+))*$"
                            meta:resourcekey="RegularExpressionValidator6Resource1"></asp:RegularExpressionValidator>
                        <br />
                        <asp:Label ID="Label15" runat="server" Text="請輸入UOF所在的網址&lt;BR&gt;範例:http://www.MyCompany.com/uof"
                            CssClass="SizeMemo" meta:resourcekey="Label15Resource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 13%; word-break: break-all;white-space:nowrap" class="PopTableLeftTD">
                        <asp:Label ID="lblMobileAddress" runat="server" Text="行動裝置站台網址" meta:resourcekey="lblMobileAddressResource1"></asp:Label>
                    </td>
                    <td style="width: 87%; word-break: break-all" class="PopTableRightTD">
                        <asp:TextBox ID="txtMobileUrl" runat="server" Columns="50" MaxLength="255" meta:resourcekey="txtMobileUrlResource1"></asp:TextBox>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" ControlToValidate="txtMobileUrl"
                            Display="Dynamic" ErrorMessage="網址格式不正確請重新輸入" SetFocusOnError="True" ValidationExpression="^((((H|h)(T|t)|(F|f))(T|t)(P|p)((S|s)?))\://)?[a-zA-Z0-9\-\.]+(\:[0-9]{1,5})*(/($|[a-zA-Z0-9\.\,\;\?\'\\\+&amp;%\$#\=~_\-]+))*$" meta:resourcekey="RegularExpressionValidator3Resource1"></asp:RegularExpressionValidator>
                        <br />
                        <asp:Label ID="Label134" runat="server" Text="範例:http://www.MyCompany.com/m" CssClass="SizeMemo" meta:resourcekey="Label134Resource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="Label62" runat="server" Text="UOF內部網址" meta:resourcekey="Label62Resource2"></asp:Label>
                    </td>
                    <td style="width:87%">
                        <asp:TextBox ID="txtSiteUrlInternal" runat="server" Columns="50" MaxLength="255" meta:resourcekey="txtSiteUrlInternalResource1"></asp:TextBox>
                        <br />
                        <asp:Label ID="lblSiteUrlCheckOutMsg1" runat="server" CssClass="SizeMemo" 
                            meta:resourcekey="lblSiteUrlCheckOutMsg1Resource1" Text="當文件轉檔服務安裝於另一台機器且無法經由站台網址連結UOF時需要設定"></asp:Label>
                        <br />
                        <asp:Label ID="Label97" runat="server" CssClass="SizeMemo"
                            meta:resourcekey="lblSiteUrlCheckOutMsg3Resource1" Text="範例:http://192.168.0.1/uof"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 13%; word-break: break-all; white-space:nowrap" class="PopTableLeftTD">
                        <asp:Label ID="lbSiteUrl0" runat="server" Text="郵件連結使用期限(天)" meta:resourcekey="lbSiteUrl0Resource1"></asp:Label>
                    </td>
                    <td style="width: 87%; word-break: break-all" class="PopTableRightTD">
                        <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                            <ContentTemplate>
                                <asp:CheckBox ID="cbLinkExpire" runat="server" Text="啟用" AutoPostBack="True" OnCheckedChanged="cbLinkExpire_CheckedChanged"
                                    meta:resourcekey="cbLinkExpireResource1" />
                                <br />
                                <asp:TextBox ID="tbLinkExpire" runat="server" Columns="3" MaxLength="3" meta:resourcekey="tbLinkExpireResource1"></asp:TextBox><asp:Label
                                    ID="Label18" runat="server" Text="天之後連結失效" meta:resourcekey="Label18Resource1"></asp:Label>
                                <br />
                                <asp:Label ID="Label19" runat="server" Text="不啟用表示郵件連結不會過期永遠有效" CssClass="SizeMemo"
                                    meta:resourcekey="Label19Resource1"></asp:Label>
                                <br />
                                <asp:RequiredFieldValidator ID="rfLinkExpire" runat="server" ControlToValidate="tbLinkExpire"
                                    Display="Dynamic" Enabled="False" ErrorMessage="請輸入天數" SetFocusOnError="True"
                                    meta:resourcekey="rfLinkExpireResource1"></asp:RequiredFieldValidator>
                                <asp:RangeValidator ID="rvLinkExpire" runat="server" ControlToValidate="tbLinkExpire"
                                    Display="Dynamic" Enabled="False" ErrorMessage="請輸入天數(1-999)" MaximumValue="999"
                                    MinimumValue="1" SetFocusOnError="True" Type="Integer" meta:resourcekey="rvLinkExpireResource1"></asp:RangeValidator>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
                <tr>
                    <td colspan="4" class="PopTableHeader" style="text-align:left">
                        <asp:Label ID="lbLeftMsgQueue" runat="server" Text="訊息佇列" meta:resourcekey="lbLeftMsgQueueResource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 13%; word-break: break-all; white-space:nowrap" class="PopTableLeftTD">
                        <asp:Label ID="Label20" runat="server" Text="*" ForeColor="Red" meta:resourcekey="Label20Resource1"></asp:Label><asp:Label
                            ID="lbLeftErrorCount" runat="server" Text="錯誤重試次數" meta:resourcekey="lbLeftErrorCountResource1"></asp:Label>
                    </td>
                    <td style="width: 87%; word-break: break-all" class="PopTableRightTD">
                        <asp:TextBox ID="txbCount" runat="server" MaxLength="2" meta:resourcekey="txbCountResource1"></asp:TextBox><asp:Label
                            ID="Label28" runat="server" Text="次" meta:resourcekey="Label28Resource1"></asp:Label>
                        <asp:CompareValidator ID="CompareValidator2" runat="server" ControlToValidate="txbCount"
                            Display="Dynamic" ErrorMessage="請輸入數字" Operator="DataTypeCheck" Type="Integer"
                            meta:resourcekey="CompareValidator2Resource1"></asp:CompareValidator>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txbCount"
                            Display="Dynamic" ErrorMessage="不允許空白" meta:resourcekey="RequiredFieldValidator1Resource1"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td style="width: 13%; word-break: break-all;white-space:nowrap" class="PopTableLeftTD">
                        <asp:Label ID="Label23" runat="server" Text="*" ForeColor="Red" meta:resourcekey="Label23Resource1"></asp:Label><asp:Label
                            ID="lbLeftInterval" runat="server" Text="重試間隔(分)" meta:resourcekey="lbLeftIntervalResource1"></asp:Label>
                    </td>
                    <td style="width: 87%; word-break: break-all" class="PopTableRightTD">
                        <asp:TextBox ID="txbInterval" runat="server" MaxLength="2" Columns="2" meta:resourcekey="txbIntervalResource1"></asp:TextBox>
                        <asp:Label ID="Label30" runat="server" Text="分" meta:resourcekey="Label30Resource1"></asp:Label>
                        <asp:CompareValidator ID="CompareValidator3" runat="server" ControlToValidate="txbInterval"
                            Display="Dynamic" ErrorMessage="請輸入數字" Operator="DataTypeCheck" Type="Integer"
                            meta:resourcekey="CompareValidator3Resource1"></asp:CompareValidator>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txbInterval"
                            Display="Dynamic" ErrorMessage="不允許空白" meta:resourcekey="RequiredFieldValidator2Resource1"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td colspan="4" class="PopTableHeader" style="text-align:left">
                        <asp:Label ID="lbLeftSystem" runat="server" Text="系統介面" meta:resourcekey="lbLeftSystemResource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 13%; word-break: break-all; white-space:nowrap" class="PopTableLeftTD">
                        <asp:Label ID="lbLeftDefaultMaster" runat="server" Text="預設主題" meta:resourcekey="lbLeftDefaultMasterResource1"></asp:Label>
                    </td>
                    <td style="width: 87%; word-break: break-all" class="PopTableRightTD">
                        <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <table>
                                    <tr>
                                        <td>
                                            <asp:DropDownList ID="ddlTheme" runat="server" meta:resourcekey="ddlThemeResource1"
                                                AutoPostBack="True" OnSelectedIndexChanged="ddlTheme_SelectedIndexChanged">
                                            </asp:DropDownList>
                                        </td>
                                        <td style="width: 99px">
                                            <asp:Image ID="imgThumbnails" runat="server" ImageUrl="~/App_Themes/DefaultTheme/images/thumbnails.gif"
                                                meta:resourcekey="imgThumbnailsResource1" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblResetIISMsg1" runat="server" Text="需重新啟動IIS方始生效" meta:resourcekey="lblResetIISMsgResource2" CssClass="SizeMemo"></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
                <tr>
                    <td style="width: 13%; word-break: break-all;white-space:nowrap" class="PopTableLeftTD">
                        <asp:Label ID="lbLeftLan" runat="server" Text="預設語系" meta:resourcekey="lbLeftLanResource1"></asp:Label>
                    </td>
                    <td style="width: 87%; word-break: break-all" class="PopTableRightTD">
                        <asp:DropDownList ID="ddlLang" runat="server" meta:resourcekey="ddlLangResource1">
                        </asp:DropDownList>
                    </td>
                    </tr>
                    <tr>
                        <td style="width: 13%; white-space:nowrap" class="PopTableLeftTD">
                            <asp:Label ID="Label27" runat="server" Text="*" ForeColor="Red" meta:resourcekey="Label27Resource1"></asp:Label><asp:Label
                                ID="lbLeftTimeOut" runat="server" Text="使用者登入過期時間(分)" meta:resourcekey="lbLeftTimeOutResource1"></asp:Label>
                        </td>
                        <td style="width: 87%; word-break: break-all" class="PopTableRightTD">
                            <asp:TextBox ID="txbTimeOut" runat="server" MaxLength="4" Width="50px" Columns="4"
                                meta:resourcekey="txbTimeOutResource1"></asp:TextBox>
                            <asp:Label ID="Label31" runat="server" Text="分" meta:resourcekey="Label31Resource1"></asp:Label>
                            <br />
                            <asp:Label ID="Label29" runat="server" Text="如果使用者於多少分鐘內未使用系統時，會強迫將使用者登出" CssClass="SizeMemo"
                                meta:resourcekey="Label29Resource1"></asp:Label>
                            <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToValidate="txbTimeOut"
                                Display="Dynamic" ErrorMessage="請輸入數字" Operator="DataTypeCheck" Type="Integer"
                                meta:resourcekey="CompareValidator1Resource1"></asp:CompareValidator>
                            <asp:CompareValidator ID="cvTimeOut" runat="server" ControlToValidate="txbTimeOut"
                                Display="Dynamic" ErrorMessage="時間需大於3分鐘" meta:resourcekey="cvTimeOutResource1"
                                Operator="GreaterThanEqual" Type="Integer" ValueToCompare="3"></asp:CompareValidator>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txbTimeOut"
                                Display="Dynamic" ErrorMessage="不允許空白" meta:resourcekey="RequiredFieldValidator3Resource1"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                <tr>
                    <td style="width: 13%; word-break: break-all; white-space:nowrap" class="PopTableLeftTD">
                        <asp:Label ID="lblLogoIconPath" runat="server" Text="LOGO圖示" meta:resourcekey="lblLogoIconPathResource1"></asp:Label>
                    </td>
                    <td style="width: 90%; word-break: break-all" class="PopTableRightTD" colspan="3">       
                        <asp:UpdatePanel ID="UpdatePanel14" runat="server"  UpdateMode="Conditional">
                            <ContentTemplate>                 
                                <asp:Image ID="imgLogo" runat="server" Height="47px" Width="145px" meta:resourcekey="imgLogoResource1" />
                                <br />
                                <telerik:RadButton ID="btnEdit" runat="server" Text="編輯" OnClientClicking="OnClientClicking" CausesValidation="False" meta:resourcekey="btnEditResource1"  ></telerik:RadButton>
                                <telerik:RadButton ID="btnDelete" runat="server" Text="刪除" OnClientClicking="bigPictureDelete" CausesValidation="False" OnClick="btnDelete_Click" meta:resourcekey="btnDeleteResource1"></telerik:RadButton>
                                <asp:HiddenField ID="hideFileGroupID" runat="server" />
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="btnEdit"
                                    EventName="Click" />
                            </Triggers>
                        </asp:UpdatePanel>
                    </td>
                </tr>
                <tr>
                    <td style="width: 13%; word-break: break-all; white-space:nowrap" class="PopTableLeftTD">
                        <asp:Label ID="lblCustomizeLoginTitle" runat="server" Text="自訂登入頁面" meta:resourcekey="lblCustomizeLoginTitleResource1"></asp:Label>
                    </td>
                    <td style="width: 90%; word-break: break-all" class="PopTableRightTD" colspan="3">
                        <table style="width: 100%; " >
                            <tr >
                                <td colspan="2" style="padding: 2px 5px 2px 2px">
                                    <asp:CheckBox ID="ckCusLoginEnable" runat="server" Text="啟用" meta:resourcekey="ckCusLoginEnableResource1" />
                                </td>
                            </tr>
                            <tr >
                                <td style="padding: 5px 5px 2px 2px">
                                    <asp:Label runat="server" ID="lblloginBgFile" Text="背景圖" meta:resourcekey="lblloginBgFileResource1"></asp:Label>
                                </td>

                            </tr>
                            <tr >
                                <td style="padding: 0px 5px 2px 2px">
                                    <uc2:UC_FileCenter runat="server" ID="UC_loginBgFile" ModuleName="EIP"  AllowedFileType="Image" ProxyEnabled="false"  AllowedMultipleFileSelection="false"/>                                  
                                </td>                                
                            </tr>
                            <tr>
                                <td style="padding: 0px 5px 2px 2px">
                                    <asp:Label runat="server" ID="lblloginBGdesc" Text="最適圖片大小：" CssClass="SizeMemo" meta:resourcekey="lblloginBGdescResource1"></asp:Label>
                                    <asp:Label runat="server" ID="lblloginBGSize" Text="1920(w)*1536(h)" CssClass="SizeMemo" meta:resourcekey="lblloginBGSizeResource2" ></asp:Label>

                                </td>
                            </tr>
                        <tr >
                                <td style="padding: 5px 5px 2px 2px">
                                    <asp:Label runat="server" ID="lblloginColorStyle" Text="登入區色系" meta:resourcekey="lblloginColorStyleResource1"></asp:Label></td>
                            </tr>
                            <tr>
                                <td style="padding: 0px 5px 2px 2px">
                                            <telerik:RadColorPicker ID="ColorPickerLoginClass" runat="server"   Columns="13"  
                                            Preset="None"  PreviewColor="False" ShowEmptyColor="False"  ShowIcon="true"
                                             Width="500px" >
                                           <telerik:ColorPickerItem Title="Red" Value="#DB2828" />
                                           <telerik:ColorPickerItem Title="Orange" Value="#F2711C" />
                                           <telerik:ColorPickerItem Title="Yellow" Value="#FBBD08" />
                                           <telerik:ColorPickerItem Title="Olive" Value="#B5CC18" />
                                           <telerik:ColorPickerItem Title="Green" Value="#21BA45" />
                                           <telerik:ColorPickerItem Title="Teal " Value="#00B5AD" />
                                           <telerik:ColorPickerItem Title="Blue" Value="#2185D0" />
                                           <telerik:ColorPickerItem Title="Violet" Value="#6435C9" />
                                           <telerik:ColorPickerItem Title="Purple" Value="#9627BA" />
                                           <telerik:ColorPickerItem Title="Pink" Value="#E03997" />
                                           <telerik:ColorPickerItem Title="Brown" Value="#A5673F" />
                                           <telerik:ColorPickerItem Title="Grey" Value="#767676" />
                                           <telerik:ColorPickerItem Title="Black" Value="#1B1C1D" />
                                        </telerik:RadColorPicker>                                   
                                </td>
                            </tr>
                        </table>
                        
                    </td>
                </tr>
                <tr>
                    <td colspan="4" class="PopTableHeader" style="text-align: left">
                        <asp:Label ID="lblMemberTitle" runat="server" Text="外部會員" meta:resourcekey="lblMemberTitleResource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 13%; word-break: break-all; white-space:nowrap" class="PopTableLeftTD">
                        <asp:Label ID="lblSelectMemberGroupTitle" runat="server" Text="群組選取權限" meta:resourcekey="lblSelectMemberGroupTitleResource1"></asp:Label>
                    </td>
                    <td style="width: 90%; word-break: break-all" class="PopTableRightTD" colspan="3">
                        <asp:CheckBox ID="cbEnableMembGroupAuth" runat="server" Text="啟用" meta:resourcekey="cbEnableMembGroupAuthResource1"/>
                    </td>
                </tr>
                <tr>
                    <td colspan="4" class="PopTableHeader" style="text-align:left">
                        <asp:Label ID="lblTimeZoneHead" runat="server" Text="多時區設定" meta:resourcekey="lblTimeZoneHeadResource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 13%; word-break: break-all; white-space:nowrap" class="PopTableLeftTD">
                        <asp:Label ID="lblTimeZoneTitle" runat="server" Text="多時區" meta:resourcekey="lblTimeZoneTitleResource1"></asp:Label>
                    </td>
                    <td style="width: 90%; word-break: break-all" class="PopTableRightTD" colspan="3">
                        <table style="width: 100%" border="0">
                            <tr>
                                <td style="text-align: left; white-space:nowrap;" colspan="2">
                                    <asp:CheckBox ID="cbEnableTimeZone" runat="server" Text="啟用" meta:resourcekey="cbEnableTimeZoneResource1" />
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 13px; white-space: nowrap;">
                                </td>
                                <td style="text-align: left">
                                    <asp:Label ID="lblTitleTimeZoneMsg" runat="server" meta:resourcekey="lblTitleTimeZoneMsgResource1" Text="當時區不同時，是否顯示資料來源時區"></asp:Label>
                                    <asp:RadioButtonList ID="rdbtnTimeZoneTextDisplayControl" runat="server" meta:resourcekey="rdbtnTimeZoneTextDisplayControlResource1">
                                        <asp:ListItem meta:resourcekey="DISPLAYListItemResource1" Selected="True" Text="顯示 ex:2015/08/31 20:00 (08:00 +8)" Value="DISPLAY"></asp:ListItem>
                                        <asp:ListItem meta:resourcekey="NON_DISPLAYListItemResource1" Text="隱藏 ex:2015/08/31 20:00" Value="NON_DISPLAY"></asp:ListItem>
                                    </asp:RadioButtonList>
                                    <asp:HiddenField ID="hfTimeZoneTextDisplayControl" runat="server" />
                                </td>
                            </tr>                                                                                    
                        </table>
                    </td>
                </tr>
                <tr>
                    <td style="white-space: nowrap;">
                        <asp:Label ID="lblSysTimeZone" runat="server" Text="系統時區" meta:resourcekey="lblSysTimeZoneResource1"></asp:Label>
                    </td>
                    <td>
                        <asp:UpdatePanel ID="UpdatePanelSysTimeZone" runat="server">
                            <ContentTemplate>
                                <table>
                                    <tr>
                                        <td>                                            
                                            <asp:DropDownList ID="ddlSysTimeZone" runat="server" meta:resourcekey="ddlSysTimeZoneResource1"></asp:DropDownList>
                                        </td>                                        
                                    </tr>
                                    <tr>
                                        <td style="padding-left: 5px; display:none;">
                                            <asp:Label ID="lblSysTime" runat="server" Text="自訂系統時間:" CssClass="SizeMemo" meta:resourcekey="lblSysTimeResource1"></asp:Label>
                                            <asp:Label ID="lblCurrentSysTime" runat="server" CssClass="SizeMemo" meta:resourcekey="lblCurrentSysTimeResource1"></asp:Label><br />
                                            <asp:Label ID="lblOriSysTime" runat="server" Text="原始系統時間:" CssClass="SizeMemo" meta:resourcekey="lblOriSysTimeResource1"></asp:Label>
                                            <asp:Label ID="lblOriCurrentSysTime" runat="server" CssClass="SizeMemo" meta:resourcekey="lblOriCurrentSysTimeResource1"></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
                <tr>
                    <td colspan="4" class="PopTableLeftTD" style="text-align:center">
                        <table style="width:100%" border="0">
                            <tr>
                                <td style="width: 45%; text-align:right"></td>
                                <td style="width: 13%; text-align:center">
                                    <telerik:RadButton ID="rbtnSave1" runat="server" Text="儲存"
                                        OnClientClicked="btnSave_Click" OnClick="rbtnSave1_Click"
                                        meta:resourcekey="rbtnSave1Resource1">
                                    </telerik:RadButton>
                                </td>
                                <td style="width: 45%"></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </telerik:RadPageView>
        <telerik:RadPageView ID="loginSet" runat="server" meta:resourcekey="loginSetResource1">
           
            <table border="0" style="width:100%" class="PopTable">
                <tr>
                    <td colspan="2" class="PopTableHeader" style="text-align:left">
                        <asp:Label ID="Label41" runat="server" Text="U-Office Force帳號安全性" meta:resourcekey="Label41Resource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 13%; word-break: break-all; white-space:nowrap" class="PopTableLeftTD">
                        <asp:Label ID="Label43" runat="server" Text="密碼有效期限" meta:resourcekey="Label43Resource1"></asp:Label>
                    </td>
                    <td style="width: 87%; word-break: break-all" class="PopTableRightTD">
                        <asp:UpdatePanel ID="UpdatePanel15" runat="server">
                            <ContentTemplate>
                                <asp:CheckBox ID="cbPWChangeEnable" runat="server" Text="啟用" AutoPostBack="True"
                                    OnCheckedChanged="cbPWChangeEnable_CheckedChanged" meta:resourcekey="cbPWChangeEnableResource2" />
                                <asp:TextBox ID="tbMaxPWAge" runat="server" Columns="5" MaxLength="3" meta:resourcekey="tbMaxPWAgeResource1"></asp:TextBox>
                                <asp:Label ID="Label44" runat="server" Text="天" meta:resourcekey="Label44Resource1"></asp:Label>
                                <asp:CompareValidator ID="cvMaxPWAge" runat="server" ControlToValidate="tbMaxPWAge"
                                    Display="Dynamic" ErrorMessage="請輸入大於1之正整數" meta:resourcekey="cvMaxPWAgeResource1"
                                    Operator="GreaterThan" Type="Integer" ValueToCompare="1"></asp:CompareValidator>
                                <asp:RequiredFieldValidator ID="rfvMaxPWAge" runat="server" ControlToValidate="tbMaxPWAge"
                                    meta:resourcekey="rfvPWResource1" Display="Dynamic" ErrorMessage="已啟用密碼強迫變更，不允許空白"></asp:RequiredFieldValidator>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
                <tr>
                    <td style="width: 13%; word-break: break-all; white-space:nowrap" class="PopTableLeftTD" rowspan="2">
                        <asp:Label ID="Label99" runat="server" Text="內部員工個人資料更新" meta:resourcekey="Label99Resource1"></asp:Label>
                    </td>
                    <td style="width: 87%; word-break: break-all" class="PopTableRightTD">
                        <asp:UpdatePanel ID="UpdatePanel16" runat="server">
                            <ContentTemplate>
                                <asp:CheckBox ID="cbPersonalInfoEnable" runat="server" Text="啟用，週期:" OnCheckedChanged="cbPersonalInfoEnable_CheckedChanged" AutoPostBack="True" meta:resourcekey="cbPersonalInfoEnableResource1" />
                                <asp:TextBox ID="txtMaxPersonalInfo" runat="server" Columns="5" MaxLength="3" meta:resourcekey="txtMaxPersonalInfoResource5"></asp:TextBox>
                                <asp:Label ID="lblPersonalInfoDay" runat="server" Text="天" meta:resourcekey="lblPersonalInfoDayResource1"></asp:Label>
                                <asp:CompareValidator ID="cvMapPersonalInfo" runat="server" ControlToValidate="txtMaxPersonalInfo"
                                    Display="Dynamic" ErrorMessage="請輸入大於0之正整數" meta:resourcekey="cvMapPersonalInfoResource1"
                                    Operator="GreaterThan" Type="Integer" ValueToCompare="0"></asp:CompareValidator>
                                <asp:RequiredFieldValidator ID="rfPersonalInfo" runat="server" ControlToValidate="txtMaxPersonalInfo"
                                    Display="Dynamic" ErrorMessage="已啟用個人資料更新，不允許空白" meta:resourcekey="rfPersonalInfoResource1"></asp:RequiredFieldValidator>
                                
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
                <tr>
                    <td style="width: 87%; word-break: break-all; text-align:left;" class="PopTableRightTD">
                        <asp:Label ID="lblPersonalInfoRemark" runat="server" Text="如果需要使用者下一次登入時更新個人資料，請按此:" meta:resourcekey="lblPersonalInfoRemarkResource1"></asp:Label>
                        <telerik:RadButton ID="rdBtnUpdatePersonalInfo" runat="server" Text="啟用" OnClientClicking="ConfirmUpdate"
                            CausesValidation="False" OnClick="rdBtnUpdatePersonalInfo_Click"
                            meta:resourcekey="rdBtnUpdatePersonalInfoResource1">
                        </telerik:RadButton>
                        <br/>
                        <asp:Label ID="lblPersonalInfoMsg1" runat="server" Text="請輸入提示訊息:" meta:resourcekey="lblPersonalInfoMsg1Resource1"></asp:Label>
                        <asp:TextBox ID="txtPersonalInfoMsg" runat="server" Width="500px" meta:resourcekey="txtPersonalInfoMsgResource2"></asp:TextBox>
                        <br />
                        <asp:Label ID="lblPersonalInfoMsg2" runat="server" Text="若未輸入則會顯示系統預設訊息「系統已啟用個人資料更新功能，請您立即進行個人資料更新，謝謝!」" ForeColor="Blue"  meta:resourcekey="lblPersonalInfoMsg2Resource1"></asp:Label>
                        <asp:Label ID="lblUpdatePISuccess" runat="server" Text="執行成功" Visible="False" ForeColor="Red" meta:resourcekey="lblUpdatePISuccessResource1"></asp:Label>
                        <asp:Label ID="lblUpdatePIFail" runat="server" Text="執行失敗(錯誤原因請至檢視事件查看)" Visible="False" ForeColor="Red" meta:resourcekey="lblUpdatePIFailResource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 13%; word-break: break-all; white-space:nowrap" class="PopTableLeftTD" rowspan="2">
                        <asp:Label ID="lblPersonalUpdate" runat="server" Text="外部會員個人資料更新" meta:resourcekey="lblPersonalUpdateResource1"></asp:Label>
                    </td>
                    <td style="width: 87%; word-break: break-all" class="PopTableRightTD">
                        <asp:UpdatePanel ID="UpdatePanel17" runat="server">
                            <ContentTemplate>
                                <asp:CheckBox ID="cbPersonalInfoEnableMember" runat="server" Text="啟用，週期:" OnCheckedChanged="cbPersonalInfoEnableMember_CheckedChanged" AutoPostBack="True" meta:resourcekey="cbPersonalInfoEnableMemberResource1" />
                                <asp:TextBox ID="txtMaxPersonalInfoMember" runat="server" Columns="5" MaxLength="3" meta:resourcekey="txtMaxPersonalInfoMemberResource2"></asp:TextBox>
                                <asp:Label ID="lblPersonalInfoDayMember" runat="server" Text="天" meta:resourcekey="lblPersonalInfoDayMemberResource1"></asp:Label>
                                <asp:CompareValidator ID="cvMapPersonalInfoMember" runat="server" ControlToValidate="txtMaxPersonalInfoMember"
                                    Display="Dynamic" ErrorMessage="請輸入大於0之正整數" meta:resourcekey="cvMapPersonalInfoMemberResource1"
                                    Operator="GreaterThan" Type="Integer" ValueToCompare="0"></asp:CompareValidator>
                                <asp:RequiredFieldValidator ID="rfPersonalInfoMember" runat="server" ControlToValidate="txtMaxPersonalInfoMember"
                                    Display="Dynamic" ErrorMessage="已啟用個人資料更新，不允許空白" meta:resourcekey="rfPersonalInfoMemberResource1"></asp:RequiredFieldValidator>
                                
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
                <tr>
                    <td style="width: 87%; word-break: break-all; text-align:left;" class="PopTableRightTD">
                        <asp:Label ID="lblPersonalInfoRemarkMember" runat="server" Text="如果需要使用者下一次登入時更新個人資料，請按此:" meta:resourcekey="lblPersonalInfoRemarkMemberResource1"></asp:Label>
                        <telerik:RadButton ID="rdBtnUpdatePersonalInfoMember" runat="server" Text="啟用" OnClientClicking="ConfirmUpdate"
                            CausesValidation="False" OnClick="rdBtnUpdatePersonalInfoMember_Click"
                            meta:resourcekey="rdBtnUpdateMemberInfoResource1">
                        </telerik:RadButton>
                        <br/>
                        <asp:Label ID="lblPersonalInfoMsgMember1" runat="server" Text="請輸入提示訊息:" meta:resourcekey="lblPersonalInfoMsgMember1Resource1"></asp:Label>
                        <asp:TextBox ID="txtPersonalInfoMsgMember" runat="server" Width="500px" meta:resourcekey="txtPersonalInfoMsgMemberResource2"></asp:TextBox>
                        <br />
                        <asp:Label ID="lblPersonalInfoMsgMember2" runat="server" Text="若未輸入則會顯示系統預設訊息「系統已啟用個人資料更新功能，請您立即進行個人資料更新，謝謝!」" ForeColor="Blue"  meta:resourcekey="lblPersonalInfoMsgMember2Resource1"></asp:Label>
                        <asp:Label ID="lblUpdateMISuccess" runat="server" Text="執行成功" Visible="False" ForeColor="Red" meta:resourcekey="lblUpdateMISuccessResource1"></asp:Label>
                        <asp:Label ID="lblUpdateMIFail" runat="server" Text="執行失敗(錯誤原因請至檢視事件查看)" Visible="False" ForeColor="Red" meta:resourcekey="lblUpdateMIFailResource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 13%; word-break: break-all; white-space:nowrap" class="PopTableLeftTD">
                        <asp:Label ID="Label48" runat="server" Text="帳號自動鎖定" meta:resourcekey="Label48Resource1"></asp:Label>
                    </td>
                    <td style="width: 87%; word-break: break-all" class="PopTableRightTD">
                        <asp:TextBox ID="tbMaxUserPWInvalidAttempts" runat="server" Columns="5" MaxLength="3"
                            meta:resourcekey="tbMaxUserPWInvalidAttemptsResource1"></asp:TextBox><asp:Label ID="Label51"
                                runat="server" Text="次登入失敗後鎖定" meta:resourcekey="Label51Resource1"></asp:Label>
                        <br />
                        <asp:Label ID="Label26" runat="server" Text="輸入 0 代表不限制" CssClass="SizeMemo" meta:resourcekey="Label26Resource1"></asp:Label>
                        <asp:CompareValidator ID="cvMaxUserPWInvalidAttempts" runat="server" ControlToValidate="tbMaxUserPWInvalidAttempts"
                            Display="Dynamic" ErrorMessage="請輸入正整數" meta:resourcekey="cvGreaterThanResource1"
                            Operator="GreaterThanEqual" Type="Integer" ValueToCompare="0"></asp:CompareValidator><asp:RequiredFieldValidator
                                ID="rfvMaxUserPWInvalidAttempts" runat="server" ControlToValidate="tbMaxUserPWInvalidAttempts"
                                meta:resourcekey="rfvPWResource1" Display="Dynamic" ErrorMessage="不允許空白"></asp:RequiredFieldValidator>
                        <br />
                        <asp:CheckBox ID="cbEnableAutoStartUser" runat="server" Text="被鎖定的帳號自動解除鎖定" onclick="DisplayEnableAutoStartUser()"
                            meta:resourcekey="cbEnableAutoStartUserResource1" />
                        <asp:Label ID="lblResetIISMsg" runat="server" Text="需重新啟動IIS方始生效" meta:resourcekey="lblResetIISMsgResource1" CssClass="SizeMemo"></asp:Label>
                        <br />
                        <asp:Panel ID="panDisableAutoStartUser" runat="server" meta:resourcekey="panDisableAutoStartUserResource1">
                            <asp:Label ID="Label3" runat="server" Text="請至人員維護介面，手動解除被鎖定的帳號" CssClass="SizeMemo"
                                meta:resourcekey="Label3Resource1"></asp:Label>
                        </asp:Panel>
                        <asp:Panel ID="panEnableAutoStartUser" runat="server" meta:resourcekey="panEnableAutoStartUserResource1">
                            <asp:DropDownList ID="ddlStartUserMins" runat="server" meta:resourcekey="ddlStartUserMinsResource1">
                                <asp:ListItem meta:resourcekey="ListItemResource1" Text="5"></asp:ListItem>
                                <asp:ListItem meta:resourcekey="ListItemResource2" Text="10"></asp:ListItem>
                                <asp:ListItem meta:resourcekey="ListItemResource3" Text="15"></asp:ListItem>
                                <asp:ListItem meta:resourcekey="ListItemResource4" Text="30"></asp:ListItem>
                                <asp:ListItem meta:resourcekey="ListItemResource5" Text="60"></asp:ListItem>
                            </asp:DropDownList>
                            <asp:Label ID="Label4" runat="server" Text="分鐘後，帳號自動解除鎖定" meta:resourcekey="Label4Resource1"></asp:Label>
                        </asp:Panel>
                    </td>
                </tr>
                <tr>
                    <td style="width: 13%; word-break: break-all; white-space:nowrap" class="PopTableLeftTD">
                        <asp:Label ID="Label54" runat="server" Text="密碼原則" meta:resourcekey="Label54Resource1"></asp:Label>
                    </td>                    
                    <td style="width: 87%; word-break: break-all;" class="PopTableRightTD">
                        <asp:Panel ID="panDisableStrongPW" runat="server" meta:resourcekey="panDisableStrongPWResource1">
                            <table style="width:100%" >
                                <tr style="height:20px">
                                    <td >
                                        <asp:Label ID="Label6" runat="server" Text="內部員工新建帳號預設密碼" meta:resourcekey="Label6Resource1"></asp:Label></td>
                                </tr>
                                <tr style="height:20px">
                                    <td>
                                        <asp:RadioButton ID="rbtPWEmpty" runat="server" Text="空白" GroupName="rbtPWDefault" meta:resourcekey="rbtPWEmptyResource1"/>
                                        <asp:RadioButton ID="rbtPWBirthday" runat="server" Text="生日" GroupName="rbtPWDefault" meta:resourcekey="rbtPWBirthdayResource1"/>
                                        <asp:RadioButton ID="rbtPWMobile" runat="server" Text="行動電話" GroupName="rbtPWDefault" meta:resourcekey="rbtPWMobileResource1"/>
                                        <asp:RadioButton ID="rbtPWSID" runat="server" Text="身分證字號" GroupName="rbtPWDefault" meta:resourcekey="rbtPWSIDResource1"/></td>
                                </tr>
                                <tr style="height:8px"><td></td></tr>
                                <tr style="height:20px">
                                    <td >
                                        <asp:Label ID="lblMemberDefaultPW" runat="server" Text="外部會員新建帳號預設密碼" meta:resourcekey="lblMemberDefaultPWResource1"></asp:Label></td>
                                </tr>
                                <tr style="height:20px">
                                    <td>
                                        <asp:RadioButton ID="rbtMemberPWEmpty" runat="server" Text="空白" GroupName="rbtMemberPWDefault" meta:resourcekey="rbtMemberPWEmptyResource1"/>
                                        <asp:RadioButton ID="rbtMemberPWBirthday" runat="server" Text="生日" GroupName="rbtMemberPWDefault" meta:resourcekey="rbtMemberPWBirthdayResource1"/>
                                        <asp:RadioButton ID="rbtMemberPWMobile" runat="server" Text="行動電話" GroupName="rbtMemberPWDefault" meta:resourcekey="rbtMemberPWMobileResource1"/>
                                        </td>
                                </tr>
                                <tr style="height:8px"><td></td></tr>
                                <tr style="height:20px">
                                    <td >
                                        <ol style="color: Blue; margin-left: 20px">
                                            <li>
                                                <asp:Label ID="lblBirthdayDesc" runat="server" Text="生日為八碼數字如19790105" CssClass="SizeMemo" meta:resourcekey="lblBirthdayDescResource1"></asp:Label>
                                            </li>
                                            <li>
                                                <asp:Label ID="lblNullDesc" runat="server" Text="如果選擇項目欄位未輸入資料亦會造成預設密碼為空白" CssClass="SizeMemo" meta:resourcekey="lblNullDescResource1"></asp:Label>
                                            </li>
                                            <li>
                                                <asp:Label ID="Label16" runat="server" Text="自訂密碼最少為六個字以上" CssClass="SizeMemo" meta:resourcekey="Label16Resource1"></asp:Label>
                                            </li>
                                        </ol>
                                    </td>
                                </tr>
                            </table>
                            <br />
                        </asp:Panel>
                        
                        <asp:CheckBox ID="cbStrongPW" runat="server" Text="啟用增強型密碼" onclick="StrongPWDisplayDescription()"
                            meta:resourcekey="cbStrongPWResource2" />
                        <asp:Panel ID="panEnableStrongPW" runat="server" meta:resourcekey="panEnableStrongPWResource1">
                            <li style="color: Blue; margin-left: 20px">
                                <asp:Label ID="Label22" runat="server" Text="預設密碼由系統自動產生" CssClass="SizeMemo" meta:resourcekey="Label22Resource1"></asp:Label></li>

                            <table>
                                <tr>
                                    <td>
                                        <span style="color: #ff0000">*</span><asp:Label ID="Label7" runat="server" Text="密碼最小長度"
                                            meta:resourceKey="Label7Resource1"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtPwdLessLength" runat="server" Columns="2" MaxLength="2" Text="8"
                                            meta:resourcekey="txtPwdLessLengthResource1"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" ControlToValidate="txtPwdLessLength"
                                            Display="Dynamic" ErrorMessage="密碼最小長度不允許空白" SetFocusOnError="True" meta:resourceKey="RequiredFieldValidator9Resource1"></asp:RequiredFieldValidator>
                                        <asp:RangeValidator ID="RangeValidator2" runat="server" ControlToValidate="txtPwdLessLength"
                                            Display="Dynamic" ErrorMessage="請輸入6-20之內的數字" MaximumValue="20" MinimumValue="6"
                                            SetFocusOnError="True" Type="Integer" meta:resourceKey="RangeValidator2Resource1"></asp:RangeValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <span style="color: #ff0000">*</span><asp:Label ID="Label89" runat="server" Text="最少大寫字母個數"
                                            meta:resourceKey="Label89Resource1"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtPwdMinUpperCase" runat="server" Columns="2" MaxLength="2" meta:resourceKey="txtPwdMinUpperCaseResource1"
                                            Text="1"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator10" runat="server" ControlToValidate="txtPwdMinUpperCase"
                                            Display="Dynamic" ErrorMessage="最少大寫字母個數不允許空白" SetFocusOnError="True" meta:resourceKey="RequiredFieldValidator10Resource1"></asp:RequiredFieldValidator>
                                        <asp:RangeValidator ID="RangeValidator3" runat="server" ControlToValidate="txtPwdMinUpperCase"
                                            Display="Dynamic" ErrorMessage="請輸入0-20之內的數字" MaximumValue="20" MinimumValue="0"
                                            SetFocusOnError="True" Type="Integer" meta:resourceKey="RangeValidator3Resource1"></asp:RangeValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <span style="color: #ff0000">*</span><asp:Label ID="Label90" runat="server" Text="最少小寫字母個數"
                                            meta:resourceKey="Label90Resource1"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtPwdMinLowerCase" runat="server" Columns="2" MaxLength="2" meta:resourceKey="txtPwdMinLowerCaseResource1"
                                            Text="1"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator11" runat="server" ControlToValidate="txtPwdMinLowerCase"
                                            Display="Dynamic" ErrorMessage="最少小寫字母個數不允許空白" SetFocusOnError="True" meta:resourceKey="RequiredFieldValidator11Resource1"></asp:RequiredFieldValidator>
                                        <asp:RangeValidator ID="RangeValidator4" runat="server" ControlToValidate="txtPwdMinLowerCase"
                                            Display="Dynamic" ErrorMessage="請輸入0-20之內的數字" MaximumValue="20" MinimumValue="0"
                                            SetFocusOnError="True" Type="Integer" meta:resourceKey="RangeValidator4Resource1"></asp:RangeValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <span style="color: #ff0000">*</span><asp:Label ID="Label14" runat="server" Text="最少數字個數"
                                            meta:resourceKey="Label14Resource1"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtPwdMinNumeric" runat="server" Columns="2" MaxLength="2" meta:resourceKey="txtPwdMinNumericResource1"
                                            Text="1"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator12" runat="server" ControlToValidate="txtPwdMinNumeric"
                                            Display="Dynamic" ErrorMessage="最少數字個數不允許空白" SetFocusOnError="True" meta:resourceKey="RequiredFieldValidator12Resource1"></asp:RequiredFieldValidator>
                                        <asp:RangeValidator ID="RangeValidator5" runat="server" ControlToValidate="txtPwdMinNumeric"
                                            Display="Dynamic" ErrorMessage="請輸入0-20之內的數字" MaximumValue="20" MinimumValue="0"
                                            SetFocusOnError="True" Type="Integer" meta:resourceKey="RangeValidator5Resource1"></asp:RangeValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <span style="color: #ff0000">*</span><asp:Label ID="Label24" runat="server" Text="最少符號個數"
                                            meta:resourceKey="Label24Resource1"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtPwdMinSymbol" runat="server" Columns="2" MaxLength="2" meta:resourceKey="txtPwdMinSymbolResource1"
                                            Text="1"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator13" runat="server" ControlToValidate="txtPwdMinSymbol"
                                            Display="Dynamic" ErrorMessage="最少符號個數不允許空白" SetFocusOnError="True" meta:resourceKey="RequiredFieldValidator13Resource1"></asp:RequiredFieldValidator>
                                        <asp:RangeValidator ID="RangeValidator6" runat="server" ControlToValidate="txtPwdMinSymbol"
                                            Display="Dynamic" ErrorMessage="請輸入0-20之內的數字" MaximumValue="20" MinimumValue="0"
                                            SetFocusOnError="True" Type="Integer" meta:resourceKey="RangeValidator6Resource1"></asp:RangeValidator>
                                    </td>
                                </tr>
                            </table>
                            <asp:Label ID="Label17" runat="server" Text="輸入 0 代表不限制" meta:resourceKey="Label17Resource1"></asp:Label>
                        </asp:Panel>
                    </td>
                </tr>
                <tr>
                    <td style="width: 13%; word-break: break-all; white-space:nowrap" class="PopTableLeftTD">
                        <asp:Label ID="Label67" runat="server" Text="強制密碼歷程記錄" meta:resourcekey="Label67Resource1"></asp:Label>
                    </td>
                    <td style="width: 87%; word-break: break-all" class="PopTableRightTD">
                        <asp:DropDownList ID="ddlEnforcePasswordHistory" runat="server" meta:resourcekey="ddlEnforcePasswordHistoryResource1">
                            <asp:ListItem Value="0" meta:resourcekey="ListItemResource6" Text="停用"></asp:ListItem>
                            <asp:ListItem Value="1" meta:resourcekey="ListItemResource7" Text="1"></asp:ListItem>
                            <asp:ListItem Value="2" meta:resourcekey="ListItemResource8" Text="2"></asp:ListItem>
                            <asp:ListItem Value="3" meta:resourcekey="ListItemResource9" Text="3"></asp:ListItem>
                            <asp:ListItem Value="4" meta:resourcekey="ListItemResource10" Text="4"></asp:ListItem>
                            <asp:ListItem Value="5" meta:resourcekey="ListItemResource11" Text="5"></asp:ListItem>
                            <asp:ListItem Value="6" meta:resourcekey="ListItemResource12" Text="6"></asp:ListItem>
                            <asp:ListItem Value="7" meta:resourcekey="ListItemResource13" Text="7"></asp:ListItem>
                            <asp:ListItem Value="8" meta:resourcekey="ListItemResource14" Text="8"></asp:ListItem>
                            <asp:ListItem Value="9" meta:resourcekey="ListItemResource15" Text="9"></asp:ListItem>
                        </asp:DropDownList>
                        <asp:Label ID="Label53" runat="server" Text="次" meta:resourcekey="Label53Resource1"></asp:Label>
                        <br />
                        <asp:Label ID="Label68" runat="server" CssClass="SizeMemo" Text="設定修改密碼時，不能與前幾次密碼相同"
                            meta:resourcekey="Label68Resource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 13%; word-break: break-all;white-space:nowrap" class="PopTableLeftTD">
                        <asp:Label ID="Label69" runat="server" Text="排除人員" meta:resourcekey="Label69Resource1"></asp:Label>
                    </td>
                    <td style="width: 87%; word-break: break-all" class="PopTableRightTD">
                        <uc2:UC_ChoiceList ID="UC_ChoiceList1" runat="server" ExpandToUser="false" />
                        <br />
                        <asp:Label ID="Label25" runat="server" Text="設定排除的人員不受U-Office Force帳號安全性的條件限制(帳號自動鎖定、增強型密碼、強制密碼歷程紀錄)" meta:resourcekey="Label25Resource1"
                            CssClass="SizeMemo"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" class="PopTableHeader" style="text-align:left">
                        <asp:Label ID="Label32" runat="server" Text="AD驗證管理與單一簽入" meta:resourcekey="Label32Resource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 13%; word-break: break-all; white-space:nowrap" class="PopTableLeftTD">
                        <asp:Label ID="Label33" runat="server" Text="單一簽入" meta:resourcekey="Label33Resource1"></asp:Label>
                    </td>
                    <td style="width: 87%; word-break: break-all; vertical-align: top" class="PopTableRightTD">
                        <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <asp:RadioButtonList ID="rblSSOType" runat="server" AutoPostBack="True"
                                    RepeatColumns="3" OnSelectedIndexChanged="rblSSOType_SelectedIndexChanged"
                                    meta:resourcekey="rblSSOTypeResource1">
                                    <asp:ListItem Value="NO" meta:resourcekey="ListItemResource24" Text="不啟用"></asp:ListItem>
                                    <asp:ListItem Value="AD" meta:resourcekey="ListItemResource25" Text="啟用AD SSO"></asp:ListItem>
                                    <asp:ListItem Value="CA" meta:resourcekey="ListItemResource26"
                                        Text="啟用用戶端憑證SSO"></asp:ListItem>
                                </asp:RadioButtonList>
                                <br />
                                <asp:DataList ID="dalIPRange" runat="server" ShowFooter="False" Enabled="False" meta:resourcekey="dalIPRangeResource1">
                                    <HeaderTemplate>
                                        <asp:Label runat="server" ID="lblIPRange" Text="IP範圍" meta:resourcekey="lblIPRangeResource1"></asp:Label>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <table>
                                            <tr style="vertical-align:top">
                                                <td style="vertical-align:top">
                                                    <%#Eval("INDEX")%>
                                                </td>
                                                <td style="vertical-align:top">
                                                    <asp:TextBox ID="txbIPBegin" runat="server" Columns="15" MaxLength="15" Text='<%# Eval("BEGIN") %>'
                                                        meta:resourcekey="txbIPBeginResource1"></asp:TextBox><asp:RegularExpressionValidator
                                                            ID="RegularExpressionValidator4" runat="server" ControlToValidate="txbIPBegin"
                                                            Display="Dynamic" ErrorMessage="IP格式不正確" SetFocusOnError="True" ValidationExpression="^([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}$"
                                                            meta:resourcekey="RegularExpressionValidator4Resource1"></asp:RegularExpressionValidator>
                                                </td>
                                                <td>~
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txbIPEnd" runat="server" Columns="15" MaxLength="15" Text='<%# Eval("END") %>'
                                                        meta:resourcekey="txbIPEndResource1"></asp:TextBox><asp:RegularExpressionValidator
                                                            ID="RegularExpressionValidator5" runat="server" ControlToValidate="txbIPEnd"
                                                            Display="Dynamic" ErrorMessage="IP格式不正確" SetFocusOnError="True" ValidationExpression="^([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}$"
                                                            meta:resourcekey="RegularExpressionValidator5Resource1"></asp:RegularExpressionValidator><asp:CustomValidator
                                                                ID="cvRangeCheck" runat="server" Display="Dynamic" EnableClientScript="False"
                                                                ErrorMessage="IP區段設定不正確" SetFocusOnError="True" ControlToValidate="txbIPEnd"
                                                                meta:resourcekey="cvRangeCheckResource1"></asp:CustomValidator>
                                                </td>
                                            </tr>
                                        </table>
                                    </ItemTemplate>
                                </asp:DataList>
                                <asp:CheckBox ID="cbIsSSOOnly" runat="server"
                                    Text="在IP範圍內，除系統管理者及外部會員外，其他人員一律需使用Single Sign On"
                                    meta:resourcekey="cbIsSSOOnlyResource1" />
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="rblSSOType"
                                    EventName="SelectedIndexChanged" />
                            </Triggers>
                        </asp:UpdatePanel>
                        <ol style="color: Blue; margin-left: 20px;">
                            <li style="word-break: break-all">
                                <asp:Label ID="lblIPRangeDesc1" runat="server" Text="啟用前請先將主機(AP Server)加入AD網域中"
                                    CssClass="SizeMemo" meta:resourcekey="lblIPRangeDesc1Resource1"></asp:Label></li>
                            <li style="word-break: break-all">
                                <asp:Label ID="lblIPRangeDesc" runat="server" meta:resourcekey="lblIPRangeDescResource1"
                                    Text="啟用後當使用者的IP位址在上列區段中時系統會嘗試讓使用者以SSO的方式登入,例如:設定192.168.1.0~192.168.1.255,而使用者的IP為192.168.1.10時會優先使用SSO登入"
                                    CssClass="SizeMemo"></asp:Label></li>
                            <li style="word-break: break-all">
                                <asp:Label ID="Label34" runat="server" Text="以SSO方式登入失敗時,使用者仍可以使用標準的驗證方式或者使用AD整合式驗證(需先完成設定)"
                                    CssClass="SizeMemo" meta:resourcekey="Label34Resource1"></asp:Label></li>
                            <li style="word-break: break-all">
                                <asp:Label ID="lblIPRangeDesc2" runat="server" Text="啟用用戶端憑證驗證時,請務必啟用IIS中UOF站台的ADAuth目錄裡的SSL設定" CssClass="SizeMemo" meta:resourcekey="lblIPRangeDesc2Resource1"></asp:Label>
                            </li>
                            <li style="word-break: break-all">
                                <asp:Label ID="lblIPRangeDesc3" runat="server" Text="啟用用戶端憑證SSO時,IP範圍內的人員,需設定個人用戶端憑證" CssClass="SizeMemo" meta:resourcekey="lblIPRangeDesc3Resource1"></asp:Label>
                            </li>
                        </ol>
                    </td>
                </tr>
                <tr>
                    <td style="width: 13%; word-break: break-all; white-space:nowrap" class="PopTableLeftTD">
                        <asp:Label ID="Label35" runat="server" Text="AD密碼管理" meta:resourcekey="Label35Resource1"></asp:Label>
                    </td>
                    <td style="width: 87%; word-break: break-all" class="PopTableRightTD">
                        <asp:CheckBox ID="cbADLogin" runat="server" Text="啟用AD整合式驗證(Single Password)" Enabled="False"
                            meta:resourcekey="cbADLoginResource1" />
                        <br />
                        <ol style="color: Blue; margin-left: 20px">
                            <li>
                                <asp:Label ID="Label36" runat="server" Text="啟用前請先完成AD Server 設定" CssClass="SizeMemo"
                                    meta:resourcekey="Label36Resource1"></asp:Label><br />
                                <asp:HyperLink runat="server" ID="HyperLink1" Text="點選這裡設定AD Server" NavigateUrl="~/System/AD/Default.aspx"
                                    meta:resourcekey="HyperLink1Resource1"></asp:HyperLink>
                            </li>
                            <li>
                                <asp:Label ID="Label37" runat="server" Text="啟用之後,可以個別設定使用者是否可以使用AD的帳號密碼登入系統" CssClass="SizeMemo"
                                    meta:resourcekey="Label37Resource1"></asp:Label>
                            </li>
                        </ol>
                        <asp:CheckBox ID="cbAllowChangeADPassword" runat="server" Text="允許使用者變更AD密碼" Enabled="False"
                            meta:resourcekey="cbAllowChangeADPasswordResource1" />
                        <br />
                        <ol style="color: Blue; margin-left: 20px">
                            <li>
                                <asp:Label ID="Label42" runat="server" meta:resourcekey="Label42Resource1" Text="此功能僅適用於啟用&quot;啟用AD整合式驗證(Single Password)&quot;或啟用AD單一簽入(Single Sign On)優先"
                                    CssClass="SizeMemo"></asp:Label></li>
                            <li>
                                <asp:Label ID="Label47" runat="server" meta:resourcekey="Label47Resource1" Text="啟用前請先完成AD Server 設定"
                                    CssClass="SizeMemo"></asp:Label><br />
                                <asp:HyperLink runat="server" ID="HyperLink2" Text="點選這裡設定AD Server" NavigateUrl="~/System/AD/Default.aspx"
                                    meta:resourcekey="HyperLink2Resource1"></asp:HyperLink></li>
                        </ol>
                        <asp:Label ID="Label38" runat="server" Text="AD密碼到期提醒" meta:resourcekey="Label38Resource1"></asp:Label>
                        <br />
                        <asp:TextBox ID="tbADPasswordNotify" runat="server" Columns="2" MaxLength="2" Text="7"
                            meta:resourcekey="tbADPasswordNotifyResource1"></asp:TextBox><asp:Label ID="Label39"
                                runat="server" Text="天" meta:resourcekey="Label39Resource1"></asp:Label>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator17" runat="server" ControlToValidate="tbADPasswordNotify"
                            Display="Dynamic" ErrorMessage="天數不允許空白" SetFocusOnError="True" meta:resourcekey="RequiredFieldValidator17Resource1"></asp:RequiredFieldValidator>
                        <asp:RangeValidator ID="RangeValidator7" runat="server" ControlToValidate="tbADPasswordNotify"
                            Display="Dynamic" ErrorMessage="請輸入1~99之間的數字" MaximumValue="99" MinimumValue="1"
                            SetFocusOnError="True" Type="Integer" meta:resourcekey="RangeValidator7Resource1"></asp:RangeValidator>
                        <br />
                        <ol style="color: Blue; margin-left: 20px">
                            <li>
                                <asp:Label ID="Label52" runat="server" CssClass="SizeMemo" Text="勾選允許使用者變更AD密碼,此設定才會有作用"
                                    meta:resourcekey="Label52Resource1"></asp:Label></li>
                            <li>
                                <asp:Label ID="Label46" runat="server" Text="設定在多少天之前提醒使用者密碼即將到期" CssClass="SizeMemo"
                                    meta:resourcekey="Label46Resource1"></asp:Label></li>
                            <li>
                                <asp:Label ID="Label45" runat="server" CssClass="SizeMemo" Text="在使用者登入之後會出現提醒使用者密碼即將到期畫面"
                                    meta:resourcekey="Label45Resource1"></asp:Label></li>
                        </ol>
                    </td>
                    </tr>
                    <tr>
                        <td style="width: 13%; word-break: break-all; white-space:nowrap" class="PopTableLeftTD">
                            <asp:Label ID="Label40" runat="server" Text="AD帳號登入" meta:resourcekey="Label40Resource1"></asp:Label>
                        </td>
                        <td style="width: 87%; word-break: break-all" class="PopTableRightTD">
                            <table>
                                <tr>
                                    <td>
                                        <asp:CheckBox ID="cbAdLoginOnly" runat="server" Text="內部員工僅能使用AD帳號登入" meta:resourcekey="cbAdLoginOnlyResource1" />
                                        <ol style="color: Blue; margin-left: 20px">
                                            <li>
                                                <asp:Label ID="Label49" runat="server" Text="啟用前請先完成AD Server 設定" CssClass="SizeMemo"
                                                    meta:resourcekey="Label49Resource1"></asp:Label>
                                            </li>
                                            <li>
                                                <asp:Label ID="Label50" runat="server" Text="啟用後除了系統管理者及外部會員外,都必須使用AD的帳號密碼登入" CssClass="SizeMemo"
                                                    meta:resourcekey="Label50Resource1"></asp:Label>
                                            </li>
                                        </ol>
                                        <asp:CheckBox ID="cbAdDomainChoose" runat="server" Text="使用下拉選單挑選登入網域" meta:resourcekey="cbAdDomainChooseResource1" />
                                        <ol style="color: Blue; margin-left: 20px">
                                            <li>
                                                <asp:Label ID="Label77" runat="server" Text="啟用前請先完成AD Server 設定" CssClass="SizeMemo"
                                                    meta:resourcekey="Label36Resource1"></asp:Label>
                                            </li>
                                            <li>
                                                <asp:Label ID="Label78" runat="server" Text="啟用後登入畫面顯示登入的下拉選單" CssClass="SizeMemo" meta:resourcekey="Label78Resource1"></asp:Label>
                                            </li>
                                        </ol>
                                        <asp:Label ID="Label79" runat="server" Text="*" ForeColor="Red"
                                            meta:resourcekey="Label79Resource1"></asp:Label><asp:Label
                                                ID="Label80" runat="server" Text="以UOF帳號登入顯示的名稱" meta:resourcekey="Label80Resource1"></asp:Label>
                                        <asp:TextBox ID="txtUOFName" runat="server"
                                            meta:resourcekey="txtUOFNameResource1"></asp:TextBox><asp:RequiredFieldValidator
                                                ID="RequiredFieldValidator14" runat="server"
                                                ControlToValidate="txtUOFName" Display="Dynamic"
                                                ErrorMessage="以UOF帳號登入顯示的名稱不允許為空白"
                                                meta:resourcekey="RequiredFieldValidator14Resource1"></asp:RequiredFieldValidator>
                                        <br />
                                        <li style="color: Blue; margin-left: 20px">
                                            <asp:Label ID="Label87" runat="server" Text="顯示在登入畫面的登入下拉選單,表示以UOF帳號登入的顯示名稱" CssClass="SizeMemo"
                                                meta:resourcekey="Label87Resource1"></asp:Label>
                                        </li>
                                        <br />
                                    </td>
                                </tr>
                                <tr>
                                    <td style=" display:none;">
                                        <br />
                                        <asp:CheckBox ID="chEnablePassword" runat="server" Text="使用UOF密碼驗證" meta:resourcekey="chEnablePasswordResource1" />

                                        <li style="color: Blue; margin-left: 20px">
                                            <asp:Label ID="lblPasswordMsg1" runat="server" Text="啟用後，原使用AD密碼登入的人員，會改為只能使用UOF密碼登入。" CssClass="SizeMemo" meta:resourcekey="lblPasswordMsg1Resource1"></asp:Label>
                                        </li>

                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:UpdatePanel ID="UpdatePanel7" runat="server">
                                            <ContentTemplate>
                                                <table style="width:100%">
                                                    <tr>
                                                        <td style="text-align:center;" class="PopTableHeader">
                                                            <asp:Label ID="Label88" runat="server" Text="網域名稱設定" meta:resourcekey="Label88Resource1"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <telerik:RadToolBar ID="RadToolBarDomain" runat="server" Width="100%"
                                                                OnButtonClick="RadToolBar_ButtonClick"
                                                                OnClientButtonClicking="RadToolBar_ButtonClicking"
                                                                meta:resourcekey="RadToolBarDomainResource1" SingleClick="None">
                                                                <Items>
                                                                    <telerik:RadToolBarButton runat="server" Value="Insert" Text="新增" meta:resourcekey="TBarButtonResource1"
                                                                        DisabledImageUrl="~/Common/Images/Icon/icon_m71.png" HoveredImageUrl="~/Common/Images/Icon/icon_m71.png"
                                                                        ImageUrl="~/Common/Images/Icon/icon_m71.png"
                                                                        CheckedImageUrl="~/Common/Images/Icon/icon_m71.png"  >
                                                                    </telerik:RadToolBarButton>
                                                                    <telerik:RadToolBarButton runat="server" IsSeparator="True"
                                                                        meta:resourcekey="RadToolBarButtonResource1"  >
                                                                    </telerik:RadToolBarButton>
                                                                    <telerik:RadToolBarButton runat="server" Value="Delete" Text="刪除" meta:resourcekey="TBarButtonResource2"
                                                                        DisabledImageUrl="~/Common/Images/Icon/icon_m03.png" HoveredImageUrl="~/Common/Images/Icon/icon_m03.png"
                                                                        ImageUrl="~/Common/Images/Icon/icon_m03.png"
                                                                        CheckedImageUrl="~/Common/Images/Icon/icon_m03.png" >
                                                                    </telerik:RadToolBarButton>
                                                                    <telerik:RadToolBarButton runat="server" IsSeparator="True"
                                                                        meta:resourcekey="RadToolBarButtonResource2"  >
                                                                    </telerik:RadToolBarButton>
                                                                    <telerik:RadToolBarButton runat="server" Value="Clear" Text="取消預設" meta:resourcekey="TBarButtonResource3"
                                                                        DisabledImageUrl="~/Common/Images/Icon/icon_m03_g.png" HoveredImageUrl="~/Common/Images/Icon/icon_m03_g.png"
                                                                        ImageUrl="~/Common/Images/Icon/icon_m03_g.png"
                                                                        CheckedImageUrl="~/Common/Images/Icon/icon_m03_g.png" >
                                                                    </telerik:RadToolBarButton>
                                                                    <telerik:RadToolBarButton runat="server" IsSeparator="True"
                                                                        meta:resourcekey="RadToolBarButtonResource3"  >
                                                                    </telerik:RadToolBarButton>
                                                                </Items>
                                                            </telerik:RadToolBar>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <Fast:Grid ID="gridDomain" runat="server" AllowSorting="True" AutoGenerateCheckBoxColumn="True"
                                                                AutoGenerateColumns="False" DataKeyNames="DOMAIN_GUID"
                                                                DataKeyOnClientWithCheckBox="False" DefaultSortDirection="Ascending" EnhancePager="True"
                                                                OnPageIndexChanging="gridDomain_PageIndexChanging" OnRowCommand="gridDomain_RowCommand"
                                                                OnRowDataBound="gridDomain_RowDataBound" PageSize="5"
                                                                Width="100%" EmptyDataText="沒有資料"
                                                                KeepSelectedRows="False" meta:resourcekey="gridDomainResource1" CustomDropDownListPage="False" SelectedRowColor="" UnSelectedRowColor=""
                                                                  >
                                                                <EnhancePagerSettings ShowHeaderPager="True" />
                                                                <ExportExcelSettings AllowExportToExcel="False" />
                                                                <Columns>
                                                                    <asp:TemplateField HeaderText="預設" meta:resourcekey="TemplateFieldResource1">
                                                                        <ItemTemplate>
                                                                            <asp:Label ID="lblChecked" runat="server"
                                                                                meta:resourcekey="lblCheckedResource1"></asp:Label>
                                                                        </ItemTemplate>
                                                                        <ItemStyle HorizontalAlign="Center" />
                                                                    </asp:TemplateField>
                                                                    <asp:TemplateField HeaderText="網域名稱" meta:resourcekey="TemplateFieldResource2">
                                                                        <ItemTemplate>
                                                                            <asp:LinkButton ID="lbtnDomainName" runat="server"
                                                                                Text='<%# Eval("DOMAIN_NAME") %>' meta:resourcekey="lbtnDomainNameResource1"></asp:LinkButton>
                                                                        </ItemTemplate>
                                                                        <HeaderStyle HorizontalAlign="Left" />
                                                                    </asp:TemplateField>
                                                                    <asp:TemplateField HeaderText="顯示名稱" meta:resourcekey="TemplateFieldResource3">
                                                                        <ItemTemplate>
                                                                            <asp:Label ID="lblDomainNickName" runat="server"
                                                                                Text='<%# Eval("DOMAIN_NICKNAME") %>'
                                                                                meta:resourcekey="lblDomainNickNameResource1"></asp:Label>
                                                                        </ItemTemplate>
                                                                        <HeaderStyle HorizontalAlign="Left" />
                                                                    </asp:TemplateField>
                                                                    <asp:TemplateField HeaderText="完整網域名稱" meta:resourcekey="FullyDomainTemplateFieldResource2">
                                                                        <ItemTemplate>
                                                                            <asp:Label ID="Label127" runat="server" Text='<%# Eval("FULLY_DOMAIN_NAME") %>'
                                                                                meta:resourcekey="Label127Resource1"></asp:Label>
                                                                        </ItemTemplate>
                                                                    </asp:TemplateField>
                                                                    <asp:TemplateField HeaderText="動作" meta:resourcekey="TemplateFieldResource4">
                                                                        <ItemTemplate>
                                                                            <asp:LinkButton ID="lbtnDefaultDomain" runat="server" Text="設為預設值" meta:resourcekey="lbtnDefaultDomainResource1"></asp:LinkButton>
                                                                        </ItemTemplate>
                                                                        <HeaderStyle HorizontalAlign="Left" />
                                                                    </asp:TemplateField>
                                                                </Columns>
                                                            </Fast:Grid>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                        <asp:Label ID="Label91" runat="server" CssClass="SizeMemo" Text="設定登入下拉選單顯示的網域名稱"
                                            meta:resourcekey="Label91Resource1"></asp:Label>
                                        <br />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                <tr>
                    <td colspan="2" class="PopTableHeader" style="text-align:right">
                        <asp:Label ID="Label70" runat="server" Text="加強驗證" meta:resourcekey="Label70Resource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 13%; word-break: break-all; white-space:nowrap" class="PopTableLeftTD">
                        <asp:Label ID="Label71" runat="server" Text="驗證方式" meta:resourcekey="Label71Resource1"></asp:Label>
                    </td>
                    <td style="width: 87%; word-break: break-all" class="PopTableRightTD">
                        <asp:UpdatePanel ID="caUserPanel" runat="server">
                            <ContentTemplate>
                                <asp:RadioButtonList ID="rdbtnStrengthen" runat="server" AutoPostBack="True" RepeatDirection="Horizontal" OnSelectedIndexChanged="rdbtnStrengthen_SelectedIndexChanged" meta:resourcekey="rdbtnStrengthenResource1">
                                    <asp:ListItem Value="NO" meta:resourcekey="ListItemResource27" Text="不啟用"></asp:ListItem>
                                    <asp:ListItem Value="USBKey" meta:resourcekey="ListItemResource28" Text="啟用USB Key認證"></asp:ListItem>
                                    <asp:ListItem Value="CA" meta:resourcekey="ListItemResource29" Text="啟用用戶端憑證驗證"></asp:ListItem>
                                </asp:RadioButtonList>
                                <br />
                                <asp:Label ID="lblTitleUSBKey" runat="server" Text="USB Key認證" meta:resourcekey="lblTitleUSBKeyResource1"></asp:Label>
                                <br />
                                <ol style="color: Blue; margin-left: 20px">
                                    <li>
                                        <asp:Label ID="lblUSBLoginDesc" runat="server" Text="USB Key 為選購" CssClass="SizeMemo"
                                            meta:resourcekey="lblUSBLoginDescResource1"></asp:Label></li>
                                    <li>
                                        <asp:Label ID="Label123" runat="server" Text="啟用之後,可以個別設定:使用者除了帳號密碼之外還需USB Key才能登入系統"
                                            CssClass="SizeMemo" meta:resourcekey="Label123Resource1"></asp:Label>
                                    </li>
                                </ol>
                                <asp:Label ID="lblTitleCA" runat="server" Text="用戶端憑證" meta:resourcekey="lblTitleCAResource1"></asp:Label>
                                <asp:CustomValidator ID="cvCheckCAuser" runat="server" SetFocusOnError="True"
                                    Display="Dynamic" OnServerValidate="cvCheckCAuser_ServerValidate"
                                    meta:resourcekey="cvCheckCAuserResource1"></asp:CustomValidator>
                                <ol style="color: Blue; margin-left: 20px">
                                    <li>
                                        <asp:Label ID="lblMsgCA1" runat="server" Text="啟用用戶端憑證驗證時,請務必啟用IIS中UOF站台的ADAuth目錄裡的SSL設定" CssClass="SizeMemo" meta:resourcekey="lblMsgCA1Resource1"></asp:Label>
                                    </li>
                                    <li>
                                        <asp:Label ID="lblMsgCA2" runat="server" Text="啟用用戶端憑證驗證時,需驗證的人員要設定個人用戶端憑證" CssClass="SizeMemo" meta:resourcekey="lblMsgCA2Resource1"></asp:Label>
                                    </li>
                                </ol>
                                <asp:Panel ID="PanelCAuser" runat="server" meta:resourcekey="PanelCAuserResource1">
                                    <asp:Label ID="lblTitleCAuser" runat="server" Text="需驗證人員" meta:resourcekey="lblTitleCAuserResource1"></asp:Label>
                                    <br />
                                    <uc2:UC_ChoiceList ID="UC_ChoiceListCAuser" runat="server" />
                                    <br />
                                    <table style="width: 600px;" class="PopTable">
                                        <tr>
                                            <td colspan="2" style="text-align:center" class="PopTableHeader">
                                                <asp:Label ID="Label124" runat="server" Text="用戶端憑證相關設定"
                                                    meta:resourcekey="Label124Resource1"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="white-space: nowrap" class="PopTableLeftTD">
                                                <asp:Label ID="Label116" runat="server" Text="*" ForeColor="Red"
                                                    meta:resourcekey="Label113Resource1"></asp:Label>
                                                <asp:Label ID="Label72" runat="server" Text="憑證要求代理序號"
                                                    meta:resourcekey="Label72Resource2"></asp:Label>
                                            </td>
                                            <td class="PopTableRightTD">
                                                <asp:TextBox ID="txtAgentSN" runat="server" Width="250px"
                                                    meta:resourcekey="txtAgentSNResource1"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="white-space: nowrap" class="PopTableLeftTD">
                                                <asp:Label ID="Label121" runat="server" Text="*" ForeColor="Red"
                                                    meta:resourcekey="Label121Resource1"></asp:Label>
                                                <asp:Label ID="Label122" runat="server" Text="網域名稱"
                                                    meta:resourcekey="Label122Resource1"></asp:Label>
                                            </td>
                                            <td class="PopTableRightTD">
                                                <asp:TextBox ID="txtCaDomain" runat="server"
                                                    meta:resourcekey="txtCaDomainResource1"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="white-space: nowrap" class="PopTableLeftTD">
                                                <asp:Label ID="Label117" runat="server" Text="*" ForeColor="Red"
                                                    meta:resourcekey="Label117Resource1"></asp:Label>
                                                <asp:Label ID="Label118" runat="server" Text="憑證伺服器名稱"
                                                    meta:resourcekey="Label118Resource1"></asp:Label>
                                            </td>
                                            <td class="PopTableRightTD">
                                                <asp:TextBox ID="txtCaMachineName" runat="server"
                                                    meta:resourcekey="txtCaMachineNameResource1"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="white-space: nowrap" class="PopTableLeftTD">
                                                <asp:Label ID="Label125" runat="server" Text="*" ForeColor="Red"
                                                    meta:resourcekey="Label125Resource1"></asp:Label>
                                                <asp:Label ID="Label119" runat="server" Text="憑證授權單位(CA)名稱"
                                                    meta:resourcekey="Label119Resource1"></asp:Label>
                                            </td>
                                            <td class="PopTableRightTD">
                                                <asp:TextBox ID="txtCaName" runat="server"
                                                    meta:resourcekey="txtCaNameResource1"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="white-space: nowrap" class="PopTableLeftTD">
                                                <asp:Label ID="Label126" runat="server" Text="IP範圍"
                                                    meta:resourcekey="Label126Resource1"></asp:Label>
                                            </td>
                                            <td class="PopTableRightTD">
                                                <asp:CheckBox ID="cbCaIP" runat="server" Text="啟用限制IP範圍" AutoPostBack="True"
                                                    OnCheckedChanged="cbCaIP_CheckedChanged" meta:resourcekey="cbCaIPResource1" />
                                                <asp:DataList ID="dalCaIPRange" runat="server" ShowFooter="False"
                                                    meta:resourcekey="dalCaIPRangeResource1">
                                                    <HeaderTemplate>
                                                    </HeaderTemplate>
                                                    <ItemTemplate>
                                                        <table>
                                                            <tr style="vertical-align:top">
                                                                <td style="vertical-align:top">
                                                                    <%#Eval("INDEX")%>
                                                                </td>
                                                                <td style="vertical-align:top">
                                                                    <asp:TextBox ID="txbCaIPBegin" runat="server" Columns="15" MaxLength="15"
                                                                        Text='<%# Eval("BEGIN") %>' meta:resourcekey="txbCaIPBeginResource1"></asp:TextBox>
                                                                    <asp:RegularExpressionValidator
                                                                        ID="revCheckCaBegin" runat="server" ControlToValidate="txbCaIPBegin"
                                                                        Display="Dynamic" ErrorMessage="IP格式不正確" SetFocusOnError="True"
                                                                        ValidationExpression="^([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}$" meta:resourcekey="revCheckCaBeginResource1"></asp:RegularExpressionValidator>
                                                                </td>
                                                                <td>~
                                                                </td>
                                                                <td>
                                                                    <asp:TextBox ID="txbCaIPEnd" runat="server" Columns="15" MaxLength="15"
                                                                        Text='<%# Eval("END") %>' meta:resourcekey="txbCaIPEndResource1"></asp:TextBox>
                                                                    <asp:RegularExpressionValidator ID="revCheckCaEnd" runat="server" ControlToValidate="txbCaIPEnd"
                                                                        Display="Dynamic" ErrorMessage="IP格式不正確" SetFocusOnError="True"
                                                                        ValidationExpression="^([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}$" meta:resourcekey="revCheckCaEndResource1"></asp:RegularExpressionValidator>
                                                                    <asp:CustomValidator ID="cvCaRangeCheck" runat="server" Display="Dynamic"
                                                                        EnableClientScript="False" ErrorMessage="IP區段設定不正確" SetFocusOnError="True"
                                                                        ControlToValidate="txbCaIPEnd" meta:resourcekey="cvCaRangeCheckResource1"></asp:CustomValidator>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </ItemTemplate>
                                                </asp:DataList>
                                                <asp:Label ID="lblCAIPMsg" runat="server" Text="啟用限制IP範圍，則需驗證人員必須要在限制的IP範圍內才可申請憑證或經由憑證加強驗證後登入UOF系統。" CssClass="SizeMemo" meta:resourcekey="lblCAIPMsgResource1"></asp:Label>
                                            </td>
                                        </tr>
                                    </table>
                                </asp:Panel>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" class="PopTableHeader" style="text-align:left">
                        <asp:Label ID="lblLoginLog" runat="server" Text="使用者登入記錄" meta:resourcekey="lblLoginLogResource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 13%; word-break: break-all; white-space:nowrap" class="PopTableLeftTD">
                        <asp:Label ID="lblIsLogAutoDelete" runat="server" Text="是否自動清除記錄" meta:resourcekey="lblIsLogAutoDeleteResource1"></asp:Label>
                    </td>
                    <td style="width: 87%; word-break: break-all" class="PopTableRightTD">
                        <asp:CheckBox ID="cbIsLogAutoDelete" runat="server" AutoPostBack="True" OnCheckedChanged="cbIsLogAutoDelete_CheckedChanged"
                            meta:resourcekey="cbIsLogAutoDeleteResource1" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 13%; word-break: break-all; white-space:nowrap" class="PopTableLeftTD">
                        <asp:Label ID="lblLogSurvivalPeriod" runat="server" Text="記錄保留期限(月)" meta:resourcekey="lblLogSurvivalPeriodResource1"></asp:Label>
                    </td>
                    <td style="width: 87%; word-break: break-all" class="PopTableRightTD">
                        <asp:DropDownList ID="ddlLogSurvivalPeriod" runat="server" meta:resourcekey="ddlLogSurvivalPeriodResource1">
                        </asp:DropDownList>
                        <asp:TextBox ID="txtLogSurvivalPeriod" runat="server" MaxLength="2" meta:resourcekey="txtLogSurvivalPeriodResource1"
                            Columns="2" Visible="False"></asp:TextBox>
                        <asp:Label ID="Label55" runat="server" Text="個月" meta:resourcekey="Label55Resource1"></asp:Label>
                        <asp:CompareValidator ID="cvLogTime" runat="server" ControlToValidate="txtLogSurvivalPeriod"
                            Display="Dynamic" ErrorMessage="請輸入正整數" Type="Integer" Operator="GreaterThan"
                            ValueToCompare="0" meta:resourcekey="cvLogTimeResource1"></asp:CompareValidator>
                        <asp:RequiredFieldValidator ID="rfvLogTime" runat="server" ControlToValidate="ddlLogSurvivalPeriod"
                            Display="Dynamic" ErrorMessage="已啟用自動清除記錄，不允許空白" meta:resourcekey="rfvLogTimeResource1"></asp:RequiredFieldValidator>
                    </td>
                </tr>

                <tr>
                    <td colspan="2" class="PopTableHeader" style="text-align:left">
                        <asp:Label ID="lblSpecialUserLogin" runat="server" Text="特殊使用者登入" meta:resourcekey="lblLoginSpecialUserResource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD" style="width: 13%; word-break: break-all; white-space:nowrap">
                        <asp:Label ID="lblPowerUser" runat="server" meta:resourcekey="lblPowerUserResource1" Text="PowerUser設定"></asp:Label>
                    </td>
                    <td class="PopTableRightTD" style="width: 87%; word-break: break-all">
                        <uc2:UC_ChoiceList ID="UC_PowerUserList" runat="server" ExpandToUser="true"  ShowMember="False" />
                        
                        <br />
                        <asp:Label ID="lblPowerUserMemo" runat="server" CssClass="SizeMemo"
                                meta:resourcekey="lblPowerUserMemoResource1" Text="PowerUser不受各模組授權人數已滿限制，可以強制進入並踢除該模組閒置最久的人"></asp:Label>
                        
                    </td>
                </tr>

                <tr>
                    <td  colspan="2" class="PopTableLeftTD" style="text-align:center">
                        <table style="width:100%" border="0">
                            <tr>
                                <td style="width: 45%; text-align:right"></td>
                                <td style="width: 13%; text-align:center">
                                    <telerik:RadButton ID="rbtnSave2" runat="server" Text="儲存"
                                        OnClientClicked="btnSave_Click" OnClick="rbtnSave2_Click"
                                        meta:resourcekey="rbtnSave2Resource1">
                                    </telerik:RadButton>
                                </td>
                                <td style="width: 45%"></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </telerik:RadPageView>
        <telerik:RadPageView ID="moduleSet" runat="server"
            meta:resourcekey="moduleSetResource1">
            <table border="0" class="PopTable" style="width:100%">
                <tr>
                    <td class="PopTableHeader" colspan="2" style="text-align:left">
                        <asp:Label ID="lblDMS" runat="server" meta:resourcekey="lblDMSResource1"
                            Text="文件管理"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD" style="width: 13%; word-break: break-all; white-space:nowrap">
                        <asp:Label ID="lblDMSPdfControl" runat="server"
                            meta:resourcekey="lblDMSPdfControlResource1" Text="原稿控制"></asp:Label>
                    </td>
                    <td class="PopTableRightTD" style="width: 87%; word-break: break-all">
                        <asp:CheckBox ID="cbDMSPdfControl" runat="server"
                            meta:resourcekey="cbDMSPdfControlResource1" Text="啟用" />

                        <asp:RadioButtonList ID="rdoPDFControl" runat="server" meta:resourcekey="rdoPDFControlResource1">
                            <asp:ListItem meta:resourcekey="ListItemResource35" Text="自行上傳PDF文件" Value="STANDARD"></asp:ListItem>
                            <asp:ListItem meta:resourcekey="ListItemResource36" Text="自動轉檔(需要文件轉檔授權)" Value="UOF"></asp:ListItem>
                        </asp:RadioButtonList>
                        <asp:Label ID="lblDMSConvertMemo" CssClass="SizeMemo" runat="server" Text="自動轉檔支援以下格式(doc,docx,txt,ppt,pptx,xls,xlsx,jpg,png,bmp,gif,pdf,ods,odt,odp)" meta:resourcekey="lblDMSConvertMemoResource1"></asp:Label>
                        <asp:HiddenField ID="hideDMSConvert" runat="server" />
                        <asp:HiddenField ID="hidePDFControl" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD" style="width: 13%; word-break: break-all; white-space:nowrap;">
                        <asp:Label ID="lblDocCheckOutLimit" runat="server"
                            meta:resourcekey="lblDocCheckOutLimitResource1" Text="文件取出到期通知時間"></asp:Label>
                    </td>
                    <td class="PopTableRightTD" style="width: 87%; word-break: break-all;">
                        <asp:TextBox ID="txtDocCheckOutLimit" runat="server" MaxLength="4" Width="40px"
                            meta:resourcekey="txtDocCheckOutLimitResource1"></asp:TextBox>
                        <asp:Label ID="Label129" runat="server" meta:resourcekey="Label56Resource1"
                            Text="天"></asp:Label>
                        <asp:RangeValidator ID="RangeValidator13" runat="server"
                            ControlToValidate="txtDocCheckOutLimit" Display="Dynamic"
                            ErrorMessage="只允許輸入數字" MaximumValue="9999"
                            meta:resourcekey="RangeValidator13Resource1" MinimumValue="0" Type="Integer"></asp:RangeValidator>
                        <br />
                        <asp:Label ID="lblDocCheckOutMsg" runat="server" CssClass="SizeMemo"
                            meta:resourcekey="lblDocCheckOutMsgResource1" Text="取出時間到期通知文件作者，0或空白則不通知"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD" style="width: 13%; word-break: break-all; white-space:nowrap">
                        <asp:Label ID="lblDocInvalidDay" runat="server"
                            meta:resourcekey="lblDocInvalidDayResource1" Text="文件到期前通知"></asp:Label>
                    </td>
                    <td class="PopTableRightTD" style="width: 87%; word-break: break-all">
                        <asp:TextBox ID="txtDocInvalidDay" runat="server" MaxLength="4" Width="40px"
                            meta:resourcekey="txtDocInvalidDayResource1"></asp:TextBox>
                        <asp:Label ID="Label130" runat="server" meta:resourcekey="Label56Resource1"
                            Text="天"></asp:Label>
                        <asp:RangeValidator ID="RangeValidator14" runat="server"
                            ControlToValidate="txtDocInvalidDay" Display="Dynamic" ErrorMessage="只允許輸入數字"
                            MaximumValue="9999" meta:resourcekey="RangeValidator14Resource1"
                            MinimumValue="0" Type="Integer"></asp:RangeValidator>
                        <br />
                        <asp:Label ID="lblDocInvalidMsg" runat="server" CssClass="SizeMemo"
                            meta:resourcekey="lblDocInvalidMsgResource1" Text="到期通知文件作者及目錄管理者，設定0為到期當日通知，空白則不通知"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD" style="width: 13%; word-break: break-all; white-space:nowrap">
                        <asp:Label ID="lblSerialMode" runat="server" Text="文件編號驗證"
                            meta:resourcekey="lblSerialModeResource1"></asp:Label>
                    </td>
                    <td class="PopTableRightTD" style="width: 87%; word-break: break-all">
                        <asp:RadioButtonList ID="rblSerialMode" runat="server"
                            RepeatDirection="Horizontal" meta:resourcekey="rblPrintControlVisibleResource1">
                            <asp:ListItem Text="全文件庫不可重複" Value="Dms" Selected="True" meta:resourcekey="rblSerialModeResource1"></asp:ListItem>
                            <asp:ListItem Text="同目錄內不可重複" Value="Folder" meta:resourcekey="rblSerialModeResource2"></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD" style="width: 13%; word-break: break-all; white-space:nowrap">
                        <asp:Label ID="Label131" runat="server" Text="熱門文件顯示範圍" meta:resourcekey="Label100Resource2"></asp:Label>
                    </td>
                    <td class="PopTableRightTD" style="width: 87%; word-break: break-all">
                        <asp:DropDownList ID="ddlPopuDocRange" runat="server" meta:resourcekey="ddlPopuDocRangeResource1">
                            <asp:ListItem Text="半個月" Value="half" meta:resourcekey="ListItemResource30"></asp:ListItem>
                            <asp:ListItem Text="一個月" Value="1" meta:resourcekey="ListItemResource31"></asp:ListItem>
                            <asp:ListItem Text="三個月" Value="3" meta:resourcekey="ListItemResource32"></asp:ListItem>
                            <asp:ListItem Text="六個月" Value="6" meta:resourcekey="ListItemResource33"></asp:ListItem>
                            <asp:ListItem Text="十二個月" Value="12" meta:resourcekey="ListItemResource34"></asp:ListItem>
                        </asp:DropDownList>
                        <br />
                        <asp:Label ID="Label100" runat="server" Text="僅顯示觀看人數或次數5次以上的文件" CssClass="SizeMemo" meta:resourcekey="Label100Resource3"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD" style="width: 13%; word-break: break-all; white-space: nowrap">
                        <asp:Label ID="lblDmsClassLevel" runat="server" Text="類別階層" meta:resourcekey="lblDmsClassLevelResource1"></asp:Label>
                    </td>
                    <td class="PopTableRightTD" style="width: 87%; word-break: break-all">
                        <asp:Label ID="lblDmsExpandTo" runat="server" Text="展開至" meta:resourcekey="lblDmsExpandToResource1"></asp:Label>
                        <telerik:RadNumericTextBox ID="rnDmsClassExpand" Width="40px" runat="server"
                            DataType="System.Decimal" MaxLength="2" MinValue="1" Culture="zh-TW"
                            DbValueFactor="1" LabelCssClass="" LabelWidth="64px"
                            meta:resourcekey="rnBullClassExpandResource1">
                            <NegativeStyle Resize="None" />
                            <NumberFormat DecimalDigits="0" ZeroPattern="n" />
                            <EmptyMessageStyle Resize="None" />
                            <ReadOnlyStyle Resize="None" />
                            <FocusedStyle Resize="None" />
                            <DisabledStyle Resize="None" />
                            <InvalidStyle Resize="None" />
                            <HoveredStyle Resize="None" />
                            <EnabledStyle HorizontalAlign="Right" Resize="None" />
                        </telerik:RadNumericTextBox>
                        <asp:Label ID="lblDmsLevel" runat="server" Text="階" meta:resourcekey="lblDmsLevelResource1"></asp:Label>
                        <br />
                        <asp:Label ID="lblDmsExpandTitle" runat="server" CssClass="SizeMemo"
                            meta:resourcekey="lblDmsExpandTitleResource1" Text="如無設定預設為全部展開"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD" style="width: 13%; word-break: break-all; white-space: nowrap">
                        <asp:Label ID="lblDocChange" runat="server" Text="文件置換" meta:resourcekey="lblDocChangeResource1"></asp:Label>
                    </td>
                    <td class="PopTableRightTD" style="width: 87%; word-break: break-all">
                        <asp:CheckBox ID="cbEnableDocChange" runat="server" Text="啟用" meta:resourcekey="cbEnableDocChangeResource1"/> <br />
                        <asp:Label ID="lblDocChangeMemo" runat="server" CssClass="SizeMemo" Text="啟用後，系統管理者、文管管理者、目錄管理者，可對已公佈文件做文件置換動作" meta:resourcekey="lblDocChangeMemoResource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableHeader" colspan="2" style="text-align:left">
                        <asp:Label ID="lblBulletinSet" runat="server"
                            meta:resourcekey="lblBulletinSetResource1" Text="公告"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD" style="width: 13%; word-break: break-all; white-space:nowrap">
                        <asp:Label ID="lblBulletinDefaultDays" runat="server"
                            meta:resourcekey="lblBulletinDefaultDaysResource1" Text="最新公告顯示範圍"></asp:Label>
                    </td>
                    <td class="PopTableRightTD" style="width: 87%; word-break: break-all">
                        <asp:DropDownList ID="ddlBulletinSet" runat="server"
                            meta:resourcekey="ddlBulletinSetResource1">
                            <asp:ListItem meta:resourcekey="ListItem1Resource1" Text="半個月" Value="Default"></asp:ListItem>
                            <asp:ListItem meta:resourcekey="ListItem2Resource1" Text="一個月" Value="1"></asp:ListItem>
                            <asp:ListItem meta:resourcekey="ListItem3Resource1" Text="三個月" Value="3"></asp:ListItem>
                            <asp:ListItem meta:resourcekey="ListItem4Resource1" Text="六個月" Value="6"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD" style="width: 13%; word-break: break-all; white-space:nowrap">
                        <asp:Label ID="Label106" runat="server" meta:resourcekey="Label106Resource1"
                            Text="列印控制"></asp:Label>
                    </td>
                    <td class="PopTableRightTD" style="width: 87%; word-break: break-all">
                        <asp:RadioButtonList ID="rblBulletinPrint" runat="server"
                            meta:resourcekey="rblBulletinPrintResource1" RepeatDirection="Horizontal">
                            <asp:ListItem meta:resourcekey="ListItemResource17" Text="可列印" Value="True"></asp:ListItem>
                            <asp:ListItem meta:resourcekey="ListItemResource18" Text="不可列印" Value="False"></asp:ListItem>
                            <asp:ListItem meta:resourcekey="ListItemResource19" Text="由發佈者自訂"
                                Value="UserDefine"></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD" style="width: 13%; word-break: break-all; white-space:nowrap">
                        <asp:Label ID="lblMarquee" runat="server"
                            meta:resourcekey="lblMarqueeResource2" Text="跑馬燈"></asp:Label>
                    </td>
                    <td class="PopTableRightTD" style="width: 87%; word-break: break-all">
                        <table style="width: 100%">
                            <tr>
                                <td style="text-align:left">
                                    <asp:CheckBox ID="ckMarquee" runat="server"
                                        meta:resourcekey="ckMarqueeResource2" />
                                    <asp:Label ID="lblMarquee2" runat="server"
                                        meta:resourcekey="lblMarqueeResource1" Text="啟用跑馬燈"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align:right">
                                    <table style="width: 100%">
                                        <tr>
                                            <td style="width: 10%; white-space:nowrap; text-align:right">
                                                <asp:Label ID="lblBulletinDirection" runat="server"
                                                    meta:resourcekey="lblBulletinDirectionResource1" Text="播放方式"></asp:Label>
                                            </td>
                                            <td style="text-align:left">
                                                <asp:RadioButtonList ID="rblBulletinDirection" runat="server"
                                                    meta:resourcekey="rblBulletinDirectionResource1" RepeatDirection="Horizontal"
                                                    RepeatLayout="Flow">
                                                    <asp:ListItem meta:resourcekey="VerticalListItemResource" Selected="True"
                                                        Text="垂直輪播" Value="Vertical"></asp:ListItem>
                                                    <asp:ListItem meta:resourcekey="HorizontalListItemResource" Text="水平播放"
                                                        Value="Horizontal"></asp:ListItem>
                                                </asp:RadioButtonList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 10%; white-space:nowrap; text-align:right">
                                                <asp:Label ID="lblBulletinPlaySpeed" runat="server"
                                                    meta:resourcekey="lblBulletinPlaySpeedResource1" Text="播放速度"></asp:Label>
                                            </td>
                                            <td style="text-align:left">
                                                <asp:RadioButtonList ID="rblBulletinPlaySpeed" runat="server"
                                                    meta:resourcekey="rblBulletinPlaySpeedResource1" RepeatDirection="Horizontal"
                                                    RepeatLayout="Flow">
                                                    <asp:ListItem meta:resourcekey="FastListItemResource" Text="快" Value="Fast"></asp:ListItem>
                                                    <asp:ListItem meta:resourcekey="MiddleListItemResource" Selected="True"
                                                        Text="中" Value="Middle"></asp:ListItem>
                                                    <asp:ListItem meta:resourcekey="SlowListItemResource" Text="慢" Value="Slow"></asp:ListItem>
                                                </asp:RadioButtonList>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align:left">
                                    <asp:CheckBox ID="cbSettingColor" runat="server"
                                        meta:resourcekey="cbSettingColorResource1" />
                                    <asp:Label ID="lblSettingColor" runat="server"
                                        meta:resourcekey="lblSettingColorResource1" Text="自訂顏色"></asp:Label>
                                    <asp:Label ID="lblComment" runat="server" CssClass="SizeMemo"
                                        meta:resourcekey="lblCommentResource1" Text="(不設定採系統預設值)"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align:right">
                                    <table style="width: 100%">
                                        <tr>
                                            <td style="width: 10%; white-space:nowrap; text-align:right">
                                                <asp:Label ID="lblFontColor" runat="server"
                                                    meta:resourcekey="lblFontColorResource1" Text="字體顏色"></asp:Label>
                                            </td>
                                            <td style="text-align:left">
                                                <telerik:RadColorPicker ID="txtTextColor" runat="server" Preset="Standard" ShowIcon="True" EnableCustomColor="True" ShowRecentColors="True" ShowEmptyColor="False" Width="500px" Columns="12" meta:resourcekey="txtTextColorResource3" SelectedColor="">
                                                    <Localization RGBSlidersTabText=" RGB Sliders" />
                                                </telerik:RadColorPicker>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 10%; white-space:nowrap; text-align:right">
                                                <asp:Label ID="lblBackGroundColor" runat="server"
                                                    meta:resourcekey="lblBackGroundColorResource1" Text="背景顏色"></asp:Label>
                                            </td>
                                            <td style="text-align:left">
                                                <telerik:RadColorPicker ID="txtTextColor2" runat="server" Preset="Standard" ShowIcon="True" EnableCustomColor="True" ShowRecentColors="True" ShowEmptyColor="False" Width="500px" Columns="12" meta:resourcekey="txtTextColor2Resource3" SelectedColor="">
                                                    <Localization RGBSlidersTabText=" RGB Sliders" />
                                                </telerik:RadColorPicker>

                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD" style="width: 13%; word-break: break-all; white-space:nowrap">
                        <asp:Label ID="lblClassDisplyTitle" runat="server"
                            meta:resourcekey="lblClassDisplyTitleResource1" Text="公告類別顯示"></asp:Label>
                    </td>
                    <td class="PopTableRightTD" style="width: 87%; word-break: break-all">
                        <asp:CheckBox ID="cbClassDisplay" runat="server"
                            meta:resourcekey="cbClassDisplayResource1" Text="根據權限顯示公告類別" />
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD" style="width: 13%; word-break: break-all; white-space:nowrap">
                        <asp:Label ID="lblBulletinFileTitle" runat="server"
                            meta:resourcekey="lblBulletinFileTitleResource1" Text="訊息通知"></asp:Label>
                    </td>
                    <td class="PopTableRightTD" style="width: 87%; word-break: break-all">
                        <asp:CheckBox ID="cbBulletinFile" runat="server" Checked="True"
                            meta:resourcekey="cbBulletinFileResource1" Text="包含附件" />
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD" style="width: 13%; word-break: break-all">
                        <asp:Label ID="lblbullExamine" runat="server"
                            meta:resourcekey="lblbullExamineTitleResource1" Text="公告審核"></asp:Label>
                    </td>
                    <td class="PopTableRightTD" style="width: 87%; word-break: break-all">
                        <asp:UpdatePanel ID="UpdatePanel9" runat="server">
                            <ContentTemplate>
                                <asp:CheckBox ID="cbBullExamine" runat="server" AutoPostBack="True"
                                    meta:resourcekey="cbBullExamineResource1"
                                    OnCheckedChanged="cbBullExamine_CheckedChanged" Text="公告發佈之前必須經過審核" />
                                <asp:Label ID="Label115" runat="server" meta:resourcekey="Label115Resource1"
                                    Text="(任一審核人員通過即發佈)"></asp:Label>
                                <asp:CustomValidator ID="cvCheckExamine" runat="server" Display="Dynamic"
                                    ErrorMessage="請選取審核人員" meta:resourcekey="cvCheckExamineResource1"
                                    OnServerValidate="cvCheckExamine_ServerValidate" SetFocusOnError="True"></asp:CustomValidator>
                                <uc2:UC_ChoiceList ID="UC_ChoiceListExamine" runat="server" />
                                <br />
                                <asp:CustomValidator ID="chCheckClassHasExamine" runat="server" Display="Dynamic" 
                                    OnServerValidate="chCheckClassHasExamine_ServerValidate" SetFocusOnError="True" meta:resourcekey="chCheckClassHasExamineResource2"></asp:CustomValidator>
                                 <asp:Label ID="lblCheckClassHasExamineMsg" runat="server" Text="以下類別內尚有審核中的公告，請設定審核者進行審核:<br />{0}" Visible="False" meta:resourcekey="lblCheckClassHasExamineMsgResource1"></asp:Label>
                                 <asp:Label ID="lblNeedExamineClassName" runat="server" Visible="False" meta:resourcekey="lblNeedExamineClassNameResource2"></asp:Label>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD" style="width: 13%; word-break: break-all">
                        <asp:Label ID="lblExpandTitle1" runat="server"
                            meta:resourcekey="lblExpandTitle1Resource2" Text="類別階層"></asp:Label>
                    </td>
                    <td class="PopTableRightTD" style="width: 87%; word-break: break-all">
                        <asp:Label ID="lblExpandTitle2" runat="server"
                            meta:resourcekey="lblExpandTitle2Resource2" Text="展開至"></asp:Label>
                        <telerik:RadNumericTextBox ID="rnBullClassExpand" Width="40px" runat="server"
                            DataType="System.Decimal" MaxLength="2" MinValue="1" Culture="zh-TW"
                            DbValueFactor="1" LabelCssClass="" LabelWidth="64px"
                            meta:resourcekey="rnBullClassExpandResource1">
                            <NegativeStyle Resize="None" />
                            <NumberFormat DecimalDigits="0" ZeroPattern="n" />
                            <EmptyMessageStyle Resize="None" />
                            <ReadOnlyStyle Resize="None" />
                            <FocusedStyle Resize="None" />
                            <DisabledStyle Resize="None" />
                            <InvalidStyle Resize="None" />
                            <HoveredStyle Resize="None" />
                            <EnabledStyle HorizontalAlign="Right" Resize="None" />
                        </telerik:RadNumericTextBox>
                        <asp:Label ID="lblExpandTitle3" runat="server"
                            meta:resourcekey="lblExpandTitle3Resource2" Text="階"></asp:Label>
                        <br />
                        <asp:Label ID="lblExpandTitle4" runat="server" CssClass="SizeMemo"
                            meta:resourcekey="lblExpandTitle4Resource2" Text="如無設定預設為全部展開"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD" style="width: 13%; word-break: break-all">
                         <asp:Label ID="lblBulletinPublishFrom" runat="server"
                            meta:resourcekey="lblBulletinPublishFromResource1" Text="公告發佈來源"></asp:Label>
                    </td>
                    <td class="PopTableRightTD" style="width: 87%; word-break: break-all">
                        <asp:CheckBox ID="cbBulletinSource" runat="server" Text="僅可由公告申請單發佈" meta:resourcekey="cbBulletinSourceResource1" ></asp:CheckBox>
                        <br />
                        <asp:Label ID="lblPublishSourceMemo" runat="server" CssClass="SizeMemo" Text="「系統管理者」及「公告管理員」不受此限制。"
                            meta:resourcekey="lblPublishSourceMemoResource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD" style="width: 13%; word-break: break-all">
                         <asp:Label ID="lblBulletinModifyFrom" runat="server"
                             Text="公告變更來源" meta:resourcekey="lblBulletinModifyFromResource1"></asp:Label>
                    </td>
                    <td class="PopTableRightTD" style="width: 87%; word-break: break-all">
                        <asp:CheckBox ID="cbModifyBulletinSource" runat="server" Text="僅可由公告變更單變更" meta:resourcekey="cbModifyBulletinSourceResource1"></asp:CheckBox>
                        <br />
                        <asp:Label ID="lblModifySourceMemo" runat="server" CssClass="SizeMemo" Text="「系統管理者」及「公告管理員」不受此限制。" meta:resourcekey="lblModifySourceMemoResource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableHeader" colspan="2" style="text-align:left">
                        <asp:Label ID="lblSetLiveMovie" runat="server"
                            meta:resourcekey="lblSetLiveMovieResource1" Text="線上影音設定"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD" style="width: 13%; word-break: break-all; white-space:nowrap">
                        <asp:Label ID="lblNewMovie" runat="server"
                            meta:resourcekey="lblNewMovieResource1" Text="最新影音天數設定"></asp:Label>
                    </td>
                    <td class="PopTableRightTD" style="width: 87%; word-break: break-all">
                        <asp:TextBox ID="txtNewMovieDate" runat="server" MaxLength="4"
                            meta:resourcekey="txtNewMovieDateResource1" Width="50px"></asp:TextBox>
                        <asp:Label ID="Label56" runat="server" meta:resourcekey="Label56Resource1"
                            Text="天"></asp:Label>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator19" runat="server"
                            ControlToValidate="txtNewMovieDate" Display="Dynamic" ErrorMessage="不允許空白"
                            meta:resourcekey="RequiredFieldValidator19Resource1"></asp:RequiredFieldValidator>
                        <asp:RangeValidator ID="RangeValidator9" runat="server"
                            ControlToValidate="txtNewMovieDate" Display="Dynamic" ErrorMessage="只允許輸入數字"
                            MaximumValue="9999" meta:resourcekey="RangeValidator9Resource1"
                            MinimumValue="0" Type="Integer"></asp:RangeValidator>
                    </td>
                </tr>
                <tr>
                    <td style="text-align:left" class="PopTableHeader" colspan="2">
                        <asp:Label ID="Label93" runat="server" meta:resourcekey="Label93Resource1"
                            Text="相片簿設定"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD" style="width: 13%; word-break: break-all; white-space:nowrap">
                        <asp:Label ID="Label96" runat="server" ForeColor="Red"
                            meta:resourcekey="Label96Resource1" Text="*"></asp:Label>
                        <asp:Label ID="Label94" runat="server" meta:resourcekey="Label94Resource1"
                            Text="允許上傳檔案大小"></asp:Label>
                    </td>
                    <td class="PopTableRightTD" style="width: 87%; word-break: break-all">
                        <asp:TextBox ID="txtMaxFileSize" runat="server" MaxLength="4"
                            meta:resourcekey="txtMaxFileSizeResource1" Width="50px"></asp:TextBox>
                        <asp:Label ID="Label95" runat="server" meta:resourcekey="Label95Resource1"
                            Text="MB(0~2000MB)"></asp:Label>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator18" runat="server"
                            ControlToValidate="txtMaxFileSize" Display="Dynamic" ErrorMessage="不允許空白"
                            meta:resourcekey="RequiredFieldValidator18Resource1" SetFocusOnError="True"></asp:RequiredFieldValidator>
                        <asp:RangeValidator ID="RangeValidator8" runat="server"
                            ControlToValidate="txtMaxFileSize" Display="Dynamic"
                            ErrorMessage="檔案大小不正確，請重新輸入" MaximumValue="2000"
                            meta:resourcekey="RangeValidator8Resource1" MinimumValue="0"
                            SetFocusOnError="True" Type="Integer"></asp:RangeValidator>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableHeader" colspan="2" style="text-align:left">
                        <asp:Label ID="Label81" runat="server" meta:resourcekey="Label81Resource1"
                            Text="私人訊息"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD" style="width: 13%; word-break: break-all; white-space:nowrap">
                        <asp:Label ID="Label82" runat="server" meta:resourcekey="Label82Resource1"
                            Text="附件總容量上限"></asp:Label>
                    </td>
                    <td class="PopTableRightTD" style="width: 87%; word-break: break-all">
                        <asp:TextBox ID="txtPriMesAttachSize" runat="server" MaxLength="4"
                            meta:resourcekey="txtPriMesAttachSizeResource1" Width="50px"></asp:TextBox>
                        <asp:Label ID="Label83" runat="server" meta:resourcekey="Label83Resource1"
                            Text="MB(0~2000MB)"></asp:Label>
                        <asp:RangeValidator ID="rvPriMesAttachSize" runat="server"
                            ControlToValidate="txtPriMesAttachSize" ErrorMessage="請輸入介於0~2000之整數"
                            MaximumValue="2000" meta:resourcekey="rvPriMesAttachSizeResource1"
                            MinimumValue="0" Type="Integer"></asp:RangeValidator>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD" style="width: 13%; word-break: break-all; white-space:nowrap">
                        <asp:Label ID="Label84" runat="server" meta:resourcekey="Label84Resource1"
                            Text="強制發送Mail"></asp:Label>
                    </td>
                    <td class="PopTableRightTD" style="width: 87%; word-break: break-all">
                        <asp:CheckBox ID="cbForceMail" runat="server"
                            meta:resourcekey="cbForceMailResource1" Text="當有私人訊息時，系統一律將訊息轉發e-mail" />
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD" style="width: 13%; word-break: break-all; white-space:nowrap">
                        <asp:Label ID="lblAddAccountMsgConversionMail" runat="server"
                            meta:resourcekey="lblAddAccountMsgConversionMailResource1" Text="新增帳號設定"></asp:Label>
                    </td>
                    <td class="PopTableRightTD" style="width: 87%; word-break: break-all">
                        <asp:CheckBox ID="cbxAccountMsgConversionMail" runat="server"
                            meta:resourcekey="cbxAccountMsgConversionMailResource1"
                            Text="新增帳號時，預設私人訊息會轉發e-mail" />
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD" style="width: 13%; word-break: break-all; white-space:nowrap">
                        <asp:Label ID="Label85" runat="server" meta:resourcekey="Label85Resource1"
                            Text="訊息保留期限"></asp:Label>
                    </td>
                    <td class="PopTableRightTD" style="width: 87%; word-break: break-all">
                        <asp:DropDownList ID="ddlMesRetention" runat="server"
                            meta:resourcekey="ddlMesRetentionResource1">
                            <asp:ListItem meta:resourcekey="MesRetentionItem1Resource1" Text="永遠保留"
                                Value="Default"></asp:ListItem>
                            <asp:ListItem meta:resourcekey="MesRetentionItem2Resource1" Text="保留最近半個月"
                                Value="15"></asp:ListItem>
                            <asp:ListItem meta:resourcekey="MesRetentionItem3Resource1" Text="保留最近一個月"
                                Value="30"></asp:ListItem>
                            <asp:ListItem meta:resourcekey="MesRetentionItem4Resource1" Text="保留最近三個月"
                                Value="90"></asp:ListItem>
                            <asp:ListItem meta:resourcekey="MesRetentionItem5Resource1" Text="保留最近六個月"
                                Value="180"></asp:ListItem>
                            <asp:ListItem meta:resourcekey="MesRetentionItem6Resource1" Text="保留最近十二個月"
                                Value="360"></asp:ListItem>
                        </asp:DropDownList>
                        <br />
                        <asp:Label ID="Label86" runat="server" CssClass="SizeMemo"
                            meta:resourcekey="Label86Resource1"
                            Text="*系統會自動清除所有&amp;quot未歸檔&amp;quot且超過期限的私人訊息&lt;br/&gt;*過多的訊息會影響系統效能，建議最多保留最近一個月訊息&lt;br /&gt;*清除的訊息無法還原，請通知使用者的私人訊息保留的政策"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableHeader" colspan="2" style="text-align:left">
                        <asp:Label ID="Label74" runat="server" meta:resourcekey="Label74Resource1"
                            Text="電子簽核"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD" style="width: 13%; word-break: break-all; white-space:nowrap">
                        <asp:Label ID="Label75" runat="server" meta:resourcekey="Label75Resource1"
                            Text="表單列印預設底圖"></asp:Label>
                    </td>
                    <td class="PopTableRightTD" style="width: 87%; word-break: break-all">                                                
                        <uc2:UC_FileCenter runat="server" ID="UC_FileCenter_FormBackground" AllowedMultipleFileSelection="false" AllowedFileType="Image" />
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD" style="width: 13%; word-break: break-all; white-space:nowrap">
                        <asp:Label ID="Label92" runat="server" meta:resourcekey="Label92Resource1"
                            Text="表單通知寄件者設定"></asp:Label>
                    </td>
                    <td class="PopTableRightTD" style="width: 87%; word-break: break-all">
                        <table>
                            <tr>
                                <td style=" white-space:nowrap; text-align:right">
                                    <asp:Label ID="Label98" runat="server" meta:resourcekey="Label98Resource1"
                                        Text="簽核中"></asp:Label>
                                </td>
                                <td>
                                    <asp:RadioButtonList ID="rbSign" runat="server"
                                        meta:resourcekey="rbSignResource1" RepeatColumns="2">
                                        <asp:ListItem meta:resourcekey="rbSignListItemResource1" Selected="True"
                                            Text="申請者" Value="Applicant"></asp:ListItem>
                                        <asp:ListItem meta:resourcekey="rbSignListItemResource2" Text="簽核者"
                                            Value="Signer"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align:right; white-space:nowrap">
                                    <asp:Label ID="Label102" runat="server" meta:resourcekey="Label102Resource1"
                                        Text="結案"></asp:Label>
                                </td>
                                <td>
                                    <asp:RadioButtonList ID="rbEndTask" runat="server"
                                        meta:resourcekey="rbEndTaskResource1" RepeatColumns="2">
                                        <asp:ListItem meta:resourcekey="rbEndTaskListItemResource1" Selected="True"
                                            Text="申請者" Value="Applicant"></asp:ListItem>
                                        <asp:ListItem meta:resourcekey="rbEndTaskListItemResource2" Text="簽核者"
                                            Value="Signer"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                        </table>
                        <asp:Label ID="Label103" runat="server" CssClass="SizeMemo"
                            meta:resourcekey="lLabel103Resource1" Text="*下述訊息通知不適用此設定:"></asp:Label>
                        <br />
                        <asp:Label ID="Label107" runat="server" CssClass="SizeMemo"
                            meta:resourcekey="lLabel107Resource1"
                            Text="跟催通知、徵詢通知、代填寫通知、作廢通知、解除鎖定通知、結案復原通知、表單變更審核結果通知:寄件者為當時使用者。"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD" style="width: 13%; word-break: break-all; white-space:nowrap">
                        <asp:Label ID="Label1234" runat="server" ForeColor="Red"
                            meta:resourcekey="Label1234Resource1" Text="*"></asp:Label>
                        <asp:Label ID="lblWindowSize" runat="server"
                            meta:resourcekey="lblWindowSizeResource2" Text="表單視窗大小"></asp:Label>
                    </td>
                    <td class="PopTableRightTD" style="width: 87%; word-break: break-all">
                        <table>
                            <tr>
                                <td>
                                    <asp:Label ID="lblHorizontalSize" runat="server"
                                        meta:resourcekey="lblHorizontalSizeResource2" Text="寬度"></asp:Label>
                                </td>
                                <td>
                                    <asp:TextBox ID="wneHorizontalSize" runat="server" MaxLength="4"
                                        meta:resourcekey="wneHorizontalSizeResource2" Width="50px"></asp:TextBox>
                                </td>
                                <td>
                                    <asp:Label ID="lblpix1" runat="server" meta:resourcekey="lblpix1Resource2"
                                        Text="px(1024~1920px)"></asp:Label>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator20" runat="server"
                                        ControlToValidate="wneHorizontalSize" Display="Dynamic" ErrorMessage="不允許空白"
                                        meta:resourcekey="RequiredFieldValidator20Resource1"></asp:RequiredFieldValidator>
                                    <asp:RangeValidator ID="rvPix1" runat="server"
                                        ControlToValidate="wneHorizontalSize" Display="Dynamic" ErrorMessage="只允許輸入數字(1024~1920)"
                                        MaximumValue="1920" meta:resourcekey="rvPix1Resource2" MinimumValue="1024"
                                        Type="Integer"></asp:RangeValidator>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="lblVerticalSize" runat="server"
                                        meta:resourcekey="lblVerticalSizeResource2" Text="高度"></asp:Label>
                                </td>
                                <td>
                                    <asp:TextBox ID="wneVerticalSize" runat="server" MaxLength="4"
                                        meta:resourcekey="wneVerticalSizeResource2" Width="50px"></asp:TextBox>
                                </td>
                                <td>
                                    <asp:Label ID="lblpix2" runat="server" meta:resourcekey="lblpix2Resource2"
                                        Text="px(768~1080px)"></asp:Label>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator21" runat="server"
                                        ControlToValidate="wneVerticalSize" Display="Dynamic" ErrorMessage="不允許空白"
                                        meta:resourcekey="RequiredFieldValidator21Resource1"></asp:RequiredFieldValidator>
                                    <asp:RangeValidator ID="rvPix2" runat="server"
                                        ControlToValidate="wneVerticalSize" Display="Dynamic" ErrorMessage="只允許輸入數字(768~1080)"
                                        MaximumValue="1080" meta:resourcekey="rvPix2Resource2" MinimumValue="768"
                                        Type="Integer"></asp:RangeValidator>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableHeader" colspan="2" style=" white-space:nowrap; text-align:left">
                        <asp:Label ID="lbLeftCapacity" runat="server"
                            meta:resourcekey="lbLeftCapacityResource1" Text="公事包容量(請先維護職級)"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD" style="width: 13%; word-break: break-all; white-space:nowrap">
                        <asp:Label ID="lbLeftByTitle" runat="server"
                            meta:resourcekey="lbLeftByTitleResource1" Text="各職級(MB)"></asp:Label>
                    </td>
                    <td class="PopTableRightTD" style="width: 87%; word-break: break-all">
                        <asp:Repeater ID="Repeater1" runat="server" DataSourceID="ObjectDataSource1"
                            OnItemDataBound="Repeater1_ItemDataBound">
                            <FooterTemplate>
                                </table>
                            </FooterTemplate>
                            <HeaderTemplate>
                                <table border="0" class="Grid">
                                    <tr class="GridHeader">
                                        <th>
                                            <asp:Label ID="lblJobTitle1" runat="server"
                                                meta:resourceKey="lblJobTitle1Resource1" Text="職級名稱"></asp:Label>
                                        </th>
                                        <th>
                                            <asp:Label ID="lblCapacity1" runat="server"
                                                meta:resourceKey="lblCapacity1Resource1" Text="容量設定"></asp:Label>
                                        </th>
                                        <th>
                                            <asp:Label ID="lblJobTitle2" runat="server"
                                                meta:resourceKey="lblJobTitle2Resource1" Text="職級名稱"></asp:Label>
                                        </th>
                                        <th>
                                            <asp:Label ID="lblCapacity2" runat="server"
                                                meta:resourceKey="lblCapacity2Resource1" Text="容量設定"></asp:Label>
                                        </th>
                                        <th>
                                            <asp:Label ID="lblJobTitle3" runat="server"
                                                meta:resourceKey="lblJobTitle3Resource1" Text="職級名稱"></asp:Label>
                                        </th>
                                        <th>
                                            <asp:Label ID="lblCapacity3" runat="server"
                                                meta:resourceKey="lblCapacity3Resource1" Text="容量設定"></asp:Label>
                                        </th>
                                    </tr>
                                    <tr class="GridItem">
                            </HeaderTemplate>
                            <ItemTemplate>
                                <td>
                                    <asp:Label ID="lbJobTitleID" runat="server"
                                        meta:resourceKey="lbJobTitleIDResource1" Text='<%# Eval("TITLE_ID") %>'
                                        Visible="False"></asp:Label>
                                    <asp:Label ID="lbJobTitleName" runat="server"
                                        meta:resourceKey="lbJobTitleNameResource1" Text='<%# Eval("TITLE_NAME") %>'></asp:Label>
                                </td>
                                <td>
                                    <asp:TextBox ID="txbCap" runat="server" MaxLength="4"
                                        meta:resourceKey="txbCapResource1" Text='<%# Eval("MAX_FILE_SIZE") %>'
                                        Width="50px"></asp:TextBox>
                                    <asp:Label ID="Label1" runat="server" meta:resourceKey="Label1Resource1"
                                        Text="MB"></asp:Label>
                                    (0~2000MB)<br />
                                    <asp:RangeValidator ID="RangeValidator1" runat="server"
                                        ControlToValidate="txbCap" Display="Dynamic" ErrorMessage="容量設定不正確,請重新輸入"
                                        MaximumValue="2000" meta:resourceKey="RangeValidator1Resource1"
                                        MinimumValue="0" Type="Integer"></asp:RangeValidator>
                                </td>
                            </ItemTemplate>
                            <SeparatorTemplate>
                                <asp:Literal ID="liTr" runat="server" meta:resourceKey="liTrResource1"></asp:Literal>
                            </SeparatorTemplate>
                        </asp:Repeater>
                        <asp:ObjectDataSource ID="ObjectDataSource1" runat="server"
                            SelectMethod="Query" TypeName="Ede.Uof.EIP.Organization.TitleUCO"></asp:ObjectDataSource>
                    </td>
                </tr>
                <asp:Panel runat="server" ID="dutyModel" Visible="False" meta:resourcekey="dutyModelResource1">
                <tr>
                    <td class="PopTableHeader" colspan="2">
                        <asp:Label ID="Label58" runat="server" meta:resourcekey="Label58Resource1"
                            Text="差勤模組"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD" style="width: 13%; word-break: break-all; white-space:nowrap"></td>
                    <td class="PopTableRightTD" style="width: 87%; word-break: break-all">
                        <asp:CheckBox ID="ckDutyEnable" runat="server"
                            meta:resourcekey="ckDutyEnableResource1" Text="啟用差勤" />
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD" style="width: 13%; word-break: break-all; white-space:nowrap">
                        <asp:Label ID="Label59" runat="server" meta:resourcekey="Label59Resource1"
                            Text="年休日數起算基準日"></asp:Label>
                    </td>
                    <td class="PopTableRightTD" style="width: 87%; word-break: break-all">
                        <table>
                            <tr>
                                <td>
                                    <asp:RadioButton ID="rbArrive" runat="server" Checked="True" GroupName="Basis"
                                        meta:resourcekey="rbArriveResource1" />
                                    <asp:Label ID="Label60" runat="server" meta:resourcekey="Label60Resource1"
                                        Text="到職日"></asp:Label>
                                </td>
                                <td></td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:RadioButton ID="rbDate" runat="server" GroupName="Basis" meta:resourcekey="rbDateResource1" />
                                    <asp:Label ID="Label61" runat="server" meta:resourcekey="Label61Resource1" Text="基準日期"></asp:Label>
                                </td>
                                <td>
                                    <asp:UpdatePanel ID="UpdatePanel5" runat="server">
                                        <ContentTemplate>
                                            <asp:DropDownList ID="ddlMonth" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlMonth_SelectedIndexChanged" meta:resourcekey="ddlMonthResource1"></asp:DropDownList>
                                            <asp:DropDownList ID="ddlDay" runat="server" meta:resourcekey="ddlDayResource1"></asp:DropDownList>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD" style="width: 13%; word-break: break-all; white-space:nowrap">
                        <asp:Label ID="lblNProcesserTitle" runat="server" meta:resourcekey="lblNProcesserTitleMsgResource1" Text="不結算統計人員設定"></asp:Label>
                    </td>
                    <td class="PopTableRightTD" style="width: 87%; word-break: break-all">
                        <uc2:UC_ChoiceList ID="ucNotProcesserUser" runat="server" ExpandToUser="False" ShowMember="False" />
                        <asp:Label ID="lblNotProcesserUser" runat="server" CssClass="SizeMemo"
                            meta:resourcekey="lblNotProcesserUserMsgResource1" Text="選取人員完全不進行差勤結算統計"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD" style="width: 13%; word-break: break-all; white-space:nowrap">
                        <asp:Label ID="Label63" runat="server" meta:resourcekey="Label63Resource1"
                            Text="特殊人員設定" Visible="False"></asp:Label>
                        <asp:Label ID="lblSPTitle" runat="server"
                            meta:resourcekey="lblSPTitleMsgResource1" Text="免刷卡人員設定"></asp:Label>
                    </td>
                    <td class="PopTableRightTD" style="width: 87%; word-break: break-all">
                        <uc2:UC_ChoiceList ID="ucSpecialUser" runat="server" ExpandToUser="False" ShowMember="False" />
                        <asp:Label ID="lblSpecialUser" runat="server" CssClass="SizeMemo"
                            meta:resourcekey="lblSpecialUserMsgResource1"
                            Text="選取人員(如不包含在不結算統計人員內)會進行結算統計但不會處理刷卡相關資料(不會遲到或曠職)"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD" style="width: 13%; word-break: break-all; white-space:nowrap">
                        <asp:Label ID="lblDutyEnable" runat="server"
                            meta:resourcekey="lblDutyEnableResource1" Text="結算控制"></asp:Label>
                    </td>
                    <td class="PopTableRightTD" style="width: 87%; word-break: break-all">
                        <table>
                            <tr>
                                <td style="white-space:nowrap">
                                    <asp:Label ID="Label64" runat="server" meta:resourcekey="Label64Resource1"
                                        Text="結算截止日"></asp:Label>
                                </td>
                                <td>
                                    <telerik:RadNumericTextBox ID="rnDutyAdvanceDays" Width="40px" MinValue="1"
                                        MaxValue="10" runat="server" DataType="System.Decimal" Culture="zh-TW"
                                        DbValueFactor="1" LabelCssClass="" LabelWidth="64px"
                                        meta:resourcekey="rnDutyAdvanceDaysResource1">
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
                                    <asp:Label ID="Label65" runat="server" meta:resourcekey="Label65Resource1"
                                        Text="天前(1~10)"></asp:Label>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD" style="width: 13%; word-break: break-all; white-space:nowrap">
                        <asp:Label ID="Label120" runat="server" meta:resourcekey="Label66Resource2"
                            Text="批次設定代理人"></asp:Label>
                    </td>
                    <td class="PopTableRightTD" style="width: 87%; word-break: break-all">
                        <asp:CheckBox ID="chbEnableAgent" runat="server"
                            meta:resourcekey="chbEnableAgentResource1" Text="是否開放給使用者修改" />
                        <asp:Label ID="lblDutyAgentMsg" runat="server" CssClass="SizeMemo"
                            meta:resourcekey="lblDutyAgentMsgResource1" Text="*此功能為避免使用者自行修改管理者所設定的代理人"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD" style="width: 13%; word-break: break-all; white-space:nowrap">
                        <asp:Label ID="lblTimeOff" runat="server"
                            meta:resourcekey="lblTimeOffResource1" Text="補休假可用期限"></asp:Label>
                    </td>
                    <td class="PopTableRightTD" style="width: 87%; word-break: break-all">
                        <table style="text-align:left;">
                            <tr>
                                <td>
                                    <asp:RadioButton ID="rbTimeOffdays" runat="server" GroupName="rbTimeOffSelect" meta:resourcekey="rbTimeOffdaysResource1" />                                    
                                </td>
                                <td>
                                    <asp:Label ID="lblTimeOffAfter" runat="server"
                                        meta:resourcekey="lblTimeOffAfterResource1" Text="加班日起"></asp:Label>
                                </td>
                                <td>
                                    <telerik:RadNumericTextBox ID="rnTimeOff" MaxLength="4" MinValue="0" MaxValue="9999"
                                        Width="40px" runat="server" DataType="System.Decimal" Culture="zh-TW"
                                        DbValueFactor="1" LabelCssClass="" LabelWidth="64px"
                                        meta:resourcekey="rnTimeOffResource1">
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
                                <td style="text-align:left">
                                    <asp:Label ID="lblTimeOffDay" runat="server" 
                                        meta:resourcekey="lblTimeOffDayResource1" Text="天"></asp:Label>
                                </td>
                            </tr>
                            </table>
                            <table style="text-align:left;">
                            <tr>
                                <td>
                                    <asp:RadioButton ID="rbTimeOffdate" runat="server" GroupName="rbTimeOffSelect" meta:resourcekey="rbTimeOffdateResource1" />                                    
                                </td> 
                                <td>
                                    <asp:Label ID="lblTimeOffEnd" runat="server" Text="截止日" meta:resourcekey="lblTimeOffEndResource1"></asp:Label>
                                </td>
                                <td >
                                    <asp:UpdatePanel ID="UpdatePanel13" runat="server">
                                        <ContentTemplate>
                                            <asp:DropDownList ID="ddlTimeOffMonth" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlTimeOffMonth_SelectedIndexChanged" meta:resourcekey="ddlTimeOffMonthResource1"></asp:DropDownList>
                                            <asp:DropDownList ID="ddlTimeOffDay" runat="server" meta:resourcekey="ddlTimeOffDayResource1"></asp:DropDownList>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD" style="width: 13%; word-break: break-all; white-space:nowrap">
                        <asp:Label ID="lblPunchBuffer" runat="server"
                            meta:resourcekey="lblPunchBufferResource1" Text="刷卡歸屬日判斷Buffer"></asp:Label>
                    </td>
                    <td class="PopTableRightTD" style="width: 87%; word-break: break-all">
                        <table>
                            <tr>
                                <td>
                                    <asp:Label ID="lblBufferBefore" runat="server"
                                        meta:resourcekey="lblBufferBeforeResource1" Text="上班前"></asp:Label>
                                </td>
                                <td>
                                    <telerik:RadNumericTextBox ID="rnBufferBefore" MaxLength="1" MinValue="0" MaxValue="8"
                                        Width="40px" runat="server" DataType="System.Decimal" Culture="zh-TW"
                                        DbValueFactor="1" LabelCssClass="" LabelWidth="64px"
                                        meta:resourcekey="rnBufferBeforeResource1">
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
                                <td>
                                    <asp:Label ID="lblBufferUnit" runat="server"
                                        meta:resourcekey="lblBufferUnitResource1" Text="小時"></asp:Label>
                                </td>
                                <td style="width: 6%; text-align: center">;</td>
                                <td>
                                    <asp:Label ID="lblBufferAfter" runat="server"
                                        meta:resourcekey="lblBufferAfterResource1" Text="下班後"></asp:Label>
                                </td>
                                <td>
                                    <telerik:RadNumericTextBox ID="rnBufferAfter" MaxLength="1" MinValue="0" MaxValue="8"
                                        Width="40px" runat="server" DataType="System.Decimal" Culture="zh-TW"
                                        DbValueFactor="1" LabelCssClass="" LabelWidth="64px"
                                        meta:resourcekey="rnBufferAfterResource1">
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
                                <td>
                                    <asp:Label ID="Label128" runat="server"
                                        meta:resourcekey="lblBufferUnitResource1" Text="小時"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblbufferlimit" runat="server" CssClass="SizeMemo" Text="*輸入範圍為0~8，建議值為上班前2小時；下班後4小時" meta:resourcekey="lblbufferlimitResource1"></asp:Label></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD" style="width: 13%; word-break: break-all; white-space: nowrap">
                        <asp:Label ID="lblCalLevRule" runat="server"
                            meta:resourcekey="lblCalLevRuleResource1" Text="請假/出差時數計算規則"></asp:Label>
                    </td>
                    <td class="PopTableRightTD" style="width: 87%; word-break: break-all">
                        <table>
                            <tr>
                                <td>
                                    <asp:RadioButton ID="rbtCalNormal" GroupName="CalLevRule" runat="server" Text="依正常班表時間計算" meta:resourcekey="rbtNormalResource1" /></td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:RadioButton ID="rbtCalEL" GroupName="CalLevRule" runat="server" Text="依彈性班表時間計算" meta:resourcekey="rbtELResource1" /></td>
                                <td>
                                    <asp:Label ID="lblCalLevRuleNote" Visible="False" runat="server" CssClass="SizeMemo" Text="*此設定只適用非跨日申請，跨日申請一律採用班表上下班時間計算" meta:resourcekey="lblCalLevRuleNoteResource1"></asp:Label></td>
                            </tr>

                        </table>

                    </td>
                </tr>
                </asp:Panel>
                <tr>
                    <td class="PopTableHeader" colspan="2">
                        <asp:Label ID="lblCalendarTitle" runat="server"
                            meta:resourcekey="lblCalendarTitleResource1" Text="行事曆"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD" style="width: 13%; word-break: break-all; white-space:nowrap">
                        <asp:Label ID="lblEventIconTitle" runat="server"
                            meta:resourcekey="lblEventIconTitleResource1" Text="私人事件預設圖示"></asp:Label>
                    </td>
                    <td class="PopTableRightTD"
                        style="width: 87%; word-break: break-all; vertical-align: top">
                        <table>
                            <tr>
                                <td style=" white-space:nowrap">
                                    <asp:Label ID="lblNotShowTitle" runat="server"
                                        meta:resourcekey="lblNotShowTitleResource1" Text="不顯示事件"></asp:Label>
                                </td>
                            </tr>
                            <tr>

                                <td>
                                    <table style="width:100%">
                                        <tr>
                                            <td style="white-space:nowrap">
                                                <asp:RadioButton ID="rbDefaultByNotShow" runat="server" GroupName="NotShow"
                                                    meta:resourcekey="rbDefaultByNotShowResource1" />
                                                <asp:Label ID="lblNotShowDefault" runat="server"
                                                    meta:resourcekey="lblNotShowDefaultResource1" Text="系統預設"></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Image ID="imgDefaultByNotShow" runat="server"
                                                    ImageUrl="~/System/Config/Image/NotDisplayIcon.gif"
                                                    meta:resourcekey="imgDefaultByNotShowResource1" />
                                            </td>
                                            <td>
                                                <asp:RadioButton ID="rbCustomByNotShow" runat="server" GroupName="NotShow"
                                                    meta:resourcekey="rbCustomByNotShowResource1" />
                                                <asp:Label ID="lblNotShowCustom" runat="server"
                                                    meta:resourcekey="lblNotShowCustomResource1" Text="自訂"></asp:Label>
                                            </td>
                                            <td style="width: 20px"></td>
                                            <td style=" white-space:nowrap">                                                
                                                <asp:Image ID="imgByNotShow" runat="server" Width="16px" Height="16px" meta:resourcekey="imgByNotShowResource1" />
                                                <uc2:UC_FileCenter runat="server" ID="UC_FileCenterByNotShow" AllowedMultipleFileSelection="false" AllowedFileType="Image" OnClientRemoved="removeByNotShow()" />
                                                <asp:Label ID="Label21" runat="server" CssClass="SizeMemo"
                                                    meta:resourcekey="Label21Resource1" Text="最適圖片大小：16(w)*16(h)"></asp:Label>
                                                <asp:CustomValidator ID="cvNotShowErrorMsg" runat="server"
                                                    ErrorMessage="請上傳不顯示事件的圖示" meta:resourcekey="cvNotShowErrorMsgResource1"
                                                    OnServerValidate="cvNotShowErrorMsg_ServerValidate"></asp:CustomValidator>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD" style="width: 13%; word-break: break-all; white-space:nowrap">
                        <asp:Label ID="lblMeetingRepeatLimitTitle" runat="server"
                            meta:resourcekey="lblMeetingRepeatLimitTitleResource1" Text="週期借用/會議天數限制"></asp:Label>
                    </td>
                    <td class="PopTableRightTD"
                        style="width: 87%; word-break: break-all; vertical-align: top">
                        <asp:UpdatePanel ID="UpdatePanel11" runat="server">
                            <ContentTemplate>
                                <asp:CheckBox ID="chbEnableMeetingRepeat" runat="server" AutoPostBack="True"
                                    meta:resourcekey="chbEnableMeetingRepeatResource1"
                                    OnCheckedChanged="chbEnableMeetingRepeat_CheckedChanged" Text="啟用限制" />
                                <asp:CustomValidator ID="cvCheckMeetingLimit" runat="server" Display="Dynamic"
                                    ErrorMessage="請輸入天數" meta:resourcekey="cvCheckMeetingLimitResource1"
                                    OnServerValidate="cvCheckMeetingLimit_ServerValidate"></asp:CustomValidator>
                                <br />
                                <telerik:RadNumericTextBox ID="rnMeetingRepeatDate" MaxLength="9" MinValue="0"
                                    Width="40px" runat="server" DataType="System.Decimal"
                                    DbValueFactor="1" LabelCssClass="" LabelWidth="64px"
                                    meta:resourcekey="rnMeetingRepeatDateResource1" Culture="zh-TW">
                                    <NegativeStyle Resize="None" />
                                    <NumberFormat DecimalDigits="0" ZeroPattern="n" />

                                    <EmptyMessageStyle Resize="None" />
                                    <ReadOnlyStyle Resize="None" />
                                    <FocusedStyle Resize="None" />
                                    <DisabledStyle Resize="None" />
                                    <InvalidStyle Resize="None" />
                                    <HoveredStyle Resize="None" />
                                    <EnabledStyle Resize="None" />

                                </telerik:RadNumericTextBox>
                                <asp:Label ID="lblMeetingMsg1" runat="server"
                                    meta:resourcekey="lblMeetingMsg1Resource1" Text="天"></asp:Label>
                                <br />
                                <asp:Label ID="lblMeetingMsg3" runat="server" CssClass="SizeMemo"
                                    meta:resourcekey="lblMeetingMsg3Resource1" Text="*新增週期借用/會議時只允許新增限制天數內的借用/會議"></asp:Label>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableHeader" colspan="2">
                        <asp:Label ID="Label108" runat="server" meta:resourcekey="Label108Resource1"
                            Text="其他"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD" style="width: 13%; word-break: break-all;white-space:nowrap">
                        <asp:Label ID="Label109" runat="server" meta:resourcekey="Label109Resource1"
                            Text="聊天室對話保留期限"></asp:Label>
                    </td>
                    <td class="PopTableRightTD"
                        style="width: 87%; word-break: break-all; vertical-align: top">
                        <telerik:RadNumericTextBox ID="rnChatReserveDay" MaxLength="3" MinValue="1"
                            Width="40px" runat="server" DataType="System.Decimal"
                            DbValueFactor="1" LabelCssClass="" LabelWidth="64px"
                            meta:resourcekey="rnChatReserveDayResource1" Culture="zh-TW">
                            <NegativeStyle Resize="None" />
                            <NumberFormat DecimalDigits="0" ZeroPattern="n" />                            
                            <ClientEvents OnValueChanging="ReserveDayChanging" />
                            <EmptyMessageStyle Resize="None" />
                            <ReadOnlyStyle Resize="None" />
                            <FocusedStyle Resize="None" />
                            <DisabledStyle Resize="None" />
                            <InvalidStyle Resize="None" />
                            <HoveredStyle Resize="None" />
                            <EnabledStyle Resize="None" />

                        </telerik:RadNumericTextBox>
                        <asp:Label ID="Label110" runat="server" meta:resourcekey="Label110Resource1"
                            Text="天"></asp:Label>                        
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD" colspan="2" style="text-align:right">
                        <table border="0" style="width:100%">
                            <tr>
                                <td style="width: 45%;text-align:right"></td>
                                <td style="width: 13%; text-align:center">
                                    <telerik:RadButton ID="rbtnSave3" OnClientClicked="btnSave_Click"
                                        runat="server" Text="儲存" OnClick="rbtnSave3_Click"
                                        meta:resourcekey="rbtnSave3Resource1">
                                    </telerik:RadButton>
                                </td>
                                <td style="width: 45%"></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </telerik:RadPageView>
        <telerik:RadPageView ID="CommSet" runat="server"
            meta:resourcekey="CommSetResource1">
            <table border="0" class="PopTable" style="width:100%">
                <tr>
                    <td colspan="2" class="PopTableHeader" style="text-align:left">
                        <asp:Label ID="lblSIPConfig" runat="server" Text="網路電話" meta:resourcekey="lblSIPConfigResource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 13%; word-break: break-all; white-space:nowrap" class="PopTableLeftTD">
                        <asp:Label ID="lblSIPSet" runat="server" Text="組態設定" meta:resourcekey="lblSIPSetResource1"></asp:Label>
                    </td>
                    <td style="width: 87%; word-break: break-all; vertical-align: top" class="PopTableRightTD">
                        <asp:UpdatePanel ID="UpdatePanel4" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <table style="width:100%" border="0">
                                    <tr>
                                        <td style="text-align:left">
                                            <asp:CheckBox ID="cbSIPEnabled" runat="server" Text="啟用" AutoPostBack="True" OnCheckedChanged="cbSIPEnabled_CheckedChanged"
                                                meta:resourcekey="cbSIPEnabledResource1" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 6%; white-space:nowrap; text-align:right">
                                            <asp:Label ID="lblDialSetMode" runat="server" Text="建置方式" meta:resourcekey="lblDialSetModeResource1"></asp:Label>
                                        </td>
                                        <td style="text-align:left">
                                            <asp:RadioButtonList ID="rblDialSetMode" runat="server" RepeatDirection="Horizontal"
                                                OnSelectedIndexChanged="rblDialSetMode_SelectedIndexChanged" AutoPostBack="True"
                                                meta:resourcekey="rblDialSetModeResource1">
                                                <asp:ListItem Text="自行建置" Value="2" meta:resourcekey="ListItemResource20"></asp:ListItem>
                                                <asp:ListItem Text="直接連線電信業者" Value="1" meta:resourcekey="ListItemResource21"></asp:ListItem>
                                            </asp:RadioButtonList>
                                            <asp:RequiredFieldValidator ID="rfvDialSetMode" runat="server" Enabled="False" ErrorMessage="請選擇建置方式"
                                                Display="Dynamic" ControlToValidate="rblDialSetMode" meta:resourcekey="rfvDialSetModeResource1"></asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="white-space:nowrap; text-align:right">
                                            <asp:Label ID="lblSIPFront" runat="server" Text="撥號前置碼" meta:resourcekey="lblSIPFrontResource1"></asp:Label>
                                        </td>
                                        <td style="text-align:left">
                                            <asp:TextBox ID="txtSIPFront" runat="server" MaxLength="3" Width="40px" meta:resourcekey="txtSIPFrontResource1"></asp:TextBox><br />
                                            <asp:RequiredFieldValidator ID="rfvSIPFront" runat="server" Enabled="False" ErrorMessage="請輸入撥號前置碼"
                                                Display="Dynamic" ControlToValidate="txtSIPFront" meta:resourcekey="rfvSIPFrontResource1"></asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style=" white-space:nowrap; text-align:right">
                                            <asp:Label ID="lblSIPIP" runat="server" Text="IP(HOST)" meta:resourcekey="lblSIPIPResource1"></asp:Label>
                                        </td>
                                        <td style="text-align:left">
                                            <asp:TextBox ID="txtSIPIP" runat="server" Width="300px" meta:resourcekey="txtSIPIPResource1"></asp:TextBox><br />
                                            <asp:RequiredFieldValidator ID="rfvSIPIP" runat="server" Enabled="False" ErrorMessage="請輸入IP"
                                                Display="Dynamic" ControlToValidate="txtSIPIP" meta:resourcekey="rfvSIPIPResource1"></asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="white-space:nowrap; text-align:right">
                                            <asp:Label ID="lblSIPProtocol" runat="server" Text="通訊協定" meta:resourcekey="lblSIPProtocolResource1"></asp:Label>
                                        </td>
                                        <td style="text-align:left">
                                            <asp:RadioButtonList ID="rblSIPProtocol" runat="server" RepeatDirection="Horizontal"
                                                meta:resourcekey="rblSIPProtocolResource1">
                                                <asp:ListItem Text="TCP" Value="TCP" meta:resourcekey="ListItemResource22"></asp:ListItem>
                                                <asp:ListItem Text="UDP" Value="UDP" meta:resourcekey="ListItemResource23"></asp:ListItem>
                                            </asp:RadioButtonList>
                                            <asp:RequiredFieldValidator ID="rfvSIPProtocol" runat="server" Enabled="False" ErrorMessage="請選擇通訊協定"
                                                Display="Dynamic" ControlToValidate="rblSIPProtocol" meta:resourcekey="rfvSIPProtocolResource1"></asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="white-space:nowrap; text-align:right">
                                            <asp:Label ID="lblSIPPort" runat="server" Text="Port" meta:resourcekey="lblSIPPortResource1"></asp:Label>
                                        </td>
                                        <td style="text-align:left">
                                            <asp:TextBox ID="txtSIPPort" runat="server" Width="80px" meta:resourcekey="txtSIPPortResource1"></asp:TextBox><br />
                                            <asp:RequiredFieldValidator ID="rfvSIPPort" runat="server" Enabled="False" ErrorMessage="請輸入Port"
                                                Display="Dynamic" ControlToValidate="txtSIPPort" meta:resourcekey="rfvSIPPortResource1"></asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="white-space:nowrap; text-align:right">
                                            <asp:Label ID="lblSIPLocal" runat="server" Text="區碼" meta:resourcekey="lblSIPLocalResource1"></asp:Label>
                                        </td>
                                        <td style="text-align:left">
                                            <asp:TextBox ID="txtSIPLocal" runat="server" MaxLength="4" Width="40px" meta:resourcekey="txtSIPLocalResource1"></asp:TextBox><br />
                                            <asp:RequiredFieldValidator ID="rfvSIPLocal" runat="server" Enabled="False" ErrorMessage="請輸入區碼"
                                                Display="Dynamic" ControlToValidate="txtSIPLocal" meta:resourcekey="rfvSIPLocalResource1"></asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" class="PopTableHeader" style="text-align:left">
                        <asp:Label ID="lblWebMailConfig" runat="server" Text="WebMail" meta:resourcekey="lblWebMailConfigResource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 13%; word-break: break-all; white-space:nowrap" class="PopTableLeftTD">
                        <asp:Label ID="lblWebMailEnabled" runat="server" Text="組態設定" meta:resourcekey="lblWebMailEnabledResource1"></asp:Label>
                    </td>
                    <td style="width: 87%; word-break: break-all; vertical-align: top" class="PopTableRightTD">
                        <asp:UpdatePanel ID="UpdatePanel6" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <table style="width:100%" border="0">
                                    <tr>
                                        <td colspan="2">
                                            <asp:CheckBox ID="cbWebMailEnabled" runat="server" Text="啟用眾至WebMail" OnCheckedChanged="cbWebMailEnabled_CheckedChanged"
                                                AutoPostBack="True" meta:resourcekey="cbWebMailEnabledResource1" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 5%; white-space:nowrap; text-align:right">
                                            <asp:Label ID="lblMailServerURL" runat="server" Text="MailServer URL" meta:resourcekey="lblMailServerURLResource1"></asp:Label>
                                        </td>
                                        <td style="text-align:left">
                                            <asp:TextBox ID="txtMailServerURL" runat="server" Width="300px" meta:resourcekey="txtMailServerURLResource1"></asp:TextBox><br />
                                            <asp:RequiredFieldValidator ID="rfvMailServerURL" runat="server" Enabled="False"
                                                ErrorMessage="請輸入MailServer URL" Display="Dynamic" ControlToValidate="txtMailServerURL"
                                                meta:resourcekey="rfvMailServerURLResource1"></asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr style="text-align:right">
                                        <td style="white-space:nowrap; text-align:right">
                                            <asp:Label ID="lblMailDomain" runat="server" Text="MailServer Domain" meta:resourcekey="lblMailDomainResource1"></asp:Label>
                                        </td>
                                        <td style="text-align:left">
                                            <asp:TextBox ID="txtMailDomain" runat="server" Width="300px" meta:resourcekey="txtMailDomainResource1"></asp:TextBox><br />
                                            <asp:RequiredFieldValidator ID="rfvMailDomain" runat="server" Enabled="False" ErrorMessage="請輸入MailServer Domain"
                                                Display="Dynamic" ControlToValidate="txtMailDomain" meta:resourcekey="rfvMailDomainResource1"></asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <asp:CheckBox ID="cbOpenfindEnabled" runat="server" Text="啟用網擎WebMail"
                                                AutoPostBack="True" OnCheckedChanged="cbOpenfindEnabled_CheckedChanged" meta:resourcekey="cbOpenfindEnabledResource1" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 5%; white-space:nowrap; text-align:right">
                                            <asp:Label ID="lblOpenfindURL" runat="server" Text="MailServer URL" meta:resourcekey="lblOpenfindURLResource1"></asp:Label>
                                        </td>
                                        <td style="text-align:left">
                                            <asp:TextBox ID="txtOpenfindMailServerURL" runat="server" Width="300px"
                                                meta:resourcekey="txtOpenfindMailServerURLResource1"></asp:TextBox><br />
                                            <asp:RequiredFieldValidator ID="rfvOpenfindURL" runat="server" Enabled="False"
                                                ErrorMessage="請輸入MailServer URL" Display="Dynamic" ControlToValidate="txtOpenfindMailServerURL"
                                                meta:resourcekey="rfvOpenfindURLResource1"></asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
                <tr style="display:none">
                    <td colspan="2" class="PopTableHeader" style="text-align:left">
                        <asp:Label ID="lblLiveMeetingTitle" runat="server" Text="線上會議" meta:resourcekey="lblLiveMeetingTitleResource1"></asp:Label>
                    </td>
                </tr>
                <tr style="display:none">
                    <td style="width: 13%; word-break: break-all; white-space:nowrap" class="PopTableLeftTD">
                        <asp:Label ID="lblEnableKokoMeeting" runat="server" Text="啟用線上會議" meta:resourcekey="lblEnableKokoMeetingResource1"></asp:Label>
                    </td>
                    <td style="width: 87%; word-break: break-all" class="PopTableRightTD">
                        <asp:CheckBox ID="cbEnableKokoMeeting" runat="server" meta:resourcekey="cbEnableKokoMeetingResource1" />
                    </td>
                </tr>
                <tr style="display:none">
                    <td style="width: 13%; word-break: break-all; white-space:nowrap" class="PopTableLeftTD">
                        <asp:Label ID="lblServerPath" runat="server" Text="伺服器位置" meta:resourcekey="lblServerPathResource1"></asp:Label>
                    </td>
                    <td style="width: 87%; word-break: break-all" class="PopTableRightTD">
                        <asp:TextBox ID="txtServerPath" runat="server" MaxLength="255" Width="300px" meta:resourcekey="txtServerPathResource1"></asp:TextBox>
                        <br />
                        <asp:Label ID="lblSetKokoMeetingDescription1" runat="server" CssClass="SizeMemo" Text="請輸入Meeting Server位置"
                            meta:resourcekey="lblSetKokoMeetingDescription1Resource1"></asp:Label>
                        <br />
                        <asp:Label ID="lblSetKokoMeetingDescription2" runat="server" CssClass="SizeMemo" Text="範例:http://meeting.uof.tw"
                            meta:resourcekey="lblSetKokoMeetingDescription2Resource1"></asp:Label>
                    </td>
                </tr>
                <tr style="display:none">
                    <td style="width: 13%; word-break: break-all; white-space:nowrap" class="PopTableLeftTD">
                        <asp:Label ID="lblAccount" runat="server" Text="Meeting帳號" meta:resourcekey="lblAccountResource1"></asp:Label>
                    </td>
                    <td style="width: 87%; word-break: break-all" class="PopTableRightTD">
                        <asp:TextBox ID="txtAccount" runat="server" MaxLength="50" Width="155px" meta:resourcekey="txtAccountResource1"></asp:TextBox><asp:RequiredFieldValidator
                            ID="RequiredFieldValidator15" runat="server" ControlToValidate="txtAccount" ErrorMessage="不允許空白"
                            Visible="False" meta:resourcekey="RequiredFieldValidator15Resource1"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr style="display:none">
                    <td style="width: 13%; word-break: break-all; white-space:nowrap" class="PopTableLeftTD">
                        <asp:Label ID="lblPwd" runat="server" Text="Meeting密碼" meta:resourcekey="lblPwdResource1"></asp:Label>
                    </td>
                    <td style="width: 87%; word-break: break-all" class="PopTableRightTD">
                        <asp:TextBox ID="txtPwd" runat="server" TextMode="Password" MaxLength="50" Width="155px"
                            meta:resourcekey="txtPwdResource1"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" class="PopTableHeader" style="text-align:left">
                        <asp:Label ID="Label133" runat="server" Text="行動裝置" meta:resourcekey="Label133Resource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 13%; word-break: break-all; white-space:nowrap" class="PopTableLeftTD">
                        <asp:Label ID="Label135" runat="server" Text="推播設定" meta:resourcekey="Label135Resource1"></asp:Label>
                    </td>
                    <td style="width: 87%; word-break: break-all; vertical-align: top" class="PopTableRightTD">
                        <asp:UpdatePanel ID="UpdatePanel12" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <table style="width:100%" border="0">
                                    <tr>
                                        <td colspan="2">
                                            <asp:CheckBox ID="cbPushCenter" runat="server" Text="啟用Push Center" OnCheckedChanged="cbPushCenter_CheckedChanged" AutoPostBack="True" Height="100%" meta:resourcekey="cbPushCenterResource1" />
                                            <telerik:RadButton ID="btnRegister" runat="server" Text="註冊" Visible="False" Height="100%" OnClick="btnRegister_Click" BackColor="Blue" meta:resourcekey="btnRegisterResource1"></telerik:RadButton>
                                            <asp:Label ID="lblLicenseInvalid" runat="server" Text="非正式版UOF，註冊失敗。" ForeColor="Red" Visible="False" meta:resourcekey="lblLicenseInvalidResource1"></asp:Label>
                                            <asp:Label ID="lblRegisterOK" runat="server" Text="註冊成功" Visible="False" ForeColor="Red" meta:resourcekey="lblRegisterOKResource1"></asp:Label>
                                            <asp:Label ID="lblRegisterFail" runat="server" ForeColor="Red" meta:resourcekey="lblRegisterFailResource1"></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
                <tr style="display:none">
                    <td colspan="2" class="PopTableHeader" style="text-align:left">
                        <asp:Label ID="lblOnlineTitle" runat="server" Text="線上服務" meta:resourcekey="lblOnlineTitleResource1"></asp:Label>
                    </td>
                </tr>
                <tr style="display:none">
                    <td style="width: 13%; word-break: break-all; white-space:nowrap" class="PopTableLeftTD">
                        <asp:Label ID="lblLymacConfigTitle" runat="server" Text="來嘛通組態設定" meta:resourcekey="lblLymacConfigTitleResource1"></asp:Label>
                    </td>
                    <td style="width: 87%; word-break: break-all" class="PopTableRightTD">
                        <asp:UpdatePanel ID="UpdatePanel10" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <table style="width:100%" border="0">
                                    <tr>
                                        <td colspan="2">
                                            <asp:CheckBox ID="cbLymaEnable" runat="server" Text="啟用"
                                                AutoPostBack="True" meta:resourcekey="cbLymaEnableResource1" />
                                            <asp:Label ID="lblLymaMsg" runat="server" Text="*取消此勾選，請記得把線上服務WebPart關閉。" CssClass="SizeMemo" meta:resourcekey="lblLymaMsg"></asp:Label>
                                            <br />
                                            <table style="width:100%">
                                                <tr>
                                                    <td>
                                                        <telerik:RadToolBar ID="RadToolBarLyma" runat="server" Width="100%"
                                                            OnButtonClick="RadToolBar_ButtonClick"
                                                            OnClientButtonClicking="RadToolBar_ButtonClicking"
                                                            meta:resourcekey="RadToolBarLymaResource1" SingleClick="None">
                                                            <Items>
                                                                <telerik:RadToolBarButton runat="server" Value="InsertLymaServer" Text="新增"
                                                                    DisabledImageUrl="~/Common/Images/Icon/icon_m71.png" HoveredImageUrl="~/Common/Images/Icon/icon_m71.png"
                                                                    ImageUrl="~/Common/Images/Icon/icon_m71.png" CheckedImageUrl="~/Common/Images/Icon/icon_m71.png"
                                                                    meta:resourcekey="InsertLymaServerResource1"  >
                                                                </telerik:RadToolBarButton>
                                                                <telerik:RadToolBarButton runat="server" IsSeparator="True"
                                                                    meta:resourcekey="RadToolBarButtonResource4" >
                                                                </telerik:RadToolBarButton>
                                                                <telerik:RadToolBarButton runat="server" Value="DeleteLymaServer" Text="刪除"
                                                                    DisabledImageUrl="~/Common/Images/Icon/icon_m03.png" HoveredImageUrl="~/Common/Images/Icon/icon_m03.png"
                                                                    ImageUrl="~/Common/Images/Icon/icon_m03.png" CheckedImageUrl="~/Common/Images/Icon/icon_m03.png"
                                                                    meta:resourcekey="DeleteLymaServerResource1"  >
                                                                </telerik:RadToolBarButton>
                                                                <telerik:RadToolBarButton runat="server" IsSeparator="True"
                                                                    meta:resourcekey="RadToolBarButtonResource5"  >
                                                                </telerik:RadToolBarButton>
                                                            </Items>
                                                        </telerik:RadToolBar>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <Fast:Grid ID="LymaGrid" runat="server" AllowSorting="True" AutoGenerateCheckBoxColumn="True"
                                                            AutoGenerateColumns="False" DataKeyNames="ONLINE_ID"
                                                            DataKeyOnClientWithCheckBox="False" DefaultSortDirection="Ascending" EnhancePager="True"
                                                            PageSize="5"
                                                            Width="500px" EmptyDataText="沒有資料"
                                                            KeepSelectedRows="False" OnRowDataBound="LymaGrid_RowDataBound"
                                                            OnRowCommand="LymaGrid_RowCommand" meta:resourcekey="LymaGridResource1" CustomDropDownListPage="False" SelectedRowColor="" UnSelectedRowColor=""
                                                              >
                                                            <EnhancePagerSettings
                                                                ShowHeaderPager="True" />
                                                            <ExportExcelSettings AllowExportToExcel="False" />
                                                            <Columns>
                                                                <asp:TemplateField HeaderText="說明" meta:resourcekey="RemarkTemplateFieldResource1">
                                                                    <ItemTemplate>
                                                                        <asp:LinkButton ID="lbtnDirections" runat="server"
                                                                            Text='<%# Eval("DIRECTIONS") %>'
                                                                            meta:resourcekey="lbtnDirectionsResource1"></asp:LinkButton>
                                                                    </ItemTemplate>
                                                                    <HeaderStyle HorizontalAlign="Center" Width="200px" />
                                                                    <ItemStyle HorizontalAlign="Left" Wrap="False" />

                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="便利貼代碼" meta:resourcekey="ScriptTemplateFieldResource1">
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lblMultiSitesName" runat="server"
                                                                            Text='<%# Eval("SCRIPT_CODE") %>'
                                                                            meta:resourcekey="lblMultiSitesNameResource2"></asp:Label>
                                                                    </ItemTemplate>
                                                                    <HeaderStyle HorizontalAlign="Center" Width="200px" />
                                                                    <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                                                </asp:TemplateField>
                                                            </Columns>
                                                        </Fast:Grid>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>

                <tr>
                    <td colspan="2" class="PopTableHeader" style="text-align:left">
                        <asp:Label ID="lblFileScanTitle" runat="server" Text="文件掃描" meta:resourcekey="lblFileScanTitleResource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 13%; word-break: break-all; white-space:nowrap" class="PopTableLeftTD">
                        <asp:Label ID="lblEnableFileScan" runat="server" Text="支援掃描功能" meta:resourcekey="lblEnableFileScanResource1"></asp:Label>
                    </td>
                    <td style="width: 87%; word-break: break-all; vertical-align: top" class="PopTableRightTD">
                                <table style="width:100%" border="0">
                                    <tr>
                                        <td colspan="2">
                                            <asp:CheckBox ID="ckbEnableFileScan" runat="server" Text="啟用" onclick="ControlScanerOCR()"  meta:resourcekey="ckbEnableFileScanResource1" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td >
                                            <uc2:UC_ChoiceList ID="ScanUserList" runat="server" ExpandToUser="False"  />
                                            <asp:Label ID="lblFileScanUserMsg" runat="server" CssClass="SizeMemo"
                                                meta:resourcekey="lblFileScanUserMsgResource1" Text="啟用後選取人員即可在本機安裝支援的設備，直接掃描上傳文件"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr style="height:5px"></tr>
                                </table>
                                    <div id="showFileScanOCR" runat="server">
                                        <asp:CheckBox ID="ckbEnableFileScanOCR" runat="server" Text="支援OCR"  meta:resourcekey="ckbEnableFileScanOCRResource1" />   
                                        <br />
                                        <asp:Label ID="lblFileScanOCRMsg" runat="server" CssClass="SizeMemo"
                                                meta:resourcekey="lblFileScanOCRMsgResource1" Text="選取後掃描文件同步啟用OCR功能，文件內容即可支援龍捲風搜尋(電子簽核、文管、公事包)"></asp:Label>

                                    </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" class="PopTableHeader" style="text-align:left">
                        <asp:Label ID="Label101" runat="server" Text="API" meta:resourceKey="Label101Resource2"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="Label104" runat="server" Text="私鑰設定" meta:resourceKey="Label104Resource2"></asp:Label>
                    </td>
                    <td>
                        <asp:UpdatePanel ID="UpdatePanel18" runat="server">
                            <ContentTemplate>
                                <table style="width:100%">
                                    <tr>
                                        <td>
                                            <telerik:RadToolBar ID="toolbarAPI" runat="server" SingleClick="None" OnButtonClick="toolbarAPI_ButtonClick" OnClientButtonClicking="toolbarAPI_ButtonClicking" Width="100%" meta:resourceKey="toolbarAPIResource1">
                                                <Items>
                                                    <telerik:RadToolBarButton runat="server" Text="新增" Value="NewAPIPrivateKey" 
                                                        DisabledImageUrl="~/Common/Images/Icon/icon_m71.png" HoveredImageUrl="~/Common/Images/Icon/icon_m71.png"
                                                         ImageUrl="~/Common/Images/Icon/icon_m71.png" CheckedImageUrl="~/Common/Images/Icon/icon_m71.png" meta:resourceKey="RadToolBarButtonResource10">
                                                        
                                                    </telerik:RadToolBarButton>
                                                    <telerik:RadToolBarButton runat="server" IsSeparator="True" meta:resourceKey="RadToolBarButtonResource11">
                                                    </telerik:RadToolBarButton>
                                                    <telerik:RadToolBarButton runat="server" Text="刪除" Value="DeleteAPIPrivateKey"
                                                        DisabledImageUrl="~/Common/Images/Icon/icon_m03.png" HoveredImageUrl="~/Common/Images/Icon/icon_m03.png"
                                                        ImageUrl="~/Common/Images/Icon/icon_m03.png" CheckedImageUrl="~/Common/Images/Icon/icon_m03.png" meta:resourceKey="RadToolBarButtonResource12">
                                                    </telerik:RadToolBarButton>
                                                    <telerik:RadToolBarButton runat="server" IsSeparator="True" meta:resourceKey="RadToolBarButtonResource13">
                                                    </telerik:RadToolBarButton>
                                                </Items>
                                            </telerik:RadToolBar>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                             <Fast:Grid ID="gridAPIPrivateKey" runat="server" DataKeyNames="APP_GUID" AllowSorting="True" AutoGenerateCheckBoxColumn="True" AutoGenerateColumns="False" Width="100%"
                                                 CustomDropDownListPage="False" DataKeyOnClientWithCheckBox="False" DefaultSortColumnName="APP_NAME" DefaultSortDirection="Ascending" EmptyDataText="No data found" 
                                                 EnhancePager="True" KeepSelectedRows="False" PageSize="5" SelectedRowColor="" UnSelectedRowColor="" OnRowDataBound="gridAPIPrivateKey_RowDataBound" OnSorting="gridAPIPrivateKey_Sorting" meta:resourceKey="gridAPIPrivateKeyResource1">
                                                 <EnhancePagerSettings ShowHeaderPager="True" FirstAltImageUrl="" FirstImageUrl="" LastAltImage="" LastImageUrl="" NextIAltImageUrl="" NextImageUrl="" PageInfoCssClass="" PageNumberCssClass="" PageNumberCurrentCssClass="" PageRedirectCssClass="" PreviousAltImageUrl="" PreviousImageUrl="" />
                                                 <ExportExcelSettings AllowExportToExcel="False" />                                                 
                                                 <Columns>                                                   
                                                     <asp:TemplateField HeaderText="外部系統代號" meta:resourceKey="TemplateFieldResource11" SortExpression="APP_NAME">
                                                     <ItemTemplate>
                                                        <asp:LinkButton ID="lbtnAPIPrivateKey" runat="server" meta:resourceKey="lbtnAPIPrivateKeyResource1" OnClick="lbtnAPIPrivateKey_Click" Text='<%# Bind("APP_NAME") %>'></asp:LinkButton>
                                                     </ItemTemplate>
                                                    <HeaderStyle Width="10%" Wrap="False"></HeaderStyle>
                                                     </asp:TemplateField>
                                                     <asp:TemplateField HeaderText="私鑰" meta:resourceKey="TemplateFieldResource12"><ItemTemplate>
                                                             <div style="word-break: break-all; width:100%">
                                                                <asp:Label ID="Label1" runat="server" meta:resourceKey="Label1Resource2" Text='<%# Bind("PRIVATE_KEY") %>'></asp:Label>
                                                             </div>
                                                     </ItemTemplate>                                                  
                                                     <HeaderStyle Wrap="False"></HeaderStyle>
                                                      </asp:TemplateField>      
                                                 </Columns>     
                                             </Fast:Grid>
                                        </td>
                                    </tr>
                              </table>
                            </ContentTemplate>
                            
                        </asp:UpdatePanel>
                    </td>
                </tr>
                <asp:Panel runat="server" ID="Enable104HRSetting" meta:resourcekey="Enable104HRSettingResource1">
                <tr>
                    <td colspan="4" class="PopTableHeader" style="text-align:left">
                        <asp:Label ID="lblHR104Head" runat="server" Text="104差勤設定" meta:resourcekey="lblHR104HeadResource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="Label136" runat="server" Text="104差勤" meta:resourcekey="Label136Resource1"></asp:Label>
                    </td>                
                    <td>
                        <asp:CheckBox ID="cbHR104Enable" runat="server" Text="啟用" meta:resourcekey="cbHR104EnableResource1" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="Label132" runat="server" Text="*" ForeColor="Red" meta:resourcekey="Label132Resource1"></asp:Label><asp:Label 
                            ID="lblHR104PunchFolderPath" runat="server" Text="刷卡匯出檔案存放路徑" meta:resourcekey="lblHR104PunchFolderPathResource1"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="txtHR104PunchFolderPath" runat="server" Width="300px" meta:resourcekey="txtHR104PunchFolderPathResource1"></asp:TextBox><br />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator16" runat="server" ErrorMessage="請輸入資料夾路徑" ControlToValidate="txtHR104PunchFolderPath" Display="Dynamic" meta:resourcekey="RequiredFieldValidator16Resource2"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                    <tr>
                        <td>
                            <asp:Label ID="Label137" runat="server" Text="同步AD帳號" meta:resourcekey="Label137Resource1"></asp:Label>
                        </td>
                        <td>
                            <asp:CheckBox ID="cbHR104SyncAD" runat="server" meta:resourcekey="cbHR104SyncADResource1" />
                            <asp:Label ID="Label140" runat="server" Text="人員同步時，同步AD帳號。" meta:resourcekey="Label140Resource1"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="Label138" runat="server" Text="帳號前加上公司別" meta:resourcekey="Label138Resource1"></asp:Label>
                        </td>
                        <td>
                            <asp:CheckBox ID="cbHR104SyncCompany" runat="server" meta:resourcekey="cbHR104SyncCompanyResource1" />
                            <asp:Label ID="Label141" runat="server" Text="人員同步時，帳號前加上公司別。" meta:resourcekey="Label141Resource1"></asp:Label>
                        <br/>
                            <asp:Label ID="Label146" runat="server" CssClass="SizeMemo" Text="例如：TW1A19876，其中TW1為公司別，而A19876為帳號。" meta:resourcekey="Label146Resource1"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="Label142" runat="server" Text="補休假可用期限" meta:resourcekey="Label142Resource1"></asp:Label>
                        </td>
                        <td>
                            <table style="text-align: left;">
                                <tr>
                                    <td>
                                        <asp:RadioButton ID="rbHR104TimeOffdays" runat="server" GroupName="rbHR104TimeOffSelect" meta:resourcekey="rbTimeOffdaysResource1" />
                                    </td>
                                    <td>
                                        <asp:Label ID="Label143" runat="server"
                                            meta:resourcekey="lblTimeOffAfterResource1" Text="加班日起"></asp:Label>
                                    </td>
                                    <td>
                                        <telerik:RadNumericTextBox ID="rnHR104TimeOff" MaxLength="4" MinValue="0" MaxValue="9999"
                                            Width="40px" runat="server" DataType="System.Decimal" Culture="zh-TW"
                                            DbValueFactor="1" LabelCssClass="" LabelWidth="64px"
                                            meta:resourcekey="rnTimeOffResource1">
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
                                        <asp:Label ID="Label144" runat="server"
                                            meta:resourcekey="lblTimeOffDayResource1" Text="天"></asp:Label>
                                    </td>
                                </tr>
                            </table>
                            <table style="text-align: left;">
                                <tr>
                                    <td>
                                        <asp:RadioButton ID="rbHR104TimeOffdate" runat="server" GroupName="rbHR104TimeOffSelect" meta:resourcekey="rbTimeOffdateResource1" />
                                    </td>
                                    <td>
                                        <asp:Label ID="Label145" runat="server" Text="截止日" meta:resourcekey="lblTimeOffEndResource1"></asp:Label>
                                    </td>
                                    <td>
                                        <asp:UpdatePanel ID="UpdatePanel19" runat="server">
                                            <ContentTemplate>
                                                <asp:DropDownList ID="ddlHR104TimeOffMonth" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlHR104TimeOffMonth_SelectedIndexChanged" meta:resourcekey="ddlTimeOffMonthResource1"></asp:DropDownList>
                                                <asp:DropDownList ID="ddlHR104TimeOffDay" runat="server" meta:resourcekey="ddlTimeOffDayResource1"></asp:DropDownList>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="Label151" runat="server" Text="加班單設定" meta:resourcekey="Label151Resource1"></asp:Label>
                        </td>
                        <td>
                            <table>
                                <tr>                                    
                                    <td>
                                        <asp:CheckBox ID="cbHR104ShowPunchCheck" runat="server" meta:resourcekey="cbHR104ShowPunchCheckResource1" />
                                        <asp:Label ID="lblHR104ShowPunchCheck" runat="server" Text="顯示檢查刷卡資料設定" meta:resourcekey="lblHR104ShowPunchCheckResource1"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:CheckBox ID="cbHR104ShowMeat" runat="server" meta:resourcekey="cbHR104ShowMeatResource1" />
                                        <asp:Label ID="lblHR104ShowMeat" runat="server" Text="顯示是否發放誤餐費設定" meta:resourcekey="lblHR104ShowMeatResource1"></asp:Label>
                                    </td>
                                </tr>
                                <tr>                                    
                                    <td>
                                        <asp:CheckBox ID="cbHR104ShowExcludeHours" runat="server" meta:resourcekey="cbHR104ShowExcludeHoursResource1" />
                                        <asp:Label ID="lblHR104ShowExcludeHours" runat="server" Text="顯示扣除時數設定" meta:resourcekey="lblHR104ShowExcludeHoursResource1"></asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>                    
                </asp:Panel>
                <tr>
                    <td colspan="2" class="PopTableLeftTD" style="text-align:center">
                        <table border="0" style="width:100%">
                            <tr>
                                <td style="width: 45%; text-align:right"></td>
                                <td style="width: 13%; text-align:center">
                                    <telerik:RadButton ID="rbtnSave4" OnClientClicked="btnSave_Click"
                                        runat="server" Text="儲存" OnClick="rbtnSave4_Click"
                                        meta:resourcekey="rbtnSave4Resource1">
                                    </telerik:RadButton>
                                </td>
                                <td style="width: 45%"></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </telerik:RadPageView>
        <telerik:RadPageView ID="MultiSitesSet" runat="server"
            meta:resourcekey="MultiSitesSetResource1">
            <table border="0"class="PopTable" style="width:100%">
                <tr>
                    <td colspan="4" class="PopTableHeader" style="text-align:left">
                        <asp:Label ID="Label114" runat="server" Text="多Site支援"
                            meta:resourcekey="Label114Resource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="width: 13%; word-break: break-all; white-space:nowrap" class="PopTableLeftTD">
                        <asp:Label ID="Label111" runat="server" Text="設定" meta:resourcekey="Label111Resource1"></asp:Label>
                    </td>
                    <td style="width: 87%; word-break: break-all" class="PopTableRightTD">
                        <table>
                            <tr>
                                <td>
                                    <asp:CheckBox ID="chkMulitSitesEnable" runat="server" Text="啟用" meta:resourcekey="chkMulitSitesEnableResource1" />
                                    <br />
                                    <asp:UpdatePanel ID="uptPnlMultiSites" runat="server">
                                        <ContentTemplate>
                                            <table style="width:100%">
                                                <tr>
                                                    <td>
                                                        <telerik:RadToolBar ID="RadToolBarMultiSites" runat="server" Width="100%"
                                                            OnButtonClick="RadToolBar_ButtonClick"
                                                            OnClientButtonClicking="RadToolBar_ButtonClicking"
                                                            meta:resourcekey="RadToolBarMultiSitesResource1" SingleClick="None">
                                                            <Items>
                                                                <telerik:RadToolBarButton runat="server" Value="InsertMultiSites" Text="新增"
                                                                    DisabledImageUrl="~/Common/Images/Icon/icon_m71.png" HoveredImageUrl="~/Common/Images/Icon/icon_m71.png"
                                                                    ImageUrl="~/Common/Images/Icon/icon_m71.png"
                                                                    CheckedImageUrl="~/Common/Images/Icon/icon_m71.png" 
                                                                    meta:resourcekey="RadToolBarButtonResource9" >
                                                                </telerik:RadToolBarButton>
                                                                <telerik:RadToolBarButton runat="server" IsSeparator="True"
                                                                    meta:resourcekey="RadToolBarButtonResource6"  >
                                                                </telerik:RadToolBarButton>
                                                                <telerik:RadToolBarButton runat="server" Value="DeleteMultiSites" Text="刪除" meta:resourcekey="TBarButtonResource5"
                                                                    DisabledImageUrl="~/Common/Images/Icon/icon_m03.png" HoveredImageUrl="~/Common/Images/Icon/icon_m03.png"
                                                                    ImageUrl="~/Common/Images/Icon/icon_m03.png"
                                                                    CheckedImageUrl="~/Common/Images/Icon/icon_m03.png" >
                                                                </telerik:RadToolBarButton>
                                                                <telerik:RadToolBarButton runat="server" IsSeparator="True"
                                                                    meta:resourcekey="RadToolBarButtonResource7"  >
                                                                </telerik:RadToolBarButton>
                                                            </Items>
                                                        </telerik:RadToolBar>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <Fast:Grid ID="grdMultiSites" runat="server" AllowSorting="True" AutoGenerateCheckBoxColumn="True"
                                                            AutoGenerateColumns="False" DataKeyNames="MENU_ID"
                                                            DataKeyOnClientWithCheckBox="False" DefaultSortDirection="Ascending" EnhancePager="True"
                                                            PageSize="5"
                                                            Width="100%" EmptyDataText="沒有資料"
                                                            KeepSelectedRows="False"
                                                            OnPageIndexChanging="grdMultiSites_PageIndexChanging"
                                                            OnRowDataBound="grdMultiSites_RowDataBound"
                                                            OnRowCommand="grdMultiSites_RowCommand"
                                                            meta:resourcekey="grdMultiSitesResource1" CustomDropDownListPage="False" SelectedRowColor="" UnSelectedRowColor="" 
                                                             >
                                                            <EnhancePagerSettings
                                                                ShowHeaderPager="True" />
                                                            <ExportExcelSettings AllowExportToExcel="False" />
                                                            <Columns>
                                                                <asp:TemplateField HeaderText="UOF網址" meta:resourcekey="TemplateFieldResource5">
                                                                    <ItemTemplate>
                                                                        <asp:LinkButton ID="lbtnMultiSites" runat="server"
                                                                            Text='<%# Eval("LINK_URL") %>' meta:resourcekey="lbtnMultiSitesResource1"></asp:LinkButton>
                                                                    </ItemTemplate>

                                                                    <HeaderStyle HorizontalAlign="Center" Width="200px" />
                                                                    <ItemStyle HorizontalAlign="Left" Wrap="False" />

                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="顯示名稱"
                                                                    meta:resourcekey="TemplateFieldResource6">
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lblMultiSitesName" runat="server"
                                                                            Text='<%# Eval("DEFAULT_TEXT") %>'
                                                                            meta:resourcekey="lblMultiSitesNameResource1"></asp:Label>
                                                                    </ItemTemplate>

                                                                    <HeaderStyle HorizontalAlign="Center" Width="200px" />
                                                                    <ItemStyle HorizontalAlign="Left" Wrap="False" />

                                                                </asp:TemplateField>
                                                            </Columns>
                                                        </Fast:Grid>
                                                    </td>
                                                </tr>
                                            </table>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                    <br />
                                    <table>
                                        <tr>
                                            <td colspan="2">
                                                <asp:Label ID="lblSecurityDesc" runat="server" Text="加密密鑰" meta:resourcekey="lblSecurityDescResource1"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblMulitSitesKey" runat="server" Text="Key"
                                                    meta:resourcekey="lblMulitSitesKeyResource1"></asp:Label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtMulitSitesKey" runat="server"
                                                    meta:resourcekey="txtMulitSitesKeyResource1"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblMulitSitesIV" runat="server" Text="IV"
                                                    meta:resourcekey="lblMulitSitesIVResource1"></asp:Label>
                                            </td>
                                            <td>
                                                <asp:TextBox ID="txtMulitSitesIV" runat="server"
                                                    meta:resourcekey="txtMulitSitesIVResource1"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <asp:Label ID="lblSecurityRemark" CssClass="SizeMemo" runat="server" Text="以上密鑰提供集團多Site間連結加密使用，如要支援多Site各Site都必須輸入相同的密鑰且不可為空白"
                                                    meta:resourcekey="lblSecurityRemarkResource1"></asp:Label>
                                            </td>
                                        </tr>
                                    </table>
                                    <br />
                                    <asp:CheckBox ID="chkAllowMulitSitesLink" runat="server" Text="允許其他站台連結" meta:resourcekey="chkAllowMulitSitesLinkResource1" />
                                    <br />
                                </td>
                            </tr>

                        </table>
                    </td>
                </tr>
                <tr>
                    <td style="text-align:center" colspan="4" class="PopTableLeftTD">
                        <table style="width:100%" border="0">
                            <tr>
                                <td style="width: 45%; text-align:right"></td>
                                <td style="width: 13%; text-align:center">
                                    <telerik:RadButton ID="rbtSave" OnClientClicked="btnSave_Click" runat="server"
                                        Text="儲存" OnClick="rbtSave_Click" meta:resourcekey="rbtSaveResource1">
                                    </telerik:RadButton>
                                    <asp:Label ID="lblSaveSuccess" runat="server" class="SizeSB" CssClass="SizeMemo" Text="儲存成功" meta:resourcekey="lblSaveSuccessResource1"
                                        Visible="False"></asp:Label>
                                </td>
                                <td style="width: 45%"></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </telerik:RadPageView>
        <telerik:RadPageView ID="Proxy" runat="server"
            meta:resourcekey="ProxyResource2">
            <table border="0" class="PopTable" style="width:100%">
                <tr>
                    <td rowspan="2" style="width: 13%; word-break: break-all; white-space:nowrap" class="PopTableLeftTD">
                        <asp:Label ID="Label66" runat="server" Text="組態設定" meta:resourcekey="lblSIPSetResource1"></asp:Label>
                    </td>
                    <td style="width: 87%; word-break: break-all; vertical-align: top" class="PopTableRightTD">
                        <table style="width:100%" border="0">
                            <tr>
                                <td style="text-align:left">
                                    <asp:CheckBox ID="chkProxy" runat="server" Text="啟用" meta:resourcekey="chkMulitSitesEnableResource1" />
                                    <asp:Label ID="lblEnableProxyMsg" CssClass="SizeMemo" runat="server" Text="沒有Proxy授權,無法啟用" meta:resourcekey="lblEnableProxyMsgResource1"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 5%; white-space:nowrap; text-align:right">
                                    <asp:Label ID="lblProxyErrorCount" runat="server" Text="Proxy錯誤重送次數" meta:resourcekey="lblProxyErrorCountResource1"></asp:Label>
                                </td>
                                <td style="text-align:left">
                                    <asp:TextBox ID="txtProxyErrcount" runat="server" MaxLength="4" Width="40px"
                                        meta:resourcekey="txtProxyErrcountResource1"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvProxyErrCount" runat="server"
                                        ErrorMessage="請輸入次數" Display="Dynamic" ControlToValidate="txtProxyErrcount"
                                        meta:resourcekey="rfvProxyErrCountResource1"></asp:RequiredFieldValidator>
                                    <asp:RangeValidator
                                        ID="RangeValidator10" runat="server" ControlToValidate="txtProxyErrcount" ErrorMessage="只允許輸入數字"
                                        MaximumValue="9999" MinimumValue="0" Type="Integer" Display="Dynamic" meta:resourcekey="RangeValidator9Resource1"></asp:RangeValidator>
                                </td>
                            </tr>
                            <tr>
                                <td style="white-space:nowrap; text-align:right">
                                    <asp:Label ID="lblProxyTfrLogDel" runat="server" Text="Proxy檔案傳輸紀錄幾個月份刪除一次" meta:resourcekey="lblProxyTfrLogDelResource1"></asp:Label>
                                </td>
                                <td style="text-align:left">
                                    <asp:TextBox ID="txtMonths" runat="server" MaxLength="4" Width="40px"
                                        meta:resourcekey="txtMonthsResource1"></asp:TextBox>
                                    <asp:Label ID="Label76" runat="server" Text="個月" meta:resourcekey="Label55Resource1"></asp:Label>
                                    <asp:RequiredFieldValidator ID="rfvProxyTfrLogDel" runat="server"
                                        ErrorMessage="請輸入月份數" Display="Dynamic" ControlToValidate="txtMonths"
                                        meta:resourcekey="rfvProxyTfrLogDelResource1"></asp:RequiredFieldValidator>
                                    <asp:RangeValidator
                                        ID="RangeValidator11" runat="server" ControlToValidate="txtMonths" ErrorMessage="只允許輸入數字"
                                        MaximumValue="9999" MinimumValue="1" Type="Integer" Display="Dynamic" meta:resourcekey="RangeValidator9Resource1"></asp:RangeValidator>
                                </td>
                            </tr>
                            <tr>
                                <td style="white-space:nowrap; text-align:right">
                                    <asp:Label ID="lblProxyFileDel" runat="server" Text="Proxy檔案無人下載時幾個月刪除一次" meta:resourcekey="lblProxyFileDelResource1"></asp:Label>
                                </td>
                                <td style="text-align:left">
                                    <asp:TextBox ID="txtProxyDelMonths" runat="server" MaxLength="4" Width="40px"
                                        meta:resourcekey="txtProxyDelMonthsResource1"></asp:TextBox>
                                    <asp:Label ID="Label113" runat="server" Text="個月" meta:resourcekey="Label55Resource1"></asp:Label>
                                    <asp:RequiredFieldValidator ID="rfvProxyDelMonth" runat="server"
                                        ErrorMessage="請輸入月份數" Display="Dynamic" ControlToValidate="txtProxyDelMonths"
                                        meta:resourcekey="rfvProxyDelMonthResource1"></asp:RequiredFieldValidator>
                                    <asp:RangeValidator
                                        ID="RangeValidator12" runat="server" ControlToValidate="txtProxyDelMonths" ErrorMessage="只允許輸入數字"
                                        MaximumValue="9999" MinimumValue="1" Type="Integer" Display="Dynamic" meta:resourcekey="RangeValidator9Resource1"></asp:RangeValidator>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>

                    <td>
                        <asp:UpdatePanel ID="UpdatePanel8" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <table style="width:100%">
                                    <tr>
                                        <td>

                                            <telerik:RadToolBar ID="RadToolBarProxy" runat="server" Width="100%"
                                                OnButtonClick="RadToolBarProxy_ButtonClick"
                                                OnClientButtonClicking="RadToolBarProxy_ButtonClicking"
                                                meta:resourcekey="RadToolBarProxyResource1" SingleClick="None">
                                                <Items>
                                                    <telerik:RadToolBarButton runat="server" Value="AddProxy" Text="新增" meta:resourcekey="TBarButtonResource4"
                                                        DisabledImageUrl="~/Common/Images/Icon/icon_m71.png" HoveredImageUrl="~/Common/Images/Icon/icon_m71.png"
                                                        ImageUrl="~/Common/Images/Icon/icon_m71.png"
                                                        CheckedImageUrl="~/Common/Images/Icon/icon_m71.png" >
                                                    </telerik:RadToolBarButton>
                                                    <telerik:RadToolBarButton runat="server" IsSeparator="True"
                                                        meta:resourcekey="RadToolBarButtonResource8" >
                                                    </telerik:RadToolBarButton>
                                                </Items>
                                            </telerik:RadToolBar>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: left">

                                            <Fast:Grid ID="GridProxy" runat="server" AllowSorting="True" AutoGenerateCheckBoxColumn="False"
                                                AutoGenerateColumns="False"
                                                DataKeyOnClientWithCheckBox="False" DefaultSortDirection="Ascending" EnhancePager="True"
                                                Width="100%" EmptyDataText="沒有資料" KeepSelectedRows="False"
                                                OnPageIndexChanging="GridProxy_PageIndexChanging" OnRowDataBound="GridProxy_RowDataBound"
                                                OnRowCommand="GridProxy_RowCommand" meta:resourcekey="GridProxyResource1"
                                                PageSize="15" CustomDropDownListPage="False" SelectedRowColor="" UnSelectedRowColor=""   >
                                                <EnhancePagerSettings
                                                    ShowHeaderPager="True" />
                                                <ExportExcelSettings AllowExportToExcel="False" />
                                                <Columns>
                                                    <asp:TemplateField HeaderText="Proxy Name" meta:resourcekey="TemplateFieldResource7">
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="lbtnProxyName" runat="server"
                                                                Text='<%# Eval("NAME") %>' CommandName="update"
                                                                OnClick="lbtnProxyName_Click" meta:resourcekey="lbtnProxyNameResource1"></asp:LinkButton>
                                                        </ItemTemplate>

                                                        <HeaderStyle HorizontalAlign="Center" Width="200px" />
                                                        <ItemStyle HorizontalAlign="Left" Wrap="False" />

                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Proxy URL" meta:resourcekey="TemplateFieldResource8">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblProxyURL" runat="server"
                                                                Text='<%# Eval("URL") %>' meta:resourcekey="lblProxyURLResource1"></asp:Label>
                                                        </ItemTemplate>

                                                        <HeaderStyle HorizontalAlign="Center" Width="200px" />
                                                        <ItemStyle HorizontalAlign="Left" Wrap="False" />

                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="停用" meta:resourcekey="TemplateFieldResource9">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblDisable" runat="server"
                                                                Text='<%# Eval("DISABLE") %>' meta:resourcekey="lblDisableResource1"></asp:Label>
                                                        </ItemTemplate>

                                                        <HeaderStyle HorizontalAlign="Center" Width="200px" />
                                                        <ItemStyle HorizontalAlign="Left" Wrap="False" />

                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="動作" meta:resourcekey="TemplateFieldResource4">
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="lbtnReset" runat="server"
                                                                Text='重設' meta:resourcekey="lbtnResetResource1"></asp:LinkButton>
                                                        </ItemTemplate>

                                                        <HeaderStyle HorizontalAlign="Center" Width="200px" />
                                                        <ItemStyle HorizontalAlign="Left" Wrap="False" />

                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Proxy Index" Visible="False"
                                                        meta:resourcekey="TemplateFieldResource10">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblProxyIndex" runat="server"
                                                                Text='<%# Eval("Index") %>' meta:resourcekey="lblProxyIndexResource1"></asp:Label>
                                                        </ItemTemplate>

                                                        <HeaderStyle HorizontalAlign="Center" Width="200px" />
                                                        <ItemStyle HorizontalAlign="Left" Wrap="False" />

                                                    </asp:TemplateField>
                                                </Columns>
                                            </Fast:Grid>

                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>

                        </asp:UpdatePanel>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" class="PopTableLeftTD" style="text-align:center">
                        <table style="width:100%" border="0">
                            <tr>
                                <td style="width: 45%; text-align:right"></td>
                                <td style="width: 13%; text-align:center">
                                    <telerik:RadButton ID="rbtnSave5" OnClientClicked="btnSave_Click"
                                        runat="server" Text="儲存" OnClick="rbtnSave5_Click"
                                        meta:resourcekey="rbtnSave5Resource1">
                                    </telerik:RadButton>
                                </td>
                                <td style="width: 45%"></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </telerik:RadPageView>
    </telerik:RadMultiPage>
    <asp:Label ID="msgTestconn" runat="server" meta:resourcekey="msgTestconnResource1"
        Text="測試連線" Visible="False"></asp:Label>
    <asp:Label ID="msgSave" runat="server" meta:resourcekey="msgSaveResource1" Text="儲存"
        Visible="False"></asp:Label>
    <asp:Label ID="Label9" runat="server" Text="基本設定" meta:resourcekey="Label9Resource1"
        Visible="False"></asp:Label>
    <asp:Label ID="Label10" runat="server" Text="登入設定" meta:resourcekey="Label10Resource1"
        Visible="False"></asp:Label>
    <asp:Label ID="Label57" runat="server" Text="模組設定" meta:resourcekey="Label57Resource1"
        Visible="False"></asp:Label>
    <asp:Label ID="lblNotRegCryptInterfaceDll" runat="server" meta:resourcekey="lblNotRegCryptInterfaceDlleResource1"
        Text="TFG相關組件尚未註冊，請洽系統管理員" Visible="False"></asp:Label>
    <asp:Label ID="Label73" runat="server" Text="整合服務" meta:resourcekey="Label73Resource1"
        Visible="False"></asp:Label>

    <asp:Label ID="Label112" runat="server" Text="集團設定" meta:resourcekey="Label112Resource1"
        Visible="False"></asp:Label>

    <asp:Label ID="lblMultiDialogTitle" runat="server" Text="新增/修改多Site網址資訊" Style="display: none" meta:resourcekey="lblMultiDialogTitleResource1"></asp:Label>
    <asp:Label ID="lblDelMultiUrl" runat="server" Text="確認刪除選取的SITE?" Style="display: none" meta:resourcekey="lblDelMultiUrlResource1"></asp:Label>
    <asp:Label ID="lblDeleteTitle" runat="server" Text="確定刪除?" Style="display: none" meta:resourcekey="lblDeleteTitleResource1"></asp:Label>
    <asp:Label ID="lblLymaTitle" runat="server" Text="新增/修改來嘛通便利貼代碼" Style="display: none" meta:resourcekey="lblLymaTitleResource1"></asp:Label>
    <input id="hidSelectColor" runat="server" value="#F9E7E8" style="width: 31px" type="hidden" />
    <input id="hidSelectColor2" runat="server" value="#F9E7E8" style="width: 31px" type="hidden" />
    <asp:Label ID="lblYes" runat="server" Text="是" Visible="False" meta:resourcekey="lblYesResource1"></asp:Label>
    <asp:Label ID="lblNo" runat="server" Text="否" Visible="False" meta:resourcekey="lblNoResource1"></asp:Label>
    <asp:Label ID="lblProxy" runat="server" Text="Proxy設定" meta:resourcekey="lblProxyResource1" Visible="False"></asp:Label>
    <asp:Label ID="lblCaMsgByConfig" runat="server" Text="請填寫用戶端憑證相關設定" Visible="False" meta:resourcekey="lblCaMsgByConfigResource1"></asp:Label>
    <asp:Label ID="lblCaMsgByUser" runat="server" Text="請選取需驗證人員" Visible="False" meta:resourcekey="lblCaMsgByUserResource1"></asp:Label>
    <asp:Label ID="lblMsgIsExistUserINdomain" runat="server" Text="已有使用者存在於該網域，無法刪除。" Visible="False" meta:resourcekey="lblMsgIsExistUserINdomainResource1"></asp:Label>
    <asp:Label ID="lblArgumentErr" runat="server" Text="註冊失敗：參數錯誤" Visible="False" meta:resourcekey="lblArgumentErrResource1"></asp:Label>
    <asp:Label ID="lblUofIsLocked" runat="server" Text="註冊失敗：UOF 被 PushCenter 鎖定, 無法工作" Visible="False" meta:resourcekey="lblUofIsLockedResource1"></asp:Label>
    <asp:Label ID="lblProcessFail" runat="server" Text="註冊失敗：處理失敗, 通常這是因為 PushCenter 內部錯誤所引起" Visible="False" meta:resourcekey="lblProcessFailResource1"></asp:Label>
    <asp:Label ID="lblZeon" runat="server" Text="ZEON PDF SERVER" meta:resourcekey="lblZeonResource1" Visible="False"></asp:Label>
    <asp:Label ID="lblMonth" runat="server" Text="月" Visible="False" meta:resourcekey="lblMonthResource1"></asp:Label>
    <asp:Label ID="lblDay" runat="server" Text="日" Visible="False" meta:resourcekey="lblDayResource1"></asp:Label>
    <asp:Label runat="server" ID="lblConfirmUpdate" Text="確定要啟用?" Visible="False" meta:resourcekey="lblConfirmUpdateResource1"></asp:Label>
    <asp:Label runat="server" ID="lbConfirmDelete" Text="確定要刪除?" Visible="False" meta:resourcekey="lbConfirmDeleteResource1"></asp:Label>
    <asp:Label runat="server" ID="lblSelect" Text="請選擇" Visible="False" meta:resourcekey="lblSelectResource1"></asp:Label> 
    <asp:Label runat="server" ID="lblPowerUserCountMsg" Text="PowerUser人數不能超過{0}人" Visible="False" meta:resourcekey="lblPowerUserCountMsgResource1"></asp:Label>    
</asp:Content>
