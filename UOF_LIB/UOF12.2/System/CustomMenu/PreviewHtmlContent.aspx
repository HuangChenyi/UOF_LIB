<%@ Page Title="" Language="C#" MasterPageFile="~/Master/DefaultMasterPage.master" AutoEventWireup="true" Inherits="System_CustomMenu_PreviewHtmlContent" Codebehind="PreviewHtmlContent.aspx.cs" %>

<%@ Register Src="~/Common/FileCenter/V3/UC_FileCenter.ascx" TagPrefix="uc1" TagName="UC_FileCenter" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:Label ID="lblHtml" runat="server" Text=""></asp:Label>
    <uc1:UC_FileCenter runat="server" ID="UC_FileCenter" />
</asp:Content>

