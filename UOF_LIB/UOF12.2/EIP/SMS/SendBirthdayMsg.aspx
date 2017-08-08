<%@ Page Title="預約發送" Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" CodeBehind="SendBirthdayMsg.aspx.cs" Inherits="Ede.Uof.Web.EIP.SMS.SendBirthdayMsg" culture="auto" meta:resourcekey="PageResource1" uiculture="auto" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script type="text/javascript">
        Sys.Application.add_load(function () {
            chkSMSLen(0);
            GetSelectData();
        });

        function GetSelectData()
        {
            var curwindow = $uof.dialog.getOpener();
            var pd;
            if (curwindow) {
                pd = curwindow.document;
            } else if (typeof (dialogArguments) != "undefined") {
                pd = dialogArguments.document;
            }

            if (pd) {                
                $("#<%=hfGetSendUsers.ClientID%>").val($("#<%=Request["ClientID"]%>", pd).val());
                $("#<%=hfStartDate.ClientID%>").val("<%=Request["StartDate"]%>"); 
            }
        }
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

        function rbClick(i) {
            var rdDate = $find("<%= rdDate.ClientID %>");
            if (i == 0) {
                rdDate.set_enabled(false);
            }
            else {
                rdDate.set_enabled(true);
            }
        }
    </script>
    <table class="PopTable" cellspacing="1" width="100%">
        <tr>
            <td style="white-space: nowrap;">
                <asp:Label ID="Label1" runat="server" Text="發送日期" meta:resourcekey="Label1Resource1"></asp:Label>
            </td>
            <td style="white-space: nowrap;">
                <table >
                    <tr>
                        <td colspan="2">
                            <asp:RadioButton ID="rdbtnCurrent" runat="server" GroupName="sendDate" Text="生日當天" Checked="True" onclick="rbClick(0)" meta:resourcekey="rdbtnCurrentResource1"/>
                            <asp:Label ID="lblYear" runat="server" Text="({0}年)" meta:resourcekey="lblYearResource1"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td style="white-space: nowrap;">
                            <asp:RadioButton ID="rdbtnOther" runat="server" GroupName="sendDate" Text="指定日期" onclick="rbClick(1)" meta:resourcekey="rdbtnOtherResource1"/>
                        </td>
                        <td>
                            <telerik:RadDatePicker ID="rdDate" runat="server" Enabled="false">
                                <DateInput runat="server" ClientEvents-OnValueChanging="OnValueChanging"></DateInput>
                            </telerik:RadDatePicker>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label2" runat="server" Text="發送時間" meta:resourcekey="Label2Resource1"></asp:Label>
            </td>
            <td>
                <telerik:RadTimePicker ID="rdTime" runat="server">
                    <DateInput runat="server">
                        <ClientEvents OnValueChanging="OnValueChanging" />
                    </DateInput>
                </telerik:RadTimePicker>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="Label3" runat="server" Text="內容" meta:resourcekey="Label3Resource1"></asp:Label>
            </td>
            <td>
                <table>
                    <tr>
                        <td>
                            <asp:TextBox ID="txtContent" runat="server" Height="120px" Width="100%"
                                TextMode="MultiLine" onkeyup="chkSMSLen(0)" MaxLength="100" meta:resourcekey="txtContentResource1"></asp:TextBox>
                            <br />
                            <asp:RequiredFieldValidator ID="rfvContent" runat="server" Display="Dynamic" ForeColor="Red"
                                ErrorMessage="簡訊內容不可空白" ControlToValidate="txtContent" meta:resourcekey="rfvContentResource1"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <asp:Label ID="Label5" runat="server" Text="共輸入了" meta:resourcekey="Label5Resource1"></asp:Label>
                            <asp:Label ID="lbcounter" runat="server" Text="0" meta:resourcekey="lbcounterResource1"></asp:Label>
                            <asp:Label ID="Label9" runat="server" Text="個字，約須" meta:resourcekey="Label9Resource1"></asp:Label>
                            <asp:Label ID="lbsmscnts_need" runat="server" Text="0" meta:resourcekey="lbsmscnts_needResource1"></asp:Label>
                            <asp:Label ID="Label7" runat="server" Text="則訊息傳送。" meta:resourcekey="Label7Resource1"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                                        <telerik:RadButton ID="btnInsertCanMSG" runat="server" Text="插入罐頭簡訊" CausesValidation="False" OnClick="btnInsertCanMSG_Click"></telerik:RadButton>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" class="SizeMemo">
                                        <asp:Label ID="Label4" runat="server" ForeColor="Blue"
                                            Text="※ {#user} 為變數,發送時會由選取的人員姓名所取代" meta:resourcekey="Label4Resource1"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" class="SizeMemo">
                                        <asp:Label ID="Label8" runat="server" ForeColor="Blue"
                                            Text="※為使簡訊內容正常呈現於手機中，請勿在簡訊內容中填入~ ` ^ { } [ ] | < >等特殊符號。" meta:resourcekey="Label8Resource1"></asp:Label>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <asp:HiddenField ID="hfGetSendUsers" runat="server" />
    <asp:HiddenField ID="hfStartDate" runat="server" />
    <asp:HiddenField ID="hfMsgID" runat="server" />
    <asp:HiddenField ID="hfBirthday" runat="server" />
    <asp:HiddenField ID="hfPhone" runat="server" />
    <asp:HiddenField ID="hfYear" runat="server" />
    <asp:HiddenField ID="hfCurrentUser" runat="server" />
    <asp:Label ID="lblSMSConnectFail" runat="server" Text="預約發送失敗，請至簡訊管理確認連線是否正常。" Visible="False" meta:resourcekey="lblSMSConnectFailResource1"></asp:Label>
</asp:Content>
