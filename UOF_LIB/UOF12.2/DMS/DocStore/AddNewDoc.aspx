<%@ Page Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" Inherits="DMS_DocStore_AddNewDoc" Title="新增文件" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" CodeBehind="AddNewDoc.aspx.cs" %>

<%@ Register Src="../../Common/ChoiceCenter/UC_ChoiceList.ascx" TagName="UC_ChoiceList" TagPrefix="uc2" %>
<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Fast" %>
<%@ Register Src="~/Common/FileCenter/V3/UC_FileCenter.ascx" TagPrefix="uc2" TagName="UC_FileCenter" %>
<%@ Register Src="~/Common/HtmlEditor/UC_HtmlEditor.ascx" TagPrefix="uc2" TagName="UC_HtmlEditor" %>
<%@ Register Src="~/Common/ChoiceCenter/UC_ChoiceList.ascx" TagPrefix="uc1" TagName="UC_ChoiceList" %>




<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript">

        function wibtnSelectFlow_Click(button, args) {
            var ddlUseWKFList = $("#<%=ddlUseWKFList.ClientID %>");
            var FormVersionId = $("#<%=ddlUseWKFList.ClientID %>").val().split(',');

            $uof.dialog.open2("~/WKF/Browse/ViewMasterFlow.aspx", button, "", 900, 800, function (returnValue) { return false; }, { "formVersionId": FormVersionId[0], "formId": FormVersionId[1] });
            return false; //button.set_autoPostBack(false);
        }

        function OnClientUploaded(id, name, path, size, contentType) {
            $("#<%=lblFileName.ClientID %>").val(name);
            $("#<%=hdFileID.ClientID %>").val(id);
        }

        function OnClientRemoved(id) {
            $("#<%=hdFileID.ClientID %>").val("");
        }

        function ConfirmApprove() {
            var userGuid = $('#<%=this.hdUserGuid.ClientID %>').val();
            var browseStrSpan = "";
            var lblFileName = $("#<%=lblFileName.ClientID %>");
            var lbUploadNow = "";
            var lbBrowse = "";
            var newfileupload = "";
            var lblApproveType = $("#<%=lblApproveType.ClientID %>");
            var lblNeedApprove = $("#<%=lblNeedApprove.ClientID %>");
            var ddlUseWKFList = $("#<%=ddlUseWKFList.ClientID %>");
            var ischkManual = $("#<%=chkManual.ClientID %>").is(":checked");
            var hdFormId = $("#<%=hdFormId.ClientID %>");
            var fs = $find("<%=UC_FileCenter.ClientID%>");
            //判斷WKF是否沒流程

            var ddlobj = $find("<%= this.ddlUseWKFList.ClientID %>");
            if (ddlobj != null) {

                if ($('#<%=ddlUseWKFList.ClientID %> option').length == 0) //ddlUseWKFList.options.length == 0
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
            //----------------------

            //判斷是否有輸入手動版本
            if (ischkManual)
                if ($("#<%=txtManual.ClientID %>").val().replace(" ", "") == "")
                    return;

            //-------------------------

            //判斷保存日是否正確
            var rdoActive1 = $("#<%=rdoActive1.ClientID %>");
            var rdoactivevalue = rdoActive1.filter(':checked').val();
            var rdoInvalid1 = $("#<%=rdoInvalid1.ClientID %>");
            var rdoInvalid1value = rdoInvalid1.filter(':checked').val();
            if (rdoInvalid1value) {
                var Start = new Date($("#<%=RadDatePicker1.ClientID %>").val().replace(/\-/g, '/'))
                var End = new Date($("#<%=RadDatePicker2.ClientID %>").val().replace(/\-/g, '/'))
            }

            var data = [];
            var now = $uof.pageMethod.sync("GetServerDate", data);

            if (!rdoInvalid1value)
                if (End < new Date(now))
                    return;
            if (!rdoInvalid1value && !rdoactivevalue)
                if (Start > End)
                    return;
            /*
                if (rdoInvalid1 != null)
                    if (!rdoInvalid1.checked)
                        if ( End < new Date(now) )
                            return;
                            
                if (rdoInvalid1 != null)
                    if (!rdoInvalid1.checked && !rdoActive1.checked)
                        if (Start > End)
                            return;*/


            //---------------------

            var IsPublish;

            if ($("#<%=rbtnlDocStatus.ClientID%>").length > 0)
                IsPublish = $('#<%=rbtnlDocStatus.ClientID %> input:checked').val();
            else
                IsPublish = "<%=rbtnlDocStatus.SelectedValue%>";

            var getappdata = [$("#<%=hidFolderID.ClientID %>").val(), $("#<%= lblDocId.ClientID %>").val(), $("#<%= hfEvent.ClientID %>").val()];
            var ApproveValue = $uof.pageMethod.sync("GetApproveValue", getappdata).split(",");

            var IsSkipApprove = ApproveValue[3];
            lblApproveType.val(ApproveValue[2]);
            lblNeedApprove.val(ApproveValue[1]);
            hdFormId.val(ApproveValue[0]);
            $('#<%=hfIsSkipApprove.ClientID %>').val(ApproveValue[3]);
            $("#<%=hfApproveType.ClientID %>").val(ApproveValue[2]);
            $("#<%=hfNeedApprove.ClientID %>").val(ApproveValue[1]);
            $("#<%=hfIsPublish.ClientID %>").val(IsPublish);
            $("#<%= hfEvent.ClientID %>").val(ApproveValue[4]);



            if (lblApproveType.val() == "WKF" && lblNeedApprove.val() == "true" && IsPublish == "publish") {

                if (fs != null && fs.get_count() > 0) {



                    if ($("#<%=lblDocname.ClientID %>").val().replace(" ", "") == "") {
                        $("#<%=lblDocname.ClientID %>").val($("#<%=lblFileName.ClientID %>").val());
                    }
                }
                else {
                    if ($("#<%=lblFileName.ClientID %>").val() != "") {
                        state = true;
                    }
                    else {
                        $("#<%=hdIsUpLoad.ClientID %>").val("false");
                    }
                }

            }
        }

        //開啟文件連結對話視窗
        function wibtnDocRefLink_ClientClick(button, args) {

            var refID = '<%=SelectRefClientid%>';

            $uof.dialog.open2("~/DMS/DocStore/DocRefLink.aspx", button, "", 1000, 600, OpenDialogResultRefLink, { "refID": refID });
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



    </script>


    <script type="text/javascript">


        function refDocID() {
            return $("#<%=hidRefDoc.ClientID %>").val();
        }



        $(function () {



            var txtTitle = $("#<%=txtTitle.ClientID %>").val();

            if (typeof (txtTitle) != "undefined") {
                $("#<%=txtTitle.ClientID %>")[0].focus(); //txtTitle.focus();
            }

            var chkManual = $("#<%=chkManual.ClientID %>");
            var txtManual = $("#<%=txtManual.ClientID %>");
            var ischkManual = $("#<%=chkManual.ClientID %>").is(":checked");
            if (typeof (chkManual) != "undefined" && typeof (txtManual) != "undefined") {
                if (ischkManual) {
                    $("#<%=txtManual.ClientID%>").attr("disabled", false);
                    $("#<%=txtManual.ClientID%>").css("background-color", "#FFFFFF");
                    $("#<%=txtManual.ClientID%>").focus();
                } else {
                    $("#<%=txtManual.ClientID%>").attr("disabled", true);
                    $("#<%=txtManual.ClientID%>").css("background-color", "#F0F0F0");
                }
            }
            ChangeActive();
            ChangeInvalid();
            //ChangeSecret();   

            //是否可更改調閱流程
            IsChangeLend();

            //是否允許調閱
            if ($("#<%=chkBorrow.ClientID%>") != null)
                if ($("#<%=chkBorrow.ClientID%>").attr("disabled") == false)
                    IsBorrow();

            var rblApplyRead = $("#<%=rblApplyRead.ClientID%>");
            var isrblApplyRead = $("#<%=rblApplyRead.ClientID%>").is(":checked");
            var ChoiceList1 = $("#ChoiceList1");

            if (rblApplyRead != null) {
                // var option = rblApplyRead.getElementsByTagName('input');

                if (!isrblApplyRead) {
                    $("#ChoiceList1").css('visibility', 'visible'); //ChoiceList1.style.visibility = "visible";
                } else {
                    $("#ChoiceList1").css('visibility', 'hidden'); //ChoiceList1.style.visibility = "hidden"
                }
            }

            // 原始檔控制
            var chkUseParentSet = $("#<%=chkUseParentSet.ClientID%>");
            var rblApplyRead2 = $("#<%=rblApplyRead2.ClientID%>");
            var rblApplyRead3 = $("#<%=rblApplyRead3.ClientID%>");
            var rblApplyRead4 = $("#<%=rblApplyRead4.ClientID%>");
            var rblApplyRead5 = $("#<%=rblApplyRead5.ClientID%>");
            var cbChangeToPDF = $("#<%=cbChangeToPDF.ClientID%>");
            var cbIsPrint = $("#<%=cbIsPrint.ClientID%>");
            var cbIsSave = $("#<%=cbIsSave.ClientID%>");
            var cbIsCopy = $("#<%=cbIsCopy.ClientID%>");
            var ddlSecret = $("#<%=ddlSecret.ClientID%>");
            var chkCommonEdit = $("#<%=chkCommonEdit.ClientID%>");

            if (chkUseParentSet.length > 0) {

                if (rblApplyRead2.length > 0) {

                    if (chkUseParentSet.prop("checked")) {
                        $("#<%=cbIsPrint.ClientID%>").prop("disabled", true);
                        $("#<%=cbIsSave.ClientID%>").prop("disabled", true);
                        $("#<%=cbIsCopy.ClientID%>").prop("disabled", true);
                        $("#<%=rblApplyRead5.ClientID%>").prop("disabled", false);
                        $("#<%=rblApplyRead2.ClientID%>").prop("disabled", false);
                        $("#<%=rblApplyRead3.ClientID%>").prop("disabled", false);
                        $("#<%=rblApplyRead4.ClientID%>").prop("disabled", false);
                    }
                    else {
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


                        var iscbChangeToPDF = $("#<%=cbChangeToPDF.ClientID%>").is(":checked");
                        var iscbIsPrint = $("#<%=cbIsPrint.ClientID%>").is(":checked");
                        var iscbIsSave = $("#<%=cbIsSave.ClientID%>").is(":checked");
                        var iscbIsCopy = $("#<%=cbIsCopy.ClientID%>").is(":checked");
                        $("#<%=cbIsPrint.ClientID%>").prop("disabled", !iscbChangeToPDF);
                        $("#<%=cbIsSave.ClientID%>").prop("disabled", !iscbChangeToPDF);
                        $("#<%=cbIsCopy.ClientID%>").prop("disabled", !iscbChangeToPDF);
                        $("#<%=rblApplyRead5.ClientID%>").attr("disabled", !iscbChangeToPDF);

                        if (iscbChangeToPDF) {
                            $("#<%=rblApplyRead2.ClientID%>").attr("disabled", !iscbIsPrint);
                            $("#<%=rblApplyRead3.ClientID%>").attr("disabled", !iscbIsSave);
                            $("#<%=rblApplyRead4.ClientID%>").attr("disabled", !iscbIsCopy);
                        } else {
                            $("#<%=rblApplyRead2.ClientID%>").attr("disabled", !iscbChangeToPDF);
                            $("#<%=rblApplyRead3.ClientID%>").attr("disabled", !iscbChangeToPDF);
                            $("#<%=rblApplyRead4.ClientID%>").attr("disabled", !iscbChangeToPDF);
                        }
                    }
                }
            }
        });




        // 機密設定
        function ChangeSecret() {

        }

        //設定調閱是否啟用
        function IsBorrow() {
            var chkBorrow = $("#<%=chkBorrow.ClientID%>");
            var rblApplyRead = $("#<%=rblApplyRead.ClientID%>");
            var ChoiceList1 = $("#ChoiceList1");
            var rblReadProcedure = $("#<%=rblReadProcedure.ClientID%>");
            var ddlUseWKFList = $("#<%=ddlUseWKFList.ClientID%>");
            var wibtnSelectFlow = $("#<%=wibtnSelectFlow.ClientID%>");
            var WKFFlow = $("#WKFFlow");

            if (typeof (chkBorrow) != 'undefined') {
                var ischkBorrow = $("#<%=chkBorrow.ClientID%>").is(":checked");
                rblApplyRead.attr("disabled", !ischkBorrow);//rblApplyRead.disabled = !chkBorrow.checked;    
                rblReadProcedure.attr("disabled", !ischkBorrow); //rblReadProcedure.disabled = !chkBorrow.checked;
                ChoiceList1.attr("disabled", !ischkBorrow);//ChoiceList1.disabled = !chkBorrow.checked;                                                   

            }
        }

        //是否可更改調閱流程
        function IsChangeLend() {
            var chkBorrow = $("#<%=chkBorrow.ClientID%>");
    if (chkBorrow != null) {
        if (chkBorrow.attr("disabled") == true) //chkBorrow.disabled
        {
            $('#ChoiceList1').attr("disabled", chkBorrow.prop("disabled"));

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
            if ($("#<%=rdoInvalid1.ClientID%>").is(":checked"))        //rdoInvalid1.checked
                datepicker.set_enabled(false);  //WebDateChooser2.disabled = true;        
            else
                datepicker.set_enabled(true);   //WebDateChooser2.disabled = false;             
        }
    }
}





function ChangeManuStatus() {
    if ($("#<%=chkManual.ClientID%>").is(":checked")) {
        $("#<%=txtManual.ClientID%>").attr("disabled", false);  //txtManual.disabled = false;
        $("#<%=txtManual.ClientID%>").css('background-color', '#FFFFFF'); //txtManual.style.backgroundColor = "#FFFFFF";   
    }
    else {
        $("#<%=txtManual.ClientID%>").attr("disabled", true);  //txtManual.disabled = true;
        $("#<%=txtManual.ClientID%>").css('background-color', '#F0F0F0'); //txtManual.style.backgroundColor = "#F0F0F0";   
    }
}


var arrayNodes = new Array();


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
function openDialogResult(returnValue) {
    if (typeof (returnValue) == 'undefined' || returnValue == null)
        return false;
    else {
        return true;
    }
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

        //文件類別Tree resize
        function resizeTree(X, Y) {
            var tree = $find("<%=myClassTree.ClientID %>");
            if (tree != null && tree != 'undefined') {
                tree.get_element().style.height = Y - 50 + "px";
                tree.get_element().style.width = X - 126 + "px";
            }
        }
    </script>
    <style>
        td {
            vertical-align: top;
        }
    </style>
    <table width="100%" border="0">
        <tr>
            <td align="center" class="PopTableHeader" style="text-align: center!important">
                <asp:Label ID="Label12" runat="server" Text="新增檔案" meta:resourcekey="Label12Resource1"></asp:Label></td>
        </tr>
    </table>
    <asp:Wizard ID="Wizard1" runat="server" ActiveStepIndex="0" BackColor="#F7F6F3" BorderColor="#999999"
        BorderWidth="1px" Height="92%" Width="100%"
        EnableTheming="True" BorderStyle="Solid" OnNextButtonClick="Wizard1_NextButtonClick" OnSideBarButtonClick="Wizard1_SideBarButtonClick" OnActiveStepChanged="Wizard1_ActiveStepChanged" meta:resourcekey="Wizard1Resource1">
        <StepStyle VerticalAlign="Top" BackColor="White" BorderColor="#E6E2D8" BorderStyle="Solid" BorderWidth="2px" />
        <SideBarStyle BackColor="White" VerticalAlign="Top" Width="120px" Font-Underline="False" ForeColor="Black" HorizontalAlign="Center" Wrap="false" />
        <NavigationButtonStyle BackColor="White" BorderColor="#C5BBAF" BorderStyle="Solid" BorderWidth="1px" ForeColor="#1C5E55" />
        <WizardSteps>
            <asp:WizardStep ID="WizardStep1" runat="server" Title="1.基本屬性" meta:resourcekey="WizardStep1Resource1">
                <asp:UpdatePanel ID="UpdatePanel5" runat="server">
                    <ContentTemplate>
                        <table style="height: 380px; width: 100%;" class="PopTable" cellspacing="1" id="PropertyTable" runat="server">
                            <tr>
                                <td>
                                    <asp:Label ID="Label1" runat="server" Text="存放目錄" meta:resourcekey="Label1Resource1"></asp:Label>
                                </td>
                                <td colspan="3">
                                    <span style="word-break: break-all; width: 350px;">
                                        <img alt="" src="../images/open.gif" />
                                        <asp:Label ID="lblFolder" runat="server" ForeColor="Blue" meta:resourcekey="lblFolderResource1"></asp:Label>
                                    </span>
                                </td>

                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="Label3" runat="server" Text="狀態" meta:resourcekey="Label3Resource1"></asp:Label>
                                </td>
                                <td colspan="3">
                                    <table>
                                        <tr>
                                            <td>
                                                <asp:RadioButtonList ID="rbtnlDocStatus" runat="server" Width="100%" RepeatDirection="Horizontal" RepeatLayout="Flow" meta:resourcekey="RadioButtonList2Resource1" OnSelectedIndexChanged="RadioButtonList2_SelectedIndexChanged" AutoPostBack="true">
                                                    <asp:ListItem Selected="True" Value="checkin" meta:resourcekey="ListItemResource1" Text="存回"></asp:ListItem>
                                                    <asp:ListItem Value="publish" meta:resourcekey="ListItemResource2" Text="公佈"></asp:ListItem>
                                                </asp:RadioButtonList>
                                            </td>
                                            <td style="padding-left: 5px;">
                                                <table runat="server" visible="false" id="tbInitialVer">
                                                    <tr>
                                                        <td>
                                                            <asp:Label ID="lblInitialVer" runat="server" Text="第一次公佈的起始版本編號:" CssClass="SizeMemo" meta:resourcekey="lblInitialVerResource1"></asp:Label>
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
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="Label6" runat="server" Text="文件名稱" meta:resourcekey="Label6Resource1"></asp:Label></td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtTitle" runat="server" Width="100%" MaxLength="300" meta:resourcekey="txtTitleResource1"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="Label5" runat="server" Text="文件編號" meta:resourcekey="Label5Resource1"></asp:Label>
                                </td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtSerial" runat="server" Width="350px" MaxLength="100" meta:resourcekey="txtSerialResource1"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="Label22" runat="server" Text="文件速別" meta:resourcekey="Label22Resource1"></asp:Label>
                                </td>
                                <td colspan="3">
                                    <asp:RadioButton ID="rdoUrgencyNormal" runat="server" GroupName="Urgency" Text="普通" Checked="true" meta:resourcekey="rdoUrgencyNormalResource1" />
                                    <asp:RadioButton ID="rdoUrgencyHigh" runat="server" GroupName="Urgency" Text="急" meta:resourcekey="rdoUrgencyHighResource1" />
                                    <asp:RadioButton ID="rdoUrgencyExHigh" runat="server" GroupName="Urgency" Text="緊急" meta:resourcekey="rdoUrgencyExHighResource1" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="Label4" runat="server" Text="版本控制" meta:resourcekey="Label4Resource1"></asp:Label>
                                </td>
                                <td colspan="3">
                                    <asp:CheckBox ID="chkManual" runat="server" Text="版本手動控制" meta:resourcekey="chkManualResource1" OnCheckedChanged="chkManual_CheckedChanged" AutoPostBack="true" />
                                    &nbsp;&nbsp;
                             <asp:Label ID="Label10" runat="server" Text="版本：" meta:resourcekey="Label10Resource1"></asp:Label>
                                    <asp:TextBox ID="txtManual" runat="server" Width="140px" MaxLength="15" meta:resourcekey="txtManualResource1"></asp:TextBox>
                                    <asp:CustomValidator ID="CustomValidator3" runat="server" Display="Dynamic" ErrorMessage="請輸入版本" meta:resourcekey="CustomValidator3Resource1" Visible="False"></asp:CustomValidator>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="lblVersionMemo" runat="server" Text="版本備註" meta:resourcekey="lblVersionMemoResource1"></asp:Label>
                                </td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtVersionMemo" runat="server" Rows="4" TextMode="MultiLine"
                                        Width="100%" meta:resourcekey="txtVersionMemoResource1"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td style="white-space: nowrap">
                                    <asp:Label ID="Label7" runat="server" Text="發行單位" meta:resourcekey="Label7Resource1"></asp:Label>
                                </td>
                                <td style="width: 400px">
                                    <div style="width: 100%; height: 90px; overflow: auto;">
                                        <uc2:UC_ChoiceList ID="UC_ChoiceList2" runat="server" ChioceType="Group" ShowMember="false" ExpandToUser="false" />
                                    </div>
                                </td>
                                <td style="white-space: nowrap">
                                    <asp:Label ID="Label8" runat="server" Text="保管者" meta:resourcekey="Label8Resource1"></asp:Label>
                                </td>
                                <td style="width: 400px">
                                    <div style="width: 100%; height: 90px; overflow: auto;">
                                        <uc2:UC_ChoiceList ID="UC_ChoiceList3" runat="server" ChioceType="User" ShowMember="false" ExpandToUser="false" />
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td style="white-space: nowrap">
                                    <asp:Label ID="Label23" runat="server" Text="權責部門" meta:resourcekey="Label23Resource1"></asp:Label>
                                </td>
                                <td style="width: 400px">
                                    <div style="width: 100%; height: 90px; overflow: auto;">
                                        <uc1:UC_ChoiceList runat="server" ID="clAuthDep" ChioceType="Group" ShowMember="false" ExpandToUser="false" />
                                    </div>
                                </td>
                                <td>
                                    <asp:Label ID="Label21" runat="server" Text="適用部門" meta:resourcekey="Label21Resource1"></asp:Label>
                                </td>
                                <td>
                                    <div style="width: 100%; height: 90px; overflow: auto;">
                                        <uc2:UC_ChoiceList ID="clSuitableDep" runat="server" ChioceType="Group" ShowMember="false" ExpandToUser="false" />
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="Label9" runat="server" Text="摘要" meta:resourcekey="Label9Resource1"></asp:Label>
                                </td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtComment" runat="server" Rows="4" TextMode="MultiLine" Width="100%" meta:resourcekey="txtCommentResource1"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="Label15" runat="server" Text="關鍵字" meta:resourcekey="LabelKeyWordResource1"></asp:Label>
                                </td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtKeyWord" runat="server" Rows="4" meta:resourceKey="txtCommentResource1"
                                        TextMode="MultiLine" Width="100%"></asp:TextBox>
                                </td>
                            </tr>
                        </table>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </asp:WizardStep>
            <asp:WizardStep ID="WizardStep2" runat="server" Title="2.保存期限" EnableTheming="True" meta:resourcekey="WizardStep2Resource1">
                <table border="0" style="width: 100%" cellspacing="1" class="PopTable">
                    <tr>
                        <td rowspan="2" style="width: 67px; text-align: right" class="PopTableLeftTD">
                            <asp:Label ID="Label14" runat="server" Text="生效設定" meta:resourcekey="Label14Resource1"></asp:Label></td>
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
                        <td rowspan="2" style="width: 67px; text-align: right" align="right" class="PopTableLeftTD">
                            <asp:Label ID="Label13" runat="server" Text="過期設定" meta:resourcekey="Label13Resource1"></asp:Label></td>
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
                <br />
                <asp:CustomValidator ID="cValidDate" runat="server" Display="Dynamic" ErrorMessage="CustomValidator" Text="保存期限設定錯誤" meta:resourcekey="cValidDateResource1" Visible="False"></asp:CustomValidator>
            </asp:WizardStep>
            <asp:WizardStep ID="WizardStep3" runat="server" Title="3.機密設定" meta:resourcekey="WizardStep3Resource1">
                <asp:UpdatePanel ID="UpdatePanel3" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <table border="0" class="PopTable" cellspacing="1">
                            <tr>
                                <td style="width: 100%; padding: 0 0 0 0; text-align: left" colspan="2">
                                    <table width="100%">
                                        <tr>
                                            <td class="PopTableRightTD" style="width: 100%">
                                                <asp:CheckBox ID="chkUseParentSet" runat="server" Text="使用父目錄的機密設定" AutoPostBack="True" OnCheckedChanged="chkUseParentSet_CheckedChanged" meta:resourcekey="chkUseParentSetResource1" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 33px; width: 20%" align="right" class="PopTableLeftTD">
                                    <asp:Label ID="Label17" runat="server" Text="機密等級" meta:resourcekey="Label17Resource1"></asp:Label>
                                </td>
                                <td style="width: 384px; height: 33px" class="PopTableRightTD">&nbsp;<asp:DropDownList ID="ddlSecret" runat="server" Width="100px" meta:resourcekey="ddlSecretResource1">
                                    <asp:ListItem Value="Normal" meta:resourcekey="ListItemResource3" Text="一般"></asp:ListItem>
                                    <asp:ListItem Value="Secret" meta:resourcekey="ListItemResource4" Text="密"></asp:ListItem>
                                    <asp:ListItem Value="XSecret" meta:resourcekey="ListItemResource5" Text="機密"></asp:ListItem>
                                    <asp:ListItem Value="XXSecret" meta:resourcekey="ListItemResource6" Text="極機密"></asp:ListItem>
                                    <asp:ListItem Value="TopSecret" meta:resourcekey="ListItemResource7" Text="絕對機密"></asp:ListItem>
                                </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 67px; height: 33px;" align="right" class="PopTableLeftTD">
                                    <asp:Label ID="Label19" runat="server" Text="共同編輯" meta:resourcekey="Label19Resource1"></asp:Label>
                                </td>
                                <td style="width: 384px;" class="PopTableRightTD">
                                    <asp:CheckBox ID="chkCommonEdit" runat="server" Text="允許作者群共同編輯" Checked="True" meta:resourcekey="chkCommonEditResource1" />
                                </td>
                            </tr>
                            <tr id="OriginalManuscriptTR" runat="server">
                                <td style="width: 67px; height: 131px;" align="right" class="PopTableLeftTD" runat="server">
                                    <asp:Label ID="Label18" runat="server" Text="原稿控制" meta:resourcekey="Label18Resource1"></asp:Label>
                                </td>
                                <td id="SourceControlTD" style="width: 384px; height: 131px;" class="PopTableRightTD" runat="server">

                                    <table width="100%">
                                        <tr>
                                            <td colspan="3" style="height: 25px" bgcolor="#f1f1f1" valign="middle">
                                                <asp:CheckBox ID="cbChangeToPDF" runat="server" Text="轉成PDF" meta:resourcekey="cbChangeToPDFResource1" AutoPostBack="True" OnCheckedChanged="cbChangeToPDF_CheckedChanged" />
                                                <asp:Image ID="Image1" runat="server" ImageUrl="~/DMS/images/icon/pdf.gif" />
                                            </td>
                                        </tr>
                                        <tr style="display:none;">
                                            <td>
                                                <asp:CheckBox ID="cbIsPrint" runat="server" Text="可列印" meta:resourcekey="cbIsPrintResource1" AutoPostBack="True" OnCheckedChanged="cbIsPrint_CheckedChanged" /></td>
                                            <td>
                                                <asp:RadioButtonList ID="rblApplyRead2" runat="server" CssClass="SizeS" CellPadding="0" CellSpacing="0" AutoPostBack="True" RepeatDirection="Horizontal" OnSelectedIndexChanged="rblApplyRead2_SelectedIndexChanged">
                                                    <asp:ListItem Selected="True" Value="AllowALL" meta:resourcekey="ListItemResource8" Text="允許全部人員"></asp:ListItem>
                                                    <asp:ListItem Value="AllowList" meta:resourcekey="ListItemResource13" Text="允許下列人員"></asp:ListItem>
                                                    <asp:ListItem Value="DenyList" meta:resourcekey="ListItemResource14" Text="不允許下列人員"></asp:ListItem>
                                                </asp:RadioButtonList></td>
                                        </tr>
                                        <tr style="display:none;">
                                            <td colspan="3">
                                                <div id="Source_ChoiceList1" style="max-height: 100px; overflow: auto;" runat="server">
                                                    <uc2:UC_ChoiceList ID="UC_clApplyRead2" runat="server" ExpandToUser="false"
                                                        IsAllowEdit="true"></uc2:UC_ChoiceList>
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
                                                <asp:CheckBox ID="cbIsSave" runat="server" Text="可另存" meta:resourcekey="cbIsSaveResource1" AutoPostBack="True" OnCheckedChanged="cbIsSave_CheckedChanged" /></td>
                                            <td>
                                                <asp:RadioButtonList ID="rblApplyRead3" runat="server" CssClass="SizeS" CellPadding="0" CellSpacing="0" AutoPostBack="True" RepeatDirection="Horizontal" OnSelectedIndexChanged="rblApplyRead2_SelectedIndexChanged">
                                                    <asp:ListItem Selected="True" Value="AllowALL" meta:resourcekey="ListItemResource8" Text="允許全部人員"></asp:ListItem>
                                                    <asp:ListItem Value="AllowList" meta:resourcekey="ListItemResource13" Text="允許下列人員"></asp:ListItem>
                                                    <asp:ListItem Value="DenyList" meta:resourcekey="ListItemResource14" Text="不允許下列人員"></asp:ListItem>
                                                </asp:RadioButtonList></td>
                                        </tr>
                                        <tr>
                                            <td colspan="3">
                                                <div id="Source_ChoiceList2" style="max-height: 100px; overflow: auto;" runat="server">
                                                    <uc2:UC_ChoiceList ID="UC_clApplyRead3" runat="server" ExpandToUser="false"
                                                        IsAllowEdit="true"></uc2:UC_ChoiceList>
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
                                                <asp:CheckBox ID="cbIsCopy" runat="server" Text="可複製" meta:resourcekey="cbIsCopyResource1" AutoPostBack="True" OnCheckedChanged="cbIsCopy_CheckedChanged" /></td>
                                            <td>
                                                <asp:RadioButtonList ID="rblApplyRead4" runat="server" CssClass="SizeS" CellPadding="0" CellSpacing="0" AutoPostBack="True" RepeatDirection="Horizontal" OnSelectedIndexChanged="rblApplyRead2_SelectedIndexChanged">
                                                    <asp:ListItem Selected="True" Value="AllowALL" meta:resourcekey="ListItemResource8" Text="允許全部人員"></asp:ListItem>
                                                    <asp:ListItem Value="AllowList" meta:resourcekey="ListItemResource13" Text="允許下列人員"></asp:ListItem>
                                                    <asp:ListItem Value="DenyList" meta:resourcekey="ListItemResource14" Text="不允許下列人員"></asp:ListItem>
                                                </asp:RadioButtonList></td>
                                        </tr>
                                        <tr style="display:none;">
                                            <td colspan="3">
                                                <div id="Source_ChoiceList3" style="max-height: 100px; overflow: auto;" runat="server">
                                                    <uc2:UC_ChoiceList ID="UC_clApplyRead4" runat="server" ExpandToUser="false"
                                                        IsAllowEdit="true"></uc2:UC_ChoiceList>
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
                                            <td colspan="3" style="height: 25px" bgcolor="#f1f1f1" valign="middle">&nbsp;<asp:Label ID="lblSource" runat="server" Text="原始檔" meta:resourcekey="lblSourceResource1"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblSource2" runat="server" Text="下載權限" meta:resourcekey="lblSource2Resource1"></asp:Label></td>
                                            <td>
                                                <asp:RadioButtonList ID="rblApplyRead5" runat="server" CssClass="SizeS" CellPadding="0" CellSpacing="0" AutoPostBack="True" RepeatDirection="Horizontal" OnSelectedIndexChanged="rblApplyRead2_SelectedIndexChanged">
                                                    <asp:ListItem Selected="True" Value="DenyALL" meta:resourcekey="ListItemResource11" Text="全部不允許"></asp:ListItem>
                                                    <asp:ListItem Value="AllowALL" meta:resourcekey="ListItemResource8" Text="允許全部人員"></asp:ListItem>
                                                    <asp:ListItem Value="AllowList" meta:resourcekey="ListItemResource13" Text="允許下列人員"></asp:ListItem>
                                                    <asp:ListItem Value="DenyList" meta:resourcekey="ListItemResource14" Text="不允許下列人員"></asp:ListItem>
                                                </asp:RadioButtonList></td>
                                        </tr>
                                        <tr>
                                            <td colspan="3">
                                                <div id="Source_ChoiceList4" style="max-height: 100px; overflow: auto;" runat="server">
                                                    <uc2:UC_ChoiceList ID="UC_clApplyRead5" runat="server" ExpandToUser="false"
                                                        IsAllowEdit="true"></uc2:UC_ChoiceList>
                                                </div>
                                            </td>
                                        </tr>

                                    </table>
                                    <asp:CustomValidator ID="cvSourceNoChoice" runat="server" ErrorMessage="請選擇「」人員"
                                        Visible="False" meta:resourcekey="cvSourceNoChoiceResource1"></asp:CustomValidator>
                                </td>
                            </tr>
                        </table>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </asp:WizardStep>
            <asp:WizardStep runat="server" Title="4.調閱權限" meta:resourcekey="WizardStep4Resource1">
                <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                    <ContentTemplate>
                        <table border="0" class="PopTable" cellspacing="1">
                            <tr>
                                <td style="width: 100%; padding: 0 0 0 0; text-align: left" colspan="2">
                                    <table width="100%">
                                        <tr>
                                            <td class="PopTableRightTD" style="height: 32px; width: 100%">
                                                <asp:CheckBox ID="chkUseParentSetup" runat="server" AutoPostBack="True" OnCheckedChanged="chkUseParentSetup_CheckedChanged"
                                                    Text="使用父目錄的調閱設定" Checked="True" meta:resourcekey="chkUseParentSetupResource1" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 20%; height: 138px;" align="right" class="PopTableLeftTD" valign="middle">
                                    <asp:Label ID="Label20" runat="server" Text="調閱申請" meta:resourcekey="Label20Resource1"></asp:Label>
                                </td>
                                <td style="height: 138px; width: 75%" class="PopTableRightTD" valign="top">
                                    <asp:CheckBox ID="chkBorrow" runat="server" Text="允許調閱申請" meta:resourcekey="chkBorrowResource1" Checked="True" onclick="IsBorrow()" AutoPostBack="True" OnCheckedChanged="chkBorrow_CheckedChanged" />
                                    &nbsp;<br />
                                    <asp:RadioButtonList ID="rblApplyRead" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="rblApplyRead_SelectedIndexChanged" meta:resourcekey="rblApplyReadResource1">
                                        <asp:ListItem Selected="True" Value="AllowALL" meta:resourcekey="ListItemResource12" Text="允許全部人員"></asp:ListItem>
                                        <asp:ListItem Value="AllowList" meta:resourcekey="ListItemResource13" Text="允許下列人員"></asp:ListItem>
                                        <asp:ListItem Value="DenyList" meta:resourcekey="ListItemResource14" Text="不允許下列人員"></asp:ListItem>
                                    </asp:RadioButtonList>
                                    <div id="ChoiceList1" style="width: 100%; height: 80px; overflow: auto;">
                                        <uc2:UC_ChoiceList ID="UC_clApplyRead" runat="server" ExpandToUser="false" />
                                    </div>
                                    <asp:CustomValidator ID="CustomValidator4" runat="server" Display="Dynamic" ErrorMessage="請選擇調閱人員"
                                        meta:resourceKey="CustomValidator4Resource1" Visible="False"></asp:CustomValidator>
                                </td>
                            </tr>
                            <tr>
                                <td class="PopTableLeftTD" align="right">
                                    <asp:Label ID="Label16" runat="server" Text="調閱流程" meta:resourceKey="Label16Resource1"></asp:Label>
                                </td>
                                <td class="PopTableRightTD" valign="top">
                                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                        <ContentTemplate>
                                            <asp:RadioButtonList ID="rblReadProcedure" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="rblReadProcedure_SelectedIndexChanged" meta:resourcekey="rblReadProcedureResource1">
                                                <asp:ListItem Selected="True" Value="DefaultFlow" meta:resourcekey="ListItemResource15" Text="簡易流程"></asp:ListItem>
                                                <asp:ListItem Value="WKFFlow" meta:resourcekey="ListItemResource16" Text="電子簽核"></asp:ListItem>
                                            </asp:RadioButtonList>
                                            <asp:Label ID="labApproveHelp" runat="server" ForeColor="Blue" Text="由下列任一「目錄管理者」審核通過即可公佈" meta:resourcekey="labApproveHelpResource1"></asp:Label>
                                            <br />
                                            <asp:Label ID="lblPath" runat="server" ForeColor="Blue" Visible="False" meta:resourcekey="lblPathResource1"></asp:Label>
                                            <span id="WKFFlow">
                                                <asp:DropDownList ID="ddlUseWKFList" runat="server" Visible="False" Width="134px" meta:resourcekey="ddlUseWKFListResource1">
                                                </asp:DropDownList>
                                                <telerik:RadButton ID="wibtnSelectFlow" Text="觀看流程" runat="server" OnClientClicked="wibtnSelectFlow_Click"
                                                    meta:resourcekey="wibtnSelectFlowResource1">
                                                </telerik:RadButton>
                                                </igtxt:WebImageButton>
                                            </span>
                                            <div id="ChoiceList2" style="width: 100%; height: 100px; overflow: auto;">
                                                <uc2:UC_ChoiceList ID="UC_clReadProcedure" runat="server" ExpandToUser="false" IsAllowEdit="false" />
                                            </div>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </td>
                            </tr>
                        </table>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </asp:WizardStep>
            <asp:WizardStep ID="WizardStep6" runat="server" Title="5.文件類別" meta:resourcekey="WizardStep6Resource1">
                <telerik:RadTreeView runat="server" ID="myClassTree" CheckBoxes="true" Height="100%"
                    OnClientNodeChecked="clientNodeChecked" meta:resourcekey="myClassTreeResource1">
                </telerik:RadTreeView>
                <input id="hidNodeTag" runat="server" style="width: 64px" type="hidden" value="DMSClass" />
                <input id="hidClickValue" type="hidden" runat="server" />
                <input id="hidIncludeParentClass" type="hidden" runat="server" />
                <asp:Label ID="labClassName" runat="server" Text="文件類別" Visible="False" meta:resourcekey="labClassNameResource1"></asp:Label>
            </asp:WizardStep>
            <asp:WizardStep ID="WizardStep7" runat="server" Title="6.參考文件" meta:resourcekey="WizardStep7Resource1">
                <asp:UpdatePanel ID="UpdatePanel4" runat="server">
                    <ContentTemplate>
                        <table>
                            <tr>
                                <td>
                                    <telerik:RadButton ID="wibtnDocRefLink" runat="server" Text="加入參考文件" meta:resourcekey="wibtnDocRefLinkResource1" OnClick="wibtnDocRefLink_Click" OnClientClicked="wibtnDocRefLink_ClientClick">
                                    </telerik:RadButton>
                                </td>                                
                                <td>
                                    &nbsp;
                                    &nbsp;
                                    &nbsp;
                                </td>
                                <td style="vertical-align:middle">
                                    <asp:CheckBox ID="cbRefLink" runat="server" Text="參考文件只限定於目前版本" meta:resourcekey="cbRefLinkResource1" />
                                    <asp:Label ID="Label11" runat="server" Text="(不勾選則表示參考文件不受版本限制)" ForeColor="Blue" meta:resourcekey="Label11Resource1"></asp:Label>
                                </td>
                            </tr>
                        </table>
                        
                        <br />
                        <asp:HiddenField ID="hidDocid" runat="server" />
                        <asp:HiddenField ID="hidRefDoc" runat="server" />
                        <Fast:Grid ID="gridDocRef" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateCheckBoxColumn="False"
                            AutoGenerateColumns="False" DataKeyOnClientWithCheckBox="False" OnRowCommand="gridDocRef_RowCommand"
                            EnhancePager="True"
                            Width="100%" OnPageIndexChanging="gridDocRef_PageIndexChanging" OnRowDataBound="gridDocRef_RowDataBound" OnSorting="gridDocRef_Sorting" DefaultSortDirection="Ascending" EmptyDataText="No data found" KeepSelectedRows="False" meta:resourcekey="gridDocRefResource1">
                            <EnhancePagerSettings
                                ShowHeaderPager="True" />
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
                                            <asp:Label ID="labDLFile" runat="server" Text='<%# Bind("DOC_NAME") %>' __designer:wfdid="w33" meta:resourceKey="labDLFileResource1"></asp:Label>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="保管者" meta:resourcekey="TemplateFieldResource5">
                                    <ItemTemplate>
                                        <uc2:UC_ChoiceList runat="server" ID="UC_ChoiceList1" IsAllowEdit="false"></uc2:UC_ChoiceList>
                                    </ItemTemplate>
                                    <HeaderStyle Wrap="False" Width="25%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="功能" meta:resourceKey="TemplateFieldResource2">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lbtnRemove" runat="server" CommandName="DelRefDoc" meta:resourceKey="lbtnRemoveResource1" Text="移除"></asp:LinkButton>&nbsp; 
                                        <!--Lala: 因考量當參考文件加入當下版本顯示資訊會影響，先把所有資訊隱藏-->
                                        <asp:LinkButton ID="lbtnInfo" runat="server" Visible="False" meta:resourceKey="lbtnInfoResource1" Text="資訊"></asp:LinkButton>
                                    </ItemTemplate>
                                    <HeaderStyle Width="7%" />
                                    <ItemStyle Wrap="False" />
                                </asp:TemplateField>
                            </Columns>
                        </Fast:Grid>
                        <asp:HiddenField ID="hideSelectRef" runat="server" />
                    </ContentTemplate>
                </asp:UpdatePanel>
            </asp:WizardStep>
            <asp:WizardStep ID="WizardStep5" runat="server" Title="7.編輯本文" meta:resourcekey="WizardStep5Resource1">
                <asp:Panel ID="pnlUploadFileDoc" runat="server" meta:resourcekey="pnlUploadFileDocResource1">
                    <table border="0" class="PopTable" cellspacing="1">
                        <tr>
                            <td style="width: 15%; white-space: nowrap" align="right" class="PopTableLeftTD">
                                <asp:Label ID="Label2" runat="server" Text="檔案" meta:resourcekey="Label2Resource1"></asp:Label>
                            </td>
                            <td style="width: 85%">
                                <uc2:UC_FileCenter runat="server" ID="UC_FileCenter" ProxyEnabled="true" />
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
                <asp:Panel ID="pnlUploadContentDoc" runat="server" meta:resourcekey="pnlUploadContentDocResource1">
                    <table>
                        <tr>
                            <td style="width: 100%;">
                                <uc2:UC_HtmlEditor runat="server" Width="100%" Height="750px" ID="DocContent" ProxyEnabled="true" />
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
                <asp:CustomValidator ID="CustomValidator1" runat="server" Display="Dynamic" ErrorMessage="請上傳檔案" meta:resourcekey="CustomValidator1Resource1" Visible="False"></asp:CustomValidator>
                <asp:CustomValidator ID="CustomValidator2" runat="server" Display="Dynamic" ErrorMessage="新增文件失敗" meta:resourcekey="CustomValidator2Resource1" Visible="False"></asp:CustomValidator>
            </asp:WizardStep>
        </WizardSteps>
        <SideBarButtonStyle ForeColor="White" />
        <HeaderStyle BackColor="Silver" BorderColor="#E6E2D8" BorderStyle="Solid" BorderWidth="2px" Font-Bold="False" ForeColor="Black" HorizontalAlign="Center" />
        <StartNavigationTemplate>
        </StartNavigationTemplate>
        <SideBarTemplate>
            <asp:DataList ID="SideBarList" runat="server" HorizontalAlign="Left" OnItemDataBound="SideBarList_ItemDataBound" meta:resourcekey="SideBarListResource1">
                <SelectedItemStyle Font-Bold="True" />
                <ItemTemplate>
                    &nbsp;&nbsp;<asp:Image ID="imgSideBar" runat="server" ImageAlign="Baseline" meta:resourcekey="imgSideBarResource1" />
                    <asp:LinkButton ID="SideBarButton" runat="server" ForeColor="Black" meta:resourcekey="SideBarButtonResource1"></asp:LinkButton>&nbsp;
                    <br />
                    <br />
                </ItemTemplate>
            </asp:DataList>
        </SideBarTemplate>
        <StepNavigationTemplate>
        </StepNavigationTemplate>
        <FinishNavigationTemplate>
        </FinishNavigationTemplate>
    </asp:Wizard>
    <asp:Label ID="lblUpload" runat="server" Text="請上傳檔案" Visible="False" meta:resourcekey="lblUploadResource1"></asp:Label>
    <asp:Label ID="lblAddError" runat="server" Text="新增文件失敗" meta:resourcekey="lblAddErrorResource1" Visible="False"></asp:Label>
    <asp:Label ID="lblPDFError" runat="server" Text="原稿控制已取消, 無法轉成PDF" Visible="False" meta:resourcekey="lblPDFErrorResource1"></asp:Label>
    <asp:Label ID="lblUnSelectUC_ApplyRead" runat="server" Text="請選擇調閱人員" Visible="False" meta:resourcekey="lblUnSelectUC_ApplyReadResource1"></asp:Label>
    <asp:Label ID="labDefApprove" runat="server" Text="由下列任一「目錄管理者」審核通過即可公佈" Visible="False" meta:resourcekey="labDefApproveResource1"></asp:Label>
    <asp:Label ID="labUseWKF" runat="server" Text="使用電子簽核，請選擇簽核流程" Visible="False" meta:resourcekey="labUseWKFResource1"></asp:Label>
    <asp:Label ID="lanNoApprove" runat="server" Text="此目錄無設定目錄管理者，無法進行審核設定" Visible="False" meta:resourcekey="lanNoApproveResource1"></asp:Label>
    <asp:Label ID="lblFolderPath" runat="server" Text="引用目錄：" Visible="False" meta:resourcekey="lblFolderPathResource1"></asp:Label>
    <asp:Label ID="labDocStore" runat="server" meta:resourcekey="labDocStoreResource1" Text="文件庫" Visible="False"></asp:Label>
    <asp:Label ID="lblNoWKFFlow" runat="server" Text="電子簽核沒有流程，請選擇簡易流程" Visible="False" meta:resourcekey="lblNoWKFFlowResource1"></asp:Label>
    <asp:HiddenField ID="hidFolderID" runat="server" />
    <asp:HiddenField ID="hdUploadState" runat="server"></asp:HiddenField>
    <asp:HiddenField ID="lblDocId" runat="server"></asp:HiddenField>
    <input id="hdFormId" runat="server" type="hidden" />
    <input id="hdNeedApprove" runat="server" type="hidden" />
    <input id="lblApproveType" runat="server" type="hidden" />
    <input id="lblDocname" runat="server" type="hidden" />
    <input id="lblNeedApprove" runat="server" type="hidden" />
    <input id="lblSecretRank" runat="server" type="hidden" />
    <input id="lblFileName" runat="server" type="hidden" />
    <input id="lblFolderName" runat="server" type="hidden" />
    <input id="hdIsUpLoad" runat="server" type="hidden" />
    <input id="hdDocSerial" runat="server" type="hidden" />
    <input id="hdSelectWKF" runat="server" type="hidden" />
    <input id="hdFileID" runat="server" type="hidden" />
    <asp:Label ID="lblFolderIsDelete" runat="server" Text="目錄已被刪除" Visible="False" meta:resourcekey="lblFolderIsDeleteResource1"></asp:Label>
    <asp:Label ID="lblSerialRepeat" runat="server" Text="文件編號已被使用" Visible="False" meta:resourcekey="lblSerialRepeatResource1"></asp:Label>
    <asp:Label ID="lblNameRepeat" runat="server" Text="文件名稱在此目錄已被使用" Visible="False" meta:resourcekey="lblNameRepeatResource1"></asp:Label>
    <asp:CustomValidator ID="cvPropertyLimit" runat="server" ErrorMessage="不可空白或沒選人員" Display="Dynamic" Visible="False" meta:resourcekey="cvPropertyLimitResource1"></asp:CustomValidator>
    <asp:CustomValidator ID="cvPropertyLimit2" runat="server" ErrorMessage="必須勾選文件類別" Display="Dynamic" Visible="False" meta:resourcekey="cvPropertyLimit2Resource1"></asp:CustomValidator>
    <asp:CustomValidator ID="cvPropertyLimit3" runat="server" ErrorMessage="必須加入參考文件" Display="Dynamic" Visible="False" meta:resourcekey="cvPropertyLimit3Resource1"></asp:CustomValidator>
    <asp:HiddenField ID="hfTaskID" runat="server" />
    <asp:HiddenField ID="hfReturnTaskID" runat="server" />
    <asp:Button ID="Button1" runat="server" Text="Button" Style="display: none;" OnClick="Button1_Click" meta:resourcekey="Button1Resource1" />
    <asp:HiddenField ID="hfApproveType" runat="server" />
    <asp:HiddenField ID="hfNeedApprove" runat="server" />
    <asp:HiddenField ID="hfIsPublish" runat="server" />
    <asp:HiddenField ID="hfstatus" runat="server" />
    <asp:Label ID="lblSelectMsg" runat="server" Text="請選擇" Visible="False" meta:resourcekey="lblSelectMsgResource1"></asp:Label>
    <asp:HiddenField runat="server" ID="hdUserGuid"></asp:HiddenField>
    <asp:Label ID="lblNoExtension" runat="server" Text="無法上傳無附檔名的檔案" Visible="False" meta:resourcekey="lblNoExtensionResource1"></asp:Label>
    <input id="hdSourceControl" runat="server" type="hidden" />
    <input id="hdSecretDefine" runat="server" type="hidden" />
    <input id="hdSource" runat="server" type="hidden" />
    <input id="hdSaveRow" runat="server" type="hidden" />
    <input id="hdPrintRow" runat="server" type="hidden" />
    <input id="hdCopyRow" runat="server" type="hidden" />
    <input id="hdLend" runat="server" type="hidden" />
    <input id="hdRef" runat="server" type="hidden" />
    <input id="hdDocName" runat="server" type="hidden" />
    <input id="hdUrgency" runat="server" type="hidden" />
    <input id="hdPublishUnit" runat="server" type="hidden" />
    <input id="hdSuitableDep" runat="server" type="hidden" />
    <asp:HiddenField ID="hfIsSkipApprove" runat="server" />
    <asp:Label ID="lblUploadContentDoc" runat="server" Text="7.編輯本文" Visible="False"
        meta:resourcekey="lblUploadContentDocResource1"></asp:Label>
    <asp:Label ID="lblUploadFile" runat="server" Text="7.檔案上傳" Visible="False"
        meta:resourcekey="lblUploadFileResource1"></asp:Label>
    <asp:Label ID="lblNeedDocName" runat="server" Text="請輸入文件標題" Visible="False" meta:resourcekey="lblNeedDocNameResource1"></asp:Label>
    <asp:Label ID="lblNeedDocContent" runat="server" Text="請輸入文件內容" Visible="False" meta:resourcekey="lblNeedDocContentResource1"></asp:Label>
    <asp:Label ID="lblAutoSerial" runat="server" Text="＊文件自動編號" Visible="False" meta:resourcekey="lblAutoSerialResource1"></asp:Label>
    <asp:Label ID="lblFullSerial" runat="server" Text="自動編號已達上限，請通知目錄管理員增加編號最大上限" Visible="False"
        meta:resourcekey="lblOverAutoSerialResource1"></asp:Label>
    <asp:Label ID="lblNewContent" runat="server" Text="編輯本文" Visible="False" meta:resourcekey="lblNewContentResource1"></asp:Label>
    <asp:Label ID="lblDocLink" runat="server" Text="文件連結" Visible="False" meta:resourcekey="lblDocLinkResource1"></asp:Label>
    <asp:Label ID="lblHistory" runat="server" Text="觀看版本歷程" Visible="False" meta:resourcekey="lblHistoryResource1"></asp:Label>
    <asp:Label ID="lblRef" runat="server" Text="觀看參考文件" Visible="False" meta:resourcekey="lblRefResource1"></asp:Label>
    <asp:Label ID="lblInfo" runat="server" Text="文件資訊" Visible="False" meta:resourcekey="lblInfoResource1"></asp:Label>
    <asp:HiddenField ID="hdFileName" runat="server" />
    <asp:HiddenField ID="hdContentAttachFileID" runat="server" />
    <asp:Label ID="lblVersionExist" runat="server" meta:resourcekey="lblVersionExistResource1" Text="已存在此手動版本" Visible="False"></asp:Label>
    <asp:HiddenField ID="hfVersion" runat="server" />
    <asp:HiddenField ID="hfContent" runat="server" />
    <asp:Label ID="labNoActive" runat="server" Text="未生效" Visible="False" meta:resourcekey="labNoActiveResource1"></asp:Label>
    <asp:Label ID="lblApproval" runat="server" Text="審核中" Visible="False" meta:resourcekey="lblApprovalResource1"></asp:Label>
    <asp:Label ID="lblPublish" runat="server" Text="已公佈" Visible="False" meta:resourcekey="lblPublishResource1"></asp:Label>
    <asp:Label ID="lblInactive" runat="server" Text="已失效" Visible="False" meta:resourcekey="lblInactiveResource1"></asp:Label>
    <asp:Label ID="lblVoid" runat="server" Text="已作廢" Visible="False" meta:resourcekey="lblVoidResource1"></asp:Label>
    <asp:Label ID="lblUpdating" runat="server" Text="改版中" Visible="False" meta:resourcekey="lblUpdatingResource1"></asp:Label>
    <asp:Label ID="lblVioding" runat="server" Text="(作廢審核中)" Visible="False" meta:resourcekey="lblViodingResource1"></asp:Label>
    <asp:Label ID="lblOldVer" runat="server" Text="舊版本" Visible="False" meta:resourcekey="lblOldVerResource1"></asp:Label>
    <asp:Label ID="lblReAct" runat="server" Text="已上架" Visible="False" meta:resourcekey="lblReActResource1"></asp:Label>
    <asp:Label ID="labDocDeny" runat="server" Text="發佈拒絕" Visible="False" meta:resourcekey="labDocDenyResource1"></asp:Label>
    <asp:Label ID="lblDraft" runat="server" Text="草稿" Visible="False" meta:resourcekey="lblDraftResource1"></asp:Label>
    <asp:Label ID="lblCheckIn" runat="server" Text="已存回" Visible="False" meta:resourcekey="lblCheckInResource1"></asp:Label>
    <asp:Label ID="lblCheckOut" runat="server" Text="已取出" Visible="False" meta:resourcekey="lblCheckOutResource1"></asp:Label>
    <asp:Label ID="lblTempInact" runat="server" Text="已下架" Visible="False" meta:resourcekey="lblTempInactResource1"></asp:Label>
    <asp:Label ID="lblChoiceBtntxt" runat="server" Text="選取部門" Visible="False" meta:resourcekey="lblChoiceBtntxtResource1"></asp:Label>
    <asp:Label ID="lblcvNonEmpty" runat="server" Text="不可空白" Visible="False" meta:resourcekey="lblcvNonEmptyResource1"></asp:Label>
    <asp:Label ID="lblDefaultVerDecimalPlaces" runat="server" Text=".0" Visible="false"></asp:Label>
    <asp:HiddenField ID="hfEvent" runat="server" />
    <asp:HiddenField ID="hfCurrentUser" runat="server" />
    <asp:HiddenField ID="hidScriptFileGroupID" runat="server" />
</asp:Content>

