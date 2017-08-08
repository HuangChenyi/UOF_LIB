<%@ Page Language="C#" MasterPageFile="~/Master/TwoColumn.master" AutoEventWireup="true" Inherits="WKF_Auth_Default" Title="權限設定" Culture="auto"
    meta:resourcekey="PageResource1" UICulture="auto" Codebehind="Default.aspx.cs" %>

<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Fast" %>
<%@ Register Src="../../Common/ChoiceCenter/UC_ChoiceList.ascx" TagName="UC_ChoiceList"
    TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ScriptContentPlaceHolder" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ToolbarContentPlaceHolder" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="LeftContentPlaceHolder" runat="Server">
    <telerik:RadTreeView ID="RadTreeView1" runat="server" OnNodeClick="RadTreeView1_NodeClick"></telerik:RadTreeView>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="RightContentPlaceHolder" runat="Server">
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td valign="top">
                <table width="100%" class="PopTable" cellspacing="1">
                    <tr>
                        <td style="background-image: url(../../App_Themes/DefaultTheme/images/po_06.gif); text-align: left;">
                            <asp:Label ID="lblRole" runat="server" Text="角色說明：" meta:resourcekey="lblRoleResource1"></asp:Label><asp:UpdatePanel
                                ID="UpdatePanel3" runat="server" RenderMode="Inline" UpdateMode="Conditional">
                                <ContentTemplate>
                                    <asp:Label
                                        ID="lblRoleDesc" runat="server" meta:resourcekey="lblRoleDescResource1"></asp:Label>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </td>
                    </tr>
                    <tr>
                        <td style="background-image: url(../../App_Themes/DefaultTheme/images/po_06.gif); text-align: left;">
                            <asp:UpdatePanel ID="UpdatePanel1" runat="server" RenderMode="Inline" UpdateMode="Conditional">
                                <ContentTemplate>
                                      <input id="hideRole" runat="server" type="hidden" />
                                    <uc2:UC_ChoiceList ID="UC_ChoiceList1" runat="server" ShowMember="False" />
                                </ContentTemplate>
                            </asp:UpdatePanel>
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td style="padding: 0; width: 100%">
                            <table width="100%" class="PopTable" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td class="PopTableHeader" style="text-align: center; padding: 0;">
                                        <center>
                                        <asp:Label ID="Label2" runat="server" Text="可使用功能列表" meta:resourcekey="Label2Resource1"></asp:Label>
                                        </center>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
                <asp:UpdatePanel ID="UpdatePanel2" runat="server" RenderMode="Inline" UpdateMode="Conditional">
                    <ContentTemplate>
                        <Fast:Grid ID="Grid1" runat="server" AllowSorting="True" AutoGenerateCheckBoxColumn="False"
                            AutoGenerateColumns="False"
                            Width="100%"
                            OnRowDataBound="Grid1_RowDataBound" AllowPaging="True" OnPageIndexChanging="Grid1_PageIndexChanging"
                            meta:resourcekey="Grid1Resource1">
                            <Columns>
                                <asp:TemplateField HeaderText="功能名稱" meta:resourcekey="TemplateFieldResource1">
                                    <ItemTemplate>
                                        <asp:Label runat="server" ID="lblFuncName" meta:resourceKey="lblFuncNameResource1" __designer:wfdid="w16"></asp:Label>


                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </Fast:Grid>
                    </ContentTemplate>
                </asp:UpdatePanel>
                &nbsp;
                <asp:Label ID="lblWKFDesigner" runat="server" Text="被設定為設計者的人員，才可使用設計模組的所有功能。" Visible="False"
                    meta:resourcekey="lblWKFDesignerResource1"></asp:Label>
                <asp:Label ID="lblWKFManager" runat="server" Text="被設定為管理員者，才可使用電子簽核所有的功能，並可設定設計者人員。於系統管理>>系統組態>>管理員設定處設定。"
                    Visible="False" meta:resourcekey="lblWKFManagerResource1"></asp:Label>
                <asp:Label ID="lblWKFArchiveUser" runat="server" Text="只要於表單中，被設定為表單歸檔者的人員。" Visible="False"
                    meta:resourcekey="lblWKFArchiveUserResource1"></asp:Label>
                <asp:Label ID="lblWKFUser" runat="server" Text="只要於表單中，被設定為表單使用者的人員。" Visible="False"
                    meta:resourcekey="lblWKFUserResource1"></asp:Label>
                <asp:Label ID="lblElectronicDocument" runat="server" Text="" Visible="false" 
                    meta:resourcekey="lblElectronicDocumentResource1"></asp:Label>
                <asp:Label ID="lblWKFInnerUser" runat="server" Text="指公司內部所有人員。" Visible="False"
                    meta:resourcekey="lblWKFInnerUserResource1"></asp:Label>
                <asp:Label ID="lblWKFOuterUser" runat="server" Text="指公司以外的使用人員。" Visible="False"
                    meta:resourcekey="lblWKFOuterUserResource1"></asp:Label>
                <asp:Label ID="lblList" runat="server" Text="角色列表" meta:resourcekey="Label1Resource1" Visible="false"></asp:Label>
                <asp:Label ID="lblWKFReaderUser" runat="server" Text="被設定為表單查閱者的人員，可操作「表單查閱者查詢」。" Visible="false" meta:resourcekey="lblWKFReaderUserResource1"></asp:Label>
                <asp:Label ID="lblWKFResponsible" runat="server" Text="被設定為表單負責人的人員，可操作「表單負責人管理」。" Visible="false" meta:resourcekey="WKFResponsibleResource1"></asp:Label>
            </td>
        </tr>
    </table>
  
</asp:Content>


