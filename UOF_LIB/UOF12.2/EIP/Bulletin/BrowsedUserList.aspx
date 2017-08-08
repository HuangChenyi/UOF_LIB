<%@ Page Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" Inherits="EIP_Bulletin_BrowsedUserList" Title="瀏覽記錄"
    Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="BrowsedUserList.aspx.cs" %>

<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Fast" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>

            <Fast:Grid ID="Grid1" runat="server" AutoGenerateCheckBoxColumn="False" AllowSorting="True"
                AutoGenerateColumns="False" DataKeyNames="BULLETIN_GUID,USER_GUID" DataSourceID="ObjectDataSource1"
                Width="100%" OnRowDataBound="Grid1_RowDataBound"
                AllowPaging="True"
                DataKeyOnClientWithCheckBox="False" DefaultSortDirection="Ascending"
                EmptyDataText="沒有資料" EnableModelValidation="True" EnhancePager="True"
                KeepSelectedRows="False">
                <EnhancePagerSettings FirstImageUrl="" FirstAltImageUrl="" PreviousImageUrl="" NextImageUrl=""
                    LastImageUrl="" LastAltImage="" PageNumberCssClass="" PageNumberCurrentCssClass=""
                    PageInfoCssClass="" PageRedirectCssClass="" NextIAltImageUrl="" PreviousAltImageUrl=""
                    ShowHeaderPager="True"></EnhancePagerSettings>
                <ExportExcelSettings AllowExportToExcel="True" DataSourceType="ObjectDataSource"></ExportExcelSettings>
                <Columns>
                    <asp:BoundField DataField="BULLETIN_GUID" HeaderText="BULLETIN_GUID" ReadOnly="True"
                        SortExpression="BULLETIN_GUID" Visible="False" meta:resourcekey="BoundFieldResource1" />
                    <asp:BoundField DataField="USER_GUID" HeaderText="USER_GUID" ReadOnly="True" SortExpression="USER_GUID"
                        Visible="False" meta:resourcekey="BoundFieldResource2" />
                    <asp:BoundField DataField="GROUP_NAME" HeaderText="部門/群組"
                        SortExpression="GROUP_NAME" meta:resourcekey="BoundFieldResource4" />
                    <asp:TemplateField HeaderText="瀏覽者" SortExpression="USER_GUID"
                        meta:resourcekey="TemplateFieldResource1" Visible="False">
                        <ItemTemplate>
                            <asp:Label runat="server" ID="lblName" meta:resourceKey="lblNameResource1"></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="USER_NAME" HeaderText="瀏覽者"
                        SortExpression="USER_NAME" meta:resourcekey="TemplateFieldResource1" />
                    <asp:TemplateField HeaderText="讀取時間" SortExpression="READ_DATE" meta:resourcekey="BoundFieldResource3" >
                        <ItemTemplate>
                            <asp:Label ID="lblReadDate" runat="server" Text='<%# Bind("READ_DATE") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </Fast:Grid>
            <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" SelectMethod="GetReadUser"
                TypeName="Ede.Uof.EIP.Bulletin.ReadUCO">
                <SelectParameters>
                    <asp:QueryStringParameter Name="bulletinGUID" QueryStringField="BULLETINID" Type="String" />
                </SelectParameters>
            </asp:ObjectDataSource>

        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:HiddenField ID="hfCurrentUser" runat="server" />
</asp:Content>