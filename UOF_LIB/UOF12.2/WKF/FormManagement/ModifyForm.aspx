﻿<%@ Page Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" Inherits="WKF_FormManagement_ModifyForm" Title="維護表單" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" CodeBehind="ModifyForm.aspx.cs" %>

<%@ Register Src="../../Common/ChoiceCenter/UC_ChoiceList.ascx" TagName="UC_ChoiceList" TagPrefix="uc1" %>
<%@ Register Src="UC_ModifySel.ascx" TagName="UC_ModifySel" TagPrefix="uc2" %>
<%@ Register Src="~/WKF/Common/UC_LimitChoice.ascx" TagPrefix="uc4" TagName="UC_LimitChoice" %>
<%@ Register Src="~/Common/FileCenter/V3/UC_FileCenter.ascx" TagPrefix="uc1" TagName="UC_FileCenter" %>
<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Fast" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        Sys.Application.add_load(function () {
            DisplayUserControl();
            AgentCheck();
            //EndFormReply();
        });

        function EndFormReply() {
            if ($("#<%= cbForum.ClientID %>").is(":checked")) {
                $("#<%=this.cbEndFormReply.ClientID%>").attr("checked", false);
                $("#<%= cbEndFormReply.ClientID %>").attr("disabled", false);
            }
            else {
                $("#<%=this.cbEndFormReply.ClientID%>").attr("checked", false);
                $("#<%= cbEndFormReply.ClientID %>").attr("disabled", true);
            }
        }

        function FormNameIsRepeat(source, arguments) {
            var formId = ["<%=Request["formId"] %>"];
            var formName = $("#<%= txtFormName.ClientID %>").val();

            var oldFormName = $uof.pageMethod.sync("GetFormName", formId);

            var data = ["<%=Request["formId"] %>", formName, oldFormName];
            var rBool = $uof.pageMethod.sync("FormNameIsRepeat", data);


            if (rBool == true) {
                arguments.IsValid = false;
            }
            else {
                arguments.IsValid = true;
            }
        }

        function Checked_cbReturnForm() {
            var cb = $("#<%= cbReturnForm.ClientID %>");
            $("#<%= ddlReturnFormTrigger.ClientID %>").attr('disabled', !cb.prop('checked'));
        }

        function Checked_cbChangeResultForm() {
            var cb = $("#<%= cbChangeResultForm.ClientID %>");
            $("#<%= ddlChangeResultFormTrigger.ClientID %>").attr('disabled', !cb.prop('checked'));
        }

        function DisplayUserControl() {
            var ucDiv = $('#ucDiv');
            var value = $('input[id*=<%=rblBackground.ClientID %>]:checked').val();
            if (value == 'None') {
                ucDiv.hide();
            }
            else if (value == 'Default') {
                ucDiv.hide();
            }
            else if (value == 'ByUser') {
                ucDiv.show();
            }
        }

        function DisplayPrintBtn() {
            var ChoiceList = $('#ChoiceList');
            var cb = $("#<%=cbPrinterAuth.ClientID %>");
            if (cb.prop('checked')) {
                ChoiceList.show();
            }
            else {
                ChoiceList.hide();
            }

        }

        function oncbxDisplayFuncChecked() {
            if ($("#<%=this.cbxDisplayFunc.ClientID%>").prop("checked")) {
                $("#<%=this.pnlDisplayFunc.ClientID%>").show();
            }
            else {
                $("#<%=this.pnlDisplayFunc.ClientID%>").hide();
            }
        }

        function onAdditionalSignChecked() {
            if ($("#<%=this.cbxAdditionalSign.ClientID%>").is(":checked") || $("#<%=this.cbxAdvancedAdditionalSign.ClientID%>").is(":checked")) {
                $("#<%=this.pnlAddSign.ClientID%>").show();
                $("#<%=this.lblAdditionalSignSet.ClientID%>").css('verticalAlign', "middle");
            }
            else {
                $("#<%=this.pnlAddSign.ClientID%>").hide();
                $("#<%=this.lblAdditionalSignSet.ClientID%>").css('verticalAlign', "top");

            }
        }

function onIQYChecked() {
    if ($("#<%=this.cbxIQY.ClientID%>").prop('checked')) {
                $("#<%=this.pnlIQY.ClientID%>").show();
                $("#<%=this.lblIQYTitle.ClientID%>").css('verticalAlign', "middle");
            }
            else {
                $("#<%=this.pnlIQY.ClientID%>").hide();
                $("#<%=this.lblIQYTitle.ClientID%>").css('verticalAlign', "top");
            }
        }
        function DelScriptCheck() {
            if ($("#<%=this.cbxDelScript.ClientID%>").prop('checked')) {
                $("#<%= cbDefaultSaveScript.ClientID%>").prop('checked', false);
                $("#<%= cbDefaultSaveScript.ClientID %>").attr('disabled', true);
            }
            else {
                $("#<%= cbDefaultSaveScript.ClientID %>").attr('disabled', false);
            }
        }

        function AgentCheck() {
            if ($("#<%=this.cbxAgent.ClientID%>").prop('checked')) {
                $("#<%=cbxSendSameDept.ClientID%>").attr('disabled', false);
                SendSameDeptCheck();
            } else {
                $("#<%=cbxSendSameDept.ClientID%>").attr('disabled', true);
                $("#<%= cbxSendSameDept.ClientID %>").prop('checked', false);
                $("#<%= cbxSetAgentAppl.ClientID %>").attr('disabled', true);
                $("#<%= cbxSetAgentAppl.ClientID %>").prop('checked', false);
                $("#<%=Panel1.ClientID%>").hide();
            }
        }

        function SendSameDeptCheck() {
            if ($("#<%=this.cbxSendSameDept.ClientID%>").is(":checked")) {

                $("#<%= cbxSetAgentAppl.ClientID %>").attr("disabled", false);

            } else {

                $("#<%= cbxSetAgentAppl.ClientID %>").attr("disabled", true);
                $("#<%= cbxSetAgentAppl.ClientID %>").prop("checked", false);
                $("#<%= Panel1.ClientID %>").hide();
            }
        }

        function SetAgentApplCheck() {
            if ($("#<%=this.cbxSetAgentAppl.ClientID%>").prop('checked')) {
                $("#<%=Panel1.ClientID%>").show();
            }
            else {
                $("#<%=Panel1.ClientID%>").hide();
            }
        }

        function ArchiveToolbarClick(sender, args) {
            var value = args.get_item().get_value();
            if (value == "setup") {
                args.set_cancel(true);
                $uof.dialog.open2('~/WKF/FormManagement/SetupArchiveUser.aspx', args.get_item(), '', 600, 400, function () { return true; }, { "FORM_ID": "<%=FormID%>", "IsFrom": "ModifyForm" })
            }
            else if (value == "delete") {
                if (confirm('<%=lblConfirm.Text %>') == false) {
                    args.set_cancel(true);
                }
            }
        }
        
        function tbReaderClientClicking(sender, args) {
            var value = args.get_item().get_value();
            if (value == "setup") {
                args.set_cancel(true);
                $uof.dialog.open2('~/WKF/FormManagement/SetupReaderUser.aspx', args.get_item(), '', 600, 400, function () { return true; }, { "FORM_ID": "<%=FormID%>", "IsFrom": "ModifyForm" })
            }
            else if (value == "delete") {
                if (confirm('<%=lblConfirmReader.Text %>') == false) {
                    args.set_cancel(true);
                }
            }
        }

        function BatchSignClick() {
            if ($("#<%=cbxBatchSign.ClientID%>").is(":checked")) {
                $("#<%=Panel3.ClientID%>").show();
            }
            else {
                $("#<%=Panel3.ClientID%>").hide();
            }
        }
    </script>
    <telerik:RadTabStrip ID="RadTabStrip1" runat="server" MultiPageID="RadMultiPage1" SelectedIndex="0" CausesValidation="False" meta:resourcekey="RadTabStrip1Resource1">
        <Tabs>
            <telerik:RadTab runat="server" Selected="True" Text="一般設定" meta:resourcekey="tabSetGenerallyResource1">
            </telerik:RadTab>
            <telerik:RadTab runat="server" Text="進階設定" meta:resourcekey="tabSetGenerallyResource2">
            </telerik:RadTab>
            <telerik:RadTab runat="server" Text="通知設定" meta:resourcekey="tabSetGenerallyResource3">
            </telerik:RadTab>
            <telerik:RadTab runat="server" Text="主題設定" meta:resourcekey="tabSetGenerallyResource4">
            </telerik:RadTab>
        </Tabs>
    </telerik:RadTabStrip>
    <telerik:RadMultiPage ID="RadMultiPage1" runat="server" SelectedIndex="2" meta:resourcekey="RadMultiPage1Resource1">
        <telerik:RadPageView ID="RadPageView1" runat="server" meta:resourcekey="RadPageView1Resource1" Selected="True">
            <table cellspacing="1" class="PopTable" width="100%">
                <tr>
                    <td colspan="4" class="PopTableHeader" align="center">
                        <center>
                                    <asp:Label ID="lblNormalTitle" runat="server" meta:resourcekey="lblNormalTitleResource1"
                                        Text="一般設定"></asp:Label></center>
                    </td>
                </tr>
                <tr>
                    <td style="height: 30px" class="PopTableLeftTD">
                        <asp:Label ID="lblFormTypeTitle" runat="server" meta:resourcekey="lblFormTypeTitleResource1"
                            Text="表單類別"></asp:Label>
                    </td>
                    <td style="height: 30px; width: 25%" class="PopTableRightTD">
                        <asp:Label ID="lblFormType" runat="server" meta:resourcekey="lblFormTypeResource1"></asp:Label>
                    </td>
                    <td style="height: 30px; width: 15%" class="PopTableLeftTD">
                        <font color="red">*</font>
                        <asp:Label ID="lblFormName" runat="server" meta:resourcekey="lblFormNameResource1"
                            Text="表單名稱"></asp:Label>
                    </td>
                    <td style="height: 30px; width: 45%" class="PopTableRightTD">
                        <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                            <ContentTemplate>
                                <asp:TextBox ID="txtFormName" runat="server" meta:resourcekey="txtFormNameResource1" MaxLength="40"></asp:TextBox>
                                <telerik:RadButton ID="ibtnSetting" runat="server" Text="設定多國語言" meta:resourcekey="ibtnSettingResource1"
                                    OnClick="ibtnSetting_Click1">
                                </telerik:RadButton>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtFormName"
                                    Display="Dynamic" ErrorMessage="請輸入表單名稱" meta:resourcekey="RequiredFieldValidator1Resource1"></asp:RequiredFieldValidator>
                                <asp:CustomValidator ID="CustomValidator1" runat="server" ClientValidationFunction="FormNameIsRepeat"
                                    ControlToValidate="txtFormName" ErrorMessage="表單名稱重複" meta:resourcekey="CustomValidator1Resource1"></asp:CustomValidator>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
                <tr>
                    <td style="height: 25px" class="PopTableLeftTD">
                        <asp:Label ID="lblFormCtl" runat="server" meta:resourcekey="lblFormCtlResource1"
                            Text="表單停用"></asp:Label>
                    </td>
                    <td colspan="3" style="height: 25px" class="PopTableRightTD">
                        <asp:CheckBox ID="cbFormCtl" runat="server" meta:resourcekey="cbFormCtlResource1" />
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD">
                        <asp:Label ID="lblDelScript" runat="server" meta:resourcekey="lblSaveScriptResource1"
                            Text="副本儲存"></asp:Label>
                    </td>
                    <td class="PopTableRightTD" colspan="3">
                        <asp:CheckBox ID="cbxDelScript" runat="server" Text="表單送出時不允許儲存副本" meta:resourcekey="cbxDelScriptResource1"
                            onclick="DelScriptCheck()" />
                        <br />
                        <asp:CheckBox ID="cbDefaultSaveScript" runat="server" Text="預設儲存副本" meta:resourcekey="cbDefaultSaveScriptResource1" />

                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD">
                        <asp:Label ID="lblBatchSign" runat="server" meta:resourcekey="lblBatchSignResource1"
                            Text="批次簽核"></asp:Label>
                    </td>
                    <td class="PopTableRightTD" colspan="3">
                        <asp:CheckBox ID="cbxBatchSign" runat="server" Text="表單支援批次簽核" meta:resourcekey="cbxBatchSignResource1" onclick="BatchSignClick()"/>
                        <asp:Panel ID="Panel3" runat="server" meta:resourcekey="pnlAddSignResource1">
                                    <uc4:UC_LimitChoice ID="UC_LimitBatchSigner" runat="server" ShowSameDepCheckBox="false"/>
                                    <asp:CustomValidator ID="cvLimitBatchSigner" runat="server" ErrorMessage="請選擇限制人員"
                                        Display="Dynamic" meta:resourceKey="cvLimitBatchSignerResource1"></asp:CustomValidator>
                                </asp:Panel>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD">
                        <asp:Label ID="lbl_ModifyMethod" runat="server" meta:resourcekey="lbl_ModifyMethodResource1"
                            Text="修改權限"></asp:Label>
                    </td>
                    <td colspan="3" class="PopTableRightTD">
                        <uc2:UC_ModifySel ID="UC_ModifySel1" runat="server" />
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD">
                        <asp:Label ID="lblAgent" runat="server" Text="代理申請" meta:resourcekey="lblAgentResource1"></asp:Label>
                    </td>
                    <td class="PopTableRightTD" colspan="3">
                        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                            <ContentTemplate>
                                <asp:CheckBox ID="cbxAgent" runat="server" Text="是否支援代理申請" meta:resourcekey="cbxAgentResource1"
                                    onclick="AgentCheck()" />
                                <table style="width:100%;">
                                    <tr>
                                        <td class="style1"></td>
                                        <td colspan="2">
                                            <asp:CheckBox ID="cbxSendSameDept" runat="server" Text="只允許同部門的人代理申請" onclick="SendSameDeptCheck()" meta:resourcekey="cbxSendSameDeptResource1" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="style1"></td>
                                        <td class="style1"></td>
                                        <td>
                                            <asp:CheckBox ID="cbxSetAgentAppl" runat="server" Text="設定例外人員" onclick="SetAgentApplCheck()"
                                                meta:resourcekey="cbxSetAgentApplResource1" />
                                            <asp:Label ID="lblSetAgentMsg" runat="server" Text="(例外人員可代理所有人員申請表單)" ForeColor="Blue"
                                                meta:resourcekey="lblSetAgentMsgResource1"></asp:Label>
                                            <asp:Panel ID="Panel1" runat="server" meta:resourcekey="Panel1Resource1">
                                                <uc1:UC_ChoiceList ID="UC_ChoiceListAgentAppl" runat="server" ExpandToUser="false"
                                                    TreeHeight="55px" ShowMember="false" />
                                            </asp:Panel>
                                            <asp:CustomValidator ID="cvAgentAppl" runat="server" Display="Dynamic" ErrorMessage="請選擇人員"
                                                OnServerValidate="cvAgentAppl_ServerValidate"
                                                meta:resourcekey="cvPrintAuthResource1"></asp:CustomValidator>
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD">
                        <asp:Label ID="Label14" runat="server" Text="列印權限" meta:resourcekey="Label14Resource1"></asp:Label>
                    </td>
                    <td colspan="3" class="PopTableRightTD">
                        <asp:CheckBox ID="cbPrinterAuth" runat="server" Text="只允許下列人員列印" meta:resourcekey="cbPrinterAuthResource1" />
                        <asp:Label ID="Label15" runat="server" ForeColor="Blue" Text="(若未勾選此項，則所有人皆可列印。)"
                            meta:resourcekey="Label15Resource1"></asp:Label>
                        <div id="ChoiceList">
                            <uc1:UC_ChoiceList ID="UC_ChoiceList_PrintAuth" runat="server" ExpandToUser="False" />
                            <br />
                            <asp:CustomValidator ID="cvPrintAuth" runat="server" Display="Dynamic" ErrorMessage="請選擇人員"
                                OnServerValidate="cvPrintAuth_ServerValidate" meta:resourcekey="cvPrintAuthResource1"></asp:CustomValidator>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD">
                        <asp:Label ID="Label16" runat="server" Text="表單列印底圖" meta:resourcekey="Label16Resource1"></asp:Label>
                    </td>
                    <td colspan="3" class="PopTableRightTD">
                        <asp:RadioButtonList ID="rblBackground" runat="server" meta:resourcekey="rblBackgroundResource1">
                            <asp:ListItem Value="None" Selected="True" Text="不使用" meta:resourcekey="ListItemResource1"></asp:ListItem>
                            <asp:ListItem Value="Default" Text="採用預設底圖" meta:resourcekey="ListItemResource2"></asp:ListItem>
                            <asp:ListItem Value="ByUser" Text="自行設定" meta:resourcekey="ListItemResource3"></asp:ListItem>
                        </asp:RadioButtonList>
                        <div id="ucDiv">
                            <uc1:UC_FileCenter runat="server" ID="UC_FileCenter" AllowedMultipleFileSelection="false" AllowedFileType="Image" ModuleName="WKF" ProxyEnabled="true" />
                            <asp:CustomValidator ID="cvUploadImage" runat="server" Display="Dynamic" ErrorMessage="請上傳圖檔"
                                OnServerValidate="cvUploadImage_ServerValidate" meta:resourcekey="cvUploadImageResource1"></asp:CustomValidator>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD">
                        <asp:Label ID="lblException" runat="server" Text="異常表單" meta:resourcekey="lblExceptionResource1"></asp:Label>
                    </td>
                    <td colspan="3" class="PopTableRightTD">
                        <asp:CheckBox ID="cbxException" runat="server" Text="異常允許送出" meta:resourcekey="cbxExceptionResource1" />
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD">
                        <asp:Label ID="lblIQYTitle" runat="server" Text="表單徵詢" meta:resourcekey="lblIQYTitleResource1"></asp:Label>
                    </td>
                    <td colspan="3" class="PopTableRightTD">
                        <asp:CheckBox ID="cbxIQY" runat="server" Text="允許表單發出徵詢" meta:resourcekey="cbxIQYResource1"
                            onclick="onIQYChecked()" />
                        <asp:Panel ID="pnlIQY" runat="server" meta:resourcekey="pnlIQYResource1">
                            <uc4:UC_LimitChoice ID="UC_LimitIQYChoice" runat="server" />
                            <asp:CustomValidator ID="cvIQY" runat="server" ErrorMessage="請選擇限制人員" Display="Dynamic"
                                meta:resourcekey="cvIQYResource1"></asp:CustomValidator>
                        </asp:Panel>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD">
                        <asp:Label ID="lblFormDelay" runat="server" meta:resourcekey="lblFormDelayResource1"
                            Text="表單逾時"></asp:Label>
                    </td>
                    <td class="PopTableRightTD">
                        <asp:DropDownList ID="ddlDay" runat="server" meta:resourcekey="ddlDayResource1">
                        </asp:DropDownList>
                        <asp:Label ID="Label2" runat="server" meta:resourcekey="Label2Resource1" Text="日"></asp:Label>
                        <asp:DropDownList ID="ddlHour" runat="server" meta:resourcekey="ddlHourResource1">
                        </asp:DropDownList>
                        <asp:Label ID="Label3" runat="server" meta:resourcekey="Label3Resource1" Text="時"></asp:Label>
                        <asp:Label ID="Label8" runat="server" Text="(0表示不設定)" CssClass="SizeMemo" meta:resourcekey="Label7Resource2"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="Label5" runat="server" Text="自動送至下一站" meta:resourcekey="Label5Resource1"></asp:Label>
                    </td>
                    <td>
                        <telerik:RadNumericTextBox ID="rntAutoSign" DataType="System.String" runat="server" Width="80px" MinValue="0" Value="0" Culture="zh-TW" DbValueFactor="1" LabelCssClass="" LabelWidth="64px" meta:resourcekey="rntAutoSignResource1">
                            <NegativeStyle Resize="None" />
                            <NumberFormat ZeroPattern="n" AllowRounding="False" DecimalDigits="0"></NumberFormat>
                            <EmptyMessageStyle Resize="None" />
                            <ReadOnlyStyle Resize="None" />
                            <FocusedStyle Resize="None" />
                            <DisabledStyle Resize="None" />
                            <InvalidStyle Resize="None" />
                            <HoveredStyle Resize="None" />
                            <EnabledStyle Resize="None" />
                        </telerik:RadNumericTextBox>
                        <asp:Label ID="Label6" runat="server" meta:resourcekey="Label3Resource1"
                            Text="時"></asp:Label>
                        <asp:Label ID="Label7" runat="server" Text="(0表示不設定)" CssClass="SizeMemo" meta:resourcekey="Label7Resource2"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD">
                        <asp:Label ID="lblCycleAlert" runat="server" Text="簽核提醒頻率" meta:resourcekey="lblCycleAlertResource1"></asp:Label>
                    </td>
                    <td colspan="3" nowrap class="PopTableRightTD">
                        <telerik:RadNumericTextBox ID="rNumCycleHours" DataType="System.String" runat="server" Width="80px" MinValue="0" Value="0" Culture="zh-TW" DbValueFactor="1" LabelCssClass="" LabelWidth="64px" meta:resourcekey="rNumCycleHoursResource1">
                            <NegativeStyle Resize="None" />
                            <NumberFormat ZeroPattern="n" AllowRounding="False" DecimalDigits="0"></NumberFormat>
                            <EmptyMessageStyle Resize="None" />
                            <ReadOnlyStyle Resize="None" />
                            <FocusedStyle Resize="None" />
                            <DisabledStyle Resize="None" />
                            <InvalidStyle Resize="None" />
                            <HoveredStyle Resize="None" />
                            <EnabledStyle Resize="None" />
                        </telerik:RadNumericTextBox>
                        <asp:Label ID="Label26" runat="server" meta:resourcekey="Label3Resource1"
                            Text="時"></asp:Label>
                        <asp:Label ID="Label10" runat="server" Text="(0表示不設定)" CssClass="SizeMemo" meta:resourcekey="Label10Resource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="height: 25px" class="PopTableLeftTD">
                        <asp:Label ID="lblExternal" runat="server" meta:resourcekey="lblExternalResource1"
                            Text="線上申請"></asp:Label>
                    </td>
                    <td colspan="3" style="height: 25px" class="PopTableRightTD">
                        <asp:CheckBox ID="cbIsExternal" runat="server" meta:resourcekey="cbIsExternalResource1"
                            Text="不允許使用者線上申請表單" />
                        <asp:Label ID="Label9" runat="server" meta:resourcekey="Label9Resource1" Text="(如果不允許時，只能由外部系統拋入表單內容)"></asp:Label>
                        <br />
                        <asp:CheckBox ID="chk_RA" runat="server" meta:resourcekey="chk_RAResource1" Text="退回申請者後，不允許在電子簽核中處理！" />
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD">
                        <asp:Label ID="lblOrSet" runat="server" meta:resourcekey="lblOrSetResource1" Text="並簽設定"></asp:Label>
                    </td>
                    <td colspan="3" class="PopTableRightTD">
                        <asp:RadioButtonList ID="rbOrSet" runat="server" meta:resourcekey="rbOrSetResource1">
                            <asp:ListItem meta:resourcekey="ListItemResource4" Value="1" Text="全部否決才可結案"></asp:ListItem>
                            <asp:ListItem meta:resourcekey="ListItemResource5" Value="2" Text="一人否決即結案"></asp:ListItem>
                        </asp:RadioButtonList>
                        <asp:CheckBox ID="cbNotDisplayUnsign" runat="server" Text="未簽核則不顯示" meta:resourcekey="cbNotDisplayUnsignResource1" />
                        <asp:Label ID="Label13" runat="server" ForeColor="Blue" Text="(在觀看簽核意見時，不顯示未簽核人員的資訊)"
                            meta:resourcekey="Label13Resource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td style="vertical-align: " class="PopTableLeftTD">
                        <asp:Label ID="lblAdditionalSignSet" runat="server" Text="加簽設定" meta:resourcekey="lblAdditionalSignSetResource1"></asp:Label>
                    </td>
                    <td colspan="3" class="PopTableRightTD">
                        <asp:CheckBox ID="cbxAdditionalSign" runat="server" meta:resourcekey="cbxAdditionalSignResource1"
                            Text="允許加簽" onclick="onAdditionalSignChecked()" />
                        <asp:Label ID="lblAdditionalSign" runat="server" ForeColor="Blue" meta:resourcekey="lblAdditionalSignResource1" Text="(由申請者、簽核者自行設定加簽人員)"></asp:Label>
                        <br />
                        <asp:CheckBox ID="cbxAdvancedAdditionalSign" runat="server" meta:resourcekey="cbxAdvancedAdditionalSignResource1" onclick="onAdditionalSignChecked()" Text="允許進階加簽" />
                        <asp:Label ID="lblAdvancedAdditionalSign" runat="server" ForeColor="Blue" meta:resourcekey="lblAdvancedAdditionalSignResource1" Text="(申請者、簽核者可幫流程中的簽核站點設定加簽人員)"></asp:Label>
                        <asp:Panel ID="pnlAddSign" runat="server" meta:resourcekey="pnlAddSignResource1">
                            <uc4:UC_LimitChoice ID="UC_LimitAddSignChoice" runat="server" />
                            <asp:CustomValidator ID="cvAdditionalSign" runat="server" ErrorMessage="請選擇限制人員"
                                Display="Dynamic" meta:resourcekey="cvAdditionalSignResource1"></asp:CustomValidator>
                        </asp:Panel>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD">
                        <asp:Label ID="Label17" runat="server" Text="退簽/作廢設定" meta:resourcekey="Label17Resource1"></asp:Label>
                    </td>
                    <td colspan="3" class="PopTableRightTD">
                        <asp:CheckBox ID="cbApplicantChoiceSend" runat="server" Text="退回申請者後，申請者送出時可選擇跳關送出的站點"
                            meta:resourcekey="cbApplicantChoiceSendResource1" />
                        <br />
                        <asp:CheckBox ID="chkReturnSign" runat="server" Text="不允許退簽" meta:resourcekey="chkReturnSignResource1" />
                        <br />
                        <asp:CheckBox ID="cbApplicantCancelForm" runat="server" Text="不允許申請者作廢表單" meta:resourceKey="cbApplicantCancelFormResource1"  />
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD">
                        <asp:Label ID="Label20" runat="server" Text="站點簽核設定" meta:resourcekey="Label20Resource1"></asp:Label>
                    </td>
                    <td colspan="3" class="PopTableRightTD">
                        <asp:CheckBox ID="cbAllowReject" Text="站點允許否決" Checked="True" runat="server"
                            meta:resourcekey="AllowRejectResource1" />
                        <asp:CheckBox ID="cbAllowReturn" Text="站點允許退簽" Checked="True" runat="server"
                            meta:resourcekey="AllowReturnResource1" />
                        <asp:CheckBox ID="cbAllowSkipped" Text="下一站若為相同簽核者則跳過" runat="server"
                            meta:resourcekey="AllowSkippedResource1" />
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD">
                        <asp:Label ID="Label1" runat="server" Text="副本設定" meta:resourcekey="Label1Resource"></asp:Label>
                    </td>
                    <td colspan="3" class="PopTableRightTD">
                        <asp:CheckBox ID="cbSetFormCC" runat="server" Text="允許使用副本" meta:resourcekey="cbSetFormCCResource1" />
                        <asp:CheckBox ID="cbSetFormBCC" runat="server" Text="允許使用密件副本" meta:resourcekey="cbSetFormBCCResource1" />
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD">
                        <asp:Label ID="Label4" runat="server" Text="簽核意見設定" meta:resourcekey="Label4Resource1"></asp:Label>
                    </td>
                    <td colspan="3" class="PopTableRightTD">
                        <asp:CheckBox ID="cbCommentOpenWindow" runat="server" Text="簽核表單時，如有簽核意見會開新視窗顯示"
                            meta:resourcekey="cbCommentOpenWindowResource1" />
                    </td>
                </tr>
                <tr style="display: none">
                    <td class="PopTableLeftTD">
                        <asp:Label ID="Label21" runat="server" Text="簽核歷程設定" meta:resourcekey="Label21Resource1"></asp:Label>
                    </td>
                    <td colspan="3" class="PopTableRightTD">
                        <asp:CheckBox ID="cbxDisplayFunc" runat="server" Text="顯示人員職務" onclick="oncbxDisplayFuncChecked()"
                            meta:resourcekey="cbxDisplayFuncResource1" />
                        <asp:Label ID="Label22" runat="server" Text="(若只勾選此選項，則不包含部門主管及簽核人員職務)" ForeColor="Blue"
                            meta:resourcekey="Label22Resource1"></asp:Label>
                        <asp:Panel ID="pnlDisplayFunc" runat="server" meta:resourcekey="pnlDisplayFuncResource1">
                            <asp:CheckBoxList ID="cbListDisplay" runat="server" meta:resourcekey="cbListDisplayResource1">
                                <asp:ListItem Text="顯示「部門主管」職務" Value="DisplaySuperior" Selected="True" meta:resourcekey="DisplaySuperiorResource1"></asp:ListItem>
                                <asp:ListItem Text="顯示「簽核人員」職務" Value="DisplaySigner" Selected="True" meta:resourcekey="DisplaySignerResource1"></asp:ListItem>
                            </asp:CheckBoxList>
                        </asp:Panel>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD">
                        <asp:Label ID="lblEndFormSetup" runat="server" Text="結案後知會設定" meta:resourcekey="lblEndFormSetupResource1"></asp:Label>
                    </td>
                    <td colspan="3" class="PopTableRightTD">
                        <asp:CheckBox ID="cbAllowEndFormAlert" runat="server" Text="允許申請者於表單結案後知會他人" meta:resourcekey="cbAllowEndFormAlertResource1" />
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD">
                        <asp:Label ID="lblSuperiorQuery" runat="server" Text="主管查詢表單設定" meta:resourcekey="lblSuperiorQueryResource1"></asp:Label>
                    </td>
                    <td colspan="3" class="PopTableRightTD">
                        <asp:CheckBox ID="cbAllowSuperiorQuery" runat="server" Text="允許部門主管針對此表單去查詢所屬員工的單據"
                            meta:resourcekey="cbAllowSuperiorQueryResource1" />
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD">
                        <asp:Label ID="Label23" runat="server" Text="表單討論設定" meta:resourcekey="Label23Resource1"></asp:Label>
                    </td>
                    <td colspan="3" class="PopTableRightTD">
                        <asp:CheckBox ID="cbForum" runat="server" Text="允許使用表單討論" onclick="EndFormReply()" meta:resourcekey="cbForumResource1" /><br />
                        <asp:CheckBox ID="cbEndFormReply" runat="server" Text="表單結案後允許繼續討論" Enabled="False" meta:resourcekey="cbEndFormReplyResource1" />
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD">
                        <asp:Label ID="Label24" runat="server" Text="行動裝置設定" meta:resourcekey="Label24Resource1"></asp:Label>
                    </td>
                    <td colspan="3" class="PopTableRightTD">
                        <asp:CheckBox ID="cbMobileApply" runat="server" Text="允許行動裝置申請" meta:resourcekey="cbMobileApplyResource1" />
                        <br />
                        <asp:CheckBox ID="cbMobileSign" runat="server" Text="允許行動裝置簽核" meta:resourcekey="cbMobileSignResource1" />
                    </td>
                </tr>
            </table>
            <table cellspacing="1" class="PopTable" width="100%">
                <tr>
                    <td colspan="6" class="PopTableHeader" align="center">
                        <center>
                                    <asp:Label ID="lblSetPersonnel" runat="server" Text="人員設定" meta:resourcekey="lblSetPersonnelResource1"></asp:Label></center>
                    </td>
                </tr>
                <tr>
                    <td style="width: 20%; text-align: right">
                        <font color="red">*</font>
                        <asp:Label ID="lblFormAuthority" runat="server" meta:resourcekey="lblFormAuthorityResource1"
                            Text="表單使用權限"></asp:Label>
                    </td>
                    <td style="vertical-align: top; background-color: #FFFFFF" colspan="5">
                        <uc1:UC_ChoiceList ID="UC_ChoiceListAuthority" runat="server" ShowMember="True" TreeHeight="100px"/>
                        <asp:CustomValidator ID="CustomValidatorAuthority" runat="server" Display="Dynamic"
                            ErrorMessage="請選擇表單使用權限" meta:resourcekey="CustomValidatorAuthorityResource1"></asp:CustomValidator>
                    </td>
                </tr>
                <tr>
                    <td style="width: 20%; text-align: right">
                        <asp:Label ID="lblManager" runat="server" meta:resourcekey="lblManagerResource1"
                            Text="表單負責人"></asp:Label>
                    </td>
                    <td style="vertical-align: top; background-color: #FFFFFF" colspan="5">
                        <uc1:UC_ChoiceList ID="UC_ChoiceListManager" runat="server" TreeHeight="100px" ShowMember="False" />
                        <asp:Label ID="lblNonSetting" runat="server" meta:resourcekey="lblNonSettingResource1"
                            Text="不設定" Visible="False"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td colspan="6" class="PopTableHeader" align="center">
                        <center>
                                    <asp:Label ID="lblArchiveSetting" runat="server" Text="歸檔設定" meta:resourcekey="lblArchiveSettingResource1"></asp:Label>
                        </center>
                    </td>
                </tr>
                <tr>
                    <td style="width: 20%; text-align: right">
                        <asp:Label ID="lblArchiveUser" runat="server" meta:resourcekey="lblArchiveUserResource1"
                            Text="歸檔處理者"></asp:Label>
                    </td>
                    <td style="vertical-align: top; background-color: #FFFFFF" colspan="5">
                        <asp:UpdatePanel ID="updatePanelArchive" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <table style="width: 100%">
                                    <tr>
                                        <telerik:RadToolBar ID="tbArchive" runat="server" Width="100%" meta:resourcekey="tbArchiveResource1"
                                            OnButtonClick="tbArchive_ButtonClick" OnClientButtonClicking="ArchiveToolbarClick" SingleClick="None">
                                            <Items>
                                                <telerik:RadToolBarButton Value="setup" runat="server" Text="新增歸檔人員" ImageUrl="~/Common/Images/Icon/icon_m51.gif" meta:resourcekey="RadToolBarButtonResource1"></telerik:RadToolBarButton>
                                                <telerik:RadToolBarButton runat="server" IsSeparator="True" meta:resourcekey="RadToolBarButtonResource2"></telerik:RadToolBarButton>
                                                <telerik:RadToolBarButton Value="delete" runat="server" Text="刪除" ImageUrl="~/Common/Images/Icon/icon_m46.gif" meta:resourcekey="RadToolBarButtonResource3"></telerik:RadToolBarButton>
                                                <telerik:RadToolBarButton runat="server" IsSeparator="True" meta:resourcekey="RadToolBarButtonResource4"></telerik:RadToolBarButton>
                                            </Items>
                                        </telerik:RadToolBar>
                                    </tr>
                                    <tr>
                                        <td style="width: 100%">
                                            <Fast:Grid ID="gridArchive" runat="server" Width="100%" OnRowCommand="gridArchive_RowCommand"
                                                AllowSorting="True" AutoGenerateCheckBoxColumn="True"
                                                AutoGenerateColumns="False" DataKeyNames="ARCHIVE_RM_ID" OnRowDataBound="gridArchive_RowDataBound"
                                                DataKeyOnClientWithCheckBox="False" DefaultSortDirection="Ascending"
                                                EnhancePager="True" PageSize="15" CustomDropDownListPage="False" EmptyDataText="No data found" KeepSelectedRows="False" meta:resourcekey="gridArchiveResource1" SelectedRowColor="" UnSelectedRowColor="">
                                                <EnhancePagerSettings
                                                    ShowHeaderPager="True" />
                                                <ExportExcelSettings AllowExportToExcel="False" />
                                                <Columns>
                                                    <asp:BoundField DataField="ARCHIVE_RM_ID" Visible="False" meta:resourceKey="BoundFieldResource1" />
                                                    <asp:TemplateField HeaderText="歸檔人員" meta:resourcekey="TemplateFieldResource2">
                                                        <ItemTemplate>
                                                            <uc1:UC_ChoiceList ID="choiceArchive" runat="server" ChioceType="User" IsAllowEdit="false" />
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="可查詢部門" meta:resourcekey="TemplateFieldResource1">
                                                        <ItemTemplate>
                                                            <uc1:UC_ChoiceList ID="choiceDept" runat="server" ChioceType="Group" IsAllowEdit="false" />
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="操作" meta:resourcekey="TemplateFieldResource3">
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="lbtnEdit" runat="server" Text="編輯" meta:resourcekey="btnEditResource1"></asp:LinkButton>
                                                        </ItemTemplate>
                                                        <ItemStyle HorizontalAlign="Center" />
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
                    <td colspan="6" class="PopTableHeader">
                        <div style="text-align: center">
                            <asp:Label ID="Label32" runat="server" Text="表單查閱設定" meta:resourcekey="Label32Resource1"></asp:Label>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td style="width: 20%; text-align: right">
                        <asp:Label ID="lblFormReader" runat="server" Text="表單查閱者" meta:resourcekey="lblFormReaderResource1"></asp:Label>
                    </td>
                    <td style="vertical-align: top; background-color: #FFFFFF" colspan="5">
                        <asp:UpdatePanel ID="updatePanelReader" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <table style="width: 100%">
                                    <tr>
                                        <telerik:RadToolBar ID="tbReader" runat="server" Width="100%" OnClientButtonClicking="tbReaderClientClicking" OnButtonClick="tbReader_ButtonClick"
                                            SingleClick="None" meta:resourcekey="tbReaderResource1">
                                            <Items>
                                                <telerik:RadToolBarButton Value="setup" runat="server" Text="新增表單查閱者" ImageUrl="~/Common/Images/Icon/icon_m51.gif" CausesValidation="False" meta:resourcekey="RadToolBarButtonResource5"></telerik:RadToolBarButton>
                                                <telerik:RadToolBarButton runat="server" IsSeparator="True" meta:resourcekey="RadToolBarButtonResource6"></telerik:RadToolBarButton>
                                                <telerik:RadToolBarButton Value="delete" runat="server" Text="刪除" ImageUrl="~/Common/Images/Icon/icon_m46.gif" CausesValidation="False" meta:resourcekey="RadToolBarButtonResource7"></telerik:RadToolBarButton>
                                                <telerik:RadToolBarButton runat="server" IsSeparator="True" meta:resourcekey="RadToolBarButtonResource8"></telerik:RadToolBarButton>
                                            </Items>
                                        </telerik:RadToolBar>
                                    </tr>
                                    <tr>
                                        <td style="width: 100%">
                                            <Fast:Grid ID="gridReader" runat="server" Width="100%"
                                                AllowSorting="True" AutoGenerateCheckBoxColumn="True" AutoGenerateColumns="False"
                                                CustomDropDownListPage="False"
                                                DataKeyNames="READER_RM_ID" DataKeyOnClientWithCheckBox="False" DefaultSortDirection="Ascending"
                                                EnhancePager="True" PageSize="15" EmptyDataText="No data found"
                                                OnRowCommand="gridReader_RowCommand" OnRowDataBound="gridReader_RowDataBound"
                                                KeepSelectedRows="False" SelectedRowColor="" UnSelectedRowColor="" meta:resourcekey="gridReaderResource1">
                                                <EnhancePagerSettings
                                                    ShowHeaderPager="True" FirstAltImageUrl="" FirstImageUrl="" LastAltImage="" LastImageUrl="" NextIAltImageUrl="" NextImageUrl="" PageInfoCssClass="" PageNumberCssClass="" PageNumberCurrentCssClass="" PageRedirectCssClass="" PreviousAltImageUrl="" PreviousImageUrl="" />
                                                <ExportExcelSettings AllowExportToExcel="False" />
                                                <Columns>
                                                    <asp:BoundField DataField="READER_RM_ID" Visible="False" meta:resourcekey="BoundFieldResource2" />
                                                    <asp:TemplateField HeaderText="表單查閱者" meta:resourcekey="TemplateFieldResource4">
                                                        <ItemTemplate>
                                                            <uc1:UC_ChoiceList ID="choiceListReader" runat="server" ChioceType="User" IsAllowEdit="false" />
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="可查詢部門" meta:resourcekey="TemplateFieldResource5">
                                                        <ItemTemplate>
                                                            <uc1:UC_ChoiceList ID="choiceDeptReader" runat="server" ChioceType="Group" IsAllowEdit="false" />
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="操作" meta:resourcekey="TemplateFieldResource6">
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="lbtnEditReader" runat="server" Text="編輯" CausesValidation="False" meta:resourcekey="lbtnEditReaderResource1"></asp:LinkButton>
                                                        </ItemTemplate>
                                                        <ItemStyle HorizontalAlign="Center" />
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
            </table>
        </telerik:RadPageView>
        <telerik:RadPageView ID="RadPageView2" runat="server" meta:resourcekey="RadPageView2Resource1">
            <table cellspacing="1" class="NormalPopTable" width="100%">
                <colgroup class="PopTableLeftTD" style="width: 18%">
                </colgroup>
                <colgroup class="PopTableRightTD" style="width: 82%;">
                </colgroup>
                <colgroup class="PopTableLeftTD" style="width: 18%;">
                </colgroup>
                <colgroup class="PopTableRightTD" style="width: 82%;">
                </colgroup>
                <tr>
                    <td colspan="2" class="PopTableHeader" align="center">
                        <center>
                                    <asp:Label ID="lblProfessnalTitle" runat="server" meta:resourcekey="lblProfessnalTitleResource1"
                                        Text="進階設定"></asp:Label></center>
                    </td>
                </tr>
                <tr>
                    <td rowspan="2" align="right">
                        <asp:Label ID="lblResponsibleControl" runat="server" Text="表單負責人可使用權限" meta:resourcekey="lblResponsibleControlResource1"></asp:Label>
                    </td>
                    <td class="PopTableRightTD" style="text-align: left; margin: 0; padding: 0">
                        <table cellpadding="0" cellspacing="0" style="width: 100%; text-align: left; margin: 0; padding: 0">
                            <tr>
                                <td class="PopTableRightTD">
                                    <table style="border: 0; margin: 0; padding: 0">
                                        <tr>
                                            <td>
                                                <asp:CheckBox ID="cbCancelForm" runat="server" Text="允許作廢表單" meta:resourcekey="cbCancelFormResource1" /><br />
                                                <asp:CheckBox ID="cbEndForm" runat="server" Text="允許強制結案" meta:resourcekey="cbEndFormResource1" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableRightTD" style="text-align: left; margin: 0; padding: 0">
                        <table cellpadding="0" cellspacing="0" style="width: 100%; text-align: left; margin: 0; padding: 0">
                            <tr>
                                <td class="PopTableRightTD">
                                    <table style="border: 0; margin: 0; padding: 0">
                                        <tr>
                                            <td>
                                                <asp:CheckBox ID="cbReturnForm" runat="server" Text="允許結案復原" onClick="Checked_cbReturnForm()"
                                                    meta:resourcekey="cbReturnFormResource1" /><br />
                                                <asp:Label ID="Label11" runat="server" Text="結案復原驗證事件設定" meta:resourcekey="Label11Resource1"></asp:Label>
                                                <asp:DropDownList ID="ddlReturnFormTrigger" runat="server" meta:resourcekey="ddlReturnFormTriggerResource1">
                                                </asp:DropDownList>
                                                <telerik:RadButton ID="btn_ReturnFormTrigger" runat="server"
                                                    meta:resourcekey="btn_ReturnFormTriggerResource1" CausesValidation="False"
                                                    Text="設定" OnClick="btn_ReturnFormTrigger_Click1">
                                                </telerik:RadButton>
                                                <br />
                                                <asp:CheckBox ID="cbChangeResultForm" runat="server" Text="允許變更審核結果" onClick="Checked_cbChangeResultForm()"
                                                    meta:resourcekey="cbChangeResultFormResource1" />
                                                <br />
                                                <asp:Label ID="Label12" runat="server" Text="審核結果驗證事件設定" meta:resourcekey="Label12Resource1"></asp:Label>
                                                <asp:DropDownList ID="ddlChangeResultFormTrigger" runat="server" meta:resourcekey="ddlChangeResultFormTriggerResource1">
                                                </asp:DropDownList>
                                                <telerik:RadButton ID="btn_ChangeResultFormTrigge" runat="server"
                                                    meta:resourcekey="btn_ChangeResultFormTriggeResource1" CausesValidation="False"
                                                    Text="設定" OnClick="btn_ChangeResultFormTrigge_Click1">
                                                </telerik:RadButton>
                                                <br />
                                                <asp:Label ID="lblMassage4" runat="server" Text="(表單狀態變更後，會影響外部的系統，如果單據結案時，有設定外部處理<br>的功能，如果沒有對應的機制，請務必不可啟動此兩個功能！)"
                                                    ForeColor="Red" meta:resourcekey="lblMassage4Resource1"></asp:Label>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        <asp:Label ID="lblSetFormTrigger" runat="server" Text="表單事件處理相關設定" meta:resourcekey="lblSetFormTriggerResource1"></asp:Label>
                    </td>
                    <td class="PopTableRightTD" style="text-align: left; margin: 0; padding: 0">
                        <table cellpadding="0" cellspacing="0" style="width: 100%; text-align: left; margin: 0; padding: 0">
                            <tr>
                                <td class="PopTableRightTD">
                                    <table cellpadding="2" border="0" cellspacing="2">
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblStartFormTriggerTitle" runat="server" Text="表單起單事件設定" meta:resourcekey="lblStartFormTriggerTitleResource1"></asp:Label>:
                                            </td>
                                            <td style="margin: 2px; padding: 2px">
                                                <asp:DropDownList ID="ddlStartFormTrigger" runat="server" meta:resourcekey="ddlStartFormTriggerResource1">
                                                </asp:DropDownList>
                                            </td>
                                            <td style="margin: 2px; padding: 2px">
                                                <telerik:RadButton ID="btn_StartFormTrigger" runat="server"
                                                    meta:resourcekey="btn_StartFormTriggerResource1" CausesValidation="False"
                                                    Text="設定" OnClick="btn_StartFormTrigger_Click1">
                                                </telerik:RadButton>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblEndFormTriggerTitle" runat="server" Text="表單結案事件設定" meta:resourcekey="lblEndFormTriggerTitleResource1"></asp:Label>:
                                            </td>
                                            <td style="margin: 2px; padding: 2px">
                                                <asp:DropDownList ID="ddlEndFormTrigger" runat="server" meta:resourcekey="ddlEndFormTriggerResource1">
                                                </asp:DropDownList>
                                            </td>
                                            <td style="margin: 2px; padding: 2px">
                                                <telerik:RadButton ID="btn_EndFormTrigger" runat="server"
                                                    meta:resourcekey="btn_EndFormTriggerResource1" CausesValidation="False"
                                                    Text="設定" OnClick="btn_EndFormTrigger_Click1">
                                                </telerik:RadButton>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblChangeFormTriggerTitle" runat="server" Text="表單狀態變更設定" meta:resourcekey="lblChangeFormTriggerTitleResource1"></asp:Label>:
                                            </td>
                                            <td style="margin: 2px; padding: 2px">
                                                <asp:DropDownList ID="ddlChangeFormTrigger" runat="server" meta:resourcekey="ddlChangeFormTriggerResource1">
                                                </asp:DropDownList>
                                            </td>
                                            <td style="margin: 2px; padding: 2px">
                                                <telerik:RadButton ID="btn_ChangeFormTrigger" runat="server"
                                                    meta:resourcekey="btn_ChangeFormTriggerResource1" CausesValidation="False"
                                                    Text="設定" OnClick="btn_ChangeFormTrigger_Click1">
                                                </telerik:RadButton>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblSignFormTriggerTitle" runat="server" Text="表單簽核中事件設定" meta:resourcekey="lblSignFormTriggerTitleResource1"></asp:Label>:
                                            </td>
                                            <td style="margin: 2px; padding: 2px">
                                                <asp:DropDownList ID="ddlSignFormTrigger" runat="server" meta:resourcekey="ddlSignFormTriggerResource1">
                                                </asp:DropDownList>
                                            </td>
                                            <td style="margin: 2px; padding: 2px">
                                                <telerik:RadButton ID="btn_SignFormTrigger" runat="server"
                                                    meta:resourcekey="btn_SignFormTriggerResource1" CausesValidation="False"
                                                    Text="設定" OnClick="btn_SignFormTrigger_Click1">
                                                </telerik:RadButton>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        <asp:Label ID="lbl_WebServiceInfoSet" runat="server" meta:resourcekey="lbl_WebServiceInfoSetResource1"
                            Text="Web Service相關設定"></asp:Label>
                    </td>
                    <td class="PopTableRightTD" style="text-align: left; margin: 0; padding: 0">
                        <table cellpadding="0" cellspacing="0" style="width: 100%; text-align: left; margin: 0; padding: 0">
                            <tr>
                                <td class="PopTableRightTD">
                                    <table width="100%">
                                        <tr>
                                            <td>
                                                <asp:CheckBox ID="chk_CallBackFlag" runat="server" meta:resourcekey="chk_CallBackFlagResource1"
                                                    Text="表單結案時需要呼叫Web Service:" />
                                            </td>
                                            <td>
                                                <asp:Panel ID="pnl_EndForm" runat="server" meta:resourcekey="pnl_EndFormResource1">
                                                    <asp:DropDownList ID="list_EndForm" runat="server" meta:resourcekey="list_EndFormResource1">
                                                    </asp:DropDownList>
                                                    <telerik:RadButton ID="btn_SetEndForm" runat="server"
                                                        CausesValidation="False" meta:resourcekey="btn_SetEndFormResource1" Text="設定" OnClick="btn_SetEndForm_Click1">
                                                    </telerik:RadButton>
                                                </asp:Panel>
                                            </td>
                                        </tr>
                                        <tr id="endFormTR" style="background-color: white">
                                            <td>
                                                <asp:CheckBox ID="CheckBox1" runat="server" Checked="True" Text="傳送表單內容" meta:resourcekey="CheckBox1Resource1" />
                                            </td>
                                            <td>
                                                <asp:CheckBox ID="CheckBox2" runat="server" Text="傳送簽核意見" meta:resourcekey="CheckBox2Resource1" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:CheckBox ID="chk_CallBackValiateFlag" runat="server" Text="表單結案時需要呼叫Web Service驗證:"
                                                    meta:resourcekey="chk_CallBackValiateFlagResource1" />
                                            </td>
                                            <td>
                                                <asp:Panel ID="pnl_ValidateForm" runat="server" meta:resourcekey="pnl_ValidateFormResource1">
                                                    <asp:DropDownList ID="list_ValidateForm" runat="server" meta:resourcekey="list_ValidateFormResource1">
                                                    </asp:DropDownList>
                                                    <telerik:RadButton ID="btn_SetValidate" runat="server"
                                                        CausesValidation="False" meta:resourcekey="btn_SetValidateFormResource1"
                                                        Text="設定" OnClick="btn_SetValidate_Click1">
                                                    </telerik:RadButton>
                                                </asp:Panel>
                                            </td>
                                        </tr>
                                        <tr id="validateFormTR" style="background-color: white">
                                            <td>
                                                <asp:CheckBox ID="cbValidateContent" runat="server" Checked="True" Text="傳送表單內容"
                                                    meta:resourcekey="cbValidateContentResource1" />
                                            </td>
                                            <td>
                                                <asp:CheckBox ID="cbValidateComment" runat="server" Text="傳送簽核意見" meta:resourcekey="cbValidateCommentResource1" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:CheckBox ID="chk_RAFlag" runat="server" meta:resourcekey="chk_RAFlagResource1"
                                                    Text="表單退簽退回申請者時呼叫Web Service:" />
                                            </td>
                                            <td>
                                                <asp:Panel ID="pnl_ReturnForm" runat="server" meta:resourcekey="pnl_ReturnFormResource1">
                                                    <asp:DropDownList ID="list_ReturnForm" runat="server" meta:resourcekey="list_ReturnFormResource1">
                                                    </asp:DropDownList>
                                                    <telerik:RadButton ID="btn_SetReturnForm" runat="server"
                                                        CausesValidation="False" meta:resourcekey="btn_SetReturnFormResource1"
                                                        Text="設定" OnClick="btn_SetReturnForm_Click1">
                                                    </telerik:RadButton>
                                                </asp:Panel>
                                            </td>
                                        </tr>
                                        <tr id="returnFormTR" style="background-color: white">
                                            <td>
                                                <asp:CheckBox ID="CheckBox3" runat="server" Checked="True" Text="傳送表單內容" meta:resourcekey="CheckBox3Resource1" />
                                            </td>
                                            <td>
                                                <asp:CheckBox ID="CheckBox4" runat="server" Text="傳送簽核意見" meta:resourcekey="CheckBox4Resource1" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </telerik:RadPageView>
        <telerik:RadPageView ID="RadPageView3" runat="server" meta:resourcekey="RadPageView3Resource1">
            <table cellspacing="1" class="PopTable" width="100%">
                <tr>
                    <td colspan="4" class="PopTableHeader" align="center">
                        <center>
                                    <asp:Label ID="lblInformSetting" runat="server" meta:resourcekey="lblInformSettingResource1"
                                        Text="通知設定"></asp:Label></center>
                    </td>
                </tr>
                <tr>
                    <td style="height: 30px" class="PopTableLeftTD">
                        <asp:Label ID="lblEnfFormInformSetting" runat="server" meta:resourcekey="lblEnfFormInformSettingResource1"
                            Text="結案通知設定"></asp:Label>
                    </td>
                    <td style="height: 30px;" class="PopTableRightTD">
                        <asp:Label ID="lblDescribeInformSetting" runat="server" Text="請勾選需發送表單結案訊息通知的角色："
                            meta:resourcekey="lblDescribeInformSettingResource1"></asp:Label>
                        <br />
                        <asp:CheckBox ID="cbApplicant" runat="server" Checked="True" Text="申請者" meta:resourcekey="cbApplicantResource1" />
                        <br />
                        <asp:CheckBox ID="cbAuthorizer" runat="server" Checked="True" Text="簽核者" meta:resourcekey="cbAuthorizerResource1" />
                        <br />
                        <asp:CheckBox ID="cbInform" runat="server" Checked="True" Text="知會人員" meta:resourcekey="cbInformResource1" />
                        <br />
                        <asp:CheckBox ID="cbArchive" runat="server" Text="歸檔者" meta:resourcekey="cbArchiveResource1" />
                        <br />
                        <asp:CheckBox ID="cbLastAuthorizer" runat="server" Checked="True" Text="最後一站簽核者" meta:resourcekey="cbLastAuthorizerResource1" />
                        <br />
                        <asp:Label ID="lblInformMessage" runat="server" CssClass="SizeMemo" Style="color: Blue"
                            Text="*以下人員一定會收到結案通知：<br />&nbsp;(1)表單結案通知設定的人員<br />&nbsp;(2)結案站點的簽核後知會人員"
                            meta:resourcekey="lblInformMessageResource1"></asp:Label>
                    </td>
                </tr>
            </table>
        </telerik:RadPageView>
        <telerik:RadPageView ID="RadPageView4" runat="server" meta:resourcekey="RadPageView1Resource4">
            <table class="PopTable" style="width:100%">
                <tr>
                    <td colspan="2" class="PopTableHeader" style="text-align:center !important">
                            <asp:Label ID="lblSetting" runat="server" meta:resourcekey="lblSettingResource1"
                                Text="主題設定"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td class="PopTableLeftTD">
                        <asp:Label ID="lblThemeSetting" runat="server" meta:resourcekey="lblThemeSettingResource1"
                            Text="主題樣式"></asp:Label>
                    </td>
                    <td class="PopTableRightTD">
                        <asp:RadioButtonList ID="rblTheme" runat="server" RepeatDirection="Horizontal">
                            <asp:ListItem Text="經典" Value="Classic" meta:resourcekey="rblThemeListItemResource1"></asp:ListItem>
                            <asp:ListItem Text="簡約" Value="Simple" meta:resourcekey="rblThemeListItemResource2"></asp:ListItem>
                            <asp:ListItem Text="傳統(一列一欄)" Value="Tradition" Selected="true" meta:resourcekey="rblThemeListItemResource3"></asp:ListItem>
                        </asp:RadioButtonList>
                    </td>
                </tr>
            </table>
        </telerik:RadPageView>
    </telerik:RadMultiPage>

    <asp:Label ID="lblTestMsg500" runat="server" Text="呼叫Web Method錯誤" Visible="False" meta:resourcekey="lblTestMsg500Resource1"></asp:Label>
    <asp:Label ID="lblTestMsg401" runat="server" Text="無法認證通過" Visible="False" meta:resourcekey="lblTestMsg401Resource1"></asp:Label>
    <asp:Label ID="lblTestMsg404" runat="server" Text="無法呼叫asmx檔案" Visible="False" meta:resourcekey="lblTestMsg404Resource1"></asp:Label>
    <asp:Label ID="lblTestMsg99" runat="server" Text="無法連線Web Service主機" Visible="False" meta:resourcekey="lblTestMsg99Resource1"></asp:Label>
    <asp:Label ID="lblTestMsg" runat="server" Text="測試成功!!" Visible="False" meta:resourcekey="lblTestMsgResource1"></asp:Label>
    <asp:Label ID="lblNormalNotify" runat="server" meta:resourcekey="lblNormalNotifyResource1" Visible="False"></asp:Label>
    <asp:Label ID="lbltestConnection" runat="server" Text="測試連線" Visible="False" meta:resourcekey="lbltestConnectionResource1"></asp:Label>
    <asp:Label ID="lblSetWS" runat="server" Text="設定" Visible="False" meta:resourcekey="lblSetWSResource1"></asp:Label>
    <asp:Label ID="lblConfirm" runat="server" Text="是否要刪除歸檔處理者" Visible="False" meta:resourcekey="lblConfirmResource1"></asp:Label>
    <asp:Label ID="lblConfirmReader" runat="server" Text="是否要刪除表單查閱者" Visible="False" meta:resourcekey="lblConfirmReaderResource1"></asp:Label>

    <asp:HiddenField ID="hidden_EndForm" runat="server" />
    <asp:HiddenField ID="hidden_ReturnForm" runat="server" />
    <asp:HiddenField ID="hidden_Validate" runat="server" />
    <asp:HiddenField ID="hidden_StartFormTrigger" runat="server" />
    <asp:HiddenField ID="hidden_EndFormTrigger" runat="server" />
    <asp:HiddenField ID="hidden_ChangeFormTrigger" runat="server" />
    <asp:HiddenField ID="hidden_SignFormTrigger" runat="server" />
    <asp:HiddenField ID="hidden_ChangeResultFormTrigger" runat="server" />
    <asp:HiddenField ID="hidden_ReturnFormTrigger" runat="server" />
    <asp:HiddenField ID="hidden_oldFormName" runat="server" />
</asp:Content>
