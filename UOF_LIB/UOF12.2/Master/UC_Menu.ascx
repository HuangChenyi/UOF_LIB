<%@ Control Language="C#" AutoEventWireup="true" Inherits="Master_UC_Menu" Codebehind="UC_Menu.ascx.cs" %>
<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<telerik:RadMenu runat="server" ID="RadMenu1" OnClientItemClicking="$uof.telerikFix.menu.itemClicking"
   Height="100%" Width="100%" EnableShadows="true" Skin="Default" EnableTextHTMLEncoding="true"
     CausesValidation="False" CollapseDelay="150" ExpandDelay="300" OnClientItemClosed="$uof.telerikFix.menu.itemClosed" EnableAutoScroll="True">
</telerik:RadMenu>
