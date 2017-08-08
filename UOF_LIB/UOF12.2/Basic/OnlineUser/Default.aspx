<%@ Page Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" Inherits="Basic_OnlineUser_Default" Title="" Culture="auto" meta:resourcekey="PageResource2" UICulture="auto" Codebehind="Default.aspx.cs" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Fast" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table style="width: 100%;">
                <tr>
                    <td style="padding-top: 2px;">&nbsp;<telerik:RadButton ID="rbtnRefresh" runat="server"
                        OnClick="rbtnRefresh_Click" meta:resourcekey="rbtnRefreshResource1">
                    </telerik:RadButton>
                    </td>
                </tr>
                <tr>
                    <td>
                        <Fast:Grid ID="Grid1" Width="100%" runat="server" AllowSorting="True" AutoGenerateCheckBoxColumn="False"
                            DataSourceID="ObjectDataSource1"
                            AutoGenerateColumns="False" DataKeyNames="userGUID,ip"
                            OnPageIndexChanging="Grid1_PageIndexChanging" OnRowCommand="Grid1_RowCommand"
                            OnRowDataBound="Grid1_RowDataBound" AllowPaging="True"
                            DataKeyOnClientWithCheckBox="False" 
                            DefaultSortDirection="Ascending" EmptyDataText="沒有資料"
                            EnhancePager="True" KeepSelectedRows="False" meta:resourcekey="Grid1Resource2"
                            PageSize="15"  >
                            <EnhancePagerSettings FirstAltImageUrl="" FirstImageUrl="" LastAltImage=""
                                LastImageUrl="" NextIAltImageUrl="" NextImageUrl="" PageInfoCssClass=""
                                PageNumberCssClass="" PageNumberCurrentCssClass="" PageRedirectCssClass=""
                                PreviousAltImageUrl="" PreviousImageUrl="" ShowHeaderPager="True" />
                            <ExportExcelSettings AllowExportToExcel="False" />
                            <Columns>
                                <asp:TemplateField HeaderText="使用者" ItemStyle-Wrap="false" SortExpression="userGUID" meta:resourcekey="TemplateFieldResource1">
                                    <ItemTemplate>
                                        <asp:Label runat="server" Text='<%# Bind("userGUID") %>' ID="Label1" meta:resourceKey="Label1Resource1"></asp:Label>


                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField HeaderText="IP" DataField="ip" ItemStyle-Wrap="false"
                                    SortExpression="ip" meta:resourcekey="BoundFieldResource2" />
                                <asp:TemplateField HeaderText="最後要求時間" ItemStyle-Wrap="false" SortExpression="requestTime" meta:resourcekey="BoundFieldResource1">
                                    <ItemTemplate>
                                        <asp:Label runat="server" ID="lblRequestTime"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="使用模組" SortExpression="module" ItemStyle-Wrap="false" meta:resourcekey="TemplateFieldResource2">
                                    <ItemTemplate>
                                        <asp:Label runat="server" Text='<%# Bind("module") %>' ID="Label2" meta:resourceKey="Label2Resource1"></asp:Label>


                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </Fast:Grid>
                    </td>
                </tr>
            </table>
            <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" SelectMethod="GetOnlineUsers"
                TypeName="Ede.Uof.Utility.OnlineManagement.OnlineUser"></asp:ObjectDataSource>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:Label ID="lbRefresh" runat="server" Text="更新名單" Visible="False" meta:resourcekey="lbRefreshResource1"></asp:Label>
</asp:Content>

