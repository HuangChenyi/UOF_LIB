<%@ Page Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" Inherits="EIP_Plant_CreatePlant" Title="新增場地設備" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="CreatePlant.aspx.cs" %>

<%@ Register Src="../../Common/ChoiceCenter/UC_ChoiceList.ascx" TagName="UC_ChoiceList" TagPrefix="uc1" %>
<%@ Register Src="~/Common/FileCenter/V3/UC_FileCenter.ascx" TagPrefix="uc1" TagName="UC_FileCenter" %>
<%@ Register Src="~/EIP/Plant/UC_EquipList.ascx" TagPrefix="uc1" TagName="UC_EquipList" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<script  type="text/javascript">
    Sys.Application.add_load(function () {
        var rdByClass=$('#<%=rdByClass.ClientID %>');
        if (rdByClass.prop("checked")) {
            IsExamine(0);
        }
    });
    function RemoveImage() {
        $("#<%=imgBigPicture.ClientID %>").attr('src', '').hide();
    }
    function CheckPlantMember(sender, args) {
        var plantMember = $('#<%=hfPlantMember.ClientID%>').val();
        if(plantMember =='')
        {
            args.IsValid = false;
        }
    }

    function rbClick(i) {
        var usedays = $find("<%=rncUseDay.ClientID%>");
        if (i == 1) {
            usedays.enable();
        }
        else {
            usedays.disable();
        }
    }

    function CreatePlant_checkKeyPress(sender, args) {
        var keyCharacter = args.get_keyCharacter();

        if (keyCharacter == sender.get_numberFormat().DecimalSeparator ||
            keyCharacter == sender.get_numberFormat().NegativeSign) {
            args.set_cancel(true);
        }
    }
    function IsExamine(i) {
        if (i == 1) {
            $('#<%=trByExamine.ClientID%>').prop('hidden', false);
        }
        else {
            $('#<%=trByExamine.ClientID%>').prop('hidden', true);
        }            
    }

    function AlertPlantExaming() {
        alert($("#<%=lblPlantExaming.ClientID%>").text());        
    }
</script>

    <asp:CustomValidator ID="CustomValidator2" runat="server" ForeColor="Red" ErrorMessage="您沒有維護的權限" Display="Dynamic" meta:resourcekey="CustomValidator2Resource1"></asp:CustomValidator> 
     
    <table cellspacing="1" cellpadding="1" class="PopTable">
        <tr>
            <td style=" white-space:nowrap;">
                <span style="color: #ff0000">*</span><asp:Label ID="lbLeftClass" runat="server" Text="類別" meta:resourcekey="lbLeftClassResource1"></asp:Label></td>
            <td style=" white-space:nowrap;">
                <table>
                    <tr>
                        <td><asp:DropDownList ID="ddlClass" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlClass_SelectedIndexChanged" meta:resourcekey="ddlClassResource1">
                               
                        </asp:DropDownList></td>
                        <td>&nbsp;</td>
                        <td >
                            <telerik:RadButton ID="btnCreateClass"  CausesValidation="false" runat="server" Text="編輯類別" OnClick="btnCreateClass_Click" meta:resourcekey="btnCreateClassResource2"></telerik:RadButton>
                        </td>
                    </tr>
                </table>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="ddlClass" ForeColor="Red"
                    Display="Dynamic" ErrorMessage="必須選擇類別" meta:resourcekey="RequiredFieldValidator3Resource1"></asp:RequiredFieldValidator></td>
        </tr>
        <tr>
            <td width="100" style="height: 27px">
                <span style="color: #ff0000">*</span><asp:Label ID="lbLeftNumber" runat="server" Text="編號" meta:resourcekey="lbLeftNumberResource1"></asp:Label></td>
            <td style="height: 27px" >
                <asp:TextBox ID="txbNumber" runat="server" MaxLength="50" meta:resourcekey="txbNumberResource1"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txbNumber" ForeColor="Red"
                    Display="Dynamic" ErrorMessage="不允許空白" meta:resourcekey="RequiredFieldValidator1Resource1"></asp:RequiredFieldValidator>
                <asp:CustomValidator ID="CustomValidator1" runat="server" Display="Dynamic" ErrorMessage="編號重複" ForeColor="Red"
                    meta:resourcekey="CustomValidator1Resource1"></asp:CustomValidator></td>
        </tr>
        <tr>
            <td width="100">
                <span style="color: #ff0000">*</span><asp:Label ID="lbLeftName" runat="server" Text="名稱" meta:resourcekey="lbLeftNameResource1"></asp:Label></td>
            <td >
                <asp:TextBox ID="txbName" runat="server" Width="100%" MaxLength="50" meta:resourcekey="txbNameResource1"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txbName" ForeColor="Red"
                    Display="Dynamic" ErrorMessage="不允許空白" meta:resourcekey="RequiredFieldValidator2Resource1"></asp:RequiredFieldValidator></td>
        </tr>
        <tr>
            <td>                
                <asp:Label ID="lbLeftContodian" runat="server" Text="保管人" meta:resourcekey="lbLeftContodianResource1"></asp:Label></td>
            <td >
                <uc1:UC_ChoiceList ID="UC_ChoiceList1" runat="server" />
            </td>
        </tr>
        <tr>
            <td style=" white-space:nowrap;">
                <asp:Label ID="Label2" runat="server" Text="*" ForeColor="Red"></asp:Label>
                <asp:Label ID="lblPlantMember" runat="server" Text="可借用人員" meta:resourcekey="lblPlantMemberResource1"></asp:Label>
            </td>
            <td>
                <uc1:UC_ChoiceList ID="UC_ChoiceListMember" runat="server" />     
                <asp:HiddenField ID="hfPlantMember" runat="server" />                
                <asp:CustomValidator ID="cvCheckPlantMember" runat="server" ErrorMessage="不允許空白" Display="Dynamic" ClientValidationFunction="CheckPlantMember" meta:resourcekey="cvCheckPlantMemberResource1"></asp:CustomValidator>
            </td>
        </tr>
        <tr>
            <td style="white-space:nowrap;">
                <asp:Label ID="lbLeftOpen" runat="server" Text="設備狀態" 
                    meta:resourcekey="lbLeftOpenResource1"></asp:Label></td>
            <td>
                <asp:RadioButtonList ID="rbtOpen" runat="server" RepeatDirection="Horizontal" 
                    meta:resourcekey="rbtOpenResource1">
                    <asp:ListItem Selected="True" Value="true" meta:resourcekey="ListItemResource1">開放</asp:ListItem>
                    <asp:ListItem Value="false" meta:resourcekey="ListItemResource2">暫停</asp:ListItem>
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
                            <asp:RadioButton ID="rdbtnLimitByClass" runat="server" Text="依類別設定" GroupName="Limit" onclick="rbClick(0)" meta:resourcekey="rdbtnLimitByClassResource1" />
                        </td>
                        <td>&nbsp;</td>
                        <td></td>
                    </tr>
                    <tr>
                        <td>
                            <asp:RadioButton ID="rdbtnUseDay" runat="server" Text="可借用到系統日之後幾天" GroupName="Limit" onclick="rbClick(1)" meta:resourcekey="rdbtnUseDayResource1" />
                        </td>
                        <td style="width:10px;white-space: nowrap;">
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
                    </tr>
                    <tr>
                        <td>
                            <asp:RadioButton ID="rdbtnNoLimit" runat="server" Text="不限定" Checked="True" GroupName="Limit" onclick="rbClick(2)" meta:resourcekey="rdbtnNoLimitResource1" />
                        </td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
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
                            <asp:RadioButton ID="rdByClass" runat="server" Text="依類別設定" Checked="True" GroupName="Apply" onclick="IsExamine(0)" meta:resourcekey="rdByClassResource1"/>
                        </td>
                    </tr>
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
                            <asp:RadioButton ID="rbNoLimit" runat="server" Text="由行事曆借用" GroupName="Apply" onclick="IsExamine(2)" meta:resourcekey="rbNoLimitResource1" />                                                   
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td >
                <asp:Label ID="lbLeftDescription" runat="server" Text="說明" meta:resourcekey="lbLeftDescriptionResource1"></asp:Label></td>
            <td >
                <asp:TextBox ID="txbDescription" runat="server" TextMode="MultiLine" Width="100%" Rows="10" meta:resourcekey="txbDescriptionResource1"></asp:TextBox></td>
        </tr>
        <tr id="_1" runat="server">
            <td style="width: 100px">
                <asp:Label ID="lblMeetingLocation" runat="server" Text="地點" meta:resourcekey="lblMeetingLocationResource1"></asp:Label>
            </td>
            <td>
                <asp:TextBox ID="txtMeetingLocation" runat="server" meta:resourcekey="txtMeetingLocationResource1" Width="100%"></asp:TextBox>                
            </td>
        </tr>
        <tr id="_2" runat="server">
            <td style="width: 100px">
                <asp:Label ID="lblAccomodate" runat="server" Text="可容納人數" meta:resourcekey="lblAccomodateResource1"></asp:Label>
            </td>
            <td>                
                <telerik:RadNumericTextBox ID="RadAccomodate" Runat=server NumberFormat-DecimalDigits="0" Width="100px">
                    <ClientEvents OnKeyPress="CreatePlant_checkKeyPress" />
                </telerik:RadNumericTextBox>                
            </td>
        </tr>
        <tr id="_3" runat="server">
            <td style="width: 100px">
                <asp:Label ID="lblEquipments" runat="server" Text="配備" meta:resourcekey="lblEquipmentResource1"></asp:Label>
            </td>
            <td>
                <uc1:UC_EquipList runat="server" ID="UC_EquipList" />
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="lbPict" runat="server" Text="圖片" meta:resourcekey="lbPictResource1"></asp:Label></td>
            <td style="max-width:350px" >
                <asp:Image ID="imgBigPicture" runat="server" Visible="false" />
                <uc1:UC_FileCenter runat="server" ID="UC_FileCenter" AllowedFileType="Image" FileSizeLimit="2048" OnClientRemoved="RemoveImage()" />
                <asp:Label ID="lblFileSizeLimit" runat="server" Text="檔案大小上限2MB" meta:resourcekey="lblFileSizeLimitResource1"></asp:Label>
                </td>
        </tr>
    </table>
    <asp:Label ID="lbPlantGuid" runat="server" Visible="False" meta:resourcekey="lbPlantGuidResource1"></asp:Label>
    <asp:Label ID="lbClassGuid" runat="server" Visible="False" meta:resourcekey="lbClassGuidResource1"></asp:Label>
    <asp:Label ID="lblPlantExaming" runat="server" style="display:none;" Text="尚有設備借用申請單在簽核中" meta:resourcekey="lblPlantExamingResource1"></asp:Label>    
</asp:Content>


