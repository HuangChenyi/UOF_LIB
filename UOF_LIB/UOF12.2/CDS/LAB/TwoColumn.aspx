<%@ Page Title="" Language="C#" MasterPageFile="~/Master/TwoColumn.master" AutoEventWireup="true" CodeFile="TwoColumn.aspx.cs" Inherits="CDS_LAB_TwoColumn" %>

<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Ede" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ScriptContentPlaceHolder" Runat="Server">
        <style>

        .SearchBoxMargin {
            margin-top: 2px;
            margin-left: 1px;
        }
        .TreeMargin {
            margin-left: 5px;
        }
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceHolder" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="LeftContentPlaceHolder" Runat="Server">
 
    <telerik:RadTreeView ID="TreeView1" runat="server" OnNodeClick="TreeView1_NodeClick" CssClass="TreeMargin"></telerik:RadTreeView>

  
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="RightContentPlaceHolder" Runat="Server">
    <Ede:Grid  ID="GridView1" runat="server" AutoGenerateColumns="false" AutoGenerateCheckBoxColumn="false">
        <Columns>
            <asp:BoundField HeaderText="產品ID" DataField="ProductID" />
             <asp:BoundField HeaderText="產品名稱" DataField="ProductName" />
              <asp:BoundField HeaderText="單價" DataField="UnitPrice" />
        </Columns>
    </Ede:Grid>


    <asp:Label ID="lblTitle" runat="server" Text="產品類別" Visible="false"></asp:Label>
</asp:Content>

