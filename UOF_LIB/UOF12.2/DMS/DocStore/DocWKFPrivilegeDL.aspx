﻿<%@ Page Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" Inherits="DMS_DocStore_DocWKFPrivilegeDL" Title="文件下載" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="DocWKFPrivilegeDL.aspx.cs" %>

<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Fast" %>
<%@ Register Src="~/Common/FileCenter/V3/UC_FileCenter.ascx" TagPrefix="uc1" TagName="UC_FileCenter" %>
<%@ Register Src="~/Common/ChoiceCenter/UC_ChoiceList.ascx" TagPrefix="uc2" TagName="UC_ChoiceList" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style type="text/css">
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
        var imgProcess;
        var labWait;
        var labFileError;

        $(function () {

            var showDlbutton = "<%=showDlbutton %>";
            var genUGfile = "<%= genUGfile %>";
            docid = "<%=docid %>";
            docversion = $("#<%= hfDocVersionJS.ClientID%>").val();
            labPDFError = $("#<%=labPDFError.ClientID%>").text();

            imgProcess = $("#<%=imgProcess.ClientID%>");
            labWait = $("#<%=labWait.ClientID%>");
            labFileError = $("#<%=labFileError.ClientID%>");
            labAlert = $("#<%=labAlert.ClientID%>");
            var data = ["<%=m_fileID %>", docid, docversion];
            var isVisible = labAlert.is(':visible');

            if (isVisible.toString().toLowerCase() === "true" || genUGfile.toString().toLowerCase() === "true") {
                // 重新呼叫,轉換PDF
                $uof.pageMethod.sync("ReConvertPDF", data);

            }

            if (showDlbutton == "true") {
                $("#<%=imgProcess.ClientID %>").css('visibility', 'hidden'); //imgProcess.style.visibility = "hidden";          

            if (typeof (DialogMasterPageWebImageButton1) != 'undefined')
                DialogMasterPageWebImageButton1.setVisible(true);
        }
        else if (showDlbutton == "false") {
            if (typeof (DialogMasterPageWebImageButton1) != 'undefined') {
                DialogMasterPageWebImageButton1.setVisible(false);
                //如果是本文模式則不跑Timer
                if ("<%=docMode %>" === 'FILE')
                    InitializeTimer();
            }
        }
        else if (showDlbutton == "SourcePDFError") {
            if (typeof (DialogMasterPageWebImageButton1) != 'undefined') {
                DialogMasterPageWebImageButton1.setVisible(true);
            }
        }
        else {
            if (typeof (DialogMasterPageWebImageButton1) != 'undefined')
                DialogMasterPageWebImageButton1.setVisible(false);
        }
        });

//2012-5-24 ELTON, add for download file by [FileCenterV2 FileControlHandler]
function DownloadFileWithHandler(sHandlerUrl, sUserProxyIndex) {
    var data = ["<%=docid %>", $("#<%= hfDocVersionJS.ClientID%>").val(), "<%=status %>"];
    $uof.pageMethod.sync("StatisticsDocDownloadCount", data);

    $uof.download(sHandlerUrl, sUserProxyIndex);
    return false;
}

function ShowProcess() {
    $("#<%=imgProcess.ClientID %>").css('visibility', 'visible');
            $("#<%=labWait.ClientID %>").css('visibility', 'visible');

            if (typeof (labPDFError) != 'undefined')
                $("#<%=labPDFError.ClientID %>").css('visibility', 'hidden');

            //labFileError.style.visibility = "hidden";
            //return false;
        }

        function ChangeStatus(result) {
            //alert(docid);            
            if (result.value == true) {
                StopTheClock();

                if (typeof (DialogMasterPageWebImageButton1) != 'undefined')
                    DialogMasterPageWebImageButton1.setVisible(true);

                $("#<%=labAlert.ClientID %>").css('visibility', 'hidden');
                $("#<%=imgProcess.ClientID %>").css('visibility', 'hidden');
            }
        }


        function OpenPDFViewerWithFileCenterV2(sJson) {
            var docid = '<%=docid %>';
            var docversion = $("#<%= hfDocVersionJS.ClientID%>").val();
            var status = '<%=status %>';
            var data = [docid, docversion, status];
            var h = $uof.tool.printScreenSize('h', screen.availHeight);
            var w = $uof.tool.printScreenSize('w', screen.availWidth);

            $uof.pageMethod.sync("StatisticsDocDownloadCount", data);

            $uof.window.open("PdfViewerSL.aspx?p=" + encodeURIComponent(sJson), w, h);

            

           <%-- $uof.dialog.open2("~/DMS/DocStore/PdfViewerSL.aspx", '', '', 1024, 768,
                function (returnValue) {
                    var docid = '<%=docid %>';
                    var docversion = "<%=docversionJS %>";
                    var status = '<%=status %>';
                    var data = [docid, docversion, status];
                    $uof.pageMethod.sync("StatisticsDocDownloadCount", data);

                    return false;
                }
            , { "p": sJson });--%>
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
                $("#<%=labPDFError.ClientID %>").css('visibility', 'visible');  //labPDFError.style.visibility = "visible";

                $("#<%=labAlert.ClientID %>").css('visibility', 'hidden'); //labAlert.style.visibility = "hidden";     

                $("#<%=imgProcess.ClientID %>").attr("src", "../images/alert.gif"); //imgProcess.src = "../images/alert.gif";

                //imgProcess.style.visibility = "hidden";                                                          
            }
            else {
                self.status = secs;
                secs = secs - 1;
                timerRunning = true;
                timerID = self.setTimeout("StartTheTimer()", delay);
                var data = [docid, docversion];
                var result = $uof.pageMethod.sync("CheckPDFFileStatus", data);

                if (result == "true") {
                    StopTheClock();

                    if (typeof (DialogMasterPageWebImageButton1) != 'undefined')
                        DialogMasterPageWebImageButton1.setVisible(true);

                    $("#<%=labAlert.ClientID %>").css('visibility', 'hidden');
                    $("#<%=imgProcess.ClientID %>").css('visibility', 'hidden');
                }
            }
        }

        function ReconvertPDF() {
            var docid = "<%=docid %>";
            var docversion = $("#<%= hfDocVersionJS.ClientID%>").val();
            var data = ["<%=m_fileID %>", docid, docversion];
            $uof.pageMethod.sync("ReConvertPDF", data);
            //location = location;

            location = location;

            return false;
        }



        function Button3Click1(docid) {
            $uof.dialog.open2("~/DMS/DocStore/DocInform.aspx", this, "", 900, 900, function (returnValue) {
                return false;
            }, { "docid": docid });
            return false;
        }

        function Button3Click2(docid, taskid) {
            $uof.dialog.open2("~/DMS/DocStore/DocInform.aspx", this, "", 900, 900, function (returnValue) {
                return false;
            }, { "docid": docid, "taskid": taskid });
            return false;
        }

        function rbtnCtrlInfoColumn_Clicking(sender, args) {
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

    </script>
    <table style="width: 100%; height: 100%" class="PopTable">
        <tr runat="server" id="tr1">

            <td>
                <asp:Label ID="Label1" runat="server" Text="文件名稱：" meta:resourcekey="Label1Resource1"></asp:Label></td>
            <td style="height: 25px; width: 78%; text-align: left;" colspan="3">
                <asp:Label ID="labDocName" runat="server" meta:resourcekey="labDocNameResource1"></asp:Label></td>
        </tr>
        <tr runat="server" id="tr2">
            <td>
                <asp:Label ID="Label5" runat="server" meta:resourcekey="Label5Resource2" Text="目錄："></asp:Label></td>
            <td colspan="3" style="height: 25px; width: 78%; text-align: left;">
                <img src="../../DMS/images/closed.gif" />
                <asp:Label ID="lblFolderName" runat="server" meta:resourcekey="lblFolderNameResource1"></asp:Label></td>
        </tr>
        <tr runat="server" id="tr3">
            <td>
                <asp:Label ID="Label3" runat="server" Text="機密等級：" meta:resourcekey="Label3Resource1"></asp:Label></td>
            <td style="height: 25px; width: 28%; text-align: left;">
                <asp:Label ID="lblSecret" runat="server" meta:resourcekey="lblSecretResource1"></asp:Label></td>
            <td>
                <asp:Label ID="Label6" runat="server" Text="狀態：" meta:resourcekey="Label6Resource1"></asp:Label></td>
            <td style="height: 25px; width: 28%; text-align: left;">
                <asp:Label ID="lblStatus" runat="server" meta:resourcekey="lblStatusResource1"></asp:Label></td>
        </tr>
        <tr runat="server" id="tr4">
            <td>
                <asp:Label ID="Label4" runat="server" Text="下載次數：" meta:resourcekey="Label4Resource1"></asp:Label></td>
            <td style="height: 25px; width: 28%; text-align: left;">
                <asp:Label ID="lblDownNum" runat="server" Font-Bold="True" ForeColor="Red" meta:resourcekey="lblDownNumResource1"></asp:Label></td>

            <td style="height: 25px; width: 22%">&nbsp;<asp:Label ID="Label2" runat="server" Text="版本：" meta:resourcekey="Label2Resource1"></asp:Label></td>
            <td style="height: 25px; width: 28%; text-align: left;">&nbsp;<asp:Label ID="labDocVersion" runat="server" meta:resourcekey="labDocVersionResource1"></asp:Label></td>
        </tr>
        <tr runat="server" id="tr5">
            <td>
                <asp:Label ID="Label7" runat="server" Text="原稿控制：" meta:resourcekey="Label18Resource1"></asp:Label></td>
            <td>
                <asp:Label ID="labSourceControl" runat="server" meta:resourcekey="labSourceControlResource1"></asp:Label>
            </td>
            <td>
                <asp:Label ID="lblPublishDateText" runat="server" Text="公佈日：" meta:resourcekey="lblPublishDateTextResource1"></asp:Label>
            </td>
            <td style="height: 25px; width: 28%;">
                <asp:Label ID="lblPublishDate" runat="server" meta:resourcekey="lblPublishDateResource1"></asp:Label>&nbsp;
            </td>
        </tr>
        <tr runat="server" id="trFilelength">
            <td>
                <asp:Label ID="Label8" runat="server" Text="文件大小：" meta:resourcekey="Label17Resource1"></asp:Label></td>
            <td colspan="3">
                <asp:Label ID="lblFilelength" runat="server" ForeColor="Black" meta:resourcekey="lblFilelengthResource1"></asp:Label>
                <asp:Label ID="Label11" runat="server" ForeColor="Black" meta:resourcekey="Label11Resource1"
                    Text="Byte"></asp:Label>
            </td>
        </tr>
        <tr style="text-align: left; height:100%;Width:100%;">
            <td colspan="4" class="PopTableRightTD" style="width: 100%; text-align: left;height:100%">
                <div style="width:100%; text-align:right; height:25px" runat="server" visible="false" id="CtrlInfoColumn">
                    <telerik:RadButton ID="rbtnCtrlInfoColumn" runat="server"  OnClientClicking="rbtnCtrlInfoColumn_Clicking"　>
                    </telerik:RadButton>
                </div> 
                <telerik:RadTabStrip ID="RadTabStrip1" runat="server" SelectedIndex="0" MultiPageID="RadMultiPage1" meta:resourcekey="RadTabStrip1Resource1">
                    <Tabs>
                        <telerik:RadTab runat="server" Value="DocContent" Text="本文內容" PageViewID="RadPageView4" meta:resourcekey="RadTabResource1">
                        </telerik:RadTab>
                        <telerik:RadTab runat="server" Value="DocStatus" Text="狀態" PageViewID="RadPageView1" meta:resourcekey="RadTabResource2">
                        </telerik:RadTab>
                        <telerik:RadTab runat="server" Value="Remark" Text="版本備註" PageViewID="RadPageView2" meta:resourcekey="RadTabResource3">
                        </telerik:RadTab>
                        <telerik:RadTab runat="server" Value="DocRef" Text="參考文件" PageViewID="RadPageView3" meta:resourcekey="RadTabResource4">
                        </telerik:RadTab>
                        <telerik:RadTab runat="server" Value="DocIsRef" Text="被參考文件" PageViewID="RadPageView6" meta:resourcekey="RadTabResource5">
                        </telerik:RadTab>
                        <telerik:RadTab runat="server" Value="ContentFile" Text="附加檔案" PageViewID="RadPageView5" meta:resourcekey="RadTabResource6">
                        </telerik:RadTab>
                    </Tabs>
                </telerik:RadTabStrip>
                <telerik:RadMultiPage ID="RadMultiPage1" runat="server" SelectedIndex="0" Width="100%"  Height="90%" meta:resourcekey="RadMultiPage1Resource1">
                    <telerik:RadPageView ID="RadPageView4" runat="server" Selected="True" Width="100%" Height="100%" meta:resourcekey="RadPageView4Resource1">
                        <table style="width: 100%;height:100%" class="PopTable">
                            <tr>
                                <td colspan="2" class="PopTableRightTD" style="text-align: left;height:100%;width: 100%;">
                                    <div class="editorcontentstyle JustAddBorder" style="overflow: auto; width: 100%; height: 100%">
                                        <asp:Label ID="lblDocContent" Width="100%" Style="word-break: break-all; word-wrap: break-word;" runat="server" meta:resourcekey="lblDocContentResource1"></asp:Label>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </telerik:RadPageView>
                    <telerik:RadPageView ID="RadPageView1" runat="server" meta:resourcekey="RadPageView1Resource1">
                        <asp:Panel ID="plFile" Style="width: 100%" runat="server" meta:resourcekey="plFileResource1">
                            <asp:Label ID="labDlFile" runat="server" ForeColor="Black" Text="請按下載...來讀取此份文件......" meta:resourcekey="labDlFileResource1" Visible="False"></asp:Label>
                            <br />
                            <asp:Image ID="imgProcess" runat="server" meta:resourcekey="imgProcessResource1" /><br />
                            <asp:Label ID="labPDFConvertERROR" runat="server" ForeColor="Blue"
                                Text="目前無法觀看此檔案，正在進行PDF檔案轉換，請稍待......" Visible="False" meta:resourcekey="labPDFConvertERRORResource1"></asp:Label>
                            <asp:Label ID="lblProtectMsg" runat="server" Text="此為保全文件無法線上觀看" ForeColor="Blue" Visible="False" meta:resourcekey="lblProtectMsgResource1" ></asp:Label>
                            <asp:Label ID="lblNotsupportDoc" runat="server" Text="目錄設定為必須轉檔，但此檔案類型並不支援" ForeColor="Blue" Visible="False" meta:resourcekey="lblNotsupportDocResource1" ></asp:Label><br />
                            <asp:Label ID="labAlert" runat="server" Text="目前無法觀看此檔案，正在進行PDF檔案轉換，請稍待......"
                                ForeColor="Blue" Visible="False" meta:resourcekey="labAlertResource1"></asp:Label>
                            <!--2012-5-23 ELTON, 因檔案仍在Proxy尚未傳輸到UOF, 需顯示警告訊息-->
                            <asp:Label ID="lblFileNotTransferToUof" runat="server" Text="目前檔案仍在Proxy伺服器，正由系統進行傳輸中，請稍後！" Visible="False" ForeColor="Blue" meta:resourcekey="lblFileNotTransferToUofResource1"></asp:Label>
                            <br />
                            <div style="text-align: center">
                                <asp:Label ID="labFileError" runat="server" ForeColor="Blue"
                                    Text="發生錯誤，檔案不存在！" Visible="False" meta:resourcekey="labFileErrorResource1"></asp:Label>
                            </div>
                            <asp:Label ID="labPDFError" runat="server" ForeColor="Blue"
                                Text="檔案目前仍在轉換處理中，請稍待幾分鐘後再試，若一直無法成功轉換，請洽系統管理員"
                                meta:resourcekey="labPDFErrorResource1"></asp:Label><br />
                            <asp:Label ID="labWait" runat="server" ForeColor="Blue" Text="請稍待，文件下載處理中..."
                                meta:resourcekey="labWaitResource1"></asp:Label>
                            <asp:CustomValidator ID="CustomValidator1" runat="server" Display="Dynamic" ErrorMessage="累計下載次數發生錯誤" meta:resourcekey="CustomValidator1Resource1"></asp:CustomValidator>
                            <asp:Label ID="lblDocDelete" runat="server" ForeColor="Red" Text="文件還未上傳或已被銷毀" Visible="False" meta:resourcekey="lblDocDeleteResource1"></asp:Label>
                        </asp:Panel>
                    </telerik:RadPageView>
                    <telerik:RadPageView ID="RadPageView2" runat="server" meta:resourcekey="RadPageView2Resource1">
                        <div style="overflow: auto; width: 100%; height: 100%">
                            <asp:Literal ID="literalComment" runat="server" meta:resourcekey="literalCommentResource1"></asp:Literal>
                        </div>
                    </telerik:RadPageView>
                    <telerik:RadPageView ID="RadPageView3" runat="server" meta:resourcekey="RadPageView3Resource1">
                        <div style="overflow: auto; width: 100%; min-height: 150px; text-align: left">
                            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                <ContentTemplate>
                                    <Fast:Grid ID="gridDocRef" runat="server" AllowSorting="True" AutoGenerateCheckBoxColumn="False"
                                        AutoGenerateColumns="False"  DataKeyOnClientWithCheckBox="False"
                                        EnhancePager="True"   Width="100%" OnRowDataBound="gridDocRef_RowDataBound"
                                        DefaultSortDirection="Ascending" EmptyDataText="No data found"
                                        KeepSelectedRows="False" PageSize="15" AllowPaging="True" DefaultSortColumnName="DOC_NAME" OnPageIndexChanging="gridDocRef_PageIndexChanging" OnSorting="gridDocRef_Sorting" meta:resourcekey="gridDocRefResource1">
                                        <EnhancePagerSettings ShowHeaderPager="True" />
                                        <ExportExcelSettings AllowExportToExcel="False" />
                                        <Columns>
                                            <asp:TemplateField HeaderText="狀態" SortExpression="DOC_STATUS" meta:resourcekey="TemplateFieldResource4">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblStatus_Ref" runat="server" Text='<%# Bind("DOC_STATUS") %>' meta:resourcekey="lblStatus_RefResource1"></asp:Label>
                                                </ItemTemplate>
                                                <HeaderStyle Wrap="False" Width="7%" />
                                                <ItemStyle Wrap="False" HorizontalAlign="Center" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="文件名稱" SortExpression="DOC_NAME" meta:resourcekey="TemplateFieldResource1">
                                                <ItemTemplate>
                                                    <table style="width:100%;">
                                                        <tr>
                                                            <td style="min-width: 16px">
                                                               <asp:Image ID="imgDocIcon" runat="server" ImageUrl="~/DMS/images/icon/unknown.gif" meta:resourcekey="imgDocIconResource1" />
                                                            </td>
                                                            <td>
                                                                <asp:LinkButton ID="labDLFile_Ref" runat="server" Text='<%# Bind("DOC_NAME") %>' meta:resourcekey="labDLFile_RefResource1"></asp:LinkButton>
                                                            </td>
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
                                                <HeaderStyle Width="60%" />
                                            </asp:TemplateField>

                                            <asp:TemplateField HeaderText="保管者" meta:resourcekey="TemplateFieldResource3">
                                                 <ItemTemplate>
                                                    <uc2:UC_ChoiceList ID="UC_ChoiceList_Ref" runat="server" IsAllowEdit="false" />
                                                </ItemTemplate>
                                                <HeaderStyle Width="26%" />
                                            </asp:TemplateField>
                                           
                                        </Columns>
                                    </Fast:Grid>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </div>
                    </telerik:RadPageView>
                    <telerik:RadPageView ID="RadPageView5" runat="server" meta:resourcekey="RadPageView5Resource1">
                        <table style="width: 98%" class="PopTable">
                            <tr>
                                <td class="PopTableLeftTD">
                                    <asp:Label ID="lblDocContentAttach" runat="server" Text="附加檔案：" meta:resourcekey="lblDocContentAttachResource1"></asp:Label>
                                </td>
                                <td class="PopTableRightTD" style="text-align: left;">
                                    <uc1:UC_FileCenter runat="server" ID="fcDocContentAttach" ModuleName="DMS" ProxyEnabled="true" />
                                    &nbsp;
                                </td>
                            </tr>
                        </table>
                    </telerik:RadPageView>
                    <telerik:RadPageView runat="server" ID="RadPageView6" meta:resourcekey="RadPageView6Resource1">
                        <div style="overflow: auto; width: 100%; height: 100%; min-height: 150px">
                            <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                                <ContentTemplate>
                            <Fast:Grid ID="isRefGrid" runat="server"
                                AllowSorting="True" AutoGenerateCheckBoxColumn="False"
                                AutoGenerateColumns="False"
                                DataKeyOnClientWithCheckBox="False"
                                EnhancePager="True"
                                Width="100%"
                                 DefaultSortDirection="Ascending" EmptyDataText="No data found" KeepSelectedRows="False" PageSize="15"   OnRowDataBound="isRefGrid_RowDataBound" meta:resourcekey="isRefGridResource1" AllowPaging="True" DefaultSortColumnName="DOC_NAME" OnPageIndexChanging="isRefGrid_PageIndexChanging" OnSorting="isRefGrid_Sorting">
                                <EnhancePagerSettings ShowHeaderPager="True" />
                                <ExportExcelSettings AllowExportToExcel="False" />
                                <Columns>
                                     <asp:TemplateField HeaderText="狀態" SortExpression="DOC_STATUS" meta:resourcekey="TemplateFieldResource9">
                                        <ItemTemplate>
                                            <asp:Label ID="lblStatus" runat="server" Text='<%# Bind("DOC_STATUS") %>' meta:resourcekey="lblStatusResource2"></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle Wrap="False" Width="7%" />
                                        <ItemStyle Wrap="False" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="文件名稱" SortExpression="DOC_NAME" meta:resourcekey="TemplateFieldResource6">
                                        <ItemTemplate>
                                            <table style="width:100%;">
                                                 <tr>
                                                    <td style="min-width: 16px">
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
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </div>
                    </telerik:RadPageView>
                </telerik:RadMultiPage>
            </td>
        </tr>
    </table>
    <asp:Label ID="lblDownload" runat="server" Text="下載文件" Visible="False" meta:resourcekey="lblDownloadResource1"></asp:Label>
    <asp:Label ID="labViewerDoc" runat="server" Text="觀看文件" meta:resourcekey="Label8Resource1" Visible="False"></asp:Label>
    <asp:Label ID="lblNoUpLoad" runat="server" Text="文件還未上傳,無法下載" Visible="False" meta:resourcekey="lblNoUpLoadResource1"></asp:Label>
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
    <asp:Label ID="labDocDeny" runat="server" Text="發佈拒絕" Visible="False" meta:resourcekey="labDocDenyResource1"></asp:Label>
    <asp:Label ID="labDocStore" runat="server" meta:resourcekey="labDocStoreResource1" Text="文件庫" Visible="False"></asp:Label>
    <asp:Label ID="labYes" runat="server" Text="是" meta:resourcekey="labYesResource1" Visible="False"></asp:Label>
    <asp:Label ID="labNo" runat="server" Text="否" meta:resourcekey="labNoResource1" Visible="False"></asp:Label>
    <asp:Label ID="labNoActive" runat="server" meta:resourcekey="labNoActiveResource1"
        Text="未生效" Visible="False"></asp:Label>
    <asp:Label ID="lblReconvert" runat="server" Text="重新轉檔" meta:resourcekey="lblReconvertResource1" Visible="False"></asp:Label>
    <asp:Label ID="labVersion" runat="server" Text="版本：" Visible="False" meta:resourcekey="labVersionResource1"></asp:Label>
    <asp:Label ID="lblEdit" runat="server" Text="資訊" Visible="False" meta:resourcekey="lblEditResource1"></asp:Label>
    <asp:Label ID="lblNoAuth" runat="server" Text="無表單觀看權限，故無法觀看文件" Visible="False" meta:resourcekey="lblNoAuthResource1"></asp:Label>
    <asp:Label ID="lblVioding" runat="server" Text="(作廢審核中)" Visible="False" meta:resourcekey="lblViodingResource1"></asp:Label>
    <asp:Label ID="lblUpdating" runat="server" Text="改版中" Visible="False" meta:resourcekey="lblUpdatingResource1"></asp:Label>
    <asp:Label ID="lblDraft" runat="server" Text="草稿" Visible="False" meta:resourcekey="lblDraftResource1"></asp:Label>
    <asp:Label ID="lblVisibleInfo" runat="server" Text="隱藏資訊" Visible="False" meta:resourcekey="lblVisibleInfoResource1" ></asp:Label>
    <asp:Label ID="lblOpenInfo" runat="server" Text="顯示資訊"  Visible="False" meta:resourcekey="lblOpenInfoResource1" ></asp:Label>
    <asp:HiddenField ID="hfIsVisible" runat="server" />
    <asp:HiddenField ID="hfVisibleInfoTxt" runat="server" />
    <asp:HiddenField ID="hfOpenInfoTxt" runat="server" />
    <asp:HiddenField ID="hfDocVersionJS" runat="server" />
    <asp:HiddenField ID="hfisXPS" runat="server" />
</asp:Content>

