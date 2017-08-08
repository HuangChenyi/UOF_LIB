<%@ Page Language="C#" MasterPageFile="~/Master/OneColumn.master" AutoEventWireup="true" Inherits="System_Organization_BaseData_Default" Title="基礎資料維護" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="Default.aspx.cs" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ScriptContentPlaceHolder" runat="Server">
    <script type="text/javascript">

        function RadToolBar1_ButtonClicking(sender, args) {

            var Key = args.get_item().get_value();

            if (Key == "createRank") {

                var tree = $find('<%=RadTreeRank.ClientID %>');
                var maxRank = tree.get_nodes().get_count() + 1;
                var newNode = new Telerik.Web.UI.RadTreeNode();

                newNode.set_text(maxRank + '');
                newNode.set_value(maxRank + '');
                newNode.set_imageUrl("<%=Request.ApplicationPath %>" + "/Common/Images/Icon/icon_m18.png");
                tree.get_nodes().add(newNode);
                newNode.set_selected(true);
                newNode.scrollIntoView();
            }
            else if (Key == "createTitle") {
                var tree = $find('<%=RadTreeRank.ClientID %>');
                var parentNode = tree.get_selectedNode();
                if (parentNode != null) {
                    var level = parentNode.get_level();
                    if (level == 1) {
                        parentNode = parentNode.get_parent();
                    }
                    var node = new Telerik.Web.UI.RadTreeNode();
                    node.set_imageUrl("<%=Request.ApplicationPath %>" + "/Common/Images/Icon/icon_m18.png");
                    node.set_text('New Title');
                    parentNode.get_nodes().add(node);
                    parentNode.set_expanded(true);
                    node.scrollIntoView();
                    args.get_item().set_enabled(false);
                    node.startEdit();
                }
                else {
                    alert('<%=lblMessage1.Text %>');
                }
            }
            else if (Key == "delete") {
                var tree = $find('<%=RadTreeRank.ClientID %>');
                var node = tree.get_selectedNode();
                if (node != null) {
                    var level = node.get_level();
                    if (level == 1) {
                        if (confirm('<%=Ede.Uof.Utility.Page.Common.Resource.GetResource("Common","ConfirmDelete") %>')) {
                            var deleteData = [node.get_value(), node.get_value(), '<%=RadTreeRank.ClientID %>'];
                            var result = $uof.pageMethod.sync("DeleteTitle", deleteData);

                            if (result == null) {
                                alert("server error");
                            }
                            else {
                                if (result == "true" && node) {
                                    if (node.get_level() == 0) {
                                        tree.get_nodes().remove(node);
                                    }
                                    else {
                                        node.get_parent().get_nodes().remove(node);
                                    }
                                }
                            }
                        }
                    }
                }
            }

    args.set_cancel(true);
}

function RadToolBar2_ButtonClicking(sender, args) {

    var Key = args.get_item().get_value();

    if (Key == "createFunc") {
        var tree = $find('<%=RadTreeFunc.ClientID %>');
        var node = new Telerik.Web.UI.RadTreeNode();
        node.set_imageUrl("<%=Request.ApplicationPath %>" + "/Common/Images/Icon/icon_m19.png");
        node.set_text('New Function');
        tree.get_nodes().insert(0, node);
        node.set_selected(tree);
        args.get_item().set_enabled(false);
        node.startEdit();
    }
    else if (Key == "delete") {
        var tree = $find('<%=RadTreeFunc.ClientID %>');
                var node = tree.get_selectedNode();
                if (node != null) {
                    if (confirm('<%=Ede.Uof.Utility.Page.Common.Resource.GetResource("Common","ConfirmDelete") %>')) {
                        var deleteData = [node.get_value(), node.get_value(), '<%=RadTreeFunc.ClientID %>'];
                        var result = $uof.pageMethod.sync("DeleteJobFunction", deleteData);

                        if (result == null) {
                            alert("server error");
                        }
                        else {
                            if (result == "true" && node) {
                                if (node.get_level() == 0) {
                                    tree.get_nodes().remove(node);
                                }
                                else {
                                    node.get_parent().get_nodes().remove(node);
                                }
                            }
                            else if (result == "SystemFuncDeleteException") {
                                alert('<%=lblMessage4.Text %>');
                            }
                            else {
                                alert(result);
                            }
                        }
                    }
                }
            }
        args.set_cancel(true);
    }

    function RadToolBar3_ButtonClicking(sender, args) {

        var Key = args.get_item().get_value();
        if (Key == "createEduc") {

            var tree = $find('<%=RadTreeEdu.ClientID %>')
            var node = new Telerik.Web.UI.RadTreeNode();
            node.set_imageUrl("<%=Request.ApplicationPath %>" + "/Common/Images/Icon/icon_m27.png");
            node.set_text('New Education');
            tree.get_nodes().insert(0, node);
            node.set_selected(tree);
            args.get_item().set_enabled(false);
            node.startEdit();
        }
        else if (Key == "delete") {
            var tree = $find('<%=RadTreeEdu.ClientID %>');
                var node = tree.get_selectedNode();
                if (node != null) {
                    if (confirm('<%=Ede.Uof.Utility.Page.Common.Resource.GetResource("Common","ConfirmDelete") %>')) {
                        var deleteData = [node.get_value(), node.get_value(), '<%=RadTreeEdu.ClientID %>'];
                        var result = $uof.pageMethod.sync("DeleteEducation", deleteData);

                        if (result == null) {
                            alert("server error");
                        }
                        else {
                            if (result == "true" && node) {
                                if (node.get_level() == 0) {
                                    tree.get_nodes().remove(node);
                                }
                                else {
                                    node.get_parent().get_nodes().remove(node);
                                }
                            }
                        }
                    }
                }
            }

        args.set_cancel(true);
    }

    function RadToolBar4_ButtonClicking(sender, args) {

        var Key = args.get_item().get_value();

        if (Key == "createType") {
            var tree = $find('<%=RadTreeSkill.ClientID %>');
            var node = new Telerik.Web.UI.RadTreeNode();
            node.set_imageUrl("<%=Request.ApplicationPath %>" + "/Common/Images/Icon/icon_m07.png");
            node.set_text('New Type');
            tree.get_nodes().insert(0, node);
            args.get_item().set_enabled(false);
            node.startEdit();
        }
        else if (Key == "createSkill") {
            var tree = $find('<%=RadTreeSkill.ClientID %>');
                var parentNode = tree.get_selectedNode();
                if (parentNode != null) {
                    var level = parentNode.get_level();
                    if (level == 1) {
                        parentNode = parentNode.get_parent();
                    }
                    var node = new Telerik.Web.UI.RadTreeNode();
                    node.set_imageUrl("<%=Request.ApplicationPath %>" + "/Common/Images/Icon/icon_m08.png");
                    node.set_text('New Skill')
                    parentNode.get_nodes().insert(0, node);
                    parentNode.set_expanded(true);
                    args.get_item().set_enabled(false);
                    node.startEdit();

                }
                else {
                    alert('<%=lblMessage2.Text %>');
                }
            }
            else if (Key == "delete") {
                var tree = $find('<%=RadTreeSkill.ClientID %>');
                var node = tree.get_selectedNode();
                if (node != null) {
                    var level = node.get_level();
                    if (level == 0) {
                        if (node.get_allNodes().length > 0) {
                            alert('<%=lblMessage3.Text %>');
                        }
                        else {
                            if (confirm('<%=Ede.Uof.Utility.Page.Common.Resource.GetResource("Common","ConfirmDelete") %>')) {
                                var deleteData = [node.get_value(), node.get_value(), '<%=RadTreeSkill.ClientID %>'];
                                var result = $uof.pageMethod.sync("DeleteSkillType", deleteData);

                                if (result == null) {
                                    alert("server error");
                                }
                                else {
                                    if (result == "true" && node) {
                                        if (node.get_level() == 0) {
                                            tree.get_nodes().remove(node);
                                        }
                                        else {
                                            node.get_parent().get_nodes().remove(node);
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else {
                        if (confirm('<%=Ede.Uof.Utility.Page.Common.Resource.GetResource("Common","ConfirmDelete") %>')) {
                            var deleteData = [node.get_value(), node.get_value(), '<%=RadTreeSkill.ClientID %>'];
                            var result = $uof.pageMethod.sync("DeleteSkill", deleteData);
                            if (result == null) {
                                alert("server error");
                            }
                            else {
                                if (result == "true" && node) {
                                    if (node.get_level() == 0) {
                                        tree.get_nodes().remove(node);
                                    }
                                    else {
                                        node.get_parent().get_nodes().remove(node);
                                    }
                                }
                            }
                        }
                    }
                }
            }

    args.set_cancel(true);
}

function Skill_OnClientNodeDragStart(sender, eventArgs) {
    var node = eventArgs.get_node();
    var tree = node.get_treeView();
    var nodes = tree.get_allNodes();
    for (var i = 0; i < nodes.length; i++) {
        nodes[i].endEdit();
    }
}

function Skill_OnClientNodeDropping(sender, eventArgs) {
    var tree = $find('<%=RadTreeSkill.ClientID %>');
    var sourceNode = eventArgs.get_sourceNode();
    var sourceparentNode = sourceNode.get_parent();
    var targetNode = eventArgs.get_destNode();
    var targetParentNode = targetNode.get_parent();
    if (sourceNode.get_level() == 0 || targetNode.get_level() == 1 || sourceparentNode.get_text() == targetNode.get_text())
        eventArgs.set_cancel(true);
    else {
        var changeData = [sourceNode.get_value(), sourceNode.get_text(), targetNode.get_value(), sourceNode.get_value(), targetNode.get_value(), '<%=RadTreeSkill.ClientID %>'];
        var result = $uof.pageMethod.sync("ChangeSkillType", changeData);

        if (result == null) {
            alert("server error");
        }
        else {
            if (result.indexOf('Error') > -1) {
                alert(result);
            }
            else {
                var newNode = new Telerik.Web.UI.RadTreeNode();
                newNode.set_text(sourceNode.get_text());
                newNode.set_value(sourceNode.get_value());
                newNode.set_imageUrl(sourceNode.get_imageUrl());
                targetNode.get_nodes().add(newNode);
                sourceNode.get_parent().get_nodes().remove(sourceNode);
                newNode.set_selected(true);
                newNode.get_parent().set_expanded(true);
                newNode.scrollIntoView();
            }
        }
    }
}

function Skill_OnClientNodeClicking(sender, eventArgs) {
    var node = eventArgs.get_node();
    if (sender.get_allowNodeEditing() && !node.get_allowEdit())
        node.set_allowEdit(true);
    else
        node.set_allowEdit(false);
}

function Skill_OnClientNodeEditing(sender, eventArgs) {
    var tree = $find('<%=RadTreeSkill.ClientID %>');
            var node = eventArgs.get_node();
            var text = node.get_text();
            var newtext = eventArgs.get_newText();
            //如果是專長
            var level = node.get_level();
            if (level == 1) {
                var typeNode = node.get_parent();

                //如果是新增
                if (node.get_value() == null || node.get_value() == "") {
                    var guid = $uof.tool.getNewGuid();
                    node.set_value(guid);
                    var createData = [guid, newtext, typeNode.get_value(), guid, '<%=RadTreeSkill.ClientID %>'];
                    var result = $uof.pageMethod.sync("CreateSkill", createData);
                    if (result == null) {
                        alert("server error");
                        eventArgs.set_cancel(true);
                    }
                    else {
                        if (result.indexOf('Error') > -1) {

                            alert(result);
                            node.set_value(null);
                            eventArgs.set_cancel(true);
                            node.scrollIntoView();
                            setTimeout(function () { node.startEdit(); }, 100);
                        }
                        else {
                            var btnSkill = $find('<%=RadToolBar4.ClientID%>').findItemByValue('createSkill');
                            btnSkill.set_enabled(true);
                            node.set_selected(null);
                        }
                    }
                }
                else {
                    var modifyData = [node.get_value(), newtext, typeNode.get_value(), node.get_value(), '<%=RadTreeSkill.ClientID %>', text];
                    var result = $uof.pageMethod.sync("ModifySkill", modifyData);
                    if (result == null) {
                        alert("server error");
                        eventArgs.set_cancel(true);
                    }
                    else {
                        if (result.indexOf('Error') > -1) {
                            alert(result);
                            eventArgs.set_cancel(true);
                            node.scrollIntoView();
                            setTimeout(function () { node.startEdit(); }, 100);
                        }
                    }
                }
            }
                //如果是專長類別
            else if (level == 0) {
                //如果是新增
                if (node.get_value() == null || node.get_value() == "") {
                    var createData = [newtext, newtext, '<%=RadTreeSkill.ClientID %>'];
                    var result = $uof.pageMethod.sync("CreateSkillType", createData);
                    if (result == null) {
                        alert("server error");
                        eventArgs.set_cancel(true);
                    }
                    else {
                        if (result.indexOf('Error') > -1) {
                            alert(result);
                            node.set_value(null);
                            eventArgs.set_cancel(true);
                            node.scrollIntoView();
                            setTimeout(function () { node.startEdit(); }, 100);
                        }
                        else {
                            var btnSkillType = $find('<%=RadToolBar4.ClientID%>').findItemByValue('createType');
                            btnSkillType.set_enabled(true);
                            node.set_value(eventArgs.get_newText());
                            node.set_selected(null);
                        }
                    }
                }
                else {
                    var modifyData = [node.get_value(), newtext, node.get_value(), '<%=RadTreeSkill.ClientID %>', text];
                    var result = $uof.pageMethod.sync("ModifySkillType", modifyData);
                    if (result == null) {
                        alert("server error");
                        eventArgs.set_cancel(true);
                    }
                    else {
                        if (result.indexOf('Error') > -1) {
                            alert(result);
                            eventArgs.set_cancel(true);
                            node.scrollIntoView();
                            setTimeout(function () { node.startEdit(); }, 100);
                        }
                        else {
                            node.set_value(newtext);
                        }
                    }
                }
            }
    }

    function Edu_OnClientNodeEditing(sender, eventArgs) {
        var tree = $find('<%=RadTreeEdu.ClientID %>');
        var node = eventArgs.get_node();
        var text = node.get_text();
        var newtext = eventArgs.get_newText();

        //如果是新增;
        if (node.get_value() == null || node.get_value() == "") {
            var guid = $uof.tool.getNewGuid();
            node.set_value(guid);
            var createData = [guid, newtext, guid, '<%=RadTreeEdu.ClientID %>'];
            var result = $uof.pageMethod.sync("CreateEducation", createData);
            if (result == null) {
                alert("server error");
                eventArgs.set_cancel(true);
            }
            else {
                if (result.indexOf('Error') > -1) {

                    alert(result);
                    node.set_value(null);
                    eventArgs.set_cancel(true);
                    node.scrollIntoView();
                    setTimeout(function () { node.startEdit(); }, 100);
                }
                else {
                    var btnEdu = $find('<%=RadToolBar3.ClientID%>').findItemByValue('createEduc');
                        btnEdu.set_enabled(true);
                        node.set_selected(null);
                    }
                }
            }
            else {
                var modifyData = [node.get_value(), newtext, node.get_value(), '<%=RadTreeEdu.ClientID %>', text];
            var result = $uof.pageMethod.sync("ModifyEducation", modifyData);
            if (result == null) {
                alert("server error");

                node.set_text(text);
            }
            else {
                if (result.indexOf('Error') > -1) {
                    alert(result);
                    eventArgs.set_cancel(true);
                    node.scrollIntoView();
                    setTimeout(function () { node.startEdit(); }, 100);

                }
            }
        }
    }

    function Func_OnClientNodeEditing(sender, eventArgs) {
        var tree = $find('<%=RadTreeFunc.ClientID %>');
            var node = eventArgs.get_node();
            var text = node.get_text();
            var newtext = eventArgs.get_newText();
            //如果是新增;
            if (node.get_value() == null || node.get_value() == "") {
                var guid = $uof.tool.getNewGuid();
                node.set_value(guid);

                var createData = [guid, newtext, guid, '<%=RadTreeFunc.ClientID %>'];
                var result = $uof.pageMethod.sync("CreateJobFunction", createData);
                if (result == null) {
                    alert("server error");

                    node.get_parent().get_nodes().remove(node);
                }
                else {
                    if (result.indexOf('Error') > -1) {

                        alert(result);
                        node.set_value(null);
                        node.scrollIntoView();
                        setTimeout(function () { node.startEdit(); }, 100);
                    }
                    else {
                        var btnFunc = $find('<%=RadToolBar2.ClientID%>').findItemByValue('createFunc');
                        btnFunc.set_enabled(true);
                        node.set_selected(null);
                    }
                }
            }
            else {
                var modifyData = [node.get_value(), newtext, node.get_value(), '<%=RadTreeFunc.ClientID %>', text];
                var result = $uof.pageMethod.sync("ModifyJobFunction", modifyData);
                if (result == null) {
                    alert("server error");
                    eventArgs.set_cancel(true);
                }
                else {
                    if (result.indexOf('Error') > -1) {
                        alert(result);
                        eventArgs.set_cancel(true);
                        node.scrollIntoView();
                        setTimeout(function () { node.startEdit(); }, 100);
                    }
                }
            }
        }

        function Rank_OnClientNodeDragStart(sender, eventArgs) {
            var node = eventArgs.get_node();
            var tree = node.get_treeView();
            var nodes = tree.get_allNodes();
            for (var i = 0; i < nodes.length; i++) {
                nodes[i].endEdit();
            }
        }
        function Rank_OnClientNodeDropping(sender, eventArgs) {
            var tree = $find('<%=RadTreeRank.ClientID %>');
            var sourceNode = eventArgs.get_sourceNode();
            var sourceparentNode = sourceNode.get_parent();
            var targetNode = eventArgs.get_destNode();
            var targetParentNode = targetNode.get_parent();
            if (sourceNode.get_level() == 0 || targetNode.get_level() == 1 || sourceparentNode.get_text() == targetNode.get_text()) {
                eventArgs.set_cancel(true);

            }
            else {
                var changeData = [sourceNode.get_value(), sourceNode.get_text(), targetNode.get_value(), sourceNode.get_value(), targetNode.get_value(), '<%=RadTreeRank.ClientID %>'];
                var result = $uof.pageMethod.sync("ChangeTitleLevel", changeData);
                if (result == null) {
                    alert("server error");
                }
                else {
                    if (result.indexOf('Error') > -1) {
                        alert(result);
                    }
                    else {
                        var newNode = new Telerik.Web.UI.RadTreeNode();
                        newNode.set_text(sourceNode.get_text());
                        newNode.set_value(sourceNode.get_value());
                        newNode.set_imageUrl(sourceNode.get_imageUrl());
                        targetNode.get_nodes().add(newNode);
                        sourceNode.get_parent().get_nodes().remove(sourceNode);
                        newNode.set_selected(true);
                        newNode.get_parent().set_expanded(true);
                        newNode.scrollIntoView();
                    }
                }
            }
        }
        function Rank_OnClientNodeClicking(sender, eventArgs) {
            var node = eventArgs.get_node();

            if (sender.get_allowNodeEditing() && !node.get_allowEdit() && node.get_level() != 0)
                node.set_allowEdit(true);
            else
                node.set_allowEdit(false);

        }
        function Rank_OnClientNodeEditing(sender, eventArgs) {
            var tree = $find('<%=RadTreeRank.ClientID %>');
            var node = eventArgs.get_node();
            var text = node.get_text();
            var newtext = eventArgs.get_newText();
            //如果是職級
            var level = node.get_level();
            if (level == 1) {
                var typeNode = node.get_parent();

                //如果是新增
                if (node.get_value() == null || node.get_value() == "") {
                    var guid = $uof.tool.getNewGuid();
                    node.set_value(guid);
                    var createData = [guid, newtext, typeNode.get_text(), guid, '<%=RadTreeRank.ClientID %>'];
                    var result = $uof.pageMethod.sync("CreateTitle", createData);

                    if (result == null) {
                        alert("server error");
                        eventArgs.set_cancel(true);
                    }
                    else {
                        if (result.indexOf('Error') > -1) {

                            alert(result);
                            node.set_value(null);
                            eventArgs.set_cancel(true);
                            node.scrollIntoView();
                            setTimeout(function () { node.startEdit(); }, 100);
                        }
                        else {
                            var btnTitle = $find('<%=RadToolBar1.ClientID%>').findItemByValue('createTitle');
                            btnTitle.set_enabled(true);
                            node.set_selected(null);
                        }
                    }
                }
                else {
                    var mofifyData = [node.get_value(), newtext, typeNode.get_text(), node.get_value(), '<%=RadTreeRank.ClientID %>', text];
                    var result = $uof.pageMethod.sync("ModifyTitle", mofifyData);
                    if (result == null) {
                        alert("server error");
                        eventArgs.set_cancel(true);
                    }
                    else {
                        if (result.indexOf('Error') > -1) {
                            alert(result);
                            eventArgs.set_cancel(true);
                            node.scrollIntoView();
                            setTimeout(function () { node.startEdit(); }, 100);
                        }
                    }
                }
            }
        }

        function treeAddNode(result) {

            var tree = $find(result.request.args["treeId"]);
            var node = tree.findNodeByValue(result.request.args["nodeId"]);

            if (result.value == null) {
                alert("server error");

                node.get_parent().get_nodes().remove(node);
            }
            else {
                if (result.value.indexOf('Error') > -1) {

                    alert(result.value);
                    node.set_value('');
                    node.scrollIntoView();
                    setTimeout(function () { node.startEdit(); }, 100);
                }
                else {
                    node.set_selected(true);
                }
            }
        }
        function treeDragNode(result) {
            var tree = $find(result.request.args["treeId"]);
            if (result.value == null) {
                alert("server error");
            }
            else {
                if (result.value.indexOf('Error') > -1) {
                    alert(result.value);
                }
                else {

                    var sourceNode = tree.findNodeByValue(result.request.args["sourceNodeId"]);
                    var targetNode = tree.findNodeByValue(result.request.args["targetNodeId"]);
                    var newNode = new Telerik.Web.UI.RadTreeNode();
                    newNode.set_text(sourceNode.get_text());
                    newNode.set_value(sourceNode.get_value());
                    newNode.set_imageUrl(sourceNode.get_imageUrl());
                    targetNode.get_nodes().add(newNode);
                    sourceNode.get_parent().get_nodes().remove(sourceNode);
                    newNode.set_selected(true);
                    newNode.get_parent().set_expanded(true);
                    newNode.scrollIntoView();
                }
            }
        }
        function treeTypeAddNode(result) {
            var tree = $find(result.request.args["treeId"]);
            var node = tree.findNodeByText(result.request.args["nodeId"]);
            if (result.value == null) {
                alert("server error");
                node.get_parent().get_nodes().remove(node);
            }
            else {
                if (result.value.indexOf('Error') > -1) {
                    alert(result.value);
                    node.set_value('');
                    node.scrollIntoView();
                    setTimeout(function () { node.startEdit(); }, 100);
                }
                else {

                    node.set_value(node.get_text());
                    node.set_selected(null);
                }
            }
        }
        function treeRenameNode(result) {
            var tree = $find(result.request.args["treeId"]);
            var node = tree.findNodeByValue(result.request.args["nodeId"]);
            if (result.value == null) {
                alert("server error");

                node.set_text(result.request.args["oldname"]);
            }
            else {
                if (result.value.indexOf('Error') > -1) {
                    alert(result.value);
                    node.set_text(result.request.args["oldname"]);
                    node.scrollIntoView();
                    setTimeout(function () { node.startEdit(); }, 100);
                }
            }
        }
        function treeTypeRenameNode(result) {
            var tree = $find(result.request.args["treeId"]);
            var node = tree.findNodeByValue(result.request.args["nodeId"]);
            if (result.value == null) {
                alert("server error");

                node.set_text(result.request.args["oldname"]);
            }
            else {
                if (result.value.indexOf('Error') > -1) {
                    alert(result.value);
                    node.set_text(result.request.args["oldname"]);
                    node.scrollIntoView();
                    setTimeout(function () { node.startEdit(); }, 100);
                }
                else {
                    node.set_value(result.request.args["name"]);
                }
            }
        }
        function treeRemoveNode(result) {
            var tree = $find(result.request.args["treeId"]);
            var node = tree.findNodeByValue(result.request.args["nodeId"]);
            if (result.value == null) {
                alert("server error");
            }
            else {
                if (result.value == true && node) {
                    if (node.get_level() == 0) {
                        tree.get_nodes().remove(node);
                    }
                    else {
                        node.get_parent().get_nodes().remove(node);
                    }
                }
            }
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContentPlaceHolder" runat="Server">

    <telerik:RadSplitter ID="MainRadSplitter" runat="server" PanesBorderSize="0"  Width="100%" Height="100%" ResizeWithParentPane="True" 
                         ResizeWithBrowserWindow="True" meta:resourcekey="MainRadSplitterResource1" >
        <telerik:RadPane ID="RadPaneRank" runat="server" Scrolling="None" Width="31%" Index="0" meta:resourceKey="RadPaneRankResource1">
            <telerik:RadSplitter ID="RadSplitterRank" runat="server" Orientation="Horizontal" BorderSize="0" meta:resourceKey="RadSplitterRankResource1">
                <telerik:RadPane ID="RadPaneRankTop" runat="server" Height="35px" Scrolling="None" Index="0" MinHeight="35" meta:resourceKey="RadPaneRankTopResource1">
                    <telerik:RadToolBar ID="RadToolBar1" runat="server" Width="100%" OnClientButtonClicking="RadToolBar1_ButtonClicking" meta:resourceKey="RadToolBar1Resource1">
                        <Items>
                            <telerik:RadToolBarButton runat="server" HoveredImageUrl="~/Common/Images/Icon/icon_m18.png"
                                ImageUrl="~/Common/Images/Icon/icon_m18.png" Value="createRank" CheckedImageUrl="~/Common/Images/Icon/icon_m18.png"
                                Text="新增等級" ToolTip="新增等級" meta:resourcekey="TBarButtonResource7">
                            </telerik:RadToolBarButton>
                            <telerik:RadToolBarButton runat="server" IsSeparator="True" meta:resourceKey="RadToolBarButtonResource1">
                            </telerik:RadToolBarButton>
                            <telerik:RadToolBarButton runat="server" HoveredImageUrl="~/Common/Images/Icon/icon_m18.png"
                                ImageUrl="~/Common/Images/Icon/icon_m18.png" Value="createTitle" CheckedImageUrl="~/Common/Images/Icon/icon_m18.png"
                                Text="新增職級" ToolTip="新增職級" meta:resourcekey="TBarButtonResource8">
                            </telerik:RadToolBarButton>
                            <telerik:RadToolBarButton runat="server" IsSeparator="True" meta:resourceKey="RadToolBarButtonResource2">
                            </telerik:RadToolBarButton>
                            <telerik:RadToolBarButton runat="server" HoveredImageUrl="~/Common/Images/Icon/icon_m03.png"
                                ImageUrl="~/Common/Images/Icon/icon_m03.png" Value="delete" CheckedImageUrl="~/Common/Images/Icon/icon_m03.png"
                                Text="刪除" ToolTip="刪除" meta:resourcekey="TBarButtonResource9">
                            </telerik:RadToolBarButton>
                            <telerik:RadToolBarButton runat="server" IsSeparator="True" meta:resourceKey="RadToolBarButtonResource3">
                            </telerik:RadToolBarButton>
                        </Items>
                    </telerik:RadToolBar>
                </telerik:RadPane>
                <telerik:RadPane ID="RadPaneRankTree" runat="server" Index="1" meta:resourceKey="RadPaneRankTreeResource1">
                    <telerik:RadTreeView ID="RadTreeRank" runat="server" AllowNodeEditing="True" EnableDragAndDrop="True"
                        Height="100%" OnClientNodeDragStart="Rank_OnClientNodeDragStart" OnClientNodeDropping="Rank_OnClientNodeDropping"
                        OnClientNodeClicking="Rank_OnClientNodeClicking" OnClientNodeEditing="Rank_OnClientNodeEditing" meta:resourceKey="RadTreeRankResource1">
                    </telerik:RadTreeView>
                </telerik:RadPane>
            </telerik:RadSplitter>
        </telerik:RadPane>
        <telerik:RadPane ID="RadPaneFunc" runat="server" Scrolling="None"  Width="19%" meta:resourceKey="RadPaneFuncResource1">
            <telerik:RadSplitter ID="RadSplitterFunc" runat="server" Orientation="Horizontal" BorderSize="0" meta:resourceKey="RadSplitterFuncResource1" PanesBorderSize="0" SplitBarsSize="">
                <telerik:RadPane ID="RadPaneFuncTop" runat="server" Height="35px" Scrolling="None" Index="0" MinHeight="35" meta:resourceKey="RadPaneFuncTopResource1">
                    <telerik:RadToolBar ID="RadToolBar2" runat="server" Width="100%" OnClientButtonClicking="RadToolBar2_ButtonClicking" meta:resourceKey="RadToolBar2Resource1">
                        <Items>
                            <telerik:RadToolBarButton runat="server" HoveredImageUrl="~/Common/Images/Icon/icon_m19.png"
                                ImageUrl="~/Common/Images/Icon/icon_m19.png" Value="createFunc" CheckedImageUrl="~/Common/Images/Icon/icon_m19.png"
                                Text="新增職務" ToolTip="新增職務" meta:resourcekey="TBarButtonResource10">
                            </telerik:RadToolBarButton>
                            <telerik:RadToolBarButton runat="server" IsSeparator="True" meta:resourceKey="RadToolBarButtonResource4">
                            </telerik:RadToolBarButton>
                            <telerik:RadToolBarButton runat="server" HoveredImageUrl="~/Common/Images/Icon/icon_m03.png"
                                ImageUrl="~/Common/Images/Icon/icon_m03.png" Value="delete" CheckedImageUrl="~/Common/Images/Icon/icon_m03.png"
                                Text="刪除" ToolTip="刪除" meta:resourcekey="TBarButtonResource11">
                            </telerik:RadToolBarButton>
                            <telerik:RadToolBarButton runat="server" IsSeparator="True" meta:resourceKey="RadToolBarButtonResource5">
                            </telerik:RadToolBarButton>
                        </Items>
                    </telerik:RadToolBar>
                </telerik:RadPane>
                <telerik:RadPane ID="RadPaneFuncTree" runat="server" meta:resourceKey="RadPaneFuncTreeResource1">
                    <telerik:RadTreeView ID="RadTreeFunc" runat="server" AllowNodeEditing="True" EnableDragAndDrop="false"
                        Height="100%" OnClientNodeEditing="Func_OnClientNodeEditing" meta:resourceKey="RadTreeFuncResource1">
                    </telerik:RadTreeView>
                </telerik:RadPane>
            </telerik:RadSplitter>
        </telerik:RadPane>
        <telerik:RadPane ID="RadPaneEdu" runat="server" Scrolling="None" Width="19%" meta:resourceKey="RadPaneEduResource1">
            <telerik:RadSplitter ID="RadSplitterEdu" runat="server" Orientation="Horizontal" BorderSize="0" meta:resourceKey="RadSplitterEduResource1">
                <telerik:RadPane ID="RadPaneEduTop" runat="server" Height="35px" Scrolling="None" Index="0" MinHeight="35" meta:resourceKey="RadPaneEduTopResource1">
                    <telerik:RadToolBar ID="RadToolBar3" runat="server" Width="100%" OnClientButtonClicking="RadToolBar3_ButtonClicking" meta:resourceKey="RadToolBar3Resource1">
                        <Items>
                            <telerik:RadToolBarButton runat="server" HoveredImageUrl="~/Common/Images/Icon/icon_m27.png"
                                ImageUrl="~/Common/Images/Icon/icon_m27.png" Value="createEduc" CheckedImageUrl="~/Common/Images/Icon/icon_m27.png"
                                Text="新增學歷" ToolTip="新增學歷" meta:resourcekey="TBarButtonResource5">
                            </telerik:RadToolBarButton>
                            <telerik:RadToolBarButton runat="server" IsSeparator="True" meta:resourceKey="RadToolBarButtonResource6">
                            </telerik:RadToolBarButton>
                            <telerik:RadToolBarButton runat="server" HoveredImageUrl="~/Common/Images/Icon/icon_m03.png"
                                ImageUrl="~/Common/Images/Icon/icon_m03.png" Value="delete" CheckedImageUrl="~/Common/Images/Icon/icon_m03.png"
                                Text="刪除" ToolTip="刪除" meta:resourcekey="TBarButtonResource6">
                            </telerik:RadToolBarButton>
                            <telerik:RadToolBarButton runat="server" IsSeparator="True" meta:resourceKey="RadToolBarButtonResource7">
                            </telerik:RadToolBarButton>
                        </Items>
                    </telerik:RadToolBar>
                </telerik:RadPane>
                <telerik:RadPane ID="RadPaneEduTree" runat="server" meta:resourceKey="RadPaneEduTreeResource1">
                    <telerik:RadTreeView ID="RadTreeEdu" runat="server" AllowNodeEditing="True" EnableDragAndDrop="false"
                        Height="100%" OnClientNodeEditing="Edu_OnClientNodeEditing" meta:resourceKey="RadTreeEduResource1">
                    </telerik:RadTreeView>
                </telerik:RadPane>
            </telerik:RadSplitter>
        </telerik:RadPane>
        <telerik:RadPane ID="RadPaneSkill" runat="server" Scrolling="None" Width="31%" meta:resourceKey="RadPaneSkillResource1">
            <telerik:RadSplitter ID="RadSplitterSkill" runat="server" Orientation="Horizontal" BorderSize="0" meta:resourceKey="RadSplitterSkillResource1">
                <telerik:RadPane ID="RadPaneSkillTop" runat="server" Height="35px" Scrolling="None" MinHeight="35" meta:resourceKey="RadPaneSkillTopResource1">
                    <telerik:RadToolBar ID="RadToolBar4" runat="server" Width="100%" OnClientButtonClicking="RadToolBar4_ButtonClicking" meta:resourceKey="RadToolBar4Resource1">
                        <Items>
                            <telerik:RadToolBarButton runat="server" HoveredImageUrl="~/Common/Images/Icon/icon_m07.png"
                                ImageUrl="~/Common/Images/Icon/icon_m07.png" Value="createType" CheckedImageUrl="~/Common/Images/Icon/icon_m07.png"
                                Text="新增類別" ToolTip="新增類別" meta:resourcekey="TBarButtonResource12">
                            </telerik:RadToolBarButton>
                            <telerik:RadToolBarButton runat="server" IsSeparator="True" meta:resourceKey="RadToolBarButtonResource8">
                            </telerik:RadToolBarButton>
                            <telerik:RadToolBarButton runat="server" HoveredImageUrl="~/Common/Images/Icon/icon_m08.png"
                                ImageUrl="~/Common/Images/Icon/icon_m08.png" Value="createSkill" CheckedImageUrl="~/Common/Images/Icon/icon_m08.png"
                                Text="新增專長" ToolTip="新增專長" meta:resourcekey="TBarButtonResource13">
                            </telerik:RadToolBarButton>
                            <telerik:RadToolBarButton runat="server" IsSeparator="True" meta:resourceKey="RadToolBarButtonResource9">
                            </telerik:RadToolBarButton>
                            <telerik:RadToolBarButton runat="server" HoveredImageUrl="~/Common/Images/Icon/icon_m03.png"
                                ImageUrl="~/Common/Images/Icon/icon_m03.png" Value="delete" CheckedImageUrl="~/Common/Images/Icon/icon_m03.png"
                                Text="刪除" ToolTip="刪除" meta:resourcekey="TBarButtonResource14">
                            </telerik:RadToolBarButton>
                            <telerik:RadToolBarButton runat="server" IsSeparator="True" meta:resourceKey="RadToolBarButtonResource10">
                            </telerik:RadToolBarButton>
                        </Items>
                    </telerik:RadToolBar>
                </telerik:RadPane>
                <telerik:RadPane ID="RadPaneSkillTree" runat="server" meta:resourceKey="RadPaneSkillTreeResource1">
                    <telerik:RadTreeView ID="RadTreeSkill" runat="server" AllowNodeEditing="True" EnableDragAndDrop="True"
                        Height="100%" OnClientNodeDragStart="Skill_OnClientNodeDragStart" OnClientNodeDropping="Skill_OnClientNodeDropping"
                        OnClientNodeClicking="Skill_OnClientNodeClicking" OnClientNodeEditing="Skill_OnClientNodeEditing" meta:resourceKey="RadTreeSkillResource1">
                    </telerik:RadTreeView>
                </telerik:RadPane>
            </telerik:RadSplitter>
        </telerik:RadPane>
    </telerik:RadSplitter>

    <asp:Label ID="lblMessage4" runat="server" Text="系統預設職務,不允許刪除" Visible="False" meta:resourcekey="lblMessage4Resource1"></asp:Label>
    <asp:Label ID="lblMessage3" runat="server" Text="請先刪除專長,再刪除類別" Visible="False" meta:resourcekey="lblMessage3Resource1"></asp:Label>
    <asp:Label ID="lblMessage2" runat="server" Text="請先選擇類別" Visible="False" meta:resourcekey="lblMessage2Resource1"></asp:Label>
    <asp:Label ID="lblMessage1" runat="server" Text="請先選擇等級" Visible="False" meta:resourcekey="lblMessage1Resource1"></asp:Label>
</asp:Content>
