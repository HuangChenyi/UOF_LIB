<%@ Control Language="C#" AutoEventWireup="true" Inherits="WKF_FormManagement_VersionFieldUserControl_CheckBoxUC" CodeBehind="CheckBoxUC.ascx.cs" %>
<%@ Reference Control="~/WKF/FormManagement/VersionFieldUserControl/VersionFieldUC.ascx" %>

<style>
    wkfCbxList{
        white-space:normal;
    }
</style>
<script type="text/javascript">

    Sys.Application.add_load(function () {
        cbOthers_Click_<%=cbOthers.ClientID%>();
    });

    function cbOthers_Click_<%=cbOthers.ClientID%>() {
        var cbChecked = $("#<%=cbOthers.ClientID%>")[0].checked;
        var txtOthers = $("#<%=txtOthers.ClientID%>");
        if (cbChecked) {
            //txtOthers.prop("readonly", false);
            //txtOthers.css({ "background-color": "" });
            txtOthers.show();
        }
        else {
            //txtOthers.prop("readonly", true);
            //txtOthers.css({ "background-color": "lightgray" });
            txtOthers.hide();
        }
    }

    function CheckValidation_<%=CustomValidator1.ClientID%>(sender, args) {
        var aryInput = $('input[id^="<%=cbxList.ClientID%>"]');
        var status = false;
        var cbOthersChecked = $("#<%=cbOthers.ClientID%>")[0].checked;

        status = cbOthersChecked;

        for (var i = 0; i < aryInput.length; i++) {
            if ($(aryInput[i]).prop('checked')) {
                status = true;
                break;
            }
        }
        if (status == false) $("#<%=cbxList.ClientID%>").focus();
        args.IsValid = status;
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
                    <td nowrap>
                        <asp:LinkButton ID="lnk_Edit" runat="server" OnClick="lnk_Edit_Click" Visible="False" CausesValidation="False" meta:resourcekey="lnk_EditResource1">[修改]</asp:LinkButton>
                        <asp:LinkButton ID="lnk_Cannel" runat="server" OnClick="lnk_Cannel_Click" Visible="False" CausesValidation="False" meta:resourcekey="lnk_CannelResource1">[取消]</asp:LinkButton>
                        <asp:LinkButton ID="lnk_Submit" runat="server" OnClick="lnk_Submit_Click" Visible="False" meta:resourcekey="lnk_SubmitResource1">[確定]</asp:LinkButton>
                    </td>
                    <td nowrap>
                        <table>
                            <tr>
                                <td>
                                    <asp:CheckBoxList ID="cbxList" runat="server" RepeatDirection="Horizontal" meta:resourcekey="cbxListResource1"></asp:CheckBoxList>
                                    <asp:Label ID="lblHasNoAuthority" runat="server" ForeColor="Red" Text="無填寫權限"
                                        Visible="False" meta:resourcekey="lblHasNoAuthorityResource1"></asp:Label>
                                    <asp:Label ID="lblCbxList" runat="server" Visible="False" class="wkfCbxList" meta:resourcekey="lblCbxListResource1"></asp:Label>
                                    <asp:Label ID="lblOthers" Visible="False" runat="server"></asp:Label>
                                    <asp:Label ID="lblMsgSigner" runat="server" Text="填寫者" Visible="False" meta:resourcekey="lblMsgSignerResource1"></asp:Label>
                                </td>
                            </tr>
                            <tr id="trOthers" runat="server">
                                <td>
                                    <asp:CheckBox ID="cbOthers" runat="server" Text="其他" meta:resourcekey="cbOthersResource1" />
                                    <asp:TextBox ID="txtOthers" runat="server"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:CustomValidator ID="CustomValidator1" runat="server"
                                        ErrorMessage="至少需要選擇一項" ClientValidationFunction="CheckValidation"
                                        meta:resourcekey="CustomValidator1Resource1" Display="Dynamic"></asp:CustomValidator>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
        <td nowrap>
            <asp:Label ID="lblModifier" runat="server" Visible="False" meta:resourcekey="lblModifierResource1"></asp:Label>
            <asp:Label ID="lblAuthorityMsg" runat="server" Text="具填寫權限人員" Visible="False"
                meta:resourcekey="lblAuthorityMsgResource1"></asp:Label>
        </td>
    </tr>
</table>

