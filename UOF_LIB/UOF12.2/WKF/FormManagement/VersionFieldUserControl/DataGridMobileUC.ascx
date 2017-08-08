<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DataGridUC.ascx.cs" Inherits="WKF_FormManagement_VersionFieldUserControl_DataGridUC" %>
<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Fast" %>
<%@ Reference Control="~/WKF/FormManagement/VersionFieldUserControl/VersionFieldUC.ascx" %>
<%@ Reference Control="~/WKF/FormManagement/VersionFieldUserControl/SingleLineTextUC.ascx" %>
<%@ Reference Control="~/WKF/FormManagement/VersionFieldUserControl/MultiLineTextUC.ascx" %>
<%@ Reference Control="~/WKF/FormManagement/VersionFieldUserControl/VersionFieldUC.ascx" %>
<%@ Reference Control="~/WKF/FormManagement/VersionFieldUserControl/AutoNumberUC.ascx" %>
<%@ Reference Control="~/WKF/FormManagement/VersionFieldUserControl/CalculateTextUC.ascx" %>
<%@ Reference Control="~/WKF/FormManagement/VersionFieldUserControl/CheckBoxUC.ascx" %>
<%@ Reference Control="~/WKF/FormManagement/VersionFieldUserControl/DateSelectUC.ascx" %>
<%@ Reference Control="~/WKF/FormManagement/VersionFieldUserControl/DropDownListUC.ascx" %>
<%@ Reference Control="~/WKF/FormManagement/VersionFieldUserControl/FileButtonUC.ascx" %>
<%@ Reference Control="~/WKF/FormManagement/VersionFieldUserControl/HyperLinkUC.ascx" %>
<%@ Reference Control="~/WKF/FormManagement/VersionFieldUserControl/MultiLineTextUC.ascx" %>
<%@ Reference Control="~/WKF/FormManagement/VersionFieldUserControl/NumberTextUC.ascx" %>
<%@ Reference Control="~/WKF/FormManagement/VersionFieldUserControl/SingleLineTextUC.ascx" %>
<%@ Reference Control="~/WKF/FormManagement/VersionFieldUserControl/RadioButtonUC.ascx" %>
<%@ Reference Control="~/WKF/FormManagement/VersionFieldUserControl/TimeSelectUC.ascx" %>

<script language="javascript">

    function <%=mfuncName%>(e, args) 
    {

     
        if ($("#<%=Grid1.ClientID %> tr").length == 1) 
        {
            args.IsValid = false;
        }
        else 
        {
            args.IsValid = true;
        }
    }

    function Clicking(e, args)
    {
        var button2 = $("#" + e.get_id()).attr("openurl");
        location.replace(button2);
    }
</script>

<asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>
        <table>
            <tr>
                <td>
                    <telerik:RadButton ID="WebImageButton_AddDgRow" runat="server" Visible="False" Text="新增明細" OnClick="WebImageButton_AddDgRow_Click1" CausesValidation="False" OnClientClicking="Clicking"  meta:resourcekey="WebImageButton_AddDgRowResource1"></telerik:RadButton>
                </td>
            </tr>
        </table>
        <asp:Panel ID="Panel1" runat="server" meta:resourcekey="Panel1Resource1" ScrollBars="None" Visible="false">
        </asp:Panel>
        <table style="width: 97%; table-layout: fixed">
            <tr>
                <td>
                    <div style="width: 100%; overflow-x: auto">

                        <Fast:Grid ID="Grid1" runat="server" AllowSorting="True" AutoGenerateCheckBoxColumn="False" EmptyDataRowStyle-Wrap="false" EnableTheming="true"
                            Width="100%" AutoGenerateColumns="False" OnRowDataBound="Grid1_RowDataBound" OnRowCommand="Grid1_RowCommand1" OnRowDeleting="Grid1_RowDeleting" EnableViewState="False" PageSize="20" DataKeyOnClientWithCheckBox="False" EnhancePager="True">
                            <Columns>
                                <asp:TemplateField HeaderText="操作" meta:resourcekey="TemplateFieldResource1">
                                    <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemTemplate>
                                        <asp:UpdatePanel ID="updatePanel1" runat="server">
                                            <ContentTemplate>
                                                &nbsp;<asp:LinkButton ID="linkBtnModify" runat="server" CausesValidation="False" Text="修改" CommandName="DetailModify" meta:resourceKey="linkBtnModifyResource1"></asp:LinkButton>
                                                <asp:LinkButton ID="linkBtnDelete" runat="server" CausesValidation="False" Text="刪除" CommandName="DetailDelete" meta:resourceKey="linkBtnDeleteResource1"></asp:LinkButton>
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField>
                                    <ItemStyle HorizontalAlign="Center" VerticalAlign="Middle" Wrap="true" />
                                    <ItemTemplate>
                                        <asp:Label ID="lblRowIndex" runat="server" Text=""></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EnhancePagerSettings FirstAltImageUrl="" FirstImageUrl="" LastAltImage="" LastImageUrl=""
                                NextIAltImageUrl="" NextImageUrl="" PageInfoCssClass="" PageNumberCssClass=""
                                PageNumberCurrentCssClass="" PageRedirectCssClass="" PreviousAltImageUrl="" PreviousImageUrl=""
                                ShowHeaderPager="True" />
                        </Fast:Grid>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:HiddenField ID="hfGridRowCont" runat="server" />
                    <asp:Label ID="lblModifier" runat="server" Visible="False" meta:resourcekey="lblModifierResource1"></asp:Label>
                    <asp:Label ID="lblMsgSigner" runat="server" Text="填寫者" Visible="False" meta:resourcekey="lblMsgSignerResource1"></asp:Label>
                    <asp:Label ID="lblAddDetail" runat="server" meta:resourcekey="lblAddDetailResource1" Text="請新增明細" Visible="False"></asp:Label>
                    <asp:Label ID="lblAddDetailfield" runat="server" meta:resourcekey="lblAddDetailfieldResource1" Text="請新增明細欄位" Visible="False"></asp:Label>
                    <asp:Label ID="lblConfirmDelete" runat="server" meta:resourcekey="lblConfirmDeleteResource1" Text="確定刪除?" Visible="False"></asp:Label>
                    <asp:Label ID="lblAddDetail2" runat="server" Text="新增明細" Visible="False" meta:resourcekey="lblAddDetail2Resource1"></asp:Label>
                    <asp:Label ID="lblOthers" runat="server" Text="其他" Visible="false" meta:resourcekey="lblOthersResource1"></asp:Label>
                    <telerik:RadNumericTextBox ID="WebNumericFormatValue" runat="server" Visible="False"></telerik:RadNumericTextBox>
                    <asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="不允許空白" Display="Dynamic" ForeColor="Red" EnableTheming="true" meta:resourcekey="CustomValidator1Resource1"></asp:CustomValidator>
                </td>
            </tr>
        </table>
    </ContentTemplate>
</asp:UpdatePanel>

