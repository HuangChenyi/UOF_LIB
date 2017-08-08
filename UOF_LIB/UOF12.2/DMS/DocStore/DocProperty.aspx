<%@ Page Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" Inherits="DMS_DocStore_DocProperty" Title="文件屬性設定" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="DocProperty.aspx.cs" %>

<%@ Register Src="../../Common/ChoiceCenter/UC_ChoiceList.ascx" TagName="UC_ChoiceList"
    TagPrefix="uc2" %>

<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Fast" %>

<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<%@ Register Src="~/Common/ChoiceCenter/UC_ChoiceList.ascx" TagPrefix="uc1" TagName="UC_ChoiceList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script id="scriptblock" type="text/javascript">
<!--

    function refDocID() {
        return $("#<%=hidRefDoc.ClientID %>").val();
    }

    var arrayNodes = new Array()
    var hidClickValue;

    $(function () {
        ChangeActive();
        ChangeInvalid();
        //ChangeSecret();     

        //IsBorrow();

        //IsChangeLend()

        if (typeof ($("#ChoiceList1")) != "undefined") {
            if ($('#<%=rblApplyRead.ClientID %> input:checked').val() == "AllowALL")
            $("#ChoiceList1").css('visibility', 'hidden');
        else
            $("#ChoiceList1").css('visibility', 'inherit');
    }


    // 原始檔控制
    var chkUseParentSet = $("#<%=chkUseParentSet.ClientID %>");
    var rblApplyRead2 = $("#<%=rblApplyRead2.ClientID %>");
    var rblApplyRead3 = $("#<%=rblApplyRead3.ClientID %>");
    var rblApplyRead4 = $("#<%=rblApplyRead4.ClientID %>");
    var rblApplyRead5 = $("#<%=rblApplyRead5.ClientID %>");
    var cbChangeToPDF = $("#<%=cbChangeToPDF.ClientID %>");
    var chkPrint = $("#<%=chkPrint.ClientID %>");
    var chkSave = $("#<%=chkSave.ClientID %>");
    var chkCopy = $("#<%=chkCopy.ClientID %>");
    var dwnSecret = $("#<%=dwnSecret.ClientID %>");
    var chkCommonEdit = $("#<%=chkCommonEdit.ClientID %>");

    if (chkUseParentSet != null) {

        if (rblApplyRead2 != null) {

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
            var ischkUseParentSet = chkUseParentSet.is(":checked");

            var folderID = $("#<%= hidFolderID.ClientID %>").val();
            var docStatus = $("#<%= hidDosStatus.ClientID %>").val();
            var isauthority = false;
            if (docStatus == "Publish") {
                var data = [folderID]
                var authority = $uof.pageMethod.sync("getFolderAuthority", data);
                if (authority == "DMSAdmin" || authority == "DMSFolderMang")
                    isauthority = true;
            }

            var isDisabled = (docStatus && !isauthority) || ischkUseParentSet || !iscbChangeToPDF;            
            $("#<%=rblApplyRead5.ClientID%>").find('input').attr("disabled", isDisabled);

            var ischkPrint = $("#<%=chkPrint.ClientID%>").is(":checked");
            var ischkSave = $("#<%=chkSave.ClientID%>").is(":checked");
            var ischkCopy = $("#<%=chkCopy.ClientID%>").is(":checked");
            var isrblApplyRead5 = $("#<%=rblApplyRead5.ClientID%>").is(":checked");

            if (iscbChangeToPDF) {
                var isDisabled = (docStatus && !isauthority) || ischkUseParentSet;
                $("#<%=rblApplyRead2.ClientID%>").find("input").attr("disabled", isDisabled || !ischkPrint);
                $("#<%=rblApplyRead3.ClientID%>").find("input").attr("disabled", isDisabled || !ischkSave);
                $("#<%=rblApplyRead4.ClientID%>").find("input").attr("disabled", isDisabled || !ischkCopy);
    	    } else {
                $("#<%=rblApplyRead2.ClientID%>").find("input").attr("disabled", !iscbChangeToPDF);
                $("#<%=rblApplyRead3.ClientID%>").find("input").attr("disabled", !iscbChangeToPDF);
                $("#<%=rblApplyRead4.ClientID%>").find("input").attr("disabled", !iscbChangeToPDF);
            }            
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
                var folderID = $("#<%= hidFolderID.ClientID %>").val();
                var docStatus = $("#<%= hidDosStatus.ClientID %>").val();

                if (docStatus == "Publish") {
                    var data = [folderID]
                    var authority = $uof.pageMethod.sync("getFolderAuthority", data);
                    if (authority != "DMSAdmin" && authority != "DMSFolderMang") {
                        datepicker.set_enabled(false);
                        cbActiveEqualPublish.attr("disabled", true);
                    }
                    else {
                        datepicker.set_enabled(true);
                        cbActiveEqualPublish.attr("disabled", false);
                    }
                }
                else {
                    datepicker.set_enabled(true);
                    cbActiveEqualPublish.attr("disabled", false);
                }
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


function wibtnSelectFlow_Click(button, args) {
    var ddlUseWKFList = $("#<%=ddlUseWKFList.ClientID%>");
    var FormVersionId = $("#<%=ddlUseWKFList.ClientID %>").val().split(','); // ddlUseWKFList.options[ddlUseWKFList.selectedIndex].value.split(',');
    $uof.dialog.open2("~/WKF/Browse/ViewMasterFlow.aspx", button, '<%=lblMaintainFlow.Text%>', 900, 800, function (returnValue) { return false; }, { "formVersionId": FormVersionId[0], "flowId": FormVersionId[1] });
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

        //文件類別Tree resize
        function resizeTree(X, Y) {
            var tree = $find("<%=treeClass.ClientID %>");
            if (tree != null && tree != 'undefined') {
                tree.get_element().style.height = Y - 50 + "px";
                tree.get_element().style.width = X - 126 + "px";
            }
        }
// -->
    </script>
    
    <table style="width:100%" border="0">
        <tr>
            <td class="PopTableHeader">
                <div style="text-align:center;">
                    <asp:Label ID="Label12" runat="server" Text="文件屬性修改" meta:resourcekey="Label12Resource1"></asp:Label>
                </div>
            </td>
        </tr>
    </table>
    <asp:Wizard ID="Wizard1" runat="server" ActiveStepIndex="0" BackColor="#F7F6F3" BorderColor="#999999"
        BorderWidth="1px" EnableTheming="True" BorderStyle="Solid"
        Height="92%" Width="100%" meta:resourcekey="Wizard1Resource1" OnNextButtonClick="Wizard1_NextButtonClick" OnSideBarButtonClick="Wizard1_SideBarButtonClick">
        <StepStyle VerticalAlign="Top" BackColor="White" BorderColor="#E6E2D8" BorderStyle="Solid" BorderWidth="2px" />
        <SideBarStyle BackColor="White" VerticalAlign="Top" Width="120px" Font-Underline="False" ForeColor="Black" HorizontalAlign="Center" Wrap="false" />
        <NavigationButtonStyle BackColor="White" BorderColor="#C5BBAF" BorderStyle="Solid" BorderWidth="1px" ForeColor="#1C5E55" />
        <WizardSteps>
            <asp:WizardStep ID="WizardStep1" runat="server" Title="1.基本屬性" StepType="Start" meta:resourcekey="WizardStepResource1">

                <table class="PopTable" style="height: 381px; width: 100%" runat="server" id="PropertyTable">



                    <tr>
                        <td style="width: 104px;white-space:nowrap">
                            <asp:Label ID="Label1" runat="server" Text="存放目錄" meta:resourcekey="Label1Resource1"></asp:Label></td>
                        <td style="width: 300px" colspan="3">
                            <span style="word-break: break-all; width: 350px;">
                                <img alt="" src="../../DMS/images/open.gif" />
                                <asp:Label ID="lblFolderName" runat="server" meta:resourcekey="lblFolderNameResource1"></asp:Label>
                            </span>
                        </td>
                    </tr>

                    <tr>
                        <td style="width: 104px;white-space:nowrap">
                            <asp:Label ID="Label2" runat="server" Text="文件名稱" meta:resourcekey="Label2Resource1"></asp:Label></td>
                        <td colspan="3">
                            <asp:TextBox ID="txtTitle" runat="server" Width="100%" meta:resourcekey="txtTitleResource1"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 104px;white-space:nowrap">
                            <asp:Label ID="Label3" runat="server" Text="文件編號" meta:resourcekey="Label3Resource1"></asp:Label></td>
                        <td colspan="3">
                            <asp:TextBox ID="txtSerial" runat="server" Width="100%" meta:resourcekey="txtSerialResource1"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 98px;white-space:nowrap" class="PopTableLeftTD">
                            <asp:Label ID="Label22" runat="server" Text="文件速別" meta:resourcekey="Label22Resource1"></asp:Label>
                        </td>
                        <td style="width: 300px" class="PopTableRightTD" colspan="3">
                            <asp:RadioButton ID="rdoUrgencyNormal" runat="server" GroupName="Urgency" Text="普通" Checked="true" meta:resourcekey="rdoUrgencyNormalResource1" />
                            <asp:RadioButton ID="rdoUrgencyHigh" runat="server" GroupName="Urgency" Text="急" meta:resourcekey="rdoUrgencyHighResource1" />
                            <asp:RadioButton ID="rdoUrgencyExHigh" runat="server" GroupName="Urgency" Text="緊急" meta:resourcekey="rdoUrgencyExHighResource1" />
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 104px;white-space:nowrap">
                            <asp:Label ID="Label4" runat="server" Text="發行單位" meta:resourcekey="Label4Resource1"></asp:Label></td>
                        <td style="width: 300px">
                            <div style="overflow: auto; width: 100%; height: 70px">
                                <uc2:UC_ChoiceList ID="UC_ChoiceList4" runat="server" ChioceType="Group" ShowMember="false" ExpandToUser="false" />
                            </div>
                        </td>                    
                        <td style="width: 104px;white-space:nowrap">
                            <asp:Label ID="Label5" runat="server" Text="保管者" meta:resourcekey="Label5Resource1"></asp:Label></td>
                        <td style="width: 300px">
                            <div style="overflow: auto; width: 100%; height: 90px">
                                <uc2:UC_ChoiceList ID="UC_ChoiceList5" runat="server" ChioceType="User" ShowMember="false" ExpandToUser="false" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 98px; white-space:nowrap" class="PopTableLeftTD">
                            <asp:Label ID="Label14" runat="server" Text="權責部門" meta:resourcekey="Label14Resource1"></asp:Label>
                        </td>
                        <td style="width: 300px" class="PopTableRightTD">
                            <div style="width: 100%; height: 90px; overflow: auto;">
                                <uc1:UC_ChoiceList runat="server" ID="clAuthDep" ChioceType="Group" ShowMember="false" ExpandToUser="false"/>
                            </div>
                        </td>
                        <td style="width: 98px; white-space:nowrap" class="PopTableLeftTD">
                            <asp:Label ID="Label23" runat="server" Text="適用部門" meta:resourcekey="Label23Resource1"></asp:Label>
                        </td>
                        <td style="width: 300px" class="PopTableRightTD">
                            <div style="width: 100%; height: 90px; overflow: auto;">
                                <uc2:UC_ChoiceList ID="clSuitableDep" runat="server" ChioceType="Group" ShowMember="false" ExpandToUser="false" />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 97px; width: 104px;white-space:nowrap">
                            <asp:Label ID="Label6" runat="server" Text="摘要" meta:resourcekey="Label6Resource1"></asp:Label></td>
                        <td style="height: 97px" colspan="3">
                            <asp:TextBox ID="txtComment" runat="server" Height="134px" TextMode="MultiLine" Width="100%" meta:resourcekey="txtCommentResource1"></asp:TextBox>
                        </td>
                    </tr>

                    <tr>
                        <td style="width: 104px;white-space:nowrap">
                            <asp:Label ID="Label13" runat="server" Text="關鍵字" meta:resourceKey="LabelKeyWordResource1"></asp:Label>
                        </td>
                        <td colspan="3">
                            <asp:TextBox ID="txtKeyword" runat="server" Height="137px" meta:resourceKey="txtCommentResource1"
                                TextMode="MultiLine" Width="100%"></asp:TextBox>
                        </td>
                    </tr>

                </table>
                <asp:RadioButtonList ID="RadioButtonList1" runat="server" RepeatDirection="Horizontal"
                    Width="200px" Visible="False" meta:resourcekey="RadioButtonList1Resource1">
                    <asp:ListItem Selected="True" Value="file" meta:resourcekey="ListItemResource1" Text="電子檔"></asp:ListItem>
                    <asp:ListItem Value="paper" meta:resourcekey="ListItemResource2" Text="紙本"></asp:ListItem>
                </asp:RadioButtonList>

            </asp:WizardStep>
            <asp:WizardStep runat="server" Title="2.保存期限" StepType="Step" meta:resourcekey="WizardStepResource2">
                <table class="PopTable">
                    <tr>
                        <td rowspan="2" style="width: 50px" class="PopTableLeftTD">
                            <asp:Label ID="Label7" runat="server" Text="生效設定" meta:resourcekey="Label7Resource1"></asp:Label></td>
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
                        <td rowspan="2" style="width: 50px" class="PopTableLeftTD">
                            <asp:Label ID="Label8" runat="server" Text="過期設定" meta:resourcekey="Label8Resource1"></asp:Label></td>
                        <td colspan="2" >
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
                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;<br />
                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp;
                <asp:CustomValidator ID="CustomValidator2" runat="server" Display="Dynamic" ErrorMessage="保存期限設定錯誤" meta:resourcekey="CustomValidator2Resource1" Visible="False"></asp:CustomValidator>
            </asp:WizardStep>
            <asp:WizardStep runat="server" Title="3.機密設定" StepType="Step" meta:resourcekey="WizardStepResource3">
                <asp:UpdatePanel ID="UpdatePanel3" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <table class="PopTable">
                            <tr>
                                <td style="width: 100%; text-align: left" colspan="2" class="PopTableRightTD">
                                    <asp:CheckBox ID="chkUseParentSet" runat="server" Text="使用父目錄的機密設定" AutoPostBack="True" OnCheckedChanged="chkUseParentSet_CheckedChanged" meta:resourcekey="chkUseParentSetResource1"></asp:CheckBox>
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 33px" class="PopTableLeftTD">
                                    <asp:Label ID="Label9" runat="server" Text="機密等級" meta:resourcekey="Label9Resource1"></asp:Label></td>
                                <td style="width: 439px; height: 33px" class="PopTableRightTD">&nbsp;<asp:DropDownList ID="dwnSecret" runat="server" Width="100px" meta:resourcekey="dwnSecretResource1">
                                    <asp:ListItem Value="Normal" meta:resourcekey="ListItemResource3" Text="一般"></asp:ListItem>
                                    <asp:ListItem Value="Secret" meta:resourcekey="ListItemResource4" Text="密"></asp:ListItem>
                                    <asp:ListItem Value="XSecret" meta:resourcekey="ListItemResource5" Text="機密"></asp:ListItem>
                                    <asp:ListItem Value="XXSecret" meta:resourcekey="ListItemResource6" Text="極機密"></asp:ListItem>
                                    <asp:ListItem Value="TopSecret" meta:resourcekey="ListItemResource7" Text="絕對機密"></asp:ListItem>
                                </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td style="height: 30px" class="PopTableLeftTD">
                                    <asp:Label ID="Label10" runat="server" Text="共同編輯" meta:resourcekey="Label10Resource1"></asp:Label></td>
                                <td style="width: 439px; height: 30px" class="PopTableRightTD">
                                    <asp:CheckBox ID="chkCommonEdit" runat="server" Text="允許作者群共同編輯" meta:resourcekey="chkCommonEditResource1" />
                                </td>
                            </tr>
                            <tr id="OriginalManuscriptTR" runat="server">
                                <td class="PopTableLeftTD" runat="server">
                                    <asp:Label ID="Label11" runat="server" Text="原稿控制" meta:resourcekey="Label11Resource1"></asp:Label></td>
                                <td style="width: 439px;" class="PopTableRightTD" runat="server">
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
                                                <asp:RadioButtonList ID="rblApplyRead2" runat="server" CssClass="SizeS" CellPadding="0" CellSpacing="0" AutoPostBack="True" OnSelectedIndexChanged="rblApplyRead2_SelectedIndexChanged" RepeatDirection="Horizontal">
                                                    <asp:ListItem Selected="True" Value="AllowALL" meta:resourcekey="ListItemResource8" Text="允許全部人員"></asp:ListItem>
                                                    <asp:ListItem Value="AllowList" meta:resourcekey="ListItemResource9" Text="允許下列人員"></asp:ListItem>
                                                    <asp:ListItem Value="DenyList" meta:resourcekey="ListItemResource10" Text="不允許下列人員"></asp:ListItem>
                                                </asp:RadioButtonList>
                                            </td>
                                        </tr>
                                        <tr style="display:none;">
                                            <td style="width: 100%" colspan="3"><div id="Source_ChoiceList1" style="max-height: 100px; overflow: auto;" runat="server">
                                                <uc2:UC_ChoiceList ID="UC_clApplyRead2" runat="server"  ExpandToUser="false"
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
                                                <asp:CheckBox ID="chkSave" runat="server" Text="可另存" meta:resourcekey="chkSaveResource1" AutoPostBack="True" OnCheckedChanged="chkSave_CheckedChanged" />
                                            </td>
                                            <td>
                                                <asp:RadioButtonList ID="rblApplyRead3" runat="server" CssClass="SizeS" CellPadding="0" CellSpacing="0" AutoPostBack="True" OnSelectedIndexChanged="rblApplyRead2_SelectedIndexChanged" RepeatDirection="Horizontal">
                                                    <asp:ListItem Selected="True" Value="AllowALL" meta:resourcekey="ListItemResource8" Text="允許全部人員"></asp:ListItem>
                                                    <asp:ListItem Value="AllowList" meta:resourcekey="ListItemResource9" Text="允許下列人員"></asp:ListItem>
                                                    <asp:ListItem Value="DenyList" meta:resourcekey="ListItemResource10" Text="不允許下列人員"></asp:ListItem>
                                                </asp:RadioButtonList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 100%" colspan="3"><div id="Source_ChoiceList2" style="max-height: 100px; overflow: auto;" runat="server">
                                                <uc2:UC_ChoiceList ID="UC_clApplyRead3" runat="server"  ExpandToUser="false"
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
                                                <asp:CheckBox ID="chkCopy" runat="server" AutoPostBack="True" meta:resourcekey="chkCopyResource1" OnCheckedChanged="chkCopy_CheckedChanged" Text="可複製" />
                                            </td>
                                            <td>
                                                <asp:RadioButtonList ID="rblApplyRead4" runat="server" AutoPostBack="True" CellPadding="0" CellSpacing="0" CssClass="SizeS" OnSelectedIndexChanged="rblApplyRead2_SelectedIndexChanged" RepeatDirection="Horizontal">
                                                    <asp:ListItem meta:resourcekey="ListItemResource8" Selected="True" Text="允許全部人員" Value="AllowALL"></asp:ListItem>
                                                    <asp:ListItem meta:resourcekey="ListItemResource9" Text="允許下列人員" Value="AllowList"></asp:ListItem>
                                                    <asp:ListItem meta:resourcekey="ListItemResource10" Text="不允許下列人員" Value="DenyList"></asp:ListItem>
                                                </asp:RadioButtonList>
                                            </td>
                                        </tr>
                                        <tr style="display:none;">
                                            <td style="width: 100%" colspan="3"><div id="Source_ChoiceList3" style="max-height: 100px; overflow: auto;" runat="server">
                                                <uc2:UC_ChoiceList ID="UC_clApplyRead4" runat="server"  ExpandToUser="false" IsAllowEdit="true"></uc2:UC_ChoiceList>
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
                                            <td colspan="3">
                                                <asp:Label ID="lblSource" runat="server" Text="原始檔" meta:resourcekey="lblSourceResource1"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblSource2" runat="server" Text="下載權限" meta:resourcekey="lblSource2Resource1"></asp:Label>
                                            </td>
                                            <td>
                                                <asp:RadioButtonList ID="rblApplyRead5" runat="server" CssClass="SizeS" CellPadding="0" CellSpacing="0" AutoPostBack="True" OnSelectedIndexChanged="rblApplyRead2_SelectedIndexChanged" RepeatDirection="Horizontal">
                                                    <asp:ListItem Selected="True" Value="DenyALL" meta:resourcekey="ListItemResource11" Text="全部不允許"></asp:ListItem>
                                                    <asp:ListItem Value="AllowALL" meta:resourcekey="ListItemResource8" Text="允許全部人員"></asp:ListItem>
                                                    <asp:ListItem Value="AllowList" meta:resourcekey="ListItemResource9" Text="允許下列人員"></asp:ListItem>
                                                    <asp:ListItem Value="DenyList" meta:resourcekey="ListItemResource10" Text="不允許下列人員"></asp:ListItem>
                                                </asp:RadioButtonList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 100%" colspan="3"><div id="Source_ChoiceList4" style="max-height: 100px; overflow: auto;" runat="server">
                                                <uc2:UC_ChoiceList ID="UC_clApplyRead5" runat="server"  ExpandToUser="false"
                                                    IsAllowEdit="true"></uc2:UC_ChoiceList>
                                            </div>
                                            </td>
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
                        <table class="PopTable">
                            <tr>
                                <td colspan="2" class="PopTableRightTD" style="text-align: left">
                                    <asp:CheckBox ID="chkUseParentSetup" runat="server" AutoPostBack="True" OnCheckedChanged="chkUseParentSetup_CheckedChanged"
                                        Text="使用父目錄的調閱設定" meta:resourcekey="chkUseParentSetupResource1" />
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 93px; height: 138px; vertical-align:middle" class="PopTableLeftTD">
                                    <asp:Label ID="Label20" runat="server" Text="調閱申請" meta:resourcekey="Label20Resource1"></asp:Label>
                                </td>
                                <td style="width: 346px; height: 138px;" class="PopTableRightTD">
                                    <asp:CheckBox ID="chkBorrow" runat="server" Text="允許調閱申請" meta:resourcekey="chkBorrowResource1" Checked="True" onclick="" AutoPostBack="True" OnCheckedChanged="chkBorrow_CheckedChanged" />
                                    &nbsp;<br />
                                    <asp:RadioButtonList ID="rblApplyRead" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="rblApplyRead_SelectedIndexChanged" meta:resourcekey="rblApplyReadResource1">
                                        <asp:ListItem Selected="True" Value="AllowALL" meta:resourcekey="ListItemResource12" Text="允許全部人員"></asp:ListItem>
                                        <asp:ListItem Value="AllowList" meta:resourcekey="ListItemResource13" Text="允許下列人員"></asp:ListItem>
                                    </asp:RadioButtonList>
                                    <div id="ChoiceList1" style="width: 100%; height: 80px; overflow: auto;">
                                        <uc2:UC_ChoiceList ID="UC_clApplyRead" runat="server" ExpandToUser="false" IsAllowEdit="false"  />
                                    </div>
                                    <asp:CustomValidator ID="CustomValidator4" runat="server" Display="Dynamic" ErrorMessage="請選擇調閱人員"
                                        meta:resourceKey="CustomValidator4Resource1" Visible="False"></asp:CustomValidator>
                                </td>
                            </tr>

                            <tr>

                                <td class="PopTableLeftTD">
                                    <asp:Label ID="Label16" runat="server" Text="調閱流程" meta:resourceKey="Label16Resource1"></asp:Label>
                                </td>
                                <td class="PopTableRightTD">


                                    <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>


                                            <asp:RadioButtonList ID="rblReadProcedure" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="rblReadProcedure_SelectedIndexChanged" meta:resourcekey="rblReadProcedureResource1">
                                                <asp:ListItem Value="DefaultFlow" Selected="True" meta:resourcekey="ListItemResource15" Text="簡易流程"></asp:ListItem>
                                                <asp:ListItem Value="WKFFlow" meta:resourcekey="ListItemResource16" Text="電子簽核"></asp:ListItem>
                                            </asp:RadioButtonList><asp:Label ID="labApproveHelp" runat="server" ForeColor="Blue" Text="由下列任一「目錄管理者」審核通過即可公佈" meta:resourcekey="labApproveHelpResource1"></asp:Label><br />
                                            <asp:Label ID="lblPath" runat="server" Visible="False" ForeColor="Blue" meta:resourcekey="lblPathResource1"></asp:Label>
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
            <asp:WizardStep runat="server" Title="5.文件類別" StepType="Finish" meta:resourcekey="WizardStepResource5">
                <telerik:RadTreeView runat="server" ID="treeClass" DefaultImageSrc="~/Common/Images/Icon/icon_m84.gif" CheckBoxes="true" Height="100%"
                    OnClientNodeChecked="clientNodeChecked" meta:resourcekey="treeClassResource1">
                </telerik:RadTreeView>
                <input id="hidNodeTag" runat="server" style="width: 64px"
                    type="hidden" value="DMSClass" />
                <input runat="server" id="hidClickValue" type="hidden" />
                <input id="hidIncludeParentClass" type="hidden" runat="server" />
                <asp:Label runat="server" Text="文件類別" ID="labClassName" Visible="False"
                    meta:resourceKey="labClassNameResource1"></asp:Label>
            </asp:WizardStep>
            <asp:WizardStep ID="WizardStep7" runat="server" Title="6.參考文件" meta:resourcekey="WizardStepResource6">
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
                                    <asp:Label ID="Label17" runat="server" Text="(不勾選則表示參考文件不受版本限制)" ForeColor="Blue" meta:resourcekey="Label17Resource1"></asp:Label>
                                </td>
                            </tr>
                        </table>

                        <Fast:Grid ID="gridDocRef" runat="server" AllowPaging="True" AllowSorting="True"
                            AutoGenerateCheckBoxColumn="False" AutoGenerateColumns="False"
                            DataKeyOnClientWithCheckBox="False" EnhancePager="True"
                            OnPageIndexChanging="gridDocRef_PageIndexChanging" OnRowDataBound="gridDocRef_RowDataBound" OnRowCommand="gridDocRef_RowCommand" Width="100%" OnSorting="gridDocRef_Sorting"  DefaultSortDirection="Ascending" EmptyDataText="No data found" KeepSelectedRows="False" meta:resourcekey="gridDocRefResource1"   PageSize="15">
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
                                        <asp:LinkButton ID="lbtnRemove" runat="server" CommandName="DelRefDoc" meta:resourceKey="lbtnRemoveResource1" Text="移除"></asp:LinkButton>
                                        <!--Lala: 因考量當參考文件加入當下版本顯示資訊會影響，先把所有資訊隱藏-->
                                        <asp:LinkButton ID="lbtnInfo" runat="server" meta:resourceKey="lbtnInfoResource1" Text="資訊" Visible="False"></asp:LinkButton>
                                        <asp:LinkButton ID="lbtnUpdate" runat="server" Text="更新" CommandName="DocUpdate" CommandArgument='<%# Eval("DOC_ID") %>' Visible ="False" meta:resourcekey="lbtnUpdateResource1"></asp:LinkButton>
                                    </ItemTemplate>
                                    <HeaderStyle Wrap="False" Width="7%" />
                                    <ItemStyle Wrap="False"/>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="docid" Visible="False" meta:resourcekey="TemplateFieldResource3">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDOCID" runat="server" Text='<%# Bind("DOC_ID") %>' meta:resourcekey="lblDOCIDResource2"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                 <asp:TemplateField HeaderText="SYS_VERSION" Visible="False" meta:resourcekey="TemplateFieldResource7">
                                    <ItemTemplate>
                                        <asp:Label ID="lblVersion" runat="server" Text='<%# Bind("SYS_VERSION") %>' meta:resourcekey="lblVersionResource1"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                 <asp:TemplateField HeaderText="SYNC_STATUS" Visible="False" meta:resourcekey="TemplateFieldResource8">
                                    <ItemTemplate>
                                        <asp:Label ID="lblSync" runat="server" Text='<%# Bind("SYNC_STATUS") %>' meta:resourcekey="lblSyncResource1"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="SOURCE" Visible="False">
                                    <ItemTemplate>
                                        <asp:Label ID="lblSource" runat="server" Text='<%# Bind("SOURCE") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </Fast:Grid>
                        <asp:HiddenField ID="hideSelectRef" runat="server"></asp:HiddenField>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </asp:WizardStep>
        </WizardSteps>
        <SideBarButtonStyle ForeColor="White" />
        <HeaderStyle BackColor="Silver" BorderColor="#E6E2D8" BorderStyle="Solid" BorderWidth="2px" Font-Bold="False" ForeColor="Black" HorizontalAlign="Center" />
        <StartNavigationTemplate>
        </StartNavigationTemplate>
        <StepNavigationTemplate>
        </StepNavigationTemplate>
        <SideBarTemplate>
            <asp:DataList ID="SideBarList" runat="server" HorizontalAlign="Left" OnItemDataBound="SideBarList_ItemDataBound" meta:resourcekey="SideBarListResource1">
                <SelectedItemStyle Font-Bold="True" />
                <ItemTemplate>
                    &nbsp;&nbsp;<asp:Image ID="imgSideBar" runat="server" meta:resourcekey="imgSideBarResource1" />
                    <asp:LinkButton ID="SideBarButton" runat="server" BackColor="Transparent" Font-Names="Verdana"
                        ForeColor="Black" meta:resourcekey="SideBarButtonResource1"></asp:LinkButton>&nbsp;
                    <br />
                    <br />
                </ItemTemplate>
            </asp:DataList>
        </SideBarTemplate>
        <FinishNavigationTemplate>
        </FinishNavigationTemplate>
    </asp:Wizard>
    <asp:CustomValidator ID="CustomValidator1" runat="server" Display="Dynamic" ErrorMessage="修改文件屬性失敗" meta:resourcekey="CustomValidator1Resource1" Visible="False"></asp:CustomValidator>
    <asp:Label ID="lblModifyError" runat="server" meta:resourcekey="lblModifyErrorResource1"
        Text="修改文件屬性失敗" Visible="False"></asp:Label>
    <asp:Label ID="labDefApprove" runat="server" Text="由下列任一「目錄管理者」審核通過即可公佈" Visible="False" meta:resourcekey="labDefApproveResource1"></asp:Label>
    <input id="hidRefDoc" runat="server" enableviewstate="true" style="width: 24px; height: 15px"
        type="hidden" />
    <input id="hidDocid" runat="server" style="width: 15px; height: 14px" type="hidden" />
    <asp:Label ID="labUseWKF" runat="server" Text="使用電子簽核，請選擇簽核流程" Visible="False" meta:resourcekey="labUseWKFResource1"></asp:Label>
    <asp:Label ID="lanNoApprove" runat="server" Text="此目錄無設定目錄管理者，無法進行審核設定" Visible="False" meta:resourcekey="lanNoApproveResource1"></asp:Label>
    <asp:Label ID="labDocStore" runat="server" meta:resourcekey="labDocStoreResource1"
        Text="文件庫" Visible="False"></asp:Label>
    <asp:Label ID="lblFolderPath" runat="server" Text="引用目錄：" Visible="False" meta:resourcekey="lblFolderPathResource1"></asp:Label>
    <asp:HiddenField ID="hidDosStatus" runat="server" />
    <asp:HiddenField ID="hidPDFError" runat="server" />
    <asp:HiddenField ID="hidFolderID" runat="server" />
    <asp:Label ID="lblNoWKFFlow" runat="server" Text="電子簽核沒有流程，請選擇簡易流程" Visible="False" meta:resourcekey="lblNoWKFFlowResource1"></asp:Label>
    <asp:Label ID="lblNameNotBlank" runat="server" Text="文件名稱不允許空白" Visible="False" meta:resourcekey="lblNameNotBlankResource1"></asp:Label>
    <asp:Label ID="lblSerialRepeat" runat="server" Text="文件編號已被使用" Visible="False" meta:resourcekey="lblSerialRepeatResource1"></asp:Label>
    <asp:Label ID="lblNameRepeat" runat="server" Text="文件名稱在此目錄已被使用" Visible="False" meta:resourcekey="lblNameRepeatResource1"></asp:Label>
    <asp:CustomValidator ID="cvPropertyLimit" runat="server" ErrorMessage="不可空白或沒選人員" Display="Dynamic" Visible="False" meta:resourcekey="cvPropertyLimitResource1"></asp:CustomValidator>
    <asp:CustomValidator ID="cvPropertyLimit2" runat="server" ErrorMessage="必須勾選文件類別" Display="Dynamic" Visible="False" meta:resourcekey="cvPropertyLimit2Resource1"></asp:CustomValidator>
    <asp:CustomValidator ID="cvPropertyLimit3" runat="server" ErrorMessage="必須加入參考文件" Display="Dynamic" Visible="False" meta:resourcekey="cvPropertyLimit3Resource1"></asp:CustomValidator>
    <asp:Label ID="lblSelectMsg" runat="server" Text="請選擇" Visible="False" meta:resourcekey="lblSelectMsgResource1"></asp:Label>
    <asp:Label ID="lblAutoSerial" runat="server" Text="＊文件自動編號" Visible="False" meta:resourcekey="lblAutoSerialResource1"></asp:Label>
    <asp:Label ID="lblMaintainFlow" runat="server" Text="維護流程" Visible="False" meta:resourcekey="lblMaintainFlowResource1" ></asp:Label>
    <asp:Label ID="lblDraft" runat="server" Text="草稿" Visible="False" meta:resourcekey="lblDraftResource1"></asp:Label>
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
    <asp:Label ID="lblVioding" runat="server" Text="(作廢審核中)" Visible="False" meta:resourcekey="lblViodingResource1"></asp:Label>
    <asp:Label ID="lblUpdating" runat="server" Text="改版中" Visible="False" meta:resourcekey="lblUpdatingResource1"></asp:Label>
    <asp:Label ID="labNoActive" runat="server" meta:resourcekey="labNoActiveResource1" Text="未生效" Visible="False"></asp:Label>
    <asp:Label ID="lblChoiceBtntxt" runat="server" Text="選取部門" Visible="False" meta:resourcekey="lblChoiceBtntxtResource1"></asp:Label>
    <asp:Label ID="lblcvNonEmpty" runat="server" Text="不可空白" Visible="False" meta:resourcekey="lblcvNonEmptyResource1"></asp:Label>
    <asp:HiddenField ID="hfCurrentUser" runat="server" />
</asp:Content>

