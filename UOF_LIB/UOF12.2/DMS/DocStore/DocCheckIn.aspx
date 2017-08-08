<%@ Page Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" Inherits="DMS_DocStore_DocCheckIn" Title="文件存回" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="DocCheckIn.aspx.cs" %>

<%@ Register Src="../../Common/ChoiceCenter/UC_ChoiceList.ascx" TagName="UC_ChoiceList" TagPrefix="uc2" %>
<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Fast" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<%@ Register Src="~/Common/FileCenter/V3/UC_FileCenter.ascx" TagPrefix="uc2" TagName="UC_FileCenter" %>


<%@ Register src="../../Common/HtmlEditor/UC_HtmlEditor.ascx" tagname="UC_HtmlEditor" tagprefix="uc1" %>
<%@ Register Src="~/Common/ChoiceCenter/UC_ChoiceList.ascx" TagPrefix="uc1" TagName="UC_ChoiceList" %>



<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script id="DocCheckInjs" type="text/javascript">

        var arrayNodes = new Array();
        var hidClickValue;
        $(function () {

            ChangeActive();
            ChangeInvalid();

            hidClickValue = $("#<%=hidClickValue.ClientID %>");
            if (typeof (hidClickValue.val()) != "undefined") {
                arrayNodes = hidClickValue.val().split(";")
            }
            IsBorrow();

            //是否可更改調閱流程
            IsChangeLend();

            if (typeof ($("#ChoiceList1")) != "undefined") {
                var rblApplyRead = $("#<%=rblApplyRead.ClientID %>");
                var isrblApplyRead = $("#<%=rblApplyRead.ClientID%>").is(":checked");
                if (isrblApplyRead)
                    $("#ChoiceList1").css('visibility', 'hidden');
                else
                    $("#ChoiceList1").css('visibility', 'inherit');
            }

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

                var iscbChangeToPDF = $("#<%=cbChangeToPDF.ClientID%>").is(":checked");
                var ischkPrint = $("#<%=chkPrint.ClientID%>").is(":checked");
                var ischkSave = $("#<%=chkSave.ClientID%>").is(":checked");
                var ischkCopy = $("#<%=chkCopy.ClientID%>").is(":checked");

                var ischkUseParentSet = $("#<%=chkUseParentSet.ClientID %>").is(":checked");
                $("#<%=chkPrint.ClientID%>").prop("disabled", !iscbChangeToPDF || ischkUseParentSet);
                $("#<%=chkSave.ClientID%>").prop("disabled", !iscbChangeToPDF || ischkUseParentSet);
                $("#<%=chkCopy.ClientID%>").prop("disabled", !iscbChangeToPDF || ischkUseParentSet);
                $("#<%=rblApplyRead5.ClientID%>").attr("disabled", iscbChangeToPDF);


                if (iscbChangeToPDF) {
                    $("#<%=rblApplyRead2.ClientID%>").attr("disabled", !ischkPrint);
                    $("#<%=rblApplyRead3.ClientID%>").attr("disabled", !ischkSave);
                    $("#<%=rblApplyRead4.ClientID%>").attr("disabled", !ischkCopy);

                } else {


                    $("#<%=rblApplyRead2.ClientID%>").attr("disabled", !iscbChangeToPDF);
                    $("#<%=rblApplyRead3.ClientID%>").attr("disabled", !iscbChangeToPDF);
                    $("#<%=rblApplyRead4.ClientID%>").attr("disabled", !iscbChangeToPDF);

                    //原始檔控制
                    $('#Source_ChoiceList4').attr("disabled", true);
                    var btnEdit2_1 = $("#<%=UC_clApplyRead5.ClientID%>").find("#btnEdit2");
                    if (btnEdit2_1 != null)
                        $("#<%=UC_clApplyRead5.ClientID%>").find("#btnEdit2").attr("disabled", true);

                    //列印
            $('#Source_ChoiceList1').attr("disabled", true);
            var btnEdit2_2 = $("#<%=UC_clApplyRead2.ClientID%>").find("#btnEdit2");
            if (btnEdit2_2 != null)
                $("#<%=UC_clApplyRead2.ClientID%>").find("#btnEdit2").attr("disabled", true);

                    //另存
            $('#Source_ChoiceList2').attr("disabled", true);
            var btnEdit2_3 = $("#<%=UC_clApplyRead3.ClientID%>").find("#btnEdit2");
            if (btnEdit2_3 != null)
                $("#<%=UC_clApplyRead3.ClientID%>").find("#btnEdit2").attr("disabled", true);

                    //複製
            $('#Source_ChoiceList3').attr("disabled", true);
            var btnEdit2_4 = $("#<%=UC_clApplyRead4.ClientID%>").find("#btnEdit2");
            if (btnEdit2_4 != null)
                $("#<%=UC_clApplyRead4.ClientID%>").find("#btnEdit2").attr("disabled", true);
        }
    }

        });

function OnClientUploaded(id, name, path, size, contentType) {
    //alert(String.format("id={0},name={1},path={2},size={3},contentType={4}", id, name, path, size, contentType));
}

function OnClientRemoved(id) {
    //alert(String.format("id={0}", id));
}

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

function ChangeState() {
    var ischkUseParentSet = $("#<%=chkUseParentSet.ClientID %>").is(":checked");
    var iscbChangeToPDF = $("#<%=cbChangeToPDF.ClientID%>").is(":checked");
    var ischkPrint = $("#<%=chkPrint.ClientID%>").is(":checked");
    var ischkSave = $("#<%=chkSave.ClientID%>").is(":checked");
    var ischkCopy = $("#<%=chkSave.ClientID%>").is(":checked");

    $("#<%=chkPrint.ClientID%>").prop("disabled", !iscbChangeToPDF || ischkUseParentSet);
    $("#<%=chkSave.ClientID%>").prop("disabled", !iscbChangeToPDF || ischkUseParentSet);
    $("#<%=chkCopy.ClientID%>").prop("disabled", !iscbChangeToPDF || ischkUseParentSet);
    $("#<%=rblApplyRead5.ClientID%>").attr("disabled", iscbChangeToPDF);


    //轉成PDF是否Check
    if (iscbChangeToPDF) {
        //原始檔下載權限是否選擇"允許全部人員"        
        if ($('#<%=rblApplyRead5.ClientID %> input:checked').val() == "AllowALL" || $('#<%=rblApplyRead5.ClientID %> input:checked').val() == "DenyALL") {
            $('#Source_ChoiceList4').attr("disabled", true);
            $("#<%=UC_clApplyRead5.ClientID%>").find("#btnEdit2").attr("disabled", true);
        }
        else {
            $('#Source_ChoiceList4').attr("disabled", false);
            $("#<%=UC_clApplyRead5.ClientID%>").find("#btnEdit2").attr("disabled", true);
        }

        //可列印是否Check   
        if (ischkPrint) {
            $("#<%=rblApplyRead2.ClientID%>").attr("disabled", !ischkPrint);
            //可列印是否選擇"允許全部人員"
            if ($('#<%=rblApplyRead2.ClientID %> input:checked').val() == "AllowALL") {
                $('#Source_ChoiceList1').attr("disabled", true);
                $("#<%=UC_clApplyRead2.ClientID%>").find("#btnEdit2").attr("disabled", true);
            }
            else {
                $('#Source_ChoiceList1').attr("disabled", false);
                $("#<%=UC_clApplyRead2.ClientID%>").find("#btnEdit2").attr("disabled", false);
            }
        }
        else {
            $('#Source_ChoiceList1').attr("disabled", true);
            $("#<%=UC_clApplyRead2.ClientID%>").find("#btnEdit2").attr("disabled", true);
        }

        //可另存是否Check  
        if (ischkSave) {
            $("#<%=rblApplyRead2.ClientID%>").attr("disabled", !ischkSave);
            //可另存是否選擇"允許全部人員"
            if ($('#<%=rblApplyRead3.ClientID %> input:checked').val() == "AllowALL") {
                $('#Source_ChoiceList2').attr("disabled", true);
                $("#<%=UC_clApplyRead3.ClientID%>").find("#btnEdit2").attr("disabled", true);
            }
            else {
                $('#Source_ChoiceList2').attr("disabled", false);
                $("#<%=UC_clApplyRead3.ClientID%>").find("#btnEdit2").attr("disabled", false);
            }
        }
        else {
            $('#Source_ChoiceList2').attr("disabled", true);
            $("#<%=UC_clApplyRead3.ClientID%>").find("#btnEdit2").attr("disabled", true);
        }

        //可複製是否Check 
        if (ischkCopy) {
            $("#<%=UC_clApplyRead4.ClientID%>").attr("disabled", !ischkCopy);
            //可複製是否選擇"允許全部人員"
            if ($('#<%=rblApplyRead4.ClientID %> input:checked').val() == "AllowALL") {
                $('#Source_ChoiceList3').attr("disabled", true);
                $("#<%=UC_clApplyRead4.ClientID%>").find("#btnEdit2").attr("disabled", true);
             }
             else {
                 $('#Source_ChoiceList3').attr("disabled", false);
                 $("#<%=UC_clApplyRead4.ClientID%>").find("#btnEdit2").attr("disabled", false);
            }
        }
        else {
            $('#Source_ChoiceList3').attr("disabled", true);
            $("#<%=UC_clApplyRead4.ClientID%>").find("#btnEdit2").attr("disabled", true);
        }
    }
    else {
        $("#<%=rblApplyRead2.ClientID%>").attr("disabled", !iscbChangeToPDF);
        $("#<%=rblApplyRead3.ClientID%>").attr("disabled", !iscbChangeToPDF);
        $("#<%=rblApplyRead4.ClientID%>").attr("disabled", !iscbChangeToPDF);

        $('#Source_ChoiceList4').attr("disabled", !iscbChangeToPDF);
        $('#Source_ChoiceList3').attr("disabled", !iscbChangeToPDF);
        $('#Source_ChoiceList2').attr("disabled", !iscbChangeToPDF);
        $('#Source_ChoiceList1').attr("disabled", !iscbChangeToPDF);
        $("#<%=UC_clApplyRead5.ClientID%>").find("#btnEdit2").attr("disabled", !iscbChangeToPDF);
        $("#<%=UC_clApplyRead4.ClientID%>").find("#btnEdit2").attr("disabled", !iscbChangeToPDF);
        $("#<%=UC_clApplyRead3.ClientID%>").find("#btnEdit2").attr("disabled", !iscbChangeToPDF);
        $("#<%=UC_clApplyRead2.ClientID%>").find("#btnEdit2").attr("disabled", !iscbChangeToPDF);

    }


}

//判斷是否可列印,另存,複製
function ChangeState2(index) {
    switch (index) {
        //列印
        case 2:
            //可列印是否Check   
            var ischkPrint = $("#<%=chkPrint.ClientID%>").is(":checked");
            if (ischkPrint) {
                //可列印是否選擇"允許全部人員"
                if ($('#<%=rblApplyRead2.ClientID %> input:checked').val() == "AllowALL") {
                    $('#Source_ChoiceList1').attr("disabled", true);
                    $("#<%=UC_clApplyRead2.ClientID%>").find("#btnEdit2").attr("disabled", true);
                }
                else {
                    $('#Source_ChoiceList1').attr("disabled", false);
                    $("#<%=UC_clApplyRead2.ClientID%>").find("#btnEdit2").attr("disabled", false);
                }
            }
            else {
                $('#Source_ChoiceList1').attr("disabled", true);
                $("#<%=UC_clApplyRead2.ClientID%>").find("#btnEdit2").attr("disabled", true);
            }
            $("#<%=rblApplyRead2.ClientID%>").attr("disabled", !ischkPrint);
            break;

            //另存    
        case 3:
            var ischkSave = $("#<%=chkSave.ClientID%>").is(":checked");
            //可另存是否Check       
            if (ischkSave) {
                //可另存是否選擇"允許全部人員"
                if ($('#<%=rblApplyRead3.ClientID %> input:checked').val() == "AllowALL") {
                    $('#Source_ChoiceList2').attr("disabled", true);
                    $("#<%=UC_clApplyRead3.ClientID%>").find("#btnEdit2").attr("disabled", true);
                }
                else {
                    $('#Source_ChoiceList2').attr("disabled", false);
                    $("#<%=UC_clApplyRead3.ClientID%>").find("#btnEdit2").attr("disabled", false);
                }
            }
            else {
                $('#Source_ChoiceList2').attr("disabled", true);
                $("#<%=UC_clApplyRead3.ClientID%>").find("#btnEdit2").attr("disabled", true);
            }
            $("#<%=rblApplyRead3.ClientID%>").attr("disabled", !ischkSave);
            break;

            //複製    
        case 4:
            var ischkCopy = $("#<%=chkCopy.ClientID%>").is(":checked");
            //可複製是否Check    
            if (ischkCopy) {
                //可複製是否選擇"允許全部人員"
                if ($('#<%=rblApplyRead4.ClientID %> input:checked').val() == "AllowALL") {
                    $('#Source_ChoiceList3').attr("disabled", true);
                    $("#<%=UC_clApplyRead4.ClientID%>").find("#btnEdit2").attr("disabled", true);
                }
                else {
                    $('#Source_ChoiceList3').attr("disabled", false);
                    $("#<%=UC_clApplyRead4.ClientID%>").find("#btnEdit2").attr("disabled", false);
                }
            }
            else {
                $('#Source_ChoiceList3').attr("disabled", true);
                $("#<%=UC_clApplyRead4.ClientID%>").find("#btnEdit2").attr("disabled", true);
            }
            $("#<%=rblApplyRead4.ClientID%>").attr("disabled", !ischkCopy);
            break;
    }
}

//判斷原始檔選擇人員
function ChangeSelApplyUser5(theRadio) {

    if (theRadio == "") {
        $("#Source_ChoiceList4").css('visibility', 'hidden');
        $('#Source_ChoiceList4').attr("disabled", true);
        $("#<%=UC_clApplyRead5.ClientID%>").find("#btnEdit2").attr("disabled", true);
        return;
    }

    if (theRadio.value == "AllowALL" || theRadio.value == "DenyALL") {
        $("#Source_ChoiceList4").css('visibility', 'hidden');
        $('#Source_ChoiceList4').attr("disabled", true);
        $("#<%=UC_clApplyRead5.ClientID%>").find("#btnEdit2").attr("disabled", true);
    }
    else {
        $("#Source_ChoiceList4").css('visibility', 'visible');
        $('#Source_ChoiceList4').attr("disabled", false);
        $("#<%=UC_clApplyRead5.ClientID%>").find("#btnEdit2").attr("disabled", false);
    }
}

//判斷可列印選擇人員
function ChangeSelApplyUser2(theRadio) {

    if (theRadio == "") {
        $("#Source_ChoiceList1").css('visibility', 'hidden');
        $('#Source_ChoiceList1').attr("disabled", true);
        $("#<%=UC_clApplyRead2.ClientID%>").find("#btnEdit2").attr("disabled", true);
        return;
    }

    if (theRadio.value == "AllowALL") {
        $("#Source_ChoiceList1").css('visibility', 'hidden');
        $('#Source_ChoiceList1').attr("disabled", true);
        $("#<%=UC_clApplyRead2.ClientID%>").find("#btnEdit2").attr("disabled", true);
    }
    else {
        $("#Source_ChoiceList1").css('visibility', 'visible');
        $('#Source_ChoiceList1').attr("disabled", false);
        $("#<%=UC_clApplyRead2.ClientID%>").find("#btnEdit2").attr("disabled", false);
    }
}

//判斷可另存選擇人員
function ChangeSelApplyUser3(theRadio) {

    if (theRadio == "") {
        $("#Source_ChoiceList2").css('visibility', 'hidden');
        $('#Source_ChoiceList2').attr("disabled", true);
        $("#<%=UC_clApplyRead3.ClientID%>").find("#btnEdit2").attr("disabled", true);
        return;
    }

    if (theRadio.value == "AllowALL") {
        $("#Source_ChoiceList2").css('visibility', 'hidden');
        $('#Source_ChoiceList2').attr("disabled", true);
        $("#<%=UC_clApplyRead3.ClientID%>").find("#btnEdit2").attr("disabled", true);
    }
    else {
        $("#Source_ChoiceList2").css('visibility', 'visible');
        $('#Source_ChoiceList2').attr("disabled", false);
        $("#<%=UC_clApplyRead3.ClientID%>").find("#btnEdit2").attr("disabled", false);
    }
}

//判斷可複製選擇人員
function ChangeSelApplyUser4(theRadio) {

    if (theRadio == "") {
        $("#Source_ChoiceList3").css('visibility', 'hidden');
        $('#Source_ChoiceList3').attr("disabled", true);
        $("#<%=UC_clApplyRead4.ClientID%>").find("#btnEdit2").attr("disabled", true);
        return;
    }

    if (theRadio.value == "AllowALL") {
        $("#Source_ChoiceList3").css('visibility', 'hidden');
        $('#Source_ChoiceList3').attr("disabled", true);
        $("#<%=UC_clApplyRead4.ClientID%>").find("#btnEdit2").attr("disabled", true);
    }
    else {
        $("#Source_ChoiceList3").css('visibility', 'visible');
        $('#Source_ChoiceList3').attr("disabled", false);
        $("#<%=UC_clApplyRead4.ClientID%>").find("#btnEdit2").attr("disabled", false);
    }
}

//是否可更改調閱流程
function IsChangeLend() {
    var chkBorrow = $("#<%=chkBorrow.ClientID%>");
    if (chkBorrow != null) {
        var isdisable = $("#<%=chkBorrow.ClientID%>").is(':disabled');
        if (isdisable) //chkBorrow.disabled
        {
            $('#ChoiceList1').attr("disabled", isdisable);

        }
    }
}

function IsBorrow() {
    var chkBorrow = $("#<%=chkBorrow.ClientID%>");
    var rblApplyRead = $("#<%=rblApplyRead.ClientID%>");
    var ChoiceList1 = $('#ChoiceList1');
    var rblReadProcedure = $("#<%=rblReadProcedure.ClientID%>");

    var ddlUseWKFList = $("#<%=ddlUseWKFList.ClientID%>");
    var wibtnSelectFlow = $("#<%=wibtnSelectFlow.ClientID%>");
    var WKFFlow = $('#WKFFlow');

    if (typeof (chkBorrow) != 'undefined') {
        var isdisable = $("#<%=chkBorrow.ClientID%>").is(':disabled');
        var ischkBorrow = $("#<%=chkBorrow.ClientID%>").is(":checked");
        if (!isdisable) {
            $("#<%=rblApplyRead.ClientID%>").attr("disabled", !ischkBorrow);
            $("#<%=rblReadProcedure.ClientID%>").attr("disabled", !ischkBorrow);
            $('#ChoiceList1').attr("disabled", !ischkBorrow);
            if (wibtnSelectFlow != null) {
                $("#<%=ddlUseWKFList.ClientID%>").attr("disabled", !ischkBorrow);
                $("#<%=wibtnSelectFlow.ClientID%>").attr("disabled", !ischkBorrow);
                $('#WKFFlow').attr("disabled", !ischkBorrow);
            }
        }
    }
}

//判斷是否轉成PDF  
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
        if ($('#<%=rblApplyRead5.ClientID %> input:checked').val() == "AllowALL" || $('#<%=rblApplyRead5.ClientID %> input:checked').val() == "DenyALL") {
            $('#Source_ChoiceList4').attr("disabled", true);
            $("#<%=UC_clApplyRead5.ClientID%>").find("#btnEdit2").attr("disabled", true);
        }
        else {
            $('#Source_ChoiceList4').attr("disabled", false);
            $("#<%=UC_clApplyRead5.ClientID%>").find("#btnEdit2").attr("disabled", false);
        }

        //可列印是否Check   
        var ischkPrint = $("#<%=chkPrint.ClientID%>").is(":checked");
        if (ischkPrint) {
            $("#<%=rblApplyRead2.ClientID%>").attr("disabled", !ischkPrint);
            //可列印是否選擇"允許全部人員"
            if ($('#<%=rblApplyRead2.ClientID %> input:checked').val() == "AllowALL") {
                $('#Source_ChoiceList1').attr("disabled", true);
                $("#<%=UC_clApplyRead2.ClientID%>").find("#btnEdit2").attr("disabled", true);
            }
            else {
                $('#Source_ChoiceList1').attr("disabled", false);
                $("#<%=UC_clApplyRead2.ClientID%>").find("#btnEdit2").attr("disabled", false);
            }
        }
        else {
            $('#Source_ChoiceList1').attr("disabled", true);
            $("#<%=UC_clApplyRead2.ClientID%>").find("#btnEdit2").attr("disabled", true);
        }

        //可另存是否Check  
        var ischkSave = $("#<%=chkSave.ClientID%>").is(":checked");
        if (ischkSave) {
            $("#<%=rblApplyRead3.ClientID%>").attr("disabled", !ischkSave);
            //可另存是否選擇"允許全部人員"
            if ($('#<%=rblApplyRead3.ClientID %> input:checked').val() == "AllowALL") {
                $('#Source_ChoiceList2').attr("disabled", true);
                $("#<%=UC_clApplyRead3.ClientID%>").find("#btnEdit2").attr("disabled", true);
            }
            else {
                $('#Source_ChoiceList2').attr("disabled", false);
                $("#<%=UC_clApplyRead3.ClientID%>").find("#btnEdit2").attr("disabled", false);
            }
        }
        else {
            $('#Source_ChoiceList2').attr("disabled", true);
            $("#<%=UC_clApplyRead3.ClientID%>").find("#btnEdit2").attr("disabled", true);
        }

        //可複製是否Check 
        var ischkCopy = $("#<%=chkCopy.ClientID%>").is(":checked");
        if (ischkCopy) {
            $("#<%=rblApplyRead4.ClientID%>").attr("disabled", !ischkCopy);
            //可複製是否選擇"允許全部人員"
            if ($('#<%=rblApplyRead4.ClientID %> input:checked').val() == "AllowALL") {
                $('#Source_ChoiceList3').attr("disabled", true);
                $("#<%=UC_clApplyRead4.ClientID%>").find("#btnEdit2").attr("disabled", true);
            }
            else {
                $('#Source_ChoiceList3').attr("disabled", false);
                $("#<%=UC_clApplyRead4.ClientID%>").find("#btnEdit2").attr("disabled", true);
            }
        }
        else {
            $('#Source_ChoiceList3').attr("disabled", true);
            $("#<%=UC_clApplyRead4.ClientID%>").find("#btnEdit2").attr("disabled", true);
        }
    }
    else {
        $("#<%=rblApplyRead2.ClientID%>").attr("disabled", !iscbChangeToPDF);
        $("#<%=rblApplyRead3.ClientID%>").attr("disabled", !iscbChangeToPDF);
        $("#<%=rblApplyRead4.ClientID%>").attr("disabled", !iscbChangeToPDF);


        $('#Source_ChoiceList4').attr("disabled", !iscbChangeToPDF);
        $('#Source_ChoiceList3').attr("disabled", !iscbChangeToPDF);
        $('#Source_ChoiceList2').attr("disabled", !iscbChangeToPDF);
        $('#Source_ChoiceList1').attr("disabled", !iscbChangeToPDF);
        $("#<%=UC_clApplyRead5.ClientID%>").find("#btnEdit2").attr("disabled", !iscbChangeToPDF);
        $("#<%=UC_clApplyRead4.ClientID%>").find("#btnEdit2").attr("disabled", !iscbChangeToPDF);
        $("#<%=UC_clApplyRead3.ClientID%>").find("#btnEdit2").attr("disabled", !iscbChangeToPDF);
        $("#<%=UC_clApplyRead2.ClientID%>").find("#btnEdit2").attr("disabled", !iscbChangeToPDF);
    }


}

function ChangeSelApplyUser(theRadio) {
    if (theRadio == "") {
        $("#ChoiceList1").css('visibility', 'hidden');
        return;
    }

    if (theRadio.value == "AllowALL")
        $("#ChoiceList1").css('visibility', 'hidden');
    else
        $("#ChoiceList1").css('visibility', 'visible');
}

//判斷原始檔選擇人員
function ChangeSelApplyUser5(theRadio) {

    if (theRadio == "") {
        $("#Source_ChoiceList4").css('visibility', 'hidden');
        $('#Source_ChoiceList4').attr("disabled", true);
        $("#<%=UC_clApplyRead5.ClientID%>").find("#btnEdit2").attr("disabled", true);
        return;
    }

    if (theRadio.value == "AllowALL" || theRadio.value == "DenyALL") {
        $("#Source_ChoiceList4").css('visibility', 'hidden');
        $('#Source_ChoiceList4').attr("disabled", true);
        $("#<%=UC_clApplyRead5.ClientID%>").find("#btnEdit2").attr("disabled", true);
    }
    else {
        $("#Source_ChoiceList4").css('visibility', 'visible');
        $('#Source_ChoiceList4').attr("disabled", false);
        $("#<%=UC_clApplyRead5.ClientID%>").find("#btnEdit2").attr("disabled", false);
    }
}

//判斷可列印選擇人員
function ChangeSelApplyUser2(theRadio) {

    if (theRadio == "") {
        $("#Source_ChoiceList1").css('visibility', 'hidden');
        $('#Source_ChoiceList1').attr("disabled", true);
        $("#<%=UC_clApplyRead2.ClientID%>").find("#btnEdit2").attr("disabled", true);
        return;
    }

    if (theRadio.value == "AllowALL") {
        $("#Source_ChoiceList1").css('visibility', 'hidden');
        $('#Source_ChoiceList1').attr("disabled", true);
        $("#<%=UC_clApplyRead2.ClientID%>").find("#btnEdit2").attr("disabled", true);
    }
    else {
        $("#Source_ChoiceList1").css('visibility', 'visible');
        $('#Source_ChoiceList1').attr("disabled", false);
        $("#<%=UC_clApplyRead2.ClientID%>").find("#btnEdit2").attr("disabled", false);
    }
}

//判斷可另存選擇人員
function ChangeSelApplyUser3(theRadio) {

    if (theRadio == "") {
        $("#Source_ChoiceList2").css('visibility', 'hidden');
        $('#Source_ChoiceList2').attr("disabled", true);
        $("#<%=UC_clApplyRead3.ClientID%>").find("#btnEdit2").attr("disabled", true);
        return;
    }

    if (theRadio.value == "AllowALL") {
        $("#Source_ChoiceList2").css('visibility', 'hidden');
        $('#Source_ChoiceList2').attr("disabled", true);
        $("#<%=UC_clApplyRead3.ClientID%>").find("#btnEdit2").attr("disabled", true);
    }
    else {
        $("#Source_ChoiceList2").css('visibility', 'visible');
        $('#Source_ChoiceList2').attr("disabled", false);
        $("#<%=UC_clApplyRead3.ClientID%>").find("#btnEdit2").attr("disabled", false);
    }
}

//判斷可複製選擇人員
function ChangeSelApplyUser4(theRadio) {

    if (theRadio == "") {
        $("#Source_ChoiceList3").css('visibility', 'hidden');
        $('#Source_ChoiceList3').attr("disabled", true);
        $("#<%=UC_clApplyRead4.ClientID%>").find("#btnEdit2").attr("disabled", true);
        return;
    }

    if (theRadio.value == "AllowALL") {
        $("#Source_ChoiceList3").css('visibility', 'hidden');
        $('#Source_ChoiceList3').attr("disabled", true);
        $("#<%=UC_clApplyRead4.ClientID%>").find("#btnEdit2").attr("disabled", true);
    }
    else {
        $("#Source_ChoiceList3").css('visibility', 'visible');
        $('#Source_ChoiceList3').attr("disabled", false);
        $("#<%=UC_clApplyRead4.ClientID%>").find("#btnEdit2").attr("disabled", false);
    }
}

function wibtnSelectFlow_Click(button, args) {
    var ddlUseWKFList = $("#<%=ddlUseWKFList.ClientID%>");
    var FormVersionId = $("#<%=ddlUseWKFList.ClientID %>").val().split(',');
    $uof.dialog.open2("~/WKF/Browse/ViewMasterFlow.aspx", button, "", 900, 800, function (returnValue) { return false; }, { "formVersionId": FormVersionId[0], "flowId": FormVersionId[1] });
    return false;
}


function ChangeActive() {
    var rdoActive1 = $("#<%=rdoActiveDay1.ClientID%>");
    var datePicker = $find("<%= RadDatePicker1.ClientID %>");
    var cbActiveEqualPublish = $("#<%=cbActiveEqualPublish.ClientID%>");
    if (datePicker) {
        var bIsChecked = $("#<%=this.rdoActiveDay1.ClientID %>").is(":checked");
        if (typeof (rdoActive1) != "undefined" && typeof (datePicker) != "undefined") {
            if (bIsChecked) {
                datePicker.set_enabled(false);
                cbActiveEqualPublish.attr("disabled", true);
            } else {
                datePicker.set_enabled(true);
                cbActiveEqualPublish.attr("disabled", false);
            }
        }
    }
}

function ChangeInvalid() {
    var rdoInvalid1 = $("#<%=rdoInvalidDay1.ClientID%>");
    var bIsChecked = $("#<%=this.rdoInvalidDay2.ClientID %>").is(":checked");

    var datepicker = $find("<%= RadDatePicker2.ClientID %>");
    if (datepicker) {
        if (typeof (rdoInvalid1) != "undefined" && typeof (datepicker) != "undefined") {
            var rdoinvalidvalue = rdoInvalid1.filter(':checked').val();

            if (bIsChecked) {
                datepicker.set_enabled(true);
            } else {
                datepicker.set_enabled(false);
            }
        }
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

        function maxsize() {
            window.dialogWidth = '700px';
            window.dialogHeight = '700px';

        }

        function sourceControlSize() {
            var SourceControl = $('#SourceControl');
            if (SourceControl.length > 0)
                SourceControl.width(484);
        }
        // -->
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
            var tree = $find("<%=myClassTree.ClientID %>");
            if (tree != null && tree != 'undefined') {
                tree.get_element().style.height = Y - 30 + "px";
                tree.get_element().style.width = X - 126 + "px";
            }
        }
    </script>
    <table border="0" style="width:100%">
        <tr>
            <td style="text-align: center!important;" class="PopTableHeader">
                <asp:Label ID="Label9" runat="server" Text="文件存回" meta:resourcekey="Label12Resource1"></asp:Label></td>
        </tr>
    </table>
    <asp:Wizard ID="Wizard1" runat="server" ActiveStepIndex="0" BackColor="#F7F6F3" BorderColor="#999999"
        BorderWidth="1px" EnableTheming="True" BorderStyle="Solid"
        Height="92%" Width="100%" meta:resourcekey="Wizard1Resource1" OnNextButtonClick="Wizard1_NextButtonClick" OnSideBarButtonClick="Wizard1_SideBarButtonClick">
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
            <asp:WizardStep ID="WizardStep1" runat="server" Title="1.基本屬性" meta:resourcekey="WizardStepResource1">
                    <table class="PopTable" style="width:100%" id="PropertyTable" runat="server">
                        <tr>
                            <td style=" white-space:nowrap;">
                                <asp:Label ID="Label12" runat="server" Text="文件名稱" meta:resourcekey="Label12Resource2"></asp:Label>
                            </td>
                            <td colspan="3" >
                                <asp:TextBox ID="txtDocName" runat="server" Width="100%" meta:resourcekey="txtDocNameResource1"></asp:TextBox>
                            </td>
                            
                        </tr>
                        <tr>
                            <td style=" white-space:nowrap;">
                                <asp:Label ID="Label11" runat="server" Text="文件編號" meta:resourcekey="Label11Resource1"></asp:Label>
                            </td>
                            <td colspan="3" >
                                <asp:TextBox ID="txtSerial" runat="server" Width="100%" meta:resourcekey="txtSerialResource1"></asp:TextBox>
                            </td>
                        </tr>
                         <tr>
                            <td style=" white-space:nowrap;">
                                <asp:Label ID="lblUrgency" runat="server" Text="文件速別" meta:resourcekey="lblUrgencyResource1"></asp:Label>
                            </td>
                            <td colspan="3" >
                                <asp:RadioButton ID="rdoUrgencyNormal" runat="server" GroupName="Urgency" Text="普通" Checked="true" meta:resourcekey="rdoUrgencyNormalResource1" />
                                <asp:RadioButton ID="rdoUrgencyHigh" runat="server" GroupName="Urgency" Text="急" meta:resourcekey="rdoUrgencyHighResource1"/>
                                <asp:RadioButton ID="rdoUrgencyExHigh" runat="server" GroupName="Urgency" Text="緊急" meta:resourcekey="rdoUrgencyExHighResource1" />
                            </td>
                        </tr>
                        <tr>
                            <td style=" white-space:nowrap;">
                                <asp:Label ID="Label2" runat="server" Text="版本備註" meta:resourcekey="Label2Resource1"></asp:Label>
                            </td>
                            <td colspan="3" >
                                <asp:TextBox ID="txtVersionMemo" runat="server" Rows="5" TextMode="MultiLine" Width="100%" meta:resourcekey="txtVersionMemoResource1"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td style=" white-space:nowrap;">
                                <asp:Label ID="Label13" runat="server" Text="發行單位" meta:resourcekey="Label13Resource1"></asp:Label>
                            </td>
                            <td style="width:200px">
                                <uc2:UC_ChoiceList ID="UC_ChoiceList1" runat="server" ChioceType="Group" ExpandToUser="false" ShowMember="false"  IsAllowEdit="true" />
                            </td>
                            <td><asp:Label ID="Label14" runat="server" Text="保管者" meta:resourcekey="Label14Resource1"></asp:Label></td>
                            <td style="width:200px"><uc2:UC_ChoiceList ID="UC_ChoiceList2" runat="server" IsAllowEdit="true" ShowMember="false" ChioceType="User" ExpandToUser="false" /></td>
                        </tr>
                         <tr>
                            <td style=" white-space:nowrap;">
                                <asp:Label ID="lblAuthDep" runat="server" Text="權責部門" meta:resourcekey="lblAuthDepResource1"></asp:Label>
                            </td>
                            <td>
                                <uc1:UC_ChoiceList runat="server" ID="clAuthDep" ChioceType="Group" ExpandToUser="false" ShowMember="false"/>
                            </td>
                            <td style=" white-space:nowrap;">
                                <asp:Label ID="lblSuitableDep" runat="server" Text="適用部門" meta:resourcekey="lblSuitableDepResource1"></asp:Label>
                            </td>
                            <td>
                                <uc2:UC_ChoiceList ID="clSuitableDep" runat="server" ChioceType="Group" ExpandToUser="false" ShowMember="false"/>
                            </td>
                        </tr>
                        <tr>
                            <td style=" white-space:nowrap;">
                                <asp:Label ID="Label15" runat="server" Text="摘要" meta:resourcekey="Label15Resource1"></asp:Label>
                            </td>
                            <td colspan="3" >
                                <asp:TextBox ID="txtDOC_COMMENT" runat="server" Rows="5" TextMode="MultiLine" Width="100%" meta:resourcekey="txtDOC_COMMENTResource1"></asp:TextBox>
                            </td>
                        </tr>                        
                        <tr>                        
                        <td style=" white-space:nowrap;">
                            <asp:Label ID="Label10" runat="server" Text="關鍵字" meta:resourcekey="LabelKeyWordResource1"></asp:Label>
                        </td>
                        <td colspan="3" >
                            <asp:TextBox ID="txtKeyWord" runat="server" Rows="5" meta:resourceKey="txtDOC_COMMENTResource1"
                                TextMode="MultiLine" Width="100%"></asp:TextBox>
                        </td>
                        </tr>                        
                    </table>
            </asp:WizardStep>
            <asp:WizardStep runat="server" Title="2.保存期限" meta:resourcekey="WizardStepResource2">
                <table border="0" class="PopTable">
                    <tr>
                        <td style="width: 23%" rowspan="2" class="PopTableLeftTD">
                            <asp:Label ID="Label7" runat="server" Text="生效設定" meta:resourcekey="Label7Resource1"></asp:Label>
                        </td>
                        <td colspan="2" class="PopTableRightTD" >
                            <asp:RadioButton ID="rdoActiveDay1" runat="server" Checked="True" Text="立即生效" GroupName="Active" meta:resourcekey="rdoActiveDay1Resource1" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" class="PopTableRightTD" style="width: 63px; padding: 0px 0px 0px 0px">
                            <table >
                                <tr>
                                    <td  style="text-align: left">
                                        <asp:RadioButton ID="rdoActiveDay2" runat="server" Text="生效日" GroupName="Active" meta:resourcekey="rdoActiveDay2Resource1" />
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
                        <td style="width: 23%" rowspan="2" class="PopTableLeftTD">
                            <asp:Label ID="Label8" runat="server" Text="過期設定" meta:resourcekey="Label8Resource1"></asp:Label>
                        </td>
                        <td colspan="2" class="PopTableRightTD" >
                            <asp:RadioButton ID="rdoInvalidDay1" runat="server" Checked="True" Text="永不過期" GroupName="Invalid" meta:resourcekey="rdoInvalidDay1Resource1" />
                        </td>
                    </tr>
                    <tr>
                        <td class="PopTableRightTD" style="width: 80%; padding: 0px 0px 0px 0px">
                            <table style="width: 100%;">
                                <tr>
                                    <td class="PopTableRightTD" style="width: 63px; text-align: left;">
                                        <asp:RadioButton ID="rdoInvalidDay2" runat="server" Text="到期日" GroupName="Invalid" meta:resourcekey="rdoInvalidDay2Resource1" />
                                        <telerik:RadDatePicker ID="RadDatePicker2" runat="server" meta:resourcekey="RadDatePicker2Resource1">
                                        </telerik:RadDatePicker>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
                <asp:CustomValidator ID="CustomValidator4" runat="server" Display="Dynamic" ErrorMessage="保存期限設定錯誤" meta:resourcekey="CustomValidator4Resource1" Visible="False"></asp:CustomValidator>
            </asp:WizardStep>
            <asp:WizardStep runat="server" Title="3.機密設定" meta:resourcekey="WizardStepResource3">
                <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                    <ContentTemplate>
                        <table class="PopTable">
                            <tr>
                                <td style="width: 100%; text-align: left" colspan="2" class="PopTableRightTD">
                                    <asp:CheckBox ID="chkUseParentSet" runat="server" Text="使用父目錄的機密設定" AutoPostBack="True" OnCheckedChanged="chkUseParentSet_CheckedChanged" meta:resourcekey="chkUseParentSetResource1"></asp:CheckBox>
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 33px; width: 23%" class="PopTableLeftTD">
                                    <asp:Label ID="Label3" runat="server" Text="機密等級" meta:resourcekey="Label3Resource1"></asp:Label>
                                </td>
                                <td style="width: 346px; height: 33px" class="PopTableRightTD">&nbsp;<asp:DropDownList ID="dwnSecret" runat="server" Width="92px" meta:resourcekey="dwnSecretResource1">
                                    <asp:ListItem Value="Normal" meta:resourcekey="ListItemResource3" Text="一般"></asp:ListItem>
                                    <asp:ListItem Value="Secret" meta:resourcekey="ListItemResource4" Text="密"></asp:ListItem>
                                    <asp:ListItem Value="XSecret" meta:resourcekey="ListItemResource5" Text="機密"></asp:ListItem>
                                    <asp:ListItem Value="XXSecret" meta:resourcekey="ListItemResource6" Text="極機密"></asp:ListItem>
                                    <asp:ListItem Value="TopSecret" meta:resourcekey="ListItemResource7" Text="絕對機密"></asp:ListItem>
                                </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td style=" white-space:nowrap;">
                                    <asp:Label ID="Label5" runat="server" Text="共同編輯" meta:resourcekey="Label5Resource1"></asp:Label>
                                </td>
                                <td >
                                    <asp:CheckBox ID="chkCOMMON_EDIT" runat="server" Text="允許作者群共同編輯" meta:resourcekey="chkCOMMON_EDITResource1" />
                                </td>
                            </tr>
                            <tr id="OriginalManuscriptTR" runat="server">
                                <td runat="server" >

                                    <asp:Label ID="Label4" runat="server" Text="原稿控制" meta:resourcekey="Label4Resource1"></asp:Label>
                                </td>
                                <td runat="server" >

                                    <table style="width:100%">
                                        <tr>
                                            <td colspan="3">
                                                <asp:CheckBox ID="cbChangeToPDF" runat="server" Text="轉成PDF" Checked="True" meta:resourcekey="cbChangeToPDFResource1" AutoPostBack="True" OnCheckedChanged="cbChangeToPDF_CheckedChanged" /></td>
                                        </tr>
                                        <tr style="display:none;">
                                            <td>
                                                <asp:CheckBox ID="chkPrint" runat="server" Text="可列印" meta:resourcekey="chkPrintResource1" AutoPostBack="True" OnCheckedChanged="chkPrint_CheckedChanged" />
                                            </td>
                                            <td>
                                                <asp:RadioButtonList ID="rblApplyRead2" runat="server" CssClass='SizeS' CellPadding="0" CellSpacing="0" AutoPostBack="True" RepeatDirection="Horizontal" OnSelectedIndexChanged="rblApplyRead2_SelectedIndexChanged">
                                                    <asp:ListItem Selected="True" Value="AllowALL" meta:resourcekey="ListItemResource8" Text="允許全部人員"></asp:ListItem>
                                                    <asp:ListItem Value="AllowList" meta:resourcekey="ListItemResource13" Text="允許下列人員"></asp:ListItem>
                                                    <asp:ListItem Value="DenyList" meta:resourcekey="ListItemResource14" Text="不允許下列人員"></asp:ListItem>
                                                </asp:RadioButtonList>
                                            </td>
                                            </tr>
                                        <tr style="display:none;">
                                            <td colspan="3" style="width: 100%">&nbsp;<div id="Source_ChoiceList1" style="max-height: 100px; overflow: auto;" runat="server">
                                                <uc2:UC_ChoiceList ID="UC_clApplyRead2" runat="server"  ExpandToUser="false"
                                                    IsAllowEdit="true"></uc2:UC_ChoiceList>
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
                                                <asp:RadioButtonList ID="rblApplyRead3" runat="server" CssClass='SizeS' CellPadding="0" CellSpacing="0" AutoPostBack="True" RepeatDirection="Horizontal" OnSelectedIndexChanged="rblApplyRead2_SelectedIndexChanged">
                                                    <asp:ListItem Selected="True" Value="AllowALL" meta:resourcekey="ListItemResource8" Text="允許全部人員"></asp:ListItem>
                                                    <asp:ListItem Value="AllowList" meta:resourcekey="ListItemResource13" Text="允許下列人員"></asp:ListItem>
                                                    <asp:ListItem Value="DenyList" meta:resourcekey="ListItemResource14" Text="不允許下列人員"></asp:ListItem>
                                                </asp:RadioButtonList>
                                            </td>
                                            </tr>
                                        <tr>
                                            <td colspan="3">&nbsp;<div id="Source_ChoiceList2" style="max-height: 100px; overflow: auto;" runat="server">
                                                <uc2:UC_ChoiceList ID="UC_clApplyRead3" runat="server"  ExpandToUser="false"
                                                    IsAllowEdit="true"></uc2:UC_ChoiceList>
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
                                                <asp:RadioButtonList ID="rblApplyRead4" runat="server" CssClass='SizeS' CellPadding="0" CellSpacing="0" AutoPostBack="True" RepeatDirection="Horizontal" OnSelectedIndexChanged="rblApplyRead2_SelectedIndexChanged">
                                                    <asp:ListItem Selected="True" Value="AllowALL" meta:resourcekey="ListItemResource8" Text="允許全部人員"></asp:ListItem>
                                                    <asp:ListItem Value="AllowList" meta:resourcekey="ListItemResource13" Text="允許下列人員"></asp:ListItem>
                                                    <asp:ListItem Value="DenyList" meta:resourcekey="ListItemResource14" Text="不允許下列人員"></asp:ListItem>
                                                </asp:RadioButtonList>
                                            </td>
                                         </tr>
                                         <tr style="display:none;">
                                            <td colspan="3">&nbsp;<div id="Source_ChoiceList3" style="max-height: 100px; overflow: auto;" runat="server">
                                                <uc2:UC_ChoiceList ID="UC_clApplyRead4" runat="server"  ExpandToUser="false"
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
                                                <asp:RadioButtonList ID="rblApplyRead5" runat="server" CssClass='SizeS' CellPadding="0" CellSpacing="0" AutoPostBack="True" RepeatDirection="Horizontal" OnSelectedIndexChanged="rblApplyRead2_SelectedIndexChanged">
                                                    <asp:ListItem Selected="True" Value="DenyALL" meta:resourcekey="ListItemResource11" Text="全部不允許"></asp:ListItem>
                                                    <asp:ListItem Value="AllowALL" meta:resourcekey="ListItemResource8" Text="允許全部人員"></asp:ListItem>
                                                    <asp:ListItem Value="AllowList" meta:resourcekey="ListItemResource13" Text="允許下列人員"></asp:ListItem>
                                                    <asp:ListItem Value="DenyLis" meta:resourcekey="ListItemResource14" Text="不允許下列人員"></asp:ListItem>
                                                </asp:RadioButtonList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="3">&nbsp;<div id="Source_ChoiceList4" style="max-height: 100px; overflow: auto;" runat="server">
                                                <uc2:UC_ChoiceList ID="UC_clApplyRead5" runat="server"  ExpandToUser="false"
                                                    IsAllowEdit="true"></uc2:UC_ChoiceList>
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
            <asp:WizardStep runat="server" Title="4.調閱權限" meta:resourcekey="WizardStepResource4">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <br />
                        <table class="PopTable">
                            <tr>
                                <td colspan="2" class="PopTableRightTD" style="text-align: left;">
                                    <asp:CheckBox ID="chkUseParentSetup" runat="server" AutoPostBack="True" OnCheckedChanged="chkUseParentSetup_CheckedChanged"
                                        Text="使用父目錄的調閱設定" meta:resourcekey="chkUseParentSetupResource1" />
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 23%; height: 138px; text-align:right; vertical-align:middle" class="PopTableLeftTD">
                                    <asp:Label ID="Label20" runat="server" Text="調閱申請" meta:resourcekey="Label20Resource1"></asp:Label>
                                </td>
                                <td style="width: 346px; height: 138px; vertical-align:top" class="PopTableRightTD">
                                    <asp:CheckBox ID="chkBorrow" runat="server" Text="允許調閱申請" Checked="True" onclick="IsBorrow()" AutoPostBack="True" OnCheckedChanged="chkBorrow_CheckedChanged" meta:resourcekey="chkBorrowResource1" />
                                    &nbsp;<br />
                                    <asp:RadioButtonList ID="rblApplyRead" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="rblApplyRead_SelectedIndexChanged" meta:resourcekey="rblApplyReadResource1">
                                        <asp:ListItem Selected="True" Value="AllowALL" meta:resourcekey="ListItemResource12" Text="允許全部人員"></asp:ListItem>
                                        <asp:ListItem Value="AllowList" meta:resourcekey="ListItemResource13" Text="允許下列人員"></asp:ListItem>
                                        <asp:ListItem Value="DenyList" meta:resourcekey="ListItemResource14" Text="不允許下列人員"></asp:ListItem>
                                    </asp:RadioButtonList>
                                    <div id="ChoiceList1" style="width: 100%; height: 80px; overflow: auto;">
                                        <uc2:UC_ChoiceList ID="UC_clApplyRead" runat="server" ExpandToUser="false" IsAllowEdit="true"  />
                                    </div>
                                    <asp:CustomValidator ID="CustomValidator5" runat="server" Display="Dynamic" ErrorMessage="請選擇調閱人員"
                                        Visible="False" meta:resourceKey="CustomValidator5Resource1"></asp:CustomValidator>
                                </td>
                            </tr>

                            <tr>

                                <td class="PopTableLeftTD" style="width: 23%">
                                    <asp:Label ID="Label16" runat="server" Text="調閱流程" meta:resourceKey="Label16Resource1"></asp:Label>
                                </td>
                                <td class="PopTableRightTD">


                                    <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>


                                            <asp:RadioButtonList ID="rblReadProcedure" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="rblReadProcedure_SelectedIndexChanged" meta:resourcekey="rblReadProcedureResource1">
                                                <asp:ListItem Value="DefaultFlow" Selected="True" meta:resourcekey="ListItemResource15" Text="簡易流程"></asp:ListItem>
                                                <asp:ListItem Value="WKFFlow" meta:resourcekey="ListItemResource16" Text="電子簽核"></asp:ListItem>
                                            </asp:RadioButtonList>&nbsp;&nbsp;<asp:Label ID="labApproveHelp" runat="server" ForeColor="Blue" Text="由下列任一「目錄管理者」審核通過即可公佈" meta:resourcekey="labApproveHelpResource1"></asp:Label><br />
                                            &nbsp;&nbsp;<asp:Label ID="lblPath" runat="server" Visible="False" ForeColor="Blue" meta:resourcekey="lblPathResource1"></asp:Label>
                                            <span id="WKFFlow">
                                                <asp:DropDownList ID="ddlUseWKFList" runat="server" Visible="False" Width="134px" meta:resourcekey="ddlUseWKFListResource1">
                                                </asp:DropDownList>
                                                <telerik:RadButton ID="wibtnSelectFlow" Text="觀看流程" runat="server" OnClientClicked="wibtnSelectFlow_Click"
                                                    meta:resourcekey="wibtnSelectFlowResource1">
                                                </telerik:RadButton>
                                            </span>
                                            <div id="ChoiceList2" style="width: 100%; height: 90px; overflow: auto;">
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
            <asp:WizardStep runat="server" Title="5.文件類別" meta:resourcekey="WizardStepResource5">
                <telerik:RadTreeView runat="server" ID="myClassTree" CheckBoxes="true"
                    Height="100%"
                    OnClientNodeChecked="clientNodeChecked" meta:resourcekey="myClassTreeResource1">
                </telerik:RadTreeView>
                <input id="hidNodeTag" runat="server" style="width: 64px" type="hidden" value="DMSClass" />
                <asp:Label runat="server" Text="文件類別" ID="labClassName" Visible="False" meta:resourceKey="labClassNameResource1"></asp:Label>
                <input runat="server" ID="hidClickValue" type="hidden" />    
                <input id="hidIncludeParentClass" type="hidden" runat="server" />
            </asp:WizardStep>
            <asp:WizardStep runat="server" Title="6.參考文件" meta:resourcekey="WizardStepResource7">
                <asp:UpdatePanel ID="UpdatePanel4" runat="server">
                    <ContentTemplate>
                        <table>
                            <tr>
                                <td>
                                    <telerik:RadButton ID="wibtnDocRefLink" runat="server" Text="加入參考文件" meta:resourcekey="wibtnDocRefLinkResource1" OnClientClicked="wibtnDocRefLink_ClientClick"  OnClick="wibtnDocRefLink_Click">
                                    </telerik:RadButton>
                                </td>                                
                                <td>
                                    &nbsp;
                                    &nbsp;
                                    &nbsp;
                                </td>
                                <td style="vertical-align:middle">
                                    <asp:CheckBox ID="cbRefLink" runat="server" Text="參考文件只限定於目前版本" meta:resourcekey="cbRefLinkResource1" />
                                    <asp:Label ID="Label18" runat="server" Text="(不勾選則表示參考文件不受版本限制)" ForeColor="Blue" meta:resourcekey="Label18Resource1"></asp:Label>
                                </td>
                            </tr>
                        </table>
                        <asp:HiddenField ID="hidDocid" runat="server" />
                        <asp:HiddenField ID="hidRefDoc" runat="server" />
                        
                        <Fast:Grid ID="gridDocRef" runat="server" AllowPaging="True" AllowSorting="True"
                            AutoGenerateCheckBoxColumn="False" AutoGenerateColumns="False"
                            DataKeyOnClientWithCheckBox="False" EnhancePager="True"
                            OnPageIndexChanging="gridDocRef_PageIndexChanging" OnRowDataBound="gridDocRef_RowDataBound" Width="100%" OnSorting="gridDocRef_Sorting" OnRowCommand="gridDocRef_RowCommand"  DefaultSortDirection="Ascending" EmptyDataText="No data found" KeepSelectedRows="False" meta:resourcekey="gridDocRefResource1"  >
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
                                            <asp:Label ID="labDLFile" onmouseover="this.className='action_over'" class="action_out" onmouseout="this.className='action_out'" runat="server" Text='<%# Bind("DOC_NAME") %>' meta:resourceKey="labDLFileResource1"></asp:Label>
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
                                        <asp:LinkButton ID="lbtnInfo" runat="server" meta:resourceKey="lbtnInfoResource1" Visible="False" Text="資訊"></asp:LinkButton>
                                        <asp:LinkButton ID="lbtnUpdate" runat="server" Text="更新" CommandName="DocUpdate" CommandArgument='<%# Eval("DOC_ID") %>' Visible ="False" meta:resourcekey="lbtnUpdateResource1"></asp:LinkButton>
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
            <asp:WizardStep runat="server" Title="7.檔案上傳" meta:resourcekey="WizardStepResource6">
                <asp:Panel ID="pnlUploadFileDoc" runat="server" meta:resourcekey="pnlUploadFileDocResource1">
                    <table class="PopTable">
                        <tr>
                            <td style="white-space:nowrap;width:120px;">
                                <asp:Label ID="Label1" runat="server" Text="檔案" meta:resourcekey="Label1Resource1"></asp:Label>
                            </td>
                            <td >
                                <uc2:UC_FileCenter runat="server" ID="UC_FileCenter" ProxyEnabled="true"  />
                            </td>
                        </tr>                        
                    </table>
                </asp:Panel>
                <asp:Panel ID="pnlUploadContentDoc" runat="server" meta:resourcekey="pnlUploadContentDocResource1">
                    <uc1:UC_HtmlEditor ID="UC_HtmlEditor1" runat="server" Width="100%" Height="600px" ProxyEnabled="true" EnableInsertDMS="true"/>                    
                </asp:Panel>
                <asp:CustomValidator ID="CustomValidator1" runat="server" Display="Dynamic" ErrorMessage="請上傳檔案" meta:resourcekey="CustomValidator1Resource1" Visible="False"></asp:CustomValidator>
                <asp:CustomValidator ID="CustomValidator2" runat="server" Display="Dynamic" ErrorMessage="存回失敗" meta:resourcekey="CustomValidator2Resource1" Visible="False"></asp:CustomValidator>
                <asp:CustomValidator ID="CustomValidator3" runat="server" Display="Dynamic" ErrorMessage="文章不是簽出狀態,不可執行存回" meta:resourcekey="CustomValidator3Resource1" Visible="False"></asp:CustomValidator>
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

    <asp:Label ID="lblClass" runat="server" Text="文件類別" Visible="False" meta:resourcekey="lblClassResource1"></asp:Label>
    <asp:Label ID="Label6" runat="server" Text="調閱申請" meta:resourcekey="Label6Resource1" Visible="False"></asp:Label>
    <asp:CheckBox ID="chkBORROW_APPLY" runat="server" Text="允許調閱申請" meta:resourcekey="chkBORROW_APPLYResource1" Visible="False" />
    <asp:Label ID="lblUpload" runat="server" meta:resourcekey="lblUploadResource1" Text="請上傳檔案"
        Visible="False"></asp:Label>
    <asp:Label ID="lblCheckinError" runat="server" meta:resourcekey="lblCheckinErrorResource1"
        Text="存回失敗" Visible="False"></asp:Label>
    <asp:Label ID="lblStatusError" runat="server" meta:resourcekey="lblStatusErrorResource1"
        Text="文章不是簽出狀態,不可執行存回" Visible="False"></asp:Label><asp:Label ID="labDefApprove"
            runat="server" Text="由下列任一「目錄管理者」審核通過即可公佈" Visible="False" meta:resourcekey="labDefApproveResource1"></asp:Label><asp:Label ID="labUseWKF"
                runat="server" Text="使用電子簽核，請選擇簽核流程" Visible="False" meta:resourcekey="labUseWKFResource1"></asp:Label>
    <asp:Label ID="lanNoApprove" runat="server" Text="此目錄無設定目錄管理者，無法進行審核設定" Visible="False" meta:resourcekey="lanNoApproveResource1"></asp:Label>
    <asp:Label ID="lblFolderPath" runat="server" Text="引用目錄" Visible="False" meta:resourcekey="lblFolderPathResource1"></asp:Label>
    <asp:Label ID="labDocStore" runat="server" meta:resourcekey="labDocStoreResource1"
        Text="文件庫" Visible="False"></asp:Label>
    <asp:HiddenField ID="hidFolderID" runat="server" />
    <asp:Label ID="lblSerialRepeat" runat="server" Text="文件編號已被使用" Visible="False" meta:resourcekey="lblSerialRepeatResource1"></asp:Label>
    <asp:Label ID="lblNameRepeat" runat="server" Text="文件名稱在此目錄已被使用" Visible="False" meta:resourcekey="lblNameRepeatResource1"></asp:Label>
    <asp:Label ID="lblSelectMsg" runat="server" Text="請選擇" Visible="False" meta:resourcekey="lblSelectMsgResource1"></asp:Label>
    <asp:Label ID="lblNoExtension" runat="server" Text="無法上傳無附檔名的檔案" Visible="False" meta:resourcekey="lblNoExtensionResource1"></asp:Label>

    <asp:Label ID="lblAutoSerial" runat="server" Text="＊文件自動編號" Visible="False" meta:resourcekey="lblAutoSerialResource1"></asp:Label>
    <asp:Label ID="lblUploadContentDoc" runat="server" Text="7.編輯本文" Visible="False" meta:resourcekey="lblUploadContentDocResource1"></asp:Label>
    <asp:Label ID="lblNeedDocName" runat="server" Text="請輸入文件標題" Visible="False" meta:resourcekey="lblNeedDocNameResource1"></asp:Label>
    <asp:Label ID="lblNeedDocContent" runat="server" Text="請輸入文件內容" Visible="False" meta:resourcekey="lblNeedDocContentResource1"></asp:Label>
    <asp:Label ID="Label17" runat="server" Text="無法上傳無附檔名的檔案" Visible="False" meta:resourcekey="lblNoExtensionResource1"></asp:Label>
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
    <asp:Label ID="lblCheckin" runat="server" Text="已存回" Visible="False" meta:resourcekey="lblCheckinResource1"></asp:Label>
    <asp:Label ID="lblCheckOut" runat="server" Text="已取出" Visible="False" meta:resourcekey="lblCheckOutResource1"></asp:Label>
    <asp:Label ID="lblTempInact" runat="server" Text="已下架" Visible="False" meta:resourcekey="lblTempInactResource1"></asp:Label>
    <asp:HiddenField ID="hfDocSerial" runat="server" />    
    <asp:Label ID="lblChoiceBtntxt" runat="server" Text="選取部門" Visible="False" meta:resourcekey="lblChoiceBtntxtResource1"></asp:Label>
    <asp:Label ID="lblcvNonEmpty" runat="server" Text="不可空白" Visible="False" meta:resourcekey="lblcvNonEmptyResource1"></asp:Label>
    <asp:HiddenField ID="hfCurrentUser" runat="server" />
</asp:Content>

