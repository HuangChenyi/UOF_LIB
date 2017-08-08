﻿<%@ Page Title="明細" Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" CodeBehind="SyncHRDetail.aspx.cs" Inherits="Ede.Uof.Web.HR104.SyncHR.SyncHRDetail" culture="auto" meta:resourcekey="PageResource1" uiculture="auto" %>
<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="EdeGrid" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <telerik:RadToolBar ID="RadToolBar1" runat="server" SingleClick="None" Width="100%" OnButtonClick="RadToolBar1_ButtonClick" meta:resourcekey="RadToolBar1Resource1">
        <Items>
            <telerik:RadToolBarButton runat="server" Value="QueryCondition" meta:resourcekey="RadToolBarButtonResource1">
                <ItemTemplate>
                    <table>
                        <tr>
                            <td>
                                <asp:Label ID="Label1" runat="server" Text="關鍵字:" meta:resourcekey="Label1Resource1" ></asp:Label>
                            </td>
                            <td>
                                <asp:TextBox ID="txtKeyWord" runat="server" meta:resourcekey="txtKeyWordResource1" ></asp:TextBox>
                            </td>
                            <td>&nbsp;&nbsp;</td>
                            <td>
                                <asp:Label ID="Label3" runat="server" Text="狀態:" meta:resourcekey="Label3Resource1"></asp:Label>
                            </td>
                            <td>&nbsp;</td>
                            <td>
                                <asp:DropDownList ID="ddlType" runat="server" meta:resourcekey="ddlTypeResource1">
                                    <asp:ListItem Text="全部" meta:resourcekey="ListItemResource1"></asp:ListItem>
                                    <asp:ListItem Text="新增" Value="Insert" meta:resourcekey="ListItemResource2"></asp:ListItem>
                                    <asp:ListItem Text="更新" Value="Update" meta:resourcekey="ListItemResource3"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td>&nbsp;</td>
                        </tr>
                    </table>
                </ItemTemplate>
            </telerik:RadToolBarButton>
            <telerik:RadToolBarButton runat="server" Text="查詢" Value="Query"
                ClickedImageUrl="~/Common/Images/Icon/icon_m39.png" DisabledImageUrl="~/Common/Images/Icon/icon_m39.png"
                HoveredImageUrl="~/Common/Images/Icon/icon_m39.png" ImageUrl="~/Common/Images/Icon/icon_m39.png" meta:resourcekey="RadToolBarButtonResource2">
            </telerik:RadToolBarButton>
            <telerik:RadToolBarButton runat="server" IsSeparator="True" meta:resourcekey="RadToolBarButtonResource3">
            </telerik:RadToolBarButton>
            <telerik:RadToolBarButton runat="server" Value="QueryShowCount" meta:resourcekey="RadToolBarButtonResource4">
                <ItemTemplate>
                    <table>
                        <tr>
                            <td>
                                <asp:Label ID="lblSyncCount" runat="server" Text="共新增{0}筆;共更新{1}筆" ForeColor="Blue" meta:resourcekey="lblSyncCountResource1" ></asp:Label>
                            </td>
                        </tr>
                    </table>
                </ItemTemplate>
            </telerik:RadToolBarButton>
        </Items>
    </telerik:RadToolBar>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <EdeGrid:Grid ID="detailGrid" runat="server" AutoGenerateCheckBoxColumn="False" AllowSorting="True" 
                AutoGenerateColumns="False" CustomDropDownListPage="False" DataKeyOnClientWithCheckBox="False" 
                DefaultSortDirection="Ascending" EmptyDataText="No data found" EnhancePager="True" 
                KeepSelectedRows="False" PageSize="15" SelectedRowColor="" UnSelectedRowColor="" 
                Width="100%" DefaultSortColumnName="NAME" AllowPaging="True" 
                OnPageIndexChanging="detailGrid_PageIndexChanging" OnRowDataBound="detailGrid_RowDataBound" 
                OnSorting="detailGrid_Sorting" OnBeforeExport="detailGrid_BeforeExport" meta:resourcekey="detailGridResource1" >
                <EnhancePagerSettings ShowHeaderPager="True" FirstAltImageUrl="" FirstImageUrl="" LastAltImage="" LastImageUrl="" NextIAltImageUrl="" NextImageUrl="" PageInfoCssClass="" PageNumberCssClass="" PageNumberCurrentCssClass="" PageRedirectCssClass="" PreviousAltImageUrl="" PreviousImageUrl=""></EnhancePagerSettings>

                <ExportExcelSettings AllowExportToExcel="False" DataSourceType="ObjectDataSource"></ExportExcelSettings>
                <Columns>
                    <asp:BoundField HeaderText="部門名稱" DataField="NAME" SortExpression="NAME" meta:resourcekey="BoundFieldResource1">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField HeaderText="部門代碼" DataField="GROUP_CODE" SortExpression="GROUP_CODE" meta:resourcekey="BoundFieldResource2">
                        <HeaderStyle Wrap="False" Width="150px" />
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="狀態" meta:resourcekey="TemplateFieldResource1" >
                        <EditItemTemplate>
                            <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("SYNC_TYPE") %>' meta:resourcekey="TextBox1Resource1" ></asp:TextBox>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="lblSyncType" runat="server" Text='<%# Bind("SYNC_TYPE") %>' meta:resourcekey="lblSyncTypeResource1" ></asp:Label>
                        </ItemTemplate>
                        <HeaderStyle Wrap="False" Width="150px" />
                        <ItemStyle Wrap="False" HorizontalAlign="Center" />
                    </asp:TemplateField>

                </Columns>
            </EdeGrid:Grid>
            <EdeGrid:Grid ID="userDetailGuid" runat="server" AutoGenerateCheckBoxColumn="False" AllowSorting="True" 
                AutoGenerateColumns="False" CustomDropDownListPage="False" DataKeyOnClientWithCheckBox="False" 
                DefaultSortDirection="Ascending" EmptyDataText="No data found" EnhancePager="True" 
                KeepSelectedRows="False" PageSize="15" SelectedRowColor="" UnSelectedRowColor="" 
                Width="100%" DefaultSortColumnName="NAME" AllowPaging="True" 
                OnPageIndexChanging="userDetailGuid_PageIndexChanging" OnRowDataBound="userDetailGuid_RowDataBound" 
                OnSorting="userDetailGuid_Sorting" OnBeforeExport="userDetailGuid_BeforeExport" meta:resourcekey="userDetailGuidResource1" >
                <EnhancePagerSettings ShowHeaderPager="True" FirstAltImageUrl="" FirstImageUrl="" LastAltImage="" LastImageUrl="" NextIAltImageUrl="" NextImageUrl="" PageInfoCssClass="" PageNumberCssClass="" PageNumberCurrentCssClass="" PageRedirectCssClass="" PreviousAltImageUrl="" PreviousImageUrl=""></EnhancePagerSettings>

                <ExportExcelSettings AllowExportToExcel="False" DataSourceType="ObjectDataSource"></ExportExcelSettings>
                <Columns>
                    <asp:BoundField DataField="ACCOUNT" HeaderText="帳號" SortExpression="ACCOUNT" meta:resourcekey="BoundFieldResource3" >
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField HeaderText="姓名" DataField="NAME" SortExpression="NAME" meta:resourcekey="BoundFieldResource4">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField HeaderText="部門名稱" DataField="GROUP_NAME" SortExpression="GROUP_NAME" meta:resourcekey="BoundFieldResource5">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField HeaderText="部門代碼" DataField="GROUP_CODE" SortExpression="GROUP_CODE" meta:resourcekey="BoundFieldResource6">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="狀態" meta:resourcekey="TemplateFieldResource2" >
                        <EditItemTemplate>
                            <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("SYNC_TYPE") %>' meta:resourcekey="TextBox1Resource2" ></asp:TextBox>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="lblSyncType" runat="server" Text='<%# Bind("SYNC_TYPE") %>' meta:resourcekey="lblSyncTypeResource2" ></asp:Label>
                        </ItemTemplate>
                        <HeaderStyle Wrap="False" Width="150px" />
                        <ItemStyle Wrap="False" HorizontalAlign="Center" />
                    </asp:TemplateField>
                </Columns>
            </EdeGrid:Grid>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="RadToolBar1" EventName="ButtonClick" />
        </Triggers>
    </asp:UpdatePanel>
    <asp:HiddenField ID="hfsyncID" runat="server" />
    <asp:HiddenField ID="hfsyncItem" runat="server" />
    <asp:Label ID="lblMsgInsert" runat="server" Text="新增" Visible="False" meta:resourcekey="lblMsgInsertResource1"></asp:Label>
    <asp:Label ID="lblMsgUpdate" runat="server" Text="更新" Visible="False" meta:resourcekey="lblMsgUpdateResource1"></asp:Label>

</asp:Content>
