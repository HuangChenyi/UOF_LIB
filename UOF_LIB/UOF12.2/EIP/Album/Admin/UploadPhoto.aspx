<%@ Page Title="相片維護" Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" Inherits="EIP_Album_Admin_MaintainPhoto" culture="auto" meta:resourcekey="PageResource1" uiculture="auto" Codebehind="UploadPhoto.aspx.cs" %>

<%@ Register Src="~/Common/FileCenter/V3/UC_FileCenter.ascx" TagPrefix="uc1" TagName="UC_FileCenter" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">


<script type="text/javascript">
    function checkBox() {
        var cbx = $("#<%= cbx.ClientID  %>").is(":checked");
        var tbxTitle = $("#<%= tbxTitle.ClientID  %>");

        if (cbx) {
            tbxTitle.attr("disabled", "disabled"); 
        }
        else {
            tbxTitle.removeAttr("disabled");
        }
    }

    function CheckInput(e, args) {

        if ("<%=trSetPhotoName.Visible.ToString().ToLower()%>" == "false") {
            var tbxTitle = $("#<%= tbxTitle.ClientID  %>");
            if (tbxTitle.val() != "") {
                args.IsValid = true;
            }
            else {
                args.IsValid = false;
            }
        }
        else {
            var cbx = $("#<%= cbx.ClientID  %>").is(":checked");
            var tbxTitle = $("#<%= tbxTitle.ClientID  %>");

            if (cbx) {
                args.IsValid = true;
            }
            else {
                if (tbxTitle.val() != "") {
                    args.IsValid = true;
                }
                else {
                    args.IsValid = false;
                }
            }

        }
    }
    
    
</script>

<asp:Label ID="lblErrorMessage" runat="server" Visible="False" ForeColor="Red" 
        meta:resourcekey="lblErrorMessageResource1"></asp:Label>
<table cellpadding="0" cellspacing="1" class="PopTable">
    <tr>
        <td style="width:20%; white-space:nowrap;" class="PopTableLeftTD"><asp:Label ID="lblSubject" 
                runat="server" Text="相簿" meta:resourcekey="lblSubjectResource1"></asp:Label></td>
        <td class="PopTableRightTD"><asp:Label ID="lblSubjectName" runat="server" 
                meta:resourcekey="lblSubjectNameResource1"></asp:Label></td>
    </tr>
    <tr id="ShowImage" runat="server">
        <td style="width:20%;white-space:nowrap;" class="PopTableLeftTD"><asp:Label ID="Label12" runat="server" 
                Text="目前相片" meta:resourcekey="Label12Resource1"></asp:Label></td>
        <td class="PopTableRightTD">            
            <uc1:UC_FileCenter runat="server" ID="UC_FileCenter2" AllowedMultipleFileSelection="false" AllowedFileType="Image" />
        </td>
    </tr>
    <tr>
        <td style="width:20%;white-space:nowrap;" class="PopTableLeftTD"><asp:Label ID="Label1" runat="server" 
                Text="相片位置" meta:resourcekey="Label1Resource1"></asp:Label></td>
        <td class="PopTableRightTD">            
            <uc1:UC_FileCenter runat="server" ID="UC_FileCenter1" AllowedMultipleFileSelection="false" AllowedFileType="Image" />
        </td>
    </tr>
    <tr>
        <td style="width:20%;white-space:nowrap;" class="PopTableLeftTD"><asp:Label ID="Label2" runat="server" 
                Text="相片主題" meta:resourcekey="Label2Resource1"></asp:Label></td>
        <td class="PopTableRightTD">
            <table cellpadding="0" cellspacing="0">
                <tr id="trSetPhotoName" runat="server">
                    <td>
                        <asp:CheckBox ID="cbx" runat="server" Text="相片檔名作為主題" onclick="checkBox()" 
                            Checked="true" meta:resourcekey="cbxResource1"  ></asp:CheckBox>
                    </td>
                </tr>
                <tr>
                    <td>
                      <asp:TextBox ID="tbxTitle" runat="server" MaxLength="20" Width="300px" 
                            Enabled="false" meta:resourcekey="tbxTitleResource1" ></asp:TextBox>
                      <asp:CustomValidator ID="RequiredFieldValidator1" runat="server" ForeColor="Red" 
                            ClientValidationFunction="CheckInput" Display="Dynamic" ErrorMessage="請輸入相片主題" 
                            meta:resourcekey="RequiredFieldValidator1Resource1"></asp:CustomValidator>        
                    </td>
                </tr>
            </table>
            
          
        </td>
    </tr>
    <tr>
        <td style="width:20%;white-space:nowrap;" class="PopTableLeftTD"><asp:Label ID="Label3" runat="server" 
                Text="相片簡述" meta:resourcekey="Label3Resource1"></asp:Label></td>
        <td class="PopTableRightTD"><asp:TextBox ID="tbxNote" runat="server" Rows="5" 
                TextMode="MultiLine" Width="100%" meta:resourcekey="tbxNoteResource1"></asp:TextBox></td>
    </tr>
    <tr>
        <td style="width:20%;white-space:nowrap;" class="PopTableLeftTD"><asp:Label ID="Label4" runat="server" 
                Text="設為封面" meta:resourcekey="Label4Resource1"></asp:Label></td>
        <td class="PopTableRightTD"><asp:CheckBox ID="cbxSetTitle" runat="server" 
                meta:resourcekey="cbxSetTitleResource1" /></td>
    </tr>
</table>

<table class="SizeMemo">
    <tr><td><asp:Label ID="Label5" runat="server" Text="備註" ForeColor="Blue" 
            meta:resourcekey="Label5Resource1"></asp:Label></td></tr>
    <tr><td><asp:Label ID="Label6" runat="server" Text="1.相片主題只允許20個字" ForeColor="Blue" 
            meta:resourcekey="Label6Resource1"></asp:Label></td></tr>
    <tr><td><asp:Label ID="Label7" runat="server" Text="2.上傳檔案只限圖檔(格式限gif、jpg、bmp、png)" 
            ForeColor="Blue" meta:resourcekey="Label7Resource1"></asp:Label></td></tr>
    <tr><td><asp:Label ID="Label8" runat="server" Text="3.檔案大小不允許超過{0}MB" 
            ForeColor="Blue" meta:resourcekey="Label8Resource1"></asp:Label></td></tr>
</table>

    <asp:Label ID="Label9" runat="server" Visible="False" Text="相簿主題不存在!!" meta:resourcekey="Label9Resource1"></asp:Label>
    <asp:Label ID="Label10" runat="server" Visible="False" Text="已有相片設定封面!!" meta:resourcekey="Label10Resource1"></asp:Label>
    <asp:Label ID="Label11" runat="server" Visible="False" Text="請選擇上傳檔案!!" meta:resourcekey="Label11Resource1"></asp:Label>
    <asp:Label ID="Label13" runat="server" Text="相片主題只允許20個字" Visible="False" meta:resourcekey="Label13Resource1"></asp:Label>
    <asp:HiddenField ID="hfCurrentUser" runat="server" />
</asp:Content>

