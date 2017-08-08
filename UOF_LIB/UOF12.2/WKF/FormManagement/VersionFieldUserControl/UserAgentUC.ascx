<%@ Control Language="C#" AutoEventWireup="true" Inherits="WKF_FormManagement_VersionFieldUserControl_UserAgentUC" Codebehind="UserAgentUC.ascx.cs" %>
<%@ Reference Control="~/WKF/FormManagement/VersionFieldUserControl/VersionFieldUC.ascx" %>

<script type="text/javascript">
    function DropDownOnChange_<%=DropDownList1.ClientID%>()
    {
        var tbx_value = $("#<%=this.tbx_value.ClientID%>");
        var tbx_text = $("#<%=this.tbx_Text.ClientID%>");
        var obj = $("#<%=this.DropDownList1.ClientID%> option:selected");
        tbx_value.val( obj.val());
        tbx_text.val( obj.text());
    }

    function DropDownOnCheck_<%=DropDownList1.ClientID%>(e, args) {
        if ($("#<%=DropDownList1.ClientID%>").val() == "###***$$$") {
            args.IsValid = false;
        }
        else {
            args.IsValid = true;
        }

    }
</script>


<%-- 為了避免designer錯誤，所以要與Mobile元件同步 --%>
<asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate></ContentTemplate>
</asp:UpdatePanel>

<table border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td nowrap>
            <table border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                        <asp:LinkButton ID="lnk_Edit" runat="server" OnClick="lnk_Edit_Click" Visible="False" meta:resourcekey="lnk_EditResource1" Text="[修改]"></asp:LinkButton>
                        <asp:LinkButton ID="lnk_Cannel" runat="server" OnClick="lnk_Cannel_Click" Visible="False" meta:resourcekey="lnk_CannelResource1" Text="[取消]"></asp:LinkButton>
                        <asp:LinkButton ID="lnk_Submit" runat="server" OnClick="lnk_Submit_Click" Visible="False" meta:resourcekey="lnk_SubmitResource1" Text="[確定]"></asp:LinkButton>
                    </td>
                    <td>
                        <asp:DropDownList ID="DropDownList1" runat="server" meta:resourcekey="DropDownList1Resource1" AppendDataBoundItems="True"></asp:DropDownList>
                        <asp:Label ID="lblDropDown" runat="server" Visible="False" meta:resourcekey="lblDropDownResource1"></asp:Label>
                    </td>
                </tr>
            </table>
        </td>
        <td>
            <asp:Label ID="lblAgentDelete" runat="server" ForeColor="Blue" Text="選取的代理人已不存在於代理人設定中!" Visible="False" meta:resourcekey="lblAgentDeleteResource1"></asp:Label>
            <asp:CustomValidator ID="CustomValidator1" runat="server" Display="Dynamic"
                ErrorMessage="請選擇項目" ControlToValidate="DropDownList1"
                SetFocusOnError="True" meta:resourcekey="CustomValidator1Resource1"></asp:CustomValidator>
            <asp:Label ID="lblHasNoAuthority" runat="server" ForeColor="Red" Text="無填寫權限" Visible="False" meta:resourcekey="lblHasNoAuthorityResource1"></asp:Label>
            <asp:Label ID="lblModifier" runat="server" Visible="False" meta:resourcekey="lblModifierResource1"></asp:Label>
            <asp:Label ID="lblMsgSigner" runat="server" Text="填寫者" Visible="False" meta:resourcekey="lblMsgSignerResource1"></asp:Label>
            <asp:Label ID="lblAuthorityMsg" runat="server" Text="具填寫權限人員" Visible="False" meta:resourcekey="lblAuthorityMsgResource1"></asp:Label>
            <asp:Label ID="lblField" runat="server" Text="外部資料訊息:" Visible="False" meta:resourcekey="lblFieldResource1" Font-Bold="False" ForeColor="Red"></asp:Label>
            <asp:Label ID="lblShowWSMsg" meta:resourcekey="lblShowWSMsgResource1" runat="server" Font-Bold="False" ForeColor="Red" Visible="False"></asp:Label>
            <asp:Label ID="lblWebServiceMsg" runat="server" Text="資料格式錯誤" meta:resourcekey="lblWebServiceMsgResource1" Visible="False" Font-Bold="False" ForeColor="Red"></asp:Label>
            <asp:Label ID="lblotherMSG" runat="server" ForeColor="Red" Text="呼叫外部資料時發生錯誤" Visible="False" meta:resourcekey="lblotherMSGResource1"></asp:Label>
            <asp:Label ID="lbl_WriteMsg" runat="server" Text="─請選擇─" Visible="False" meta:resourcekey="lbl_WriteMsgResource1"></asp:Label>
            <asp:HiddenField ID="tbx_value" runat="server" />
            <asp:HiddenField ID="tbx_Text" runat="server" />
        </td>
    </tr>
</table>
