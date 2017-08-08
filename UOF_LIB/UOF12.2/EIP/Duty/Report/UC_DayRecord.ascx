<%@ Control Language="C#" AutoEventWireup="true"
    Inherits="EIP_Duty_Report_UC_DayRecord" Codebehind="UC_DayRecord.ascx.cs" %>
<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Fast" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>


<script type="text/javascript">
    function PunchToolBar_Click1(sender, args) {
        var toolBar = sender;
        var toolbarbutton = toolBar.findItemByText("date");
        var rdpDate = toolbarbutton.findControl("rdpDate");
        var ddlDate = $telerik.findElement(toolbarbutton.get_element(), ("ddlDate")).value;

        var key = args.get_item().get_value();
        if (key == "btnWork") {
            args.set_cancel(!window.confirm(ddlDate + ' <%=lblConfirmWork.Text %>'));
        }

        if (key == "btnOff") {
            args.set_cancel(!window.confirm(ddlDate + ' <%=lblConfirmOff.Text %>'));
        }
    }

</script>
<asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>
        <div style="width: 99%">
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
                    <telerik:RadToolBarButton runat="server" Value="subDept" meta:resourcekey="TBarButtonResource3">
                        <ItemTemplate>
                            <asp:CheckBox ID="cbSubDept" Text="包含子部門" AutoPostBack="True" runat="server" OnCheckedChanged="cbSubDept_CheckedChanged" meta:resourcekey="cbSubDeptResource1" />
                        </ItemTemplate>
                    </telerik:RadToolBarButton>
                    <telerik:RadToolBarButton runat="server" IsSeparator="True" Text="sp3" Value="QueryDept">
                    </telerik:RadToolBarButton>
                    <telerik:RadToolBarButton runat="server" Value="TimeZoneDayRecord">
                        <ItemTemplate>
                            <asp:Label ID="lblUserTimeZoneName" runat="server"></asp:Label>
                        </ItemTemplate>
                    </telerik:RadToolBarButton>
                </Items>
            </telerik:RadToolBar>
            <asp:CustomValidator ID="CusVail_IP" runat="server" ErrorMessage="IP不合法，不允許刷卡" EnableClientScript="False" meta:resourcekey="CusVail_IPResource1"
                Display="Dynamic"></asp:CustomValidator>
            <Fast:Grid ID="DayRecordGrid" runat="server" AllowPaging="True" AllowSorting="True"
                AutoGenerateCheckBoxColumn="False" AutoGenerateColumns="False"
                DataKeyOnClientWithCheckBox="False" DefaultSortDirection="Ascending" EmptyDataText="沒有資料" EnhancePager="True" KeepSelectedRows="False" OnPageIndexChanging="DayRecordGrid_PageIndexChanging"
                OnRowDataBound="DayRecordGrid_RowDataBound"
                Width="100%" meta:resourcekey="DayRecordGridResource1" PageSize="15" CustomDropDownListPage="False" SelectedRowColor="" UnSelectedRowColor="" OnSorting="DayRecordGrid_Sorting" DefaultSortColumnName="NAME">
                <EnhancePagerSettings ShowHeaderPager="False" />
                <ExportExcelSettings AllowExportToExcel="False" />
                <Columns>
                    <asp:TemplateField HeaderText="姓名" SortExpression="NAME" meta:resourcekey="TemplateFieldResource1">
                        <ItemTemplate>
                            <asp:Label ID="lblName" runat="server" meta:resourcekey="lblNameResource1"></asp:Label>
                        </ItemTemplate>
                        <HeaderStyle Width="20%" />
                        <ItemStyle HorizontalAlign="Center" Wrap="false"/>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="簽到" meta:resourcekey="TemplateFieldResource2">
                        <ItemTemplate>
                            <table style="width: 80px" align="center">
                                <tr>
                                    <td style="width: 5px;"></td>
                                    <td style="text-align: right; width: 50px; white-space:nowrap;">
                                        <asp:Label ID="lblWork" runat="server" meta:resourcekey="lblWorkResource1" Text='<%# Bind("WORK_CLOCK_TIME", "{0:HH:mm}") %>'></asp:Label>
                                    </td>
                                    <td style="width: 5px;"></td>
                                    <td style="text-align: left; width: 15px; white-space:nowrap;">
                                        <asp:ImageButton ID="imgWorkLocation" runat="server" ImageUrl="~/Common/Images/Icon/icon_m207.png" Visible="false" />
                                    </td>
                                    <td style="width: 5px;"></td>
                                </tr>
                            </table>
                        </ItemTemplate>
                        <HeaderStyle Width="15%" />
                        <ItemStyle HorizontalAlign="Center" Wrap="false"/>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="簽退" meta:resourcekey="TemplateFieldResource3">
                        <ItemTemplate>
                            <table style="width: 80px" align="center">
                                <tr>
                                    <td style="width: 5px;"></td>
                                    <td style="text-align: right; width: 50px; white-space:nowrap;">
                                        <asp:Label ID="lblOff" runat="server" meta:resourcekey="lblOffResource1" Text='<%# Bind("OFF_CLOCK_TIME", "{0:HH:mm}") %>'></asp:Label>
                                    </td>
                                    <td style="width: 5px;"></td>
                                    <td style="text-align: left; width: 15px; white-space:nowrap;">
                                        <asp:ImageButton ID="imgOffLocation" runat="server" ImageUrl="~/Common/Images/Icon/icon_m207.png" Visible="false" />
                                    </td>
                                    <td style="width: 5px;"></td>
                                </tr>
                            </table>
                        </ItemTemplate>
                        <HeaderStyle Width="15%" />
                        <ItemStyle HorizontalAlign="Center" Wrap="false"/>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="請假" meta:resourcekey="BoundFieldResource4">
                        <ItemTemplate>
                            <asp:Label ID="lblLeaveString" runat="server"
                                meta:resourcekey="lblLeaveStringResource1"></asp:Label>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" Wrap="false" />
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="出差" meta:resourcekey="TemplateFieldResource4">
                        <ItemTemplate>
                            <asp:Label ID="lblTravelString" runat="server" meta:resourcekey="lblTravelStringResource1"></asp:Label>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                    </asp:TemplateField>

                </Columns>
            </Fast:Grid>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>
<asp:Label runat="server" ID="lblConfirmWork" Visible="False" Text="確定簽到？" meta:resourcekey="lblConfirmWorkResource1"></asp:Label>
<asp:Label runat="server" ID="lblConfirmOff" Visible="False" Text="確定簽退？" meta:resourcekey="lblConfirmOffResource1"></asp:Label>
<asp:Label ID="lblMapTitle" runat="server" Text="刷卡位置" Visible="false" meta:resourcekey="lblMapTitleResource1"></asp:Label>
<asp:HiddenField ID="hfCurrentUser" runat="server" />
