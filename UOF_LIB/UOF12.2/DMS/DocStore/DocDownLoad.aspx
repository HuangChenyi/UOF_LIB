<%@ Page Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" Inherits="DMS_DocStore_DocDownLoad" Title="文件下載" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="DocDownLoad.aspx.cs" %>

<%@ Import Namespace="Ede.Uof.Utility" %>
<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Fast" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<%@ Register Src="~/Common/ChoiceCenter/UC_ChoiceList.ascx" TagPrefix="uc2" TagName="UC_ChoiceList" %>
<%@ Register Src="~/Common/FileCenter/V3/UC_FileCenter.ascx" TagPrefix="uc1" TagName="UC_FileCenter" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server" OnAjaxRequest="RadAjaxManager1_AjaxRequest" meta:resourcekey="RadAjaxManager1Resource1">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="RadAjaxManager1">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="gridDocRef" UpdatePanelCssClass="" UpdatePanelHeight="100%" />
                </UpdatedControls>
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="isRefGrid" UpdatePanelCssClass="" UpdatePanelHeight="100%" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManager>
    <telerik:RadCodeBlock ID="RadCodeBlock1" runat="server">
        <style type="text/css">
            .unselectable {
                -ms-user-select: none;
                -moz-user-select: none;
                -khtml-user-select: none;
                -webkit-user-select: none;
                user-select: none;
            }
            div.JustAddBorder table tr td {
                border-width: 1px;
                border-style: solid;
            }
        </style>
        <script type="text/jscript">

            var docid;
            var docversion;
            var labPDFError;
            //var labDlFile;
            var labWait;
            var labFileError;
            function pageLoad() {

            }

            $(function () {

                var showDlbutton = "<%=showDlbutton %>";
                docid = "<%=docid %>";
                docversion = "<%=versionJS %>";
                labPDFError = $("#<%=labPDFError.ClientID %>");
                labWait = $("#<%=labWait.ClientID %>");
                labFileError = $("#<%=labFileError.ClientID %>");
                labAlert = $("#<%=labAlert.ClientID %>");
                m_fileID = "<%=m_fileID %>";

                var labAlert = $("#<%=labAlert.ClientID %>");
                var isVisible = labAlert.is(':visible');

                if (showDlbutton == "true") {
                    if (typeof (DialogMasterPageWebImageButton1) != 'undefined') {
                        DialogMasterPageWebImageButton1.setVisible(true);
                        DialogMasterPageWebImageButton3.setVisible(true);
                    }
                }
                else if (showDlbutton == "false") {
                    if (typeof (DialogMasterPageWebImageButton1) != 'undefined') {
                        DialogMasterPageWebImageButton1.setVisible(false);
                        DialogMasterPageWebImageButton3.setVisible(false);

                        //如果是本文模式則不跑Timer
                        if ("<%=thisDmsDoc.v_DOC_MODE %>" == 'FILE')
                            setTimeout(function () {
                                InitializeTimer();
                            }, 1000);
                    }
                }
                else if (showDlbutton == "SourcePDFError") {
                    if (typeof (DialogMasterPageWebImageButton1) != 'undefined') {
                        DialogMasterPageWebImageButton1.setVisible(true);
                        DialogMasterPageWebImageButton3.setVisible(true);
                    }
                }
                else {
                    if (typeof (DialogMasterPageWebImageButton1) != 'undefined')
                        DialogMasterPageWebImageButton1.setVisible(false);
                    if (typeof (DialogMasterPageWebImageButton3) != 'undefined')
                        DialogMasterPageWebImageButton3.setVisible(false);
                }

            });

            function LoadAjaxManager() {

                // 重新呼叫,轉換PDF
                var ajaxManager = $find("<%= RadAjaxManager1.ClientID %>");
                ajaxManager.ajaxRequest("ReConvertPDF");
            }

            //2012-5-24 ELTON, add for download file by [FileCenterV2 FileControlHandler]
            function DownloadFileWithHandler(sHandlerUrl, sUserProxyIndex) {
                var hidPath = $("#<%=hidPath.ClientID %>").val();
                var status = '<%=status %>';
                var ajaxManager = $find("<%= RadAjaxManager1.ClientID %>");
                ajaxManager.ajaxRequest("StatisticsDocDownloadCount");
                $uof.download(sHandlerUrl, sUserProxyIndex);
                return false;
            }

            function ShowProcess() {
                $("#<%=labWait.ClientID %>").css('visibility', 'visible'); //labWait.style.visibility = "visible";

                if (typeof (labPDFError) != 'undefined')
                    $("#<%=labPDFError.ClientID %>").css('visibility', 'hidden'); //labPDFError.style.visibility = "hidden";
            }

            function ChangeStatus(result) {
                if (result.value == true) {
                    StopTheClock();

                    if (typeof (DialogMasterPageWebImageButton1) != 'undefined')
                        DialogMasterPageWebImageButton1.setVisible(true);
                    if (typeof (DialogMasterPageWebImageButton3) != 'undefined')
                        DialogMasterPageWebImageButton3.setVisible(true);

                    var labAlert;
                    labAlert = $("#<%=labAlert.ClientID %>");
                    $("#<%=labAlert.ClientID %>").css('visibility', 'hidden');
                }
            }

            function OpenPDFViewerWithFileCenterV2(sJson) {
                var h = $uof.tool.printScreenSize('h', screen.availHeight);
                var w = $uof.tool.printScreenSize('w', screen.availWidth);
                $uof.window.open("PdfViewerSL.aspx?p=" + encodeURIComponent(sJson), w, h);
            }

            var secs;
            var timerID = null;
            var timerRunning = false;
            var delay = 15000;

            function InitializeTimer() {
                secs = 5;
                StopTheClock();
                StartTheTimer();
            }

            function StopTheClock() {
                if (timerRunning)
                    clearTimeout(timerID)
                timerRunning = false
            }

            function StartTheTimer() {
                if (secs == 1) {
                    StopTheClock();
                    $("#<%=labPDFError.ClientID %>").css('visibility', 'visible'); //labPDFError.style.visibility = "visible";

                    var labAlert;
                    labAlert = $("#<%=labAlert.ClientID %>");
                        $("#<%=labAlert.ClientID %>").css('visibility', 'hidden'); //labAlert.style.visibility = "hidden";     


                }
                else {
                    self.status = secs;
                    secs = secs - 1;
                    timerRunning = true;
                    timerID = self.setTimeout("StartTheTimer()", delay);
                    var ajaxManager = $find("<%= RadAjaxManager1.ClientID %>");
                        ajaxManager.ajaxRequest("CheckPDFFileStatus");
                        var labView;
                        labView = $("#<%=labViewerDoc.ClientID %>");
                    DialogMasterPageWebImageButton1.setText(labView.innerText);
                }
            }

            function Button4Click(docid) {
                $uof.dialog.open2("~/DMS/DocStore/DocInform.aspx", this, "", 900, 900, function (returnValue) {
                    return false;
                }, { "docid": docid });
                return false;
            }

            function ReconvertPDF(sender, args) {
                setTimeout(function () {

                    var ajaxManager = $find("<%= RadAjaxManager1.ClientID %>");
                    LoadAjaxManager();
                }, 1000);
                return false;
            }

            //FireFox與Chrome無法調整大小
            //function maxsize() {

            //    if (window.dialogHeight) {
            //        window.dialogHeight = '725px';
            //        window.dialogWidth = '700px';
            //    }
            //    else {
            //        window.moveTo(0, 0);
            //        window.resizeTo(1000, 700);
            //    }       
            //}

            function printContent() {
                $uof.dialog.open2("~/DMS/DocStore/DocPrintContentByDownLoad.aspx", this, "", 1024, 768, function (returnValue) {
                    return false;
                }, { "docid": docid, "docversion": docversion, "folderid": folderid });
            }


            function setHylink() {
                hyperlinks = document.getElementById('<%= lblDocContent.ClientID %>').getElementsByTagName("a");


                for (i = 0; i < hyperlinks.length; i++) {
                    hyperlinks[i].setAttribute('target', '_blank');
                }
            }

            function copyContent() {

                var ctrlRange = document.body.createControlRange();
                var obj = document.getElementById('<%=lblDocContent.ClientID %>');
                obj.contentEditable = true;

                ctrlRange.addElement(obj);
                ctrlRange.execCommand("SelectAll", null, null);
                ctrlRange.execCommand("Copy");
                ctrlRange.execCommand("Unselect");
                obj.contentEditable = false;

                alert('<%=lblCopyed.Text %>');
                return false;

            }

            function selectContent() {

                var obj = $('#<%=lblDocContent.ClientID %>')[0];
                var browser = '<%=browser%>';
                $('#<%=lblDocContent.ClientID %>').select();

                if (browser.indexOf('Firefox') != -1 || browser.indexOf('Chrome') != -1) {
                    var selection = obj.ownerDocument.defaultView.getSelection();
                    var range = obj.ownerDocument.createRange();
                    range.selectNodeContents(obj);
                    selection.removeAllRanges();
                    selection.addRange(range);
                } else if (browser.indexOf('Safari') != -1) {
                    var selection = obj.ownerDocument.defaultView.getSelection();
                    selection.setBaseAndExtent(obj, 0, obj, 1);
                }

                return false;
            }

            function unSelectContent() {

                var obj = $('#body');

                obj.addClass("unselectable");
                $(document).bind("contextmenu", function () { return false; });
                $(document).bind("selectstart", function () { return false; });
                $(document).keydown(function () { return key(arguments[0]) });
            }

            function key(e) {
                var keynum;
                if (window.event) // IE
                {
                    keynum = e.keyCode;
                }
                else if (e.which) // Netscape/Firefox/Opera
                {
                    keynum = e.which;
                }
                if (keynum == 17) { alert("<%=lblNoCpoy.Text %>"); return false; }
            }

            function openPrint() {

                var docid = '<%=docid %>';
                var manualversion = '<%= versionJS %>'
                $uof.dialog.open2("~/DMS/DocStore/DocPrintContentByDownLoad.aspx", this, "", 1024, 768, function (returnValue) { return false;}, { "docid": docid, "docversion": manualversion });
                return false;
            }

            function rbtnCtrlInfoColumn_Clicking(sender,args)
            {
                var isVisible = $('#<%= hfIsVisible.ClientID%>').val();
                var btn = $find("<%= rbtnCtrlInfoColumn.ClientID%>");
                if (isVisible == "True") {
                    $('#<%= hfIsVisible.ClientID%>').val("False");
                    $('#<%= tr1.ClientID%>').hide()
                    $('#<%= tr2.ClientID%>').hide()
                    $('#<%= tr3.ClientID%>').hide()
                    $('#<%= tr4.ClientID%>').hide()
                    $('#<%= tr5.ClientID%>').hide()
                    btn.set_text($('#<%= hfOpenInfoTxt.ClientID%>').val());
                }
                else {
                    $('#<%= hfIsVisible.ClientID%>').val("True");
                    $('#<%= tr1.ClientID%>').show()
                    $('#<%= tr2.ClientID%>').show()
                    $('#<%= tr3.ClientID%>').show()
                    $('#<%= tr4.ClientID%>').show()
                    $('#<%= tr5.ClientID%>').show()
                    btn.set_text($('#<%= hfVisibleInfoTxt.ClientID%>').val());
                }
                args.set_cancel(true);
            }

            function Button3ClientOnClick(docID, version) {
                $uof.dialog.open2("~/DMS/DocStore/DocOfflineSecuritySetting.aspx", this, "", 900, 600, function (returnValue) { return false; }, { "docid": docid, "docversion": version });
                return false;
            }
        </script>
    </telerik:RadCodeBlock>
    
            <table id="body" border="0" style="width: 100%;height:100%" class="PopTable">
                <tr  runat="server" id="tr1">
                    <td style="white-space: nowrap; width: 25%">
                        <asp:Label ID="Label1" runat="server" Text="文件名稱" meta:resourcekey="Label1Resource1"></asp:Label></td>
                    <td style="height: 25px; width: 25%; word-wrap: break-word" colspan="3">
                        <asp:Label ID="labDocName" runat="server" meta:resourcekey="labDocNameResource1"></asp:Label>
                    </td>
                </tr>
                <tr  runat="server" id="tr2">
                    <td>
                        <asp:Label ID="Label5" runat="server" meta:resourcekey="Label5Resource2" Text="目錄"></asp:Label></td>
                    <td colspan="3">
                        <span style="word-break: break-all; width: 380px;">
                            <img src="../../DMS/images/closed.gif" />
                            <asp:Label ID="lblFolderName" runat="server" meta:resourcekey="lblFolderNameResource1"></asp:Label>
                        </span>
                    </td>
                </tr>
                <tr  runat="server" id="tr3">
                    <td>
                        <asp:Label ID="Label3" runat="server" Text="機密等級" meta:resourcekey="Label3Resource1"></asp:Label>
                    </td>
                    <td style="white-space: nowrap; width: 25%">
                        <asp:Label ID="lblSecret" runat="server" meta:resourcekey="lblSecretResource1"></asp:Label>
                    </td>
                    <td style="white-space: nowrap; width: 25%">
                        <asp:Label ID="Label6" runat="server" Text="狀態" meta:resourcekey="Label6Resource1"></asp:Label>
                    </td>
                    <td style="white-space: nowrap; width: 25%">
                        <asp:Label ID="lblStatus" runat="server" meta:resourcekey="lblStatusResource1"></asp:Label>
                    </td>
                </tr>
                <tr  runat="server" id="tr4">
                    <td>
                        <asp:Label ID="Label4" runat="server" Text="下載次數" meta:resourcekey="Label4Resource1"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="lblDownNum" runat="server" Font-Bold="True" Font-Size="Larger" ForeColor="Red" meta:resourcekey="lblDownNumResource1"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="Label2" runat="server" Text="版本" meta:resourcekey="Label2Resource1"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="labDocVersion" runat="server" meta:resourcekey="labDocVersionResource1"></asp:Label>
                    </td>
                </tr>
                <tr  runat="server" id="tr5">
                    <td>
                        <asp:Label ID="Label7" runat="server" Text="原稿控制" meta:resourcekey="Label18Resource1"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="labSourceControl" runat="server" meta:resourcekey="labSourceControlResource1"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="lblPublishDateText" runat="server" Text="公佈日" meta:resourcekey="lblPublishDateTextResource1"></asp:Label>
                    </td>
                    <td>
                        <asp:Label ID="lblPublishDate" runat="server" meta:resourcekey="lblPublishDateResource1"></asp:Label>
                    </td>
                </tr>
                <tr runat="server" id="trFilelength">
                    <td>
                        <asp:Label ID="Label8" runat="server" Text="文件大小" meta:resourcekey="Label17Resource1"></asp:Label>
                    </td>
                    <td colspan="3">
                        <asp:Label ID="lblFilelength" runat="server" ForeColor="Black" meta:resourcekey="lblFilelengthResource1"></asp:Label>
                        <asp:Label ID="Label11" runat="server" ForeColor="Black" meta:resourcekey="Label11Resource1" Visible="False" Text="Byte"></asp:Label>
                    </td>
                </tr>
                <tr style="text-align: left; height:100%">
                    <td id="content" colspan="4" class="PopTableRightTD" style="text-align: left; vertical-align: top;height:100%">
                        <div style="width:100%; text-align:right; height:25px" runat="server" visible="false" id="CtrlInfoColumn">
                            <telerik:RadButton ID="rbtnCtrlInfoColumn" runat="server"  OnClientClicking="rbtnCtrlInfoColumn_Clicking"　>
                            </telerik:RadButton>
                        </div> 
                        <telerik:RadTabStrip ID="tabDms" MultiPageID="tabDmsView" runat="server" BackColor="White" Width="100%" meta:resourcekey="tabDmsResource1" SelectedIndex="0">
                            <Tabs>
                                <telerik:RadTab runat="server" Selected="True" Value="DocContent" Text="本文內容" PageViewID="ContentRadPageView" meta:resourcekey="ContentRadPageViewResource1">
                                </telerik:RadTab>
                                <telerik:RadTab runat="server" Value="DocStatus" Text="狀態" PageViewID="RadPageView1" meta:resourcekey="TabResource1">
                                </telerik:RadTab>
                                <telerik:RadTab runat="server" Value="Remark" Text="版本備註" PageViewID="RadPageView2" meta:resourcekey="TabResource2">
                                </telerik:RadTab>
                                <telerik:RadTab runat="server" Value="DocRef" Text="參考文件" PageViewID="RadPageView3" meta:resourcekey="TabResource3">
                                </telerik:RadTab>
                                <telerik:RadTab runat="server" Value="DocIsRef" Text="被參考文件" PageViewID="RadPageView4" meta:resourcekey="RadTabResource1">
                                </telerik:RadTab>
                                <telerik:RadTab runat="server" Value="ContentFile" Text="附加檔案" PageViewID="AttachRadPageView" meta:resourcekey="AttachRadPageViewResource3">
                                </telerik:RadTab>
                        
                            </Tabs>
                        </telerik:RadTabStrip>
                        <telerik:RadMultiPage ID="tabDmsView" runat="server" BackColor="White" Width="100%" Height="90%" meta:resourcekey="tabDmsViewResource1" SelectedIndex="0">
                            <telerik:RadPageView runat="server" ID="ContentRadPageView" Height="100%" meta:resourcekey="ContentRadPageViewResource2">
                                <table border="1" class="PopTable" style="width: 99.9%;  Height:100%">
                                    <tr style="height:100%">
                                        <td colspan="2" class="PopTableRightTD" style="text-align: left;height:100%">
                                            <div class="editorcontentstyle JustAddBorder" style="width: 100%; height:100%">
                                                <asp:Label ID="lblDocContent" Width="100%" Style="word-break: break-all; word-wrap: break-word;" runat="server" Text="Label" meta:resourcekey="lblDocContentResource1"></asp:Label>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </telerik:RadPageView>
                            <telerik:RadPageView runat="server" ID="RadPageView1" meta:resourcekey="RadPageView1Resource1">
                                <table style="width: 100%; min-height:150px; height:100%">
                                    <tr>
                                        <td style="line-height: normal; text-align: center">
                                            <asp:Label ID="labFailOpenPDF" runat="server" Text="檔案有保全設定,無法開啟!!"
                                                Visible="False" ForeColor="Blue" meta:resourcekey="lblFailToOpenFile"></asp:Label>
                                            <asp:Label ID="labDlFile" runat="server" ForeColor="Black"
                                                meta:resourcekey="labDlFileResource1" Text="請按下載...來讀取此份文件......"
                                                Visible="False"></asp:Label>
                                            <br />

                                            <br />
                                            <asp:Label ID="labPDFConvertERROR" runat="server" ForeColor="Blue"
                                                meta:resourcekey="labPDFConvertERRORResource" Text="發生錯誤，轉換失敗！"
                                                Visible="False"></asp:Label>
                                            <br />
                                            <asp:Label ID="lblProtectMsg" runat="server" Text="此為保全文件無法線上觀看" ForeColor="Blue" meta:resourcekey="lblProtectMsgResource1" Visible="False"></asp:Label>
                                            <asp:Label ID="labAlert" runat="server" ForeColor="Blue"
                                                meta:resourcekey="labAlertResource1" Text="正在進行檔案轉換，請稍後再觀看"
                                                Visible="False"></asp:Label>
                                            <br />
                                            <asp:Label ID="lblNotsupportDoc" runat="server" Text="目錄設定為必須轉檔，但此檔案類型並不支援" ForeColor="Blue" meta:resourcekey="lblNotsupportDocResource1" Visible="False"></asp:Label>
                                            <!--2012-5-23 ELTON, 因檔案仍在Proxy尚未傳輸到UOF, 需顯示警告訊息-->
                                            <asp:Label ID="lblFileNotTransferToUof" runat="server" Text="目前檔案仍在Proxy伺服器，正由系統進行傳輸中，請稍後！" Visible="False" ForeColor="Blue" meta:resourcekey="lblFileNotTransferToUofResource1"></asp:Label>
                                            <br>
                                            <asp:Label ID="labFileError" runat="server" ForeColor="Blue"
                                                meta:resourcekey="labFileErrorResource1" Text="發生錯誤，檔案不存在！"
                                                Visible="False"></asp:Label>
                                            <br />
                                            <asp:Label ID="labPDFError" runat="server" ForeColor="Blue"
                                                meta:resourcekey="labPDFErrorResource1"
                                                Text="檔案目前仍在轉換處理中，請稍待幾分鐘後再試，若一直無法成功轉換，請洽系統管理員"></asp:Label>
                                            <br />
                                            <asp:Label ID="labWait" runat="server" ForeColor="Blue"
                                                meta:resourcekey="labWaitResource1" Text="請稍待，文件下載處理中..."></asp:Label>
                                            <asp:CustomValidator ID="CustomValidator1" runat="server" Display="Dynamic"
                                                ErrorMessage="累計下載次數發生錯誤" meta:resourcekey="CustomValidator1Resource1"></asp:CustomValidator>
                                            <asp:Label ID="lblDocDelete" runat="server" ForeColor="Red"
                                                meta:resourcekey="lblDocDeleteResource1" Text="文件已被銷毀" Visible="False"></asp:Label>
                                            <asp:Label ID="lblDocVerNotFind" runat="server" ForeColor="Blue"
                                                meta:resourcekey="lblDocVerNotFindResource1" Text="此版本文件不存在"
                                                Visible="False"></asp:Label>

                                        </td>
                                    </tr>
                                </table>
                            </telerik:RadPageView>
                            <telerik:RadPageView runat="server" ID="RadPageView2" meta:resourcekey="RadPageView2Resource1">
                                <div style="overflow: auto; width: 100%; height: 100%; min-height: 150px">
                                    <asp:Literal ID="literalComment" runat="server" meta:resourcekey="literalCommentResource1"></asp:Literal>
                                </div>
                            </telerik:RadPageView>
                            <telerik:RadPageView runat="server" ID="RadPageView3" meta:resourcekey="RadPageView3Resource1">
                                <div style="overflow: auto; width: 100%; height: 100%; min-height: 150px; text-align: left;">
                                    <table style="text-align: left; width: 100%">
                                        <tr>
                                            <td>
                                                <Fast:Grid ID="gridDocRef" runat="server"
                                                    AllowSorting="True" AutoGenerateCheckBoxColumn="False"
                                                    AutoGenerateColumns="False"
                                                    DataKeyOnClientWithCheckBox="False"
                                                    EnhancePager="True" OnSorting="gridDocRef_Sorting" OnPageIndexChanging="gridDocRef_PageIndexChanging"
                                                    Width="100%"
                                                    OnRowDataBound="gridDocRef_RowDataBound"  DefaultSortDirection="Ascending" EmptyDataText="No data found" KeepSelectedRows="False" PageSize="15" meta:resourcekey="gridDocRefResource1">
                                                    <EnhancePagerSettings ShowHeaderPager="True" />
                                                    <ExportExcelSettings AllowExportToExcel="False" />
                                                    <Columns>
                                                        <asp:TemplateField HeaderText="狀態" SortExpression="DOC_STATUS" meta:resourcekey="TemplateFieldResource5">
                                                            <ItemTemplate>
                                                                <asp:Label ID="lblStatus_Ref" runat="server" Text='<%# Bind("DOC_STATUS") %>' meta:resourcekey="lblStatus_RefResource1"></asp:Label>
                                                            </ItemTemplate>
                                                            <HeaderStyle Wrap="False" Width="7%" />
                                                            <ItemStyle Wrap="False" HorizontalAlign="Center" />
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="文件名稱" meta:resourceKey="TemplateFieldResource1" SortExpression="DOC_NAME">
                                                            <ItemTemplate>
                                                               <table style="width:100%;">
                                                                    <tr>
                                                                        <td style="width: 20px">
                                                                            <asp:Image ID="imgDocIcon" runat="server" ImageUrl="~/DMS/images/icon/unknown.gif" meta:resourcekey="imgDocIconResource1" />
                                                                        </td>
                                                                        <td>
                                                                            <asp:LinkButton ID="labDLFile_Ref" runat="server" Text='<%# Bind("DOC_NAME") %>' meta:resourcekey="labDLFile_RefResource1"></asp:LinkButton>
                                                                        <td >
                                                                            <table style="width:100%;">
                                                                                <tr>
                                                                                    <td style="text-align:right;">
                                                                                        <asp:ImageButton ID="imgPDFViewer" CommandName="PDFViewer" CommandArgument='<%#Eval("REF_DOC_ID")+","+Eval("PUBLISH_MANUAL_VERSION") %>' Visible="false" runat="server" AlternateText="觀看文件" OnClick="imgPDFViewer_Click"/>
                                                                                        <asp:Image ID="imgNoPDFViewer" runat="server" Visible="false"></asp:Image>
                                                                                    </td>
                                                                                </tr>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                                <br />
                                                                <asp:Label ID="lblNoLend" runat="server" Text="舊版本無權限調閱" ForeColor="Red" Visible="False" meta:resourcekey="lblNoLendResource1"></asp:Label>
                                                                <asp:Label ID="lblNoView" runat="server" Text="無權限觀看" ForeColor="Red" Visible="False" meta:resourcekey="lblNoViewResource1"></asp:Label>
                                                            </ItemTemplate>
                                                            <HeaderStyle Wrap="False" Width="60%" />
                                                        </asp:TemplateField>                                                
                                                        <asp:TemplateField HeaderText="保管者" meta:resourcekey="TemplateFieldResource4">
                                                            <ItemTemplate>
                                                                <uc2:UC_ChoiceList runat="server" ID="UC_ChoiceList_Ref" IsAllowEdit="false"></uc2:UC_ChoiceList>
                                                            </ItemTemplate>
                                                            <HeaderStyle Width="26%" Wrap="False" />                                                         
                                                        </asp:TemplateField>                                                
                                                    </Columns>
                                                </Fast:Grid>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </telerik:RadPageView>
                            <telerik:RadPageView runat="server" ID="AttachRadPageView" meta:resourcekey="AttachRadPageViewResource1">
                                <table border="1" class="PopTable" style="width: 99.9%; height: 100%; min-height: 150px">
                                    <tr>
                                        <td style=" white-space:nowrap;">
                                            <asp:Label ID="lblDocContentAttach" runat="server" Text="附加檔案" meta:resourcekey="lblDocContentAttachResource1"></asp:Label>
                                        </td>
                                        <td >
                                            <uc1:UC_FileCenter runat="server" ID="fcDocContentAttach" ModuleName="DMS" ProxyEnabled="true"  />
                                        </td>
                                    </tr>
                                </table>
                            </telerik:RadPageView>
                            <telerik:RadPageView runat="server" ID="RadPageView4" meta:resourcekey="RadPageView4Resource1">
                                <div style="overflow: auto; width: 100%; height: 100%; min-height:150px">
                                    <Fast:Grid ID="isRefGrid" runat="server"
                                        AllowSorting="True" AutoGenerateCheckBoxColumn="False"
                                        AutoGenerateColumns="False"
                                        DataKeyOnClientWithCheckBox="False"
                                        EnhancePager="True" OnSorting="isRefGrid_Sorting" OnPageIndexChanging="isRefGrid_PageIndexChanging"
                                        Width="100%"
                                         DefaultSortDirection="Ascending" EmptyDataText="No data found" KeepSelectedRows="False" PageSize="15"   OnRowDataBound="isRefGrid_RowDataBound" meta:resourcekey="isRefGridResource1" >
                                        <EnhancePagerSettings ShowHeaderPager="True" />
                                        <ExportExcelSettings AllowExportToExcel="False" />
                                        <Columns>
                                            <asp:TemplateField HeaderText="狀態" SortExpression="DOC_STATUS" meta:resourcekey="TemplateFieldResource9">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblStatus" runat="server" Text='<%# Bind("DOC_STATUS") %>' meta:resourcekey="lblStatusResource2"></asp:Label>
                                                </ItemTemplate>
                                                <HeaderStyle Wrap="False" Width="7%" />
                                                <ItemStyle Wrap="False" HorizontalAlign="Center" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="文件名稱" SortExpression="DOC_NAME" meta:resourcekey="TemplateFieldResource6">
                                                <ItemTemplate>
                                                    <table style="width:100%;">
                                                        <tr>
                                                            <td style="width: 20px">
                                                               <asp:Image ID="imgDocIcon1" runat="server" ImageUrl="~/DMS/images/icon/unknown.gif" meta:resourcekey="imgDocIcon1Resource1" />
                                                            </td>
                                                            <td>
                                                                <asp:LinkButton ID="lbtnIsRef" runat="server" Text='<%# Bind("DOC_NAME") %>' meta:resourcekey="lbtnIsRefResource1"></asp:LinkButton>
                                                            </td>
                                                            <td >
                                                                <table style="width:100%;">
                                                                    <tr>
                                                                        <td style="text-align:right;">
                                                                            <asp:ImageButton ID="imgPDFViewer" CommandName="PDFViewer"  CommandArgument='<%#Eval("DOC_ID")+","+Eval("PUBLISH_MANUAL_VERSION") %>' Visible="false" runat="server" AlternateText="觀看文件" OnClick="imgPDFViewer_Click" />
                                                                            <asp:Image ID="imgNoPDFViewer" runat="server" Visible="false"></asp:Image>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                    <br />
                                                        <asp:Label ID="lblNoView1" runat="server" Text="無權限觀看" ForeColor="Red" Visible="False" meta:resourcekey="lblNoView1Resource1"></asp:Label>                                        
                                                </ItemTemplate>
                                                <HeaderStyle Wrap="False" Width="60%" />
                                            </asp:TemplateField>                                                                        
                                            <asp:TemplateField HeaderText="保管者" meta:resourcekey="TemplateFieldResource8">
                                                <ItemTemplate>
                                                    <uc2:UC_ChoiceList runat="server" ID="UC_ChoiceList1" IsAllowEdit="false"></uc2:UC_ChoiceList>
                                                </ItemTemplate>
                                                <HeaderStyle Wrap="False" Width="26%" />
                                            </asp:TemplateField>                                    
                                        </Columns>
                                    </Fast:Grid>
                                </div>
                            </telerik:RadPageView>
                        </telerik:RadMultiPage>
                    </td>
                </tr>
            </table>
    <asp:TextBox ID="tbUnSelect" runat="server" Style="display: none;" meta:resourcekey="tbUnSelectResource1"></asp:TextBox>
    <asp:Label ID="lblDownload" runat="server" Text="下載文件" Visible="False" meta:resourcekey="lblDownloadResource1"></asp:Label>
    <asp:Label ID="labViewerDoc" runat="server" Text="觀看文件" meta:resourcekey="Label8Resource1" Style="display: none"></asp:Label>
    <asp:Label ID="lblSecretm" runat="server" Text="密" Visible="False" meta:resourcekey="lblSecretmResource1"></asp:Label>
    <asp:Label ID="lblXSecret" runat="server" Text="機密" Visible="False" meta:resourcekey="lblXSecretResource1"></asp:Label>
    <asp:Label ID="lblXXSecret" runat="server" Text="極機密" Visible="False" meta:resourcekey="lblXXSecretResource1"></asp:Label>
    <asp:Label ID="lblTopSecret" runat="server" Text="絕對機密" Visible="False" meta:resourcekey="lblTopSecretResource1"></asp:Label>

    <asp:Label ID="lblNormal" runat="server" Text="一般" Visible="False" meta:resourcekey="lblNormalResource1"></asp:Label>
    <asp:Label ID="lblCheckin" runat="server" Text="已存回" Visible="False" meta:resourcekey="lblCheckinResource1"></asp:Label>
    <asp:Label ID="lblCheckOut" runat="server" Text="已取出" Visible="False" meta:resourcekey="lblCheckOutResource1"></asp:Label>
    <asp:Label ID="lblApproval" runat="server" Text="審核中" Visible="False" meta:resourcekey="lblApprovalResource1"></asp:Label>
    <asp:Label ID="lblPublish" runat="server" Text="已公佈" Visible="False" meta:resourcekey="lblPublishResource1"></asp:Label>
    <asp:Label ID="lblInactive" runat="server" Text="已失效" Visible="False" meta:resourcekey="lblInactiveResource1"></asp:Label>
    <asp:Label ID="lblVoid" runat="server" Text="已作廢" Visible="False" meta:resourcekey="lblVoidResource1"></asp:Label>
    <asp:Label ID="lblTempInact" runat="server" Text="已下架" Visible="False" meta:resourcekey="lblTempInactResource1"></asp:Label>
    <asp:Label ID="lblOldVer" runat="server" Text="舊版本" Visible="False" meta:resourcekey="lblOldVerResource1"></asp:Label>
    <asp:Label ID="lblReAct" runat="server" Text="已上架" Visible="False" meta:resourcekey="lblReActResource1"></asp:Label>
    <asp:Label ID="labVersion" runat="server" Text="版本：" Visible="False" meta:resourcekey="labVersionResource1"></asp:Label>
    <asp:Label ID="labDocDeny" runat="server" Text="發佈拒絕" Visible="False" meta:resourcekey="labDocDenyResource1"></asp:Label>
    <asp:Label ID="labDocStore" runat="server" meta:resourcekey="labDocStoreResource1" Text="文件庫" Visible="False"></asp:Label>
    <asp:Label ID="labYes" runat="server" Text="是" meta:resourcekey="labYesResource1" Visible="False"></asp:Label>
    <asp:Label ID="labNo" runat="server" Text="否" meta:resourcekey="labNoResource1" Visible="False"></asp:Label>
    <asp:Label ID="labNoActive" runat="server" meta:resourcekey="labNoActiveResource1" Text="未生效" Visible="False"></asp:Label>
    <input id="hidPath" type="hidden" runat="server" />
    <asp:Label ID="lblEdit" runat="server" Text="資訊" meta:resourcekey="lblEditResource1" Visible="False"></asp:Label>
    <asp:Label ID="lblReconvert" runat="server" Text="重新轉檔" meta:resourcekey="lblReconvertResource1" Visible="False"></asp:Label>
    <asp:Label ID="lblPrintContent" runat="server" Text="列印本文" Visible="False" meta:resourcekey="lblPrintContentResource1"></asp:Label>
    <asp:Label ID="lblUpdating" runat="server" Text="改版中" Visible="False" meta:resourcekey="lblUpdatingResource1"></asp:Label>
    <asp:Label ID="lblVioding" runat="server" Text="(作廢審核中)" Visible="False" meta:resourcekey="lblViodingResource1"></asp:Label>
    <asp:Label ID="lblSelectButton" runat="server" Text="全選本文內容" Visible="False" meta:resourcekey="lblSelectButtonResource1"></asp:Label>
    <asp:Label ID="lblCopyButton" runat="server" Text="複製本文" Visible="False" meta:resourcekey="lblCopyButtonResource1"></asp:Label>
    <asp:Label ID="lblCopyed" runat="server" Text="本文內容已複製" Visible="False" meta:resourcekey="lblCopyedResource1"></asp:Label>
    <asp:Label ID="lblNoCpoy" runat="server" Text="禁止複製內容" Visible="False" meta:resourcekey="lblNoCpoyResource1"></asp:Label>
    <asp:Label ID="lblDraft" runat="server" Text="草稿" Visible="False" meta:resourcekey="lblDraftResource1"></asp:Label>
    <asp:Label ID="lblVisibleInfo" runat="server" Text="隱藏資訊" Visible="False" meta:resourcekey="lblVisibleInfoResource1" ></asp:Label>
    <asp:Label ID="lblOpenInfo" runat="server" Text="顯示資訊"  Visible="False" meta:resourcekey="lblOpenInfoResource1"></asp:Label>
    <asp:Label ID="lblRelease" runat="server" Text="產出UDoc" Visible="false" meta:resourcekey="lblReleaseResource1"></asp:Label>
    <asp:HiddenField ID="hfIsVisible" runat="server" />
    <asp:HiddenField ID="hfVisibleInfoTxt" runat="server" />
    <asp:HiddenField ID="hfOpenInfoTxt" runat="server" />
    <asp:HiddenField ID="hfisXPS" runat="server" />
</asp:Content>

