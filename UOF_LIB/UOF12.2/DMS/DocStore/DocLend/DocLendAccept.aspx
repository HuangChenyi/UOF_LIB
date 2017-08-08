<%@ Page Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" Inherits="DMS_DocStore_DocLend_DocLendAccept" Title="文件調閱" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="DocLendAccept.aspx.cs" %>

<%@ Register Src="../../../Common/ChoiceCenter/UC_ChoiceList.ascx" TagName="UC_ChoiceList" TagPrefix="uc1" %>
<%@ Register Src="~/Common/FileCenter/V3/UC_FileCenter.ascx" TagPrefix="uc1" TagName="UC_FileCenter" %>



<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script language="javascript">

        var docid;
        var docversion;
        var labPDFError;
        //var labDlFile;
        var imgProcess;
        var labWait;
        var labFileError;

        $(function () {

            var showDlbutton = "<%=showDlbutton %>";
            docid = "<%=docid %>";
            docversion = $("#<%= hfDocVersionJS.ClientID%>").val();
            labPDFError = $("#<%=labPDFError.ClientID%>");


            imgProcess = $("#<%=imgProcess.ClientID%>");
            labWait = $("#<%=labWait.ClientID%>");
            labFileError = $("#<%=labFileError.ClientID%>");


            if (showDlbutton == "true") {
                imgProcess.hide();
                //DialogMasterPageWebImageButton1.setVisible(true);
            } else if (showDlbutton == "false") {
                //DialogMasterPageWebImageButton1.setVisible(false);     
                //如果是本文模式則不跑Timer
                if ("<%=thisDmsDoc.v_DOC_MODE %>" == 'FILE')                       
                    InitializeTimer();
            } else {
                //DialogMasterPageWebImageButton1.setVisible(false);            
            }
        });

        //2012-5-24 ELTON, add for download file by [FileCenterV2 FileControlHandler]
        function DownloadFileWithHandler(sHandlerUrl, sUserProxyIndex) {
            var data = ["<%=docid %>", $("#<%= hfDocVersionJS.ClientID%>").val()];
            $uof.pageMethod.sync("StatisticsDocDownloadCount", data);
            //DMS_DocStore_DocLend_DocLendAccept.StatisticsDocDownloadCount("<%=docid %>","<%=docversion %>");
        	$uof.download(sHandlerUrl, sUserProxyIndex);
            return false;
        }

        function ShowProcess() {
            //labDlFile.style.visibility = "hidden";
            imgProcess.show();
            labWait.show();

            if (typeof (labPDFError) != 'undefined')
                labPDFError.hide();

            //labFileError.style.visibility = "hidden";
            return true;
        }

        function ChangeStatus(result) {
            //alert(docid);            
            if (result.value == true) {
                StopTheClock();

                //DialogMasterPageWebImageButton1.setVisible(true);    


                ////DialogMasterPageWebImageButton1.onclick= function(){ downloadFile(docid); };            
                ////DialogMasterPageWebImageButton1.onclick= function(){ vvv(); };

                var labAlert;
                labAlert = $("#<%=labAlert.ClientID%>");
                labAlert.hide();

                var imgProcess;
                imgProcess = $("#<%=imgProcess.ClientID%>");
                imgProcess.hide();

                //labDlFile.style.visibility = "visible"; 

            }
        }
        function OpenPDFViewerWithFileCenterV2(sJson) {            
            var h = $uof.tool.printScreenSize('h', screen.availHeight);
            var w = $uof.tool.printScreenSize('w', screen.availWidth);
            $uof.window.open("../PdfViewerSL.aspx?p=" + encodeURIComponent(sJson), w, h);
        }



        var secs;
        var timerID = null;
        var timerRunning = false;
        var delay = 150;

        function InitializeTimer() {
            secs = 5;
            StopTheClock();
            StartTheTimer();
        }

        function StopTheClock() {
            if (timerRunning) {
                clearTimeout(timerID);
            }
            timerRunning = false;
        }

        function StartTheTimer() {
            if (secs == 1) {
                StopTheClock();
                labPDFError.hide();

                var labAlert;
                labAlert = $("#<%=labAlert.ClientID%>");
                labAlert.show();

                var imgProcess;
                imgProcess = $("#<%=imgProcess.ClientID%>");
            imgProcess.attr("src", "../../images/alert.gif");

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

                var labAlert;
                labAlert = $("#<%=labAlert.ClientID%>");
                labAlert.hide();

                var imgProcess;
                imgProcess = $("#<%=imgProcess.ClientID%>");
                imgProcess.hide();
            }
        }
    }

        //列印本文
        function printContent() {
            var docid = '<%=docid %>';
            var docversion = $("#<%= hfDocVersionJS.ClientID%>").val();
            $uof.dialog.open2("~/DMS/DocStore/DocPrintContent.aspx", this, "", 1024, 768, function (returnValue) {
                return false;
            }, { "docid": docid, docversion: docversion });
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

    
        <table id="body"  border="1" class="PopTable" style="width: 100%; height: 100%">
            <tr runat="server" id="tr1">
                <td style="white-space: nowrap; width: 22%; ">
                    <asp:Label ID="Label1" runat="server" meta:resourcekey="Label1Resource1" Text="文件名稱："></asp:Label></td>
                <td colspan="3" style=" text-align:left;">
                    <span style="word-break: break-all; ">
                        <asp:Label ID="labDocName" runat="server" meta:resourcekey="labDocNameResource1"></asp:Label>
                    </span>
                </td>
            </tr>
            <tr runat="server" id="tr2">
                <td style="width: 22%; ">
                    <asp:Label ID="Label5" runat="server" meta:resourcekey="Label5Resource2" Text="目錄："></asp:Label></td>
                <td colspan="3" style=" text-align:left;">
                    <img src="../../images/closed.gif" />
                    <asp:Label ID="lblFolderName" runat="server" meta:resourcekey="lblFolderNameResource1"></asp:Label></td>
            </tr>
            <tr runat="server" id="tr3">
                <td  style="width: 22%; ">
                    <asp:Label ID="Label3" runat="server" meta:resourcekey="Label3Resource1" Text="機密等級："></asp:Label></td>
                <td style="width: 28%; text-align:left; ">
                    <asp:Label ID="lblSecret" runat="server" meta:resourcekey="lblSecretResource1"></asp:Label></td>
                <td style="width: 22%; ">
                    <asp:Label ID="Label6" runat="server" meta:resourcekey="Label6Resource1" Text="狀態："></asp:Label></td>
                <td style="width: 28%; text-align:left; ">
                    <asp:Label ID="lblStatus" runat="server" meta:resourcekey="lblStatusResource1"></asp:Label></td>
            </tr>
            <tr  runat="server" id="tr4">
                <td  style="width: 22%; ">
                    <asp:Label ID="Label7" runat="server" meta:resourcekey="Label18Resource1" Text="原稿控制："></asp:Label></td>
                <td style="width: 28%; text-align:left; ">
                    <asp:Label ID="labSourceControl" runat="server" meta:resourcekey="labSourceControlResource1"></asp:Label></td>
                <td  style="width: 22%; ">&nbsp;
                    <asp:Label ID="Label2" runat="server" meta:resourcekey="Label2Resource1" Text="版本："></asp:Label></td>
                <td style="width: 28%; text-align:left; ">&nbsp;<asp:Label ID="labDocVersion" runat="server" meta:resourcekey="labDocVersionResource1"></asp:Label></td>
            </tr>
            <tr runat="server" id="tr5">
                <td  style="width: 22%">
                    <asp:Label ID="Label4" runat="server" Text="調閱期限：" meta:resourcekey="Label4Resource1"></asp:Label></td>
                <td  style="width: 28%">
                    <telerik:RadDatePicker ID="dateStart" runat="server" EnableTyping="False" Culture="zh-TW" meta:resourcekey="dateStartResource1" >
                    </telerik:RadDatePicker>
                </td>
                <td  style="width: 22%">
                    <asp:Label ID="Label8" runat="server" Text="至" meta:resourcekey="Label8Resource1"></asp:Label></td>
                <td style="width: 28%">
                    <telerik:RadDatePicker ID="dateEnd" runat="server" EnableTyping="False" Culture="zh-TW" meta:resourcekey="dateEndResource1" >
                    </telerik:RadDatePicker>
                </td>
            </tr>
            <tr style="text-align: left; height:100%">
                <td colspan="4" class="PopTableRightTD"  style="text-align: left; vertical-align: top;height:100%">
                    <div style="width:100%; text-align:right; height:25px" runat="server" visible="false" id="CtrlInfoColumn">
                            <telerik:RadButton ID="rbtnCtrlInfoColumn" runat="server"  OnClientClicking="rbtnCtrlInfoColumn_Clicking"　>
                            </telerik:RadButton>
                    </div> 
                    <telerik:RadTabStrip ID="tabApprove" runat="server" SelectedIndex="0" MultiPageID="RadMultiPage1" meta:resourcekey="tabApproveResource1">
                        <Tabs>
                            <telerik:RadTab runat="server" Selected="True" PageViewID="RadPageView4" Text="本文內容" meta:resourcekey="RadTabResource1">
                            </telerik:RadTab>
                            <telerik:RadTab runat="server" Text="審核者" PageViewID="RadPageView1" meta:resourcekey="TabResource1">
                            </telerik:RadTab>
                            <telerik:RadTab runat="server" Text="調閱理由" PageViewID="RadPageView2" meta:resourcekey="TabResource2">
                            </telerik:RadTab>
                            <telerik:RadTab runat="server" Text="審核意見" PageViewID="RadPageView3" meta:resourcekey="TabResource3">
                            </telerik:RadTab>
                            <telerik:RadTab runat="server" Text="附加檔案" PageViewID="RadPageView5" meta:resourcekey="RadTabResource2">
                            </telerik:RadTab>
                        </Tabs>
                    </telerik:RadTabStrip>
                    <telerik:RadMultiPage ID="RadMultiPage1" runat="server" SelectedIndex="0" Width="100%" Height="90%" meta:resourcekey="RadMultiPage1Resource1">
                        <telerik:RadPageView ID="RadPageView4" runat="server" Height="100%" Width="100%" meta:resourcekey="RadPageView4Resource1" Selected="True">
                            <table  border="1" class="PopTable" style="width: 100%;  Height:100%">
                                <tr  style="height:100%;width:100%">
                                    <td colspan="2" class="PopTableRightTD" style="text-align: left;height:100%;width:100%">
                                        <div style="overflow: auto; width: 100%; height: 100%">
                                            <asp:Label ID="lblDocContent" Width="100%" style="word-break:break-all;word-wrap:break-word;" runat="server" Text="Label" meta:resourcekey="lblDocContentResource1"></asp:Label>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </telerik:RadPageView>
                        <telerik:RadPageView ID="RadPageView1" runat="server" meta:resourcekey="RadPageView1Resource1">
                            <asp:Label ID="labApproveResult" runat="server" meta:resourcekey="labApproveResultResource1"
                                Text="審核結果："></asp:Label>
                            <asp:Label ID="labResult" runat="server" Style="color: Blue;" meta:resourcekey="labResultResource1"></asp:Label>
                            <br />
                            <asp:Label ID="Label11" runat="server" meta:resourcekey="Label11Resource1"
                                Text="審核模式："></asp:Label><asp:Label ID="labFlowType" runat="server" ForeColor="Blue" meta:resourcekey="labFlowTypeResource1"></asp:Label>
                            <br />
                            <asp:Label ID="lblFinishTime" runat="server" meta:resourcekey="lblFinishTimeResource1"
                                Text="審核時間："></asp:Label>
                            <asp:Label ID="labApproHelp" runat="server" meta:resourcekey="labApproHelpResource1"></asp:Label><br />
                            <asp:Label ID="lblUseWKFList" runat="server" Text="審核流程：" meta:resourcekey="lblUseWKFListResource1"></asp:Label>
                            <asp:DropDownList ID="ddlUseWKFList" runat="server"
                                Enabled="False" Visible="False" Width="161px" meta:resourcekey="ddlUseWKFListResource1">
                            </asp:DropDownList>
                            <telerik:RadButton ID="btnQueryFlow" runat="server" AutoPostBack="False"
                                meta:resourcekey="btnQueryFlowResource1" Text="觀看流程">
                            </telerik:RadButton>
                            &nbsp;&nbsp;&nbsp;&nbsp;<asp:Label ID="lblLastApproveUser" runat="server"
                                Visible="False" meta:resourcekey="lblLastApproveUserResource1"></asp:Label>
                            <br />
                            <center>
                                <br />
                                <asp:Image ID="imgProcess" runat="server" meta:resourcekey="imgProcessResource1" />
                                <br />
                                <asp:Label ID="labWait" runat="server" ForeColor="Blue"
                                    meta:resourcekey="labWaitResource1" Text="請稍待，文件下載處理中..."></asp:Label>
                                <asp:Label ID="labPDFConvertERROR" runat="server" ForeColor="Blue" meta:resourcekey="labPDFConvertERRORResource"
                                    Text="發生錯誤，轉換PDF失敗！" Visible="False"></asp:Label>
                                <asp:Label ID="labAlert" runat="server" ForeColor="Blue" meta:resourcekey="labAlertResource1" Text="目前無法觀看此檔案，正在進行PDF檔案轉換，請稍待......"
                                    Visible="False"></asp:Label>

                                <!--2012-5-23 ELTON, 因檔案仍在Proxy尚未傳輸到UOF, 需顯示警告訊息-->
                                <asp:Label ID="lblFileNotTransferToUof" runat="server" Text="目前檔案仍在Proxy伺服器，正由系統進行傳輸中，請稍後！" Visible="False" ForeColor="Blue" meta:resourcekey="lblFileNotTransferToUofResource1"></asp:Label>

                                <asp:Label ID="labFileError" runat="server" ForeColor="Blue"
                                    meta:resourcekey="labFileErrorResource1" Text="發生錯誤，檔案不存在！" Visible="False"></asp:Label>
                                <asp:Label ID="labPDFError" runat="server" ForeColor="Blue" meta:resourcekey="labPDFErrorResource1"
                                    Text="檔案目前仍在轉換處理中，請稍待幾分鐘後再試，若一直無法成功轉換，請洽系統管理員"></asp:Label>
                                <asp:CustomValidator ID="CustomValidator1" runat="server" Display="Dynamic" ErrorMessage="累計下載次數發生錯誤"
                                    meta:resourcekey="CustomValidator1Resource1"></asp:CustomValidator>
                                <asp:Label ID="lblDocDelete" runat="server" ForeColor="Red" Text="文件已被銷毀" Visible="False" meta:resourcekey="lblDocDeleteResource1"></asp:Label></center>
                        </telerik:RadPageView>
                        <telerik:RadPageView ID="RadPageView2" runat="server" meta:resourcekey="RadPageView2Resource1">
                            <asp:TextBox ID="txtLendReason" runat="server" Height="100%"
                                        ReadOnly="True" TextMode="MultiLine" Width="100%" meta:resourcekey="txtLendReasonResource1"></asp:TextBox>
                        </telerik:RadPageView>
                        <telerik:RadPageView ID="RadPageView3" runat="server" meta:resourcekey="RadPageView3Resource1">
                            <asp:TextBox ID="txtApproveComment" runat="server" Height="100%"
                                        ReadOnly="True" TextMode="MultiLine" Width="100%" meta:resourcekey="txtApproveCommentResource1"></asp:TextBox>
                        </telerik:RadPageView>
                        <telerik:RadPageView ID="RadPageView5" runat="server" meta:resourcekey="RadPageView5Resource1">
                            <table border="1px" cellpadding="0" cellspacing="0" width="98%" class="PopTable">
                                        <tr>
                                            <td class="PopTableLeftTD">
                                                <asp:Label ID="lblDocContentAttach" runat="server" Text="附加檔案：" meta:resourcekey="lblDocContentAttachResource1" ></asp:Label>
                                            </td>
                                            <td  class="PopTableRightTD">
                                                <uc1:UC_FileCenter runat="server" id="fcDocContentAttach" ModuleName="DMS" ProxyEnabled="true" />
                                                &nbsp;
                                            </td>
                                        </tr>
                                    </table>

                        </telerik:RadPageView>
                    </telerik:RadMultiPage>
                </td>
            </tr>

        </table>
        <asp:Label ID="lblDownload" runat="server" meta:resourcekey="lblDownloadResource1"
            Text="下載文件" Visible="False"></asp:Label><asp:Label ID="labViewerDoc" runat="server"
                meta:resourcekey="labViewerDocResource1" Text="觀看文件" Visible="False"></asp:Label>
        <asp:Label ID="labAppProce" runat="server" Text="審核流程" Visible="False" meta:resourcekey="labAppProceResource1"></asp:Label>
    <asp:Label ID="labDocStore" runat="server" meta:resourcekey="labDocStoreResource1"
        Text="文件庫" Visible="False"></asp:Label><asp:Label ID="lblSecretm" runat="server"
            meta:resourcekey="lblSecretmResource1" Text="密" Visible="False"></asp:Label><asp:Label
                ID="lblXSecret" runat="server" meta:resourcekey="lblXSecretResource1" Text="機密"
                Visible="False"></asp:Label><asp:Label ID="lblXXSecret" runat="server" meta:resourcekey="lblXXSecretResource1"
                    Text="極機密" Visible="False"></asp:Label><asp:Label ID="lblTopSecret" runat="server"
                        meta:resourcekey="lblTopSecretResource1" Text="絕對機密" Visible="False"></asp:Label><asp:Label
                            ID="lblNormal" runat="server" meta:resourcekey="lblNormalResource1" Text="一般"
                            Visible="False"></asp:Label><asp:Label ID="lblCheckin" runat="server" meta:resourcekey="lblCheckinResource1"
                                Text="已存回" Visible="False"></asp:Label><asp:Label ID="lblCheckOut" runat="server"
                                    meta:resourcekey="lblCheckOutResource1" Text="已取出" Visible="False"></asp:Label><asp:Label
                                        ID="lblApproval" runat="server" meta:resourcekey="lblApprovalResource1" Text="審核中"
                                        Visible="False"></asp:Label><asp:Label ID="lblPublish" runat="server" meta:resourcekey="lblPublishResource1"
                                            Text="已公佈" Visible="False"></asp:Label><asp:Label ID="lblInactive" runat="server"
                                                meta:resourcekey="lblInactiveResource1" Text="已失效" Visible="False"></asp:Label><asp:Label
                                                    ID="lblVoid" runat="server" meta:resourcekey="lblVoidResource1" Text="已作廢" Visible="False"></asp:Label><asp:Label
                                                        ID="lblTempInact" runat="server" meta:resourcekey="lblTempInactResource1" Text="已下架"
                                                        Visible="False"></asp:Label><asp:Label ID="lblOldVer" runat="server" meta:resourcekey="lblOldVerResource1"
                                                            Text="舊版本" Visible="False"></asp:Label><asp:Label ID="lblReAct" runat="server" meta:resourcekey="lblReActResource1"
                                                                Text="已上架" Visible="False"></asp:Label><asp:Label ID="labDocDeny" runat="server"
                                                                    meta:resourcekey="labDocDenyResource1" Text="發佈拒絕" Visible="False"></asp:Label>
    <asp:Label ID="labNoActive" runat="server" meta:resourcekey="labNoActiveResource1"
        Text="未生效" Visible="False"></asp:Label><asp:Label ID="labYes" runat="server" meta:resourcekey="labYesResource1"
            Text="是" Visible="False"></asp:Label><asp:Label ID="labNo" runat="server" meta:resourcekey="labNoResource1"
                Text="否" Visible="False"></asp:Label><asp:Label ID="lblAccept" runat="server" meta:resourcekey="lblAcceptResource1"
                    Text="允許調閱" Visible="False"></asp:Label><asp:Label ID="lblDeny" runat="server" meta:resourcekey="lblDenyResource1"
                        Text="拒絕調閱" Visible="False"></asp:Label><asp:Label ID="lblLastApprove" runat="server"
                            meta:resourcekey="lblLastApproveResource1" Text="審核者：" Visible="False"></asp:Label><asp:Label
                                ID="labUseDef" runat="server" meta:resourcekey="labUseDefResource1" Text="簡易審核"
                                Visible="False"></asp:Label><asp:Label ID="labWKF" runat="server" meta:resourcekey="labWKFResource1"
                                    Text="電子簽核" Visible="False"></asp:Label>
    <asp:Label ID="labDocNoApprove" runat="server" Text="文件不需審核" Visible="False" meta:resourcekey="labDocNoApproveResource"></asp:Label>
    <asp:Label ID="lblDeleteLend" runat="server" Text="調閱資料已被刪除，請重新申請調閱" Visible="False" meta:resourcekey="lblDeleteLendResource"></asp:Label>
    <asp:Label ID="labDocIsDelete" runat="server" Text="文件已被銷毀" Visible="False" meta:resourcekey="labDocIsDeleteResource1"></asp:Label>
    <asp:Label ID="lblNoLend" runat="server" Text="此文件目前不允許調閱" Visible="False" meta:resourcekey="lblNoLendResource1"></asp:Label>
    <asp:Label ID="lblUpdating" runat="server" Text="改版中" Visible="False" meta:resourcekey="lblUpdatingResource1"></asp:Label>
    <asp:Label ID="lblVioding" runat="server" Text="(作廢審核中)" Visible="False" meta:resourcekey="lblViodingResource1"></asp:Label>
    <asp:Label ID="lblPrintContent" runat="server" Text="列印本文" Visible="False" meta:resourcekey="lblPrintContentResource1" ></asp:Label>
    <asp:Label ID="lblVisibleInfo" runat="server" Text="隱藏資訊" Visible="False" meta:resourcekey="lblVisibleInfoResource1"  ></asp:Label>
    <asp:Label ID="lblOpenInfo" runat="server" Text="顯示資訊"  Visible="False" meta:resourcekey="lblOpenInfoResource1" ></asp:Label>
    <asp:HiddenField ID="hfIsVisible" runat="server" />
    <asp:HiddenField ID="hfVisibleInfoTxt" runat="server" />
    <asp:HiddenField ID="hfOpenInfoTxt" runat="server" />
    <asp:HiddenField ID="hfDocVersionJS" runat="server" />
</asp:Content>
