<%@ Control Language="C#" AutoEventWireup="true" Inherits="EIP_Calendar_UC_UnCompleteDevolveList" Codebehind="UC_UnCompleteDevolveList.ascx.cs" %>
<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Fast" %>

<script id="Telerik" type="text/javascript">

    function bar4_Click(sender, args) {
        var key = args.get_item().get_value();
        if (key == "CreateDevelve")
        {
            var UserGuid = '<%=Page.User.Identity.Name%>';
            var date = '<%= Ede.Uof.EIP.Organization.Util.UserTime.SetZone(Ede.Uof.EIP.SystemInfo.Current.UserGUID).GetNowForUi().ToString("yyyy/MM/dd HH:mm:dd") %>';
            args.set_cancel(true);
            $uof.dialog.open2("~/EIP/Calendar/CreateDevolve.aspx", args.get_item(), "", 460, 520, openDialogResult, { "OwnerGuid": UserGuid, "Date": date });
        }
    }

    function openDialogResult(returnValue) {
        if (typeof (returnValue) == 'undefined' || returnValue == null)
            return false;
        else {
            return true;
        }
    }
</script>

<table width="100%" cellpadding="0" cellspacing="0" id="toolbarTB" runat="server">
    <tr>
        <td colspan="11" style="height:30px; vertical-align :top">
            <telerik:RadToolBar ID="RadToolBar1" runat="server" width="100%" OnClientButtonClicking="bar4_Click"
                onbuttonclick="RadToolBar1_ButtonClick">
                <Items>
                    <telerik:RadToolBarButton runat="server" Text="新增交辦" Value="CreateDevelve" meta:resourcekey="TBarButtonResource1"
                         CheckedImageUrl="~/Common/Images/Icon/icon_m27.png"
                         DisabledImageUrl="~/Common/Images/Icon/icon_m27.png"
                         HoveredImageUrl="~/Common/Images/Icon/icon_m27.png"
                         ImageUrl="~/Common/Images/Icon/icon_m27.png"
                    >
                    </telerik:RadToolBarButton>
                    <telerik:RadToolBarButton runat="server" IsSeparator="True" Text="Button 1">
                    </telerik:RadToolBarButton>
                </Items>
            </telerik:RadToolBar>
         </td>
    </tr>   
</table>
<table>
    <tr>
        <td>
            <asp:Image ID="Image2" runat="server" ImageUrl="~/Common/Images/Icon/icon_c11.png" />
            <asp:Label ID="lblSign" runat="server" Text="審核中" meta:resourcekey="lblSignResource1"></asp:Label>
        </td>
        
        <td>
            <asp:Image ID="Image3" runat="server" ImageUrl="~/Common/Images/Icon/icon_c12.png" />
            <asp:Label ID="lblProcess" runat="server" Text="進行中" meta:resourcekey="lblProcessResource1"></asp:Label>
        </td>
        <td>
            <asp:Image ID="Image4" runat="server" ImageUrl="~/Common/Images/Icon/icon_c10.png" />
            <asp:Label ID="lblNotBegin" runat="server" Text="尚未開始" meta:resourcekey="lblNotBeginResource1"></asp:Label>
        </td>
    </tr>
</table>
<asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
        <Fast:Grid ID="Grid1" runat="server" AllowSorting="True" AutoGenerateCheckBoxColumn="False"
            AutoGenerateColumns="False" BorderStyle="None" BorderWidth="0px"
            ShowHeader="False" Width="100%"
            OnRowDataBound="Grid1_RowDataBound" AllowPaging="True" SkinID="HomepageBlockStyle"
            OnPageIndexChanging="Grid1_PageIndexChanging"
            DataKeyOnClientWithCheckBox="False" DefaultSortDirection="Ascending"
            EnhancePager="True" PageSize="15">
            <EnhancePagerSettings FirstAltImageUrl="" FirstImageUrl="" LastAltImage=""
                LastImageUrl="" NextIAltImageUrl="" NextImageUrl="" PageInfoCssClass=""
                PageNumberCssClass="" PageNumberCurrentCssClass="" PageRedirectCssClass=""
                PreviousAltImageUrl="" PreviousImageUrl="" ShowHeaderPager="True" />
            <ExportExcelSettings AllowExportToExcel="False" />
            <Columns>
                <asp:TemplateField meta:resourcekey="TemplateFieldResource1">
                    <ItemTemplate>
                        <table width="100%" border="0">
                            <tr>
                                <td width="16" style="padding-right: 2px; min-width: 16px">
                                    <asp:Image runat="server" ID="imgStatus"></asp:Image>
                                </td>
                                <td width="40%">
                                    <asp:LinkButton runat="server" ID="LinkButton1" Text='<%# Eval("SUBJECT") %>' meta:resourcekey="LinkButton1Resource1" OnClick="LinkButton1_Click"></asp:LinkButton>

                                </td>
                                <td width="28%">
                                    <asp:Label runat="server" ID="lblExecuser" meta:resourcekey="lblExecuserResource1"></asp:Label>

                                </td>
                                <td width="16%" style="white-space: nowrap;">
                                    <asp:Label runat="server" ID="lblOverTime" Text="逾時:{0}天" ForeColor="Red" Visible="false" meta:resourcekey="lblOverTimeResource1"></asp:Label>
                                </td>

                                <td width="16%" style="text-align: right; white-space: nowrap;">
                                    <asp:LinkButton runat="server" ID="LinkButton2" OnClick="LinkButton2_Click" Text="" meta:resourcekey="LinkButton2Resource1"></asp:LinkButton>
                                </td>
                            </tr>
                        </table>

                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <FooterStyle BackColor="White" BorderStyle="None" BorderWidth="0px" />
            <PagerStyle BackColor="White" />
        </Fast:Grid>
    </ContentTemplate>
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="RadToolBar1" EventName="ButtonClick" />
    </Triggers>
</asp:UpdatePanel>
<asp:Label ID="msgSelf" runat="server" Text="自己" Visible="False" meta:resourcekey="msgSelfResource1"></asp:Label>
<asp:Label ID="msgMeeting" runat="server" Text="會議" Visible="False" meta:resourcekey="msgMeetingResource1"></asp:Label>
<asp:Label ID="msgMeetingrecord" runat="server" Text="會議記錄" Visible="False" meta:resourcekey="msgMeetingrecordResource1"></asp:Label>
<asp:Label ID="lblNotice" runat="server" meta:resourceKey="lblNoticeResource1" Text="[知會]" Visible="False"></asp:Label>