<%@ Page Title="" Language="C#" MasterPageFile="~/Master/DefaultMasterPage.master" AutoEventWireup="true" CodeFile="Default2.aspx.cs" Inherits="CDS_Default2" %>

<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Ede" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <asp:Button ID="Button1" runat="server" Text="Button" OnClick="Button1_Click" />

    <Ede:Grid ID="Grid1" runat="server" AutoGenerateCheckBoxColumn="false" ></Ede:Grid>
   
</asp:Content>

