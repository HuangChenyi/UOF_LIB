<%@ Page Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" Inherits="System_Organization_Employee_SelectTitle"
    Title="設定部門職級" Culture="auto" UICulture="auto" meta:resourcekey="PageResource1" Codebehind="SelectTitle.aspx.cs" %>

<%@ Register Src="../../../Common/Organization/DepartmentTree.ascx" TagName="DepartmentTree"
    TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
<script type="text/javascript">
    function resizeLeftTree(X, Y) {
        var tree = $find("<%=DepartmentTree1.TreeClientId %>");
        tree.get_element().style.overflow = "auto";
        tree.get_element().style.height = (Y - 30) + "px";
        var newx=X/3-3
        if (newx < 200)
            newx=200

        tree.get_element().style.width = newx + "px";


        window.setTimeout(function () {
              var selectedNode = tree.get_selectedNode();

                if (selectedNode != null) {
                    selectedNode.scrollIntoView();
                }
            }, 500);
        }

</script>
    <telerik:RadSplitter ID="MainRadSplitter" runat="server" BorderSize="0" LiveResize="true" 
        ResizeWithBrowserWindow="true" ResizeWithParentPane="true">
        <telerik:RadPane ID="RadPaneLeft" runat="server" Scrolling="none" Width="33%" MinWidth="200">
            <telerik:RadSplitter ID="RadSplitterLeft" runat="server" Orientation="Horizontal" BorderSize="0">
                <telerik:RadPane ID="RadSplitterLeftTop" runat="server" Height="30px" Scrolling="None">
                    <table style="height: 100%; width: 100%"
                        class="NormalPopTable">
                        <tr>
                            <td class="PopTableHeader" style="text-align: left">
                                <asp:Label ID="Label1" runat="server" Text="部門" meta:resourcekey="Label1Resource1"></asp:Label>
                            </td>

                        </tr>
                    </table>
                </telerik:RadPane>
                <telerik:RadPane ID="RadSplitterLeftDown" runat="server" Scrolling="None" >
                    <uc1:DepartmentTree ID="DepartmentTree1" runat="server" Width="200px" Height="500px" />
                </telerik:RadPane>
            </telerik:RadSplitter>
        </telerik:RadPane>
        <telerik:RadPane ID="RadPaneMiddle" runat="server" Scrolling="none" Width="33%" MinWidth="200">
            <telerik:RadSplitter ID="RadSplitterMiddle" runat="server" Orientation="Horizontal" BorderSize="0">
                <telerik:RadPane ID="RadSplitterMiddleTop" runat="server" Height="30px" Scrolling="None">
                    <table style="height: 100%; width: 100%"
                        class="NormalPopTable">
                        <tr>
                            <td class="PopTableHeader" style="text-align: left">
                                <asp:Label ID="Label2" runat="server" Text="職級" meta:resourcekey="Label2Resource1"></asp:Label>
                            </td>
                        </tr>
                    </table>
                </telerik:RadPane>
                <telerik:RadPane ID="RadSplitterMiddleDown" runat="server">
                    <asp:RadioButtonList ID="rdoTitle" runat="server" meta:resourcekey="rdoTitleResource1">
                    </asp:RadioButtonList>
                </telerik:RadPane>
            </telerik:RadSplitter>
        </telerik:RadPane>
        <telerik:RadPane ID="RadPaneRight" runat="server" Scrolling="none" Width="33%" MinWidth="200">
            <telerik:RadSplitter ID="RadSplitterRight" runat="server" Orientation="Horizontal" BorderSize="0">
                <telerik:RadPane ID="RadSplitterRightTop" runat="server" Height="30px" Scrolling="None">
                    <table style="height: 100%; width: 100%"
                        class="NormalPopTable">
                        <tr>
                            <td class="PopTableHeader" style="text-align: left">
                                <asp:Label ID="Label3" runat="server" Text="職務" meta:resourcekey="Label3Resource1"></asp:Label>
                            </td>
                        </tr>
                    </table>
                </telerik:RadPane>
                <telerik:RadPane ID="RadSplitterRightDown" runat="server" >
                    <asp:CheckBoxList ID="chkFunc" runat="server" meta:resourcekey="chkFuncResource1">
                    </asp:CheckBoxList>
                </telerik:RadPane>
            </telerik:RadSplitter>
        </telerik:RadPane>
    </telerik:RadSplitter>


</asp:Content>
