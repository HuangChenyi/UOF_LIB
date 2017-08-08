<%@ Page Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" Inherits="EIP_Calendar_CreateMeeting" Title="新增會議" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="CreateMeeting.aspx.cs" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Register Src="../../Common/ChoiceCenter/UC_BtnChoiceOnce.ascx" TagName="UC_BtnChoiceOnce" TagPrefix="uc7" %>
<%@ Register Src="Common/UC_DevolveList.ascx" TagName="UC_DevolveList" TagPrefix="uc5" %>
<%@ Register Src="Common/UC_RemindTime.ascx" TagName="UC_RemindTime" TagPrefix="uc4" %>
<%@ Register Src="Common/UC_CreateBorrow.ascx" TagName="UC_CreateBorrow" TagPrefix="uc3" %>
<%@ Register Src="Common/UC_PrivateEvent.ascx" TagName="UC_PrivateEvent" TagPrefix="uc2" %>
<%@ Register Src="../../Common/ChoiceCenter/UC_ChoiceList.ascx" TagName="UC_ChoiceList" TagPrefix="uc1" %>
<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Fast" %>
<%@ Register Src="~/Common/FileCenter/V3/UC_FileCenter.ascx" TagPrefix="uc1" TagName="UC_FileCenter" %>


<%@ Register src="../../Common/ChoiceCenter/UC_ChoiceAddressBook.ascx" tagname="UC_ChoiceAddressBook" tagprefix="uc6" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
<script id="CreateMeetingjs" type="text/javascript">

    $(function () {
        if ($('#<%=hidToggleStatus.ClientID%>').val() == 'show') {
            $('.bccTRClass').show();
        }
        else {
            $('#<%=hidToggleStatus.ClientID%>').val('')
            $('.bccTRClass').hide();
        }

        $('#a_div').on('click', function () {
            if ($('#<%=hidToggleStatus.ClientID%>').val() == '' || $('#<%=hidToggleStatus.ClientID%>').val() == 'hide') {
                $('.bccTRClass').show();
                $('#<%=hidToggleStatus.ClientID%>').val("show")
            }
            else {
                $('.bccTRClass').hide();
                $('#<%=hidToggleStatus.ClientID%>').val("hide")
            }
        }
        );
    });
    

    function barRecord_Click(sender, args) {
        var Key = args.get_item().get_value();

        if (Key == "Create") {
            args.set_cancel(true);
     
            $uof.dialog.open2("~/EIP/Calendar/CreateMinute.aspx", args.get_item(), "", 800, 600,
                function (returnValue) {
                    if (typeof (returnValue) == 'undefined' || returnValue == null) { return false;}
                    else {return true; }
                    }, 
                { "MeetingGuid": '<%=lbMeetingGuid.Text%>' });
        }
        else if (Key == "Delete") {
            if (confirm('<%=lbConfirmDelete.Text %>') == false)
                args.set_cancel(true);
        }
    }

    function DialogCreatePre() {
        var owner = $("#<%= hidOwnerGuid.ClientID %>").val();
        var date = $("#<%= hidDate.ClientID %>").val();
        window.location.href = "CreateMeetingOrInquiry.aspx?OwnerGuid=" + owner + "&Date=" + date;
        return false;
    }

    function Button4Click() {
        return confirm('<%= lbConfirmDelete.Text %>');
    }

    //改變會議時間後要更新借用帶入的會議時間, 且不要postback, 所以改用前端處理
    function SetMeetingStartTime(sender, args){
        $("#<%=UC_CreateBorrow1.FindControl("hidMeetingStartTime").ClientID%>").val(args.get_newValue());
    }

    function SetMeetingEndTime(sender, args){
        $("#<%=UC_CreateBorrow1.FindControl("hidMeetingEndTime").ClientID%>").val(args.get_newValue());
    }

    function CheckRdNoticeStatus() {
        var rbNoticeRightNow = $("#<%=rbNoticeRightNow.ClientID %>").is(":checked");
        var rbNoticeBefore = $("#<%=rbNoticeBefore.ClientID %>").is(":checked");

        if (rbNoticeRightNow) {
            noticeBeforeDiv.style.display = "none";
        }
        if (rbNoticeBefore) {
            noticeBeforeDiv.style.display = "";
        }
    }
    Sys.Application.add_load(CheckRdNoticeStatus);
</script>
    <asp:CustomValidator ID="cvReadAuthority" runat="server" ErrorMessage="您已經不是該會議預計參加人員，因此不帶出會議資料" Visible="False" meta:resourcekey="cvReadAuthorityResource1"></asp:CustomValidator>
    <telerik:RadSplitter ID="Radsplitter1" runat="server" Orientation="Horizontal"
        Width="100%" PanesBorderSize="0" Height="100%"
        BorderSize="0" LiveResize="True" ResizeWithParentPane="True"
        ResizeWithBrowserWindow="True">
        <telerik:RadPane ID="toolbarPane" runat="server" Height="26" Locked="true">
            <telerik:RadTabStrip ID="rts1" MultiPageID="rmp1" runat="server" SelectedIndex="0" meta:resourcekey="rts1Resource1" OnTabClick="rts1_TabClick">
                <Tabs>
                    <telerik:RadTab runat="server" Text="會議內容" Value="Content" PageViewID="rpvContent" Selected="True" meta:resourcekey="RadTabResource1"></telerik:RadTab>
                    <telerik:RadTab runat="server" Text="會議記錄" Value="Record" PageViewID="rpvRecord" meta:resourcekey="RadTabResource2"></telerik:RadTab>
                    <telerik:RadTab runat="server" Text="待辦事項" Value="Devolve" meta:resourcekey="RadTabResource3"></telerik:RadTab>
                </Tabs>
            </telerik:RadTabStrip>
        </telerik:RadPane>
        <telerik:RadPane ID="RadPane2" runat="server" Height="100%">
            <telerik:RadMultiPage ID="rmp1" runat="server" SelectedIndex="0" meta:resourcekey="rmp1Resource1">
                <telerik:RadPageView ID="rpvContent" runat="server" meta:resourcekey="rpvContentResource1" Selected="True">
                    <asp:CustomValidator ID="CustomValidator5" runat="server" Display="Dynamic" ErrorMessage="無法新增會議"
                        meta:resourcekey="CustomValidator5Resource1">
                    </asp:CustomValidator>
                    <asp:CustomValidator ID="CustomValidator2" runat="server" Display="Dynamic" ErrorMessage="設備已被預訂,無法新增借用"
                        meta:resourcekey="CustomValidator2Resource1">
                    </asp:CustomValidator>
                    <asp:CustomValidator ID="CustomValidator3" runat="server" Display="Dynamic"
                        ErrorMessage="設備借用時間必須介於會議時間" meta:resourcekey="CustomValidator3Resource1">
                    </asp:CustomValidator>
                    <table width="100%" runat="server" id="infoTB">
                        <tbody >
                            <tr>
                                <td valign="top" style="width: 50%">                                    
                                    <table class="PopTable" cellspacing="1" width="100%">
                                        <tr>
                                            <td>
                                                <asp:Label ID="Label16" runat="server" Text="*" ForeColor="Red" meta:resourcekey="Label16Resource1"></asp:Label>
                                                <asp:Label ID="lblChair" runat="server" Text="主席" meta:resourcekey="lblChairResource1"></asp:Label>
                                            </td>
                                            <td>
                                                <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                                                    <ContentTemplate>
                                                        &nbsp;<asp:Label ID="lblSelChair" runat="server" meta:resourcekey="lblSelChairResource1"></asp:Label>
                                                        <asp:Label ID="lblSelChairGUID" runat="server" Visible="False" meta:resourcekey="lblSelChairGUIDResource1"></asp:Label>
                                                        <uc7:UC_BtnChoiceOnce ID="UC_BtnChoiceOnce1" runat="server" />
                                                        <asp:CustomValidator ID="cvCheckChair" runat="server" Display="Dynamic" ErrorMessage="主席不允許空白" meta:resourcekey="cvCheckChairResource1"></asp:CustomValidator>
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="white-space: nowrap;">
                                                <span style="color: #ff0000">*</span><asp:Label ID="Label1" runat="server" Text="預計參加人員"
                                                    meta:resourcekey="Label1Resource1"></asp:Label></td>
                                            <td>
                                                <uc1:UC_ChoiceList ID="UC_ChoiceList1" runat="server" ShowMember="False" TreeHeight="100px" />
                                                <asp:CustomValidator ID="CustomValidator1" runat="server" Display="Dynamic" ErrorMessage="參加人員不允許空白" meta:resourcekey="CustomValidator1Resource1"></asp:CustomValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <span style="color: #ff0000">*</span><asp:Label ID="Label2" runat="server" Text="主旨"
                                                    meta:resourcekey="Label2Resource1"></asp:Label></td>
                                            <td>
                                                <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                                                    <ContentTemplate>
                                                        <asp:Label ID="lblSubject" runat="server" Text="" Visible="false"></asp:Label>
                                                        <asp:TextBox ID="txbSubject" runat="server" Width="99%" meta:resourcekey="txbSubjectResource1" MaxLength="200">
                                                        </asp:TextBox>
                                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                                                            ControlToValidate="txbSubject" Display="Dynamic" ErrorMessage="不允許空白"
                                                            meta:resourcekey="RequiredFieldValidator1Resource1">
                                                        </asp:RequiredFieldValidator>
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <span style="color: #ff0000">*</span><asp:Label ID="Label3" runat="server" Text="地點"
                                                    meta:resourcekey="Label3Resource1"></asp:Label></td>
                                            <td>
                                                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                    <tr>
                                                        <td>
                                                            <div id="div1" runat="server">
                                                                <asp:CheckBox ID="cbLiveMeeting" Text="線上會議" runat="server" meta:resourcekey="cbLiveMeetingResource1"
                                                                    AutoPostBack="True" OnCheckedChanged="cbLiveMeeting_CheckedChanged" />
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <asp:RadioButtonList ID="rbBorrowRoom" runat="server"
                                                                RepeatDirection="Horizontal" AutoPostBack="True"
                                                                OnSelectedIndexChanged="rbBorrowRoom_SelectedIndexChanged"
                                                                meta:resourcekey="rbBorrowRoomResource1">
                                                                <asp:ListItem Text="借用會議室" Value="Y" meta:resourcekey="ListItemResource1"></asp:ListItem>
                                                                <asp:ListItem Text="其他地點" Value="N" Selected="True"
                                                                    meta:resourcekey="ListItemResource2">
                                                                </asp:ListItem>
                                                            </asp:RadioButtonList>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2">
                                                            <asp:UpdatePanel ID="UpdatePanel4" runat="server">
                                                                <ContentTemplate>
                                                                    <asp:Label ID="lblLocation" runat="server" Text="" Visible="false"></asp:Label>
                                                                    <asp:TextBox ID="txbLocation" runat="server" Width="99%" meta:resourcekey="txbLocationResource1" MaxLength="50">
                                                                    </asp:TextBox>
                                                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2"
                                                                        runat="server" ControlToValidate="txbLocation" Display="Dynamic" ErrorMessage="不允許空白"
                                                                        meta:resourcekey="RequiredFieldValidator2Resource1"></asp:RequiredFieldValidator>
                                                                </ContentTemplate>
                                                            </asp:UpdatePanel>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="Label4" runat="server" Text="說明" meta:resourcekey="Label4Resource1"></asp:Label></td>
                                            <td>
                                                <asp:TextBox ID="txbDescription" runat="server" Height="100px" TextMode="MultiLine"
                                                    Width="99%" meta:resourcekey="txbDescriptionResource1">
                                                </asp:TextBox></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <span style="color: #ff0000">*</span><asp:Label ID="Label5" runat="server" Text="開始時間"
                                                    meta:resourcekey="Label5Resource1"></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label ID="lblStartDateTime" runat="server" Text=""  Visible="false"></asp:Label>
                                                <telerik:RadDateTimePicker runat="server" ID="rdStartDateTime"    >
                                                    <DateInput Enabled="false"></DateInput>
                                                    <DatePopupButton Enabled="false" />
                                                  
                                                    <ClientEvents OnDateSelected="SetMeetingStartTime" />
                                                </telerik:RadDateTimePicker>                                                    
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <span style="color: #ff0000">*</span>
                                                <asp:Label ID="Label6" runat="server" Text="結束時間" meta:resourcekey="Label6Resource1"></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label ID="lblEndDateTime" runat="server" Text="" Visible="false"></asp:Label>
                                                <telerik:RadDateTimePicker runat="server" ID="rdEndDateTime">
                                                    <ClientEvents OnDateSelected="SetMeetingEndTime" />
                                                </telerik:RadDateTimePicker>
                                                <asp:CustomValidator ID="CustomValidator4" runat="server" Display="Dynamic" ErrorMessage="請填入開始時間" OnServerValidate="CustomValidator4_ServerValidate" meta:resourcekey="CustomValidator4Resource1"></asp:CustomValidator>
                                                <asp:CustomValidator ID="CustomValidator6" runat="server" Display="Dynamic" ErrorMessage="請填入結束時間" OnServerValidate="CustomValidator6_ServerValidate" meta:resourcekey="CustomValidator6Resource1"></asp:CustomValidator>
                                                <asp:CustomValidator ID="CustomValidator7" runat="server" Display="Dynamic" ErrorMessage="結束時間需晚於開始時間" OnServerValidate="CustomValidator7_ServerValidate" meta:resourcekey="CustomValidator7Resource1"></asp:CustomValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="Label24" runat="server" Text="會議通知時間" meta:resourcekey="Label24Resource1"></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label ID="lblNotice" runat="server" Text="" Visible="false"></asp:Label>
                                                <table style="padding: 0; width: 150px;" runat="server" id="noticeTB">
                                                    <tr>
                                                        <td colspan="2">
                                                            <asp:RadioButton ID="rbNoticeRightNow" runat="server" Text="立即通知" GroupName="RbNoticeGroup" Checked="true" onclick="CheckRdNoticeStatus()" meta:resourcekey="rbNoticeRightNowResource1"/>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td style="white-space: nowrap;">
                                                            <asp:RadioButton ID="rbNoticeBefore" runat="server" Text="開始前" GroupName="RbNoticeGroup" onclick="CheckRdNoticeStatus()" meta:resourcekey="rbNoticeBeforeResource1"/>
                                                        </td>
                                                        <td style="white-space: nowrap;">
                                                            <div id="noticeBeforeDiv" style="display: none">
                                                                <asp:DropDownList ID="ddlNoticeTime" runat="server">
                                                                    <asp:ListItem Value="10" Text="10分" meta:resourcekey="NoticeTimeListItem1Resource1"></asp:ListItem>
                                                                    <asp:ListItem Value="30" Text="30分" meta:resourcekey="NoticeTimeListItem2Resource1"></asp:ListItem>
                                                                    <asp:ListItem Value="60" Text="1小時" meta:resourcekey="NoticeTimeListItem3Resource1"></asp:ListItem>
                                                                    <asp:ListItem Value="120" Text="2小時" meta:resourcekey="NoticeTimeListItem4Resource1"></asp:ListItem>
                                                                    <asp:ListItem Value="1440" Text="1天" meta:resourcekey="NoticeTimeListItem5Resource1"></asp:ListItem>
                                                                    <asp:ListItem Value="4320" Text="3天" meta:resourcekey="NoticeTimeListItem6Resource1"></asp:ListItem>
                                                                    <asp:ListItem Value="10080" Text="1週" meta:resourcekey="NoticeTimeListItem7Resource1"></asp:ListItem>
                                                                </asp:DropDownList>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblContact" runat="server" Text="會議連絡人" meta:resourcekey="lblContactResource1"></asp:Label>
                                            </td>
                                            <td>
                                                <uc1:UC_ChoiceList ID="UC_ChoiceList3" runat="server" ChioceType="User" ShowMember="False" TreeHeight="100px" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="Label21" runat="server" Text="知會人員" meta:resourcekey="Label21Resource1"></asp:Label>
                                                <br />
                                                <div id="a_div">
                                                    <asp:Label ID="lblEnableBCC" runat="server" Text="密件副本" ForeColor="Blue" style="text-decoration:underline;cursor:pointer" meta:resourcekey="lbtnEnableBCCResource1"></asp:Label>
                                                </div>
                                            </td>
                                            <td>
                                                <uc6:UC_ChoiceAddressBook ID="UC_ChoiceAddressBookCC" runat="server" />
                                                <asp:Label ID="lblCCOtherContact" runat="server" Text="" Visible="false"></asp:Label>
                                                <table style="width: 100%;" runat="server" id="CCMailTB">
                                                    <tr>
                                                        <td >
                                                            <asp:Label ID="Label22" runat="server" Text="手動輸入電子郵件地址並以逗號分隔" meta:resourcekey="Label22Resource1"></asp:Label>
                                                            <asp:TextBox ID="txtCCOtherContact" runat="server" Rows="5" Width="100%" TextMode="MultiLine"></asp:TextBox>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr runat="server" class="bccTRClass" style="display: none;">
                                            <td>
                                                <asp:Label ID="Label17" runat="server" Text="密件副本" meta:resourcekey="Label17Resource1"></asp:Label>
                                            </td>
                                            <td>
                                                <uc6:UC_ChoiceAddressBook ID="UC_ChoiceAddressBookBCC" runat="server" />
                                                <asp:Label ID="lblBCCOtherContact" runat="server" Text="" Visible="false"></asp:Label>
                                                <table style="width: 100%;" runat="server" id="BCCMailTB">
                                                    <tr>
                                                        <td >
                                                            <asp:Label ID="Label23" runat="server" Text="手動輸入電子郵件地址並以逗號分隔" meta:resourcekey="Label23Resource1"></asp:Label>
                                                            <asp:TextBox ID="txtBCCOtherContact" runat="server" Rows="5" Width="100%" TextMode="MultiLine"></asp:TextBox>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblFile" runat="server" Text="附件" meta:resourcekey="lblFileResource1"></asp:Label></td>
                                            <td>                                                
                                                <uc1:UC_FileCenter runat="server" ID="UC_FileCenter" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="Label7" runat="server" Text="私人" meta:resourcekey="Label7Resource1"></asp:Label></td>
                                            <td>
                                                <uc2:UC_PrivateEvent ID="UC_PrivateEvent1" runat="server" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="Label8" runat="server" Text="提醒時間" meta:resourcekey="Label8Resource1"></asp:Label></td>
                                            <td>
                                                <uc4:UC_RemindTime ID="UC_RemindTime1" runat="server" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="Label9" runat="server" Text="建立人員" meta:resourcekey="Label9Resource1"></asp:Label></td>
                                            <td>
                                                <asp:Label ID="lbCreateUser" runat="server" meta:resourcekey="lbCreateUserResource1"></asp:Label></td>
                                        </tr>
                                    </table>
                                </td>
                                <td style="width: 50%; vertical-align: top;">
                                    <asp:Panel runat="server" ID="Panel1" Width="100%" meta:resourcekey="Panel1Resource1">
                                        <table class="PopTable" cellspacing="1" width="100%">
                                            <tr>
                                                <td colspan="2" class="PopTableHeader">
                                                    <div style="text-align: center;">
                                                        <asp:Label ID="Label11" runat="server" Text="人員" meta:resourcekey="Label11Resource1"></asp:Label>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="Label12" runat="server" Text="參加" meta:resourcekey="Label12Resource1"></asp:Label></td>
                                                <td>
                                                    <asp:Label ID="lbJoinCount" runat="server" Font-Bold="True" ForeColor="Olive" meta:resourcekey="lbJoinCountResource1"></asp:Label>
                                                    <asp:Label ID="Label20" runat="server" Text="人" Font-Bold="False" ForeColor="Olive"
                                                        meta:resourcekey="Label20Resource1"></asp:Label></td>
                                            </tr>
                                            <tr id="joinTR" runat="server">
                                                <td></td>
                                                <td>
                                                    <asp:Label ID="lbJoin" runat="server" meta:resourcekey="lbJoinResource1"></asp:Label></td>
                                            </tr>
                                            <tr>
                                                <td style="height: 23px">
                                                    <asp:Label ID="Label13" runat="server" Text="不參加" meta:resourcekey="Label13Resource1"></asp:Label></td>
                                                <td style="height: 23px">
                                                    <asp:Label ID="lbUnJoinCount" runat="server" Font-Bold="True" ForeColor="#C00000"
                                                        meta:resourcekey="lbUnJoinCountResource1"></asp:Label>
                                                    <asp:Label ID="Label19" runat="server" Text="人" ForeColor="#C00000" meta:resourcekey="Label19Resource1"></asp:Label></td>
                                            </tr>
                                            <tr id="nojoinTR" runat="server">
                                                <td></td>
                                                <td>
                                                    <asp:Label ID="lbUnJoin" runat="server" meta:resourcekey="lbUnJoinResource1"></asp:Label></td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="Label14" runat="server" Text="尚未回覆" meta:resourcekey="Label14Resource1"></asp:Label></td>
                                                <td>
                                                    <asp:Label ID="lbUnBackCount" runat="server" ForeColor="Black" meta:resourcekey="lbUnBackCountResource1"></asp:Label>
                                                    <asp:Label ID="Label18" runat="server" Text="人" meta:resourcekey="Label18Resource1"></asp:Label></td>
                                            </tr>
                                            <tr id="noReplyTR" runat="server">
                                                <td></td>
                                                <td>
                                                    <asp:Label ID="lbNotReply" runat="server" meta:resourcekey="lbNotReplyResource1"></asp:Label></td>
                                            </tr>
                                            <tr>
                                                <td style="white-space: nowrap;">
                                                    <asp:Label ID="lblRealAttendUser" runat="server" Text="實際參與人員" meta:resourcekey="lblRealAttendUserResource1"></asp:Label></td>
                                                <td>
                                                    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                                                        <ContentTemplate>
                                                            <telerik:RadButton runat="server" ID="btnAutoSetRealAttendUser" Text="帶入預計參加人員" meta:resourcekey="btnAutoSetRealAttendUserResource1" OnClick="btnAutoSetRealAttendUser_Click1"></telerik:RadButton>
                                                            <uc1:UC_ChoiceList ID="UC_ChoiceList2" runat="server" ExpandToUser="true" />
                                                        </ContentTemplate>
                                                    </asp:UpdatePanel>
                                                </td>
                                            </tr>
                                        </table>
                                    </asp:Panel>
                                    <asp:Panel ID="Panel2" runat="server" Width="100%" Visible="False" meta:resourcekey="Panel2Resource1">
                                        <asp:Label ID="lblNotReplyMsg" runat="server" ForeColor="Red" Text="會議已經開始，無法回覆" meta:resourcekey="lblNotReplyMsgResource1"></asp:Label>
                                        
                                        <table class="PopTable" cellspacing="1" width="100%">
                                            <tr>
                                                <td style="height: 24px;white-space:nowrap">
                                                    <span style="color: #ff0000"></span>
                                                    <asp:Label ID="Label10" runat="server" Text=" 回覆" meta:resourcekey="Label10Resource1"></asp:Label></td>
                                                <td style="height: 24px">
                                                    <asp:RadioButton ID="rbJoin" runat="server" GroupName="join" Text="回覆參加會議，並加入我的行事曆"
                                                        Checked="True" meta:resourcekey="rbJoinResource1" AutoPostBack="True" OnCheckedChanged="rbJoin_CheckedChanged" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 24px"></td>
                                                <td style="height: 24px">
                                                    <asp:RadioButton ID="rbUnJoin" runat="server" GroupName="join" Text="回覆不參加" meta:resourcekey="rbUnJoinResource1"
                                                        AutoPostBack="True" OnCheckedChanged="rbUnJoin_CheckedChanged" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="white-space:nowrap">
                                                    <asp:Label ID="Label15" runat="server" Text="回覆說明" meta:resourcekey="Label15Resource1"></asp:Label></td>
                                                <td>
                                                    <asp:TextBox ID="txbReturnDesc" runat="server" Height="100px" TextMode="MultiLine"
                                                        Width="360px" meta:resourcekey="txbReturnDescResource1">
                                                    </asp:TextBox></td>
                                            </tr>
                                        </table>

                                        <asp:UpdatePanel ID="UpdatePanel5" runat="server">
                                            <ContentTemplate>
                                                <asp:Label runat="server" ID="lblSchedule" Text="會議時間內的行程" ForeColor="Blue" meta:resourcekey="lblScheduleResource1"></asp:Label>
                                                <Fast:Grid ID="GridAllSchedule" runat="server" AllowSorting="True" AutoGenerateCheckBoxColumn="False"
                                                    AutoGenerateColumns="False"
                                                    ShowHeader="False" Width="100%" BorderStyle="None"
                                                    BorderWidth="0px" AllowPaging="False"
                                                    OnPageIndexChanging="GridAllSchedule_PageIndexChanging"
                                                    DataKeyOnClientWithCheckBox="False" DefaultSortDirection="Ascending"
                                                    EnhancePager="True" PageSize="15" OnRowDataBound="GridAllSchedule_RowDataBound"
                                                    EmptyDataText="沒有資料"
                                                    KeepSelectedRows="False" meta:resourcekey="GridAllScheduleResource1">
                                                    <EnhancePagerSettings ShowHeaderPager="True" />
                                                    <ExportExcelSettings AllowExportToExcel="False" />
                                                    <Columns>
                                                        <asp:TemplateField meta:resourcekey="TemplateFieldResource1">
                                                            <ItemTemplate>
                                                                <table width="100%" border="0">
                                                                    <tr>
                                                                        <td width="16px" style="min-width: 16px">
                                                                            <img height="16px" src="<%=ResolveUrl("~/common/images/icon/icon02.png")%>" width="16px" />
                                                                        </td>
                                                                        <td width="50%">
                                                                            <asp:LinkButton runat="server" ID="lbtnSubject" Text='<%# Eval("SUBJECT") %>' OnClick="lbtnSubject_Click"></asp:LinkButton>
                                                                        </td>
                                                                        <td style="white-space:nowrap;">
                                                                            <asp:Label runat="server" ID="Label25" Text="("></asp:Label>
                                                                            <asp:Label runat="server" ID="lblScheduleDateTime"></asp:Label>                                                                            
                                                                            <asp:Label runat="server" ID="Label27" Text=")"></asp:Label>
                                                                        </td>
                                                                    </tr>
                                                                </table>

                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                    </Columns>
                                                </Fast:Grid>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </asp:Panel>
                                    <table width="100%">
                                        <tr>
                                            <td>
                                                <asp:UpdatePanel ID="UpdatePanel6" runat="server">
                                                    <ContentTemplate>
                                                        <asp:CustomValidator ID="CustomValidator8" runat="server" Display="Dynamic" ErrorMessage=""></asp:CustomValidator>
                                                        <uc3:UC_CreateBorrow ID="UC_CreateBorrow1" runat="server" />
                                                    </ContentTemplate>
                                                </asp:UpdatePanel>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:LinkButton ID="lbtnQueryResult" runat="server" CausesValidation="False"
                                                    Visible="False" meta:resourcekey="lbtnQueryResultResource1" Text="查詢徵詢結果">
                                                </asp:LinkButton>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </telerik:RadPageView>
                <telerik:RadPageView ID="rpvRecord" runat="server" meta:resourcekey="rpvRecordResource1">
                    <telerik:RadToolBar ID="RadToolBar1" runat="server"
                        OnButtonClick="RadToolBar1_ButtonClick" OnClientButtonClicking="barRecord_Click" Width="100%" meta:resourcekey="RadToolBar1Resource1">

                        <Items>
                            <telerik:RadToolBarButton runat="server" HoveredImageUrl="~/Common/Images/Icon/icon_m27.png" ImageUrl="~/Common/Images/Icon/icon_m27.png"
                                Value="Create" CheckedImageUrl="~/Common/Images/Icon/icon_m27.png" Text="新增記錄" meta:resourcekey="TBarButtonResource1">
                            </telerik:RadToolBarButton>
                            <telerik:RadToolBarButton runat="server" IsSeparator="True" Value="s1" meta:resourcekey="RadToolBarButtonResource1">
                            </telerik:RadToolBarButton>
                            <telerik:RadToolBarButton runat="server" HoveredImageUrl="~/Common/Images/Icon/icon_m03.png" ImageUrl="~/Common/Images/Icon/icon_m03.png"
                                Value="Delete" CheckedImageUrl="~/Common/Images/Icon/icon_m03.png" Text="刪除選取項目"
                                meta:resourcekey="TBarButtonResource2">
                            </telerik:RadToolBarButton>
                            <telerik:RadToolBarButton runat="server" IsSeparator="True" Value="s2" meta:resourcekey="RadToolBarButtonResource2">
                            </telerik:RadToolBarButton>
                            <telerik:RadToolBarButton runat="server" HoveredImageUrl="~/Common/Images/Icon/icon_s09.png" ImageUrl="~/Common/Images/Icon/icon_s09.png"
                                Value="Send" CheckedImageUrl="~/Common/Images/Icon/icon_s09.png" Text="發送會議記錄"
                                meta:resourcekey="TBarButtonResource3">
                            </telerik:RadToolBarButton>
                            <telerik:RadToolBarButton runat="server" IsSeparator="True" Value="s3" meta:resourcekey="RadToolBarButtonResource3">
                            </telerik:RadToolBarButton>
                        </Items>

                    </telerik:RadToolBar>
                    <Fast:Grid ID="gridRecord" runat="server" AllowSorting="True" AutoGenerateCheckBoxColumn="True"
                        AutoGenerateColumns="False" DataKeyNames="MINUTE_GUID"
                        Width="100%" OnRowDataBound="gridRecord_RowDataBound" AllowPaging="True"
                        OnRowCommand="gridRecord_RowCommand"
                        DataKeyOnClientWithCheckBox="False" DefaultSortDirection="Ascending"
                        EnhancePager="True" PageSize="15" EmptyDataText="No data found" KeepSelectedRows="False"
                        meta:resourcekey="gridRecordResource2"   >
                        <EnhancePagerSettings ShowHeaderPager="True" />
                        <ExportExcelSettings AllowExportToExcel="False" />
                        <Columns>
                            <asp:BoundField DataField="IS_DEVOLVE" HeaderText="待辦" SortExpression="IS_DEVOLVE" meta:resourcekey="BoundFieldResource1">
                                <ItemStyle HorizontalAlign="Center" Width="60px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="IS_RESOLUTION" HeaderText="決議" meta:resourcekey="BoundFieldResource2" SortExpression="IS_RESOLUTION">
                                <ItemStyle HorizontalAlign="Center" Width="60px" />
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="主旨" SortExpression="SUBJECT" meta:resourcekey="TemplateFieldResource1">
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnView" runat="server" CommandName="btnView" meta:resourceKey="btnViewResource1" Text='<%# Eval("SUBJECT") %>'></asp:LinkButton>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:TemplateField>
                        </Columns>
                    </Fast:Grid>
                </telerik:RadPageView>
            </telerik:RadMultiPage>
            <telerik:RadMultiPage ID="DevolveRmp" runat="server" SelectedIndex="0" Visible="false">
                <telerik:RadPageView ID="rpvDevolve" runat="server" Selected="true">
                    <uc5:UC_DevolveList ID="UC_DevolveList1" runat="server" />
                </telerik:RadPageView>
            </telerik:RadMultiPage>

            <asp:Label ID="lbMeetingGuid" runat="server" Visible="False" meta:resourcekey="lbMeetingGuidResource1"></asp:Label>
            <asp:Label ID="lbBtn2" runat="server" Text="編輯會議紀錄及待辦" Visible="False" meta:resourcekey="lbBtn2Resource1"></asp:Label>
            <asp:Label ID="lbUserGuid" runat="server" Visible="False" meta:resourcekey="lbUserGuidResource1"></asp:Label>
            <asp:Label ID="lbOwnerGuid" runat="server" Visible="False" meta:resourcekey="lbOwnerGuidResource1"></asp:Label>
            <asp:Label ID="lbConfirmJoin" runat="server" Text="確定回覆" Visible="False" meta:resourcekey="lbConfirmJoinResource1"></asp:Label>
            <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" OldValuesParameterFormatString="original_{0}"
                SelectMethod="GetAllMinute" TypeName="Ede.Uof.EIP.Schedule.Meeting.MinuteManagementUCO">
                <SelectParameters>
                    <asp:ControlParameter ControlID="lbUserGuid" Name="userGUID" PropertyName="Text"
                        Type="String" />
                    <asp:ControlParameter ControlID="lbMeetingGuid" Name="meetingGUID" PropertyName="Text"
                        Type="String" />
                </SelectParameters>
            </asp:ObjectDataSource>

            <asp:Label ID="lbConfirmDelete" runat="server" Text="確定要刪除?" Visible="False" meta:resourcekey="lbConfirmDeleteResource1"></asp:Label>
            <asp:Label ID="lbDelete" runat="server" Text="刪除" Visible="False" meta:resourcekey="lbDeleteResource1"></asp:Label>
            <asp:Label ID="lblPreMsg" runat="server" Text="上一步" Visible="False" meta:resourcekey="lblPreMsgResource1"></asp:Label>
            <input id="hideMinuteAndDevolveEditable" type="hidden" runat="server" />
            <input id="hidOwnerGuid" runat="server" type="hidden" />
            <input id="hidDate" runat="server" type="hidden" />
            <asp:Label ID="lblSendSuccess" runat="server" Visible="False" Text="發送成功" meta:resourcekey="lblSendSuccessResource1"></asp:Label>
            <asp:Label ID="lblInquiryGuid" runat="server" Visible="False" meta:resourcekey="lblInquiryGuidResource1"></asp:Label>
            <asp:Label ID="lblLoginAlert" runat="server" Visible="False" Text="登入者非此會議參與人員,所以無法回覆 !" meta:resourcekey="lblLoginAlertResource2"></asp:Label>
            <asp:Label ID="lblLiveMeeting" runat="server" Text="線上會議室" Visible="False" meta:resourcekey="lblLiveMeetingResource1"></asp:Label>
            <asp:Label ID="lblCheckConnection" runat="server" Text="請檢查Meeting Server的連線資訊是否正確，包含位置、帳號及密碼！(請注意Meeting Server的帳號不能被停用)" Visible="False" meta:resourcekey="lblCheckConnectionResource1"></asp:Label>
            <asp:Label ID="lblMeetingConnectionError" runat="server" Text="請檢查線上會議的設定，包含Meeting位置、帳號與密碼!(請注意Meeting Server的帳號不能被停用)" Visible="False" meta:resourcekey="lblMeetingConnectionErrorResource1"></asp:Label>
            <asp:Label ID="lblModifyMeetingError" runat="server" Text="修改會議失敗!!" Visible="False" meta:resourcekey="lblModifyMeetingErrorResource1"></asp:Label>
            <asp:Label ID="lblDeleteMeetingError" runat="server" Text="刪除會議失敗!!" Visible="False" meta:resourcekey="lblDeleteMeetingErrorResource1"></asp:Label>
            <asp:Label ID="lblAddMeetingError" runat="server" Text="新增會議失敗!!" Visible="False" meta:resourcekey="lblAddMeetingErrorResource1"></asp:Label>
            <asp:Label ID="lblMeetingLocationURLError" runat="server" Text="Meeting Server位置所輸入的URL不正確或是為不合法的!!" Visible="False" meta:resourcekey="lblMeetingLocationURLErrorResource1"></asp:Label>
            <asp:Label ID="lblSampleShowLimitMsg" runat="server" Text="設備{0}只開放今天後{1}天內借用(可借用到{2})。" Visible="False" meta:resourcekey="lblSampleShowLimitMsgResource1"></asp:Label>
            <asp:HiddenField ID="hidToggleStatus" runat="server" />
            <asp:HiddenField ID="hfCurrentUser" runat="server" />
        </telerik:RadPane>
    </telerik:RadSplitter>
</asp:Content>
