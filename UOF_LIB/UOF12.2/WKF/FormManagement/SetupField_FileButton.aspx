<%@ Page Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" Inherits="WKF_FormManagement_SetupField_FileButton" Title="新增欄位" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="SetupField_FileButton.aspx.cs" %>
<%@ Register Src="UC_FiledDropList.ascx" TagName="UC_FiledDropList" TagPrefix="uc3" %>
<%@ Register Src="UC_FieldControl.ascx" TagName="UC_FieldControl" TagPrefix="uc2" %>
<%@ Register Src="../../Common/ChoiceCenter/UC_ChoiceList.ascx" TagName="UC_ChoiceList" TagPrefix="uc1" %>
<%@ Register src="UC_ModifySel.ascx" tagname="UC_ModifySel" tagprefix="uc4" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        Sys.Application.add_load(function () {
            Checked_PDF();
        });


        function Checked_PDF() {
            var cb = $("#<%= chk_PDF.ClientID %>");
            if(cb.prop('checked')){
                $("div#divUseViewer").show();
                $("div#divDownloadControl").show();
                $("div#divWatermarkControl").show();
            }
            else {
                $("div#divUseViewer").hide();
                $("div#divDownloadControl").hide();
                $("div#divWatermarkControl").hide();
            }
        }

        function CheckFieldId(sender, args) {
            var fieldId = $("#<%=hiddenFieldId.ClientID%>").val();
            var formVersionId = $("#<%=hiddenformVersionId.ClientID%>").val();
            if (fieldId == "" || formVersionId == "") {
                args.set_cancel(true);
            }
            else {
                args.set_cancel(true);
                $uof.dialog.open2("~/wkf/formmanagement/setupfilewatermark.aspx",sender, "", 800, 650, function () { return false; }, { fieldId: fieldId, formVersionId: formVersionId });
            }
        }
    </script>

    <table width="100%" class="PopTable" cellspacing="1">
        <colgroup class="PopTableLeftTD">
        </colgroup>
        <colgroup class="PopTableRightTD">
        </colgroup>
        <colgroup class="PopTableLeftTD">
        </colgroup>
        <colgroup class="PopTableRightTD">
        </colgroup>
        <tr>
            <td align="center" class="PopTableHeader" colspan="4">
                 <center>
                <asp:Label ID="lblFileButton" runat="server" Text="檔案選取欄位" meta:resourcekey="lblFileButtonResource1"></asp:Label>
                </center>
                </td>
        </tr>
        <tr>
            <td><font color="red">*</font><asp:Label ID="lblFieldId" runat="server" Text="欄位代號"
                meta:resourcekey="lblFieldIdResource1"></asp:Label></td>
            <td>
                <asp:TextBox ID="txtFieldId" runat="server" Width="98px" meta:resourcekey="txtFieldIdResource1"></asp:TextBox><br />
                <asp:RequiredFieldValidator ID="RequiredFieldValidatorFieldId" runat="server" ControlToValidate="txtFieldId"
                    Display="Dynamic" ErrorMessage="請輸入欄位代號" meta:resourcekey="RequiredFieldValidatorFieldIdResource1"></asp:RequiredFieldValidator>
                <asp:CustomValidator ID="CustomValidatorFieldId" runat="server" Display="Dynamic"
                    ErrorMessage="同一表單版本的欄位代號不得重複" meta:resourcekey="CustomValidatorFieldIdResource1"></asp:CustomValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtFieldId"
                    Display="Dynamic" ErrorMessage="輸入內容只允許英文或數字" ValidationExpression="\w*" meta:resourcekey="RegularExpressionValidator1Resource1"></asp:RegularExpressionValidator></td>
            <td><font color="red">*</font><asp:Label ID="lblFieldName" runat="server" Text="欄位名稱"
                meta:resourcekey="lblFieldNameResource1"></asp:Label></td>
            <td>
                <asp:TextBox ID="txtFieldName" runat="server" Width="200px" meta:resourcekey="txtFieldNameResource1"></asp:TextBox><br />
                <asp:RequiredFieldValidator ID="RequiredFieldValidatorFieldName" runat="server" ControlToValidate="txtFieldName"
                    Display="Dynamic" ErrorMessage="請輸入欄位名稱" meta:resourcekey="RequiredFieldValidatorFieldNameResource1"></asp:RequiredFieldValidator></td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="lblFieldType" runat="server" Text="欄位格式" meta:resourcekey="lblFieldTypeResource1"></asp:Label></td>
            <td>
                <uc3:UC_FiledDropList ID="UC_FiledDropList1" runat="server" />                
                <asp:CustomValidator ID="CustomValidatorModifyFieldType" runat="server" 
                    Display="Dynamic" meta:resourcekey="CustomValidatorModifyFieldTypeResource1"></asp:CustomValidator>
                </td>
            <td>
                <asp:Label ID="lblFieldSeq" runat="server" Text="欄位順序" meta:resourcekey="lblFieldSeqResource1"></asp:Label></td>
            <td>
                <asp:Label ID="lblSeq" runat="server" meta:resourcekey="lblSeqResource1"></asp:Label>
                <telerik:RadNumericTextBox ID="RadNumericTextBoxSeq" runat="server"  MaxLength="3" MaxValue="999"
                    MinValue="0" Width="40px"></telerik:RadNumericTextBox>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="lblContentControl" runat="server" Text="內容控制" meta:resourcekey="lblContentControlResource1"></asp:Label>
            </td>
            <td colspan="3">
                <asp:CheckBox ID="chk_PDF" runat="server" Text="在欄位裡直接預覽" meta:resourcekey="chk_PDFResource1" onclick="Checked_PDF()" />
                <asp:Label ID="lblMemo" runat="server" Text="(若未購買文件轉檔服務時，只能預覽PDF檔案) " meta:resourcekey="lblMemoResource1" CssClass="SizeMemo"></asp:Label>
                <br />

                <div id="divUseViewer">
                     <asp:Label ID="lblDisplayWidth" runat="server" Text="預覽大小：" meta:resourcekey="lblDisplayWidthResource1"></asp:Label>
                     <asp:RadioButton ID="rbViewerSizeA4v" runat="server" Text="A4直式" GroupName="viewerSize" Checked="true"  meta:resourcekey="rbViewerSizeA4vResource1"/>
                     <asp:RadioButton ID="rbViewerSizeA4h" runat="server" Text="A4橫式" GroupName="viewerSize"  meta:resourcekey="rbViewerSizeA4hResource1"/>
                     <asp:RadioButton ID="rbViewerSizeCus" runat="server" Text="符合螢幕寬度" GroupName="viewerSize"  meta:resourcekey="rbViewerSizeCusResource1"/>
                    </div>
                <div id="divDownloadControl">
                    <asp:Label ID="lblDownloadControl" runat="server" Text="下載控制：" meta:resourcekey="lblDownloadControlResource1"></asp:Label>
                    <asp:RadioButton ID="rbEnableDownload" runat="server" Text="可線上觀看並下載PDF" GroupName="download" Checked="true" meta:resourcekey="rbEnableDownloadResource1" />
                    <asp:RadioButton ID="rbDisableDownload" runat="server" Text="只能線上觀看不能下載" GroupName="download" meta:resourcekey="rbDisableDownloadResource1"/>
                </div>
                <div id="divWatermarkControl">
                    <asp:Label ID="lblWatermarkControl" runat="server" Text="浮水印設定：" meta:resourcekey="lblWatermarkControlResource1"></asp:Label>
                    <telerik:RadButton ID="btnSetting" runat="server" Text="設定" OnClientClicking="CheckFieldId" Enabled="false" meta:resourcekey="btnSettingResource1"></telerik:RadButton>
                    <asp:Label ID="lblWatermarkMemo" runat="server" Text="(先儲存欄位才可設定浮水印)" CssClass="SizeMemo"  meta:resourcekey="lblWatermarkMemoResource1" ></asp:Label>
                </div>
                <div>
                    <asp:Label ID="lblRestricts" runat="server" Text="【使用限制】" CssClass="SizeMemo" meta:resourcekey="lblRestrictsResource1"></asp:Label>
                    <br />
                    <asp:Label ID="lblRestrict1" runat="server" Text="1.支援文件格式：doc, docx, txt, ppt, pptx, xls, xlsx, jpg, png, bmp, gif, pdf。" CssClass="SizeMemo" meta:resourcekey="lblRestrict1Resource1"></asp:Label>
                    <br />
                    <asp:Label ID="lblRestrict2" runat="server" Text="2.文字檔(.txt)不能超過2MB，超過不會進行轉檔。" CssClass="SizeMemo" meta:resourcekey="lblRestrict2Resource1"></asp:Label>
                    <br />
                    <asp:Label ID="lblRestrict3" runat="server" Text="3.圖形檔的長寬不能超過2048px，超過會進行等比例縮小。" CssClass="SizeMemo" meta:resourcekey="lblRestrict3Resource1"></asp:Label>
                    <br />
                    <asp:Label ID="lblRestrict4" runat="server" Text="4.有設保全的檔案，不會進行轉檔。" CssClass="SizeMemo" meta:resourcekey="lblRestrict4Resource1"></asp:Label>
                    <br />
                    <asp:Label ID="lblRestrict5" runat="server" Text="5.只能上傳一個檔案。" CssClass="SizeMemo" meta:resourcekey="lblRestrict5Resource1"></asp:Label>
                    <%--<br />--%>
                    <%--<asp:Label ID="lblRestrict6" runat="server" Text="6.若未啟用DCS，只能預覽PDF檔。" CssClass="SizeMemo" meta:resourcekey="lblRestrict6Resource1"></asp:Label>--%>
                <br />

                </div>
                
                
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="lblDispalyFieldName" runat="server" Text="欄位顯示" meta:resourcekey="lblDispalyFieldNameResource1"></asp:Label>
            </td>
            <td colspan=3>
                <asp:CheckBox ID="cbxDisplayFieldName" runat="server" Text="顯示欄位名稱" Checked=true meta:resourcekey="cbxDisplayFieldNameResource1"/>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="lblFieldControl" runat="server" Text="欄位控制" meta:resourcekey="lblFieldControlResource1"></asp:Label></td>
            <td colspan="3">
                <uc2:UC_FieldControl ID="UC_FieldControl1" runat="server" />
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="lbl_FieldModify" runat="server" Text="修改權限" 
                    meta:resourcekey="lbl_FieldModifyResource1"></asp:Label>
            </td>
            <td colspan="3">
                <uc4:UC_ModifySel ID="UC_ModifySel1" runat="server" />
            </td>
        </tr>
        <tr id="GrideDetail">
        <td>
            <asp:Label ID="lblDisplayLength" runat="server" Text="顯示寬度" meta:resourcekey="lblDisplayLengthRecource1"></asp:Label></td>
        <td colspan="3">
            <telerik:RadNumericTextBox ID="RadNumericViewLength" runat="server"
                MaxValue="1000" MinValue="0"  Width="40px" ></telerik:RadNumericTextBox>
            <asp:Label ID="Label2" runat="server" Font-Bold="True" Font-Names="Arial" 
                Text="px" meta:resourcekey="Label2Resource1"></asp:Label>
            <asp:Label ID="lblDisplayLengthNotify" runat="server" Text="(表單顯示的限制長度，設零由系統自行調整)" meta:resourcekey="lblDisplayLengthNotifyRecource1"></asp:Label></td>
    </tr>
        <tr>
            <td>
                <asp:Label ID="lblFieldRemark" runat="server" Text="欄位備註" meta:resourcekey="lblFieldRemarkResource1"></asp:Label></td>
            <td colspan="3">
                <asp:TextBox ID="txtFieldRemark" runat="server" Width="90%" meta:resourcekey="txtFieldRemarkResource1"></asp:TextBox></td>
        </tr>
    </table>
    <asp:HiddenField ID="hiddenFieldId" runat="server"></asp:HiddenField>
    <asp:HiddenField ID="hiddenformVersionId" runat="server"></asp:HiddenField>
</asp:Content>
