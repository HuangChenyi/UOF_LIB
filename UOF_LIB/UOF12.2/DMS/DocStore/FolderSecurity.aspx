<%@ Page Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" Inherits="DMS_DocStore_FolderSecurity" Title="目錄安全" Culture="auto" UICulture="auto" meta:resourcekey="PageResource1" CodeBehind="FolderSecurity.aspx.cs" %>

<%@ Register Src="../../Common/ChoiceCenter/UC_ChoiceList.ascx" TagName="UC_ChoiceList" TagPrefix="uc1" %>
<%@ Register Src="../../Common/ChoiceCenter/UC_ChoiceOnce.ascx" TagName="UC_ChoiceOnce" TagPrefix="uc2" %>
<%@ Register Src="../../Common/ChoiceCenter/UC_BtnChoiceOnce.ascx" TagName="UC_BtnChoiceOnce" TagPrefix="uc3" %>
<%@ Register Src="~/Common/FileCenter/V3/UC_FileCenter.ascx" TagPrefix="uc1" TagName="UC_FileCenter" %>

<%@ Register Src="../../Common/HtmlEditor/UC_HtmlEditor.ascx" TagName="UC_HtmlEditor" TagPrefix="uc5" %>
<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Fast" %>
<%@ Register Src="~/Common/HtmlEditor/UC_HtmlEditor.ascx" TagPrefix="uc1" TagName="UC_HtmlEditor" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">    
    <script id="igClientScript" type="text/javascript">

        function wibtnWKFFlowInfo_Click(oButton, oEvent) {
            var ddlUseWKFList = $("#<%=ddlUseWKFList.ClientID %> option:selected");
            var FormVersionId = ddlUseWKFList.val().split(',')[0];

            $uof.dialog.open2("~/DMS/DocStore/WKFFlowInfo.aspx", oButton, "", 500, 250,
                                    function (returnValue) {
                                        return false;
                                    }
                                    , { "formversionid": FormVersionId });
            oEvent.set_cancel(true);
        }

        function wibtnWKFFlowInfo2_Click(oButton, oEvent) {
            var ddlUseWKFList2 = $("#<%=ddlUseWKFList2.ClientID %> option:selected");
            var FormVersionId = ddlUseWKFList2.val().split(',')[0];

            $uof.dialog.open2("~/DMS/DocStore/WKFFlowInfo.aspx", oButton, "", 500, 250,
                        function (returnValue) {
                            return false;
                        }
                        , { "formversionid": FormVersionId });
            oEvent.set_cancel(true);

        }

        function wibtnWKFFlowInfoEx2_Click(oButton, oEvent) {
            var ddlUseWKFListEx2 = $("#<%=ddlUseWKFListEx2.ClientID %> option:selected");
            var FormVersionId = ddlUseWKFListEx2.val().split(',')[0];

            $uof.dialog.open2("~/DMS/DocStore/WKFFlowInfo.aspx", oButton, "", 500, 250,
            function (returnValue) {
                return false;
            }
            , { "formversionid": FormVersionId });
            oEvent.set_cancel(true);
        }

        function Button1Click() {
            if (CheckddlUseWKFListCount2())
                return DeleteChildDocData();
        }

        function Button1Click2() {
            if (CheckddlUseWKFListCount())
                return DeleteChildDocData();
        }

        function CheckddlUseWKFListCount() {
            var ddlUseWKFList = $("#<%=ddlUseWKFList.ClientID %> option");

            if (ddlUseWKFList.length > 0) {
                if (ddlUseWKFList.size() == 0) {
                    alert('<%=lblNoWKFFlow.Text %>');
                    return false;
                }
                return true;
            }
        }
        function CheckddlUseWKFListCount2() {
            var ddlUseWKFList = $("#<%=ddlUseWKFList2.ClientID %> option");

            if (ddlUseWKFList.length > 0) {
                if (ddlUseWKFList.size() == 0) {
                    alert('<%=lblNoWKFFlow.Text %>');
                    return false;
                }
                return true;
            }
        }
        function CheckddlUseWKFListEx2Count(oEvent) {
            var ddlUseWKFListEx2 = $("#<%=ddlUseWKFListEx2.ClientID %> option");

            if (ddlUseWKFListEx2.length > 0) {
                if (ddlUseWKFListEx2.size() == 0) {
                    alert('<%=lblNoWKFFlow.Text %>');
                    return false;
                }
                return true;
            }
        }
    </script>

    <script id="FolderSecurityjs" type="text/javascript">

        function btnWKFAddNew_Click(sender, args) {
            var FormID = 'DMSApprove';
            $uof.dialog.open2("~/WKF/ExternalModule/DesignFormFlow.aspx", sender, "", 1024, 800,
            function (returnValue) {
                return true;
            }
            , { "formID": FormID });

            args.set_cancel(true);
        }

        function btnWKFAddNewEx2_Click(oButton, oEvent) {
            var FormID = 'DMSVoid';

            $uof.dialog.open2("~/WKF/ExternalModule/DesignFormFlow.aspx", oButton, "", 1024, 800,
            function (returnValue) {
                return true;
            }
            , { "formID": FormID });
            oEvent.set_cancel(true);
        }

        function wibtnSelectFlow_Click(oButton, oEvent) {
            var ddlUseWKFList = $("#<%=ddlUseWKFList.ClientID %> option:selected");
            var FormVersionId = ddlUseWKFList.val().split(',')[0];
            var FlowID = ddlUseWKFList.val().split(',')[1]
            var CanEdit = ddlUseWKFList.val().split(',')[2];

            if (CanEdit == "true") {
                $uof.dialog.open2("~/WKF/ExternalModule/DesignFormFlow.aspx", oButton, "", 1024, 800,
            function (returnValue) {
                return false;
            }
            , { "formVersionId": FormVersionId });
            }
            else {
                $uof.dialog.open2("~/WKF/Browse/ViewMasterFlow.aspx", oButton, '<%=lblMaintainFlow.Text%>', 800, 650,
                function (returnValue) {
                    return false;
                }
                , { "formVersionId": FormVersionId, "flowId": FlowID });
            }
            oEvent.set_cancel(true);
        }

        function wibtnSelectFlowEx2_Click(oButton, oEvent) {

            var ddlUseWKFListEx2 = $("#<%=ddlUseWKFListEx2.ClientID %> option:selected");
            var FormVersionId = ddlUseWKFListEx2.val().split(',')[0];
            var FlowID = ddlUseWKFListEx2.val().split(',')[1];
            var CanEdit = ddlUseWKFListEx2.val().split(',')[2];

            if (CanEdit == "true") {
                $uof.dialog.open2("~/WKF/ExternalModule/DesignFormFlow.aspx", oButton, "", 1024, 800,
                function (returnValue) {
                    return false;
                }
                , { "formVersionId": FormVersionId });
            }
            else {
                $uof.dialog.open2("~/WKF/Browse/ViewMasterFlow.aspx", oButton, '<%=lblMaintainFlow.Text%>', 800, 650,
                function (returnValue) {
                    return false;
                }
                , { "formVersionId": FormVersionId, "flowId": FlowID });
            }
            oEvent.set_cancel(true);
        }


        function btnWKFAddNew2_Click(oButton, oEvent) {
            var FormID = 'DMSLend';
            $uof.dialog.open2("~/WKF/ExternalModule/DesignFormFlow.aspx", oButton, "", 1024, 800,
                function (returnValue) {
                    return true;
                }
                , { "formID": FormID });
            oEvent.set_cancel(true);
        }

        function wibtnSelectFlow2_Click(oButton, oEvent) {
            var ddlUseWKFList2 = $("#<%=ddlUseWKFList2.ClientID %> option:selected");
            var FormVersionId = ddlUseWKFList2.val().split(',')[0];
            var FlowID = ddlUseWKFList2.val().split(',')[1]
            var CanEdit = ddlUseWKFList2.val().split(',')[2];

            if (CanEdit == "true") {
                $uof.dialog.open2("~/WKF/ExternalModule/DesignFormFlow.aspx", oButton, "", 1024, 800,
                function (returnValue) {
                    return false;
                }
                , { "formVersionId": FormVersionId });
            }
            else {
                $uof.dialog.open2("~/WKF/Browse/ViewMasterFlow.aspx", oButton, "", 800, 650,
                                    function (returnValue) {
                                        return false;
                                    }
                                    , { "formVersionId": FormVersionId, "flowId": FlowID });
            }
            oEvent.set_cancel(true);
        }

        function ChangeText() {
            var ddlUseWKFList2 = $("#<%=ddlUseWKFList2.ClientID %> option:selected");
            var CanEdit = ddlUseWKFList2.val().split(',')[2];

            if (CanEdit == "true") {
                $("#<%=wibtnSelectFlow2.ClientID %>").val('<%=lblEditForm.Text %>');
            }
            else {
                $("#<%=wibtnSelectFlow2.ClientID %>").val('<%=lblShowForm.Text %>');
            }
        }

        function DeleteChildDocData() {

            var name = "";
            var hidNoAuthSet = $("#<%=hidNoAuthSet.ClientID %>").val().split(',');
            var ckAuthorSetLend = $("#<%=ckAuthorSetLend.ClientID %>");
            var chkAuthorCanChange = $("#<%=chkAuthorCanChange.ClientID %>");
            var DeleteText = '<%=lblCheckDeleteChildDocData.Text %>'.split('」');

            if (chkAuthorCanChange.length > 0) {
                if (!chkAuthorCanChange.prop("checked"))
                    name += '<%=wsSource.Title %>' + '、'
            }
            else {
                for (var i = 0 ; i < hidNoAuthSet.length ; i++) {
                    if (hidNoAuthSet[i] == "source")
                        name += '<%=wsSource.Title %>' + '、'
                }
            }

            if (ckAuthorSetLend.length > 0) {
                if (!ckAuthorSetLend.prop("checked"))
                    name += '<%=wsLend.Title %>' + '、'
            }
            else {
                for (var i = 0 ; i < hidNoAuthSet.length ; i++) {
                    if (hidNoAuthSet[i] == "lend")
                        name += '<%=wsLend.Title %>' + '、'
                }
            }


            name = name.substring(0, name.length - 1);
            if (name != "") {
                name = DeleteText[0] + name + "」" + DeleteText[1] + name + "」" + DeleteText[2];
                return confirm(name);
            }
        }

        function CheckddlUseWKFListCount2() {
            var ddlUseWKFList2 = $("#<%=ddlUseWKFList2.ClientID %> option");

            if (ddlUseWKFList2.length > 0) {
                if (ddlUseWKFList2.size() == 0) {

                    alert('<%=lblNoWKFFlow.Text %>');
                    return false;
                }
            }
            return true;
        }

        function ChangeStatus() {
            var chkAgentSubscribe = $("#<%=chkAgentSubscribe.ClientID%>");
            if (chkAgentSubscribe.length == 0)
                return;
            //任何變更
            var chkAllChange = $("#<%=chkAllChange.ClientID%>");
            // 新文件發佈
            var chkNewDoc = $("#<%=chkNewDoc.ClientID%>");
            // 文件版本更新
            var chkVerChange = $("#<%=chkVerChange.ClientID%>");
            // 文件作廢
            var chkDocVoid = $("#<%=chkDocVoid.ClientID%>");
            // 文件銷毀
            var chkDocDel = $("#<%=chkDocDel.ClientID%>");

            var rbtnlistSubscribe = $("#<%=rbtnlistSubscribe.ClientID%> input:radio");

            var check = chkAgentSubscribe.prop("checked");
            if (check)
                $("#divAgentUser").show();
            else
                $("#divAgentUser").hide();
            chkAllChange.prop("disabled", !check);
            chkNewDoc.prop("disabled", !check);
            chkVerChange.prop("disabled", !check);
            chkDocVoid.prop("disabled", !check);
            chkDocDel.prop("disabled", !check);
            rbtnlistSubscribe.prop("disabled", !check);
        }

        function ChangeAddSummary(){            
            var chkAddSummary = $("#<%=chkAddSummary.ClientID %>");
            var rblChoseCoverType_0 = $("#<%=rblChoseCoverType.ClientID%>_0");
            var rblChoseCoverType_1 = $("#<%=rblChoseCoverType.ClientID%>_1");  
            var ckShowSignOffCourse = $("#<%=ckShowSignOffCourse.ClientID%>");
            var cbShowVerHistory = $("#<%=cbShowVerHistory.ClientID%>");
            if (!chkAddSummary.prop("disabled") && chkAddSummary.is(":checked")) {
                rblChoseCoverType_0.removeAttr("disabled");
                rblChoseCoverType_1.removeAttr("disabled");
                ckShowSignOffCourse.removeAttr("disabled");
                cbShowVerHistory.removeAttr("disabled");
            }
            else{
                rblChoseCoverType_0.prop("disabled", true);
                rblChoseCoverType_1.prop("disabled", true);                    
                ckShowSignOffCourse.prop("disabled", true);
                cbShowVerHistory.prop("disabled", true);
            }
        }

        function ChangeInformType() {
            chkAllChange = $("#<%=chkAllChange.ClientID%>");

            if (chkAllChange.length > 0) {
                // 新文件發佈
                chkNewDoc = $("#<%=chkNewDoc.ClientID%>");

                // 文件版本更新
                chkVerChange = $("#<%=chkVerChange.ClientID%>");

                // 文件作廢
                chkDocVoid = $("#<%=chkDocVoid.ClientID%>");

                // 文件銷毀
                chkDocDel = $("#<%=chkDocDel.ClientID%>");

                chkNewDoc.prop("checked", chkAllChange.prop("checked"));
                chkVerChange.prop("checked", chkAllChange.prop("checked"));
                chkDocVoid.prop("checked", chkAllChange.prop("checked"));
                chkDocDel.prop("checked", chkAllChange.prop("checked"));
            }
        }

        function ChangeAllStatus() {
            chkNewDoc = $("#<%=chkNewDoc.ClientID%>");

            // 文件版本更新
            chkVerChange = $("#<%=chkVerChange.ClientID%>");

            // 文件作廢
            chkDocVoid = $("#<%=chkDocVoid.ClientID%>");

            // 文件銷毀
            chkDocDel = $("#<%=chkDocDel.ClientID%>");

            chkAllChange = $("#<%=chkAllChange.ClientID%>");


            if (chkNewDoc.prop("checked") && chkVerChange.prop("checked") && chkDocVoid.prop("checked") && chkDocDel.prop("checked"))
                chkAllChange.prop("checked", true);
            else
                chkAllChange.prop("checked", false);
        }

        //設定調閱是否啟用
        function IsBorrow() {
            var chkBorrow = $("#<%=chkBorrow.ClientID %>");
            var rblApplyRead = $("#<%=rblApplyRead.ClientID %>");
            var ChoiceList1 = $("#ChoiceList1");
            var rblReadProcedure = $("#<%=rblReadProcedure.ClientID %>");

            var btnWKFAddNew2 = $("#<%=btnWKFAddNew2.ClientID %>");
            var ddlUseWKFList2 = $("#<%=ddlUseWKFList2.ClientID %>");
            var wibtnSelectFlow2 = $("#<%=wibtnSelectFlow2.ClientID %>");
            var WKFFlow = $("#WKFFlow");

            rblApplyRead.prop("disabled", !chkBorrow.prop("checked"));
            rblReadProcedure.prop("disabled", !chkBorrow.prop("checked"));
            ChoiceList1.prop("disabled", !chkBorrow.prop("checked"));

            if (btnWKFAddNew2.length > 0) {
                btnWKFAddNew2.prop("disabled", !chkBorrow.prop("checked"));
                ddlUseWKFList2.prop("disabled", !chkBorrow.prop("checked"));
                wibtnSelectFlow2.prop("disabled", !chkBorrow.prop("checked"));
                WKFFlow.prop("disabled", !chkBorrow.prop("checked"));
            }
        }

        //判斷選擇的人員
        function ChangeSelApplyUser(theRadio) {
            var ChoiceList1 = $("#ChoiceList1");

            if (theRadio.val() == "AllowALL")
                ChoiceList1.hide();
            else
                ChoiceList1.show();
        }

        function InheritParent() {
            var ckInheritParent2 = $("#<%=ckInheritParent2.ClientID %>");
            var rblApplyRead = $("#<%=rblApplyRead.ClientID %>");
            var ChoiceList1 = $("#ChoiceList1");
            var rblReadProcedure = $("#<%=rblReadProcedure.ClientID %>");

            var btnWKFAddNew2 = $("#<%=btnWKFAddNew2.ClientID %>");
            var ddlUseWKFList2 = $("#<%=ddlUseWKFList2.ClientID %>");
            var wibtnSelectFlow2 = $("#<%=wibtnSelectFlow2.ClientID %>");
            var WKFFlow = $("#WKFFlow");
            var ckAuthorSetLend = $("#<%=ckAuthorSetLend.ClientID %>");
            var chkBorrow = $("#<%=chkBorrow.ClientID %>");

            if (chkBorrow.prop("checked")) {
                rblApplyRead.prop("disabled", ckInheritParent2.prop("checked"));
                rblReadProcedure.prop("disabled", ckInheritParent2.prop("checked"));
                ChoiceList1.prop("disabled", ckInheritParent2.prop("checked"));

                if (btnWKFAddNew2.length > 0) {
                    btnWKFAddNew2.prop("disabled", ckInheritParent2.prop("checked"));
                    ddlUseWKFList2.prop("disabled", ckInheritParent2.prop("checked"));
                    wibtnSelectFlow2.prop("disabled", ckInheritParent2.prop("checked"));
                    WKFFlow.prop("disabled", ckInheritParent2.prop("checked"));
                }

            }
            ckAuthorSetLend.prop("disabled", ckInheritParent2.prop("checked"));
            chkBorrow.prop("disabled", ckInheritParent2.prop("checked"));
        }

        function InheritParentLoad() {
            var ckInheritParent2 = $("#<%=ckInheritParent2.ClientID %>");
            var rblApplyRead = $("#<%=rblApplyRead.ClientID %>");
            var ChoiceList1 = $("#ChoiceList1");
            var rblReadProcedure = $("#<%=rblReadProcedure.ClientID %>");

            var btnWKFAddNew2 = $("#<%=btnWKFAddNew2.ClientID %>");
            var ddlUseWKFList2 = $("#<%=ddlUseWKFList2.ClientID %>");
            var wibtnSelectFlow2 = $("#<%=wibtnSelectFlow2.ClientID %>");
            var WKFFlow = $("#WKFFlow");
            var ckAuthorSetLend = $("#<%=ckAuthorSetLend.ClientID %>");
            var chkBorrow = $("#<%=chkBorrow.ClientID %>");


            rblApplyRead.prop("disabled", ckInheritParent2.prop("checked"));
            rblReadProcedure.prop("disabled", ckInheritParent2.prop("checked"));
            ChoiceList1.prop("disabled", ckInheritParent2.prop("checked"));

            if (btnWKFAddNew2.length > 0) {
                btnWKFAddNew2.prop("disabled", ckInheritParent2.prop("checked"));
                ddlUseWKFList2.prop("disabled", ckInheritParent2.prop("checked"));
                wibtnSelectFlow2.prop("disabled", ckInheritParent2.prop("checked"));
                WKFFlow.prop("disabled", ckInheritParent2.prop("checked"));
            }
            ckAuthorSetLend.prop("disabled", ckInheritParent2.prop("checked"));

            chkBorrow.prop("disabled", ckInheritParent2.prop("checked"));
        }

        //繼承全域浮水印設定
        function InheritMacrocosmWater(ChangeToPDF) {
            var folderID = $("#<%=hidFolderID.ClientID%>").val();
            var cbMacrocosmWater = $("#<%=cbMacrocosmWater.ClientID %>");
            var cbInheritParentWater = $("#<%=cbInheritParentWater.ClientID %>");
            var chkAddSummary = $("#<%=chkAddSummary.ClientID %>");
            var rblChoseCoverType_0 = $("#<%=rblChoseCoverType.ClientID%>_0");
            var rblChoseCoverType_1 = $("#<%=rblChoseCoverType.ClientID%>_1");  
            var ckShowSignOffCourse = $("#<%=ckShowSignOffCourse.ClientID%>");
            var cbShowVerHistory = $("#<%=cbShowVerHistory.ClientID%>");

            var chkUseTxt = $("#<%=chkUseTxt.ClientID%>");
            var ddlTxtRotation = $("#<%=ddlTxtRotation.ClientID%>");
            var colorPicker1 = $find('<%= colorPicker1.ClientID%>');
            var ddlTxtSize = $("#<%=ddlTxtSize.ClientID%>");
            var rdoTxtPosition = $("#<%=rdoTxtPosition.ClientID%> input:radio");
            var chkDlUser = $("#<%=chkDlUser.ClientID%>");

            var txtDefText = $("#<%=txtDefText.ClientID%>");
            var chkDefText = $("#<%=chkDefText.ClientID%>");
            var RbtnVerticalPrevirw = $find("<%=RbtnVerticalPreview.ClientID %>");
            var RbtnHorizontalPreview = $find("<%=RbtnHorizontalPreview.ClientID %>");            


            var ddlTxtRotation2 = $("#<%=ddlTxtRotation2.ClientID%>");
            var colorPicker2 = $find('<%= ColorPicker2.ClientID%>');
            var ddlTxtSize2 = $("#<%=ddlTxtSize2.ClientID%>");
            var rdoTxtPosition2 = $("#<%=rdoTxtPosition2.ClientID%> input:radio");
            var chkDefText = $("#<%=chkDefText.ClientID%>");                   

            //2009/3/31 yafan 加入此段文字浮水印透明度的變數宣告**************
            var Transparency_sys = $("#<%=ddlTransparency1.ClientID%>");
            var Transparency_def = $("#<%=ddlTransparency2.ClientID%>");
            //**************************************************************** 

            var chkUseImg = $("#<%=chkUseImg.ClientID%>");
            var ddlImgRotation = $("#<%=ddlImgRotation.ClientID%>");
            var ddlimageTransparency = $("#<%=ddlimageTransparency.ClientID%>");
            //2012/5/25 YAFAN 調整此部分CODE 因應使用新版的檔案上傳元件
            //    var browseStrSpan ="";
            //    var showUploadNowButton ="";
            //    var lbUploadNow ="";
            var btnDelete = $("#<%=ViewState["btnDeleteID"].ToString() %>");
            var PDF;
            //2009/4/9 yafan加入此段是否加入系統日期的設定
            var chkSysDate = $("#<%=chkSysDate.ClientID %>");
            var chkSysPath = $("#<%=chkSysPath.ClientID %>");
            if (ChangeToPDF == "true")
                PDF = cbMacrocosmWater.prop("checked");
            else
                PDF = true;
            if (cbInheritParentWater.length > 0) {
                if (PDF) {
                    cbInheritParentWater.prop("disabled", true);
                    //cbInheritParentWater.checked = false;

                    $("#divTxtDL").prop("disabled", true);
                    $("#txtSetting").prop("disabled", true);
                    $("#txtPosition").prop("disabled", true);
                    $("#divTxtDL2").prop("disabled", true);
                    $("#txtSetting2").prop("disabled", true);
                    $("#txtPosition2").prop("disabled", true);
                    $("#spParentWater").prop("disabled", true);
                    //$("#tableSummary").prop("disabled", true);
                    $("#tablePDFSet").prop("disabled", true);

                    
                    chkAddSummary.prop("disabled", true);
                    rblChoseCoverType_0.prop("disabled", true);
                    rblChoseCoverType_1.prop("disabled", true);
                    if (RbtnVerticalPrevirw != null) {
                        RbtnVerticalPrevirw.set_enabled(false);
                    }
                    if(RbtnHorizontalPreview != null){
                        RbtnHorizontalPreview.set_enabled(false);
                    }
                    ckShowSignOffCourse.prop("disabled", true);

                    cbShowVerHistory.prop("disabled", true);

                    chkUseTxt.prop("disabled", true);
                    ddlTxtRotation.prop("disabled", true);
                    // txtTextColor.prop("disabled", true);
                    if (colorPicker1 != null) {
                        colorPicker1.set_enabled(false);
                    }
                    ddlTxtSize.prop("disabled", true);
                    ddlTxtRotation2.prop("disabled", true);
                    //txtTextColor2.prop("disabled", true);
                    if (colorPicker2 != null)
                        colorPicker2.set_enabled(false);
                    ddlTxtSize2.prop("disabled", true);
                    txtDefText.prop("disabled", true);

                    //2009/3/31 yafan 加入此段文字浮水印透明度的變數宣告**************
                    if (Transparency_sys != null) {
                        Transparency_sys.prop("disabled", true);
                        Transparency_def.prop("disabled", true);
                    }
                    //**************************************************************** 
                    //2009/4/9 yafan加入此段系統時間的設定
                    chkSysDate.prop("disabled", true);
                    chkSysPath.prop("disabled", true);
                    chkUseImg.prop("disabled", true);
                    $("#imgWater").prop("disabled", true);
                    $("#imgRot").prop("disabled", true);
                    ddlImgRotation.prop("disabled", true);
                    ddlimageTransparency.prop("disabled", true);
                    $("#imgPosition").prop("disabled", true);
                    rdoTxtPosition.prop("disabled", true);
                    chkDlUser.prop("disabled", true);
                    chkDefText.prop("disabled", true);
                    rdoTxtPosition2.prop("disabled", true);
                    var colorPicker1 = $find('<%= colorPicker1.ClientID%>');
                    if (colorPicker1 != null)
                        colorPicker1.set_selectedColor($("#<%=hidSelectColor.ClientID%>").val());
                    var colorPicker2 = $find('<%= ColorPicker2.ClientID%>');
                    if (colorPicker2 != null)
                        colorPicker2.set_selectedColor($("#<%=hidSelectColor2.ClientID%>").val());
                    //ChangeColor($("#<%=hidSelectColor.ClientID%>").val());
                    //ChangeColor2($("#<%=hidSelectColor2.ClientID%>").val());

                    if (btnDelete.length > 0) {
                        btnDelete.prop("disabled", true);
                    }
                }
                else {
                    if (folderID == "DMSRoot") {
                        cbInheritParentWater.prop("disabled", true);
                    }
                    else {
                        cbInheritParentWater.prop("disabled", false);
                    }
                    $("#spParentWater").prop("disabled", false);
                    InheritParentPDFWater();
                }

            }
        }

        //繼承父資料夾浮水印設定
        function InheritParentPDFWater() {            
            var cbInheritParentWater = $("#<%=cbInheritParentWater.ClientID %>");
            var chkAddSummary = $("#<%=chkAddSummary.ClientID %>");
            var rblChoseCoverType_0 = $("#<%=rblChoseCoverType.ClientID%>_0");
            var rblChoseCoverType_1 = $("#<%=rblChoseCoverType.ClientID%>_1");
            var ckShowSignOffCourse = $("#<%=ckShowSignOffCourse.ClientID%>");
            var cbShowVerHistory = $("#<%=cbShowVerHistory.ClientID%>"); 

            var chkDlUser = $("#<%=chkDlUser.ClientID%>");
            var chkUseTxt = $("#<%=chkUseTxt.ClientID%>");
            var ddlTxtRotation = $("#<%=ddlTxtRotation.ClientID%>");
            var colorPicker1 = $find('<%= colorPicker1.ClientID%>');
            var ddlTxtSize = $("#<%=ddlTxtSize.ClientID%>");
            var rdoTxtPosition = $("#<%=rdoTxtPosition.ClientID%> input:radio");

            var txtDefText = $("#<%=txtDefText.ClientID%>");
            var chkDefText = $("#<%=chkDefText.ClientID%>");
            var RbtnVerticalPrevirw = $find("<%=RbtnVerticalPreview.ClientID %>");
            var RbtnHorizontalPreview = $find("<%=RbtnHorizontalPreview.ClientID %>");  

            var ddlTxtRotation2 = $("#<%=ddlTxtRotation2.ClientID%>");
            var colorPicker2 = $find('<%= ColorPicker2.ClientID%>');
            var ddlTxtSize2 = $("#<%=ddlTxtSize2.ClientID%>");
            var chkDefText = $("#<%=chkDefText.ClientID%>");
            var rdoTxtPosition2 = $("#<%=rdoTxtPosition2.ClientID%> input:radio");

            //2009/3/31 yafan 加入此段文字浮水印透明度的變數宣告**************
            var Transparency_sys = $("#<%=ddlTransparency1.ClientID%>");
            var Transparency_def = $("#<%=ddlTransparency2.ClientID%>");
            //**************************************************************** 

            //2009/4/9 yafan 加入是否顯示系統時間的設定
            var chkSysDate = $("#<%=chkSysDate.ClientID %>");
            var chkSysPath = $("#<%=chkSysPath.ClientID %>");

            var chkUseImg = $("#<%=chkUseImg.ClientID%>");
            var ddlImgRotation = $("#<%=ddlImgRotation.ClientID%>");
            var ddlimageTransparency = $("#<%=ddlimageTransparency.ClientID%>");
            //2012/5/25 YAFAN 調整此部分CODE 因應使用新版的檔案上傳元件
            //var browseStrSpan = "";
            //var showUploadNowButton ="";
            // var lbUploadNow = "";    

            var btnDelete = $("#<%=ViewState["btnDeleteID"].ToString() %>");

            if (cbInheritParentWater.length > 0) {

                if (cbInheritParentWater.prop("checked")) {
                    $("#divTxtDL").prop("disabled", true);
                    $("#txtSetting").prop("disabled", true);
                    $("#txtPosition").prop("disabled", true);
                    $("#divTxtDL2").prop("disabled", true);
                    $("#txtSetting2").prop("disabled", true);
                    $("#txtPosition2").prop("disabled", true);
                    //$("#tableSummary").prop("disabled", true);
                    $("#tablePDFSet").prop("disabled", true);

                    <%--if (colorPicker1 != null) {
                  colorPicker1.set_selectedColor($("#<%=hidSelectColor.ClientID%>").val());
          }
          if (colorPicker2 != null)
              colorPicker2.set_selectedColor($("#<%=hidSelectColor2.ClientID%>").val());--%>


                    chkAddSummary.prop("disabled", true);
                    //RbtnVerticalPrevirw.prop("disabled", true);
                    //RbtnHorizontalPreview.prop("disabled", true);
                    RbtnVerticalPrevirw.set_enabled(false);
                    RbtnHorizontalPreview.set_enabled(false);
                    rblChoseCoverType_0.prop("disabled", true);
                    rblChoseCoverType_1.prop("disabled", true);
                    ckShowSignOffCourse.prop("disabled", true);
                    cbShowVerHistory.prop("disabled", true);
                    chkUseTxt.prop("disabled", true);
                    ddlTxtRotation.prop("disabled", true);
                    //txtTextColor.prop("disabled", true);
                    if (colorPicker1 != null) {
                        colorPicker1.set_enabled(false);
                    }
                    ddlTxtSize.prop("disabled", true);
                    ddlTxtRotation2.prop("disabled", true);
                    //txtTextColor2.prop("disabled", true);
                    if (colorPicker2 != null)
                        colorPicker2.set_enabled(false);
                    ddlTxtSize2.prop("disabled", true);
                    txtDefText.prop("disabled", true);
                    chkDlUser.prop("disabled", true);
                    rdoTxtPosition.prop("disabled", true);
                    chkDefText.prop("disabled", true);
                    rdoTxtPosition2.prop("disabled", true);

                    //2009/3/31 yafan 加入此段文字浮水印透明度的變數宣告**************
                    if (Transparency_sys != null) {
                        Transparency_sys.prop("disabled", true);
                        Transparency_def.prop("disabled", true);
                    }
                    //**************************************************************** 

                    //2009/4/9 yafan加入此段是否顯示系統時間的設定
                    chkSysDate.prop("disabled", true);
                    chkSysPath.prop("disabled", true);

                    //2012/5/25 YAFAN 調整此部分CODE 因應使用新版的檔案上傳元件
                    //            if (browseStrSpan != null )
                    //            {
                    //                browseStrSpan.disabled = true;
                    //                showUploadNowButton.style.display = 'none'
                    //                
                    //            }    
                    chkUseImg.prop("disabled", true);
                    $("#imgWater").prop("disabled", true);
                    $("#imgRot").prop("disabled", true);
                    ddlImgRotation.prop("disabled", true);
                    ddlimageTransparency.prop("disabled", true);
                    $("#imgPosition").prop("disabled", true);
                    //ChangeColor($("#<%=hidSelectColor.ClientID%>").val());
                    //ChangeColor2($("#<%=hidSelectColor2.ClientID%>").val());

                    if (btnDelete.length > 0) {
                        btnDelete.prop("disabled", true);
                    }
                    else {

                    }
                }
                else {
                    
                    ChangeTextStatus();
                }
            }
        }

        function CheckchkUseImg() {
            ChangeImgStatus();
            var chkUseImg = $("#<%=chkUseImg.ClientID%>");
            var fs = $find("<%= UC_FileCenter.ClientID%>");
            if (fs != null && fs != 'undefined') {
                if (!chkUseImg.prop("disabled") && chkUseImg.prop("checked"))
                    fs.set_enabled(true);                            
                else
                    fs.set_enabled(false);                                
            }
        }

        //圖片浮水印是否啟用
        function ChangeImgStatus() {
            var chkUseImg = $("#<%=chkUseImg.ClientID%>");
            var ddlImgRotation = $("#<%=ddlImgRotation.ClientID%>");
            var ddlimageTransparency = $("#<%=ddlimageTransparency.ClientID%>");
            //2012/5/25 YAFAN 調整此部分CODE 因應使用新版的檔案上傳元件
            //        var browseStrSpan ="";
            //        var showUploadNowButton ="";
            //        var lbUploadNow = "";
            var btnDelete = $("#<%=ViewState["btnDeleteID"].ToString() %>");
            var rdoImgPosition = $("#<%=rdoImgPosition.ClientID%> input:radio");

            if (!chkUseImg.prop("disabled") && chkUseImg.prop("checked")) {
                //2012/5/25 YAFAN 調整此部分CODE 因應使用新版的檔案上傳元件
                //            if (browseStrSpan != null )
                //            {
                //                browseStrSpan.disabled = false;
                //                
                //                if (browseStrSpan.style.display == '')
                //                    showUploadNowButton.style.display = 'none'
                //                else
                //                    showUploadNowButton.style.display = ''
                //                
                //            }            

                $("#imgWater").prop("disabled", false);
                $("#imgRot").prop("disabled", false);
                ddlImgRotation.prop("disabled", false);
                ddlimageTransparency.prop("disabled", false);
                $("#imgPosition").prop("disabled", false);
                rdoImgPosition.prop("disabled", false);

                if (btnDelete.length > 0) {
                    btnDelete.prop("disabled", false);
                }
            }
            else {
                //2012/5/25 YAFAN 調整此部分CODE 因應使用新版的檔案上傳元件
                //            if (browseStrSpan != null )
                //            {
                //                browseStrSpan.disabled = true;
                //                showUploadNowButton.style.display = 'none'
                //                
                //            }    
                $("#imgWater").prop("disabled", true);
                $("#imgRot").prop("disabled", true);
                ddlImgRotation.prop("disabled", true);
                ddlimageTransparency.prop("disabled", true);
                $("#imgPosition").prop("disabled", true);
                rdoImgPosition.prop("disabled", true);

                if (btnDelete.length > 0) {
                    btnDelete.prop("disabled", true);
                }
            }
        }

        //文字浮水印是否啟用
        function ChangeTextStatus() {            
            var chkUseTxt = $("#<%=chkUseTxt.ClientID%>");

            var chkDlUser = $("#<%=chkDlUser.ClientID%>");
            var ddlTxtRotation = $("#<%=ddlTxtRotation.ClientID%>");
            var ddlTxtSize = $("#<%=ddlTxtSize.ClientID%>");
            var ddlTransparency1 = $("#<%=ddlTransparency1.ClientID%>");
            var rdoTxtPosition = $("#<%=rdoTxtPosition.ClientID%> input:radio");

            var chkDefText = $("#<%=chkDefText.ClientID%>");
            var txtDefText = $("#<%=txtDefText.ClientID%>");
            var ddlTxtRotation2 = $("#<%=ddlTxtRotation2.ClientID%>");
            var ddlTxtSize2 = $("#<%=ddlTxtSize2.ClientID%>");
            var ddlTransparency2 = $("#<%=ddlTransparency2.ClientID%>");
            var rdoTxtPosition2 = $("#<%=rdoTxtPosition2.ClientID%> input:radio");
            var colorPicker1 = $find('<%= colorPicker1.ClientID%>');
            <%--if (colorPicker1 != null)
            colorPicker1.set_selectedColor($("#<%=hidSelectColor.ClientID%>").val());--%>
            var colorPicker2 = $find('<%= ColorPicker2.ClientID%>');
            <%--if (colorPicker2 != null)
            colorPicker2.set_selectedColor($("#<%=hidSelectColor2.ClientID%>").val());--%>

            if (chkUseTxt.prop("checked")) {
                $("#divTxtDL").prop("disabled", false);
                $("#txtSetting").prop("disabled", false);
                $("#txtPosition").prop("disabled", false);
                $("#divTxtDL2").prop("disabled", false);
                $("#txtSetting2").prop("disabled", false);
                $("#txtPosition2").prop("disabled", false);
                chkDlUser.prop("disabled", false);
                chkDefText.prop("disabled", false);

                ChangeDlUser();
                ChangeDefText();
            }
            else {
                $("#divTxtDL").prop("disabled", true);
                $("#txtSetting").prop("disabled", true);
                $("#txtPosition").prop("disabled", true);
                $("#divTxtDL2").prop("disabled", true);
                $("#txtSetting2").prop("disabled", true);
                $("#txtPosition2").prop("disabled", true);

                chkDlUser.prop("disabled", true);
                ddlTxtRotation.prop("disabled", true);
                //txtTextColor.prop("disabled", true);
                colorPicker1.set_enabled(false);
                ddlTxtSize.prop("disabled", true);
                ddlTransparency1.prop("disabled", true);
                rdoTxtPosition.prop("disabled", true);

                chkDefText.prop("disabled", true);
                txtDefText.prop("disabled", true);
                ddlTxtRotation2.prop("disabled", true);
                //txtTextColor2.prop("disabled", true);
                colorPicker2.set_enabled(false);
                ddlTxtSize2.prop("disabled", true);
                ddlTransparency2.prop("disabled", true);
                rdoTxtPosition2.prop("disabled", true);
            }
            //ChangeColor($("#<%=hidSelectColor.ClientID%>").val());
            //ChangeColor2($("#<%=hidSelectColor2.ClientID%>").val());
        }

        //下載者部門是否勾選
        function ChangeDlUser() {
            var ddlTxtRotation = $("#<%=ddlTxtRotation.ClientID%>");
            var colorPicker = $find('<%= colorPicker1.ClientID%>');
            var ddlTxtSize = $("#<%=ddlTxtSize.ClientID%>");
            var chkDlUser = $("#<%=chkDlUser.ClientID%>");
            var Transparency_sys = $("#<%= ddlTransparency1.ClientID %>");
            var rdoTxtPosition = $("#<%= rdoTxtPosition.ClientID %> input:radio");

            if (chkDlUser.prop("checked")) {
                $("#txtSetting").prop("disabled", false);
                $("#txtPosition").prop("disabled", false);
                ddlTxtRotation.prop("disabled", false);
                //txtTextColor.prop("disabled", false);
                if (colorPicker != null)
                    colorPicker.set_enabled(true);
                ddlTxtSize.prop("disabled", false);
                if (Transparency_sys)
                    Transparency_sys.prop("disabled", false);
                rdoTxtPosition.prop("disabled", false);
            }
            else {
                $("#txtSetting").prop("disabled", true);
                $("#txtPosition").prop("disabled", true);
                ddlTxtRotation.prop("disabled", true);
                //txtTextColor.prop("disabled", true);
                if (colorPicker != null)
                    colorPicker.set_enabled(false);
                ddlTxtSize.prop("disabled", true);
                if (Transparency_sys)
                    Transparency_sys.prop("disabled", true);
                rdoTxtPosition.prop("disabled", true);
            }
        }

        //自訂文字是否勾選
        function ChangeDefText() {
            var ddlTxtRotation2 = $("#<%=ddlTxtRotation2.ClientID%>");
            var colorPicker2 = $find('<%= ColorPicker2.ClientID%>');
            var ddlTxtSize2 = $("#<%=ddlTxtSize2.ClientID%>");
            var txtDefText = $("#<%=txtDefText.ClientID%>");
            var chkDefText = $("#<%=chkDefText.ClientID%>");
            var Transparency_def = $("#<%= ddlTransparency2.ClientID %>");
            var rdoTxtPosition2 = $("#<%= rdoTxtPosition2.ClientID %> input:radio");

            if (chkDefText.prop("checked")) {
                $("#txtSetting2").prop("disabled", false);
                $("#txtPosition2").prop("disabled", false);
                ddlTxtRotation2.prop("disabled", false);
                //txtTextColor2.prop("disabled", false);
                if (colorPicker2 != null)
                    colorPicker2.set_enabled(true);
                ddlTxtSize2.prop("disabled", false);
                txtDefText.prop("disabled", false);
                if (Transparency_def)
                    Transparency_def.prop("disabled", false);
                rdoTxtPosition2.prop("disabled", false);
            }
            else {
                $("#txtSetting2").prop("disabled", true);
                $("#txtPosition2").prop("disabled", true);
                ddlTxtRotation2.prop("disabled", true);
                //txtTextColor2.prop("disabled", true);
                if (colorPicker2 != null)
                    colorPicker2.set_enabled(false);
                ddlTxtSize2.prop("disabled", true);
                txtDefText.prop("disabled", true);
                if (Transparency_def)
                    Transparency_def.prop("disabled", true);
                rdoTxtPosition2.prop("disabled", true);
            }
        }

        //開啟下載者部門的文字顏色選擇頁面
        function OpenColorPicker() {
            var currentSelNode = "SYS";
            $uof.dialog.open2("~/DMS/Admin/ColorPicker.aspx", "", "", 290, 340,
                    function (returnValue) {
                        return false;
                    }
                    , { "SelectType": currentSelNode });
        }

        //開啟自訂文字的文字顏色選擇頁面
        function OpenColorPicker2() {
            var currentSelNode = "USER";
            $uof.dialog.open2("~/DMS/Admin/ColorPicker.aspx", "", "", 290, 340,
                   function (returnValue) {
                       return false;
                   }
                   , { "SelectType": currentSelNode });
        }

        //詢問是否要複製父目錄設定
        function IsCopy() {
            var ob = $("#<%=ckInheritParent.ClientID%>");
            var hidIsCpoy = $("#<%=hidIsCpoy.ClientID %>");

            if (!ob.prop("checked")) {
                if (confirm('<%=lblIsCpoy.Text %>')) {
                    hidIsCpoy.val('false');
                }
                else {
                    hidIsCpoy.val('true');
                }
            }
            else {
                hidIsCpoy.val('true');
            }
        }

        function myClassTree_NodeChecked(sender, eventArgs) {
            var node = eventArgs.get_node();
            var bChecked = node.get_checked();
            var classId = node.get_value();
            if (!node.get_checked()) {
                var a = node.get_allNodes();
                for (var j = 0; j < a.length; j++) {
                    var childNode = a[j];
                    childNode.set_checked(false);
                }
                node.set_checked(false);
            }
            else {
                while (node.get_parent().set_checked != null) {
                    node.get_parent().set_checked(true);
                    node = node.get_parent();
                }
            }

            var hidClickValue = $("#<%=hidClickValue.ClientID%>");

            if (!bChecked) {
                hidClickValue.val(hidClickValue.val().replace(classId, ''));
            }
            else
                hidClickValue.val(hidClickValue.val() + classId + ';');
        }

        function rtxtInitialVer_OnKeyPress(sender, args) {
            var keyCode = args.get_keyCode();

            if (!(((keyCode >= 48) && (keyCode <= 57)) || (window.event.keyCode == 46) || (keyCode == 13) || (keyCode == 8)))
                args.set_cancel(true);
        }

        function rtxtInitialVer_OnValueChanging(sender, args) {
            var oldValue = args.get_oldValue();
            var newValue = args.get_newValue();
            if (newValue == '') return;
            if (newValue.indexOf('.') == -1) {
                //只有整數時
                if (newValue.length > 2)
                    args.set_newValue(oldValue);
                else
                    args.set_newValue(newValue + ".0");
            }
            else {
                var array = newValue.split('.');
                if (array.length > 2) {
                    //不可以兩個小數點
                    args.set_newValue(oldValue);
                }
                else {
                    if (array[1] == "") {
                        if (array[0].length > 2) {
                            args.set_newValue(oldValue);
                        }
                        else
                            args.set_newValue(newValue + "0");
                    }
                    else {

                        if (array[0].length > 2) {
                            //整數位兩位
                            args.set_newValue(oldValue);
                            return;
                        }
                        else if (array[1].length > 2) {
                            args.set_newValue(array[0] + "." + array[1].substring(0, 2));
                        }
                    }
                }
            }
        }

        function RadCustomizeProperty_ButtonClicking(sender, args) {
            var value = args.get_item().get_value();
            var folderID = $("#<%=hidFolderID.ClientID%>").val();
            switch (value) {
                case "AddCustomizeProperty":
                    args.set_cancel(true);
                    $uof.dialog.open2("~/DMS/DocStore/DMSPropertyCustomizeEdit.aspx", args.get_item(), '<%=lblAddCustomizeProperty.Text%>', 500, 300, RadCustomizePropertyResult, { "folderid": folderID, "Mode": "Add" });
                    break;
                case "DeleteCustomizeProperty":
                    var CheckedData = $uof.fastGrid.getChecked('<%= GridCustomizeProperty.ClientID %>');
                    if (CheckedData == "") {
                        args.set_cancel(true);
                    }
                    break;
            }
        }

        function RadCustomizePropertyResult(returnValue) {
            if (typeof (returnValue) != 'undefined') {
                return true;
            }
            return false;
        }

        function CopyText(ClientID) {
            //Add code to handle your event here.
            
            clipboardData.setData("Text", $('#' + ClientID).text());
        }

        function openCoverPreview(width, height) {            
            var iTop = (window.screen.availHeight - 30 - height) / 2;  //視窗的垂直位置;
            var iLeft = (window.screen.availWidth - 10 - width) / 2;   //視窗的水平位置;            
            var owindow = window.open('', '_blank', 'scrollbars=yes,menubar=no,toolbar=no,width=' + width + ',height=' + height + ',top=' + iTop + ',left=' + iLeft);
            var ImgCoverPreview = $('#<%=ImgCoverPreview.ClientID%>');
            owindow.document.body.innerHTML = '<IMG src=' + ImgCoverPreview[0].src + '>';
            <%--owindow.document.title = '<%=btnPDFPreview.Text%>';--%>
        }

        function ContentEmpty() {
            alert('<%=lblContentEmpty.Text%>');
        }        

        function btnPDFPreview_Click(url) {                                   
            window.open(url + "&timestamp=" + new Date().getTime(),'_blank', 'scrollbars=yes,menubar=no,toolbar=no,width=600,height=900');                                    
        }

        function btnPDFPreview() {            
            $uof.dialog.open2('../DMS/DocStore/DocCoverPreview.png', '', '', 500, 700, function (returnValue) { return false; });
        }

        //文件類別Tree resize
        function resizeTree(X, Y) {
            var tree = $find("<%=classTree1.ClientID %>");
            if (tree != null && tree != 'undefined') {
                tree.get_element().style.height = Y - 50 + "px";
                tree.get_element().style.width = X - 153 + "px";
            }
        }
    </script>

    <style>
        td {
            vertical-align: top;
        }

        .previewwindow {
            z-index: 9900 !important;
        }

        div.JustAddBorder table tr td {
            border-width: 1px;
            border-style: solid;
        }
    </style>

    <table width="100%" border="0">
        <tr>
            <td class="PopTableHeader" style="height: 21px; text-align: center!important">
                <asp:Label ID="lblTitle" runat="server" Text="目錄安全" meta:resourcekey="lblTitleResource1"></asp:Label></td>
        </tr>
    </table>

    <asp:Wizard ID="Wizard1" runat="server" ActiveStepIndex="0" BackColor="#F7F6F3" BorderColor="#999999"
        BorderWidth="1px" Height="92%"
        Width="100%" EnableTheming="True" BorderStyle="Solid"
        meta:resourcekey="Wizard1Resource1"
        OnSideBarButtonClick="Wizard1_SideBarButtonClick">
        <StepStyle VerticalAlign="Top" BackColor="White" BorderColor="#E6E2D8" BorderStyle="Solid" BorderWidth="2px" />
        <SideBarStyle BackColor="White" VerticalAlign="Top" Width="120px" Font-Underline="False" ForeColor="Black" HorizontalAlign="Left" Wrap="false" />
        <NavigationButtonStyle BackColor="White" BorderColor="#C5BBAF" BorderStyle="Solid" BorderWidth="1px" ForeColor="#1C5E55" />
        <WizardSteps>
            <asp:WizardStep ID="WizardStep9" runat="server" Title="文件設定" meta:resourcekey="WizardStep9Resource1">
                <asp:UpdatePanel ID="UpdatePanel11" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <table style="width: 100%;" border="0px" cellpadding="0px" cellspacing="1px">
                            <tr>
                                <td style="text-align: left;" colspan="2">
                                    <asp:CheckBox ID="ckInheritParent_docMode" runat="server" Text="使用父目錄的文件設定"
                                        OnCheckedChanged="ckInheritParent_docMode_CheckedChanged"
                                        AutoPostBack="True" meta:resourcekey="ckInheritParent_docModeResource1" />
                                    &nbsp;<asp:Label ID="lblShowParent"
                                        runat="server" ForeColor="Blue" Text="目前所繼承的父目錄：" Visible="False"
                                        meta:resourcekey="lblShowParentResource1"></asp:Label>
                                    &nbsp;<asp:Label ID="labUseParent_docMode" runat="server" ForeColor="Blue"
                                        Visible="False" meta:resourcekey="labUseParent_docModeResource1"></asp:Label><br />
                                    <asp:CheckBox ID="chkChangeToChild_docMode" runat="server" Text="套用變更到此目錄與子目錄" meta:resourcekey="chkChangeChildSetResource5" /><br />
                                </td>
                            </tr>
                        </table>     
                        <telerik:RadTabStrip ID="rtsDocSettingTab" MultiPageID="rmpDocSettingPage" SelectedIndex="0" runat="server">
                            <Tabs>
                                <telerik:RadTab runat="server" Text="一般設定" Selected="True" meta:resourcekey="RadTabResource4">
                                </telerik:RadTab>
                                <telerik:RadTab runat="server" Text="版號設定" meta:resourcekey="RadTabResource5">
                                </telerik:RadTab>
                            </Tabs>
                        </telerik:RadTabStrip>
                        <telerik:RadMultiPage ID="rmpDocSettingPage" runat="server">
                            <telerik:RadPageView ID="rpvDocGeneralSetting" runat="server" Selected="true">
                                <table  style="width: 100%;" border="0px" cellpadding="0px" cellspacing="1px" class="PopTable">
                                    <tr>
                                        <td style="width: 30%;">
                                            <asp:Label ID="Label24" runat="server" Text="文件模式" meta:resourcekey="Label24Resource1"></asp:Label>
                                        </td>
                                        <td class="PopTableRightTD" style="white-space: nowrap;">
                                            <asp:RadioButtonList ID="RadioButtonList1" runat="server" RepeatDirection="Horizontal" meta:resourcekey="RadioButtonList1Resource1">
                                                <asp:ListItem Value="FILE" Text="檔案" meta:resourcekey="ListItemResource147"></asp:ListItem>
                                                <asp:ListItem Value="CONT" Text="本文" meta:resourcekey="ListItemResource148"></asp:ListItem>
                                                <asp:ListItem Value="BOTH" Text="皆可" meta:resourcekey="ListItemResource149"></asp:ListItem>
                                            </asp:RadioButtonList>
                                            <asp:Label ID="lblModeExplain" runat="server" Text="檔案:僅可發佈文件檔案" CssClass="SizeMemo" meta:resourcekey="lblModeExplainResource1"></asp:Label>
                                            <br />
                                            <asp:Label ID="lblModeExplain2" runat="server" Text="本文:使用本文格式" CssClass="SizeMemo" meta:resourcekey="lblModeExplain2Resource1">
                                            </asp:Label>
                                        </td>
                                    </tr>
                                    <tr style="display: none;">
                                        <td style="width: 30%;">
                                            <asp:Label ID="Label32" runat="server" Text="本文文件列印" meta:resourcekey="Label32Resource1"></asp:Label>
                                        </td>
                                        <td class="PopTableRightTD">
                                            <asp:RadioButtonList ID="rblIsContentPrint" runat="server" RepeatDirection="Horizontal" meta:resourcekey="rblIsContentPrintResource1">
                                                <asp:ListItem Value="True" Text="是" meta:resourcekey="ListItemResource156"></asp:ListItem>
                                                <asp:ListItem Value="False" Text="否" meta:resourcekey="ListItemResource157"></asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 30%;">
                                            <asp:Label ID="lblIdenticalName" runat="server" Text="允許相同名稱" meta:resourcekey="lblIdenticalNameResource1"></asp:Label>
                                        </td>
                                        <td class="PopTableRightTD">
                                            <asp:RadioButtonList ID="rblIdentical" runat="server" RepeatDirection="Horizontal" meta:resourcekey="rblIdenticalResource1">
                                                <asp:ListItem Value="True" Text="是" meta:resourcekey="ListItemResource158"></asp:ListItem>
                                                <asp:ListItem Value="False" Text="否" meta:resourcekey="ListItemResource159"></asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="white-space: nowrap;">
                                            <asp:Label ID="lblViewDraft" runat="server" Text="允許讀者查詢草稿" meta:resourcekey="lblViewDraftResource1"></asp:Label>
                                        </td>
                                        <td class="PopTableRightTD">
                                            <asp:RadioButtonList ID="rblIsViewDraft" runat="server" RepeatDirection="Horizontal" meta:resourcekey="rblIsViewDraftResource1">
                                                <asp:ListItem Text="是" Value="True" meta:resourcekey="ListItemResource184"></asp:ListItem>
                                                <asp:ListItem Text="否" Value="False" meta:resourcekey="ListItemResource185"></asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="white-space: nowrap;">
                                            <asp:Label ID="lblAuthorPrintControl" runat="server" Text="允許作者使用紙本分發" meta:resourcekey="lblAuthorPrintControlResource1"></asp:Label>
                                        </td>
                                        <td class="PopTableRightTD">
                                            <asp:RadioButtonList ID="rblAuthorPrintControl" runat="server" RepeatDirection="Horizontal" meta:resourcekey="rblAuthorPrintControlResource1">
                                                <asp:ListItem Text="是" Value="True" meta:resourcekey="ListItemResource197"></asp:ListItem>
                                                <asp:ListItem Text="否" Value="False" meta:resourcekey="ListItemResource198"></asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                    </tr>
                                    <tr runat="server" id="trDocChange" visible="false">
                                        <td style="white-space: nowrap;">
                                            <asp:Label ID="lblAuthorDocChange" runat="server" Text="允許作者使用文件置換" meta:resourcekey="lblAuthorDocChangeResource1"></asp:Label>
                                        </td>
                                        <td class="PopTableRightTD">
                                            <asp:RadioButtonList ID="rblAuthorDocChange" runat="server" RepeatDirection="Horizontal" meta:resourcekey="rblAuthorDocChangeResource1">
                                                <asp:ListItem Text="是" Value="True" meta:resourcekey="ListItemResource199" ></asp:ListItem>
                                                <asp:ListItem Text="否" Value="False" meta:resourcekey="ListItemResource200" ></asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="white-space: nowrap;">
                                            <asp:Label ID="lblDuplicateDocNo" runat="server" Text="文件編號重複" meta:resourcekey="lblDuplicateDocNoResource1"></asp:Label>
                                        </td>
                                        <td class="PopTableRightTD">
                                            <asp:CheckBox ID="cbDuplicateDocNo" Text="啟用" runat="server" meta:resourcekey="cbDuplicateDocNoResource1"/><br />
                                            <asp:Label ID="lblDuplicateDocNoMemo" CssClass="SizeMemo" runat="server" Text="啟用後，依此設定為主，不考慮一般組態設定的文件編號驗證" meta:resourcekey="lblDuplicateDocNoMemoResource1"></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </telerik:RadPageView>
                            <telerik:RadPageView ID="rpvDocAdvancedSetting" runat="server">
                                <table  style="width: 100%;" border="0px" cellpadding="0px" cellspacing="1px" class="PopTable">
                                    <tr >
                                        <td style="width: 30%;">
                                            <asp:Label ID="lblAllowAddVersion" runat="server" Text="版本編號" meta:resourcekey="lblAllowAddVersionResource1"></asp:Label>
                                        </td>
                                        <td class="PopTableRightTD">
                                            <table>
                                                <tr>
                                                    <td>
                                                        <asp:RadioButtonList ID="rblAllowVersionCarry" runat="server" AutoPostBack="True" RepeatDirection="Horizontal" meta:resourcekey="rblAllowVersionCarryResource1" OnSelectedIndexChanged="rblAllowVersionCarry_SelectedIndexChanged">
                                                            <asp:ListItem Value="True" Text="預設" meta:resourcekey="ListItemResource160"></asp:ListItem>
                                                            <asp:ListItem Value="False" Text="進階" meta:resourcekey="ListItemResource161"></asp:ListItem>
                                                        </asp:RadioButtonList>
                                                    </td>
                                                    <td>
                                                        &nbsp;
                                                        (<asp:LinkButton ID="lbtnVerEx" runat="server" Text="版本編號範例" meta:resourcekey="lbtnVerExResource1"></asp:LinkButton>)
                                                    </td>
                                                </tr>
                                            </table>
                                            <asp:Label ID="lblAllowVerCarryComment" runat="server" Text="進階:只有在取出公佈版時才進號, 其餘版更皆不異動版號." CssClass="SizeMemo" meta:resourcekey="lblAllowVerCarryCommentResource1"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="lblAuthorSettingInitialVer" runat="server" Text="作者自訂起始公佈版本編號" meta:resourcekey="lblAuthorSettingInitialVerResource1"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:CheckBox ID="cbAuthorSettingInitialVer" runat="server" Text="啟用" meta:resourcekey="cbAuthorSettingInitialVerResource1" /><br />
                                            <asp:Label ID="Label40" runat="server" CssClass="SizeMemo" Text="文件第一次公佈時，可依各別文件自行設定版本編號。" meta:resourcekey="Label40Resource1"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr id="trVerCarryDigit" runat="server" >
                                        <td>
                                            <asp:Label ID="lblSetVersionCarryDigit" runat="server" Text="編號小數點後進號數值" meta:resourcekey="lblSetVersionCarryDigitResource1"></asp:Label>
                                        </td>
                                        <td class="PopTableRightTD">
                                            <telerik:RadNumericTextBox ID="wneSetVersionCarryDigit" runat="server" MaxValue="100" MinValue="1" Width="40px" DataType="System.Int32" Culture="zh-TW" DbValueFactor="1" LabelCssClass="" LabelWidth="64px" meta:resourcekey="wneSetVersionCarryDigitResource1">
                                                <NegativeStyle Resize="None" />
                                                <NumberFormat DecimalDigits="0" ZeroPattern="n" />
                                                <EmptyMessageStyle Resize="None" />
                                                <ReadOnlyStyle Resize="None" />
                                                <FocusedStyle Resize="None" />
                                                <DisabledStyle Resize="None" />
                                                <InvalidStyle Resize="None" />
                                                <HoveredStyle Resize="None" />
                                                <EnabledStyle Resize="None" />
                                            </telerik:RadNumericTextBox>
                                            <asp:CustomValidator ID="cvVersionCarryError" runat="server" ErrorMessage="不可為0" meta:resourcekey="cvVersionCarryErrorResource1" Display="Dynamic"></asp:CustomValidator>
                                            <asp:RequiredFieldValidator ID="rfvVersionCarryError" runat="server" ErrorMessage="請輸入進號小數" ControlToValidate="wneSetVersionCarryDigit" Display="Dynamic" meta:resourcekey="rfvVersionCarryErrorResource1"></asp:RequiredFieldValidator>
                                            <br />
                                            <asp:Label ID="lblSetVersionComment" runat="server" Text="當取出後，版本編號小數點後之數值，剛好等於此設定值，則版本編號將自動進一整數位。" CssClass="SizeMemo" meta:resourcekey="lblSetVersionCommentResource1"></asp:Label>
                                            <br />
                                            <br />
                                            <asp:Label ID="lblSetVersionEx" runat="server" Text="EX:如公佈版本為&amp;quot1.2版&amp;quot，下一版應為&amp;quot1.3版&amp;quot；但若進號數值設定為&amp;quot3&amp;quot，則系統會自動從&amp;quot1.2版&amp;quot直接進位成&amp;quot2.0&amp;quot，依此類推。" ForeColor="Red" meta:resourcekey="lblSetVersionExResource1"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr id="trInitialVer" runat="server" >
                                        <td>
                                            <asp:Label ID="lblinitialVer" runat="server" Text="起始公佈版本編號" meta:resourcekey="lblinitialVerResource1"></asp:Label>
                                        </td>
                                        <td class="PopTableRightTD">
                                            <telerik:RadTextBox Style="text-align: right;" ID="rtxtInitialVer" runat="server" Width="45px" LabelCssClass="" LabelWidth="64px" meta:resourcekey="rtxtInitialVerResource1" Resize="None">
                                                            <ClientEvents OnKeyPress="rtxtInitialVer_OnKeyPress" OnValueChanging="rtxtInitialVer_OnValueChanging" />
                                                            <EmptyMessageStyle Resize="None" />
                                                            <ReadOnlyStyle Resize="None" />
                                                            <FocusedStyle Resize="None" />
                                                            <DisabledStyle Resize="None" />
                                                            <InvalidStyle Resize="None" />
                                                            <HoveredStyle Resize="None" />
                                                            <EnabledStyle Resize="None" />
                                                        </telerik:RadTextBox>
                                                        <asp:CustomValidator ID="cvInitialVerError" runat="server" ErrorMessage="不可為0" Display="Dynamic" meta:resourcekey="cvInitialVerErrorResource1"></asp:CustomValidator>
                                                            <asp:CustomValidator ID="cvDecimalDigitsErr" runat="server" ErrorMessage="小數點第一位不可為0" Display="Dynamic" meta:resourcekey="cvDecimalDigitsErrResource1" ></asp:CustomValidator>
                                                        <asp:CustomValidator ID="cvInitialVerError1" runat="server" ErrorMessage="小數位不可大於等於版號進號小數設定值" Display="Dynamic" meta:resourcekey="cvInitialVerError1Resource1"></asp:CustomValidator>
                                                        <asp:RequiredFieldValidator ID="rfvInitialVerError" runat="server" ControlToValidate="rtxtInitialVer" Display="Dynamic" ErrorMessage="請輸入起始版號" meta:resourcekey="rfvInitialVerErrorResource1"></asp:RequiredFieldValidator>
                                            <br />
                                                        <asp:Label ID="lblInitialVerComment" runat="server" CssClass="SizeMemo" Text="此設定值將視為第一次公佈時之版本編號。" ForeColor="Blue" meta:resourcekey="lblInitialVerCommentResource1"></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </telerik:RadPageView>
                        </telerik:RadMultiPage>                
                    </ContentTemplate>
                </asp:UpdatePanel>
            </asp:WizardStep>
            <asp:WizardStep ID="WizardStep1" runat="server" Title="權限設定" meta:resourcekey="WizardStepResource1">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        &nbsp;<asp:CheckBox ID="ckInheritParent" runat="server" Text="使用父目錄的權限設定" AutoPostBack="True" OnCheckedChanged="ckInheritParent_CheckedChanged" onclick="IsCopy();" meta:resourcekey="ckInheritParentResource1" /><asp:Label ID="labShowParent" runat="server" ForeColor="Blue" Text="目前所繼承的父目錄：" meta:resourcekey="labShowParentResource1"></asp:Label>
                        <asp:Label ID="labUseParent" runat="server" ForeColor="Blue"
                            meta:resourcekey="labUseParentResource1"></asp:Label><br />
                        &nbsp;<asp:CheckBox ID="ckChangeToChild" runat="server" Text="套用變更到此目錄及子目錄" meta:resourcekey="ckChangeToChildResource1" /><asp:CustomValidator ID="CustomValidator1" runat="server" Display="Dynamic" ErrorMessage="寫入權限失敗" meta:resourcekey="CustomValidator1Resource1"></asp:CustomValidator>
                        <asp:CustomValidator ID="CustomValidator2" runat="server" Display="Dynamic" ErrorMessage="相關文件正審核中,不允許移除管理員" meta:resourcekey="CustomValidator2Resource1"></asp:CustomValidator><br />
                        <br />
                        <telerik:RadTabStrip ID="RadTabStrip1" runat="server" SelectedIndex="0" MultiPageID="RadMultiPage1" meta:resourcekey="RadTabStrip1Resource1">
                            <Tabs>
                                <telerik:RadTab runat="server" Selected="True" Text="目錄管理者" meta:resourcekey="RadTabResource1">
                                </telerik:RadTab>
                                <telerik:RadTab runat="server" Text="作者" meta:resourcekey="RadTabResource2">
                                </telerik:RadTab>
                                <telerik:RadTab runat="server" Text="讀者" meta:resourcekey="RadTabResource3">
                                </telerik:RadTab>
                            </Tabs>
                        </telerik:RadTabStrip>
                        <telerik:RadMultiPage ID="RadMultiPage1" runat="server" SelectedIndex="0" BorderStyle="Solid" BorderWidth="1px"
                            Height="435px" BorderColor="#CCCCCC" BackColor="GhostWhite" meta:resourcekey="RadMultiPage1Resource1">
                            <telerik:RadPageView runat="server" ID="RadPageView1" meta:resourcekey="RadPageView1Resource1" Selected="True">
                                <uc1:UC_ChoiceList ID="UC_ChoiceList1" runat="server" ExpandToUser="false"></uc1:UC_ChoiceList>
                            </telerik:RadPageView>
                            <telerik:RadPageView runat="server" ID="RadPageView2" meta:resourcekey="RadPageView2Resource1">
                                <uc1:UC_ChoiceList ID="UC_ChoiceList2" runat="server" ExpandToUser="false"></uc1:UC_ChoiceList>
                            </telerik:RadPageView>
                            <telerik:RadPageView runat="server" ID="RadPageView3" meta:resourcekey="RadPageView3Resource1">
                                <uc1:UC_ChoiceList ID="UC_ChoiceList3" runat="server" ExpandToUser="false"></uc1:UC_ChoiceList>
                            </telerik:RadPageView>
                        </telerik:RadMultiPage>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </asp:WizardStep>
            <asp:WizardStep ID="wsSource" runat="server" Title="機密設定" meta:resourcekey="wsSourceResource5">
                <asp:UpdatePanel ID="UpdatePanel5" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <table border="0" class="PopTable" cellspacing="1" style="width: 100%;">
                            <tr>
                                <td colspan="2" style="text-align: left; padding-left: 0px; padding-right: 0px;">
                                    <table width="100%">
                                        <tr>
                                            <td class="PopTableRightTD" style="width: 100%; height: 75px">
                                                <asp:CheckBox ID="chkUseParentSet" runat="server" Text="使用父目錄的機密設定" OnCheckedChanged="chkUseParentSet_CheckedChanged" AutoPostBack="True" meta:resourcekey="chkUseParentSetResource5" /><asp:Label
                                                    ID="labShowSourceParent" runat="server" ForeColor="Blue" meta:resourcekey="labShowSourceParentResource1"
                                                    Text="目前所繼承的父目錄：" Visible="False"></asp:Label>
                                                <asp:Label ID="labUseSourceParent" runat="server"
                                                    ForeColor="Blue" Visible="False"
                                                    meta:resourcekey="labUseSourceParentResource1"></asp:Label><br />
                                                <asp:CheckBox ID="chkChangeChildSet" runat="server" Text="套用變更到此目錄與子目錄" meta:resourcekey="chkChangeChildSetResource5" /><br />
                                                <asp:CheckBox ID="chkAuthorCanChange" runat="server" Text="作者可依文件自行設定" meta:resourcekey="chkAuthorCanChangeResource5" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 33px; width: 15%; white-space: nowrap" align="right" class="PopTableLeftTD">
                                    <asp:Label ID="Label17" runat="server" Text="機密等級" meta:resourcekey="Label17Resource5"></asp:Label>
                                </td>
                                <td style="height: 33px" class="PopTableRightTD">&nbsp;<asp:DropDownList ID="ddlSecret" runat="server" Width="100px"
                                    meta:resourcekey="ddlSecretResource1">
                                    <asp:ListItem Value="Normal" Text="一般" meta:resourcekey="ListItemResource121"></asp:ListItem>
                                    <asp:ListItem Value="Secret" Text="密" meta:resourcekey="ListItemResource122"></asp:ListItem>
                                    <asp:ListItem Value="XSecret" Text="機密" meta:resourcekey="ListItemResource123"></asp:ListItem>
                                    <asp:ListItem Value="XXSecret" Text="極機密" meta:resourcekey="ListItemResource124"></asp:ListItem>
                                    <asp:ListItem Value="TopSecret" Text="絕對機密" meta:resourcekey="ListItemResource125"></asp:ListItem>
                                </asp:DropDownList>
                                </td>
                            </tr>

                            <tr>
                                <td style="width: 15%; height: 33px;" align="right" class="PopTableLeftTD">
                                    <asp:Label ID="Label19" runat="server" Text="共同編輯" meta:resourcekey="Label19Resource5"></asp:Label>
                                </td>
                                <td class="PopTableRightTD">
                                    <asp:CheckBox ID="chkCommonEdit" runat="server" Text="允許作者群共同編輯" Checked="True" meta:resourcekey="chkCommonEditResource5" />
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 15%; height: 131px;" align="right" class="PopTableLeftTD">
                                    <asp:Label ID="Label18" runat="server" Text="原稿控制" meta:resourcekey="Label18Resource5"></asp:Label>
                                </td>
                                <td style="height: 131px;" class="PopTableRightTD">

                                    <table style="width: 100%;">
                                        <tr>
                                            <td colspan="3" style="height: 25px" bgcolor="#f1f1f1" valign="middle">
                                                <asp:CheckBox ID="cbChangeToPDF" runat="server" Text="此目錄下的文件皆受控管" AutoPostBack="True" OnCheckedChanged="cbChangeToPDF_CheckedChanged" meta:resourcekey="cbChangeToPDFResource5" />
                                                <asp:Image ID="Image1" runat="server" ImageUrl="~/DMS/images/icon/pdf.gif"
                                                    meta:resourcekey="Image1Resource1" />
                                            </td>
                                        </tr>
                                        <tr style="display:none;">
                                            <td>
                                                <asp:CheckBox ID="cbIsPrint" runat="server" Text="可列印" AutoPostBack="True" OnCheckedChanged="cbIsPrint_CheckedChanged" meta:resourcekey="cbIsPrintResource5" /></td>
                                            <td>
                                                <asp:RadioButtonList ID="rblApplyRead2" runat="server"
                                                    CellPadding="0" CellSpacing="0" AutoPostBack="True" CssClass="SizeS"
                                                    OnSelectedIndexChanged="rblApplyRead2_SelectedIndexChanged" RepeatDirection="Horizontal"
                                                    meta:resourcekey="rblApplyRead2Resource1">
                                                    <asp:ListItem Selected="True" Value="AllowALL" Text="允許全部人員" meta:resourcekey="ListItemResource126"></asp:ListItem>
                                                    <asp:ListItem Value="AllowList" Text="允許下列人員" meta:resourcekey="ListItemResource127"></asp:ListItem>
                                                    <asp:ListItem Value="DenyList" Text="不允許下列人員" meta:resourcekey="ListItemResource128"></asp:ListItem>
                                                </asp:RadioButtonList></td>
                                        </tr>
                                        <tr style="display:none;">
                                            <td style="width: 100%; text-align: left;" colspan="3">
                                                <div id="Source_ChoiceList1" style="max-height: 100px; overflow: auto; text-align: left;" runat="server">
                                                    <uc1:UC_ChoiceList ID="UC_clApplyRead2" runat="server" ExpandToUser="false"
                                                        IsAllowEdit="true"></uc1:UC_ChoiceList>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr style="display:none;">
                                            <td colspan="3">
                                                <hr />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:CheckBox ID="cbIsSave" runat="server" Text="可另存" AutoPostBack="True" OnCheckedChanged="cbIsSave_CheckedChanged" meta:resourcekey="cbIsSaveResource5" /></td>
                                            <td>
                                                <asp:RadioButtonList ID="rblApplyRead3" runat="server"
                                                    CellPadding="0" CellSpacing="0" AutoPostBack="True" CssClass="SizeS"
                                                    OnSelectedIndexChanged="rblApplyRead2_SelectedIndexChanged" RepeatDirection="Horizontal"
                                                    meta:resourcekey="rblApplyRead3Resource1">
                                                    <asp:ListItem Selected="True" Value="AllowALL" Text="允許全部人員" meta:resourcekey="ListItemResource129"></asp:ListItem>
                                                    <asp:ListItem Value="AllowList" Text="允許下列人員" meta:resourcekey="ListItemResource130"></asp:ListItem>
                                                    <asp:ListItem Value="DenyList" Text="不允許下列人員" meta:resourcekey="ListItemResource131"></asp:ListItem>
                                                </asp:RadioButtonList></td>
                                        </tr>
                                        <tr>
                                            <td style="width: 100%; text-align: left;" colspan="3">
                                                <div id="Source_ChoiceList2" style="max-height: 100px; overflow: auto;" runat="server">
                                                    <uc1:UC_ChoiceList ID="UC_clApplyRead3" runat="server" ExpandToUser="false"
                                                        IsAllowEdit="true"></uc1:UC_ChoiceList>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="3">
                                                <hr />
                                            </td>
                                        </tr>
                                        <tr style="display:none;">
                                            <td>
                                                <asp:CheckBox ID="cbIsCopy" runat="server" Text="可複製" AutoPostBack="True" OnCheckedChanged="cbIsCopy_CheckedChanged" meta:resourcekey="cbIsCopyResource5" /></td>
                                            <td>
                                                <asp:RadioButtonList ID="rblApplyRead4" runat="server"
                                                    CellPadding="0" CellSpacing="0" AutoPostBack="True" CssClass="SizeS"
                                                    OnSelectedIndexChanged="rblApplyRead2_SelectedIndexChanged" RepeatDirection="Horizontal"
                                                    meta:resourcekey="rblApplyRead4Resource1">
                                                    <asp:ListItem Selected="True" Value="AllowALL" Text="允許全部人員" meta:resourcekey="ListItemResource132"></asp:ListItem>
                                                    <asp:ListItem Value="AllowList" Text="允許下列人員" meta:resourcekey="ListItemResource133"></asp:ListItem>
                                                    <asp:ListItem Value="DenyList" Text="不允許下列人員" meta:resourcekey="ListItemResource134"></asp:ListItem>
                                                </asp:RadioButtonList></td>
                                        </tr>
                                        <tr style="display:none;">
                                            <td style="width: 100%; text-align: left;" colspan="3">
                                                <div id="Source_ChoiceList3" style="max-height: 100px; overflow: auto;" runat="server">
                                                    <uc1:UC_ChoiceList ID="UC_clApplyRead4" runat="server" ExpandToUser="false"
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
                                        <tr style="display:none;">
                                            <td colspan="3">
                                                <hr />
                                            </td>
                                        </tr>                                        
                                        <tr>
                                            <td colspan="3" style="height: 25px" bgcolor="#f1f1f1" valign="middle">&nbsp;<asp:Label ID="lblSource" runat="server" Text="原始檔" meta:resourcekey="lblSourceResource5"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblSource2" runat="server" Text="下載權限" meta:resourcekey="lblSource2Resource5"></asp:Label></td>
                                            <td>
                                                <asp:RadioButtonList ID="rblApplyRead5" runat="server"
                                                    CellPadding="0" CellSpacing="0" AutoPostBack="True" CssClass="SizeS"
                                                    OnSelectedIndexChanged="rblApplyRead2_SelectedIndexChanged" RepeatDirection="Horizontal"
                                                    meta:resourcekey="rblApplyRead5Resource1">
                                                    <asp:ListItem Selected="True" Value="DenyALL" Text="全部不允許" meta:resourcekey="ListItemResource135"></asp:ListItem>
                                                    <asp:ListItem Value="AllowALL" Text="允許全部人員" meta:resourcekey="ListItemResource136"></asp:ListItem>
                                                    <asp:ListItem Value="AllowList" Text="允許下列人員" meta:resourcekey="ListItemResource137"></asp:ListItem>
                                                    <asp:ListItem Value="DenyList" Text="不允許下列人員" meta:resourcekey="ListItemResource138"></asp:ListItem>
                                                </asp:RadioButtonList></td>
                                        </tr>
                                        <tr>
                                            <td style="width: 100%; text-align: left;" colspan="3">
                                                <div id="Source_ChoiceList4" style="max-height: 100px; overflow: auto;" runat="server">
                                                    <uc1:UC_ChoiceList ID="UC_clApplyRead5" runat="server" ExpandToUser="false"
                                                        IsAllowEdit="true"></uc1:UC_ChoiceList>
                                                </div>
                                            </td>
                                        </tr>

                                    </table>
                                    <asp:CustomValidator ID="cvSourceNoChoice" runat="server" ErrorMessage="請選擇「」人員"
                                        Visible="False" meta:resourcekey="cvSourceNoChoiceResource5"></asp:CustomValidator>
                                </td>
                            </tr>
                        </table>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </asp:WizardStep>
            <asp:WizardStep ID="WizardStep2" runat="server" Title="審核流程" meta:resourcekey="WizardStepResource3">
                <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <table style="width: 100%;" border="1" cellpadding="0" cellspacing="0">
                            <tr>
                                <td style="height: 22px; text-align: left; vertical-align: top;">&nbsp;<img src="../../DMS/images/closed.gif" />
                                    <asp:Label ID="Labelx1" runat="server" Text="目錄：" meta:resourcekey="Label2Resource1"></asp:Label>
                                    <asp:Label ID="lblPath" runat="server" ForeColor="Blue" meta:resourcekey="lblPathResource1"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 100%; height: 18px;" colspan="2">&nbsp;<asp:CheckBox ID="chkInheritParent" runat="server" Text="繼承父目錄的審核流程" AutoPostBack="True"
                                    OnCheckedChanged="chkInheritParent_CheckedChanged" meta:resourcekey="chkInheritParentResource1" />
                                    &nbsp;
                                    <asp:Label ID="labShowParent2" runat="server" ForeColor="Blue" Text="目前所繼承的父目錄："
                                        Visible="False" meta:resourcekey="labShowParent2Resource1"></asp:Label><asp:Label
                                            ID="labUseParent2" runat="server" ForeColor="Blue" Visible="False" meta:resourcekey="labUseParent2Resource1"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 100%; height: 25px;" colspan="2">&nbsp;<asp:CheckBox ID="chkChangeToChild" runat="server" Text="套用變更到此目錄及子目錄" meta:resourcekey="chkChangeToChildResource1" />
                                </td>
                            </tr>
                        </table>
                        <telerik:RadTabStrip ID="RadTabStrip2" runat="server" MultiPageID="RadMultiPage2" SelectedIndex="0" meta:resourcekey="RadTabStrip2Resource1">
                            <Tabs>
                                <telerik:RadTab runat="server" Selected="True" Text="公佈審核" meta:resourcekey="PublishTabResource1">
                                </telerik:RadTab>
                                <telerik:RadTab runat="server" Text="作廢審核" meta:resourcekey="VoidTabResource1">
                                </telerik:RadTab>
                            </Tabs>
                        </telerik:RadTabStrip>
                        <telerik:RadMultiPage ID="RadMultiPage2" runat="server" SelectedIndex="0" meta:resourcekey="RadMultiPage2Resource1">
                            <telerik:RadPageView runat="server" ID="RadPageView4" meta:resourcekey="RadPageView4Resource1" Selected="True">
                                <table style="width: 100%;" border="1" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td style="width: 100%; height: 13px" colspan="2" valign="top">&nbsp;<asp:CheckBox ID="chkNeedApprove" runat="server" Text="文件公佈之前必須經過審核" AutoPostBack="True"
                                            OnCheckedChanged="chkNeedApprove_CheckedChanged" meta:resourcekey="chkNeedApproveResource1" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 100%; height: 13px" colspan="2" valign="top">&nbsp;<asp:Label ID="Label25" runat="server" Text="排除人員(可直接修改文件不需跑審核流程)："
                                            meta:resourcekey="Label25Resource1"></asp:Label>
                                            <br />
                                            &nbsp;<asp:CheckBox ID="CheckBox1" runat="server" Text="文件管理管理員" meta:resourcekey="CheckBox1Resource1" />
                                            <br />
                                            &nbsp;<asp:CheckBox ID="CheckBox2" runat="server" Text="目錄管理者" meta:resourcekey="CheckBox2Resource1" />
                                            <br />
                                            &nbsp;<asp:Label ID="lblNoApprove" runat="server" Text="自訂排除人員" meta:resourcekey="lblNoApproveResource1"></asp:Label>
                                            <uc1:UC_ChoiceList ID="UC_ChoiceList4" runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 100%; height: 30px;" colspan="2">
                                            <asp:RadioButtonList ID="rdoApproveType" runat="server" RepeatDirection="Horizontal"
                                                AutoPostBack="True" OnSelectedIndexChanged="rdoApproveType_SelectedIndexChanged"
                                                meta:resourcekey="rdoApproveTypeResource1">
                                                <asp:ListItem Selected="True" Value="DMS" Text="使用文管簡易審核模式" meta:resourcekey="ListItemResource139"></asp:ListItem>
                                                <asp:ListItem Value="WKF" Text="使用電子簽核模式" meta:resourcekey="ListItemResource140"></asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" valign="top">
                                            <asp:Panel ID="panSelUser" runat="server" Width="100%" meta:resourcekey="panSelUserResource1">
                                                &#160; &#160;
                                                <asp:Label ID="lanDMSapprove" runat="server" ForeColor="Blue" Text="由下列任一「目錄管理者」審核通過即可公佈"
                                                    meta:resourcekey="lanDMSapproveResource1"></asp:Label>
                                                <center>
                                                    <asp:Label ID="labNoFolderMang" runat="server" ForeColor="Red" Text="此目錄無設定目錄管理者，無法進行審核設定"
                                                    Visible="False" meta:resourcekey="labNoFolderMangResource1"></asp:Label>
                                                </center>
                                                <center>
                                                    <asp:DropDownList ID="ddlUseWKFList" runat="server" Visible="False" Width="280px"
                                                    meta:resourcekey="ddlUseWKFListResource1"></asp:DropDownList>
                                                    <uc1:UC_ChoiceList ID="chManager" runat="server" IsAllowEdit="false" />
                                                    <br />
                                                    <telerik:RadButton ID="btnWKFAddNew" runat="server" text="新增流程" visible="False" 
                                                meta:resourcekey="btnWKFAddNewResource1" OnClick="btnWKFAddNew_Click1"              
                                                OnClientClicking="btnWKFAddNew_Click"></telerik:RadButton>&nbsp; &nbsp; 
                                                    <telerik:RadButton ID="wibtnSelectFlow" runat="server"
                                                Text="查詢流程" Visible="False" OnClick="wibtnSelectFlow_Click1" 
                                                    meta:resourcekey="wibtnSelectFlowResource1" OnClientClicking="wibtnSelectFlow_Click"></telerik:RadButton>&nbsp; &nbsp;
                                                    <telerik:RadButton ID="wibtnWKFFlowInfo" runat="server" Text="流程資訊" 
                                                    meta:resourcekey="wibtnWKFFlowInfoResource1" OnClientClicking="wibtnWKFFlowInfo_Click"></telerik:RadButton>
                                                    <asp:CustomValidator ID="cvNoWKFVer" runat="server" 
                                                    ErrorMessage="CustomValidator" Visible='False' 
                                                    meta:resourcekey="cvNoWKFVerResource1"></asp:CustomValidator>                                                   
                                                </center>
                                            </asp:Panel>
                                        </td>
                                    </tr>
                                </table>
                            </telerik:RadPageView>
                            <telerik:RadPageView runat="server" ID="RadPageView5" meta:resourcekey="RadPageView5Resource1">
                                <table style="width: 100%;" border="1" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td style="width: 100%; height: 13px" colspan="2" valign="top">
                                            <asp:CheckBox ID="chkNeedApproveEx2" runat="server" Text="文件作廢之前必須經過審核" AutoPostBack="True"
                                                OnCheckedChanged="chkNeedApproveEx2_CheckedChanged"
                                                meta:resourcekey="chkNeedApproveEx2Resource1" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 100%; height: 13px" colspan="2" valign="top">
                                            <asp:Label ID="Label26" runat="server" Text="排除人員(可直接修改文件不需跑審核流程)："
                                                meta:resourcekey="Label26Resource1"></asp:Label>
                                            <br />
                                            <asp:CheckBox ID="CheckBox1Ex2" runat="server" Text="文件管理管理員"
                                                meta:resourcekey="CheckBox1Ex2Resource1" />
                                            <br />
                                            <asp:CheckBox ID="CheckBox2Ex2" runat="server" Text="目錄管理者"
                                                meta:resourcekey="CheckBox2Ex2Resource1" />
                                            <br />
                                            <asp:Label ID="lblNoApprove2" runat="server" Text="自訂排除人員" meta:resourcekey="lblNoApproveResource1"></asp:Label>
                                            <uc1:UC_ChoiceList ID="UC_ChoiceListEx2" runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 100%; height: 30px;" colspan="2">
                                            <asp:RadioButtonList ID="rdoApproveTypeEx2" runat="server" RepeatDirection="Horizontal"
                                                AutoPostBack="True" OnSelectedIndexChanged="rdoApproveTypeEx2_SelectedIndexChanged"
                                                meta:resourcekey="rdoApproveTypeResource1">
                                                <asp:ListItem Selected="True" Value="DMS" Text="使用文管簡易審核模式" meta:resourcekey="ListItemResource139"></asp:ListItem>
                                                <asp:ListItem Value="WKF" Text="使用電子簽核模式" meta:resourcekey="ListItemResource140"></asp:ListItem>
                                            </asp:RadioButtonList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" valign="top">
                                            <asp:Panel ID="panSelUserEx2" runat="server" Width="100%" meta:resourcekey="panSelUserResource1">
                                                &#160; &#160;
                                                <asp:Label ID="lanDMSapproveEx2" runat="server" ForeColor="Blue" Text="由下列任一「目錄管理者」審核通過即可公佈"
                                                    meta:resourcekey="lanDMSapproveResource1"></asp:Label>
                                                <center>
                                                    <asp:Label ID="labNoFolderMangEx2" runat="server" ForeColor="Red" Text="此目錄無設定目錄管理者，無法進行審核設定"
                                                    Visible="False" meta:resourcekey="labNoFolderMangResource1"></asp:Label>
                                                </center>
                                                <center>
                                                    <asp:DropDownList ID="ddlUseWKFListEx2" runat="server" Visible="False" Width="280px"
                                                    meta:resourcekey="ddlUseWKFListResource1"></asp:DropDownList>
                                                    <uc1:UC_ChoiceList ID="chManagerEx2" runat="server" IsAllowEdit="false" />
                                                    <br />
                                                    <telerik:RadButton ID="btnWKFAddNewEx2" runat="server" text="新增流程" visible="False" 
                                                meta:resourcekey="btnWKFAddNewResource1" OnClick="btnWKFAddNewEx2_Click"              
                                                OnClientClicking="btnWKFAddNewEx2_Click"></telerik:RadButton>&nbsp; &nbsp; 
                                                    <telerik:RadButton ID="wibtnSelectFlowEx2" runat="server"
                                                Text="查詢流程" Visible="False" OnClick="wibtnSelectFlowEx2_Click" 
                                                    meta:resourcekey="wibtnSelectFlowResource1" OnClientClicking="wibtnSelectFlowEx2_Click"></telerik:RadButton>&#160; &#160; 
                                                    <telerik:RadButton ID="wibtnWKFFlowInfoEx2" runat="server" Text="流程資訊" 
                                                    meta:resourcekey="wibtnWKFFlowInfoResource1" OnClientClicking="wibtnWKFFlowInfoEx2_Click"></telerik:RadButton>
                                                    <asp:CustomValidator ID="cvNoWKFVerEx2" runat="server" ErrorMessage="CustomValidator"
                                                    Visible='False' meta:resourcekey="cvNoWKFVerResource1"></asp:CustomValidator>
                                                    <br />
                                                </center>
                                            </asp:Panel>
                                        </td>
                                    </tr>
                                </table>
                            </telerik:RadPageView>
                        </telerik:RadMultiPage>
                        <input id="hidFolderRMID" runat="server" style="width: 30px" type="hidden" />
                        </input>
                        <input id="hidFolderRMIDEx2" runat="server" style="width: 30px" type="hidden"></input>
                        </input>
                        </input>
                    </ContentTemplate>
                </asp:UpdatePanel>
                <asp:Label ID="lblUseDMS" runat="server" Text="由下列任一「目錄管理者」審核通過即可公佈：" Visible="False" meta:resourcekey="lblUseDMSResource1"></asp:Label>
                <asp:Label ID="lblUseWKF" runat="server" Text="使用的電子簽核流程：" Visible="False" meta:resourcekey="lblUseWKFResource1"></asp:Label><br />
                <asp:Label ID="lblNoWKFFlow" runat="server" Text="電子簽核沒有流程，請先新增流程" Visible="False" meta:resourcekey="lblNoWKFFlowResource1"></asp:Label>
            </asp:WizardStep>
            <asp:WizardStep ID="wsLend" runat="server" Title="調閱流程" meta:resourcekey="WizardStepResource4">
                <asp:UpdatePanel ID="UpdatePanel3" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <table border="0" width="100%" class="PopTable" cellspacing="1">
                            <tr>
                                <td align="right" valign="top" style="height: 22px; width: 20%" class="PopTableLeftTD">
                                    <img src="../../DMS/images/closed.gif" />
                                    <asp:Label ID="Label2" runat="server" Text="目錄" meta:resourcekey="Label2Resource1"></asp:Label></td>
                                <td style="height: 22px; width: 264px;" valign="top" class="PopTableRightTD">&nbsp;<asp:Label ID="lblSelfFolderPath" runat="server" ForeColor="Blue"
                                    meta:resourcekey="lblSelfFolderPathResource1"></asp:Label></td>
                            </tr>
                            <tr>
                                <td colspan="2" bgcolor="#ffffff" style="text-align: left; padding: 0px 0px 0px 0px">
                                    <table width="100%" class="PopTableRightTD">
                                        <tr>
                                            <td style="width: 100%">&nbsp;<asp:CheckBox ID="ckInheritParent2" runat="server"
                                                Text="使用父目錄的調閱設定" onclick="InheritParent()" AutoPostBack="True" OnCheckedChanged="ckInheritParent2_CheckedChanged" meta:resourcekey="ckInheritParent2Resource1" />
                                                <asp:Label ID="labShowParent3" runat="server" ForeColor="Blue" Text="目前所繼承的父目錄：" meta:resourcekey="labShowParent3Resource1"></asp:Label>
                                                <asp:Label ID="labUseParent3" runat="server" ForeColor="Blue"
                                                    meta:resourcekey="labUseParent3Resource1"></asp:Label>&nbsp;
                    <br />
                                                &nbsp;<asp:CheckBox ID="ckChangeToChild2" runat="server"
                                                    Text="套用變更到此目錄及子目錄" meta:resourcekey="ckChangeToChild2Resource1" /><br />
                                                &nbsp;<asp:CheckBox ID="ckAuthorSetLend" runat="server"
                                                    Text="作者可針對文件自行設定" meta:resourcekey="ckAuthorSetLendResource1" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>

                            </tr>

                            <tr>
                                <td style="width: 93px; height: 138px; white-space: nowrap;" align="right" class="PopTableLeftTD" valign="middle">
                                    <asp:Label ID="Label20" runat="server" Text="調閱申請" meta:resourcekey="Label20Resource1"></asp:Label>
                                </td>
                                <td style="width: 100%; height: 138px;" class="PopTableRightTD" valign="top">
                                    <asp:CheckBox ID="chkBorrow" runat="server" Text="允許調閱申請" Checked="True" onclick="IsBorrow()" AutoPostBack="True" OnCheckedChanged="chkBorrow_CheckedChanged" meta:resourcekey="chkBorrowResource1" />
                                    &nbsp;<br />
                                    <asp:RadioButtonList ID="rblApplyRead" runat="server"
                                        RepeatDirection="Horizontal" AutoPostBack="True"
                                        OnSelectedIndexChanged="rblApplyRead_SelectedIndexChanged"
                                        meta:resourcekey="rblApplyReadResource1">
                                        <asp:ListItem Selected="True" Value="AllowALL" meta:resourcekey="ListItemResource3" Text="允許全部人員"></asp:ListItem>
                                        <asp:ListItem Value="AllowList" meta:resourcekey="ListItemResource141" Text="允許下列人員"></asp:ListItem>
                                    </asp:RadioButtonList>
                                    <div id="ChoiceList1" style="width: 100%; height: 80px; overflow: auto;">
                                        <uc1:UC_ChoiceList ID="UC_clApplyRead" runat="server" ExpandToUser="false" IsAllowEdit="true" />
                                    </div>
                                    <asp:CustomValidator ID="CustomValidator3" runat="server" Display="Dynamic" ErrorMessage="請選擇調閱人員"
                                        Visible="False" meta:resourcekey="CustomValidator3Resource1"></asp:CustomValidator>

                                </td>
                            </tr>

                            <tr>
                                <td class="PopTableLeftTD" align="right" style="height: 181px">
                                    <asp:Label ID="Label16" runat="server" Text="調閱流程" meta:resourcekey="Label16Resource1"></asp:Label>
                                </td>
                                <td class="PopTableRightTD" style="height: 181px" valign="top">

                                    <asp:UpdatePanel ID="UpdatePanel4" runat="server">
                                        <ContentTemplate>

                                            <asp:RadioButtonList ID="rblReadProcedure" runat="server"
                                                RepeatDirection="Horizontal" AutoPostBack="True"
                                                OnSelectedIndexChanged="rblReadProcedure_SelectedIndexChanged"
                                                meta:resourcekey="rblReadProcedureResource1">
                                                <asp:ListItem Selected="True" Value="DefaultFlow" meta:resourcekey="ListItemResource6" Text="簡易流程"></asp:ListItem>
                                                <asp:ListItem Value="WKFFlow" meta:resourcekey="ListItemResource142" Text="電子簽核"></asp:ListItem>
                                            </asp:RadioButtonList>
                                            <asp:Label ID="labApproveHelp" runat="server" ForeColor="Blue" Text="由下列任一人員審核通過即可" meta:resourcekey="labApproveHelpResource1"></asp:Label><br />
                                            <uc1:UC_ChoiceList ID="UC_clReadProcedure" runat="server" ExpandToUser="false" IsAllowEdit="false" />

                                            <asp:Label ID="Label5" runat="server" ForeColor="Blue" Visible="False" meta:resourcekey="Label5Resource1"></asp:Label><span id="WKFFlow">
                                                <asp:DropDownList ID="ddlUseWKFList2" runat="server" Visible="False" Width="295px"
                                                    onchange="ChangeText();" meta:resourcekey="ddlUseWKFList2Resource1">
                                                </asp:DropDownList>
                                                <br />
                                                <br />
                                                <telerik:RadButton ID="btnWKFAddNew2" runat="server"
                                                    Text="新增調閱流程" Visible="False" OnClick="btnWKFAddNew2_Click1" meta:resourcekey="btnWKFAddNew2Resource1" OnClientClicking="btnWKFAddNew2_Click">
                                                </telerik:RadButton>
                                                &nbsp;
                                <telerik:RadButton ID="wibtnSelectFlow2" runat="server" Text="編輯流程"
                                    Visible="False" OnClick="wibtnSelectFlow2_Click1" meta:resourcekey="wibtnSelectFlow2Resource1" OnClientClicking="wibtnSelectFlow2_Click">
                                </telerik:RadButton>
                                                &nbsp;
                                <telerik:RadButton ID="wibtnWKFFlowInfo2" runat="server" Text="流程資訊" meta:resourcekey="wibtnWKFFlowInfo2Resource1" OnClientClicking="wibtnWKFFlowInfo2_Click"></telerik:RadButton>
                                                <asp:CustomValidator ID="cvNoWKFVer1" runat="server" ErrorMessage="CustomValidator"
                                                    Visible='False' meta:resourcekey="cvNoWKFVer1Resource1"></asp:CustomValidator>
                                            </span>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>

                                </td>
                            </tr>
                        </table>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </asp:WizardStep>
            <asp:WizardStep ID="WizardStep4" runat="server" Title="文件屬性設定" meta:resourcekey="WizardStepResource2">
                <asp:UpdatePanel ID="UpdatePanel6" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        &nbsp;<asp:CheckBox ID="ckInhitProLim" runat="server" AutoPostBack="True"
                            Text="使用父目錄的文件屬性" OnCheckedChanged="ckInhitProLim_CheckedChanged"
                            meta:resourcekey="ckInhitProLimResource1" />
                        <asp:Label ID="lblInhitProLim" runat="server" Text="目前所繼承的父目錄："
                            Visible="False" ForeColor="Blue" meta:resourcekey="lblInhitProLimResource1"></asp:Label>
                        <asp:Label ID="lblInhitProLimUser" runat="server" Visible="False"
                            ForeColor="Blue" meta:resourcekey="lblInhitProLimUserResource1"></asp:Label>
                        <br />
                        &nbsp;<asp:CheckBox ID="ckChChildProLim" runat="server" Text="套用變更到此目錄及子目錄"
                            meta:resourcekey="ckChChildProLimResource1" />
                        <br />
                        <br />
                        <table style="width: 100%; height: 85%; border: 1px solid #999999" cellpadding="0" cellspacing="0">
                            <tr>
                                <td valign="top" style="width: 200px; white-space: nowrap">
                                    <asp:Label ID="Label21" runat="server" ForeColor="Blue" Text="勾選者為文件必填的欄位" meta:resourcekey="Label21Resource1"></asp:Label>
                                    <br />
                                    &nbsp;<asp:CheckBox ID="ckDocName" runat="server" Text="文件名稱"
                                        meta:resourcekey="ckDocNameResource1" />
                                    <br />
                                    <br />
                                    &nbsp;<asp:CheckBox ID="ckDocSerial" runat="server" Text="文件編號"
                                        meta:resourcekey="ckDocSerialResource1" />
                                    <br />
                                    <br />
                                    &nbsp;<asp:CheckBox ID="ckPublishUnit" runat="server" Text="發行單位"
                                        meta:resourcekey="ckPublishUnitResource1" />
                                    <br />
                                    <br />
                                    &nbsp;<asp:CheckBox ID="ckCustodyUser" runat="server" Text="保管者"
                                        meta:resourcekey="ckCustodyUserResource1" />
                                    <br />
                                    <br />
                                    &nbsp;<asp:CheckBox ID="ckDocComment" runat="server" Text="摘要"
                                        meta:resourcekey="ckDocCommentResource1" />
                                    <br />
                                    <br />
                                    &nbsp;<asp:CheckBox ID="ckDocKeyword" runat="server" Text="關鍵字"
                                        meta:resourcekey="ckDocKeywordResource1" />
                                    <br />
                                    <br />
                                    &nbsp;<asp:CheckBox ID="ckDocType" runat="server" Text="文件類別"
                                        meta:resourcekey="ckDocTypeResource1" />
                                    <br />
                                    <br />
                                    &nbsp;<asp:CheckBox ID="ckDocReflink" runat="server" Text="參考文件"
                                        meta:resourcekey="ckDocReflinkResource1" />
                                    <br />
                                    <br />
                                    &nbsp;<asp:CheckBox ID="ckVerMemo" runat="server" Text="版本備註" meta:resourcekey="ckVerMemoResource1" />
                                    <br />
                                    <br />
                                </td>
                                <td>
                                    <telerik:RadTabStrip ID="RadTabStripProperty" runat="server" SelectedIndex="0" MultiPageID="RadMultiPageProperty">
                                        <Tabs>
                                            <telerik:RadTab runat="server" Text="自訂屬性" meta:resourceKey="CustomizePropertyResource1">
                                            </telerik:RadTab>                                            
                                        </Tabs>
                                    </telerik:RadTabStrip>

                                    <telerik:RadMultiPage ID="RadMultiPageProperty" runat="server" SelectedIndex="0">
                                        <telerik:RadPageView ID="RadPageProperty" runat="server">
                                            <telerik:RadToolBar ID="RadCustomizeProperty" runat="server" Width="100%" OnClientButtonClicking="RadCustomizeProperty_ButtonClicking" OnButtonClick="RadCustomizeProperty_ButtonClick">
                                                <Items>
                                                    <telerik:RadToolBarButton Value="AddCustomizeProperty" runat="server" Text="新增" meta:resourceKey="AddCustomizePropertyResource1"
                                                        ImageUrl="~/Common/Images/Icon/icon_m02.gif">
                                                    </telerik:RadToolBarButton>
                                                    <telerik:RadToolBarButton IsSeparator="true"></telerik:RadToolBarButton>
                                                    <telerik:RadToolBarButton Value="DeleteCustomizeProperty" runat="server" Text="刪除" meta:resourceKey="DeleteCustomizePropertyResource1"
                                                        ImageUrl="~/Common/Images/Icon/icon_m03.gif">
                                                    </telerik:RadToolBarButton>
                                                    <telerik:RadToolBarButton IsSeparator="true"></telerik:RadToolBarButton>
                                                </Items>
                                            </telerik:RadToolBar>
                                            <Fast:Grid ID="GridCustomizeProperty" runat="server" AutoGenerateCheckBoxColumn="True" DataKeyNames="PROPERTY_ID" AllowPaging="true" OnPageIndexChanging="GridCustomizeProperty_PageIndexChanging"
                                                AutoGenerateColumns="False" OnRowDataBound="GridCustomizeProperty_RowDataBound" Width="100%" EnhancePager="True" PageSize="15" EmptyDataText="沒有資料" KeepSelectedRows="False" CustomDropDownListPage="False" DataKeyOnClientWithCheckBox="False" DefaultSortDirection="Ascending" SelectedRowColor="" UnSelectedRowColor="" AllowSorting="True">
                                                <ExportExcelSettings AllowExportToExcel="False" />
                                                <EnhancePagerSettings
                                                    ShowHeaderPager="false" FirstAltImageUrl="" FirstImageUrl="" LastAltImage=""
                                                    LastImageUrl="" NextIAltImageUrl="" NextImageUrl="" PageInfoCssClass=""
                                                    PageNumberCssClass="" PageNumberCurrentCssClass="" PageRedirectCssClass=""
                                                    PreviousAltImageUrl="" PreviousImageUrl="" />
                                                <Columns>
                                                    <asp:TemplateField HeaderText="屬性標題" meta:resourceKey="PropertyNameResource1">
                                                        <ItemTemplate>
                                                            <asp:LinkButton ID="lbtnPropertyName" runat="server" Text='<%# Bind("PROPERTY_NAME") %>' OnClick="lbtnPropertyName_Click"></asp:LinkButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="屬性型態" meta:resourceKey="PropertyTypeResource1">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblPropertyType" runat="server"></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="是否必填" meta:resourceKey="IsMandatoryResource1">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblIsMandatory" runat="server"></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="屬性順序" meta:resourceKey="OrdersResource1">
                                                        <ItemTemplate>
                                                            <table>
                                                                <tr align="left">
                                                                    <td style="width: 50%; white-space: nowrap">
                                                                        <asp:Panel ID="palUp" runat="server">
                                                                            <img id="Img1" src="~/Common/Images/Icon/icon_m113.png" runat="server"
                                                                                border="0" />
                                                                            <asp:LinkButton ID="lbtnUp" runat="server" CommandName="Up" CommandArgument='<%# Eval("PROPERTY_ID") %>'
                                                                                OnCommand="lbtnChangeOrder_Command" Text="往上移" meta:resourceKey="MoveUpResource1">
                                                                            </asp:LinkButton>
                                                                        </asp:Panel>
                                                                    </td>
                                                                    <td style="width: 50%; white-space: nowrap">
                                                                        <asp:Panel ID="palDown" runat="server">
                                                                            <img id="Img2" src="~/Common/Images/Icon/icon_m114.png" runat="server"
                                                                                border="0" />
                                                                            <asp:LinkButton ID="lbtnDown" runat="server" CommandName="Down" CommandArgument='<%# Eval("PROPERTY_ID") %>'
                                                                                OnCommand="lbtnChangeOrder_Command" Text="往下移" meta:resourceKey="MoveDownResource1">
                                                                            </asp:LinkButton>
                                                                        </asp:Panel>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </ItemTemplate>
                                                        <ItemStyle Width="100px" />
                                                    </asp:TemplateField>
                                                </Columns>
                                                <HeaderStyle HorizontalAlign="Center" Wrap="false" />
                                            </Fast:Grid>
                                        </telerik:RadPageView>                                        
                                    </telerik:RadMultiPage>
                                </td>
                            </tr>
                        </table>                        
                    </ContentTemplate>
                </asp:UpdatePanel>
            </asp:WizardStep>
            <asp:WizardStep ID="WizardStep3" runat="server" Title="浮水印設定與封面" meta:resourcekey="WizardStepResource5">                                      
                <span id="spMacrocosmWater">
                    <asp:CheckBox ID="cbMacrocosmWater" runat="server" Text="使用全域設定" AutoPostBack="True" OnCheckedChanged="cbMacrocosmWater_CheckedChanged" meta:resourcekey="cbMacrocosmWaterResource5" />

                    <br />
                    <span id="spParentWater">
                        <asp:CheckBox ID="cbInheritParentWater" runat="server" Text="使用父目錄的浮水印設定與封面" AutoPostBack="True" OnCheckedChanged="cbInheritParentWater_CheckedChanged" meta:resourcekey="cbInheritParentWaterResource5" />
                    </span>
                    <br />
                    <asp:CheckBox ID="cbChangeChildWater" runat="server" Text="套用變更到此目錄及子目錄" meta:resourcekey="cbChangeChildWaterResource5" />
                    <br />
                </span>
                <telerik:RadButton ID="RbtnVerticalPreview" runat="server" Text="直向預覽" OnClick="RbtnVerticalPrevirw_Click" AutoPostBack="False" meta:resourcekey="RbtnVerticalPrevirwResource1"></telerik:RadButton>
                <telerik:RadButton ID="RbtnHorizontalPreview" runat="server" Text="橫向預覽" AutoPostBack="False" meta:resourcekey="RbtnHorizontalPreviewResource1"></telerik:RadButton>                
                <br />
                <telerik:RadTabStrip ID="RadTabStripWaterAndCover" runat="server" SelectedIndex="0" MultiPageID="RadMultiPageWaterAndCover">
                    <Tabs>
                        <telerik:RadTab runat="server" Text="浮水印設定" meta:resourceKey="WaterMarkResource1">
                        </telerik:RadTab>
                        <telerik:RadTab runat="server" Text="文件封面" meta:resourceKey="DocCoverResource1">
                        </telerik:RadTab>
                    </Tabs>
                </telerik:RadTabStrip>

                <telerik:RadMultiPage ID="RadMultiPageWaterAndCover" runat="server" SelectedIndex="0">
                    <telerik:RadPageView ID="RadPageWater" runat="server">
                        <table id="tablePDFSet" cellpadding="0" cellspacing="0" style="width: 100%; border: 1px solid #999999">
                    <tr style="border: 1px ridge #FFF">
                        <td bgcolor="#cccccc" colspan="2">
                            <asp:CheckBox ID="chkUseTxt" runat="server" meta:resourceKey="chkUseTxtResource1"
                                Text="使用文字浮水印" />                            
                        </td>
                    </tr>
                    <tr style="border: #999999 solid 1px">


                        <td bgcolor="#ffffff" style="width: 50%; height: 98px; border: 1px ridge #FFF" valign="top">
                            <div id="divTxtDL">
                                <br />
                                <asp:CheckBox ID="chkDlUser" runat="server" Text="下載者的姓名及部門" meta:resourcekey="chkDlUserResource5" />
                            </div>

                        </td>
                        <td style="height: 98px; width: 50%;" bgcolor="#ffffff">

                            <div id="txtSetting">
                                <table cellpadding="1" cellspacing="1" style="height: 100%; border: #ffffff solid 1px">
                                    <tr>
                                        <td bgcolor="#cccccc" align="right" style="width: 90px; height: 25px; border: #ffffff solid 1px">
                                            <asp:Label ID="Label3" runat="server" Text="旋轉角度：" meta:resourcekey="Label6Resource1"></asp:Label></td>
                                        <td style="height: 25px; border: #ffffff solid 1px">
                                            <asp:DropDownList ID="ddlTxtRotation" runat="server"
                                                meta:resourcekey="ddlTxtRotationResource1">
                                                <asp:ListItem meta:resourcekey="ListItemResource1">0</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource2">5</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource4">10</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource7">15</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource8">20</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource9">25</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource10">30</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource11">35</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource12">40</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource13">45</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource14">50</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource15">55</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource16">60</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource17">65</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource18">70</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource19">75</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource20">80</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource21">85</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource22">90</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="#cccccc" align="right" style="height: 25px; border: #ffffff solid 1px">
                                            <asp:Label ID="Label4" runat="server" Text="文字顏色：" meta:resourcekey="Label4Resource1"></asp:Label></td>
                                        <td style="width: 158px; height: 25px; border: #ffffff solid 1px">
                                            <telerik:RadColorPicker ID="colorPicker1" runat="server" Preset="Standard" ShowIcon="true" EnableCustomColor="true" ShowRecentColors="true" ShowEmptyColor="false" Width="300px" meta:resourcekey="colorPicker1Resource1">
                                                <Localization RGBSlidersTabText=" RGB Sliders"></Localization>
                                            </telerik:RadColorPicker>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td bgcolor="#cccccc" align="right" style="height: 25px; border: #ffffff solid 1px">
                                            <asp:Label ID="Label8" runat="server" Text="文字大小：" meta:resourcekey="Label5Resource1"></asp:Label></td>
                                        <td style="height: 25px; border: #ffffff solid 1px">
                                            <asp:DropDownList ID="ddlTxtSize" runat="server" Width="46px"
                                                meta:resourcekey="ddlTxtSizeResource1">
                                                <asp:ListItem meta:resourcekey="ListItemResource143">5</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource144">10</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource20">15</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource23" Selected="True">20</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource24">25</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource25">30</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource26">35</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource27">40</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource28">45</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource29">50</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource30">55</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource31">60</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource32">65</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource33">70</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource40">75</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource41">80</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right" bgcolor="#cccccc" style="height: 25px; border: #ffffff solid 1px">
                                            <asp:Label ID="Label14" runat="server" Text="透明度："
                                                meta:resourcekey="Label14Resource1"></asp:Label></td>
                                        <td style="height: 25px; border: #ffffff solid 1px">
                                            <asp:DropDownList ID="ddlTransparency1" runat="server" meta:resourcekey="ddlTransparency1Resource1">
                                                <asp:ListItem meta:resourcekey="ListItemResource162">0</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource163">10</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource164">20</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource165">30</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource166">40</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource167">50</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource168">60</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource169">70</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource170" Selected="True">80</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource171">90</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource172">100</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                </table>

                            </div>
                        </td>
                    </tr>
                    <tr style="border: #999999 solid 1px">
                        <td bgcolor="#ffffff" colspan="2" style="height: 50px;" valign="top">
                            <asp:Label ID="Label9" runat="server" Text="文字浮水印顯示位置：" meta:resourcekey="Label3Resource1"></asp:Label>
                            <div id="txtPosition">
                                <asp:RadioButtonList ID="rdoTxtPosition" runat="server"
                                    RepeatDirection="Horizontal" meta:resourcekey="rdoTxtPositionResource1">
                                    <asp:ListItem Value="PosAll" Selected="True" meta:resourcekey="ListItemResource34" Text="全部填滿"></asp:ListItem>
                                    <asp:ListItem Value="PosCenter" meta:resourcekey="ListItemResource35" Text="置中"></asp:ListItem>
                                    <asp:ListItem Value="PosLeftUp" meta:resourcekey="ListItemResource36" Text="左上角"></asp:ListItem>
                                    <asp:ListItem Value="PosRightUp" meta:resourcekey="ListItemResource37" Text="右上角"></asp:ListItem>
                                    <asp:ListItem Value="PosLeftDown" meta:resourcekey="ListItemResource38" Text="左下角"></asp:ListItem>
                                    <asp:ListItem Value="PosRightDown" meta:resourcekey="ListItemResource39" Text="右下角"></asp:ListItem>
                                </asp:RadioButtonList>
                            </div>
                        </td>
                    </tr>
                    <tr style="border: #999999 solid 1px">
                        <td bgcolor="#ffffff" style="width: 50%; height: 87px; border: #999999 solid 1px" valign="top">
                            <div id="divTxtDL2">
                                <asp:CheckBox ID="chkDefText" runat="server" Text="自訂文字浮水印" meta:resourcekey="chkDefTextResource5" /><br />
                                <table style="width: 100%;">
                                    <tr>
                                        <td style="white-space: nowrap;">
                                            <asp:Label ID="Label1" runat="server" meta:resourceKey="Label1Resource1" Text="文字內容："></asp:Label>
                                        </td>
                                        <td style="vertical-align: top;">
                                            <asp:TextBox ID="txtDefText" runat="server" MaxLength="150" meta:resourceKey="txtDefTextResource1" Rows="3" TextMode="MultiLine" Width="280px"></asp:TextBox>
                                        </td>
                                    </tr>
                                </table>
                                <asp:CustomValidator ID="cvDefText" runat="server" Display="Dynamic" ErrorMessage="請填寫文字內容" meta:resourcekey="cvDefTextResource1"></asp:CustomValidator>
                            </div>
                        </td>
                        <td bgcolor="#ffffff" style="height: 87px; width: 50%;">
                            <div id="txtSetting2">
                                <table cellpadding="1" cellspacing="1" style="height: 100%; border: #999999 solid 1px">
                                    <tr style="border: #ffffff solid 1px">
                                        <td bgcolor="#cccccc" align="right" style="width: 90px; height: 25px;">
                                            <asp:Label ID="Label6" runat="server" meta:resourcekey="Label6Resource1" Text="旋轉角度："></asp:Label></td>
                                        <td style="height: 25px; border: #ffffff solid 1px">
                                            <asp:DropDownList ID="ddlTxtRotation2" runat="server"
                                                meta:resourcekey="ddlTxtRotation2Resource1">
                                                <asp:ListItem meta:resourcekey="ListItemResource1">0</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource2">5</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource4">10</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource7">15</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource8">20</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource9">25</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource10">30</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource11">35</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource12">40</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource13">45</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource14">50</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource15">55</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource16">60</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource17">65</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource18">70</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource19">75</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource20">80</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource21">85</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource22">90</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr style="border: #ffffff solid 1px">
                                        <td bgcolor="#cccccc" align="right" style="height: 25px">
                                            <asp:Label ID="Label7" runat="server" meta:resourcekey="Label4Resource1" Text="文字顏色："></asp:Label></td>
                                        <td style="width: 158px; height: 25px; border: #ffffff solid 1px">
                                            <telerik:RadColorPicker ID="ColorPicker2" runat="server" Preset="Standard" ShowIcon="true" EnableCustomColor="true" ShowRecentColors="true" ShowEmptyColor="false" Width="300px" meta:resourcekey="ColorPicker2Resource1">
                                                <Localization RGBSlidersTabText=" RGB Sliders"></Localization>
                                            </telerik:RadColorPicker>
                                        </td>
                                    </tr>
                                    <tr style="border: #ffffff solid 1px">
                                        <td bgcolor="#cccccc" align="right" style="height: 25px">
                                            <asp:Label ID="Label12" runat="server" meta:resourcekey="Label5Resource1" Text="文字大小："></asp:Label></td>
                                        <td style="height: 25px; border: #ffffff solid 1px">
                                            <asp:DropDownList ID="ddlTxtSize2" runat="server" Width="46px"
                                                meta:resourcekey="ddlTxtSize2Resource1">
                                                <asp:ListItem meta:resourcekey="ListItemResource145">5</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource146">10</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource20">15</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource23" Selected="True">20</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource24">25</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource25">30</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource26">35</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource27">40</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource28">45</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource29">50</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource30">55</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource31">60</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource32">65</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource33">70</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource40">75</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource41">80</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr style="border: #ffffff solid 1px">
                                        <td align="right" bgcolor="#cccccc" style="height: 25px">
                                            <asp:Label ID="Label15" runat="server" Text="透明度："
                                                meta:resourcekey="Label15Resource1"></asp:Label></td>
                                        <td style="height: 25px; border: #ffffff solid 1px">
                                            <asp:DropDownList ID="ddlTransparency2" runat="server" meta:resourcekey="ddlTransparency2Resource1">
                                                <asp:ListItem meta:resourcekey="ListItemResource173">0</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource174">10</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource175">20</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource176">30</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource177">40</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource178">50</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource179">60</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource180">70</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource181" Selected="True">80</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource182">90</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource183">100</asp:ListItem>
                                            </asp:DropDownList>

                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                    <tr style="border: #999999 solid 1px">
                        <td bgcolor="#ffffff" style="height: 54px" valign="top" colspan="2">
                            <asp:Label ID="Label13" runat="server" meta:resourcekey="Label3Resource1" Text="文字浮水印顯示位置："></asp:Label>
                            <div id="txtPosition2">
                                <asp:RadioButtonList ID="rdoTxtPosition2" runat="server"
                                    RepeatDirection="Horizontal" meta:resourcekey="rdoTxtPosition2Resource1">
                                    <asp:ListItem meta:resourcekey="ListItemResource34" Selected="True" Text="全部填滿" Value="PosAll"></asp:ListItem>
                                    <asp:ListItem meta:resourcekey="ListItemResource35" Text="置中" Value="PosCenter"></asp:ListItem>
                                    <asp:ListItem meta:resourcekey="ListItemResource36" Text="左上角" Value="PosLeftUp"></asp:ListItem>
                                    <asp:ListItem meta:resourcekey="ListItemResource37" Text="右上角" Value="PosRightUp"></asp:ListItem>
                                    <asp:ListItem meta:resourcekey="ListItemResource38" Text="左下角" Value="PosLeftDown"></asp:ListItem>
                                    <asp:ListItem meta:resourcekey="ListItemResource39" Text="右下角" Value="PosRightDown"></asp:ListItem>
                                </asp:RadioButtonList>
                            </div>
                        </td>
                    </tr>
                    <tr style="border: #999999 solid 1px">
                        <td bgcolor="#ffffff" colspan="2" style="height: 0px"></td>
                    </tr>
                    <tr style="border: #999999 solid 1px">
                        <td bgcolor="#cccccc" colspan="2" style="border: #999999 solid 1px">

                            <asp:CheckBox ID="chkUseImg" runat="server" meta:resourceKey="chkUseImgResource1"
                                Text="使用圖形浮水印" />
                            <asp:CustomValidator ID="cvUseIMG" runat="server" Display="Dynamic" ErrorMessage="請選擇圖形浮水印" meta:resourcekey="cvUseIMGResource1"></asp:CustomValidator>

                        </td>
                    </tr>
                    <tr style="border: #999999 solid 1px">
                        <td bgcolor="#ffffff" style="width: 50%; height: 148px; border: #999999 solid 1px">
                            <div id="imgWater">
                                <uc1:UC_FileCenter runat="server" ID="UC_FileCenter" ProxyEnabled="False" />
                            </div>
                        </td>
                        <td bgcolor="#ffffff" style="height: 148px; width: 50%;">
                            <div id="imgRot">
                                <table style="border: #999999 solid 1px;">
                                    <tr style="border: #999999 solid 1px">
                                        <td align="right" bgcolor="#cccccc" style="width: 90px; border: 1px solid #ffffff">
                                            <asp:Label ID="Label10" runat="server" meta:resourceKey="Label6Resource1" Text="旋轉角度："></asp:Label>
                                        </td>
                                        <td style="width: 158px; border: 1px solid #ffffff">
                                            <asp:DropDownList ID="ddlImgRotation" runat="server"
                                                meta:resourcekey="ddlImgRotationResource1">
                                                <asp:ListItem meta:resourceKey="ListItemResource42">0</asp:ListItem>
                                                <asp:ListItem meta:resourceKey="ListItemResource43">5</asp:ListItem>
                                                <asp:ListItem meta:resourceKey="ListItemResource44">10</asp:ListItem>
                                                <asp:ListItem meta:resourceKey="ListItemResource45">15</asp:ListItem>
                                                <asp:ListItem meta:resourceKey="ListItemResource46">20</asp:ListItem>
                                                <asp:ListItem meta:resourceKey="ListItemResource47">25</asp:ListItem>
                                                <asp:ListItem meta:resourceKey="ListItemResource48">30</asp:ListItem>
                                                <asp:ListItem meta:resourceKey="ListItemResource49">35</asp:ListItem>
                                                <asp:ListItem meta:resourceKey="ListItemResource50">40</asp:ListItem>
                                                <asp:ListItem meta:resourceKey="ListItemResource51">45</asp:ListItem>
                                                <asp:ListItem meta:resourceKey="ListItemResource52">50</asp:ListItem>
                                                <asp:ListItem meta:resourceKey="ListItemResource53">55</asp:ListItem>
                                                <asp:ListItem meta:resourceKey="ListItemResource54">60</asp:ListItem>
                                                <asp:ListItem meta:resourceKey="ListItemResource55">65</asp:ListItem>
                                                <asp:ListItem meta:resourceKey="ListItemResource56">70</asp:ListItem>
                                                <asp:ListItem meta:resourceKey="ListItemResource57">75</asp:ListItem>
                                                <asp:ListItem meta:resourceKey="ListItemResource58">80</asp:ListItem>
                                                <asp:ListItem meta:resourceKey="ListItemResource65">85</asp:ListItem>
                                                <asp:ListItem meta:resourceKey="ListItemResource66">90</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr style="border: #999999 solid 1px">
                                        <td align="right" bgcolor="#cccccc" style="width: 90px; border: 1px solid #ffffff">
                                            <asp:Label ID="Label36" runat="server" Text="透明度：" meta:resourceKey="Label36Resource1"></asp:Label>
                                        </td>
                                        <td style="width: 158px; border: 1px solid #ffffff">
                                            <asp:DropDownList ID="ddlimageTransparency" runat="server" meta:resourcekey="ddlimageTransparencyResource1">
                                                <asp:ListItem meta:resourcekey="ListItemResource186">0</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource187">10</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource188">20</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource189">30</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource190">40</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource191">50</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource192">60</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource193">70</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource194">80</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource195">90</asp:ListItem>
                                                <asp:ListItem meta:resourcekey="ListItemResource196">100</asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#ffffff" colspan="2" style="height: 35px; border: #999999 solid 1px">
                            <asp:Label ID="Label11" runat="server" meta:resourceKey="Label8Resource1" Text="圖片浮水印顯示位置："></asp:Label>
                            <div id="imgPosition">
                                <asp:RadioButtonList ID="rdoImgPosition" runat="server" RepeatDirection="Horizontal"
                                    meta:resourcekey="rdoImgPositionResource1">
                                    <asp:ListItem Value="PosAll" Selected="True" meta:resourcekey="ListItemResource59" Text="全部填滿"></asp:ListItem>
                                    <asp:ListItem Value="PosCenter" meta:resourcekey="ListItemResource60" Text="置中"></asp:ListItem>
                                    <asp:ListItem Value="PosLeftUp" meta:resourcekey="ListItemResource61" Text="左上角"></asp:ListItem>
                                    <asp:ListItem Value="PosRightUp" meta:resourcekey="ListItemResource62" Text="右上角"></asp:ListItem>
                                    <asp:ListItem Value="PosLeftDown" meta:resourcekey="ListItemResource63" Text="左下角"></asp:ListItem>
                                    <asp:ListItem Value="PosRightDown" meta:resourcekey="ListItemResource64" Text="右下角"></asp:ListItem>
                                </asp:RadioButtonList>
                            </div>
                        </td>
                    </tr>
                    <tr style="border: 1px ridge #fff;">
                        <td bgcolor="#cccccc" colspan="2">
                            <asp:CheckBox ID="chkSysDate" runat="server"
                                Text="顯示系統日期" meta:resourcekey="chkSysDateResource1" />
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#cccccc" colspan="2">
                            <asp:CheckBox ID="chkSysPath" runat="server"
                                Text="顯示文件路徑" meta:resourcekey="chkSysPathResource1" />
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#ffffff" colspan="2" style="height: 0px"></td>
                    </tr>
                </table>                        
                    </telerik:RadPageView>
                    <telerik:RadPageView ID="RadPageCover" runat="server">                        
                        <asp:Image ID="ImgCoverPreview" runat="server" Style="display: none" />
                        <table style="width:100%">
                            <tr>
                                <td style="white-space:nowrap;width:120px">
                                    &nbsp;<asp:CheckBox ID="chkAddSummary" runat="server" meta:resourceKey="chkAddSummaryResource1" Text="使用文件封面" />
                                </td>
                                <td style="white-space:nowrap;">
                                    <asp:RadioButtonList runat="server" ID="rblChoseCoverType" RepeatDirection="Horizontal" CellSpacing="0" CellPadding="0">
                                        <asp:ListItem Value="System" Text="系統預設" Selected="True" meta:resourceKey="SystemResource1"></asp:ListItem>
                                        <asp:ListItem Value="Custom" Text="自訂封面" meta:resourceKey="CustomResource1"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td>
                                    <asp:CheckBox ID="ckShowSignOffCourse" runat="server" Text="顯示簽核資訊" meta:resourcekey="ckShowSignOffCourseResource1" />
                                    <asp:CheckBox ID="cbShowVerHistory" runat="server" Text="顯示版本歷程" meta:resourcekey="cbShowVerHistoryResource1"/>
                                </td>
                            </tr>
                        </table>                                                                                                
                        <div runat="server" id="dvEditorDocCover">
                            <uc1:UC_HtmlEditor ID="UC_HtmlEditorDocCover" runat="server" Width="100%" Height="500px" EnableInsertFiles="false" />
                        </div>
                        <div class="editorcontentstyle JustAddBorder" style="width: 100%; height:100%">
                            <asp:Literal runat="server" ID="ltrDocCover"></asp:Literal>
                        </div>
                        <table id="dtDocCoverProperty" runat="server" style="width: 100%" class="PopTable" cellspacing="0" cellpadding="0">
                            <colgroup class="PopTableLeftTD" style="width: 20%"></colgroup>
                            <colgroup class="PopTableRightTD" style="width: 30%"></colgroup>
                            <colgroup class="PopTableLeftTD" style="width: 20%"></colgroup>
                            <colgroup class="PopTableRightTD" style="width: 30%"></colgroup>
                            <tr>
                                <td class="PopTableHeader" colspan="4" style="text-align: center!important">
                                    <asp:Label ID="Label37" runat="server" Text="系統屬性" meta:resourcekey="Label37Resource1"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td class="PopTableHeader" style="text-align: center!important">
                                    <asp:Label ID="lblPropertyParam" runat="server" Text="屬性代號"
                                        meta:resourcekey="lblPropertyParamResource1"></asp:Label>
                                </td>
                                <td class="PopTableHeader" style="text-align: center!important">
                                    <asp:Label ID="lblPropertyScrip" runat="server" Text="屬性說明"
                                        meta:resourcekey="lblPropertyScripResource1"></asp:Label>
                                </td>
                                <td class="PopTableHeader" style="text-align: center!important">
                                    <asp:Label ID="Label38" runat="server" Text="屬性代號"
                                        meta:resourcekey="lblPropertyParamResource1"></asp:Label>
                                </td>
                                <td class="PopTableHeader" style="text-align: center!important">
                                    <asp:Label ID="Label39" runat="server" Text="屬性說明"
                                        meta:resourcekey="lblPropertyScripResource1"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="lblPropIdauthor" runat="server" Text="{#author}"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblPropDescriptauthor" runat="server" Text="作者" meta:resourcekey="lblPropDescriptauthorResource1"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblPropIdfileName" runat="server" Text="{#fileName}"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblPropDescriptfileName" runat="server" Text="檔案名稱" meta:resourcekey="lblPropDescriptfileNameResource1"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="lblPropDocSerial" runat="server" Text="{#docSerial}"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblPropDescriptDocSerial" runat="server" Text="文件編號" meta:resourcekey="lblPropDescriptDocSerialResource1"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblPropIdversion" runat="server" Text="{#version}"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblPropDescriptversion" runat="server" Text="版本" meta:resourcekey="lblPropDescriptversionResource1"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="lblPropDocCategory" runat="server" Text="{#docCategory}"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblPropDescriptDocCategory" runat="server" Text="文件類別" meta:resourcekey="lblPropDescriptDocCategoryResource1"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblPropIdactiveDay" runat="server" Text="{#activeDay}"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblPropDescriptactiveDay" runat="server" Text="生效日" meta:resourcekey="lblPropDescriptactiveDayResource1"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="lblPropIdsecretRank" runat="server" Text="{#secretRank}"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblPropDescriptsecretRank" runat="server" Text="機密等級" meta:resourcekey="lblPropDescriptsecretRankResource1"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblPropIdpublicDay" runat="server" Text="{#publicDay}"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblPropDescriptpublicDay" runat="server" Text="公佈日" meta:resourcekey="lblPropDescriptpublicDayResource1"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="lblPropIdinvalidDay" runat="server" Text="{#invalidDay}"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblPropDescriptinvalidDay" runat="server" Text="到期日" meta:resourcekey="lblPropDescriptinvalidDayResource1"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblPropIddownloadTime" runat="server" Text="{#downloadTime}"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblPropDescriptdownloadTime" runat="server" Text="下載時間" meta:resourcekey="lblPropDescriptdownloadTimeResource1"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="lblPropIddownloadUser" runat="server" Text="{#downloadUser}"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblPropDescriptdownloadUser" runat="server" Text="下載者" meta:resourcekey="lblPropDescriptdownloadUserResource1"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblPropIdfolder" runat="server" Text="{#folder}"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblPropDescriptfolder" runat="server" Text="目錄" meta:resourcekey="lblPropDescriptfolderResource1"></asp:Label>
                                </td>                                
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="lblPropIddownloadCount" runat="server" Text="{#downloadCount}"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblPropDescriptdownloadCount" runat="server" Text="文件下載次數" meta:resourcekey="lblPropDescriptdownloadCountResource1"></asp:Label>
                                </td>

                                <td>
                                </td>
                                <td>
                                </td>
                            </tr>
                        </table>                        
                    </telerik:RadPageView>
                </telerik:RadMultiPage>                        


            </asp:WizardStep>
            <asp:WizardStep ID="WizardStep5" runat="server" Title="目錄代理訂閱" meta:resourcekey="WizardStep5Resource2">
                <asp:UpdatePanel ID="UpdatePanel7" runat="server">
                    <ContentTemplate>
                        &nbsp;<asp:CheckBox ID="chkAgentSubscribe" runat="server" Text="訂閱目錄文件" meta:resourcekey="chkAgentSubscribeResource1" />
                        <asp:CustomValidator ID="cvCheckSelect" runat="server" Display="Dynamic" ErrorMessage="請選擇通知時機" meta:resourcekey="cvCheckSelectResource1"></asp:CustomValidator>
                        <asp:CustomValidator ID="cvCheckError" runat="server" Display="Dynamic" ErrorMessage="設定目錄代理訂閱發生錯誤" meta:resourcekey="cvCheckErrorResource1"></asp:CustomValidator>
                        <br />
                        &nbsp;<img src="../../DMS/images/closed.gif" />&nbsp;
                     <asp:Label ID="lblFolder" runat="server" ForeColor="Blue" meta:resourcekey="lblFolderResource1"></asp:Label>
                        <asp:RadioButtonList ID="rbtnlistSubscribe" runat="server" meta:resourcekey="rbtnlistSubscribeResource1">
                            <asp:ListItem Selected="True" Value="false" Text="只訂閱此目錄下的文件" meta:resourcekey="ListItemResource150"></asp:ListItem>
                            <asp:ListItem Value="true" Text="訂閱此目錄及子目錄下的文件" meta:resourcekey="ListItemResource151"></asp:ListItem>
                        </asp:RadioButtonList>
                        <table class="PopTable">
                            <tr>
                                <td colspan="2" style="text-align: left; white-space: nowrap;">
                                    <asp:Label ID="Label22" runat="server" Font-Bold="True" Text="通知時機" meta:resourcekey="Label22Resource1"></asp:Label></td>
                            </tr>
                            <tr>
                                <td style="width: 109px; text-align: left">
                                    <asp:CheckBox ID="chkAllChange" runat="server" Text="任何變更" meta:resourcekey="chkAllChangeResource1" /></td>
                                <td style="width: 187px" align="left">&nbsp;<asp:CheckBox ID="chkNewDoc" runat="server" Text="新文件發佈" meta:resourcekey="chkNewDocResource1" /><br />
                                    &nbsp;<asp:CheckBox ID="chkVerChange" runat="server" Text="文件版本變更" meta:resourcekey="chkVerChangeResource1" /><br />
                                    &nbsp;<asp:CheckBox ID="chkDocVoid" runat="server" Text="文件作廢" meta:resourcekey="chkDocVoidResource1" /><br />
                                    &nbsp;<asp:CheckBox ID="chkDocDel" runat="server" Text="文件被銷毀" meta:resourcekey="chkDocDelResource1" />
                                </td>
                            </tr>
                        </table>
                        <div id="divAgentUser">
                            &nbsp;<asp:Label ID="Label23" runat="server" Text="代理訂閱對象" meta:resourcekey="Label23Resource1"></asp:Label>
                            <asp:CustomValidator ID="cvCheckAgentUser" runat="server" Display="Dynamic" ErrorMessage="請選取代理訂閱對象" meta:resourcekey="cvCheckAgentUserResource1"></asp:CustomValidator>

                            <uc1:UC_ChoiceList ID="UC_ChoiceListAgentUser" runat="server" ExpandToUser="false" />
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </asp:WizardStep>
            <asp:WizardStep ID="WizardStep6" runat="server" Title="分類設定"
                meta:resourcekey="WizardStep6Resource1">     
                <table border="1">
                    <tr>
                        <td colspan="2">
                            <asp:CheckBox ID="cbIncludeParent" runat="server" Text="連動勾選父類別" meta:resourcekey="cbIncludeParentResource1" />                            
                        </td>
                    </tr>
                    <tr>
                        <td style="width:15px">

                        </td>
                        <td>
                            <asp:Label ID="lblIncludeParent" runat="server" Text="備註:新增/維護文件勾選文件類別時，會連動勾選父類別" CssClass="SizeMemo" meta:resourcekey="lblIncludeParentResource1"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <asp:RadioButtonList ID="rdoClassList" runat="server" AutoPostBack="True" RepeatDirection="Horizontal"
                                OnSelectedIndexChanged="rdoClassList_SelectedIndexChanged"
                                meta:resourcekey="rdoClassListResource1">
                                <asp:ListItem Value="false" Text="不限制可選分類"
                                    meta:resourcekey="ListItemResource152"></asp:ListItem>
                                <asp:ListItem Value="true" Text="限制可選分類" meta:resourcekey="ListItemResource153"></asp:ListItem>
                            </asp:RadioButtonList>
                            <input id="hidClickValue" type="hidden" runat="server" />
                        </td>
                    </tr>
                </table>           
                <telerik:RadTreeView ID="classTree1" runat="server" CheckBoxes="True" Height="100%" meta:resourceKey="classTree1Resource1" OnClientNodeChecked="myClassTree_NodeChecked" TriStateCheckBoxes="False" Width="100%">
                </telerik:RadTreeView>
            </asp:WizardStep>
            <asp:WizardStep ID="WizardStep7" runat="server" Title="內文預設值" meta:resourcekey="WizardStep7Resource1">
                <uc5:UC_HtmlEditor ID="UC_HtmlEditor1" runat="server" Width="100%" Height="500px" ProxyEnabled="true" />
            </asp:WizardStep>
            <asp:WizardStep ID="WizardStep8" runat="server" Title="文件編號設定"
                meta:resourcekey="WizardStep8Resource1">
                <asp:UpdatePanel ID="UpdatePanel10" runat="server">
                    <ContentTemplate>
                        <table border="0" class="PopTable" cellspacing="1">
                            <tr>
                                <td style="white-space: nowrap;">
                                    <asp:Label ID="Label27" runat="server" Text="文件目錄" meta:resourcekey="Label27Resource1"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblDocFolder" runat="server" meta:resourcekey="lblDocFolderResource1"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="white-space: nowrap;">
                                    <asp:Label ID="Label28" runat="server" Text="編號方式" meta:resourcekey="Label28Resource1"></asp:Label>
                                </td>
                                <td>
                                    <asp:RadioButtonList ID="rdoAutoDocNum" runat="server" AutoPostBack="True" RepeatDirection="Horizontal"
                                        OnSelectedIndexChanged="rdoAutoDocNum_SelectedIndexChanged"
                                        meta:resourcekey="rdoAutoDocNumResource1">
                                        <asp:ListItem Value="true" Text="自動編號" meta:resourcekey="ListItemResource154"></asp:ListItem>
                                        <asp:ListItem Value="false" Text="手動編號" meta:resourcekey="ListItemResource155"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </td>
                            </tr>
                            <tr>
                                <td style="white-space: nowrap;">
                                    <asp:Label ID="Label29" runat="server" Text="文件編號字軌" meta:resourcekey="Label29Resource1"></asp:Label>
                                </td>
                                <td style="white-space: nowrap;">
                                    <asp:DropDownList ID="ddlAutoSerial" runat="server" AutoPostBack="True"
                                        OnSelectedIndexChanged="ddlAutoSerial_SelectedIndexChanged"
                                        meta:resourcekey="ddlAutoSerialResource1">
                                    </asp:DropDownList>
                                    &nbsp;
                                    <telerik:RadButton ID="wbtnSetAutoSerial" runat="server" Text="字軌設定" meta:resourcekey="wbtnSetAutoSerialResource1" OnClick="wbtnSetAutoSerial_Click"></telerik:RadButton>
                                    <asp:HiddenField ID="hfSelectedSerial" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <td style="white-space: nowrap;">
                                    <asp:Label ID="Label34" runat="server" Text="起始流水號" meta:resourcekey="Label34Resource1"></asp:Label>
                                </td>
                                <td style="white-space: nowrap;">
                                    <telerik:RadNumericTextBox Width="100px" Value="1" ID="rntbInitialSerialNo" runat="server" DataType="System.Int32" MinValue="1" Culture="zh-TW" DbValueFactor="1" LabelCssClass="" LabelWidth="64px" meta:resourcekey="rntbInitialSerialNoResource1">
                                        <NegativeStyle Resize="None" />
                                        <NumberFormat DecimalDigits="0" GroupSeparator="" ZeroPattern="n" AllowRounding="False" />
                                        <EmptyMessageStyle Resize="None" />
                                        <ReadOnlyStyle Resize="None" />
                                        <FocusedStyle Resize="None" />
                                        <DisabledStyle Resize="None" />
                                        <InvalidStyle Resize="None" />
                                        <HoveredStyle Resize="None" />
                                        <EnabledStyle Resize="None" />
                                    </telerik:RadNumericTextBox>
                                    <asp:Label ID="Label35" runat="server" Text="此設定僅使用於尚未使用的字軌" CssClass="SizeMemo" meta:resourcekey="Label35Resource1"></asp:Label><br />
                                    <asp:RequiredFieldValidator ID="rfvInitialSerialNo" runat="server" ErrorMessage="請輸入起始流水號" ControlToValidate="rntbInitialSerialNo" Display="Dynamic" meta:resourcekey="rfvInitialSerialNoResource1"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <td style="white-space: nowrap;">
                                    <asp:Label ID="Label30" runat="server" Text="流水號位數"
                                        meta:resourcekey="Label30Resource1"></asp:Label>
                                </td>
                                <td style="white-space: nowrap;">
                                    <asp:Label ID="lblCurrentSerial" runat="server"
                                        meta:resourcekey="lblCurrentSerialResource1"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="white-space: nowrap;">
                                    <asp:Label ID="Label31" runat="server" Text="目前流水號"
                                        meta:resourcekey="Label31Resource1"></asp:Label>
                                </td>
                                <td style="white-space: nowrap;">
                                    <asp:Label ID="lblMaxSerial" runat="server"
                                        meta:resourcekey="lblMaxSerialResource1"></asp:Label>
                                </td>
                            </tr>
                        </table>
                        <asp:CustomValidator ID="cvNonAutoSerial" runat="server" ErrorMessage="請選擇自動編號字軌" Display="None" meta:resourcekey="cvNonAutoSerialResource1"></asp:CustomValidator>
                        <asp:CustomValidator ID="cvInitialSerialNo" runat="server" ErrorMessage="起始流水號位數不能大於字軌設定的流水號位數" Display="None" meta:resourcekey="cvInitialSerialNoResource1"></asp:CustomValidator>
                        <asp:Label ID="lblSerialNoUse" runat="server" Text="此流水號尚未被使用" Visible="False" meta:resourcekey="lblSerialNoUseResource1"></asp:Label>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </asp:WizardStep>            
        </WizardSteps>
        <SideBarButtonStyle ForeColor="White" />
        <HeaderStyle BackColor="Silver" BorderColor="#E6E2D8" BorderStyle="Solid" BorderWidth="2px" Font-Bold="False" ForeColor="Black" HorizontalAlign="Center" />
        <StartNavigationTemplate>
        </StartNavigationTemplate>
        <SideBarTemplate>
            <asp:DataList ID="SideBarList" runat="server" HorizontalAlign="Left" OnItemDataBound="SideBarList_ItemDataBound" meta:resourcekey="SideBarListResource1">
                <ItemTemplate>
                    &nbsp;&nbsp;<asp:Image ID="imgSideBar" runat="server" ImageAlign="Baseline" meta:resourcekey="imgSideBarResource1" />
                    <asp:LinkButton ID="SideBarButton" runat="server" ForeColor="Black" meta:resourcekey="SideBarButtonResource1"></asp:LinkButton>&nbsp;
                    <br />
                    <br />
                </ItemTemplate>
                <SelectedItemStyle Font-Bold="True" />
            </asp:DataList>
        </SideBarTemplate>
        <StepNavigationTemplate>
        </StepNavigationTemplate>
        <FinishNavigationTemplate>
        </FinishNavigationTemplate>
    </asp:Wizard>

    <asp:Label ID="lblManager" runat="server" Text="目錄管理者" Visible="False" meta:resourcekey="lblManagerResource1"></asp:Label>
    <asp:Label ID="lblAuthor" runat="server" Text="作者" Visible="False" meta:resourcekey="lblAuthorResource1"></asp:Label>
    <asp:Label ID="lblReader" runat="server" Text="讀者" Visible="False" meta:resourcekey="lblReaderResource1"></asp:Label>
    <asp:Label ID="labUseWKF" runat="server" Text="使用電子簽核，請選擇簽核流程" Visible="False" meta:resourcekey="labUseWKFResource1"></asp:Label>
    <asp:Label ID="lanNoApprove" runat="server" Text="此目錄無設定目錄管理者，無法進行審核設定" Visible="False" meta:resourcekey="lanNoApproveResource1"></asp:Label>
    <asp:Label ID="labDefApprove" runat="server" Text="由下列任一人員審核通過即可" Visible="False" meta:resourcekey="labDefApproveResource1"></asp:Label>
    <asp:Label ID="lblFolderPath" runat="server" Text="引用目錄：" Visible="False" meta:resourcekey="lblFolderPathResource1"></asp:Label>
    <asp:Label ID="labDocStore" runat="server" Text="文件庫" Visible="False" meta:resourcekey="labDocStoreResource1"></asp:Label>
    <asp:Label ID="lblCheckDeleteChildDocData" runat="server" Visible="False" Text="設定作者不可自行設定「」，目錄下的文件「」將被移除，請問是否要繼續?" meta:resourcekey="lblCheckDeleteChildDocDataResource1"></asp:Label>
    <asp:Label ID="lblEditForm" runat="server" Text="編輯流程" Visible="False" meta:resourcekey="lblEditFormResource1"></asp:Label>
    <asp:Label ID="lblShowForm" runat="server" Text="觀看流程" Visible="False" meta:resourcekey="lblShowFormResource1"></asp:Label>
    <asp:Label ID="lblNoWKFFlow2" runat="server" Text="電子簽核沒有流程，請先新增流程" Visible="False" meta:resourcekey="lblNoWKFFlow2Resource1"></asp:Label>
    <asp:HiddenField ID="hidFolderID" runat="server" />
    <input id="hidNoAuthSet" type="hidden" runat="server" />
    <input id="hidSelectColor" runat="server" value="#F9E7E8" style="width: 31px" type="hidden" />
    <input id="hidSelectColor2" runat="server" value="#F9E7E8" style="width: 31px" type="hidden" />
    <asp:HiddenField ID="hidChangeToPDF" runat="server" />
    <asp:HiddenField ID="hidWaterViewState" runat="server" />
    <asp:Label ID="lblFolderIsDelete" runat="server" Text="目錄已被刪除" Visible="False" meta:resourcekey="lblFolderIsDeleteResource1"></asp:Label>
    <asp:HiddenField ID="hidIsCpoy" runat="server" />
    <asp:Label ID="lblIsCpoy" runat="server" Text="是否要複製父目錄的權限設定到此目錄?" Visible="False" meta:resourcekey="lblIsCpoyResource1"></asp:Label>
    <asp:Label ID="lblSelectMsg" runat="server" Text="請選擇" Visible="False" meta:resourcekey="lblSelectMsgResource1"></asp:Label>
    <asp:Label ID="lblWatermarkPic" runat="server" Text="請選擇浮水印檔案" Visible="False" meta:resourcekey="lblWatermarkPicResource1"></asp:Label>
    <asp:Label ID="lblSelectMem" runat="server" Text="人員" Visible="False" meta:resourcekey="lblSelectMemResource1"></asp:Label>
    <asp:Label ID="lblEmptyFlow" runat="server" Text="=======請選擇流程=======" meta:resourcekey="lblEmptyFlowResource1" Visible="False"></asp:Label>
    <asp:Label ID="lblClass" runat="server" Text="文件類別" Visible="False" meta:resourcekey="lblClassResource1"></asp:Label>
    <asp:Label ID="lblAutoSerialTitle" runat="server" Text="設定文件編號字軌" Visible="False" meta:resourcekey="lblAutoSerialTitleResource1"></asp:Label>
    <asp:Label ID="lblSelect" runat="server" Text="請選擇" meta:resourcekey="lblSelectResource1" Visible="False"></asp:Label>
    <asp:Label ID="lblVersionCarryError" runat="server" Text="進號小數不可為0" Visible="False" meta:resourcekey="lblVersionCarryErrorResource1"></asp:Label>
    <asp:HiddenField ID="hidAllowPrint" runat="server" />
    <asp:HiddenField ID="hfAllowIdenticalName" runat="server" />
    <asp:HiddenField ID="hfAllowVersionCarry" runat="server" />
    <asp:HiddenField ID="hfVersionCarryDigit" runat="server" />
    <asp:HiddenField ID="hfInitialValue" runat="server" />
    <asp:HiddenField ID="hfIsViewDraft" runat="server" />
    <asp:HiddenField ID="hfDocMode" runat="server" />
    <asp:HiddenField ID="hfAuthorPrintControl" runat="server" />
    <asp:HiddenField ID="hfAuthorDocChange" runat="server" />
    <asp:Label ID="Label33" runat="server" Text="進號小數不可為0" Visible="False" meta:resourcekey="lblVersionCarryErrorResource1"></asp:Label>
    <asp:Label ID="lblMaintainFlow" runat="server" Text="維護流程" Visible="False" meta:resourcekey="lblMaintainFlowResource1"></asp:Label>
    <asp:Label ID="lblPropertyTypeTextBox" runat="server" Text="文字" Visible="False" meta:resourcekey="lblPropertyTypeTextBoxResource1"></asp:Label>
    <asp:Label ID="lblPropertyTypeDate" runat="server" Text="日期" Visible="False" meta:resourcekey="lblPropertyTypeDateResource1"></asp:Label>
    <asp:Label ID="lblIsMandatoryTrue" runat="server" Text="是" Visible="False" meta:resourcekey="lblIsMandatoryTrueResource1"></asp:Label>
    <asp:Label ID="lblIsMandatoryFalse" runat="server" Text="否" Visible="False" meta:resourcekey="lblIsMandatoryFalseResource1"></asp:Label>
    <asp:Label ID="lblCustProperty" runat="server" Text="自訂屬性" Visible="False" meta:resourcekey="lblCustPropertyResource1"></asp:Label>
    <asp:Label ID="lblTempValue" runat="server" Text="視實際資料而定" Visible="False" meta:resourcekey="lblTempValueResource1"></asp:Label>
    <asp:Label ID="lblContentEmpty" runat="server" Text="請先設定文件封面內容" Visible="False" meta:resourcekey="lblContentEmptyResource1"></asp:Label>
    <asp:Label ID="lblAddCustomizeProperty" runat="server" Text="新增/維護自訂屬性" Visible="False" meta:resourcekey="lblAddCustomizePropertyResource1"></asp:Label>    
    <asp:Label ID="lblPDFPreview" runat="server" Visible="False" meta:resourcekey="btnPDFPreviewResource1"></asp:Label>    
    <asp:Label ID="lblVerExTitle" runat="server" Text="版本編號範例" meta:resourcekey="lblVerExTitleResource1" Visible="false"></asp:Label>
    <telerik:RadWindow ID="modalPopup" runat="server" Modal="True" >
        <ContentTemplate>
            <asp:Image ID="WatermarkImage" runat="server" Width="99%" />
        </ContentTemplate>
    </telerik:RadWindow>
    
    <telerik:RadScriptBlock ID="RadScriptBlock1" runat="server">
    <script type="text/javascript">
        //<![CDATA[   
        Sys.Application.add_load(function () {
            var rblApplyRead = $("#<%=rblApplyRead.ClientID%>");
            var ChoiceList1 = $("#ChoiceList1");
            var ckInheritParent2 = $("#<%=ckInheritParent2.ClientID %>");


            if (rblApplyRead.length > 0) {
                var option = rblApplyRead.find('input');
                if (!$(option[0]).prop("checked")) {
                    ChoiceList1.show();
                } else {
                    ChoiceList1.hide();
                }
            }


            // 原始檔控制
            var chkUseParentSet = $("#<%=chkUseParentSet.ClientID %>");
            var chkAuthorCanChange = $("<%=chkAuthorCanChange.ClientID %>");
            var rblApplyRead2 = $("<%=rblApplyRead2.ClientID %>");
            var rblApplyRead3 = $("<%=rblApplyRead3.ClientID%>");
            var rblApplyRead4 = $("<%=rblApplyRead4.ClientID%>");
            var rblApplyRead5 = $("<%=rblApplyRead5.ClientID%>");
            var cbChangeToPDF = $("<%=cbChangeToPDF.ClientID%>");
            var cbIsPrint = $("<%=cbIsPrint.ClientID%>");
            var cbIsSave = $("<%=cbIsSave.ClientID%>");
            var cbIsCopy = $("<%=cbIsCopy.ClientID%>");
            var cbAllowRelease = $("<%=cbAllowRelease.ClientID%>");
            var ddlSecret = $("<%=ddlSecret.ClientID%>");
            var chkCommonEdit = $("<%=chkCommonEdit.ClientID%>");

            if (chkUseParentSet.length > 0) {

                if (rblApplyRead2.length > 0) {

                    if (rblApplyRead2[0].prop("checked"))
                        $("#<%=Source_ChoiceList1.ClientID %>").hide();
                    else
                        $("#<%=Source_ChoiceList1.ClientID %>").show();

                    if (rblApplyRead3[0].prop("checked"))
                        $("#<%=Source_ChoiceList2.ClientID %>").hide();
                    else
                        $("#<%=Source_ChoiceList2.ClientID %>").show();

                    if (rblApplyRead4[0].prop(checked))
                        $("#<%=Source_ChoiceList3.ClientID %>").hide();
                    else
                        $("#<%=Source_ChoiceList3.ClientID %>").show();

                    if (rblApplyRead5[0].prop("checked") || rblApplyRead5[1].prop("checked"))
                        $("#<%=Source_ChoiceList4.ClientID %>").hide();
                    else
                        $("#<%=Source_ChoiceList4.ClientID %>").show()

                    $("#<%=cbIsPrint.ClientID %>").prop("disabled", !$("#<%=cbChangeToPDF.ClientID %>").prop("checked"));
                    $("#<%=cbIsSave.ClientID %>").prop("disabled", !$("#<%=cbChangeToPDF.ClientID %>").prop("checked"));
                    $("#<%=cbIsCopy.ClientID %>").prop("disabled", !$("#<%=cbChangeToPDF.ClientID %>").prop("checked"));
                    $("#<%=cbAllowRelease.ClientID %>").prop("disabled", !$("#<%=cbChangeToPDF.ClientID %>").prop("checked"));
                    $("#<%=rblApplyRead5.ClientID %>").prop("disabled", !$("#<%=cbChangeToPDF.ClientID %>").prop("checked"));


                    if ($("#<%=cbChangeToPDF.ClientID %>").prop("checked")) {
                        $("#<%=rblApplyRead2.ClientID%>").prop("disabled", !$("#<%=cbIsPrint.ClientID %>").prop("checked"));

                        $("#<%=rblApplyRead3.ClientID%>").prop("disabled", !$("#<%=cbIsSave.ClientID %>").prop("checked"));

                        $("#<%=rblApplyRead4.ClientID%>").prop("disabled", !$("#<%=cbIsCopy.ClientID %>").prop("checked"));
                    } else {
                        $("#<%=rblApplyRead2.ClientID%>").prop("disabled", !$("#<%=cbChangeToPDF.ClientID %>").prop("checked"));

                        $("#<%=rblApplyRead3.ClientID%>").prop("disabled", !$("#<%=cbChangeToPDF.ClientID %>").prop("checked"));

                        $("#<%=rblApplyRead4.ClientID%>").prop("disabled", !$("#<%=cbChangeToPDF.ClientID %>").prop("checked"));

                    }

                }

            }

            //PDF浮水印設定
            if ($("#<%=chkAddSummary.ClientID %>").length > 0) {
                var hidChangeToPDF = $("#<%=hidChangeToPDF.ClientID %>");
                var spMacrocosmWater = $("#spMacrocosmWater");
                var cbMacrocosmWater = $("#<%=cbMacrocosmWater.ClientID %>");
                var cbChangeChildWater = $("#<%=cbChangeChildWater.ClientID %>");

                if (hidChangeToPDF.val() == "true") {
                    spMacrocosmWater.prop("disabled", false);
                    cbMacrocosmWater.prop("disabled", false);
                    cbChangeChildWater.prop("disabled", false);
                } else {
                    spMacrocosmWater.prop("disabled", true);
                    cbMacrocosmWater.prop("disabled", true);
                    cbChangeChildWater.prop("disabled", true);
                }

                InheritMacrocosmWater(hidChangeToPDF.val());
                ChangeImgStatus();
            }

            ChangeStatus();
            CheckchkUseImg();
            ChangeAddSummary();


            // watermark/cover preview            
            var RbtnVerticalPreview = $find('<%= RbtnVerticalPreview.ClientID %>');
            var RbtnHorizontalPreview = $find('<%= RbtnHorizontalPreview.ClientID %>');
            if (RbtnVerticalPreview != null && RbtnVerticalPreview.get_enabled()) {
                $('#<%= RbtnVerticalPreview.ClientID %>').on("click", function (evt) { evt.preventDefault(); OpenPreview(); });
            }

            if (RbtnHorizontalPreview != null && RbtnHorizontalPreview.get_enabled()) {
                $('#<%= RbtnHorizontalPreview.ClientID %>').on("click", function (evt) { evt.preventDefault(); OpenPreview('Landscape'); });
            }
            
        });


        function OpenPreview(orientation) {            
            var file = $find('<%:UC_FileCenter.ClientID%>');
            var para = JSON.stringify({
                Orientation: orientation,
                IsUseText: $("#<%:chkUseTxt.ClientID%>").is(":checked"), // 使用文字浮水印
                IsShowAccount: $("#<%:chkDlUser.ClientID%>").is(":checked"), // 下載者的姓名及部門
                TextRotation: $("#<%:ddlTxtRotation.ClientID%>").val(),
                TextColor: $find('<%: colorPicker1.ClientID%>').get_selectedColor(),
                TextSize: $("#<%:ddlTxtSize.ClientID%>").val(),
                TextTransparency: $("#<%:ddlTransparency1.ClientID%>").val(),
                TextPosition: $("#<%:rdoTxtPosition.ClientID%> input:checked").val(),

                IsUseDefText: $("#<%:chkDefText.ClientID%>").is(":checked"), // 使用自訂文字浮水印
                TxetDef: $("#<%:txtDefText.ClientID%>").val(),
                TxetDefRotation: $("#<%:ddlTxtRotation2.ClientID%>").val(),
                TxetDefColor: $find('<%: ColorPicker2.ClientID%>').get_selectedColor(),
                TxetDefSize: $("#<%:ddlTxtSize2.ClientID%>").val(),
                TxetDefTransparency: $("#<%:ddlTransparency2.ClientID%>").val(),
                TxetDefPosition: $("#<%:rdoTxtPosition2.ClientID%> input:checked").val(),

                IsUseImage: $("#<%:chkUseImg.ClientID%>").is(":checked"), // 使用圖形浮水印
                FileGroupId: file.get_fileGroupId(),
                Uploaded: JSON.stringify(file.get_uploaded()),
                ImageRotation: $("#<%:ddlImgRotation.ClientID%>").val(),
                ImageTransparency: $("#<%:ddlimageTransparency.ClientID%>").val(),
                ImagePosition: $("#<%:rdoImgPosition.ClientID%> input:checked").val(),

                IsShowSysDate: $("#<%:chkSysDate.ClientID %>").is(":checked"),
                IsShowDocPath: $("#<%:chkSysPath.ClientID %>").is(":checked"),
                FolderId: $("#<%:hidFolderID.ClientID %>").val(),
                
                IsAddCover: $("#<%:chkAddSummary.ClientID %>").is(":checked"), // 使用文件封面
                IsSystemSummary: $("#<%:rblChoseCoverType.ClientID%>_0").is(":checked"), // 系統預設封面
                IsUserDefineCover: $("#<%:rblChoseCoverType.ClientID%>_1").is(":checked"), // 自訂封面
                IsShowApprovalRecord: $("#<%:ckShowSignOffCourse.ClientID%>").is(":checked"), // 顯示簽核資訊
                IsShowVersionHistory: $("#<%:cbShowVerHistory.ClientID%>").is(":checked"), //顯示文件版本歷程
                CoverHtml: $find('<%:UC_HtmlEditorDocCover.ClientID%>').get_content()                
            });

            var url = $uof.pageMethod.sync("GetPreviewJson", [para]);         
            var previewImage = $('#<%= WatermarkImage.ClientID %>');
            previewImage.removeAttr("src");
            if (url == "") {
                return;
            }
            
            var width = (orientation === undefined) ? "650px" : "900px";
            var height = (orientation === undefined) ? "900px" : "650px";
            $uof.window.open("../DocStore/DocCoverPreview.aspx?Url=" + url + "&h=" + height, width, height);
        }
        //]]>
    </script>
    </telerik:RadScriptBlock>
</asp:Content>
