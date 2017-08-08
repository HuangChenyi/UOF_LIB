<%@ Page Language="C#" MasterPageFile="~/Master/DefaultMasterPage.master" AutoEventWireup="true" Inherits="Basic_Personal_Information_Default" Title="個人資訊設定" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="Default.aspx.cs" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Register Src="UC_Member.ascx" TagName="UC_Member" TagPrefix="uc5" %>
<%@ Register Src="UC_Employee.ascx" TagName="UC_Employee" TagPrefix="uc4" %>
<%@ Register Src="../../../Common/ChoiceCenter/UC_BtnChoiceOnce.ascx" TagName="UC_BtnChoiceOnce" TagPrefix="uc3" %>
<%@ Register Src="../../../Common/ChoiceCenter/UC_ChoiceList.ascx" TagName="UC_ChoiceList" TagPrefix="uc2" %>
<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Fast" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script id="personaljs" type="text/javascript">
        var authwindow;
        var revokewindow;
        var flag = false;
        var flag2 = false;
        var myVar;
        var myVar2;

        function OpenDialogResult (returnValue) {
            if( typeof(returnValue)=="undefined")
                return false;
            else
                return true;
        }


        function Infomation_Default_RadToolBar1_ButtonClicking(sender, args) {
            var value = args.get_item().get_value();
            if (value == "Create") {

                args.set_cancel(true);
                $uof.dialog.open2("~/Basic/Personal/Information/FavoriteUserSet.aspx", args.get_item(), 
               "title", 500, 500, OpenDialogResult);

                
            }
            else if (value == "Delete") {
                args.set_cancel(!confirm('<%=msgDeleteUserSet.Text %>'));
            }
        }

        function linkGooglePlay() {
            var googlePlayUrl = '<%=hidGooglePlayUrl.Value%>';
            window.open(googlePlayUrl, '_blank');
        }

        function linkAppStore() {
            var AppleStoreUrl = '<%=hidAppleStoreUrl.Value%>';
            window.open(AppleStoreUrl, '_blank');
        }
        function OpenGoogleRevoke(url) {
            flag = false;
            flag2 = false;
            myVar2 = setInterval(function () { checkrevoke(); }, 300);
            revokewindow = $uof.window.open(url, 300, 100);
        }

        function OpenGoogleAuth(url) {
            flag = false;
            flag2 = false;
            myVar = setInterval(function () { checkauth(); }, 300);
            authwindow = $uof.window.open(url, 500, 600);
            
        }
        function checkauth() {
            if (authwindow) {
                if (authwindow.closed) {
                    if (authwindow && !flag) {
                        var result = $uof.pageMethod.sync("UpdateGoogleInfo", []);
                       
                        $("#<%=hideBindGoogle.ClientID %>").val(result);
                        __doPostBack("<%=LinkBtnBind2.UniqueID %>", 'OnClick');
                        
                        flag = true;
                        stopCheckauth();
                    }
                }
            }
        }
        function checkrevoke() {
            if (revokewindow) {
                if (revokewindow.closed ) {
                    if ( !flag2) {
                        $uof.pageMethod.sync("RevokeGoogleInfo", []);
                __doPostBack("<%=LinkBtnRevoke2.UniqueID %>", 'OnClick');
                flag2 = true;  
                stopCheckrevoke();
                    }
                }
            }         

        }

        function stopCheckauth() {
            clearInterval(myVar);
        }
        function stopCheckrevoke() {
            clearInterval(myVar2);
        }

        function OnClientClickingCalendar(sender, args) {
            args.set_cancel(true);
            $uof.dialog.open2("~/Basic/Personal/Information/CalendarLink.aspx", sender,
       "", 500, 200, OpenDialogResult);
           
        }

        function OnClientClickingCalendarCancel(sender, args) {
            var shortcode = $("#<%=lblSubscribeShort.ClientID %>").text();
            var data = [shortcode];
            $uof.pageMethod.sync("CalendarSubscribeCancel", data);
        }
    </script>
    <asp:HiddenField ID="hideBindGoogle" runat="server" />
    <table width="100%" cellpadding="5">
        <tr>
            
            <td>
                <telerik:RadTabStrip ID="rts1" MultiPageID="rmp1" runat="server"
                    SelectedIndex="0">
                    <Tabs>
                        <telerik:RadTab runat="server" Text="基本資料設定" Value="BaseData"
                            PageViewID="rpvBaseData" meta:resourcekey="RadTabResource1">
                        </telerik:RadTab>
                        <telerik:RadTab runat="server" Text="設定" Value="Setup" PageViewID="rpvSetup"
                            meta:resourcekey="RadTabResource2" Selected="True">
                        </telerik:RadTab>
                    </Tabs>
                </telerik:RadTabStrip>
                <telerik:RadMultiPage ID="rmp1" runat="server" BackColor="White"
                    SelectedIndex="1">
                    <telerik:RadPageView ID="rpvBaseData" runat="server"></telerik:RadPageView>
                    <telerik:RadPageView ID="rpvSetup" runat="server">
                        <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <table class="PopTable" cellspacing="1" width="100%">
                                    <tr>
                                        <td class="PopTableHeader">
                                            <asp:Label ID="Label27" runat="server" Text="通知" meta:resourcekey="Label27Resource1"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: left; vertical-align: middle">
                                            <table>
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="lblGotMessage" runat="server" Text="收到私人訊息時" meta:resourcekey="lblGotMessageResource1"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding-left: 20px;">
                                                        <asp:CheckBox ID="cbEmail" runat="server" Text="寄信至我的E-Mail" AutoPostBack="True" OnCheckedChanged="cbEmail_CheckedChanged" meta:resourcekey="cbEmailResource1" />
                                                        <asp:CustomValidator ID="CustomValidator2" runat="server" Display="Dynamic" ErrorMessage="請先至基本資料設定填寫電子郵件" ForeColor="Red" meta:resourcekey="CustomValidator2Resource1"></asp:CustomValidator>
                                                        <br />
                                                        <asp:CheckBox ID="cbPush" runat="server" Text="傳送至我的行動裝置" AutoPostBack="True" Enabled="False" ForeColor="#999999" Height="100%" OnCheckedChanged="cbPush_CheckedChanged" meta:resourcekey="cbPushResource1" />
                                                        <asp:Label ID="lblGetApp" runat="server" Text="註：需先安裝 UOF APP" CssClass="SizeMemo" meta:resourcekey="lblGetAppResource1"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding-left: 35px">
                                                        <asp:ImageButton ID="imgGoogle" runat="server" ImageUrl="~/Common/Images/googlePlay.png" OnClientClick="linkGooglePlay()" meta:resourcekey="imgGoogleResource1" />
                                                        <asp:ImageButton ID="imgApple" runat="server" ImageUrl="~/Common/Images/AppStore.png" OnClientClick="linkAppStore()" meta:resourcekey="imgAppleResource1" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="lblGetEM" runat="server" Text="即時通訊" meta:resourcekey="lblGetEMResource1"></asp:Label>

                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="padding-left: 35px">                                                        
                                                        <a href="../../../EIP/EM/Upgrade/setup.zip" target="_blank"  >
                                                            <img src="../../../Common/Images/downloadEM.png" /></a>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <asp:Panel ID="panEmpl" runat="server" meta:resourcekey="panEmplResource1">
                                         <tr>
                                            <td class="PopTableHeader">
                                                <asp:Label ID="Label1" runat="server" Text="與Google帳號連結" meta:resourcekey="Label1Resource1"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="text-align: left">
                                                <asp:Label ID="Label2" runat="server" Text="Google帳號：" meta:resourcekey="Label2Resource1"></asp:Label><asp:Label ID="lblGoogleAcc" runat="server" Text=""></asp:Label>
                                                <asp:Label ID="lblInvalidAcc" runat="server" Text="連結帳號資訊不完全，請重新作連結" ForeColor="Red" Visible="false"  meta:resourcekey="lblInvalidAccResource1"></asp:Label>
                                                <br />
                                                 <telerik:RadButton ID="RadBtnBind" runat="server" Text="連結" meta:resourcekey="RadBtnBindResource1"></telerik:RadButton>
                                                <telerik:RadButton ID="RadBtnRevoke" runat="server" Text="解除" meta:resourcekey="RadBtnRevokeResource1"></telerik:RadButton><br />
                                                <asp:Label ID="Label3" runat="server" Text="1.設定完成後可將UOF行事曆顯示於Google行事曆上。" CssClass="SizeMemo" meta:resourcekey="Label3Resource1"></asp:Label><br />
                                                <asp:Label ID="Label4" runat="server" Text="2.請勿將同一個Google帳號連結到不同的UOF帳號上，會導致資料處理異常。" CssClass="SizeMemo" meta:resourcekey="Label4Resource1"></asp:Label>
                                                <asp:LinkButton ID="LinkBtnBind2" runat="server" OnClick="LinkBtnBind2_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="LinkBtnRevoke2" runat="server" OnClick="LinkBtnRevoke2_Click"></asp:LinkButton>
                                                <asp:CustomValidator ID="CustomValidator1" Display="Dynamic"  runat="server" ErrorMessage="綁定帳號中斷或是發生錯誤，請重新作綁定" meta:resourcekey="CustomValidator1Resource1"></asp:CustomValidator>
                                                <asp:HiddenField ID="HiddenField1" runat="server" />
                                                <asp:Label ID="lblBindAgain" runat="server" Text="變更連結" Visible="false" meta:resourcekey="lblBindAgainResource1"></asp:Label>
                                                <asp:Label ID="lblBind" runat="server" Text="連結" Visible="false" meta:resourcekey="lblBindResource1"></asp:Label>
                                            </td>
                                        </tr>
                                         <tr>
                                            <td class="PopTableHeader">
                                                <asp:Label ID="Label5" runat="server" Text="共用行事曆" meta:resourcekey="Label5Resource1"></asp:Label>
                                            </td>
                                        </tr>
                                         <tr>
                                            <td style="text-align: left">
                                                 <telerik:RadButton ID="RadButton1" runat="server" Text="共用" OnClientClicking="OnClientClickingCalendar" OnClick="RadButton1_Click" meta:resourcekey="RadButton1Resource1"></telerik:RadButton>
                                                <asp:Label ID="lblSubscribeShort" Visible="false" runat="server" ></asp:Label>
                                                 <telerik:RadButton ID="RadButton2" runat="server" Text="取消共用"  OnClick="RadButton2_Click" meta:resourcekey="RadButton2Resource1"></telerik:RadButton>
                                                <br />
                                                <asp:Label ID="Label6"  runat="server"  CssClass="SizeMemo" Text="讓不同的軟體或裝置共用您的行事曆，例如iphone或outlook" meta:resourcekey="Label6Resource1"></asp:Label>
                                            </td>
                                        </tr>

                                        <tr>
                                            <td class="PopTableHeader">
                                                <asp:Label ID="lbLeftOpen" runat="server" Text="開放別人編輯我的行事曆" meta:resourcekey="lbLeftOpenResource1"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="text-align: left">
                                                <uc2:UC_ChoiceList ID="UC_ChoiceList1" runat="server" ExpandToUser="false" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="PopTableHeader">
                                                <asp:Label ID="Label25" runat="server" Text="設定代理人" meta:resourcekey="Label25Resource1"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="text-align: left">
                                                <asp:Label ID="lblSettingAgentMsg" runat="server" Text="目前由管理者設定代理人" ForeColor="Red" meta:resourcekey="lblSettingAgentMsgResource1"></asp:Label>
                                                <table>
                                                    <tr>
                                                        <td>
                                                            <asp:Label ID="Label42" runat="server" Text="第一代理人" meta:resourcekey="Label42Resource1"></asp:Label>
                                                        </td>
                                                        <td>
                                                            <asp:Label ID="lbFirstAgent" runat="server" meta:resourcekey="lbFirstAgentResource1"></asp:Label></td>
                                                        <td>
                                                            <asp:Panel ID="settingAgentPanel1" runat="server" meta:resourcekey="settingAgentPanel1Resource1">
                                                                <table>
                                                                    <tr>
                                                                        <td>
                                                                            <uc3:UC_BtnChoiceOnce ID="UC_BtnChoiceOnce1" runat="server" />
                                                                        </td>
                                                                        <td>
                                                                            <telerik:RadButton ID="rbtnDeleteAgent1" OnClick="rbtnDeleteAgent1_Click" runat="server" meta:resourcekey="btnDeleteAgent1Resource1">
                                                                            </telerik:RadButton>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </asp:Panel>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label ID="Label43" runat="server" Text="第二代理人" meta:resourcekey="Label43Resource1"></asp:Label>
                                                        </td>
                                                        <td>
                                                            <asp:Label ID="lbSecondAgent" runat="server" meta:resourcekey="lbSecondAgentResource1"></asp:Label>
                                                        </td>
                                                        <td>
                                                            <asp:Panel ID="settingAgentPanel2" runat="server" meta:resourcekey="settingAgentPanel2Resource1">
                                                                <table>
                                                                    <tr>
                                                                        <td>
                                                                            <uc3:UC_BtnChoiceOnce ID="UC_BtnChoiceOnce2" runat="server" />
                                                                        </td>
                                                                        <td>
                                                                            <telerik:RadButton ID="rbtnDeleteAgent2" runat="server" OnClick="rbtnDeleteAgent2_Click" meta:resourcekey="btnDeleteAgent2Resource1">
                                                                            </telerik:RadButton>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </asp:Panel>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <asp:Label ID="Label44" runat="server" Text="第三代理人" meta:resourcekey="Label44Resource1"></asp:Label>
                                                        </td>
                                                        <td>
                                                            <asp:Label ID="lbThirdAgent" runat="server" meta:resourcekey="lbThirdAgentResource1"></asp:Label>
                                                        </td>
                                                        <td>
                                                            <asp:Panel ID="settingAgentPanel3" runat="server" meta:resourcekey="settingAgentPanel3Resource1">
                                                                <table>
                                                                    <tr>
                                                                        <td>
                                                                            <uc3:UC_BtnChoiceOnce ID="UC_BtnChoiceOnce3" runat="server" />
                                                                        </td>
                                                                        <td>
                                                                            <telerik:RadButton ID="rbtnDeleteAgent3" runat="server" Text="RadButton" OnClick="rbtnDeleteAgent3_Click" meta:resourcekey="btnDeleteAgent3Resource1">
                                                                            </telerik:RadButton>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </asp:Panel>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="PopTableHeader">
                                                <asp:Label ID="lblfavoriteUserSet" runat="server" Text="常用人員設定" meta:resourcekey="lblfavoriteUserSetResource1"></asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="text-align: left">
                                                <telerik:RadToolBar ID="RadToolBar1" runat="server" Width="100%" OnClientButtonClicking="Infomation_Default_RadToolBar1_ButtonClicking" OnButtonClick="RadToolBar1_ButtonClick" meta:resourcekey="RadToolBar1Resource1">
                                                    <Items>
                                                        <telerik:RadToolBarButton runat="server" Text="新增" Value="Create"
                                                            ClickedImageUrl="~/Common/Images/Icon/icon_m17.png" DisabledImageUrl="~/Common/Images/Icon/icon_m17.png"
                                                            HoveredImageUrl="~/Common/Images/Icon/icon_m17.png" ImageUrl="~/Common/Images/Icon/icon_m17.png" meta:resourcekey="RadToolBarButtonResource1">
                                                        </telerik:RadToolBarButton>
                                                        <telerik:RadToolBarButton runat="server" IsSeparator="True" meta:resourcekey="RadToolBarButtonResource2"></telerik:RadToolBarButton>
                                                        <telerik:RadToolBarButton runat="server" Text="刪除" Value="Delete"
                                                            ClickedImageUrl="~/Common/Images/Icon/icon_m03.gif" DisabledImageUrl="~/Common/Images/Icon/icon_m03.gif"
                                                            HoveredImageUrl="~/Common/Images/Icon/icon_m03.gif" ImageUrl="~/Common/Images/Icon/icon_m03.gif" meta:resourcekey="RadToolBarButtonResource3">
                                                        </telerik:RadToolBarButton>
                                                        <telerik:RadToolBarButton runat="server" IsSeparator="True" meta:resourcekey="RadToolBarButtonResource4"></telerik:RadToolBarButton>
                                                    </Items>
                                                </telerik:RadToolBar>
                                                <Fast:Grid ID="Grid1" runat="server" DataKeyNames="FAVORITE_GUID"
                                                    AllowSorting="True" AutoGenerateCheckBoxColumn="True" AutoGenerateColumns="False"
                                                    Width="100%"
                                                    OnRowDataBound="Grid1_RowDataBound" DataSourceID="odsFavoUserSet" DataKeyOnClientWithCheckBox="False" meta:resourcekey="Grid1Resource1"  DefaultSortDirection="Ascending" EmptyDataText="沒有資料" EnhancePager="True" KeepSelectedRows="False" PageSize="15"  >
                                                    <EnhancePagerSettings ShowHeaderPager="True" />
                                                    <ExportExcelSettings AllowExportToExcel="False" />
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="名稱" meta:resourcekey="TemplateFieldResource1">
                                                            <ItemTemplate>
                                                                <asp:LinkButton runat="server" ID="LinkButton1" Text='<%# Eval("FAVORITE_NAME") %>' meta:resourcekey="LinkButton1Resource1"></asp:LinkButton>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="人員設定" meta:resourcekey="TemplateFieldResource2">
                                                            <ItemTemplate>
                                                                <uc2:UC_ChoiceList runat="server" ID="UC_ChoiceFavUserSet"></uc2:UC_ChoiceList>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:BoundField DataField="FAVORITE_GUID" HeaderText="FAVORITE_GUID" Visible="False" meta:resourcekey="BoundFieldResource1" />
                                                    </Columns>
                                                </Fast:Grid>
                                            </td>
                                        </tr>


                                    </asp:Panel>
                                </table>
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="RadToolBar1" EventName="ButtonClick" />
                                <asp:AsyncPostBackTrigger ControlID="LinkBtnBind2" EventName="Click" />
                                <asp:AsyncPostBackTrigger ControlID="LinkBtnRevoke2" EventName="Click" />
                            </Triggers>
                        </asp:UpdatePanel>
                    </telerik:RadPageView>
                </telerik:RadMultiPage>
            </td>
        </tr>
    </table>
    <script language="javascript">
        function CheckSignLength(s, a) {
            if (a.Value.length > 255) {
                a.IsValid = false;
            }
        }
    </script>

    <asp:Label ID="msgBasesetup" runat="server" Text="基本資料設定" Visible="False" meta:resourcekey="msgBasesetupResource1"></asp:Label>
    <asp:Label ID="msgSetup" runat="server" Text="設定" Visible="False" meta:resourcekey="msgSetupResource1"></asp:Label>
    <asp:Label ID="msgDelete" runat="server" meta:resourcekey="msgDeleteResource1" Text="刪除" Visible="False"></asp:Label>
    <asp:Label ID="lbUpdate" runat="server" Text="修改" Visible="False" meta:resourcekey="lbUpdateResource1"></asp:Label>
    <asp:Label ID="msgDeleteUserSet" runat="server" Text="確定要刪除嗎？" Visible="False" meta:resourcekey="msgDeleteUserSetResource1"></asp:Label>
    <input id="hideUser" type="hidden" runat="server" />
    <input id="hidGooglePlayUrl" type="hidden" runat="server" />
    <input id="hidAppleStoreUrl" type="hidden" runat="server" />
    <asp:ObjectDataSource ID="odsFavoUserSet" runat="server" TypeName="Ede.Uof.EIP.Organization.FavoriteUserSetUCO" SelectMethod="GetAllFavoriteUserSet">
        <SelectParameters>
            <asp:ControlParameter ControlID="hideUser" Name="userGUID"
                PropertyName="Value" Type="String" />
        </SelectParameters>
    </asp:ObjectDataSource>
</asp:Content>
