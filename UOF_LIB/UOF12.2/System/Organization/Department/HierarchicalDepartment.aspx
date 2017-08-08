<%@ Page Title="部門管理" Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" Inherits="System_Organization_Department_HierarchicalDepartment" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="HierarchicalDepartment.aspx.cs" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">

        function resizeHRTree(X, Y) {
            var tree = $find("<%=RadTreeViewHR.ClientID %>");
            tree.get_element().style.height = Y - 35 + "px";
            tree.get_element().style.width = X + "px";
        }

        function RadToolBarHR_ManageDep_ButtonClicking(sender, args) {
            args.set_cancel(true);
            var Key = args.get_item().get_value();
            if (Key === "createDept") {
                var tree = $find("<%=RadTreeViewHR.ClientID %>");

                var parentNode = tree.get_selectedNode();
                if (parentNode !== null) {
                    SetToolbarEnable(false);

                    var node = new Telerik.Web.UI.RadTreeNode();
                    node.set_text("New Department");
                    node.set_imageUrl("<%=Request.ApplicationPath %>" + "/Common/Images/Icon/icon_m01.png");
                    parentNode.get_nodes().insert(0, node);
                    parentNode.expand();
                    node.scrollIntoView();
                    node.startEdit();
                }
                else {
                    alert('<%=lbNeedItemSelected.Text %>');
                }
            }
            else if (Key === "delete") {
                var tree = $find("<%=RadTreeViewHR.ClientID %>");
                var node = tree.get_selectedNode();
                var groupId = "<%=_groupId%>";
                if (node !== null) {
                    var level = node.get_level();

                    if (confirm('<%=Ede.Uof.Utility.Page.Common.Resource.GetResource("Common","ConfirmDelete") %>')) {
                        SetToolbarEnable(false);
                        var data = [node.get_value(), level, node.get_value(), groupId];
                        var result = $uof.pageMethod.sync("DeleteDepartment", data);

                        if (result === null) {
                            alert("server error");
                        }
                        else {
                            if (result.indexOf('Error') > -1) {

                                alert(result);
                            }
                            else {
                                if (node) {

                                    if (node.get_level === 0) {
                                        tree.get_nodes().remove(node);
                                        tree.get_nodes().getNode(0).set_selected(true);
                                    }
                                    else {
                                        var parentnode = node.get_parent();
                                        parentnode.get_nodes().remove(node);
                                        parentnode.set_selected(true);
                                        checkNodePostion(parentnode);
                                    }
                                }
                                top.returnValue = "";
                            }
                        }

                        SetToolbarEnable(true);
                    }
                }
            }
            else if (Key === "moveup") {
                var tree = $find("<%=RadTreeViewHR.ClientID %>");
                var node = tree.get_selectedNode();
                var parentNode = node.get_parent();
                var index = node.get_index();
                var groupId = "<%=_groupId%>";
                var data = [node.get_value(), parentNode.get_value(), index + 1 - 1, groupId];
                var result = $uof.pageMethod.sync("ChangeDepartmentPostion", data);

                if (result === null) {
                    alert("server error");
                    SetToolbarEnable(true);
                }
                else {
                    if (result.indexOf('Error') > -1) {
                        alert(result);
                        SetToolbarEnable(true);
                    }
                    else {
                        window.location = "<%=Request.Path %>?focusNode=" + result;
                        top.returnValue = "";
                    }
                }
            }
            else if (Key === "movedown") {
                var tree = $find("<%=RadTreeViewHR.ClientID %>");
                var node = tree.get_selectedNode();
                var parentNode = node.get_parent()
                var index = node.get_index();
                var groupId = "<%=_groupId%>";
                var data = [node.get_value(), parentNode.get_value(), index + 1 + 1, groupId];
                var result = $uof.pageMethod.sync("ChangeDepartmentPostion", data);

                if (result === null) {
                    alert("server error");
                    SetToolbarEnable(true);
                }
                else {
                    if (result.indexOf('Error') > -1) {
                        alert(result);
                        SetToolbarEnable(true);
                    }
                    else {
                        window.location = "<%=Request.Path %>?focusNode=" + result;
                        top.returnValue = "";
                    }
                }
            }
        }
Sys.Application.add_load(function () {
    var tree = $find("<%= RadTreeViewHR.ClientID %>");
            var selectedNode = tree.get_selectedNode()
            if (selectedNode !== null) {
                window.setTimeout(function () { selectedNode.scrollIntoView(); }, 200);
            }
            checkNodePostion(selectedNode);
        });
        function ClientNodeDragStart(sender, eventArgs) {
            var node = eventArgs.get_node();
            var tree = node.get_treeView();
            var nodes = tree.get_allNodes();
            for (var i = 0; i < nodes.length; i++) {
                nodes[i].endEdit();
            }
        }
        function ClientNodeDropping(sender, eventArgs) {

            var sourceNode = eventArgs.get_sourceNode();
            var parentNode = sourceNode.get_parent();
            var targetNode = eventArgs.get_destNode();
            var groupId = "<%=_groupId%>";
            if (parentNode === null) {
                eventArgs.set_cancel(true);
            }
            else {
                var changeDeptPData = [sourceNode.get_value(), sourceNode.get_text(), targetNode.get_value(), sourceNode.get_value(), targetNode.get_value(), groupId];
                var result = $uof.pageMethod.sync("ChangeDepartmentParent", changeDeptPData);

                if (result === null) {
                    alert("server error");
                    SetToolbarEnable(true);
                }
                else {
                    if (result.indexOf('Error') > -1) {
                        alert(result);
                        SetToolbarEnable(true);
                    }
                    else {
                        window.location = "<%=Request.Path %>?focusNode=" + result;
                        top.returnValue = "";
                    }
                }
            }



        }
        function ClientNodeEditing(sender, eventArgs) {
            var tree = $find("<%=RadTreeViewHR.ClientID %>");
            var node = eventArgs.get_node();
            var text = eventArgs.get_newText();
            var oldtext = node.get_text();
            var groupId = "<%=_groupId%>";
            if (escape(text) === '%A0' || escape(text) === "") {
                alert('<%=Ede.Uof.Utility.Page.Common.Resource.GetResource("Common","ErrorNotAllowEmpty", Ede.Uof.EIP.SystemInfo.Current.Culture) %>');
                eventArgs.set_cancel(true);
                setTimeout(function () { node.startEdit(); }, 100);
            }
            else {
                //如果是新增;
                if (node.get_value() === null || node.get_value() === "") {

                    var guid = $uof.tool.getNewGuid();
                    node.set_value(guid);
                    var parentNode = node.get_parent();
                    var parentGuid = parentNode.get_value();
                    var createData = [guid, text, parentGuid, guid, groupId, oldtext];
                    var result = $uof.pageMethod.sync("CreateDepartment", createData);

                    if (result === null) {
                        alert("server error");
                        node.get_parent().get_nodes().remove(node);

                        SetToolbarEnable(true);
                    }
                    else {
                        if (result.indexOf('Error') > -1) {
                            alert(result);
                            node.set_value("");
                            setTimeout(function () { node.startEdit(); }, 100);
                        }
                        else {
                            SetToolbarEnable(true);
                            top.returnValue = "";
                        }
                    }
                }
                else {
                    var modifyData = [node.get_value(), text, node.get_value(), groupId, oldtext];
                    var result = $uof.pageMethod.sync("ModifyDepartment", modifyData);

                    if (result === null) {
                        alert("server error");

                        node.set_text(oldtext);
                        SetToolbarEnable(true);
                    }
                    else {
                        if (result.indexOf('Error') > -1) {
                            alert(result);
                            eventArgs.set_cancel(true);
                            setTimeout(function () { node.startEdit(); }, 100);
                        }
                        else {
                            SetToolbarEnable(true);
                            top.returnValue = "";
                        }
                    }
                }
                checkNodePostion(node);
            }
        }
        function ClientNodeClicked(sender, eventArgs) {
            var node = eventArgs.get_node();
            node.set_selected(true);
            checkNodePostion(node);
        }
        function ClientNodeClicking(sender, eventArgs) {
            var node = eventArgs.get_node();
            if (sender.get_allowNodeEditing() && !node.get_allowEdit())
                node.set_allowEdit(true);
        }

        function checkNodePostion(treeNode) {

            if (treeNode !== null) {
                var oToolbar = $find("<%=RadToolBarHR.ClientID %>");
                var itemdown = oToolbar.findItemByValue("movedown");
                var itemup = oToolbar.findItemByValue("moveup");
                itemdown.set_enabled((treeNode.get_nextNode() !== null));
                itemup.set_enabled((treeNode.get_previousNode() !== null));
            }

        }

        function SetToolbarEnable(enable) {

            var oToolbar = $find("<%=RadToolBarHR.ClientID %>");
            var itemcreate = oToolbar.findItemByValue("createDept");
            var itemdel = oToolbar.findItemByValue("delete");
            itemcreate.set_enabled(enable);
            itemdel.set_enabled(enable);
        }

    </script>

    <telerik:RadSplitter ID="MainRadSplitter" runat="server" Width="100%" LiveResize="true" ResizeWithBrowserWindow="true" ResizeWithParentPane="true" Orientation="Horizontal" BorderSize="0">
        <telerik:RadPane ID="TopRadPane" runat="server" Height="35px" Scrolling="None">
            <telerik:RadToolBar ID="RadToolBarHR" runat="server" Width="100%" OnClientButtonClicking="RadToolBarHR_ManageDep_ButtonClicking">
                <Items>
                    <telerik:RadToolBarButton runat="server" HoveredImageUrl="~/System/Organization/Department/icon_images/icon_m01.gif" ImageUrl="~/System/Organization/Department/icon_images/icon_m01.gif"
                        Value="createDept" CheckedImageUrl="~/System/Organization/Department/icon_images/icon_m01.gif" Text="新增部門" meta:resourcekey="TBarButtonResource1">
                    </telerik:RadToolBarButton>
                    <telerik:RadToolBarButton runat="server" IsSeparator="True" Value="'s1">
                    </telerik:RadToolBarButton>
                    <telerik:RadToolBarButton runat="server" HoveredImageUrl="~/System/Organization/Department/icon_images/icon_m03.gif" ImageUrl="~/System/Organization/Department/icon_images/icon_m03.gif"
                        Value="delete" CheckedImageUrl="~/System/Organization/Department/icon_images/icon_m03.gif" Text="刪除" meta:resourcekey="TBarButtonResource2">
                    </telerik:RadToolBarButton>
                    <telerik:RadToolBarButton runat="server" IsSeparator="True" Value="s2">
                    </telerik:RadToolBarButton>
                    <telerik:RadToolBarButton runat="server" HoveredImageUrl="~/Common/Images/Icon/icon_m113.gif" ImageUrl="~/Common/Images/Icon/icon_m113.gif"
                        Value="moveup"
                        CheckedImageUrl="~/Common/Images/Icon/icon_m113.gif" Text="上移"
                        meta:resourcekey="TBarButtonResource3">
                    </telerik:RadToolBarButton>
                    <telerik:RadToolBarButton runat="server" IsSeparator="True" Value="'s3">
                    </telerik:RadToolBarButton>
                    <telerik:RadToolBarButton runat="server" HoveredImageUrl="~/Common/Images/Icon/icon_m114.gif" ImageUrl="~/Common/Images/Icon/icon_m114.gif"
                        Value="movedown"
                        CheckedImageUrl="~/Common/Images/Icon/icon_m114.gif" Text="下移"
                        meta:resourcekey="TBarButtonResource4">
                    </telerik:RadToolBarButton>
                    <telerik:RadToolBarButton runat="server" IsSeparator="True" Value="s4">
                    </telerik:RadToolBarButton>
                </Items>
            </telerik:RadToolBar>
        </telerik:RadPane>
        <telerik:RadPane ID="TreeRadPane" runat="server" Scrolling="None">
            <telerik:RadTreeView ID="RadTreeViewHR" runat="server" Height="500px"
                AllowNodeEditing="true" EnableDragAndDrop="true" OnClientNodeClicking="ClientNodeClicking"
                OnClientNodeClicked="ClientNodeClicked"
                OnClientNodeEditing="ClientNodeEditing" OnClientNodeDragStart="ClientNodeDragStart"
                OnClientNodeDropping="ClientNodeDropping">
            </telerik:RadTreeView>
        </telerik:RadPane>
    </telerik:RadSplitter>

    <input id="hiddenDropTargetNode" runat="server" type="hidden" />
    <input id="hiddenDropSourceNode" runat="server" type="hidden" />
    <input id="hiddenNodeId" runat="server" type="hidden" />

    <asp:Label ID="lbConfirmDelete" runat="server" Text="確定要刪除?" Visible="False" meta:resourcekey="lbConfirmDeleteResource1"></asp:Label>
    <asp:Label ID="lbNotAllowEmpty" runat="server" Text="部門不允許空白!" Visible="False" meta:resourcekey="lbNotAllowEmptyResource1"></asp:Label>
    <asp:Label ID="lbLengthErr" runat="server" Text="字數不可超過50 !" Visible="False" meta:resourcekey="lbLengthErrResource1"></asp:Label>
    <asp:Label ID="lbDuplicateError" runat="server" Text="名稱重複!" Visible="False" meta:resourcekey="lbDuplicateErrorResource1"></asp:Label>
    <asp:Label ID="lbNeedItemSelected" runat="server" Text="請先選擇節點!" Visible="False" meta:resourcekey="lbNeedItemSelectedResource1"></asp:Label>
    <asp:Label ID="lbNotAllowMove" runat="server" Text="無法搬移 ! 不可移動至子節點下" Visible="False" meta:resourcekey="lbNotAllowMoveResource1"></asp:Label>
    <asp:Label ID="lbNotAllowDelete" runat="server" Text="不可刪除!" Visible="False" meta:resourcekey="lbNotAllowDeleteResource1"></asp:Label>
    <asp:Label ID="lbNotAllowDelete2" runat="server" Text="節點內仍有項目存在, 不可刪除!" Visible="False" meta:resourcekey="lbNotAllowDelete2Resource1"></asp:Label>
</asp:Content>

