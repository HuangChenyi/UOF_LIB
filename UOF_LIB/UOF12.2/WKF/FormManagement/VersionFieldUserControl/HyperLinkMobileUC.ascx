<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="HyperLinkUC.ascx.cs" Inherits="WKF_FormManagement_VersionFieldUserControl_HyperLinkUC" %>
<%@ Reference Control="~/WKF/FormManagement/VersionFieldUserControl/VersionFieldUC.ascx" %>

<asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>
        <table border="0" cellpadding="0" cellspacing="0" style="width: 97%">
            <tr>
                <td>
                    <asp:LinkButton ID="lnk_Edit" runat="server" OnClick="lnk_Edit_Click" Visible="False" CausesValidation="False" meta:resourcekey="lnk_EditResource1">[修改]</asp:LinkButton>
                    <asp:LinkButton ID="lnk_Cannel" runat="server" OnClick="lnk_Cannel_Click" Visible="False" CausesValidation="False" meta:resourcekey="lnk_CannelResource1">[取消]</asp:LinkButton>
                </td>
            </tr>
            <tr>
                <td nowrap>
                    <telerik:RadButton ID="WebImageButton1" runat="server"
                        CausesValidation="False" OnClick="WebImageButton1_Click1" Text="設定超連結"
                        meta:resourcekey="WebImageButton1Resource1" Visible="False">
                    </telerik:RadButton>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:HyperLink ID="HyperLink1" runat="server" meta:resourcekey="HyperLink1Resource1" ForeColor="Blue"></asp:HyperLink>
                    <asp:LinkButton ID="lblHyperLink" runat="server" ForeColor="Blue" meta:resourcekey="lblHyperLinkResource1"></asp:LinkButton>
                    <asp:Label ID="lblHasNoAuthority" runat="server" Text="無填寫權限" ForeColor="Red" Visible="False" meta:resourcekey="lblHasNoAuthorityResource1"></asp:Label>
                    <asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="不允許空白" ForeColor="Red" EnableTheming="true"
                        meta:resourcekey="CustomValidator1Resource1" Visible="False" Display="Dynamic"></asp:CustomValidator>
                    <asp:Label ID="lblToolTipMsg" runat="server" Text="不允許修改(唯讀)" Visible="False" meta:resourcekey="lblToolTipMsgResource1"></asp:Label>
                    <asp:Label ID="lblMsgSigner" runat="server" Text="填寫者" Visible="False" meta:resourcekey="lblMsgSignerResource1"></asp:Label>
                    <asp:Label ID="lblAuthorityMsg" runat="server" Text="具填寫權限人員" Visible="False" meta:resourcekey="lblAuthorityMsgResource1"></asp:Label>
                    <asp:Label ID="lblModifier" runat="server" Visible="False" meta:resourcekey="lblModifierResource1"></asp:Label>
                    <asp:HiddenField ID="hiddenDefaultValue" runat="server" />
                </td>
            </tr>
        </table>
    </ContentTemplate>
</asp:UpdatePanel>
