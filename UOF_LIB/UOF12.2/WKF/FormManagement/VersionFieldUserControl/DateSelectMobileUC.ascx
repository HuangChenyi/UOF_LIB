<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DateSelectUC.ascx.cs" Inherits="WKF_FormManagement_VersionFieldUserControl_DateSelectUC" %>
<%@ Reference Control="~/WKF/FormManagement/VersionFieldUserControl/VersionFieldUC.ascx" %>

<asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>
        <table border="0" cellpadding="0" cellspacing="0" style="width: 97%">
            <tr>
                <td>
                    <asp:LinkButton ID="lnk_Edit" runat="server" OnClick="lnk_Edit_Click"
                        Visible="False" meta:resourcekey="lnk_EditResource1"
                        Text="[修改]"></asp:LinkButton>
                    <asp:LinkButton ID="lnk_Cannel" runat="server" OnClick="lnk_Cannel_Click"
                        Visible="False" meta:resourcekey="lnk_CannelResource1"
                        Text="[取消]"></asp:LinkButton>
                    <asp:LinkButton ID="lnk_Submit" runat="server" OnClick="lnk_Submit_Click"
                        Visible="False" meta:resourcekey="lnk_SubmitResource1"
                        Text="[確定]"></asp:LinkButton>
                </td>
            </tr>
            <tr>
                <td>
                    <telerik:RadDatePicker ID="RadDatePicker1" runat="server" MaxDate="9999-12-31" MinDate="1911-01-01" SkinID="AllowEmpty" Width="100%" EnableTheming="true">
                    </telerik:RadDatePicker>
                    <asp:Label ID="lblDateChooser" runat="server" Visible="False" meta:resourcekey="lblDateChooserResource1"></asp:Label>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:Button ID="Button1" runat="server" meta:resourcekey="Button1Resource1" OnClick="Button1_Click" Text="取得值" Visible="False" CausesValidation="False" />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="RadDatePicker1" Display="Dynamic" ErrorMessage="不允許空白" Visible="False" EnableTheming="true" meta:resourcekey="RequiredFieldValidator1Resource1"></asp:RequiredFieldValidator>
                    <asp:Label ID="lblHasNoAuthority" runat="server" ForeColor="Red" Text="無填寫權限" Visible="False" meta:resourcekey="lblHasNoAuthorityResource1"></asp:Label>
                    <asp:Label ID="lblModifier" runat="server" Visible="False" meta:resourcekey="lblModifierResource1"></asp:Label>
                    <asp:Label ID="lblMsgSigner" runat="server" Text="填寫者" Visible="False" meta:resourcekey="lblMsgSignerResource1"></asp:Label>
                    <asp:Label ID="lblAuthorityMsg" runat="server" Text="具填寫權限人員" Visible="False" meta:resourcekey="lblAuthorityMsgResource1"></asp:Label>
                    <asp:Label ID="lblReadonly" runat="server" meta:resourcekey="lblReadonlyResource1" Text="唯讀" Visible="False"></asp:Label>
                    <asp:Label ID="lblField" runat="server" Text="外部資料訊息:" Visible="False" meta:resourcekey="lblFieldResource1" Font-Bold="False" ForeColor="Red"></asp:Label>
                    <asp:Label ID="lblShowWSMsg" meta:resourcekey="lblShowWSMsgResource1" runat="server" Font-Bold="False" ForeColor="Red" Visible="False"></asp:Label>
                    <asp:Label ID="lblWebServiceMsg" runat="server" Text="資料格式錯誤" meta:resourcekey="lblWebServiceMsgResource1" Visible="False" Font-Bold="False" ForeColor="Red"></asp:Label>
                    <asp:Label ID="lblotherMSG" runat="server" ForeColor="Red" Text="呼叫外部資料時發生錯誤" Visible="False" meta:resourcekey="lblotherMSGResource1"></asp:Label>
                </td>
            </tr>
        </table>
    </ContentTemplate>
</asp:UpdatePanel>
