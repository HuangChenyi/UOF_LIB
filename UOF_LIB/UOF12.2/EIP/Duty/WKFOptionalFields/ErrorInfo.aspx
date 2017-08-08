<%@ Page Title="錯誤資訊" Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" Inherits="WKFOptionalFields_ErrorInfo" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="ErrorInfo.aspx.cs" %>

<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Fast" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        Sys.Application.add_load(function () {
            var curwindow = $uof.dialog.getOpener();
            var pd;
            if (curwindow) {
                pd = curwindow.document;
            } else if (typeof (dialogArguments) != "undefined") {
                pd = dialogArguments.document;
            }
            if (pd) {

                $("#<%=hidUser.ClientID %>").val($("#<%=Request["users"]%>", pd).val());
                if ($('#<%= hidPostBack.ClientID%>').val() === "First") {
                    $('#<%= btnLoadUser.ClientID%>').click();
                }
            }
        });
        
    </script>
    <table class="PopTable" id="table1" runat="server" style="display:none">
        <tr id="trPunch" runat="server" style="display: none;">
            <td style="text-align: center!important" class="PopTableHeader">
                <asp:Label ID="Label1" runat="server" Text="加班時間未在刷卡時間內之人員"
                    meta:resourcekey="Label1Resource1"></asp:Label>
            </td>
        </tr>
        <tr id="trPunchGrid" runat="server" style="display: none;">
            <td>
                <Fast:Grid ID="girdPunch" runat="server" AutoGenerateCheckBoxColumn="False" AllowSorting="True"
                    AutoGenerateColumns="False" DataKeyOnClientWithCheckBox="False"
                    DefaultSortDirection="Ascending" EmptyDataText="沒有資料"
                    EnhancePager="True" KeepSelectedRows="False" PageSize="15"
                    Width="100%" ShowHeader="False"
                    OnRowDataBound="girdPunch_RowDataBound"
                    meta:resourcekey="girdPunchResource1">
                    <EnhancePagerSettings FirstImageUrl="" FirstAltImageUrl="" PreviousImageUrl="" NextImageUrl=""
                        LastImageUrl="" LastAltImage="" PageNumberCssClass="" PageNumberCurrentCssClass=""
                        PageInfoCssClass="" PageRedirectCssClass="" NextIAltImageUrl="" PreviousAltImageUrl=""
                        ShowHeaderPager="True"></EnhancePagerSettings>
                    <ExportExcelSettings AllowExportToExcel="False"></ExportExcelSettings>
                    <Columns>
                        <asp:TemplateField HeaderText="人員" meta:resourcekey="TemplateFieldResource1">
                            <ItemTemplate>
                                <asp:Label ID="lblPunchUser" runat="server"
                                    meta:resourcekey="lblPunchUserResource1"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Left" Width="50%" />
                        </asp:TemplateField>
                    </Columns>
                </Fast:Grid>
            </td>
        </tr>
        <tr id="trTravel" runat="server">
            <td style="text-align: center!important" class="PopTableHeader">
                <asp:Label ID="Label4" runat="server" Text="與出差單時間重疊之人員"
                    meta:resourcekey="Label4Resource1"></asp:Label>
            </td>
        </tr>
        <tr id="trTravelGrid" runat="server">
            <td>
                <Fast:Grid ID="gridTravel" runat="server" AutoGenerateCheckBoxColumn="False" AllowSorting="True"
                    AutoGenerateColumns="False" DataKeyOnClientWithCheckBox="False"
                    DefaultSortDirection="Ascending" EmptyDataText="沒有資料"
                    EnhancePager="True" KeepSelectedRows="False" PageSize="15"
                    Width="100%"
                    ShowHeader="False" OnRowDataBound="gridTravel_RowDataBound"
                    meta:resourcekey="gridTravelResource1">
                    <EnhancePagerSettings FirstImageUrl="" FirstAltImageUrl="" PreviousImageUrl="" NextImageUrl=""
                        LastImageUrl="" LastAltImage="" PageNumberCssClass="" PageNumberCurrentCssClass=""
                        PageInfoCssClass="" PageRedirectCssClass="" NextIAltImageUrl="" PreviousAltImageUrl=""
                        ShowHeaderPager="True"></EnhancePagerSettings>
                    <ExportExcelSettings AllowExportToExcel="False"></ExportExcelSettings>
                    <Columns>
                        <asp:TemplateField HeaderText="人員" meta:resourcekey="TemplateFieldResource2">
                            <ItemTemplate>
                                <asp:Label ID="lblTravelUser" runat="server"
                                    meta:resourcekey="lblTravelUserResource1"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Left" Width="50%" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="單號" Visible="false"
                            meta:resourcekey="TemplateFieldResource3">
                            <ItemTemplate>
                                <asp:LinkButton ID="lbtnOTDocNbr" runat="server"
                                    meta:resourcekey="lbtnOTDocNbrResource1"></asp:LinkButton>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Left" />
                        </asp:TemplateField>
                    </Columns>
                </Fast:Grid>
            </td>
        </tr>
        <tr id="trLeave" runat="server">
            <td style="text-align: center!important" class="PopTableHeader">
                <asp:Label ID="Label2" runat="server" Text="與請假單時間重疊之人員"
                    meta:resourcekey="Label2Resource1"></asp:Label>
            </td>
        </tr>
        <tr id="trLeaveGrid" runat="server">
            <td>
                <Fast:Grid ID="gridLeave" runat="server" AutoGenerateCheckBoxColumn="False" AllowSorting="True"
                    AutoGenerateColumns="False" DataKeyOnClientWithCheckBox="False"
                    DefaultSortDirection="Ascending" EmptyDataText="沒有資料"
                    EnhancePager="True" KeepSelectedRows="False" PageSize="15"
                    Width="100%" OnRowDataBound="gridLeave_RowDataBound"
                    ShowHeader="False" meta:resourcekey="gridLeaveResource1">
                    <EnhancePagerSettings FirstImageUrl="" FirstAltImageUrl="" PreviousImageUrl="" NextImageUrl=""
                        LastImageUrl="" LastAltImage="" PageNumberCssClass="" PageNumberCurrentCssClass=""
                        PageInfoCssClass="" PageRedirectCssClass="" NextIAltImageUrl="" PreviousAltImageUrl=""
                        ShowHeaderPager="True"></EnhancePagerSettings>
                    <ExportExcelSettings AllowExportToExcel="False"></ExportExcelSettings>
                    <Columns>
                        <asp:TemplateField HeaderText="人員" meta:resourcekey="TemplateFieldResource4">
                            <ItemTemplate>
                                <asp:Label ID="lblLeaveUser" runat="server"
                                    meta:resourcekey="lblLeaveUserResource1"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Left" Width="50%" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="單號" Visible="false"
                            meta:resourcekey="TemplateFieldResource5">
                            <ItemTemplate>
                                <asp:Label ID="lblLeaveNbr" runat="server"
                                    meta:resourcekey="lblLeaveNbrResource1"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </Fast:Grid>
            </td>
        </tr>
        <tr id="trOvertime" runat="server">
            <td style="text-align: center!important" class="PopTableHeader">
                <asp:Label ID="Label3" runat="server" Text="與加班單時間重疊之人員"
                    meta:resourcekey="Label3Resource1"></asp:Label>
            </td>
        </tr>
        <tr id="trOTGrid" runat="server">
            <td>
                <Fast:Grid ID="gridOvertime" runat="server" AutoGenerateCheckBoxColumn="False" AllowSorting="True"
                    AutoGenerateColumns="False" DataKeyOnClientWithCheckBox="False"
                    DefaultSortDirection="Ascending" EmptyDataText="沒有資料"
                    EnhancePager="True" KeepSelectedRows="False" PageSize="15"
                    Width="100%"
                    OnRowDataBound="gridOvertime_RowDataBound" ShowHeader="False"
                    meta:resourcekey="gridOvertimeResource1">
                    <EnhancePagerSettings FirstImageUrl="" FirstAltImageUrl="" PreviousImageUrl="" NextImageUrl=""
                        LastImageUrl="" LastAltImage="" PageNumberCssClass="" PageNumberCurrentCssClass=""
                        PageInfoCssClass="" PageRedirectCssClass="" NextIAltImageUrl="" PreviousAltImageUrl=""
                        ShowHeaderPager="True"></EnhancePagerSettings>
                    <ExportExcelSettings AllowExportToExcel="False"></ExportExcelSettings>
                    <Columns>
                        <asp:TemplateField HeaderText="人員" meta:resourcekey="TemplateFieldResource6">
                            <ItemTemplate>
                                <asp:Label ID="lblUser" runat="server" meta:resourcekey="lblUserResource1"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Left" Width="50%" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="單號" Visible="false"
                            meta:resourcekey="TemplateFieldResource7">
                            <ItemTemplate>
                                <asp:LinkButton ID="lbtnOTDocNbr" runat="server"
                                    meta:resourcekey="lbtnOTDocNbrResource2"></asp:LinkButton>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Left" />
                        </asp:TemplateField>
                    </Columns>
                </Fast:Grid>
            </td>
        </tr>
        <tr id="trUserSett" runat="server">
            <td style="text-align: center!important" class="PopTableHeader">
                <asp:Label ID="Label5" runat="server" Text="差勤結算類別不同之人員" meta:resourcekey="Label5Resource1"></asp:Label>
            </td>
        </tr>
        <tr id="trUserSettGrid" runat="server">
            <td>
                <Fast:Grid ID="gridOTS" runat="server" AutoGenerateCheckBoxColumn="False" AllowSorting="True"
                    AutoGenerateColumns="False" DataKeyOnClientWithCheckBox="False"
                    DefaultSortDirection="Ascending" EmptyDataText="沒有資料"
                    EnhancePager="True" KeepSelectedRows="False" PageSize="15" 
                    Width="100%" ShowHeader="False" 
                    meta:resourcekey="gridOTSResource1">
                    <EnhancePagerSettings FirstImageUrl="" FirstAltImageUrl="" PreviousImageUrl="" NextImageUrl=""
                        LastImageUrl="" LastAltImage="" PageNumberCssClass="" PageNumberCurrentCssClass=""
                        PageInfoCssClass="" PageRedirectCssClass="" NextIAltImageUrl="" PreviousAltImageUrl=""
                        ShowHeaderPager="True"></EnhancePagerSettings>
                    <ExportExcelSettings AllowExportToExcel="False"></ExportExcelSettings>
                    <Columns>
                         <asp:BoundField DataField="USERS_SETT" HeaderText="期別" 
                                    ItemStyle-Wrap="false" ItemStyle-HorizontalAlign="Left" HeaderStyle-Wrap="false" meta:resourcekey="BoundFieldResource1" />
                    </Columns>
                </Fast:Grid>

            </td>
        </tr>
        <tr id="trTimeZone" runat="server">
            <td style="text-align: center!important" class="PopTableHeader">
                <asp:Label ID="Label6" runat="server" Text="歸屬地點不同之人員" meta:resourcekey="Label6Resource1"></asp:Label>
            </td>
        </tr>
        <tr id="trTimeZoneGrid" runat="server">
            <td>
                <Fast:Grid ID="gridTimeZone" runat="server" AutoGenerateCheckBoxColumn="False" AllowSorting="True"
                    AutoGenerateColumns="False" DataKeyOnClientWithCheckBox="False"
                    DefaultSortDirection="Ascending" EmptyDataText="沒有資料"
                    EnhancePager="True" KeepSelectedRows="False" PageSize="15" 
                    Width="100%" ShowHeader="False" OnRowDataBound="gridTimeZone_RowDataBound"
                    meta:resourcekey="gridOTSResource1">
                    <EnhancePagerSettings FirstImageUrl="" FirstAltImageUrl="" PreviousImageUrl="" NextImageUrl=""
                        LastImageUrl="" LastAltImage="" PageNumberCssClass="" PageNumberCurrentCssClass=""
                        PageInfoCssClass="" PageRedirectCssClass="" NextIAltImageUrl="" PreviousAltImageUrl=""
                        ShowHeaderPager="True"></EnhancePagerSettings>
                    <ExportExcelSettings AllowExportToExcel="False"></ExportExcelSettings>
                    <Columns>
                         <asp:TemplateField HeaderText="歸屬地點" 
                            meta:resourcekey="TemplateFieldResource8">
                            <ItemTemplate>
                                <asp:Label ID="lblTimeZone" runat="server" Text=""></asp:Label>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Left" />
                        </asp:TemplateField>
                    </Columns>
                </Fast:Grid>
            </td>
        </tr>
        <tr id="trNotAllowOverTime" runat="server">
            <td style="text-align: center!important" class="PopTableHeader">
                <asp:Label ID="Label7" runat="server" Text="歸屬日不允許加班之人員" meta:resourcekey="Label7Resource1"></asp:Label>
            </td>
        </tr>
        <tr id="trNotAllowOverTimeGrid" runat="server">
            <td>
                <Fast:Grid ID="gridNotAllowOverTime" runat="server" AutoGenerateCheckBoxColumn="False" AllowSorting="True"
                    AutoGenerateColumns="False" DataKeyOnClientWithCheckBox="False"
                    DefaultSortDirection="Ascending" EmptyDataText="沒有資料"
                    EnhancePager="True" KeepSelectedRows="False" PageSize="15"
                    Width="100%" ShowHeader="False"
                    OnRowDataBound="gridNotAllowOverTime_RowDataBound"
                    meta:resourcekey="gridNotAllowOverTimeResource1">
                    <EnhancePagerSettings FirstImageUrl="" FirstAltImageUrl="" PreviousImageUrl="" NextImageUrl=""
                        LastImageUrl="" LastAltImage="" PageNumberCssClass="" PageNumberCurrentCssClass=""
                        PageInfoCssClass="" PageRedirectCssClass="" NextIAltImageUrl="" PreviousAltImageUrl=""
                        ShowHeaderPager="True"></EnhancePagerSettings>
                    <ExportExcelSettings AllowExportToExcel="False"></ExportExcelSettings>
                    <Columns>
                        <asp:TemplateField HeaderText="人員" meta:resourcekey="TemplateFieldResource9">
                            <ItemTemplate>
                                <asp:Label ID="lblNotAllowOverTimeUser" runat="server"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Left" Width="50%" />
                        </asp:TemplateField>
                    </Columns>
                </Fast:Grid>
            </td>
        </tr>
    </table>
    <asp:HiddenField ID="hidPostBack" runat="server" />
    <asp:HiddenField ID="hidUser" runat="server" />
    <div style="display: none">
        <asp:Button ID="btnLoadUser" runat="server" Text="" onclick="btnLoadUser_Click" />    
    </div>
</asp:Content>

