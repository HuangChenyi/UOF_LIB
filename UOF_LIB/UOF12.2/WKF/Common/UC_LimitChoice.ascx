<%@ Control Language="C#" AutoEventWireup="true" Inherits="WKF_Common_UC_LimitChoice" Codebehind="UC_LimitChoice.ascx.cs" %>
<%@ Register Src="../../Common/ChoiceCenter/UC_ChoiceList.ascx" TagName="UC_ChoiceList" TagPrefix="uc1" %>
<script type="text/javascript">
    function <%=JavaScriptFuncName1%>() { 

        if ($('#<%=rbLimit.ClientID%>').is(":checked") == false) {
            $('#<%=pnlUserControlSetting.ClientID  %>').hide();

        }
        else {
            $('#<%=pnlUserControlSetting.ClientID  %>').show();
        }    
    
    }
</script>
<asp:Panel ID="pnlLimit" runat="server" meta:resourcekey="pnlLimitResource1">
    <table border="0" width="100%">
        <tr>
            <td colspan="2">
                <asp:RadioButton ID="rbGernal" runat="server" GroupName="UserControlType"
                    Text="不限定" Checked="True" meta:resourcekey="rbGernalResource1" /><br />
                <asp:RadioButton ID="rbLimit" runat="server" GroupName="UserControlType"
                    Text="只限定下列人員" meta:resourcekey="rbLimitResource1" />
            </td>
        </tr>
        <tr>
            <td width="10px"></td>
            <td>
                <asp:Panel ID="pnlUserControlSetting" runat="server"
                    meta:resourcekey="pnlUserControlSettingResource1">
                    <asp:CheckBox ID="cbIsWithSamedep" runat="server" Text="包含簽核者同部門人員"
                        meta:resourcekey="cbIsWithSamedepResource1" />
                    <uc1:UC_ChoiceList ID="UC_ChoiceList1" runat="server" ExpandToUser="False"
                        ShowMember="False" />
                </asp:Panel>
            </td>
        </tr>
    </table>
</asp:Panel>
