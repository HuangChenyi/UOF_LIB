<%@ Page Title="可休假餘額查詢" Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" CodeBehind="UserAllLeaveDetail.aspx.cs" Inherits="Ede.Uof.Web.EIP.Duty.WKFOptionalFields104.UserAllLeaveDetail" %>
<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Fast" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
<asp:UpdatePanel ID="updatepanel1" runat="server"><ContentTemplate>
    <Fast:Grid ID="Grid1" runat="server" AutoGenerateCheckBoxColumn="False"
        AllowSorting="True" AutoGenerateColumns="False" 
        DataKeyOnClientWithCheckBox="False" 
        EmptyDataText="沒有資料" EnhancePager="True" OnSorting="Grid1_Sorting"
        KeepSelectedRows="False"  Width="100%">

        <EnhancePagerSettings ShowHeaderPager="True" />
        <ExportExcelSettings
            AllowExportToExcel="False" />
        <Columns>
            <asp:BoundField HeaderText="假別" DataField="LEAVE_REFERENCE_CLASS" SortExpression="LEAVE_REFERENCE_CLASS ASC" >
                <HeaderStyle Wrap="False" />
                <ItemStyle HorizontalAlign="Left" />
            </asp:BoundField>
            <asp:BoundField HeaderText="可用" DataField="ANNUAL_MEMO" SortExpression="ANNUAL_LEAVE ASC,LEAVE_UNIT ASC" >
                <HeaderStyle Wrap="False" />
                <ItemStyle HorizontalAlign="Right" />
            </asp:BoundField>
            <asp:BoundField HeaderText="已用" DataField="USED_MEMO" SortExpression="USED_LEAVE ASC,LEAVE_UNIT ASC" >
                <HeaderStyle Wrap="False" />
                <ItemStyle HorizontalAlign="Right" />
            </asp:BoundField>
            <asp:BoundField HeaderText="剩餘" DataField="SURPLUS_MEMO" SortExpression="SURPLUS_LEAVE ASC,LEAVE_UNIT ASC" >
                <HeaderStyle Wrap="False" />
                <ItemStyle HorizontalAlign="Right" />
            </asp:BoundField>
        </Columns>
    </Fast:Grid>
    <asp:Label ID="lblError" runat="server" Text="" ForeColor="Red"></asp:Label>
</ContentTemplate></asp:UpdatePanel>

</asp:Content>
