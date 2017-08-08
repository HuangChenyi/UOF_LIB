<%@ Control Language="C#" AutoEventWireup="true" Inherits="EIP_Duty_Punch_UC_Punch" Codebehind="UC_Punch.ascx.cs" %>
<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Fast" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>

<script type="text/javascript">
    function PunchToolBar_Click1(sender, args) {
        var toolBar = sender;
        var toolbarbutton = toolBar.findItemByText("date");
        var ddlDate = $telerik.findElement(toolbarbutton.get_element(), ("ddlDate")).value;

        var key = args.get_item().get_value();
        if (key == "btnWork") {
            args.set_cancel(!window.confirm(ddlDate + ' <%=lblConfirmWork.Text %>'));
        }

        if (key == "btnOff") {
            args.set_cancel(!window.confirm(ddlDate + ' <%=lblConfirmOff.Text %>'));
        }
    }
        function OpenGoogleMap() {
            var h = $uof.tool.printScreenSize('h', screen.availHeight);
            var w = $uof.tool.printScreenSize('w', screen.availWidth);
            $uof.window.open("EIP/Duty/Punch/ShowMapLocation.html", w, h);
        }
</script>

<asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>
        <div style="width:99.5%">
            <table style="width: 100%" cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                        <telerik:RadToolBar ID="RadToolBar1" runat="server" OnClientButtonClicking="PunchToolBar_Click1" Width="100%"
                            OnButtonClick="RadToolBar1_ButtonClick">
                            <Items>
                                <telerik:RadToolBarButton runat="server" Value="date" Text="date">
                                    <ItemTemplate>
                                        <table>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="Label1" runat="server" meta:resourcekey="TBLabelResource1"
                                                        Text="歸屬日"></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:DropDownList runat="server" ID="ddlDate" AutoPostBack="true" OnSelectedIndexChanged="ddlDate_SelectedIndexChanged"></asp:DropDownList>
                                                </td>
                                            </tr>
                                        </table>
                                    </ItemTemplate>
                                </telerik:RadToolBarButton>
                                <telerik:RadToolBarButton runat="server" IsSeparator="True" Text="sp0">
                                </telerik:RadToolBarButton>
                                <telerik:RadToolBarButton runat="server" Text="簽到" Value="btnWork" Enabled="False" meta:resourcekey="TBarButtonResource1"
                                    CheckedImageUrl="~/Common/Images/Icon/icon22_04.png"
                                    DisabledImageUrl="~/Common/Images/Icon/icon22_04.png"
                                    HoveredImageUrl="~/Common/Images/Icon/icon22_04.png"
                                    ImageUrl="~/Common/Images/Icon/icon22_04.png">
                                </telerik:RadToolBarButton>
                                <telerik:RadToolBarButton runat="server" IsSeparator="True" Text="sp1">
                                </telerik:RadToolBarButton>
                                <telerik:RadToolBarButton runat="server" Text="簽退" Value="btnOff" Enabled="False" meta:resourcekey="TBarButtonResource2"
                                    CheckedImageUrl="~/Common/Images/Icon/icon22_05.png"
                                    DisabledImageUrl="~/Common/Images/Icon/icon22_05.png"
                                    HoveredImageUrl="~/Common/Images/Icon/icon22_05.png"
                                    ImageUrl="~/Common/Images/Icon/icon22_05.png">
                                </telerik:RadToolBarButton>
                                <telerik:RadToolBarButton runat="server" IsSeparator="True" Text="sp2">
                                </telerik:RadToolBarButton>
                                <telerik:RadToolBarButton runat="server" Value="TimeZone">
                                    <ItemTemplate>
                                        <asp:Label ID="lblUserTimeZoneName" runat="server"></asp:Label>
                                    </ItemTemplate>
                                </telerik:RadToolBarButton>
                            </Items>
                        </telerik:RadToolBar>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:CustomValidator ID="CusVail_IP" runat="server" ErrorMessage="IP不合法，不允許刷卡"
                            meta:resourcekey="CusVail_IPResource1" Display="Dynamic"></asp:CustomValidator></td>
                </tr>
                <tr>
                    <td>
                        <Fast:Grid ID="PunchGrid" runat="server" AutoGenerateCheckBoxColumn="False"
                            AllowSorting="True" AutoGenerateColumns="False" 
                            DataKeyOnClientWithCheckBox="False" DefaultSortDirection="Ascending"
                            EmptyDataText="沒有資料" EnableModelValidation="True" EnhancePager="True"
                            KeepSelectedRows="False" PageSize="15"
                            OnRowDataBound="PunchGrid_RowDataBound" Width="100%"
                            meta:resourcekey="PunchGridResource2">
                            <EnhancePagerSettings ShowHeaderPager="True" FirstAltImageUrl=""
                                FirstImageUrl="" LastAltImage="" LastImageUrl="" NextIAltImageUrl=""
                                NextImageUrl="" PageInfoCssClass="" PageNumberCssClass=""
                                PageNumberCurrentCssClass="" PageRedirectCssClass="" PreviousAltImageUrl=""
                                PreviousImageUrl="" />
                            <ExportExcelSettings AllowExportToExcel="False" />
                            <Columns>
                                <asp:TemplateField HeaderText="姓名" meta:resourcekey="TemplateFieldResource1">
                                    <ItemTemplate>
                                        <asp:Label ID="lblName" runat="server" meta:resourcekey="lblNameResource1"></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle Width="33%" />
                                    <ItemStyle HorizontalAlign="Center" Wrap="false"/>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="簽到" meta:resourcekey="TemplateFieldResource2">
                                    <ItemTemplate>
                                        <asp:Label ID="lblWork" runat="server"
                                            Text='<%# Bind("WORK_CLOCK_TIME", "{0:HH:mm}") %>'
                                            meta:resourcekey="lblWorkResource1"></asp:Label>
                                        <asp:ImageButton ID="imgWorkLocation" runat="server" Visible="false" ImageUrl="~/Common/Images/Icon/icon_m207.png" />
                                    </ItemTemplate>
                                    <HeaderStyle Width="33%" />
                                    <ItemStyle HorizontalAlign="Center" Wrap="false" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="簽退" meta:resourcekey="TemplateFieldResource3">
                                    <ItemTemplate>
                                        <asp:Label ID="lblOff" runat="server"
                                            Text='<%# Bind("OFF_CLOCK_TIME", "{0:HH:mm}") %>'
                                            meta:resourcekey="lblOffResource1"></asp:Label>
                                        <asp:ImageButton ID="imgOffLocation" runat="server" Visible="false" ImageUrl="~/Common/Images/Icon/icon_m207.png" />
                                    </ItemTemplate>
                                    <HeaderStyle Width="33%" />
                                    <ItemStyle HorizontalAlign="Center" Wrap="false"/>
                                </asp:TemplateField>
                            </Columns>
                        </Fast:Grid>

                    </td>
                </tr>
            </table>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>
<asp:Label runat="server" ID="lblConfirmWork" Visible="False" Text="確定簽到？"
    meta:resourcekey="lblConfirmWorkResource1"></asp:Label>
<asp:Label runat="server" ID="lblConfirmOff" Visible="False" Text="確定簽退？"
    meta:resourcekey="lblConfirmOffResource1"></asp:Label>
<asp:Label ID="lblMapTitle" runat="server" Text="刷卡位置" Visible="false" meta:resourcekey="lblMapTitleResource1"></asp:Label>
<asp:HiddenField ID="hfCurrentUser" runat="server" />


