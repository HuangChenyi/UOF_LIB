<%@ Page Title="" Language="C#" MasterPageFile="~/Master/DefaultMasterPage.master" AutoEventWireup="true" CodeFile="Default2.aspx.cs" Inherits="CDS_TEST_Default2" %>
<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Fast" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <Fast:Grid ID="grid" runat="server" AutoGenerateCheckBoxColumn="false"></Fast:Grid>
</asp:Content>

