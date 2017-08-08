<%@ Control Language="C#" AutoEventWireup="true" Inherits="WKF_FormManagement_VersionFieldUserControl_TimeSelectUC" Codebehind="TimeSelectUC.ascx.cs" %>
<%@ Reference Control="~/WKF/FormManagement/VersionFieldUserControl/VersionFieldUC.ascx" %>

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
            <asp:LinkButton ID="lnk_Edit" runat="server" onclick="lnk_Edit_Click" Visible="False"  meta:resourcekey="lnk_EditResource1">[修改]</asp:LinkButton>
            <asp:LinkButton ID="lnk_Cannel" runat="server" onclick="lnk_Cannel_Click" Visible="False"  meta:resourcekey="lnk_CannelResource1">[取消]</asp:LinkButton>
            <asp:LinkButton ID="lnk_Submit" runat="server" onclick="lnk_Submit_Click" Visible="False"  meta:resourcekey="lnk_SubmitResource1">[確定]</asp:LinkButton>
        </td>
        <td nowrap >
        <Style>
             #telerik<%=RadTimePicker1.ClientID%> table {                
                 line-height: 1em;        
            }
            #telerik<%=RadTimePicker1.ClientID%> table td {                
                line-height: 1em;
            }
        </Style>
            <telerik:RadTimePicker ID="RadTimePicker1" runat="server" Width="100px" SkinID="AllowEmpty"></telerik:RadTimePicker>
            <asp:Label ID="lblDateTime" runat="server" Visible="False" meta:resourcekey="lblDateTimeResource1"></asp:Label>
        </td>
    </tr>
    </table>
</td>
<td>
    <asp:Button ID="Button1" runat="server" meta:resourcekey="Button1Resource1" OnClick="Button1_Click" Text="取得值" Visible="False" CausesValidation="False" />
    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
        ControlToValidate="RadTimePicker1" Display="Dynamic" ErrorMessage="不允許空白" 
        Visible="False" meta:resourcekey="RequiredFieldValidator1Resource1" 
        SetFocusOnError="True"></asp:RequiredFieldValidator>
    <asp:Label ID="lblHasNoAuthority" runat="server" ForeColor="Red" Text="無填寫權限" Visible="False" meta:resourcekey="lblHasNoAuthorityResource1"></asp:Label>
    <asp:Label ID="lblModifier" runat="server" Visible="False" meta:resourcekey="lblModifierResource1"></asp:Label>
    <asp:Label ID="lblMsgSigner" runat="server" Text="填寫者" Visible="False" meta:resourcekey="lblMsgSignerResource1"></asp:Label>
    <asp:Label ID="lblReadonly" runat="server" meta:resourcekey="lblReadonlyResource1" Text="唯讀" Visible="False"></asp:Label>
    <asp:Label ID="lblAuthorityMsg" runat="server" Text="具填寫權限人員" Visible="False" meta:resourcekey="lblAuthorityMsgResource1"></asp:Label>
    <asp:Label ID="lblField" runat="server" Text="外部資料訊息:" Visible="False" meta:resourcekey="lblFieldResource1" Font-Bold="False" ForeColor="Red"></asp:Label>
    <asp:Label ID="lblShowWSMsg" meta:resourcekey="lblShowWSMsgResource1" runat="server" Font-Bold="False" ForeColor="Red" Visible="False"></asp:Label>
    <asp:Label ID="lblWebServiceMsg" runat="server" Text="資料格式錯誤" meta:resourcekey="lblWebServiceMsgResource1" Visible="False" Font-Bold="False" ForeColor="Red"></asp:Label>
    <asp:Label ID="lblotherMSG" runat="server" ForeColor="Red" Text="呼叫外部資料時發生錯誤" Visible="False" meta:resourcekey="lblotherMSGResource1"></asp:Label>
</td>
</tr>
</table>    
