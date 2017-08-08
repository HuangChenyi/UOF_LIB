<%@ Control Language="C#" AutoEventWireup="true" CodeFile="showImg.ascx.cs" Inherits="WKF_OptionalFields_showImg" %>
<%@ Reference Control="~/WKF/FormManagement/VersionFieldUserControl/VersionFieldUC.ascx" %>
<%@ Import Namespace="Ede.Uof.Utility.FileCenter.V3" %>
<%@ Register Src="~/Common/FileCenter/V3/UC_FileCenter.ascx" TagPrefix="uc2" TagName="UC_FileCenter" %>
<%@ Register Src="~/Common/ChoiceCenter/UC_ChoiceListMobile.ascx" TagPrefix="uc2" TagName="UC_ChoiceListMobile" %>


<script language="javascript">

    //檢查是否有上傳檔案
    function ClientValidate_<%=this.VersionField.FieldID%>(source, arguments) {
        if ($find("<%=UC_FileCenter.ClientID%>").get_count() > 0) {
           arguments.IsValid = true;
       }
       else {
           arguments.IsValid = false;
        }


          }

</script>
<table class="PopTable" style="width:500px" >
    <tr>
        <td class="PopTableRightTD" style="text-align:left">
             <asp:LinkButton ID="LinkButton1" runat="server" ForeColor="OliveDrab" OnClick="LinkButton1_Click" meta:resourcekey="LinkButton1Resource1" CausesValidation="False" Text="檔案操作"></asp:LinkButton>
                        <br />
                        <asp:Panel ID="pnlFileCenter" runat="server">
                            <uc2:UC_FileCenter runat="server" ID="UC_FileCenter" Editable="false"  UploadEnabled="false" ModuleName="CDS" ProxyEnabled="true" />
                        </asp:Panel>
        </td>
    </tr>
        <tr>
        <td class="PopTableRightTD" style="text-align:left">
            <asp:Image ID="img" runat="server" />
    </tr>
    <tr>
        <td class="PopTableRightTD" style="text-align:left">
            <asp:TextBox ID="txtContent" Width="100%" Height="200px"  TextMode="MultiLine"  runat="server"></asp:TextBox>
            <asp:Label ID="lblContent" runat="server" Text="" Visible="false"></asp:Label>
            </td>
    </tr>
</table>

    <asp:CustomValidator ID="CustomValidator1" runat="server" Display="Dynamic" ErrorMessage="至少需選取一項檔案！"
         ClientValidationFunction="ClientValidate" meta:resourcekey="CustomValidator1Resource1"></asp:CustomValidator>            
<asp:Label ID="lblHasNoAuthority" runat="server" Text="無填寫權限" ForeColor="Red" Visible="False" meta:resourcekey="lblHasNoAuthorityResource1"></asp:Label>
<asp:Label ID="lblToolTipMsg" runat="server" Text="不允許修改(唯讀)" Visible="False" meta:resourcekey="lblToolTipMsgResource1"></asp:Label>
<asp:Label ID="lblModifier" runat="server" Visible="False" meta:resourcekey="lblModifierResource1"></asp:Label>
<asp:Label ID="lblMsgSigner" runat="server" Text="填寫者" Visible="False" meta:resourcekey="lblMsgSignerResource1"></asp:Label>
<asp:Label ID="lblAuthorityMsg" runat="server" Text="具填寫權限人員" Visible="False" meta:resourcekey="lblAuthorityMsgResource1"></asp:Label>