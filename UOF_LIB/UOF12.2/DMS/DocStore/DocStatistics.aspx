<%@ Page Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" Inherits="DMS_DocStore_DocStatistics" Title="文件下載統計" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" CodeBehind="DocStatistics.aspx.cs" %>

<%@ Register Assembly="System.Web.Extensions"
    Namespace="System.Web.UI" TagPrefix="asp" %>
<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Fast" %>
<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Charting" TagPrefix="telerik" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <telerik:RadTabStrip ID="RadTabStrip1" runat="server" SelectedIndex="0" MultiPageID="RadMultiPage1">
        <Tabs>
            <telerik:RadTab runat="server" Value="DownloadChart" Text="下載率">
            </telerik:RadTab>
            <telerik:RadTab runat="server" Value="DownloadLog" Text="下載記錄">
            </telerik:RadTab>
        </Tabs>
    </telerik:RadTabStrip>
<telerik:RadMultiPage ID="RadMultiPage1" runat="server" SelectedIndex="0">
    <telerik:RadPageView ID="RadPageView1" runat="server">
        <telerik:RadChart ID="RadChart1" runat="server" DefaultType="Pie" AutoLayout="True" Width="450px"
            Height="370px" IntelligentLabelsEnabled="True"
            OnItemDataBound="RadChart1_ItemDataBound">
            <Series>
                <telerik:ChartSeries Name="Series 1" Type="Pie" DataYColumn="DOWNLOADCOUNT">
                    <Appearance ShowLabelConnectors="True" LegendDisplayMode="ItemLabels">
                    </Appearance>
                </telerik:ChartSeries>
            </Series>
            <ChartTitle Visible="False">
                <Appearance Visible="False">
                </Appearance>
            </ChartTitle>
        </telerik:RadChart>
    </telerik:RadPageView>
    <telerik:RadPageView ID="RadPageView2" runat="server">
        <asp:UpdatePanel id="UpdatePanel1" runat="server">
            <contenttemplate>
                <Fast:Grid id="Grid2" runat="server" Width="100%" AutoGenerateCheckBoxColumn="False" DataKeyNames="DOC_ID,MANUAL_VERSION,USER_GUID" DataKeyOnClientWithCheckBox="False"  AutoGenerateColumns="False" AllowSorting="True" AllowPaging="True" OnPageIndexChanging="Grid2_PageIndexChanging" OnRowDataBound="Grid2_RowDataBound" PageSize="15" EnhancePager="True" OnSorting="Grid2_Sorting">
                    <Columns>
                    <asp:TemplateField HeaderText="下載者" meta:resourcekey="TemplateFieldResource1" SortExpression="USER_GUID">
                        <ItemTemplate>
                        <asp:Label runat="server" ID="lblUser"></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="MANUAL_VERSION" HeaderText="版本" meta:resourcekey="BoundFieldResource1" SortExpression="MANUAL_VERSION"></asp:BoundField>
                        <asp:TemplateField HeaderText="時間" meta:resourcekey="BoundFieldResource2" SortExpression="CREATE_DATE">
                            <ItemTemplate>
                                <asp:Label runat="server" ID="lblCreateDate"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EnhancePagerSettings FirstAltImageUrl="" FirstImageUrl="" LastAltImage="" LastImageUrl=""
                        NextIAltImageUrl="" NextImageUrl="" PageInfoCssClass="" PageNumberCssClass=""
                        PageNumberCurrentCssClass="" PageRedirectCssClass="" PreviousAltImageUrl="" PreviousImageUrl=""
                        ShowHeaderPager="True" />
                </Fast:Grid>
            </contenttemplate>
        </asp:UpdatePanel>
    </telerik:RadPageView>
</telerik:RadMultiPage>    
    &nbsp;
    <asp:Label ID="lblChart" runat="server" Text="下載率" Visible="False" meta:resourcekey="lblChartResource1"></asp:Label>
    <asp:Label ID="lblRecord" runat="server" Text="下載統計" Visible="False" meta:resourcekey="lblRecordResource1"></asp:Label>
    <asp:Label ID="labDlNum" runat="server" Text="下載數" Visible="False" meta:resourcekey="lblChartDlNum"></asp:Label>
    <asp:Label ID="labOtherDoc" runat="server" Text="其他文件" meta:resourcekey="lblOtherDoc" Visible="False"></asp:Label>
    <asp:Label ID="labDocIsDelete" runat="server" Text="文件已被銷毀" Visible="false" meta:resourcekey="labDocIsDeleteResource1"></asp:Label>
</asp:Content>

