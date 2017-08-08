<%@ Page Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" Inherits="EIP_Plant_CreateClass" Title="新增類別" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="CreateClass.aspx.cs" %>

<%@ Register Src="../../Common/ChoiceCenter/UC_ChoiceList.ascx" TagName="UC_ChoiceList" TagPrefix="uc1" %>
    
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script type="text/javascript">
        Sys.Application.add_load(function () {
            var rbNoLimit = $('#<%=rbNoLimit.ClientID %>');
            if (rbNoLimit.prop("checked")) {
                IsExamine(0);
            }
        });

        function IsExamine(i) {
            if (i == 1) {
                $('#<%=trByExamine.ClientID%>').prop('hidden', false);
            }
            else {
                $('#<%=trByExamine.ClientID%>').prop('hidden', true);
            }            
        }
        function rbClick(i) {
                var usedays = $find("<%=rncUseDay.ClientID%>");
            if (i == 0) {
                usedays.enable();
            }
            else {
                usedays.disable();
            }
        }

        function AlertPlantExaming() {
            alert($("#<%=lblPlantExaming.ClientID%>").text());        
        }
    </script>
    <asp:CustomValidator ID="CustomValidator1" runat="server" Display="Dynamic" ForeColor="Red" ErrorMessage="無管理類別權限" meta:resourcekey="CustomValidator1Resource1"></asp:CustomValidator>
   <asp:CustomValidator ID="CustomValidator2" runat="server" Display="Dynamic" ForeColor="Red" ErrorMessage="類別名稱重複" meta:resourcekey="CustomValidator2Resource1"></asp:CustomValidator>
    <table cellspacing="1" class="PopTable">
        <tr>
            <td>
                <span style="color: #ff0000">*</span><asp:Label ID="lbName" runat="server" Text="名稱" meta:resourcekey="lbNameResource1"></asp:Label></td>
            <td>
                <asp:TextBox ID="txbName" runat="server" MaxLength="50" meta:resourcekey="txbNameResource1"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txbName" ForeColor="Red"
                    Display="Dynamic" ErrorMessage="不允許空白" meta:resourcekey="RequiredFieldValidator1Resource1"></asp:RequiredFieldValidator></td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="lbCustodian" runat="server" Text="保管人" meta:resourcekey="lbCustodianResource1"></asp:Label></td>
            <td>
                <uc1:UC_ChoiceList ID="UC_ChoiceList1" runat="server" />
            </td>
        </tr>
        <tr>
            <td style="white-space:nowrap;">
                <asp:Label ID="lblIsMeetingRoom" runat="server" Text="會議室場地" 
                    meta:resourcekey="lblIsMeetingRoomResource1" ></asp:Label>
            </td>
            <td>
                <asp:RadioButtonList ID="rbIsMeetingRoom" runat="server" 
                    RepeatDirection="Horizontal" meta:resourcekey="rbIsMeetingRoomResource1">
                <asp:ListItem Value="Y" Text="是" meta:resourcekey="ListItemResource1"></asp:ListItem>
                <asp:ListItem Value="N" Text="否" Selected="True" 
                        meta:resourcekey="ListItemResource2"></asp:ListItem>
                </asp:RadioButtonList>
            </td>
        </tr>
                <tr>
            <td style="white-space: nowrap;">
                <asp:Label ID="Label1" runat="server" Text="借用限制" meta:resourcekey="Label1Resource1"></asp:Label>
            </td>
            <td style="white-space: nowrap;">
                <table>
                    <tr>
                        <td style="white-space: nowrap;">
                            <asp:RadioButton ID="rdbtnIsUseDay" runat="server" Text="可借用到系統日之後幾天" GroupName="Limit" onclick="rbClick(0)" meta:resourcekey="rdbtnIsUseDayResource1" />
                        </td>
                        <td>
                            <telerik:RadNumericTextBox ID="rncUseDay" runat="server" CssClass="RightAligned" Value="0" MinValue="0" Width="60px" DataType="System.Int32" Culture="zh-TW" DbValueFactor="1" LabelWidth="24px" meta:resourcekey="rncUseDayResource1">
                                <NegativeStyle Resize="None"></NegativeStyle>

                                <NumberFormat ZeroPattern="n" DecimalDigits="0"></NumberFormat>

                                <EmptyMessageStyle Resize="None"></EmptyMessageStyle>

                                <ReadOnlyStyle Resize="None"></ReadOnlyStyle>

                                <FocusedStyle Resize="None"></FocusedStyle>

                                <DisabledStyle Resize="None"></DisabledStyle>

                                <InvalidStyle Resize="None"></InvalidStyle>

                                <HoveredStyle Resize="None"></HoveredStyle>

                                <EnabledStyle Resize="None"></EnabledStyle>
                            </telerik:RadNumericTextBox>
                            <asp:Label ID="lblDay" runat="server" Text="天" meta:resourcekey="lblDayResource1"></asp:Label>
                        </td>
                        <td style="width: 20px; white-space: nowrap;"></td>
                        <td style="width: 100px;">
                            <asp:RadioButton ID="rdbtnNoUse" runat="server" Text="不限定" GroupName="Limit" Checked="True" onclick="rbClick(1)" meta:resourcekey="rdbtnNoUseResource1" />
                        </td>
                    </tr>
                </table>
                <asp:Label ID="lblNoticeMsg1" runat="server" Text="例如：系統日期是1/1，如設定3天，則可借用到1/3。" ForeColor="Blue" meta:resourcekey="lblNoticeMsg1Resource1"></asp:Label>
            </td>
        </tr>
        <tr>
            <td style="white-space: nowrap;">
                <asp:Label ID="Label3" runat="server" Text="借用申請方式" meta:resourcekey="Label3Resource1"></asp:Label>
            </td>
            <td>
                <table>
                    <tr>                        
                        <td colspan="3">
                            <asp:RadioButton ID="rbByExamine" runat="server" Text="由設備借用單借用" GroupName="Apply" onclick="IsExamine(1)" meta:resourcekey="rbByExamineResource1" />                                                   
                        </td>
                        
                    </tr>
                    <tr id="trByExamine" runat="server">
                        <td></td>
                        <td>
                            &nbsp;&nbsp;
                            <asp:Label ID="Label4" runat="server" Text="核准後，設備狀態更新為" meta:resourcekey="Label4Resource1"></asp:Label>
                            &nbsp;&nbsp;
                        </td>
                        <td>                            
                            <asp:RadioButtonList ID="rblStatus" runat="server"
                                        RepeatDirection="Horizontal">
                                        <asp:ListItem Selected="True" Value="Booking" Text="預約" meta:resourcekey="ListItemResource3"></asp:ListItem>
                                        <asp:ListItem Value="Loaned" Text="已借出" meta:resourcekey="ListItemResource4"></asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            <asp:RadioButton ID="rbNoLimit" runat="server" Text="由行事曆借用" GroupName="Apply" Checked="True" onclick="IsExamine(0)" meta:resourcekey="rbNoLimitResource1" />                                                   
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <%--<tr>
            <td>
                <asp:Label ID="Label3" runat="server" Text="借用申請" meta:resourcekey="Label3Resource1" ></asp:Label>
            </td>
            <td>
                <table>
                    <tr>
                        <td colspan="3">
                            <asp:CheckBox ID="cbIsExanine" runat="server" onClick="IsExamine()" Text="僅可由設備借用申請單進行申請" meta:resourcekey="cbIsExanineResource1"/>
                        </td>
                    </tr>
                    <tr id="trByExamine" runat="server">
                        <td></td>
                        <td>
                            &nbsp;&nbsp;
                            <asp:Label ID="Label4" runat="server" Text="核准後，設備狀態更新為" meta:resourcekey="Label4Resource1"></asp:Label>
                            &nbsp;&nbsp;
                        </td>
                        <td>                            
                            <asp:RadioButtonList ID="rblStatus" runat="server"
                                        RepeatDirection="Horizontal">
                                        <asp:ListItem Selected="True" Value="Booking" Text="預約" meta:resourcekey="ListItemResource3"></asp:ListItem>
                                        <asp:ListItem Value="Loaned" Text="已借出" meta:resourcekey="ListItemResource4"></asp:ListItem>
                            </asp:RadioButtonList>     
                        </td>
                    </tr>
                </table>
            </td>
        </tr>--%>
    </table>
    <asp:Label ID="lbClassGuid" runat="server" Visible="False" meta:resourcekey="lbClassGuidResource1"></asp:Label>
    <asp:Label ID="lblPlantExaming" runat="server" style="display:none;" Text="尚有設備借用申請單在簽核中" meta:resourcekey="lblPlantExamingResource1"></asp:Label>    
</asp:Content>

