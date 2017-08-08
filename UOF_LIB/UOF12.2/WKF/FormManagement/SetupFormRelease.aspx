<%@ Page Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" Inherits="WKF_FormManagement_SetupFormRelease" Title="設定發佈資訊" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="SetupFormRelease.aspx.cs" %>
<%@ Register Src="../../Common/ChoiceCenter/UC_ChoiceList.ascx" TagName="UC_ChoiceList" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

<script id="redirectjs" type="text/javascript">
    //導頁
    function RedirectPage(url) {
        window.location = url;
        return false;
    }
</script>

    <table width="100%">
        <tr>
            <td>
                <table>
                    <tr>
                        <td>
                            <telerik:RadButton ID="ibtnDesignField" runat="server" Text="1.設計欄位>>" CausesValidation="False"
                                meta:resourcekey="ibtnDesignFieldResource1" OnClick="ibtnSetup_Click">
                            </telerik:RadButton>
                        </td>
                        <td>
                            <telerik:RadButton ID="ibtnSetupCondition" runat="server" Text="2.設定條件>>" CausesValidation="False"
                                meta:resourcekey="ibtnSetupConditionResource1" OnClick="ibtnSetup_Click">
                            </telerik:RadButton>
                        </td>
                        <td>
                            <telerik:RadButton ID="ibtnSetupNotify" runat="server" Text="3.設定起結案通知>>" CausesValidation="False"
                                meta:resourcekey="ibtnSetupNotifyResource1" OnClick="ibtnSetup_Click">
                            </telerik:RadButton>
                        </td>
                        <td>
                            <telerik:RadButton ID="ibtnDesignFlow" runat="server" Text="4.設定流程>>" CausesValidation="False"
                                meta:resourcekey="ibtnDesignFlowResource1" OnClick="ibtnSetup_Click">
                            </telerik:RadButton>
                        </td>
                        <td>
                            <telerik:RadButton ID="ibtnSetupRelease" runat="server" Text="5.設定發佈資訊>>" CausesValidation="False"
                                meta:resourcekey="ibtnSetupReleaseResource1">
                            </telerik:RadButton>
                        </td>
                        <td>
                            <telerik:RadButton ID="ibtnSetupMail" runat="server" Text="6.設定郵件樣板>>" CausesValidation="False"
                                meta:resourcekey="ibtnSetupMailResource1" OnClick="ibtnSetup_Click">
                            </telerik:RadButton>
                        </td>
                                                <td>
                            <telerik:RadButton ID="ibtnSetupDes" runat="server" Text="7.設定使用說明>>" OnClick="ibtnSetup_Click" 
                                CausesValidation="False" meta:resourcekey="ibtnSetupDesResource1">
                            </telerik:RadButton>
                        </td>      
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td style="height: 162px" valign="top">
                <table width="100%" class="PopTable" cellspacing="1">
                    <colgroup class="PopTableLeftTD">
                    </colgroup>
                    <colgroup class="PopTableRightTD">
                    </colgroup>
                    <colgroup class="PopTableLeftTD">
                    </colgroup>
                    <colgroup class="PopTableRightTD">
                    </colgroup>
                    <tr>
                        <td>
                            <asp:Label ID="lblFormType" runat="server" Text="表單類別" meta:resourcekey="lblFormTypeResource1"></asp:Label></td>
                        <td>
                            <asp:Label ID="lblFormCategory" runat="server" meta:resourcekey="lblFormCategoryResource1"></asp:Label></td>
                        <td>
                            <asp:Label ID="lblFormNameTitle" runat="server" Text="表單名稱" meta:resourcekey="lblFormNameTitleResource1"></asp:Label></td>
                        <td>
                            <asp:Label ID="lblFormName" runat="server" meta:resourcekey="lblFormNameResource1"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="lblFormVersion" runat="server" Text="版本" meta:resourcekey="lblFormVersionResource1"></asp:Label></td>
                        <td colspan="3">&nbsp;<asp:TextBox ID="txtVersionID" runat="server" Enabled="False"
                            Style="text-align: right" Width="34px" meta:resourcekey="txtVersionIDResource1"></asp:TextBox>
                            <asp:Label ID="Label2" runat="server" Text="●" meta:resourcekey="Label2Resource1"></asp:Label>
                            <asp:TextBox ID="txtVersion" runat="server" Enabled="False" Style="text-align: right"
                                Width="43px" meta:resourcekey="txtVersionResource1"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="lblVersionUser" runat="server" Text="自動發佈時間" meta:resourcekey="lblVersionUserResource1"></asp:Label></td>
                        <td colspan="3" valign="top">
                            <table border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td>
                                        <asp:RadioButton ID="rbDateRelease" runat="server" GroupName="isRelease" Checked="True"
                                            Text="指定時間" meta:resourcekey="rbDateReleaseResource1" />
                                        <br />
                                        <asp:RadioButton ID="rbNoRelease" runat="server" GroupName="isRelease" Text="不使用自動發佈"
                                            meta:resourcekey="rbNoReleaseResource1" /><br />
                                        <asp:RadioButton ID="rbNowRelease" runat="server" GroupName="isRelease" Text="立刻發佈"
                                            meta:resourcekey="rbNowReleaseResource1" /></td>
                                    <td style="vertical-align:top">
                                        <telerik:RadDateTimePicker ID="RadDatePicker1" runat="server"></telerik:RadDateTimePicker>
                                    </td>
                                </tr>
                            </table>
                            <asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="表單版本第一個欄位型態需為單行文字欄位、自動編號欄位、數值欄位"
                                Display="Dynamic" meta:resourcekey="CustomValidator1Resource1"></asp:CustomValidator>
                            <asp:CustomValidator ID="CustomValidator2" runat="server" ErrorMessage="明細欄位需有子欄位"
                                Display="Dynamic" meta:resourcekey="CustomValidator2Resource1"></asp:CustomValidator>
                            <asp:CustomValidator ID="CustomValidator3" runat="server" ErrorMessage="發伂的版本編號需大於目前已發佈的版本編號"
                                Display="Dynamic" meta:resourcekey="CustomValidator3Resource1"></asp:CustomValidator>
                            <asp:CustomValidator ID="CustomValidator4" runat="server" Display="Dynamic" ErrorMessage="表單欄位不得為空"
                                meta:resourcekey="CustomValidator4Resource1"></asp:CustomValidator></td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <asp:Label ID="lblFieldDesign" runat="server" meta:resourcekey="lblFieldDesignResource1"
        Text="1.設計欄位>>" Visible="False"></asp:Label><asp:Label ID="lblFormCondition" runat="server"
            meta:resourcekey="lblFormConditionResource1" Text="2.設定條件>>" Visible="False"></asp:Label><asp:Label
                ID="lblFormFlow" runat="server" meta:resourcekey="lblFormFlowResource1" Text="3.設定流程>>"
                Visible="False"></asp:Label><asp:Label ID="lblPublish" runat="server" meta:resourcekey="lblPublishResource1"
                    Text="5.設定發佈資訊>>" Visible="False"></asp:Label>
    <asp:Label ID="lblIssueNeedAutoNoMsg" runat="server" Text="發怖失敗!「自動編號」為必要欄位，請先至欄位設計新增此欄位!" Visible="False" meta:resourcekey="lblIssueNeedAutoNoMsgResource1"></asp:Label>
</asp:Content>
