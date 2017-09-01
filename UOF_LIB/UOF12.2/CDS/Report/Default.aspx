<%@ Page Title="" Language="C#" MasterPageFile="~/Master/DefaultMasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="CDS_Report_Default" %>

<%@ Register Assembly="Telerik.ReportViewer.WebForms, Version=9.0.15.225, Culture=neutral, PublicKeyToken=a9d7983dfcc261be" Namespace="Telerik.ReportViewer.WebForms" TagPrefix="telerik" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <telerik:ReportViewer ID="ReportViewer1" runat="server"  Width="100%"   Height="600px" >
     
    </telerik:ReportViewer>
    <asp:Button ID="Button1" runat="server" Text="Button" />


</asp:Content>

