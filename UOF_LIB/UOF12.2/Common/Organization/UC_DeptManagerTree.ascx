<%@ Control Language="C#" AutoEventWireup="true" Inherits="Common_ChoiceCenter_UC_DeptManagerTree" Codebehind="UC_DeptManagerTree.ascx.cs" %>
<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<telerik:RadTreeView ID="DepartmentTree" runat="server" 
    OnNodeClick ="DepartmentTree_NodeClick">
</telerik:RadTreeView>

<asp:Label ID="lblDeptManager" runat="server" Text="部門管理員" Visible="False" 
    meta:resourcekey="lblDeptManagerResource1"></asp:Label>
<asp:Label ID="lblSuperior" runat="server" Text="主管" Visible="False" 
    meta:resourcekey="lblSuperiorResource1"></asp:Label>
<asp:Label ID="lblPersonal" runat="server" Text="個人" Visible="False" 
    meta:resourcekey="lblPersonalResource1"></asp:Label>

