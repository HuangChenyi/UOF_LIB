<%@ Control Language="C#" AutoEventWireup="true" Inherits="WKF_FormManagement_VersionFieldUserControl_FileButtonUC" Codebehind="FileButtonUC.ascx.cs" %>
<%@ Reference Control="~/WKF/FormManagement/VersionFieldUserControl/VersionFieldUC.ascx" %>

<%@ Register Src="~/Common/DCS/UC_XpsViewer.ascx" TagPrefix="uc1" TagName="UC_XpsViewer" %>
<%@ Register Src="~/Common/FileCenter/V3/UC_FileCenter.ascx" TagPrefix="uc2" TagName="UC_FileCenter" %>


<script language="javascript">

    //檢查是否有上傳檔案
   function ClientValidate_<%=this.VersionField.FieldID%>(source, arguments)
   {
        if ($find("<%=UC_FileCenter.ClientID%>").get_count()  > 0)
        {
            arguments.IsValid = true;
        }
        else
        {
            arguments.IsValid = false;
        }
   }
   
</script>

<table cellpadding="0" cellspacing="0" width="100%" border="0">
    <tr>
        <td align="left">
            <table border="0" cellpadding="0" cellspacing="0" style="width:100%">
                <tr>
                    <td style="max-width: 60px" runat="server" id="tdEdit">
                        <asp:LinkButton ID="lnk_Edit" runat="server" OnClick="lnk_Edit_Click" Visible="False" CausesValidation="False" meta:resourcekey="lnk_EditResource1">[修改]</asp:LinkButton>
                        <asp:LinkButton ID="lnk_Submit" runat="server" OnClick="lnk_Submit_Click" Visible="False" meta:resourcekey="lnk_SubmitResource1">[確定]</asp:LinkButton>
                    </td>
                    <td style="text-align:left">
                        <asp:LinkButton ID="LinkButton1" runat="server" ForeColor="OliveDrab" OnClick="LinkButton1_Click" meta:resourcekey="LinkButton1Resource1" CausesValidation="False" Text="檔案操作"></asp:LinkButton>
                        <br />
                        <asp:Panel ID="pnlFileCenter" runat="server">
                            <uc2:UC_FileCenter runat="server" ID="UC_FileCenter"  ProxyEnabled="true" />
                        </asp:Panel>
                        <div>
                            <asp:Label ID="lblFileName" runat="server" Visible="false"></asp:Label>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <uc1:UC_XpsViewer runat="server" ID="UC_XpsViewer" DownloadEnabled="false" Visible="false" FileIdOrFileGroupId=""/>
                        <asp:Label ID="lblModifier" runat="server" Visible="False" meta:resourcekey="lblModifierResource1"></asp:Label>
                        </td>
                    </tr>
                </table>
        </td>
        <td>
            <asp:CustomValidator ID="CustomValidator1" runat="server" Display="Dynamic" ErrorMessage="至少需選取一項檔案！" ClientValidationFunction="ClientValidate" meta:resourcekey="CustomValidator1Resource1"></asp:CustomValidator>            
            <asp:Label ID="lblHasNoAuthority" runat="server" ForeColor="Red" Text="無填寫權限" Visible="False" meta:resourcekey="lblHasNoAuthorityResource1"></asp:Label>
            <asp:Label ID="lblFileGroupId" runat="server" Text="" Visible="false"></asp:Label>
            <asp:HiddenField ID="HiddenFieldFileButton" runat="server" />
            <asp:Label ID="lblAuthorityMsg" runat="server" Text="具填寫權限人員" Visible="False" meta:resourcekey="lblAuthorityMsgResource1"></asp:Label>
            <asp:Label ID="lblMsgSigner" runat="server" Text="填寫者" Visible="False" meta:resourcekey="lblMsgSignerResource1"></asp:Label>
            <asp:Label ID="lblViewMsg" runat="server" Text="您沒有安裝EB PDF Viewer！\n\n是否要安裝？" Visible="False" meta:resourcekey="lblViewMsgResource1"></asp:Label>
            <asp:Label ID="lblSaveTxt" runat="server" Text="下載" Visible="False" meta:resourcekey="lblSaveTxtResource1"></asp:Label>
            <asp:Label ID="lblNoPDFMsg" runat="server" Text="你的瀏覽器不援PDF Viewer." Visible="False" meta:resourcekey="lblNoPDFMsgResource1"></asp:Label>
            <asp:HiddenField ID="hiddenFieldFileId" runat="server" />
        </td>
    </tr>
</table>

