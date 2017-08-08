<%@ Page Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" Inherits="DMS_DocStore_DocOutPublish" Title="文件公佈" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="DocOutPublish.aspx.cs" %>

<%@ Register Src="../../Common/ChoiceCenter/UC_ChoiceList.ascx" TagName="UC_ChoiceList" TagPrefix="uc1" %>
<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Fast" %>

<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<%@ Register Src="~/Common/FileCenter/V3/UC_FileCenter.ascx" TagPrefix="uc1" TagName="UC_FileCenter" %>

<%@ Register Src="../../Common/HtmlEditor/UC_HtmlEditor.ascx" TagName="UC_HtmlEditor" TagPrefix="uc2" %>
<%@ Register Src="~/Common/ChoiceCenter/UC_ChoiceList.ascx" TagPrefix="uc2" TagName="UC_ChoiceList" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script id="igClientScript" type="text/javascript">

        function OnClientClicked(button, args) {
            var ddlUseWKFList = $("#<%=ddlUseWKFList.ClientID %>");
            var FormVersionId = $("#<%=ddlUseWKFList.ClientID %>").val().split(',');
            $uof.dialog.open2("~/WKF/Browse/ViewMasterFlow.aspx", button, "", 900, 800, function (returnValue) { return false; }, { "formVersionId": FormVersionId[0], "flowId": FormVersionId[1] });

            return false; //button.set_autoPostBack(false);
        }

        function OnClientUploaded(id, name, path, size, contentType) {
            $("#<%=lblFileName.ClientID %>").val(name);
            $("#<%=hdFileID.ClientID %>").val(id);
        }

        function OnClientRemoved(id) {
            $("#<%=lblFileName.ClientID %>").val("");
            $("#<%=hdFileID.ClientID %>").val("");
        }

        function ConfirmApprove() {
            var browseStrSpan = "";
            var lblFileName = $("#<%=lblFileName.ClientID %>");
            var lbUploadNow = "";
            var lbBrowse = "";
            var lblApproveType = $("#<%=lblApproveType.ClientID %>");
            var lblNeedApprove = $("#<%=lblNeedApprove.ClientID %>");
            var ddlUseWKFList = $("#<%=ddlUseWKFList.ClientID %>");
            var hdApproveRMID = $("#<%=hdApproveRMID.ClientID %>");
            var isWKFListVisable = $("#<%=ddlUseWKFList.ClientID %>").is(':visible');
            var userGuid = $('#<%=this.hdUserGuid.ClientID %>').val();
            var varManualControl = $("#<%= hdVER_MANUAL_CONTROL.ClientID%>").val();
            var publishVer = $("#<%= hidPublishVer.ClientID%>").val();

            //判斷WKF是否沒流程
            if (ddlUseWKFList != null && isWKFListVisable) {
                if ($("#<%=ddlUseWKFList.ClientID %>").children('option').length == 0)  //ddlUseWKFList.options.length == 0
                {
                    return;
                }
            }
            else {
                var hdSelectWKF = $("#<%=hdSelectWKF.ClientID %>");

                if (hdSelectWKF.val() == "") {
                    return;
                }
            }

            //判斷保存日是否正確
            var rdoActive1 = $("#<%=rdoActive1.ClientID %>");
            var rdoInvalid1 = $("#<%=rdoInvalid1.ClientID %>");
            var checkrdoActive1 = $("#<%=rdoActive1.ClientID %>").is(":checked");
            var checkrdoInvalid1 = $("#<%=rdoInvalid1.ClientID %>").is(":checked");

            var picker1 = $find("<%= RadDatePicker1.ClientID %>");
            var picker2 = $find("<%= RadDatePicker2.ClientID %>");
            if (rdoInvalid1 != null && picker1) {


                var Start = new Date(picker1.get_selectedDate())
                var End = new Date(picker2.get_selectedDate())
                var getserverData = [];
                var now = $uof.pageMethod.sync("GetServerDate", getserverData);
                if (!checkrdoInvalid1)
                    if (End < new Date(now))
                        return;

                if (!checkrdoInvalid1 && !checkrdoActive1)
                    if (Start > End)
                        return;
            }


            //---------------------

            //判斷是否有輸入手動版本
            if ($("#<%=hdVER_MANUAL_CONTROL.ClientID %>").val() == "False")
                return;
            //-------------------------
            //檢查版本是否重複
            var ManVer

            if ($("#<%=txtHandVer.ClientID %>").val() != null)
                ManVer = $("#<%=txtHandVer.ClientID %>").val();
            else
                ManVer = $("#<%=lblVersion.ClientID %>").val();

            var getMVdata = [$("#<%=lblDocId.ClientID %>").val(), ManVer];
            var mvResult = $uof.pageMethod.sync("CheckManualVersion", getMVdata);
            if (mvResult == "false") {
                alert('<%=lblVersionExist.Text %>')
                return false;
            }
            //-------------------------
            var appData = [$("#<%=hidFolderID.ClientID %>").val()];
            var ApproveValue = $uof.pageMethod.sync("GetApproveValue", appData).split(",");

            lblApproveType.val(ApproveValue[2]);
            lblNeedApprove.val(ApproveValue[1]);
            hdApproveRMID.val(ApproveValue[0]);

            if (ApproveValue[2] == "WKF" && ApproveValue[1] == "true") {
                var state = false;

                if ($("#<%=hdFileID.ClientID %>").val() != "") {
                    state = true;

                    if ($("#<%=lblDocname.ClientID %>").val().replace(" ", "") == "") {
                        $("#<%=lblDocname.ClientID %>").val($("#<%=lblFileName.ClientID %>").val());
                    }
                }
                else {
                    if ($("#<%=lblFileName.ClientID %>").val().replace(" ", "") != "") {
                        state = true;
                    }
                    else {
                        $("#<%=hdIsUpLoad.ClientID %>").val("false");
                    }
                }


                $("#<%=hfstatus.ClientID %>").val(state);


            }
        }

    </script>

    <script id="DocOutPublishjs" type="text/javascript">

        var arrayNodes = new Array();
        var hidClickValue;

        $(function () {


            hidClickValue = $("#<%=hidClickValue.ClientID %>");
            if (typeof ($("#<%=hidClickValue.ClientID %>").val()) != "undefined") {
                arrayNodes = $("#<%=hidClickValue.ClientID %>").val().split(";");
            }

            ChangeActive();
            ChangeInvalid();

            if ($("#<%=rblApplyRead2.ClientID %>") != null) {

                if ($('#<%=rblApplyRead2.ClientID %> input:checked').val() == "AllowALL")
                    $("#Source_ChoiceList1").css('visibility', 'hidden');
                else
                    $("#Source_ChoiceList1").css('visibility', 'inherit');

                if ($('#<%=rblApplyRead3.ClientID %> input:checked').val() == "AllowALL")
                    $("#Source_ChoiceList2").css('visibility', 'hidden');
                else
                    $("#Source_ChoiceList2").css('visibility', 'inherit');

                if ($('#<%=rblApplyRead4.ClientID %> input:checked').val() == "AllowALL")
                    $("#Source_ChoiceList3").css('visibility', 'hidden');
                else
                    $("#Source_ChoiceList3").css('visibility', 'inherit');

                if ($('#<%=rblApplyRead5.ClientID %> input:checked').val() == "AllowALL" || $('#<%=rblApplyRead5.ClientID %> input:checked').val() == "DenyALL")
                    $("#Source_ChoiceList4").css('visibility', 'hidden');
                else
                    $("#Source_ChoiceList4").css('visibility', 'inherit');

                var ischkUseParentSet = $("#<%=chkUseParentSet.ClientID %>").is(":checked");
                var iscbChangeToPDF = $("#<%=cbChangeToPDF.ClientID%>").is(":checked");
                $("#<%=chkPrint.ClientID%>").prop("disabled", !iscbChangeToPDF || ischkUseParentSet);
                $("#<%=chkSave.ClientID%>").prop("disabled", !iscbChangeToPDF || ischkUseParentSet);
                $("#<%=chkCopy.ClientID%>").prop("disabled", !iscbChangeToPDF || ischkUseParentSet);
                $("#<%=rblApplyRead5.ClientID%>").attr("disabled", iscbChangeToPDF);
                var ischkPrint = $("#<%=chkPrint.ClientID%>").is(":checked");
                var ischkSave = $("#<%=chkSave.ClientID%>").is(":checked");
                var ischkCopy = $("#<%=chkCopy.ClientID%>").is(":checked");
                var isrblApplyRead5 = $("#<%=rblApplyRead5.ClientID%>").is(":checked");

                if ($("#<%=cbChangeToPDF.ClientID %>").is(':checked')) {
                    $("#<%=rblApplyRead2.ClientID%>").attr("disabled", !ischkPrint);
                    $("#<%=rblApplyRead3.ClientID%>").attr("disabled", !ischkSave);
                    $("#<%=rblApplyRead4.ClientID%>").attr("disabled", !ischkCopy);
                } else {
                    $("#<%=rblApplyRead2.ClientID%>").attr("disabled", !iscbChangeToPDF);
                    $("#<%=rblApplyRead3.ClientID%>").attr("disabled", !iscbChangeToPDF);
                    $("#<%=rblApplyRead4.ClientID%>").attr("disabled", !iscbChangeToPDF);
                    //原始檔控制
                    $("#Source_ChoiceList4").attr("disabled", true);
                    if ($("#<%=UC_clApplyRead5.ClientID%>").find("#btnEdit2") != null)
                        $("#<%=UC_clApplyRead5.ClientID%>").find("#btnEdit2").attr("disabled", true);

                    //列印
                    $("#Source_ChoiceList1").attr("disabled", true);
                    if ($("#<%=UC_clApplyRead2.ClientID%>").find("#btnEdit2") != null)
                        $("#<%=UC_clApplyRead2.ClientID%>").find("#btnEdit2").attr("disabled", true);

                    //另存
                    $("#Source_ChoiceList2").attr("disabled", true);
                    if ($("#<%=UC_clApplyRead3.ClientID%>").find("#btnEdit2") != null)
                $("#<%=UC_clApplyRead3.ClientID%>").find("#btnEdit2").attr("disabled", true);

                    //複製
            $("#Source_ChoiceList3").attr("disabled", true);
            if ($("#<%=UC_clApplyRead4.ClientID%>").find("#btnEdit2") != null)
                $("#<%=UC_clApplyRead4.ClientID%>").find("#btnEdit2").attr("disabled", true);
        }
    }
        });

        function clientNodeChecked(sender, eventArgs) {
            var node = eventArgs.get_node();
            var includeParentClass = $("#<%=hidIncludeParentClass.ClientID%>").val();
            if (!node.get_checked()) {                
                var a = node.get_allNodes();
                for (var j = 0; j < a.length; j++) {
                    var childNode = a[j];
                    childNode.set_checked(false);
                }
                node.set_checked(false);                 
            }
            else {
                if (includeParentClass == 'False') {
                    return;
                }
                while (node.get_parent().set_checked != null) {
                    node.get_parent().set_checked(true);
                    node = node.get_parent();
                }
            }
        }

        function ChangeActive() {
            var rdoActive1 = $("#<%=rdoActive1.ClientID%>");
            var datepicker = $find("<%= RadDatePicker1.ClientID %>");
            var cbActiveEqualPublish = $("#<%=cbActiveEqualPublish.ClientID%>");
            if (datepicker) {
                if (typeof (rdoActive1) != "undefined" && typeof (datepicker) != "undefined") {
                    if ($("#<%=rdoActive1.ClientID%>").is(":checked")) {
                        datepicker.set_enabled(false);
                        cbActiveEqualPublish.attr("disabled", true);
                    }
                    else {
                        datepicker.set_enabled(true);
                        cbActiveEqualPublish.attr("disabled", false);
                    }
                }
            }
        }

        function ChangeInvalid() {
            var rdoInvalid1 = $("#<%=rdoInvalid1.ClientID%>");
            var datepicker = $find("<%= RadDatePicker2.ClientID %>");
            if (datepicker) {
                if (typeof (rdoInvalid1) != "undefined" && typeof (datepicker) != "undefined") {
                    if ($("#<%=rdoInvalid1.ClientID%>").is(":checked"))
                        datepicker.set_enabled(false);
                    else
                        datepicker.set_enabled(true);
                }
            }
        }

        function ChangeState() {
            var ischkUseParentSet = $("#<%=chkUseParentSet.ClientID %>").is(":checked");
            var iscbChangeToPDF = $("#<%=cbChangeToPDF.ClientID%>").is(":checked");
            $("#<%=chkPrint.ClientID%>").prop("disabled", !iscbChangeToPDF || ischkUseParentSet);
            $("#<%=chkSave.ClientID%>").prop("disabled", !iscbChangeToPDF || ischkUseParentSet);
            $("#<%=chkCopy.ClientID%>").prop("disabled", !iscbChangeToPDF || ischkUseParentSet);
            $("#<%=rblApplyRead5.ClientID%>").attr("disabled", iscbChangeToPDF);

            //轉成PDF是否Check
            if (iscbChangeToPDF) {
                //原始檔下載權限是否選擇"允許全部人員"        
                if ($('#<%=UC_clApplyRead5.ClientID %> input:checked').val() == "AllowALL" || $('#<%=UC_clApplyRead5.ClientID %> input:checked').val() == "DenyALL") {
                    $("#Source_ChoiceList4").attr("disabled", true);
                    $("#<%=UC_clApplyRead5.ClientID%>").find("#btnEdit2").attr("disabled", true);
                }
                else {
                    $("#Source_ChoiceList4").attr("disabled", false);
                    $("#<%=UC_clApplyRead5.ClientID%>").find("#btnEdit2").attr("disabled", false);
                }

                //可列印是否Check   
                var ischkPrint = $("#<%=chkPrint.ClientID %>").is(':checked');
                if (ischkPrint) {
                    $("#<%=rblApplyRead2.ClientID%>").attr("disabled", !ischkPrint);
                    //可列印是否選擇"允許全部人員"
                    if ($('#<%=rblApplyRead2.ClientID %> input:checked').val() == "AllowALL") {
                        $("#Source_ChoiceList1").attr("disabled", true);
                        $("#<%=UC_clApplyRead2.ClientID%>").find("#btnEdit2").attr("disabled", true);
                    }
                    else {
                        $("#Source_ChoiceList1").attr("disabled", false);
                        $("#<%=UC_clApplyRead2.ClientID%>").find("#btnEdit2").attr("disabled", false);
                    }
                }
                else {
                    $("#Source_ChoiceList1").attr("disabled", true);
                    $("#<%=UC_clApplyRead2.ClientID%>").find("#btnEdit2").attr("disabled", true);
                }

                //可另存是否Check  
                var ischkSave = $("#<%=chkSave.ClientID %>").is(':checked');
                if (ischkSave) {
                    $("#<%=rblApplyRead3.ClientID%>").attr("disabled", !ischkSave);
                    //可另存是否選擇"允許全部人員"
                    if ($('#<%=rblApplyRead3.ClientID %> input:checked').val() == "AllowALL") {
                        $("#Source_ChoiceList2").attr("disabled", true);
                        $("#<%=UC_clApplyRead3.ClientID%>").find("#btnEdit2").attr("disabled", true);
                    }
                    else {
                        $("#Source_ChoiceList2").attr("disabled", false);
                        $("#<%=UC_clApplyRead3.ClientID%>").find("#btnEdit2").attr("disabled", false);
                    }
                }
                else {
                    $("#Source_ChoiceList2").attr("disabled", true);
                    $("#<%=UC_clApplyRead3.ClientID%>").find("#btnEdit2").attr("disabled", true);
                }

                //可複製是否Check 
                var ischkCopy = $("#<%=chkCopy.ClientID %>").is(':checked');
                if (ischkCopy) {
                    $("#<%=rblApplyRead4.ClientID%>").attr("disabled", !ischkCopy);
                    //可複製是否選擇"允許全部人員"
                    if ($('#<%=rblApplyRead4.ClientID %> input:checked').val() == "AllowALL") {
                        $("#Source_ChoiceList3").attr("disabled", true);
                        $("#<%=UC_clApplyRead4.ClientID%>").find("#btnEdit2").attr("disabled", true);
                    }
                    else {
                        $("#Source_ChoiceList3").attr("disabled", false);
                        $("#<%=UC_clApplyRead4.ClientID%>").find("#btnEdit2").attr("disabled", false);
                    }
                }
                else {
                    $("#Source_ChoiceList3").attr("disabled", true);
                    $("#<%=UC_clApplyRead4.ClientID%>").find("#btnEdit2").attr("disabled", true);
                }
            }
            else {
                $("#<%=rblApplyRead2.ClientID%>").attr("disabled", !iscbChangeToPDF);
                $("#<%=rblApplyRead3.ClientID%>").attr("disabled", !iscbChangeToPDF);
                $("#<%=rblApplyRead4.ClientID%>").attr("disabled", !iscbChangeToPDF);

                $("#Source_ChoiceList4").attr("disabled", !iscbChangeToPDF);
                $("#<%=UC_clApplyRead5.ClientID%>").find("#btnEdit2").attr("disabled", !iscbChangeToPDF);
                $("#Source_ChoiceList3").attr("disabled", !iscbChangeToPDF);
                $("#<%=UC_clApplyRead4.ClientID%>").find("#btnEdit2").attr("disabled", !iscbChangeToPDF);
                $("#Source_ChoiceList2").attr("disabled", !iscbChangeToPDF);
                $("#<%=UC_clApplyRead3.ClientID%>").find("#btnEdit2").attr("disabled", !iscbChangeToPDF);
                $("#Source_ChoiceList2").attr("disabled", !iscbChangeToPDF);
                $("#<%=UC_clApplyRead3.ClientID%>").find("#btnEdit2").attr("disabled", !iscbChangeToPDF);
                $("#Source_ChoiceList1").attr("disabled", !iscbChangeToPDF);
                $("#<%=UC_clApplyRead2.ClientID%>").find("#btnEdit2").attr("disabled", !iscbChangeToPDF);
            }
        }

//判斷是否可列印,另存,複製
        function ChangeState2(index) {
            switch (index) {
                //列印
                case 2:
                    //可列印是否Check   
                    var ischkPrint = $("#<%=chkPrint.ClientID %>").is(':checked');
                    if (ischkPrint) {
                        //可列印是否選擇"允許全部人員"
                        if ($('#<%=rblApplyRead2.ClientID %> input:checked').val() == "AllowALL") {
                            $("#Source_ChoiceList1").attr("disabled", true);
                            $("#<%=UC_clApplyRead2.ClientID%>").find("#btnEdit2").attr("disabled", true);
                        }
                        else {
                            $("#Source_ChoiceList1").attr("disabled", false);
                            $("#<%=UC_clApplyRead2.ClientID%>").find("#btnEdit2").attr("disabled", false);
                        }
                    }
                    else {
                        $("#Source_ChoiceList1").attr("disabled", true);
                        $("#<%=UC_clApplyRead2.ClientID%>").find("#btnEdit2").attr("disabled", true);
                    }
                    $("#<%=rblApplyRead2.ClientID %>").attr("disabled", !ischkPrint);
                    break;

                    //另存    
                case 3:
                    //可另存是否Check       
                    var ischkSave = $("#<%=chkSave.ClientID %>").is(':checked');
                    if (ischkSave) {
                        //可另存是否選擇"允許全部人員"
                        if ($('#<%=rblApplyRead3.ClientID %> input:checked').val() == "AllowALL") {
                            $("#Source_ChoiceList2").attr("disabled", true);
                            $("#<%=UC_clApplyRead3.ClientID%>").find("#btnEdit2").attr("disabled", true);
                        }
                        else {
                            $("#Source_ChoiceList2").attr("disabled", false);
                            $("#<%=UC_clApplyRead3.ClientID%>").find("#btnEdit2").attr("disabled", false);
                        }
                    }
                    else {
                        $("#Source_ChoiceList2").attr("disabled", true);
                        $("#<%=UC_clApplyRead3.ClientID%>").find("#btnEdit2").attr("disabled", true);
                    }
                    $("#<%=rblApplyRead3.ClientID %>").attr("disabled", !ischkSave);
                    break;

                    //複製    
                case 4:
                    //可複製是否Check    
                    var ischkCopy = $("#<%=chkCopy.ClientID %>").is(':checked');
                    if (ischkCopy) {
                        //可複製是否選擇"允許全部人員"
                        if ($('#<%=rblApplyRead4.ClientID %> input:checked').val() == "AllowALL") {
                            $("#Source_ChoiceList3").attr("disabled", true);
                            $("#<%=UC_clApplyRead4.ClientID%>").find("#btnEdit2").attr("disabled", true);
                        }
                        else {
                            $("#Source_ChoiceList3").attr("disabled", false);
                            $("#<%=UC_clApplyRead4.ClientID%>").find("#btnEdit2").attr("disabled", false);
                        }
                    }
                    else {
                        $("#Source_ChoiceList3").attr("disabled", false);
                        $("#<%=UC_clApplyRead4.ClientID%>").find("#btnEdit2").attr("disabled", true);
                    }
                    $("#<%=rblApplyRead4.ClientID %>").attr("disabled", !ischkCopy);
                    break;
            }
        }

//判斷原始檔選擇人員
        function ChangeSelApplyUser5(theRadio) {

            if (theRadio == "") {
                $("#Source_ChoiceList4").css('visibility', 'hidden');
                $("#Source_ChoiceList4").attr("disabled", true);
                $("#<%=UC_clApplyRead5.ClientID%>").find("#btnEdit2").attr("disabled", true);
                return;
            }

            if (theRadio.value == "AllowALL" || theRadio.value == "DenyALL") {
                $("#Source_ChoiceList4").css('visibility', 'hidden');
                $("#Source_ChoiceList4").attr("disabled", true);
                $("#<%=UC_clApplyRead5.ClientID%>").find("#btnEdit2").attr("disabled", true);
            }
            else {
                $("#Source_ChoiceList4").css('visibility', 'visible');
                $("#Source_ChoiceList4").attr("disabled", false);
                $("#<%=UC_clApplyRead5.ClientID%>").find("#btnEdit2").attr("disabled", false);
            }
        }

//判斷可列印選擇人員
        function ChangeSelApplyUser2(theRadio) {
            if (theRadio == "") {
                $("#Source_ChoiceList1").css('visibility', 'hidden');
                $("#Source_ChoiceList1").attr("disabled", true);
                $("#<%=UC_clApplyRead2.ClientID%>").find("#btnEdit2").attr("disabled", true);
                return;
            }

            if (theRadio.value == "AllowALL") {
                $("#Source_ChoiceList1").css('visibility', 'hidden');
                $("#Source_ChoiceList1").attr("disabled", true);
                $("#<%=UC_clApplyRead2.ClientID%>").find("#btnEdit2").attr("disabled", true);
            }
            else {
                $("#Source_ChoiceList1").css('visibility', 'visible');
                $("#Source_ChoiceList1").attr("disabled", false);
                $("#<%=UC_clApplyRead2.ClientID%>").find("#btnEdit2").attr("disabled", false);
            }
        }

 //判斷可另存選擇人員
        function ChangeSelApplyUser3(theRadio) {
            if (theRadio == "") {
                $("#Source_ChoiceList2").css('visibility', 'hidden');
                $("#Source_ChoiceList2").attr("disabled", true);
                $("#<%=UC_clApplyRead3.ClientID%>").find("#btnEdit2").attr("disabled", true);
                return;
            }

            if (theRadio.value == "AllowALL") {
                $("#Source_ChoiceList2").css('visibility', 'hidden');
                $("#Source_ChoiceList2").attr("disabled", true);
                $("#<%=UC_clApplyRead3.ClientID%>").find("#btnEdit2").attr("disabled", true);
            }
            else {
                $("#Source_ChoiceList2").css('visibility', 'visible');
                $("#Source_ChoiceList2").attr("disabled", false);
                $("#<%=UC_clApplyRead3.ClientID%>").find("#btnEdit2").attr("disabled", false);
            }
        }

 //判斷可複製選擇人員
        function ChangeSelApplyUser4(theRadio) {
            if (theRadio == "") {
                $("#Source_ChoiceList3").css('visibility', 'hidden');
                $("#Source_ChoiceList3").attr("disabled", true);
                $("#<%=UC_clApplyRead4.ClientID%>").find("#btnEdit2").attr("disabled", true);
                return;
            }

            if (theRadio.value == "AllowALL") {
                $("#Source_ChoiceList3").css('visibility', 'hidden');
                $("#Source_ChoiceList3").attr("disabled", true);
                $("#<%=UC_clApplyRead4.ClientID%>").find("#btnEdit2").attr("disabled", true);
            }
            else {
                $("#Source_ChoiceList3").css('visibility', 'visible');
                $("#Source_ChoiceList3").attr("disabled", false);
                $("#<%=UC_clApplyRead4.ClientID%>").find("#btnEdit2").attr("disabled", false);
            }
        }

        //開啟文件連結對話視窗
        function wibtnDocRefLinkonclientclick(button, args) {

            var docID = $("#<%=hidDocid.ClientID%>").val();

            $uof.dialog.open2("~/DMS/DocStore/DocRefLink.aspx", button, "", 1000, 600, OpenDialogResultRefLink, { "docID": docID });

            args.set_cancel(true);
        }

        function OpenDialogResultRefLink(returnValue) {
            if (typeof (returnValue) != 'undefined' || returnValue != null || returnValue != null) {
                $("#<%=hidRefDoc.ClientID %>").val(returnValue);
                return true;
            }
            else {
                return false;
            }
        }

 //刪除以選擇的文件參考連結
        function DeleteRefDoc(docid) {
            var tmpLinkDocID;
            tmpLinkDocID = $("#<%=hidRefDoc.ClientID%>").val();

            var linksplit = tmpLinkDocID.split("$%");


            for (var i = 0 ; i < linksplit.length ; i++) {
                var s = linksplit[i].indexOf(docid + "$@");

                if (s > -1)
                    linksplit.splice(i, 1);
            }

            var tempLink;
            tempLink = linksplit.join("$%");
            $("#<%=hidRefDoc.ClientID%>").val(tempLink);
        }

        function refDocID() {
            return $("#<%=hidRefDoc.ClientID%>").val();
        }

        function OpenDialog(TaskID, FormId) {
            $uof.dialog.open2("~/WKF/ExternalModule/ExternalFormScript.aspx", "", "", 0, 0,
                                    function (returnValue) {
                                        //表單沒送出的話，將指給該表單的本文附件及本文內檔案設成DELETED
                                        var attachmentID = $("#<%= hidScriptFileGroupID.ClientID%>").val();
                                        if ((typeof (returnValue) == 'undefined' || returnValue == null || returnValue == "NeedPostBack") && attachmentID !== "") {
                                            var data = [attachmentID];
                                            var result = $uof.pageMethod.sync("DeleteTextScriptFile", data);
                                        }

                                        //表單關閉後，會先執行Button1 click事件，故後端還沒接到Dialog.GetReturnValue()的值，所以先用HiddenField接起來。
                                        $("#<%=hfTaskID.ClientID %>").val(returnValue)
                                        $('#<%= Button1.ClientID%>').click();
                                        return true;
                                    }
                                       , { "scriptId": TaskID, "formId": 'DMSApprove', "formVersionId": FormId });
            return false;

        }
        //開啟文件連結對話視窗
        function wibtnDocRefLink_ClientClick(button, args) {
            var docID = $("#<%=hidDocid.ClientID%>").val();
            var refID = '<%=SelectRefClientid%>';
            $uof.dialog.open2("~/DMS/DocStore/DocRefLink.aspx", button, "", 1000, 600, OpenDialogResultRefLink, { "docID": docID, "refID": refID });

            return false;

        }
        function OpenDialogResultRefLink(returnValue) {
            if (typeof (returnValue) != 'undefined' || returnValue != null) {
                $("#<%=hidRefDoc.ClientID %>").val(returnValue);
                return true;
            }
            else {
                return false;
            }
        }

        //文件類別Tree resize
        function resizeTree(X, Y) {
            var tree = $find("<%=treeClass.ClientID %>");
            if (tree != null && tree != 'undefined') {
                tree.get_element().style.height = Y - 28 + "px";
                tree.get_element().style.width = X - 126 + "px";
            }
        }
    </script>
    <table style="width: 100%" border="0">
        <tr>
            <td class="PopTableHeader">
                <div style="text-align: center">
                    <asp:Label ID="Label13" runat="server" Text="公佈文件" meta:resourcekey="Label13Resource1"></asp:Label>
                </div>
            </td>
        </tr>
    </table>

    <asp:Wizard ID="Wizard1" runat="server" ActiveStepIndex="0" BackColor="#F7F6F3" BorderColor="#999999"
        BorderWidth="1px" EnableTheming="True" BorderStyle="Solid"
        Height="92%" Width="100%" meta:resourcekey="Wizard1Resource1" OnNextButtonClick="Wizard1_NextButtonClick" OnSideBarButtonClick="Wizard1_SideBarButtonClick" OnActiveStepChanged="Wizard1_ActiveStepChanged">
        <StepStyle VerticalAlign="Top" BackColor="White" BorderColor="#E6E2D8" BorderStyle="Solid" BorderWidth="2px" />
        <SideBarStyle BackColor="White" VerticalAlign="Top" Width="120px" Font-Underline="False" ForeColor="Black" HorizontalAlign="Center" Wrap="false" />
        <NavigationButtonStyle BackColor="White" BorderColor="#C5BBAF" BorderStyle="Solid" BorderWidth="1px" ForeColor="#1C5E55" />
        <SideBarTemplate>
            <asp:DataList ID="SideBarList" runat="server" HorizontalAlign="Left" OnItemDataBound="SideBarList_ItemDataBound" meta:resourcekey="SideBarListResource1">
                <SelectedItemStyle Font-Bold="True" />
                <ItemTemplate>
                    &nbsp;&nbsp;<asp:Image ID="imgSideBar" runat="server" meta:resourcekey="imgSideBarResource1" />
                    <asp:LinkButton ID="SideBarButton" runat="server" ForeColor="Black" meta:resourcekey="SideBarButtonResource1"></asp:LinkButton>&nbsp;
                    <br />
                    <br />
                </ItemTemplate>
            </asp:DataList>
        </SideBarTemplate>
        <WizardSteps>
            <asp:WizardStep ID="WizardStep1" runat="server" Title="1.基本屬性" StepType="Start" meta:resourcekey="WizardStepResource1">
                <table style="width: 100%" class="PopTable" id="PropertyTable" runat="server">
                    <tr>
                        <td style="white-space: nowrap">
                            <asp:Label ID="Label7" runat="server" Text="文件名稱" meta:resourcekey="Label7Resource1"></asp:Label>
                        </td>
                        <td colspan="3">
                            <asp:TextBox ID="txtTitle" runat="server" Width="100%" meta:resourcekey="txtTitleResource1"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="white-space: nowrap">
                            <asp:Label ID="Label6" runat="server" Text="文件編號" meta:resourcekey="Label6Resource1"></asp:Label>
                        </td>
                        <td colspan="3">
                            <asp:TextBox ID="txtSerial" runat="server" Width="100%" meta:resourcekey="txtSerialResource1"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="white-space: nowrap">
                            <asp:Label ID="Label22" runat="server" Text="文件速別" meta:resourcekey="Label22Resource1"></asp:Label>
                        </td>
                        <td colspan="3">
                            <asp:RadioButton ID="rdoUrgencyNormal" runat="server" GroupName="Urgency" Text="普通"
                                Checked="true" meta:resourcekey="rdoUrgencyNormalResource1" />
                            <asp:RadioButton ID="rdoUrgencyHigh" runat="server" GroupName="Urgency" Text="急"
                                meta:resourcekey="rdoUrgencyHighResource1" />
                            <asp:RadioButton ID="rdoUrgencyExHigh" runat="server" GroupName="Urgency" Text="緊急"
                                meta:resourcekey="rdoUrgencyExHighResource1" />
                        </td>
                    </tr>
                    <tr>
                        <td style="white-space: nowrap">
                            <asp:Label ID="lblVersionMemo" runat="server" Text="版本備註" meta:resourcekey="Label12Resource1"></asp:Label>
                        </td>
                        <td colspan="3">
                            <asp:TextBox ID="txtVersionMemo" runat="server" Height="85px" TextMode="MultiLine"
                                Width="100%" meta:resourcekey="txtVersionMemoResource1"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="white-space: nowrap">
                            <asp:Label ID="Label8" runat="server" Text="發行單位" meta:resourcekey="Label8Resource1"></asp:Label>
                        </td>
                        <td style="text-align: left; vertical-align: top; width: 200px">
                            <uc1:UC_ChoiceList ID="UC_ChoiceList3" runat="server" ChioceType="Group" ShowMember="false"  ExpandToUser="false" />
                        </td>
                        <td>
                            <asp:Label ID="Label9" runat="server" Text="保管者" meta:resourcekey="Label9Resource1"></asp:Label>
                        </td>
                        <td style="text-align: left; vertical-align: top; width: 200px">
                            <uc1:UC_ChoiceList ID="UC_ChoiceList4" runat="server" ChioceType="User" ShowMember="false" ExpandToUser="false" />
                        </td>
                    </tr>
                    <tr>
                        <td style="white-space: nowrap">
                            <asp:Label ID="lblAuthDep" runat="server" Text="權責部門" meta:resourcekey="lblAuthDepResource1"></asp:Label>
                        </td>
                        <td style="text-align: left; vertical-align: top">
                            <uc2:UC_ChoiceList runat="server" ID="clAuthDep" ChioceType="Group" ShowMember="false" ExpandToUser="false" />
                        </td>
                        <td style="white-space: nowrap">
                            <asp:Label ID="Label21" runat="server" Text="適用部門" meta:resourcekey="Label21Resource1"></asp:Label>
                        </td>
                        <td style="text-align: left; vertical-align: top">
                            <uc1:UC_ChoiceList ID="clSuitableDep" runat="server" ChioceType="Group" ShowMember="false" ExpandToUser="false" />
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 104px; white-space: nowrap">
                            <asp:Label ID="Label10" runat="server" Text="摘要" meta:resourcekey="Label10Resource1"></asp:Label>
                        </td>
                        <td style="height: 104px" colspan="3">
                            <asp:TextBox ID="txtComment" runat="server" Height="100px" TextMode="MultiLine" Width="100%" meta:resourcekey="txtCommentResource1"></asp:TextBox>
                        </td>
                    </tr>

                    <tr>
                        <td style="white-space: nowrap">
                            <asp:Label ID="LabelKeyWord" runat="server" Text="關鍵字" meta:resourceKey="LabelKeyWordResource1"></asp:Label>
                        </td>
                        <td colspan="3">
                            <asp:TextBox ID="txtKeyWord" runat="server" Height="99px" meta:resourceKey="txtCommentResource1"
                                TextMode="MultiLine" Width="100%"></asp:TextBox>
                        </td>
                    </tr>
                </table>
                <asp:CheckBox ID="chkApply" runat="server" Text="允許申請副本" Visible="False" meta:resourcekey="chkApplyResource1" />
                <asp:RadioButtonList ID="RadioButtonList1" runat="server" RepeatDirection="Horizontal"
                    Width="200px" Visible="False" meta:resourcekey="RadioButtonList1Resource1">
                    <asp:ListItem Selected="True" meta:resourcekey="ListItemResource1" Text="電子檔"></asp:ListItem>
                    <asp:ListItem meta:resourcekey="ListItemResource2" Text="紙本"></asp:ListItem>
                </asp:RadioButtonList>
            </asp:WizardStep>
            <asp:WizardStep runat="server" Title="2.保存期限" StepType="Step" meta:resourcekey="WizardStepResource2">
                <table class="PopTable" style="width: 100%">
                    <tr>
                        <td rowspan="2" class="PopTableLeftTD" style="width: 23%;">
                            <asp:Label ID="Label4" runat="server" Text="生效設定" meta:resourcekey="Label4Resource1"></asp:Label></td>
                        <td colspan="2" class="PopTableRightTD">
                            <asp:RadioButton ID="rdoActive1" runat="server" Checked="True" Text="立即生效" GroupName="Active" meta:resourcekey="rdoActive1Resource1" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" class="PopTableRightTD" style="width: 63px; padding: 0px 0px 0px 0px">
                            <table >
                                <tr>
                                    <td  style="text-align: left">
                                        <asp:RadioButton ID="rdoActive2" runat="server" Text="生效日" GroupName="Active" meta:resourcekey="rdoActive2Resource1" />
                                        <telerik:RadDatePicker ID="RadDatePicker1" runat="server" meta:resourcekey="RadDatePicker1Resource1">
                                        </telerik:RadDatePicker>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3">
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:CheckBox ID="cbActiveEqualPublish" runat="server" Text="文件公佈時，公佈日晚於生效日，以公佈日為主" meta:resourcekey="cbActiveEqualPublishResource1" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td rowspan="2" class="PopTableLeftTD">
                            <asp:Label ID="Label5" runat="server" Text="過期設定" meta:resourcekey="Label5Resource1"></asp:Label></td>
                        <td colspan="2" class="PopTableRightTD">
                            <asp:RadioButton ID="rdoInvalid1" runat="server" Checked="True" Text="永不過期" GroupName="Invalid" meta:resourcekey="rdoInvalid1Resource1" />
                        </td>
                    </tr>
                    <tr>
                        <td class="PopTableRightTD" style="width: 80%; padding: 0px 0px 0px 0px">
                            <table style="width: 100%;">
                                <tr>
                                    <td class="PopTableRightTD" style="width: 63px; text-align: left;">
                                        <asp:RadioButton ID="rdoInvalid2" runat="server" Text="到期日" GroupName="Invalid" meta:resourcekey="rdoInvalid2Resource1" />
                                        <telerik:RadDatePicker ID="RadDatePicker2" runat="server" meta:resourcekey="RadDatePicker2Resource1">
                                        </telerik:RadDatePicker>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
                <asp:CustomValidator ID="CustomValidator6" runat="server" Display="Dynamic" ErrorMessage="保存期限設定錯誤" meta:resourcekey="CustomValidator6Resource1" Visible="false"></asp:CustomValidator>
            </asp:WizardStep>
            <asp:WizardStep runat="server" Title="3.機密設定" StepType="Step" meta:resourcekey="WizardStepResource3">
                <asp:UpdatePanel ID="UpdatePanel3" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <table class="PopTable">
                            <tr>
                                <td style="width: 100%; text-align: left;" colspan="2" class="PopTableRightTD">
                                    <asp:CheckBox ID="chkUseParentSet" runat="server" Text="使用父目錄的機密設定" AutoPostBack="True" OnCheckedChanged="chkUseParentSet_CheckedChanged" meta:resourcekey="chkUseParentSetResource1"></asp:CheckBox>
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 33px" class="PopTableLeftTD">
                                    <asp:Label ID="Label14" runat="server" Text="機密等級" meta:resourcekey="Label14Resource1"></asp:Label></td>
                                <td style="width: 458px; height: 33px" class="PopTableRightTD">&nbsp;<asp:DropDownList ID="dwnSecret" runat="server" Width="100px" meta:resourcekey="dwnSecretResource1">
                                    <asp:ListItem Value="Normal" meta:resourcekey="ListItemResource3" Text="一般"></asp:ListItem>
                                    <asp:ListItem Value="Secret" meta:resourcekey="ListItemResource4" Text="密"></asp:ListItem>
                                    <asp:ListItem Value="XSecret" meta:resourcekey="ListItemResource5" Text="機密"></asp:ListItem>
                                    <asp:ListItem Value="XXSecret" meta:resourcekey="ListItemResource6" Text="極機密"></asp:ListItem>
                                    <asp:ListItem Value="TopSecret" meta:resourcekey="ListItemResource7" Text="絕對機密"></asp:ListItem>
                                </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 38px" class="PopTableLeftTD">
                                    <asp:Label ID="Label15" runat="server" Text="共同編輯" meta:resourcekey="Label15Resource1"></asp:Label></td>
                                <td style="width: 458px; height: 38px" class="PopTableRightTD">
                                    <asp:CheckBox ID="chkCommonEdit" runat="server" Text="允許作者群共同編輯" meta:resourcekey="chkCommonEditResource1" />
                                </td>
                            </tr>
                            <tr id="OriginalManuscriptTR" runat="server">
                                <td class="PopTableLeftTD" runat="server">
                                    <asp:Label ID="Label16" runat="server" Text="原稿控制" meta:resourcekey="Label16Resource1"></asp:Label>
                                </td>
                                <td style="width: 458px" class="PopTableRightTD" runat="server">


                                    <table style="width: 100%">
                                        <tr>
                                            <td colspan="3" style="height: 24px">
                                                <asp:CheckBox ID="cbChangeToPDF" runat="server" Text="轉成PDF" Checked="True" meta:resourcekey="cbChangeToPDFResource1" AutoPostBack="True" OnCheckedChanged="cbChangeToPDF_CheckedChanged" /></td>
                                        </tr>
                                        <tr style="display:none;">
                                            <td>
                                                <asp:CheckBox ID="chkPrint" runat="server" Text="可列印" meta:resourcekey="chkPrintResource1" AutoPostBack="True" OnCheckedChanged="chkPrint_CheckedChanged" />
                                            </td>
                                            <td>
                                                <asp:RadioButtonList ID="rblApplyRead2" runat="server" CssClass="SizeS" CellPadding="0" CellSpacing="0" AutoPostBack="True" RepeatDirection="Horizontal" OnSelectedIndexChanged="rblApplyRead2_SelectedIndexChanged">
                                                    <asp:ListItem Selected="True" Value="AllowALL" meta:resourcekey="ListItemResource8" Text="允許全部人員"></asp:ListItem>
                                                    <asp:ListItem Value="AllowList" meta:resourcekey="ListItemResource13" Text="允許下列人員"></asp:ListItem>
                                                    <asp:ListItem Value="DenyList" meta:resourcekey="ListItemResource14" Text="不允許下列人員"></asp:ListItem>
                                                </asp:RadioButtonList>
                                            </td>
                                        </tr>
                                        <tr style="display:none;">
                                            <td colspan="3">&nbsp;<div id="Source_ChoiceList1" style="max-height: 100px; overflow: auto;" runat="server">
                                                <uc1:UC_ChoiceList ID="UC_clApplyRead2" runat="server"  ExpandToUser="false"
                                                    IsAllowEdit="true"></uc1:UC_ChoiceList>
                                            </div>
                                            </td>
                                        </tr>
                                        <tr>
                                        </tr>
                                        <tr style="display:none;">
                                            <td colspan="3" rowspan="1">
                                                <hr />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:CheckBox ID="chkSave" runat="server" Text="可另存" meta:resourcekey="chkSaveResource1" AutoPostBack="True" OnCheckedChanged="chkSave_CheckedChanged" />
                                            </td>
                                            <td>
                                                <asp:RadioButtonList ID="rblApplyRead3" runat="server" CssClass="SizeS" CellPadding="0" CellSpacing="0" AutoPostBack="True" RepeatDirection="Horizontal" OnSelectedIndexChanged="rblApplyRead2_SelectedIndexChanged">
                                                    <asp:ListItem Selected="True" Value="AllowALL" meta:resourcekey="ListItemResource8" Text="允許全部人員"></asp:ListItem>
                                                    <asp:ListItem Value="AllowList" meta:resourcekey="ListItemResource13" Text="允許下列人員"></asp:ListItem>
                                                    <asp:ListItem Value="DenyList" meta:resourcekey="ListItemResource14" Text="不允許下列人員"></asp:ListItem>
                                                </asp:RadioButtonList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="3">&nbsp;<div id="Source_ChoiceList2" style="max-height: 100px; overflow: auto;" runat="server">
                                                <uc1:UC_ChoiceList ID="UC_clApplyRead3" runat="server"  ExpandToUser="false"
                                                    IsAllowEdit="true"></uc1:UC_ChoiceList>
                                            </div>
                                            </td>
                                        </tr>
                                        <tr>
                                        </tr>
                                        <tr>
                                            <td colspan="3" rowspan="1">
                                                <hr />
                                            </td>
                                        </tr>
                                        <tr style="display:none;">
                                            <td>
                                                <asp:CheckBox ID="chkCopy" runat="server" Text="可複製" meta:resourcekey="chkCopyResource1" AutoPostBack="True" OnCheckedChanged="chkCopy_CheckedChanged" />
                                            </td>
                                            <td>
                                                <asp:RadioButtonList ID="rblApplyRead4" runat="server" CssClass="SizeS" CellPadding="0" CellSpacing="0" AutoPostBack="True" RepeatDirection="Horizontal" OnSelectedIndexChanged="rblApplyRead2_SelectedIndexChanged">
                                                    <asp:ListItem Selected="True" Value="AllowALL" meta:resourcekey="ListItemResource8" Text="允許全部人員"></asp:ListItem>
                                                    <asp:ListItem Value="AllowList" meta:resourcekey="ListItemResource13" Text="允許下列人員"></asp:ListItem>
                                                    <asp:ListItem Value="DenyList" meta:resourcekey="ListItemResource14" Text="不允許下列人員"></asp:ListItem>
                                                </asp:RadioButtonList>
                                            </td>
                                        </tr>
                                        <tr style="display:none;">
                                            <td colspan="3">&nbsp;<div id="Source_ChoiceList3" style="max-height: 100px; overflow: auto;" runat="server">
                                                <uc1:UC_ChoiceList ID="UC_clApplyRead4" runat="server"  ExpandToUser="false"
                                                    IsAllowEdit="true"></uc1:UC_ChoiceList>
                                            </div>
                                            </td>
                                        </tr>
                                        <tr style="display:none;">
                                            <td colspan="3">
                                                <hr />
                                            </td>
                                        </tr>
                                        <tr style="display:none;">
                                            <td colspan="3">
                                                <asp:CheckBox ID="cbAllowRelease" runat="server" Text="允許讀者產生UDoc" meta:reourcekey="cbAllowReleaseResource1" />
                                            </td>
                                        </tr>                                        
                                        <tr>
                                        </tr>
                                        <tr style="display:none;">
                                            <td colspan="3" rowspan="1">
                                                <hr />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="3">
                                                <asp:Label ID="lblSource" runat="server" Text="原始檔" meta:resourcekey="lblSourceResource1"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblSource2" runat="server" Text="下載權限" meta:resourcekey="lblSource2Resource1"></asp:Label>
                                            </td>
                                            <td>
                                                <asp:RadioButtonList ID="rblApplyRead5" runat="server" CssClass="SizeS" CellPadding="0" CellSpacing="0" AutoPostBack="True" RepeatDirection="Horizontal" OnSelectedIndexChanged="rblApplyRead2_SelectedIndexChanged">
                                                    <asp:ListItem Selected="True" Value="DenyALL" meta:resourcekey="ListItemResource11" Text="全部不允許"></asp:ListItem>
                                                    <asp:ListItem Value="AllowALL" meta:resourcekey="ListItemResource8" Text="允許全部人員"></asp:ListItem>
                                                    <asp:ListItem Value="AllowList" meta:resourcekey="ListItemResource13" Text="允許下列人員"></asp:ListItem>
                                                    <asp:ListItem Value="DenyList" meta:resourcekey="ListItemResource14" Text="不允許下列人員"></asp:ListItem>
                                                </asp:RadioButtonList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="3">&nbsp;<div id="Source_ChoiceList4" style="max-height: 100px; overflow: auto;" runat="server">
                                                <uc1:UC_ChoiceList ID="UC_clApplyRead5" runat="server"  ExpandToUser="false"
                                                    IsAllowEdit="true"></uc1:UC_ChoiceList>
                                            </div>
                                            </td>
                                        </tr>
                                        <tr>
                                        </tr>
                                    </table>
                                    <asp:CustomValidator ID="cvSourceNoChoice" runat="server" ErrorMessage='請選擇""人員'
                                        Visible="False" meta:resourcekey="cvSourceNoChoiceResource1"></asp:CustomValidator>
                                </td>
                            </tr>
                        </table>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </asp:WizardStep>
            <asp:WizardStep runat="server" StepType="Step" Title="4.調閱權限" meta:resourcekey="WizardStepResource4">
                <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                    <ContentTemplate>
                        <table class="PopTable">
                            <tr>
                                <td colspan="2" class="PopTableRightTD" style="height: 32px; text-align: left;">
                                    <asp:CheckBox ID="chkUseParentSetup" runat="server" AutoPostBack="True" OnCheckedChanged="chkUseParentSetup_CheckedChanged"
                                        Text="使用父目錄的調閱設定" meta:resourcekey="chkUseParentSetupResource1" />
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 23%; height: 138px; vertical-align: middle" class="PopTableLeftTD">
                                    <asp:Label ID="Label20" runat="server" Text="調閱申請" meta:resourcekey="Label20Resource1"></asp:Label>
                                </td>
                                <td style="width: 346px; height: 138px; vertical-align: top" class="PopTableRightTD">
                                    <asp:CheckBox ID="chkBorrow" runat="server" Text="允許調閱申請" Checked="True" AutoPostBack="True" OnCheckedChanged="chkBorrow_CheckedChanged" meta:resourcekey="chkBorrowResource1" />
                                    &nbsp;<br />
                                    <asp:RadioButtonList ID="rblApplyRead" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="rblApplyRead_SelectedIndexChanged" meta:resourcekey="rblApplyReadResource1">
                                        <asp:ListItem Selected="True" Value="AllowALL" meta:resourcekey="ListItemResource12" Text="允許全部人員"></asp:ListItem>
                                        <asp:ListItem Value="AllowList" meta:resourcekey="ListItemResource13" Text="允許下列人員"></asp:ListItem>
                                        <asp:ListItem Value="DenyList" meta:resourcekey="ListItemResource14" Text="不允許下列人員"></asp:ListItem>
                                    </asp:RadioButtonList>
                                    <div id="ChoiceList1" style="width: 100%; height: 80px; overflow: auto;">
                                        <uc1:UC_ChoiceList ID="UC_clApplyRead" runat="server" ExpandToUser="false" IsAllowEdit="true"  />
                                    </div>
                                    <asp:CustomValidator ID="CustomValidator8" runat="server" Display="Dynamic" ErrorMessage="請選擇調閱人員"
                                        Visible="False" meta:resourceKey="CustomValidator8Resource1"></asp:CustomValidator>
                                </td>
                            </tr>

                            <tr>

                                <td class="PopTableLeftTD" style="width: 23%;">
                                    <asp:Label ID="Label19" runat="server" Text="調閱流程：" meta:resourceKey="Label16Resource1"></asp:Label>
                                </td>
                                <td class="PopTableRightTD">
                                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                        <ContentTemplate>

                                            <asp:RadioButtonList ID="rblReadProcedure" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="rblReadProcedure_SelectedIndexChanged" meta:resourcekey="rblReadProcedureResource1">
                                                <asp:ListItem Value="DefaultFlow" Selected="True" meta:resourcekey="ListItemResource15" Text="簡易流程"></asp:ListItem>
                                                <asp:ListItem Value="WKFFlow" meta:resourcekey="ListItemResource16" Text="電子簽核"></asp:ListItem>
                                            </asp:RadioButtonList>&nbsp;&nbsp;<asp:Label ID="labApproveHelp" runat="server" ForeColor="Blue" Text="由下列任一「目錄管理者」審核通過即可公佈" meta:resourcekey="labApproveHelpResource1"></asp:Label><br />
                                            &nbsp;&nbsp;<asp:Label ID="lblPath" runat="server" Visible="False" ForeColor="Blue" meta:resourcekey="lblPathResource1"></asp:Label>
                                            <span id="WKFFlow">
                                                <asp:DropDownList ID="ddlUseWKFList" runat="server" Visible="False" Width="134px" meta:resourcekey="ddlUseWKFListResource1">
                                                </asp:DropDownList>
                                                <telerik:RadButton ID="wibtnSelectFlow" Text="觀看流程" runat="server" OnClientClicked="OnClientClicked"
                                                    meta:resourcekey="wibtnSelectFlowResource1">
                                                </telerik:RadButton>
                                            </span>
                                            <div id="ChoiceList2" style="width: 100%; height: 90px; overflow: auto;">
                                                <uc1:UC_ChoiceList ID="UC_clReadProcedure" runat="server" ExpandToUser="false" IsAllowEdit="false" />
                                            </div>

                                        </ContentTemplate>
                                    </asp:UpdatePanel>

                                </td>
                            </tr>

                        </table>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </asp:WizardStep>
            <asp:WizardStep runat="server" Title="5.文件類別" StepType="Step" meta:resourcekey="WizardStepResource5">
                <telerik:RadTreeView runat="server" ID="treeClass" CheckBoxes="true"
                    Height="100%"
                    OnClientNodeChecked="clientNodeChecked" meta:resourcekey="treeClassResource1">
                </telerik:RadTreeView>
                <input id="hidNodeTag" runat="server" style="width: 64px" type="hidden" value="DMSClass" />
                <input id="hidClickValue" type="hidden" runat="server" />
                <input id="hidIncludeParentClass" type="hidden" runat="server" />      
                <asp:Label ID="labClassName" runat="server" Text="文件類別" Visible="False" meta:resourcekey="labClassNameResource1"></asp:Label>
            </asp:WizardStep>
            <asp:WizardStep ID="WizardStep7" runat="server" Title="6.文件參考" meta:resourcekey="WizardStepResource7">
                <asp:UpdatePanel ID="UpdatePanel4" runat="server">
                    <ContentTemplate>
                        <table>
                            <tr>
                                <td>
                                    <telerik:RadButton ID="wibtnDocRefLink" runat="server" Text="加入參考文件" meta:resourcekey="wibtnDocRefLinkResource1"  OnClientClicked="wibtnDocRefLink_ClientClick" OnClick="wibtnDocRefLink_Click">
                                    </telerik:RadButton>
                                </td>
                                <td>
                                    &nbsp;&nbsp;&nbsp;
                                </td>
                                <td>
                                    <asp:CheckBox ID="cbRefLink" runat="server" Text="參考文件只限定於目前版本" meta:resourcekey="cbRefLinkResource1" />
                                    <asp:Label ID="Label18" runat="server" Text="(不勾選則表示參考文件不受版本限制)" ForeColor="Blue" meta:resourcekey="Label18Resource1"></asp:Label>
                                </td>
                            </tr>
                        </table>
                        
                        <asp:HiddenField ID="hidRefDoc" runat="server" />
                        <Fast:Grid ID="gridDocRef" runat="server" AllowPaging="True" AllowSorting="True"
                            AutoGenerateCheckBoxColumn="False" AutoGenerateColumns="False"
                            DataKeyOnClientWithCheckBox="False" EnhancePager="True"
                            OnRowCommand="gridDocRef_RowCommand"
                            OnPageIndexChanging="gridDocRef_PageIndexChanging" OnRowDataBound="gridDocRef_RowDataBound" Width="100%" OnSorting="gridDocRef_Sorting"  DefaultSortDirection="Ascending" EmptyDataText="No data found" KeepSelectedRows="False" meta:resourcekey="gridDocRefResource1"  >
                            <EnhancePagerSettings ShowHeaderPager="True" />
                            <ExportExcelSettings AllowExportToExcel="False" />
                            <Columns>
                                <asp:TemplateField HeaderText="狀態" SortExpression="SYS_STATUS" meta:resourcekey="TemplateFieldResource6">
                                        <ItemTemplate>
                                            <asp:Label ID="lblStatus" runat="server" Text='<%# Bind("DOC_STATUS") %>' meta:resourcekey="lblStatusResource1"></asp:Label>
                                        </ItemTemplate>
                                        <HeaderStyle Wrap="False" />
                                        <ItemStyle Wrap="False" />
                                    </asp:TemplateField>
                                <asp:TemplateField HeaderText="文件名稱" meta:resourceKey="TemplateFieldResource1" SortExpression="DOC_NAME">
                                    <ItemTemplate>
                                        <span style="word-break: break-all; width: 30%;">
                                            <asp:Image ID="imgDocIcon" runat="server" ImageUrl="~/DMS/images/icon/unknown.gif" meta:resourcekey="imgDocIconResource1"></asp:Image>
                                            <asp:Label ID="labDLFile" runat="server" Text='<%# Bind("DOC_NAME") %>' meta:resourceKey="labDLFileResource1"></asp:Label>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="保管者" meta:resourcekey="TemplateFieldResource5">
                                        <ItemTemplate>
                                            <uc1:UC_ChoiceList runat="server" ID="UC_ChoiceList1" IsAllowEdit="false"></uc1:UC_ChoiceList>
                                        </ItemTemplate>
                                        <HeaderStyle Wrap="False" Width="25%" />
                                    </asp:TemplateField>   
                                <asp:TemplateField HeaderText="功能" meta:resourceKey="TemplateFieldResource2">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lbtnRemove" runat="server" CommandName="DelRefDoc" meta:resourceKey="lbtnRemoveResource1" Text="移除"></asp:LinkButton>&nbsp;
                                        <!--Lala: 因考量當參考文件加入當下版本顯示資訊會影響，先把所有資訊隱藏-->                                        
                                        <asp:LinkButton ID="lbtnInfo" runat="server" Visible="False" meta:resourceKey="lbtnInfoResource1" Text="資訊"></asp:LinkButton>
                                        <asp:LinkButton ID="lbtnUpdate" runat="server" Text="更新" CommandName="DocUpdate" CommandArgument='<%# Eval("DOC_ID") %>' Visible ="False" meta:resourcekey="lbtnUpdateResource1"></asp:LinkButton>                                  
                                    </ItemTemplate>
                                    <HeaderStyle Wrap="False" Width="7%" />
                                    <ItemStyle Wrap="False"/>
                                </asp:TemplateField>
                            </Columns>
                        </Fast:Grid>
                        <asp:HiddenField ID="hideSelectRef" runat="server" />
                    </ContentTemplate>
                </asp:UpdatePanel>
            </asp:WizardStep>
            <asp:WizardStep runat="server" Title="7.檔案上傳" StepType="Finish" meta:resourcekey="WizardStepResource6">
                <table style="width: 100%" class="PopTable">
                    <tr>
                        <td style="white-space: nowrap; width: 120px;">
                            <asp:Label ID="Label3" runat="server" Text="目前實際版本" meta:resourcekey="Label3Resource1"></asp:Label>
                        </td>
                        <td style="white-space: nowrap;">
                            <asp:Label ID="lblActualVer" runat="server" meta:resourcekey="lblActualVerResource1"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td style="white-space: nowrap; width: 120px;">
                            <asp:Label ID="Label17" runat="server" Text="發佈後實際版本" meta:resourcekey="Label17Resource1"></asp:Label></td>
                        <td  runat="server" id="tdhandVer" style="white-space: nowrap;">
                            <asp:TextBox ID="txtHandVer" runat="server" MaxLength="15" ForeColor="Red" meta:resourcekey="txtHandVerResource1"></asp:TextBox>
                            <asp:CustomValidator ID="CustomValidator9" runat="server" Display="Dynamic" ErrorMessage="請輸入版本" meta:resourcekey="RequiredFieldValidator1Resource1" Visible="false"></asp:CustomValidator>
                        </td>
                        <td runat="server" id="tdinitialVer">
                            <table runat="server">
                                <tr>
                                    <td>
                                        <telerik:RadNumericTextBox ID="rntxtBitInteger" runat="server" Width="35px" DataType="System.Int32" NumberFormat-DecimalDigits="0" NumberFormat-AllowRounding="false" MaxLength="2">
                                            <NegativeStyle Resize="None"></NegativeStyle>
                                            <NumberFormat DecimalDigits="0" ZeroPattern="n" AllowRounding="False" GroupSeparator=""></NumberFormat>
                                            <EmptyMessageStyle Resize="None"></EmptyMessageStyle>
                                            <ReadOnlyStyle Resize="None"></ReadOnlyStyle>
                                            <FocusedStyle Resize="None"></FocusedStyle>
                                            <DisabledStyle Resize="None"></DisabledStyle>
                                            <InvalidStyle Resize="None"></InvalidStyle>
                                            <HoveredStyle Resize="None"></HoveredStyle>
                                            <EnabledStyle Resize="None"></EnabledStyle>
                                        </telerik:RadNumericTextBox>
                                        <asp:Label ID="lblDecimalPoint" runat="server" Text="." Style="vertical-align: bottom"></asp:Label>
                                        <telerik:RadNumericTextBox ID="rntxtDecimalPlaces" runat="server" Width="35px" DataType="System.Int32" NumberFormat-DecimalDigits="0" NumberFormat-AllowRounding="false" MaxLength="2">
                                            <NegativeStyle Resize="None"></NegativeStyle>
                                            <NumberFormat DecimalDigits="0" ZeroPattern="n" AllowRounding="False" GroupSeparator=""></NumberFormat>
                                            <EmptyMessageStyle Resize="None"></EmptyMessageStyle>
                                            <ReadOnlyStyle Resize="None"></ReadOnlyStyle>
                                            <FocusedStyle Resize="None"></FocusedStyle>
                                            <DisabledStyle Resize="None"></DisabledStyle>
                                            <InvalidStyle Resize="None"></InvalidStyle>
                                            <HoveredStyle Resize="None"></HoveredStyle>
                                            <EnabledStyle Resize="None"></EnabledStyle>
                                        </telerik:RadNumericTextBox>
                                    </td>
                                    <td style="padding-left: 5px;">
                                        <asp:CustomValidator ID="cvInitialVerError" runat="server" ErrorMessage="小數位不可大於等於版號進號小數設定值" Display="Dynamic" meta:resourcekey="cvInitialVerErrorResource1"></asp:CustomValidator>
                                        <asp:CustomValidator ID="cvInitialVerError2" runat="server" ErrorMessage="不可為0.0版" Display="Dynamic" meta:resourcekey="cvInitialVerError2Resource1" ></asp:CustomValidator>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr style="display: none;">
                        <td style="white-space: nowrap; width: 120px;">
                            <asp:Label ID="Label1" runat="server" Text="目前系統版本：" meta:resourcekey="Label1Resource1"></asp:Label>
                        </td>
                        <td style="white-space: nowrap;">
                            <asp:Label ID="lblSysActualVer" runat="server" meta:resourcekey="lblSysActualVerResource1"></asp:Label>
                        </td>
                    </tr>
                    <tr style="display: none;">
                        <td style="white-space: nowrap; width: 120px;">
                            <asp:Label ID="Label2" runat="server" Text="發佈後系統版本：" meta:resourcekey="Label2Resource1"></asp:Label>
                        </td>
                        <td style="white-space: nowrap;">
                            <asp:Label ID="lblSysNewVer" runat="server" ForeColor="Red" meta:resourcekey="lblSysNewVerResource1"></asp:Label>
                        </td>
                    </tr>
                </table>
                <br />
                <asp:Panel ID="pnlUploadFileDoc" runat="server" meta:resourcekey="pnlUploadFileDocResource1">
                    <table class="PopTable">
                        <tr>
                            <td style="white-space: nowrap; width: 120px;">
                                <asp:Label ID="Label11" runat="server" Text="檔案" meta:resourcekey="Label11Resource1"></asp:Label>
                            </td>
                            <td>
                                <uc1:UC_FileCenter runat="server" ID="UC_FileCenter" ProxyEnabled="true" />
                            </td>
                        </tr>

                    </table>
                </asp:Panel>
                <asp:Panel ID="pnlUploadContentDoc" runat="server" Width="99.9%" meta:resourcekey="pnlUploadContentDocResource1">
                    <uc2:UC_HtmlEditor ID="UC_HtmlEditor1" runat="server" Width="100%" Height="650px" ProxyEnabled="true" EnableInsertDMS="true" />
                </asp:Panel>
                <asp:CustomValidator ID="CustomValidator1" runat="server" Display="Dynamic" ErrorMessage="請上傳檔案" meta:resourcekey="CustomValidator1Resource1" Visible="False"></asp:CustomValidator>
                <asp:CustomValidator ID="CustomValidator2" runat="server" Display="Dynamic" ErrorMessage="公佈失敗" meta:resourcekey="CustomValidator2Resource1" Visible="False"></asp:CustomValidator>
                <asp:CustomValidator ID="CustomValidator3" runat="server" Display="Dynamic" ErrorMessage="文章不是簽出狀態,不可執行發佈" meta:resourcekey="CustomValidator3Resource1" Visible="False"></asp:CustomValidator>
                <asp:CustomValidator ID="CustomValidator4" runat="server" Display="Dynamic" ErrorMessage="已存在此手動版本" meta:resourcekey="CustomValidator4Resource1" Visible="False"></asp:CustomValidator>
                <asp:CustomValidator ID="CustomValidator5" runat="server" Display="Dynamic" ErrorMessage="目前無法公佈! 檔案不存在 或 檔案同步進行中" meta:resourcekey="CustomValidator5Resource1" Visible="False"></asp:CustomValidator>
                <asp:CustomValidator ID="CustomValidator7" runat="server" Display="Dynamic" ErrorMessage="原稿控制已取消, 無法轉成PDF" meta:resourcekey="CustomValidator7Resource1" Visible="False"></asp:CustomValidator>
            </asp:WizardStep>
        </WizardSteps>
        <SideBarButtonStyle ForeColor="White" />
        <HeaderStyle BackColor="Silver" BorderColor="#E6E2D8" BorderStyle="Solid" BorderWidth="2px" Font-Bold="False" ForeColor="Black" HorizontalAlign="Center" />
        <StartNavigationTemplate>
        </StartNavigationTemplate>
        <StepNavigationTemplate>
        </StepNavigationTemplate>
        <FinishNavigationTemplate>
        </FinishNavigationTemplate>
    </asp:Wizard>

    <asp:Label ID="lblUpload" runat="server" meta:resourcekey="lblUploadResource1" Text="請上傳檔案" Visible="False"></asp:Label>
    <asp:Label ID="lblPublishError" runat="server" meta:resourcekey="lblPublishErrorResource1" Text="公佈失敗" Visible="False"></asp:Label>
    <asp:Label ID="lblStatusError" runat="server" meta:resourcekey="lblStatusErrorResource1" Text="文章不是簽出狀態,不可執行發佈" Visible="False"></asp:Label>
    <asp:Label ID="lblVersionExist" runat="server" meta:resourcekey="lblVersionExistResource1" Text="已存在此手動版本" Visible="False"></asp:Label>
    <asp:Label ID="lblCannotPublish" runat="server" meta:resourcekey="lblCannotPublishResource1" Text="目前無法公佈! 檔案不存在 或 檔案同步進行中" Visible="False"></asp:Label>
    <asp:Label ID="lblPDFError" runat="server" Text="原稿控制已取消, 無法轉成PDF" Visible="False" meta:resourcekey="lblPDFErrorResource1"></asp:Label>
    <asp:Label ID="labDefApprove" runat="server" Text="由下列任一「目錄管理者」審核通過即可公佈" Visible="False" meta:resourcekey="labDefApproveResource1"></asp:Label>
    <asp:Label ID="labUseWKF" runat="server" Text="使用電子簽核，請選擇簽核流程" Visible="False" meta:resourcekey="labUseWKFResource1"></asp:Label>
    <asp:Label ID="lanNoApprove" runat="server" Text="此目錄無設定目錄管理者，無法進行審核設定" Visible="False" meta:resourcekey="lanNoApproveResource1"></asp:Label>
    <asp:Label ID="lblFolderPath" runat="server" Text="引用目錄：" Visible="False" meta:resourcekey="lblFolderPathResource1"></asp:Label>
    <asp:CheckBox ID="chkBORROW_APPLY" runat="server" Text="允許調閱申請" meta:resourcekey="chkBORROW_APPLYResource1" Visible="False" />
    <asp:Label ID="labDocStore" runat="server" meta:resourcekey="labDocStoreResource1" Text="文件庫" Visible="False"></asp:Label>
    <asp:Label ID="lblNoWKFFlow" runat="server" Text="電子簽核沒有流程，請選擇簡易流程" Visible="False" meta:resourcekey="lblNoWKFFlowResource1"></asp:Label>
    <asp:HiddenField ID="hidFolderID" runat="server"></asp:HiddenField>
    <input id="hidDocid" runat="server" style="width: 15px; height: 14px" type="hidden" /><input id="hdStatus" runat="server" type="hidden" /><asp:HiddenField ID="hdUploadState" runat="server"></asp:HiddenField>
    <asp:Label ID="lblSerialRepeat" runat="server" Text="文件編號已被使用" Visible="False" meta:resourcekey="lblSerialRepeatResource1"></asp:Label>
    <asp:Label ID="lblNameRepeat" runat="server" Text="文件名稱在此目錄已被使用" Visible="False" meta:resourcekey="lblNameRepeatResource1"></asp:Label>
    <input id="hdApproveRMID" runat="server" type="hidden" />
    <input id="lblDocId" runat="server" type="hidden" />
    <input id="lblApproveType" runat="server" type="hidden" />
    <input id="lblStatus" runat="server" type="hidden" />
    <input id="lblDocname" runat="server" type="hidden" />
    <input id="lblNeedApprove" runat="server" type="hidden" />
    <input id="lblSecretRank" runat="server" type="hidden" />
    <input id="lblMemo" runat="server" type="hidden" />
    <input id="lblKeyWord" runat="server" type="hidden" />
    <input id="lblFilelength" runat="server" type="hidden" />
    <input id="lblAuthor" runat="server" type="hidden" />
    <input id="lblVersion" runat="server" type="hidden" />
    <input id="lblFileName" runat="server" type="hidden" />
    <input id="lblCreateTime" runat="server" type="hidden" />
    <input id="lblFolderName" runat="server" type="hidden" />
    <input id="hdVersionMemo" runat="server" type="hidden" />
    <input id="hdIsUpLoad" runat="server" type="hidden" />
    <input id="hdDocSerial" runat="server" type="hidden" />
    <input id="hdSelectWKF" runat="server" type="hidden" />
    <input id="hdFileID" runat="server" type="hidden" />
    <input id="hdVER_MANUAL_CONTROL" runat="server" type="hidden" />
    <asp:CustomValidator ID="cvPropertyLimit" runat="server" ErrorMessage="不可空白或沒選人員" Display="Dynamic" Visible="False" meta:resourcekey="cvPropertyLimitResource1"></asp:CustomValidator>
    <asp:CustomValidator ID="cvPropertyLimit2" runat="server" ErrorMessage="必須勾選文件類別" Display="Dynamic" Visible="False" meta:resourcekey="cvPropertyLimit2Resource1"></asp:CustomValidator>
    <asp:CustomValidator ID="cvPropertyLimit3" runat="server" ErrorMessage="必須加入參考文件" Display="Dynamic" Visible="False" meta:resourcekey="cvPropertyLimit3Resource1"></asp:CustomValidator>
    <asp:Label ID="lblSelectMsg" runat="server" Text="請選擇" Visible="False" meta:resourcekey="lblSelectMsgResource1"></asp:Label>
    <input id="Hidden1" runat="server" type="hidden" />
    <asp:Button ID="Button1" runat="server" Text="Button" Style="display: none;" OnClick="Button1_Click" meta:resourcekey="Button1Resource1" />
    <asp:HiddenField ID="hfstatus" runat="server" />
    <asp:HiddenField ID="hfTaskID" runat="server" />
    <input id="hdFormId" runat="server" type="hidden" />
    <asp:HiddenField runat="server" ID="hdUserGuid"></asp:HiddenField>
    <asp:Label ID="lblNoExtension" runat="server" Text="無法上傳無附檔名的檔案" Visible="False" meta:resourcekey="lblNoExtensionResource1"></asp:Label>
    <input id="hdSourceControl" runat="server" type="hidden" />
    <input id="hdSecretDefine" runat="server" type="hidden" />
    <input id="hdFolderID" runat="server" type="hidden" />
    <input id="hdSource" runat="server" type="hidden" />
    <input id="hdSaveRow" runat="server" type="hidden" />
    <input id="hdPrintRow" runat="server" type="hidden" />
    <input id="hdCopyRow" runat="server" type="hidden" />
    <input id="hdLend" runat="server" type="hidden" />
    <input id="hdRef" runat="server" type="hidden" />
    <input id="hdDocName" runat="server" type="hidden" />
    <asp:Label ID="lblDoubleSend" runat="server" Text="此份文件已發送過發佈申請單{0}。" Visible="False" meta:resourcekey="lblDoubleSendResource1"></asp:Label>
    <asp:Label ID="lblAutoSerial" runat="server" Text="＊文件自動編號" Visible="False" meta:resourcekey="lblAutoSerialResource1"></asp:Label>
    <asp:Label ID="lblFullSerial" runat="server" Text="自動編號已達上限，請通知目錄管理員增加編號最大上限" Visible="False" meta:resourcekey="lblFullSerialResource1"></asp:Label>
    <asp:HiddenField ID="hfIsSkipApprove" runat="server" />
    <asp:Label ID="lblUploadContentDoc" runat="server" Text="7.編輯本文" Visible="False" meta:resourcekey="lblUploadContentDocResource1"></asp:Label>
    <asp:Label ID="lblNeedDocName" runat="server" Text="請輸入文件標題" Visible="False" meta:resourcekey="lblNeedDocNameResource1"></asp:Label>
    <asp:Label ID="lblNeedDocContent" runat="server" Text="請輸入文件內容" Visible="False" meta:resourcekey="lblNeedDocContentResource1"></asp:Label>
    <asp:Label ID="lblCheckIn" runat="server" Text="存回" Visible="False" meta:resourcekey="lblCheckInResource1"></asp:Label>
    <asp:Label ID="lblPublish" runat="server" Text="公佈" Visible="False" meta:resourcekey="lblPublishResource1"></asp:Label>
    <asp:Label ID="lblCheckinError" runat="server" meta:resourcekey="lblCheckinErrorResource1" Text="存回失敗" Visible="False"></asp:Label>
    <asp:Label ID="lblWKFError" runat="server" Text="文件公佈申請單送出錯誤，無法公佈文件，請關閉本視窗重新公佈" Visible="False" meta:resourcekey="lblWKFErrorResource1"></asp:Label>
    <asp:Label ID="lblDocLink" runat="server" Text="文件連結" Visible="False" meta:resourcekey="lblDocLinkResource1"></asp:Label>
    <asp:Label ID="lblHistory" runat="server" Text="觀看版本歷程" Visible="False" meta:resourcekey="lblHistoryResource1"></asp:Label>
    <asp:Label ID="lblRef" runat="server" Text="觀看參考文件" Visible="False" meta:resourcekey="lblRefResource1"></asp:Label>
    <asp:Label ID="lblInfo" runat="server" Text="文件資訊" Visible="False" meta:resourcekey="lblInfoResource1"></asp:Label>
    <asp:HiddenField ID="hdFileName" runat="server" />
    <asp:HiddenField ID="hdContentAttachFileID" runat="server" />
    <asp:HiddenField ID="hfDocSerial" runat="server" />
     <asp:Label ID="labNoActive" runat="server" Text="未生效" Visible="False" meta:resourcekey="labNoActiveResource1"></asp:Label>
    <asp:Label ID="lblApproval" runat="server" Text="審核中" Visible="False" meta:resourcekey="lblApprovalResource1"></asp:Label>
    <asp:Label ID="lblPublishStatus" runat="server" Text="已公佈" Visible="False" meta:resourcekey="Label12Resource2"></asp:Label>
    <asp:Label ID="lblInactive" runat="server" Text="已失效" Visible="False" meta:resourcekey="lblInactiveResource1"></asp:Label>
    <asp:Label ID="lblVoid" runat="server" Text="已作廢" Visible="False" meta:resourcekey="lblVoidResource1"></asp:Label>
    <asp:Label ID="lblUpdating" runat="server" Text="改版中" Visible="False" meta:resourcekey="lblUpdatingResource1"></asp:Label>
    <asp:Label ID="lblVioding" runat="server" Text="(作廢審核中)" Visible="False" meta:resourcekey="lblViodingResource1"></asp:Label>
     <asp:Label ID="lblOldVer" runat="server" Text="舊版本" Visible="False" meta:resourcekey="lblOldVerResource1"></asp:Label>
    <asp:Label ID="lblReAct" runat="server" Text="已上架" Visible="False" meta:resourcekey="lblReActResource1"></asp:Label>
    <asp:Label ID="labDocDeny" runat="server" Text="發佈拒絕" Visible="False" meta:resourcekey="labDocDenyResource1"></asp:Label>
    <asp:Label ID="lblDraft" runat="server" Text="草稿" Visible="False" meta:resourcekey="lblDraftResource1"></asp:Label>
    <asp:Label ID="lblCheckInStatus" runat="server" Text="已存回" Visible="False" meta:resourcekey="lblCheckInStatusResource1"></asp:Label>
    <asp:Label ID="lblCheckOut" runat="server" Text="已取出" Visible="False" meta:resourcekey="lblCheckOutResource1"></asp:Label>
    <asp:Label ID="lblTempInact" runat="server" Text="已下架" Visible="False" meta:resourcekey="lblTempInactResource1"></asp:Label>
    <asp:Label ID="lblChoiceBtntxt" runat="server" Text="選取部門" Visible="False" meta:resourcekey="lblChoiceBtntxtResource1"></asp:Label>
    <asp:Label ID="lblcvNonEmpty" runat="server" Text="不可空白" Visible="False" meta:resourcekey="lblcvNonEmptyResource1"></asp:Label>
    <asp:Label ID="lblDefaultVerDecimalPlaces" runat="server" Text=".0" Visible="false"></asp:Label> 
    <asp:HiddenField ID="hidPublishVer" runat="server" />
    <asp:HiddenField ID="hfCurrentUser" runat="server" />
    <asp:HiddenField ID="hidScriptFileGroupID" runat="server" />
</asp:Content>

