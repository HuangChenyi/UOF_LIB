<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AllUserSetUC.ascx.cs" Inherits="WKF_FormManagement_VersionFieldUserControl_AllUserSetUC" %>
<%@ Register Src="../../../Common/ChoiceCenter/UC_ChoiceList.ascx" TagName="UC_ChoiceList" TagPrefix="uc2" %>
<%@ Register Src="~/Common/ChoiceCenter/UC_ChoiceListMobile.ascx" TagPrefix="uc3" TagName="UC_ChoiceListMobile" %>

<%@ Reference Control="~/WKF/FormManagement/VersionFieldUserControl/VersionFieldUC.ascx" %>

<asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>
        <table cellpadding="0" cellspacing="0" border="0" style="width: 97%">
            <tr>
                <td>
                    <asp:LinkButton ID="lnk_Edit" runat="server" OnClick="lnk_Edit_Click" Visible="False" meta:resourcekey="lnk_EditResource1" Text="[修改]"></asp:LinkButton>
                    <asp:LinkButton ID="lnk_Cannel" runat="server" OnClick="lnk_Cannel_Click" Visible="False" meta:resourcekey="lnk_CannelResource1" Text="[取消]" CausesValidation="false"></asp:LinkButton>
                    <asp:LinkButton ID="lnk_Submit" runat="server" OnClick="lnk_Submit_Click" Visible="False" meta:resourcekey="lnk_SubmitResource1" Text="[確定]"></asp:LinkButton>
                    <asp:Image ID="imgAllUser" runat="server" meta:resourcekey="imgAllUserResource1" />
                    <span id="SpanValue" runat="server">
                        <asp:Label ID="lblAllUserValue" runat="server" meta:resourcekey="lblAllUserValueResource1"></asp:Label>
                    </span>
                </td>
            </tr>
            <tr>
                <asp:Label ID="lblMsgSigner" runat="server" Text="填寫者" Visible="False" meta:resourcekey="lblMsgSignerResource1"></asp:Label>
                <asp:Label ID="lblHasNoAuthority" runat="server" ForeColor="Red" Text="無填寫權限"
                    Visible="False" meta:resourcekey="lblHasNoAuthorityResource1"></asp:Label>
                <asp:Label ID="lblAllPeople" runat="server" meta:resourcekey="lblAllPeopleResource1" Text="所有人員" Visible="False"></asp:Label>
                <asp:Label ID="lblAllDep" runat="server" meta:resourcekey="lblAllDepResource1" Text="所有部門" Visible="False"></asp:Label>
                <asp:Label ID="lblAllFunc" runat="server" meta:resourcekey="lblAllFuncResource1" Text="所有職務" Visible="False"></asp:Label>
                <asp:Label ID="lblAllRank" runat="server" meta:resourcekey="lblAllRankResource1" Text="所有職級" Visible="False"></asp:Label>
                <asp:Label ID="lblAuthorityMsg" runat="server" Text="具填寫權限人員" Visible="False"
                    meta:resourcekey="lblAuthorityMsgResource1"></asp:Label>
            </tr>
            <tr>
                <td colspan="2">
                    <uc3:UC_ChoiceListMobile runat="server" ID="UC_ChoiceListMobile" IsAllowEdit="false" />
                    <div style="display: none">
                        <uc2:UC_ChoiceList ID="UC_ChoiceList1" runat="server" ShowMember="False" />
                    </div>
                    <asp:Label ID="lblModifier" runat="server" Visible="False" meta:resourcekey="lblModifierResource1"></asp:Label>
                    <asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="不允許空白" ForeColor="Red" EnableTheming="true"
                        meta:resourcekey="CustomValidator1Resource1" SetFocusOnError="True"
                        Visible="False" Display="Dynamic"></asp:CustomValidator>
                </td>
            </tr>
        </table>
        <span style="display: none">
            <asp:Label ID="lblRealValue" runat="server" meta:resourcekey="lblRealValueResource1"></asp:Label></span>
        <asp:Label ID="lblChooseDept" runat="server" Visible="False" Text="選取部門" meta:resourcekey="lblChooseDeptResource1"></asp:Label>
        <asp:Label ID="lblChoosePeople" runat="server" Visible="False" Text="選取人員" meta:resourcekey="lblChoosePeopleResource1"></asp:Label>
        <asp:Label ID="lblChooseFunction" runat="server" Visible="False" Text="選取職務" meta:resourcekey="lblChooseFunctionResource1"></asp:Label>
        <asp:Label ID="lblChooseRank" runat="server" Visible="False" Text="選取職級" meta:resourcekey="lblChooseRankResource1"></asp:Label>
    </ContentTemplate>
</asp:UpdatePanel>
