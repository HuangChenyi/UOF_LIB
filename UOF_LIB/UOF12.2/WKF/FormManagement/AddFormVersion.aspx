<%@ Page Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" Inherits="WKF_FormManagement_AddFormVersion" Title="新增表單版本" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="AddFormVersion.aspx.cs" %>

<%@ Register Src="../../Common/ChoiceCenter/UC_ChoiceList.ascx" TagName="UC_ChoiceList" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<script language="javascript">

    Sys.Application.add_load(function(){
        checkAutoNoList();
    })


function checkAutoNoList()
{

    if ($("#<%=this.rbNewVersion.ClientID%>").prop("checked") ) {
        $("#autoNOList").show();
      }
      else {
        $("#autoNOList").hide();
      }

 

    if ($("#<%=this.rbImportForm.ClientID%>").prop("checked")) {
        $("#ibtnDisplay").show();
    }
    else {
        $("#ibtnDisplay").hide();
    }

  }
  
 function hittenrbImportForm()
 {
     
     $("#rbImportForm").hide();
 }

</script>


<table width="100%" class="PopTable" cellspacing="1" style=" border-spacing:1px">
    <tr>
       <td class="PopTableLeftTD">
           <asp:Label ID="lblFormTypeTitle" runat="server" Text="表單類別" meta:resourcekey="lblFormTypeTitleResource1"></asp:Label></td>
       <td class="PopTableRightTD">
           <asp:Label ID="lblFormType" runat="server" meta:resourcekey="lblFormTypeResource1"></asp:Label></td>
       <td class="PopTableLeftTD" style=" white-space:nowrap;">
           <asp:Label ID="lblFormNameTitle" runat="server" Text="表單名稱" meta:resourcekey="lblFormNameTitleResource1"></asp:Label></td>
       <td class="PopTableRightTD">
           <asp:Label ID="lblFormName" runat="server" meta:resourcekey="lblFormNameResource1"></asp:Label></td>
    </tr>
    
    <tr>
       <td class="PopTableLeftTD">
           <asp:Label ID="lblFormVersion" runat="server" Text="版本" meta:resourcekey="lblFormVersionResource1"></asp:Label></td>
       <td colspan="3" class="PopTableRightTD">
           <asp:TextBox ID="txtBigVersionID" runat="server" Width="34px" Enabled="False" style="text-align:right" meta:resourcekey="txtBigVersionIDResource1"></asp:TextBox>
           <asp:Label ID="Label2" runat="server" Text="●" meta:resourcekey="Label2Resource1"></asp:Label>
           <asp:TextBox ID="txtSmallVersionID" runat="server" Width="43px" Enabled="False" style="text-align:right" meta:resourcekey="txtSmallVersionIDResource1"></asp:TextBox>&nbsp;
           <asp:Label ID="Label3" runat="server" ForeColor="Blue" Text="( 版本編號由系統產生! )" meta:resourcekey="Label3Resource1"></asp:Label></td>
    </tr>
    <tr>
        <td style="height: 70px" class="PopTableLeftTD">
           <asp:Label ID="lblVersionBuild" runat="server" Text="建置方式" meta:resourcekey="lblVersionBuildResource1"></asp:Label></td>
       <td colspan="3" style="height: 70px" class="PopTableRightTD">
                   
                   
           
            
           <table >
                <tr>
                    <td colspan ="2">             
                        <asp:RadioButton ID="rbNewVersion" runat="server"  Checked="True" GroupName="isVersionBuild"  Text="新表單版本" meta:resourcekey="rbNewVersionResource1" onclick="checkAutoNoList()" />
                    </td>
                </tr>
                <tr>
                    <td colspan = "2" > 
                         <asp:RadioButton ID="rbCopyVersion" runat="server"  GroupName="isVersionBuild" Text="從舊版本複製" meta:resourcekey="rbCopyVersionResource1" onclick="checkAutoNoList()" />
                         <asp:DropDownList ID="ddlAllVersion" runat="server" meta:resourcekey="ddlAllVersionResource1">
                        </asp:DropDownList>&nbsp;<asp:CheckBox ID="cbCopyFlow" runat="server" Text="含表單流程" meta:resourcekey="cbCopyFlowResource1" />
                        <asp:Label ID="lblAlertMsg" runat="server" ForeColor="Red" Text="無可複製的表單版本" Visible="False" meta:resourcekey="lblAlertMsgResource1"></asp:Label>

                    </td>
                </tr>
                <tr>
                    <td id = "rbImportForm">
                        <asp:RadioButton ID="rbImportForm" runat="server" onclick="checkAutoNoList()" GroupName="isVersionBuild" Text="匯入外部表單" meta:resourcekey="rbImportFormResource1" />
                        </td>
                    <td id = "ibtnDisplay" style ="display:none" >
                        <telerik:RadButton ID="ibtnImportForm" runat="server" Text="匯入範本" meta:resourcekey="ibtnImportFormResource1"></telerik:RadButton>
          <asp:CustomValidator ID="CustomValidator3" runat="server" ErrorMessage="請選擇表單欄位" meta:resourcekey="CustomValidator3Resource1"></asp:CustomValidator> 
                    </td>
                </tr>

           </table>
            


        </td>  
    </tr>
   <tbody id="autoNOList"> 
   <tr>
  <td class="PopTableLeftTD" style=" white-space:nowrap;"><asp:Label ID="Label1" runat="server" Text="表單編號設定" meta:resourcekey="Label1Resource1"></asp:Label></td>
  <td colspan="3" class="PopTableRightTD">
      <asp:Label ID="lblFieldID" runat="server" Text="欄位代號：" meta:resourcekey="lblFieldIDResource1"></asp:Label>
      <asp:TextBox ID="txtFieldID" runat="server" meta:resourcekey="txtFieldIDResource1"></asp:TextBox>
      <asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="請輸入欄位代號" Display="Dynamic" Visible="False" meta:resourcekey="CustomValidator1Resource1"></asp:CustomValidator>
      <asp:RegularExpressionValidator ID="RegularExpressionValidatorFieldId" runat="server" ControlToValidate="txtFieldID"
                Display="Dynamic" ErrorMessage="輸入內容只允許英文或數字"  ValidationExpression="\w+" meta:resourcekey="RegularExpressionValidatorFieldIdResource1"></asp:RegularExpressionValidator>
      <br />
      <asp:Label ID="lblFieldName" runat="server" Text="欄位名稱：" meta:resourcekey="lblFieldNameResource1"></asp:Label>
      <asp:TextBox ID="txtFieldName" runat="server" meta:resourcekey="txtFieldNameResource1"></asp:TextBox>
      <asp:CustomValidator ID="CustomValidator2" runat="server" Display="Dynamic" meta:resourcekey="CustomValidator2Resource1" ErrorMessage="請輸入欄位名稱"
          Visible="False"></asp:CustomValidator>
      <br />
      <asp:Label ID="lblTrackID" runat="server" Text="字軌選擇：" meta:resourcekey="lblTrackIDResource1"></asp:Label>
      <asp:DropDownList ID="ddlTrack" runat="server" OnSelectedIndexChanged="ddlTrack_SelectedIndexChanged" meta:resourcekey="ddlTrackResource1">
                <asp:ListItem meta:resourcekey="ListItemResource21" Text="AR"></asp:ListItem>
                <asp:ListItem meta:resourcekey="ListItemResource22" Text="AP"></asp:ListItem> 
      </asp:DropDownList>
      <telerik:RadButton ID="WebImageButton1" runat="server" Text="字軌設定" CausesValidation="False" meta:resourcekey="WebImageButton1Resource1" 
          OnClick="WebImageButton1_Click1"></telerik:RadButton>
      <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="字軌不得為空值，請新增字軌！" ControlToValidate="ddlTrack" Display="Dynamic" Visible="False" meta:resourcekey="RequiredFieldValidator1Resource1"></asp:RequiredFieldValidator>
      <br />
      <asp:Label ID="lblAutoNumberDesc" runat="server" Text="字軌(1~15)+年(西元年後兩碼2)+月(2碼)+流水號(5)" meta:resourcekey="lblAutoNumberDescResource1"></asp:Label>&nbsp;</td>
     </tr> 
</tbody>     
</table>
    <asp:Label ID="lblVersion" runat="server" meta:resourcekey="lblVersionResource1"
        Text="版本" Visible="False"></asp:Label>
    <asp:Label ID="lblFormIsexist" runat="server" meta:resourcekey="lblFormIsexistResource1"
        Text="已存在，新增版本自動更新為" Visible="False"></asp:Label>
    <asp:Label ID="lblDocNbr" runat="server" Text="表單編號" Visible="False" meta:resourcekey="lblDocNbrResource1"></asp:Label>
    <asp:HiddenField ID="HiddenField1" runat="server" />
</asp:Content>

