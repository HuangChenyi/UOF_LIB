﻿<%@ Page Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" Inherits="EIP_SMS_SendMsg" Title="簡訊發送" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" CodeBehind="SendMsg.aspx.cs" %>

<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Fast" %>
<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Register Src="~/Common/ChoiceCenter/UC_ChoiceList.ascx" TagName="UC_ChoiceList" TagPrefix="uc3" %>
<%@ Register Src="~/Common/ChoiceCenter/UC_ChoiceCustomer.ascx" TagName="UC_ChoiceCustomer" TagPrefix="uc1" %>
<%@ Register Src="~/Common/ChoiceCenter/UC_ChoiceAddressBook.ascx" TagName="UC_ChoiceAddressBook" TagPrefix="uc2" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script id="UC_SiteMap" type="text/javascript">
        function chkSMSLen(kind) {
            var handle = $("#<%=txtContent.ClientID%>");
            var handlecount = $("#<%=lbcounter.ClientID%>");
            var handleneed = $("#<%=lbsmscnts_need.ClientID%>");
            var msgR = handle.val();

            handlecount.text(msgR.length);
            var maxlen = hasChinese(msgR) ? 70 : 160;
            var len = maxlen;
            var chtlmt1 = 66;
            var englmt1 = 156;

            if (handlecount.text() == 0) //無簡訊內容
            {
                handlecount.text("0");
                return null;
            }

            if (handlecount.text() <= maxlen) //如果輸入字數<=最大限制字數
            {
                handleneed.text("1");
            }
            else {
                handleneed.text("2");
            }
        }

        // == 檢查是否有中文 ....
        function hasChinese(str) {
            var i;
            var ch, cch;
            if (str.length > 0) {
                for (i = 0; i < str.length; i++) {
                    ch = '';
                    if (str.charCodeAt(i) > 127) {
                        return true;
                    }
                }
            }
            return false;
        }
    </script>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table cellspacing="1" style="width: 100%;">
                <tr>
                    <td>
                        <table class="PopTable" cellspacing="1" width="100%">
                            <tr>
                                <td nowrap="nowrap">
                                    <asp:Label ID="Label2" runat="server" Text="剩餘通數" meta:resourcekey="Label2Resource1"></asp:Label>
                                </td>
                                <td class="PopTableRightTD">
                                    <asp:Label ID="lblCredit" runat="server" Text="0" meta:resourcekey="lblCreditResource1"></asp:Label>
                                    <asp:Label ID="Label3" runat="server" Text="通" meta:resourcekey="Label3Resource1"></asp:Label>
                                    <asp:CustomValidator ID="CustomValidator1" runat="server" Display="Dynamic"
                                        ErrorMessage="無法連接到簡訊伺服器,請稍候再試或洽您的系統管理人員." meta:resourcekey="CustomValidator1Resource1"></asp:CustomValidator>
                                    <asp:Label ID="lbException" runat="server" meta:resourcekey="lbExceptionResource1"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td nowrap="nowrap">
                                    <asp:Label ID="Label11" runat="server" Text="發送對象" meta:resourcekey="Label11Resource1"></asp:Label>
                                </td>
                                <td class="PopTableRightTD">
                                    <table>
                                        <tr>
                                            <td>
                                                <table style="border: 1px #999999 solid">
                                                    <tr>
                                                        <td valign="top">
                                                            <uc3:UC_ChoiceList ID="UC_ChoiceList2" runat="server" ExpandToUser="False" AutoResize="false" TreeHeight="300" TreeWidth="150" />
                                                        </td>
                                                        <td valign="top">
                                                            <uc1:UC_ChoiceCustomer ID="UC_ChoiceCustomer1" runat="server" AutoResize="false" TreeHeight="300" TreeWidth="150" />
                                                        </td>
                                                        <td valign="top">
                                                            <uc2:UC_ChoiceAddressBook ID="UC_ChoiceAddressBook1" runat="server" AutoResize="false" TreeHeight="300" TreeWidth="150" />
                                                        </td>
                                                        <td valign="top">
                                                            <table>
                                                                <tr>
                                                                    <td nowrap="nowrap">
                                                                        <asp:Label ID="Label28" runat="server" Text="手動輸入" meta:resourcekey="Label28Resource1"></asp:Label>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                        <asp:TextBox ID="txtManual" runat="server" Height="150px" Width="300px" TextMode="MultiLine" meta:resourcekey="txtManualResource1"></asp:TextBox>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td nowrap="nowrap" style="padding-left: 20px;">
                                                                        <ol class="SizeMemo">
                                                                            <asp:Label ID="Label29" runat="server" Text="手動輸入說明" ForeColor="Blue"
                                                                                meta:resourcekey="Label29Resource1"></asp:Label><br />
                                                                            <li>
                                                                                <asp:Label ID="Label30" runat="server" Text="格式:手機號碼 空格 人名" ForeColor="Blue"
                                                                                    meta:resourcekey="Label30Resource1"></asp:Label>
                                                                            </li>
                                                                            <li>
                                                                                <asp:Label ID="Label32" runat="server" Text="人名可以省略" ForeColor="Blue"
                                                                                    meta:resourcekey="Label32Resource1"></asp:Label>
                                                                            </li>
                                                                            <li>
                                                                                <asp:Label ID="Label33" runat="server" Text="第二筆資料請打在下一行(一行代表一個人)"
                                                                                    ForeColor="Blue" meta:resourcekey="Label33Resource1"></asp:Label>
                                                                            </li>
                                                                            <li>
                                                                                <asp:Label ID="Label35" runat="server" Text="例:" ForeColor="Blue" meta:resourcekey="Label35Resource1"></asp:Label><br />
                                                                                <asp:Label ID="Label31" runat="server" Text="0912345678 宜靜" ForeColor="Blue" meta:resourcekey="Label31Resource1"></asp:Label><br />
                                                                                <asp:Label ID="Label34" runat="server" Text="0987654321 大雄" ForeColor="Blue" meta:resourcekey="Label34Resource1"></asp:Label>
                                                                            </li>
                                                                        </ol>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td nowrap="nowrap">
                                    <asp:Label ID="Label12" runat="server" Text="發送時間" meta:resourcekey="Label12Resource1"></asp:Label>
                                </td>
                                <td class="PopTableRightTD">
                                    <table>
                                        <tr>
                                            <td>
                                                <asp:RadioButton ID="rbBtnNow" Text="立即傳送" runat="server" Checked="True" GroupName="send" meta:resourcekey="rbBtnNowResource1" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td>
                                                            <asp:RadioButton ID="rbBtnReservation" Text="預約發送" runat="server" GroupName="send" meta:resourcekey="rbBtnReservationResource1" /></td>
                                                        <td>
                                                            <telerik:RadDateTimePicker ID="rdtpDate" runat="server" meta:resourcekey="rdtpDateResource1">
                                                            </telerik:RadDateTimePicker>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td style="white-space: nowrap">
                                    <asp:Label ID="Label5" runat="server" Text="簡訊主旨" meta:resourcekey="Label5Resource1"></asp:Label></td>
                                <td class="PopTableRightTD">
                                    <table>
                                        <tr>
                                            <td>
                                                <asp:TextBox ID="txtSubject" runat="server" Width="400px" meta:resourcekey="txtSubjectResource1"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="rfvSubject" runat="server" Display="Dynamic" ForeColor="Red"
                                                    ErrorMessage="簡訊主旨不可空白" ControlToValidate="txtSubject"
                                                    meta:resourcekey="rfvSubjectResource1"></asp:RequiredFieldValidator>
                                                <br />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="SizeMemo">
                                                <asp:Label ID="Label10" runat="server" Text="簡訊主旨內容不會出現於簡訊內容,也不列入簡訊字數計算"
                                                    ForeColor="Blue" meta:resourcekey="Label10Resource1"></asp:Label>
                                            </td>
                                        </tr>
                                    </table>

                                </td>
                            </tr>
                            <tr>
                                <td nowrap="nowrap">
                                    <asp:Label ID="Label6" runat="server" Text="內容" meta:resourcekey="Label6Resource1"></asp:Label></td>
                                <td class="PopTableRightTD">
                                    <table>
                                        <tr>
                                            <td>
                                                <asp:TextBox ID="txtContent" runat="server" Height="120px" Width="400px"
                                                    TextMode="MultiLine" onkeyup="chkSMSLen(0)" MaxLength="100"
                                                    meta:resourcekey="txtContentResource1"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="rfvContent" runat="server" Display="Dynamic" ForeColor="Red"
                                                    ErrorMessage="簡訊內容不可空白" ControlToValidate="txtContent"
                                                    meta:resourcekey="rfvContentResource1"></asp:RequiredFieldValidator>
                                            </td>
                                            <td>
                                                <table>
                                                    <tr>
                                                        <td>
                                                            <telerik:RadButton ID="btnInsertCanMSG" runat="server" Text="插入罐頭簡訊" CausesValidation="False" OnClick="btnInsertCanMSG_Click" meta:resourcekey="btnInsertCanMSGResource1"></telerik:RadButton>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="SizeMemo">
                                                            <asp:Label ID="Label1" runat="server" ForeColor="Blue"
                                                                Text="※ {#user} 為變數,發送時會由選取的人員姓名所取代" meta:resourcekey="Label1Resource2"></asp:Label>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="SizeMemo">
                                                            <asp:Label ID="Label8" runat="server" ForeColor="Blue"
                                                                Text="※為使簡訊內容正常呈現於手機中，請勿在簡訊內容中填入~ ` ^ { } [ ] | < >等特殊符號。"
                                                                meta:resourcekey="Label8Resource1"></asp:Label>
                                                        </td>
                                                    </tr>
                                                </table>

                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <asp:Label ID="Label4" runat="server" Text="共輸入了" meta:resourcekey="Label4Resource1"></asp:Label>
                                                <asp:Label ID="lbcounter" runat="server" Text="0" meta:resourcekey="lbcounterResource1"></asp:Label>
                                                <asp:Label ID="Label9" runat="server" Text="個字，約須" meta:resourcekey="Label9Resource1"></asp:Label>
                                                <asp:Label ID="lbsmscnts_need" runat="server" Text="0" meta:resourcekey="lbsmscnts_needResource1"></asp:Label>
                                                <asp:Label ID="Label7" runat="server" Text="則訊息傳送。" meta:resourcekey="Label7Resource1"></asp:Label>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <asp:HiddenField ID="hfdXml" runat="server" />
        </ContentTemplate>
    </asp:UpdatePanel>

    <asp:Label ID="lblSend" runat="server" Text="發送簡訊" Visible="False" meta:resourcekey="lblSendResource1"></asp:Label>
    <asp:HiddenField ID="hfCurrentUser" runat="server" />
</asp:Content>

