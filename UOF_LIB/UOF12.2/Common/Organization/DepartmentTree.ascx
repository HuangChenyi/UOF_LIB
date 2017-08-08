
<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Control Language="C#" AutoEventWireup="true"
    Inherits="Common_Organization_DepartmentTree" Codebehind="DepartmentTree.ascx.cs" %>


<telerik:RadTreeView ID="UC_DEPTREE" runat="server" OnNodeClick ="UC_DEPTREE_NodeClick"/>
