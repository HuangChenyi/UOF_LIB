<%@ Page Title="" Language="C#" MasterPageFile="~/Master/DefaultMasterPage.master" AutoEventWireup="true" CodeBehind="DocWKFFormDL.aspx.cs" Inherits="DMS_DocStore_DocWKFFormDL" culture="auto" meta:resourcekey="PageResource1" uiculture="auto" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script type="text/jscript">
        function DownloadFileWithHandler(sHandlerUrl, sUserProxyIndex) {
            var data = ["<%=docid %>", $("#<%= hfDocVersionJS.ClientID%>").val(), "<%=status %>"];
            $uof.pageMethod.sync("StatisticsDocDownloadCount", data);
            $uof.download(sHandlerUrl, sUserProxyIndex);
            return false;
        }

        function OpenPDFViewer(sJson) {
            var docid = '<%=docid %>';
            var docversion = $("#<%= hfDocVersionJS.ClientID%>").val();
            var status = '<%=status %>';
            var data = [docid, docversion, status];
            var h = $uof.tool.printScreenSize('h', screen.availHeight);
            var w = $uof.tool.printScreenSize('w', screen.availWidth);
            var url = "PdfViewerSL.aspx?p=" + encodeURIComponent(sJson);

            $uof.pageMethod.sync("StatisticsDocDownloadCount", data);

            if ($uof.tool.browser.isMobile) {
                location.replace(url);
            }
            else {
                $uof.window.open(url, w, h);
                window.open('', '_self', '');
                window.close();
            }
        }

        function OpenTextViewer(docID, status, docVer, flow, taskid) {
            //DocWKFPrivilegeDL.aspx?docid={0}&status={文件狀態}&flow={哪張文件表單}&ver={1}"
            $uof.dialog.open2("~/DMS/DocStore/DocWKFPrivilegeDL.aspx", this, "", 0, 0,
                            function (returnValue) {
                                window.open('', '_self', '');
                                window.close();
                            }
                                , { "docid": docID, "status": status, "flow": flow, "ver": docVer, 'taskid': taskid });
            return false;
        }
    </script>
    <asp:Label ID="lblNoUpLoad" runat="server" Text="文件還未上傳,無法下載" Visible="False" meta:resourcekey="lblNoUpLoadResource1"></asp:Label>
    <asp:Label ID="lblDocDelete" runat="server" ForeColor="Red" Text="文件已被銷毀" Visible="False" meta:resourcekey="lblDocDeleteResource1"></asp:Label>
    <asp:Label ID="lblNoAuth" runat="server" Text="無表單觀看權限，故無法觀看文件" Visible="False" meta:resourcekey="lblNoAuthResource1"></asp:Label>
    <asp:HiddenField ID="hfDocVersionJS" runat="server" />
    <asp:Label ID="labFileError" runat="server" ForeColor="Blue" Text="發生錯誤，檔案不存在！" Visible="False" meta:resourcekey="labFileErrorResource1"></asp:Label>
    <asp:Label ID="lblFileNotTransferToUof" runat="server" Text="目前檔案仍在Proxy伺服器，正由系統進行傳輸中，請稍後！" Visible="False" meta:resourcekey="lblFileNotTransferToUofResource1"></asp:Label>
    <asp:Label ID="labAlert" runat="server" Text="目前無法觀看此檔案，正在進行PDF檔案轉換，請稍待......" Visible="False" meta:resourcekey="labAlertResource1"></asp:Label>
    <asp:Label ID="lblNotsupportDoc" runat="server" Text="目錄設定為必須轉檔，但此檔案類型並不支援" Visible="False" meta:resourcekey="lblNotsupportDocResource1"></asp:Label>
    <asp:Label ID="lblProtectMsg" runat="server" Text="此為保全文件無法線上觀看" Visible="False" meta:resourcekey="lblProtectMsgResource1"></asp:Label>
    <asp:Label ID="lblLendProcessMsg" runat="server" Text="文件正在調閱申請中。" Visible="False" meta:resourcekey="lblLendProcessMsgResource1"></asp:Label>
    <asp:Label ID="lblLendDenyMsg" runat="server" Text="文件已調閱拒絕，請重新調閱。" Visible="False" meta:resourcekey="lblLendDenyMsgResource1"></asp:Label>
    <asp:Label ID="lblFormErrorMsg" runat="server" Text="請先送出表單，再點按文件連結。" Visible="False" meta:resourcekey="lblFormErrorMsgResource1"></asp:Label>
</asp:Content>
