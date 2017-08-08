<%@ Control Language="C#" AutoEventWireup="true" Inherits="WKF_FormManagement_VersionFieldUserControl_RadioButtonUC" CodeBehind="RadioButtonUC.ascx.cs" %>
<%@ Reference Control="~/WKF/FormManagement/VersionFieldUserControl/VersionFieldUC.ascx" %>

<script type="text/javascript">
    Sys.Application.add_load(function () {
        SetDefault_<%=rbOthers.ClientID%>();
    });

    function SetDefault_<%=rbOthers.ClientID%>() {
        var rbList = $("#<%=rbList.ClientID%> input[type='radio']");
        var txtOthers = $("#<%=txtOthers.ClientID%>");
        var rbOthers = $("#<%=rbOthers.ClientID%>");
        var otherCheck = rbOthers.is(":checked");

        if (otherCheck) {
            rbList.each(function () {
                $(this).prop("checked", false);
            });
            txtOthers.show();
        }
        else {
            rbOthers.prop("checked", false);
            txtOthers.hide();
        }
    }

    function rbOthers_Click_<%=rbOthers.ClientID%>() {
        var txtOthers = $("#<%=txtOthers.ClientID%>");
        var rbList = $("#<%=rbList.ClientID%> input[type='radio']");

        rbList.each(function () {
            $(this).prop("checked", false);
        });

        txtOthers.show();
    }

    function rbList_Click_<%=rbList.ClientID%>() {
        var rbOthers = $("#<%=rbOthers.ClientID%>");
        var txtOthers = $("#<%=txtOthers.ClientID%>");

        rbOthers.prop("checked", false);
        txtOthers.hide();
    }

    function CheckFieldEmpty_<%=customValidator1.ClientID%>(sender, args) {
         var rbList = $("#<%=rbList.ClientID%> input[type='radio']");
        var rbOthers = $("#<%=rbOthers.ClientID%>");
        var otherCheck = rbOthers.is(":checked");
        var isValid = false;

        //先檢查其他
        if (otherCheck) {
            isValid = true;
        }
        else {
            //其他沒勾選再一個個檢查list
            rbList.each(function () {
                if ($(this).is(":checked")) {
                    isValid = true;
                }
            });
        }

        args.IsValid = isValid;

        if (!isValid) {
            $("#<%=rbList.ClientID%>").focus();
        }
    }
</script>

<%-- 為了避免designer錯誤，所以要與Mobile元件同步 --%>
<asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate></ContentTemplate>
</asp:UpdatePanel>

<table border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td>
            <table border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td nowrap>
                        <asp:LinkButton ID="lnk_Edit" runat="server" OnClick="lnk_Edit_Click" Visible="False" CausesValidation="false" meta:resourcekey="lnk_EditResource1">[修改]</asp:LinkButton>
                        <asp:LinkButton ID="lnk_Cannel" runat="server" OnClick="lnk_Cannel_Click" Visible="False" CausesValidation="false" meta:resourcekey="lnk_CannelResource1">[取消]</asp:LinkButton>
                        <asp:LinkButton ID="lnk_Submit" runat="server" OnClick="lnk_Submit_Click" Visible="False" meta:resourcekey="lnk_SubmitResource1">[確定]</asp:LinkButton>
                    </td>
                    <td>
                        <table>
                            <tr>
                                <td>
                                    <asp:RadioButtonList ID="rbList" runat="server" RepeatDirection="Horizontal" meta:resourcekey="rbListResource1" ></asp:RadioButtonList>
                                    <asp:Label ID="lblList" runat="server" Visible="False" meta:resourcekey="lblListResource1"></asp:Label>
                                    <asp:Label ID="lblOthers" Visible="False" runat="server"></asp:Label>
                                </td>
                            </tr>
                            <tr id="trOthers" runat="server">
                                <td>
                                    <asp:RadioButton ID="rbOthers" runat="server" Text="其他"  meta:resourcekey="rbOthersResource1" />
                                    <asp:TextBox ID="txtOthers" runat="server"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:CustomValidator ID="customValidator1" runat="server" Display="Dynamic" ErrorMessage="不允許空白"
                                        Visible="False" meta:resourcekey="RequiredFieldValidator1Resource1" ClientValidationFunction="CheckFieldEmpty"
                                        SetFocusOnError="True"></asp:CustomValidator>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
        <td>
            <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                ControlToValidate="rbList" Display="Dynamic" ErrorMessage="不允許空白"
                Visible="False" meta:resourcekey="RequiredFieldValidator1Resource1"
                SetFocusOnError="True"></asp:RequiredFieldValidator>--%>

            <asp:Label ID="lblHasNoAuthority" runat="server" ForeColor="Red" Text="無填寫權限" Visible="False" meta:resourcekey="lblHasNoAuthorityResource1"></asp:Label>
            <asp:Label ID="lblModifier" runat="server" Visible="False" meta:resourcekey="lblModifierResource1"></asp:Label>
            <asp:Label ID="lblMsgSigner" runat="server" Text="填寫者" Visible="False" meta:resourcekey="lblMsgSignerResource1"></asp:Label>
            <asp:Label ID="lblAuthorityMsg" runat="server" Text="具填寫權限人員" Visible="False" meta:resourcekey="lblAuthorityMsgResource1"></asp:Label>
        </td>
    </tr>
</table>
