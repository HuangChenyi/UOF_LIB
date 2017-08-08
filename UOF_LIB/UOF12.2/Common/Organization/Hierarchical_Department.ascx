<%@ Control Language="C#" AutoEventWireup="true"
    Inherits="Common_Organization_Hierarchical_Department" Codebehind="Hierarchical_Department.ascx.cs" %>
<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<telerik:RadTreeView ID="UC_HRDEPTTREE" runat="server"  
    OnNodeClick="UC_HRDEPTTREE_NodeClick">
</telerik:RadTreeView>
