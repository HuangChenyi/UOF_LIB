<%@ Page Title="離線保全設定" Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" CodeBehind="DocOfflineSecuritySetting.aspx.cs" Inherits="Ede.Uof.Web.DMS.DocStore.DocOfflineSecuritySetting" culture="auto" meta:resourcekey="PageResource1" uiculture="auto" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script type="text/javascript">
        function DownloadFileWithHandler(sHandlerUrl, sUserProxyIndex) {
            $uof.download(sHandlerUrl, sUserProxyIndex);
        }

    </script>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table class="PopTable">
                <tr>
                    <td style="width: 25%">
                        <span style="color: #ff0000">*</span>
                        <asp:Label ID="lblDocPW" runat="server" Text="密碼" meta:resourcekey="lblDocPWResource1"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" MaxLength="20" Width="200px" BorderStyle="Groove" meta:resourcekey="txtPasswordResource1"></asp:TextBox>
                        <asp:CustomValidator ID="cvRequiredPassword" runat="server" Display="Dynamic" ErrorMessage="必填" meta:resourcekey="cvRequiredPasswordResource1"></asp:CustomValidator>
                    </td>
                </tr>
                <tr>
                    <td style="width: 25%">
                        <span style="color: #ff0000">*</span>
                        <asp:Label ID="Label1" runat="server" Text="確認密碼" meta:resourcekey="Label1Resource1"></asp:Label>
                    </td>
                    <td>
                        <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" MaxLength="20" Width="200px" BorderStyle="Groove" meta:resourcekey="txtConfirmPasswordResource1"></asp:TextBox>
                        <asp:CompareValidator ID="CompareConfirmPassword" runat="server" ControlToCompare="txtPassword"
                            ControlToValidate="txtConfirmPassword" Display="Dynamic" ErrorMessage="密碼不符,請重新輸入密碼" ForeColor="Red"
                            SetFocusOnError="True" meta:resourcekey="CompareConfirmPasswordResource1" ></asp:CompareValidator>
                        <asp:CustomValidator ID="cvRequiredConfirmPassword" runat="server" Display="Dynamic" ErrorMessage="必填" meta:resourcekey="cvRequiredConfirmPasswordResource1"></asp:CustomValidator>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lblDocOpenTimes" runat="server" Text="可開啟次數" meta:resourcekey="lblDocOpenTimesResource1"></asp:Label>
                    </td>
                    <td>
                        <telerik:RadNumericTextBox ID="rntxDocOpenTimes" runat="server" Width="200px" DataType="System.Int32" Culture="zh-TW" DbValueFactor="1" LabelCssClass="" LabelWidth="64px" meta:resourcekey="rntxDocOpenTimesResource1">
                            <NegativeStyle Resize="None"></NegativeStyle>
                            <NumberFormat ZeroPattern="n" AllowRounding="False" DecimalDigits="0" GroupSeparator="" GroupSizes="3"></NumberFormat>
                            <EmptyMessageStyle Resize="None"></EmptyMessageStyle>
                            <ReadOnlyStyle Resize="None"></ReadOnlyStyle>
                            <FocusedStyle Resize="None"></FocusedStyle>
                            <DisabledStyle Resize="None"></DisabledStyle>
                            <InvalidStyle Resize="None"></InvalidStyle>
                            <HoveredStyle Resize="None"></HoveredStyle>
                            <EnabledStyle Resize="None"></EnabledStyle>
                        </telerik:RadNumericTextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lblExpiryDate" runat="server" Text="有效日期" meta:resourcekey="lblExpiryDateResource1"></asp:Label>
                    </td>
                    <td>
                        <telerik:RadDatePicker ID="rdpExpiryDate" runat="server" Culture="zh-TW" meta:resourcekey="rdpExpiryDateResource1">
                            <Calendar Culture="zh-TW" EnableWeekends="True" FastNavigationNextText="&amp;lt;&amp;lt;" UseColumnHeadersAsSelectors="False" UseRowHeadersAsSelectors="False">
                            </Calendar>
                            <DateInput DateFormat="yyyy/M/d" DisplayDateFormat="yyyy/M/d" LabelWidth="64px" Width="">
                                <EmptyMessageStyle Resize="None" />
                                <ReadOnlyStyle Resize="None" />
                                <FocusedStyle Resize="None" />
                                <DisabledStyle Resize="None" />
                                <InvalidStyle Resize="None" />
                                <HoveredStyle Resize="None" />
                                <EnabledStyle Resize="None" />
                            </DateInput>
                            <DatePopupButton CssClass="" HoverImageUrl="" ImageUrl="" />
                        </telerik:RadDatePicker>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lblLimitIP" runat="server" Text="IP限定" meta:resourcekey="lblLimitIPResource1"></asp:Label>
                    </td>
                    <td>
                        <table>
                            <tr>
                                <td style="resize: vertical;">
                                    <asp:Repeater ID="IPRangerRepeater" runat="server" OnItemDataBound="IPRangerRepeater_ItemDataBound">
                                        <HeaderTemplate>
                                            <table>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <tr>
                                                <td>
                                                    <telerik:RadTextBox ID="rtxtIPStart" runat="server" Width="200px" LabelCssClass="" LabelWidth="64px" meta:resourcekey="rtxtIPStartResource1" Resize="None">
                                                        <EmptyMessageStyle Resize="None" />
                                                        <ReadOnlyStyle Resize="None" />
                                                        <FocusedStyle Resize="None" />
                                                        <DisabledStyle Resize="None" />
                                                        <InvalidStyle Resize="None" />
                                                        <HoveredStyle Resize="None" />
                                                        <EnabledStyle Resize="None" />
                                                    </telerik:RadTextBox>
                                                    <asp:RegularExpressionValidator
                                                        ID="RegularExpressionValidator4" runat="server" ControlToValidate="rtxtIPStart"
                                                        Display="Dynamic" ErrorMessage="IP格式不正確" SetFocusOnError="True" ValidationExpression="^([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}$" meta:resourcekey="RegularExpressionValidator4Resource1"></asp:RegularExpressionValidator>
                                                    <asp:CustomValidator ID="cvFillInIPStart" runat="server" Display="Dynamic" ErrorMessage="請填入ip位址" meta:resourcekey="cvFillInIPStartResource1"></asp:CustomValidator>
                                                    <asp:Label ID="Label2" runat="server" Text="~" meta:resourcekey="Label2Resource1"></asp:Label>
                                                    <telerik:RadTextBox ID="rtxtIPEnd" runat="server" Width="200px" LabelCssClass="" LabelWidth="64px" meta:resourcekey="rtxtIPEndResource1" Resize="None">
                                                        <EmptyMessageStyle Resize="None" />
                                                        <ReadOnlyStyle Resize="None" />
                                                        <FocusedStyle Resize="None" />
                                                        <DisabledStyle Resize="None" />
                                                        <InvalidStyle Resize="None" />
                                                        <HoveredStyle Resize="None" />
                                                        <EnabledStyle Resize="None" />
                                                    </telerik:RadTextBox>
                                                    <asp:RegularExpressionValidator
                                                        ID="RegularExpressionValidator1" runat="server" ControlToValidate="rtxtIPEnd"
                                                        Display="Dynamic" ErrorMessage="IP格式不正確" SetFocusOnError="True" ValidationExpression="^([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}$" meta:resourcekey="RegularExpressionValidator1Resource1"></asp:RegularExpressionValidator>
                                                    <asp:CustomValidator ID="cvFillInIPEnd" runat="server" Display="Dynamic" ErrorMessage="請填入ip位址" meta:resourcekey="cvFillInIPEndResource1"></asp:CustomValidator>
                                                    <asp:CustomValidator ID="cvRangeCheck" runat="server" Display="Dynamic" ErrorMessage="IP區段設定不正確" SetFocusOnError="True" meta:resourcekey="cvRangeCheckResource1"></asp:CustomValidator>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                        <FooterTemplate>
                                            </table>
                                        </FooterTemplate>
                                    </asp:Repeater>
                                </td>
                                <td style="vertical-align: bottom;">
                                    <table>
                                        <tr>
                                            <td style="padding: 0px 0px 5px 1px;">
                                                <asp:ImageButton ID="ibtnAddLimitIP" runat="server" ImageUrl="~/Common/Images/Icon/icon_j13.gif" ToolTip="新增" OnClick="ibtnAddLimitIP_Click" meta:resourcekey="ibtnAddLimitIPResource1" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lblCustomFileName" runat="server" Text="自訂檔名" meta:resourcekey="lblCustomFileNameResource1"></asp:Label>
                    </td>
                    <td>
                        <telerik:RadTextBox ID="txtCustomFileName" runat="server" Width="200px" LabelCssClass="" LabelWidth="64px" meta:resourcekey="txtCustomFileNameResource1" Resize="None">
                            <EmptyMessageStyle Resize="None" />
                            <ReadOnlyStyle Resize="None" />
                            <FocusedStyle Resize="None" />
                            <DisabledStyle Resize="None" />
                            <InvalidStyle Resize="None" />
                            <HoveredStyle Resize="None" />
                            <EnabledStyle Resize="None" />
                        </telerik:RadTextBox>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lblComment" runat="server" Text="備註" meta:resourcekey="lblCommentResource1"></asp:Label>
                    </td>
                    <td>
                        <telerik:RadTextBox ID="txtComment" runat="server" TextMode="MultiLine" Width="100%" Height="150px" LabelCssClass="" LabelWidth="64px" meta:resourcekey="txtCommentResource1" Resize="None">
                            <EmptyMessageStyle Resize="None" />
                            <ReadOnlyStyle Resize="None" />
                            <FocusedStyle Resize="None" />
                            <DisabledStyle Resize="None" />
                            <InvalidStyle Resize="None" />
                            <HoveredStyle Resize="None" />
                            <EnabledStyle Resize="None" />
                        </telerik:RadTextBox>
                    </td>
                </tr>
            </table>
            <asp:Literal ID="scriptZone" runat="server" meta:resourcekey="scriptZoneResource1"></asp:Literal>
            <asp:HiddenField ID="hidIPValue" runat="server" />
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
