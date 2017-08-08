<%@ Page Language="C#" MasterPageFile="~/Master/DefaultMasterPage.master" AutoEventWireup="true" Inherits="DMS_Query_WaitApplyStatus" Title="" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="WaitApplyStatus.aspx.cs" %>

<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Fast" %>
<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script id="WaitApplyStatusjs" type="text/javascript">
        function RadToolbar1_Click(sender, args) {
            var toolBar = sender;
            var button = args.get_item();
            if (button.get_value() == "Delete") {
                if (confirm('<%=lblConfirmDelete.Text %>') == false)
                    args.set_cancel(true);
            }
        }
        function OpenPDFViewerWithFileCenterV2(sJson) {
            var h = $uof.tool.printScreenSize('h', screen.availHeight);
            var w = $uof.tool.printScreenSize('w', screen.availWidth);
            $uof.window.open("../DocStore/PdfViewerSL.aspx?p=" + encodeURIComponent(sJson), w, h);
        }
    </script>

    <table width="100%" height="400">
        <tr>
            <td valign="top">
                <telerik:RadToolBar ID="RadToolbar1" runat="server" Width="100%" OnButtonClick="RadToolbar1_ButtonClicked" OnClientButtonClicking="RadToolbar1_Click" meta:resourcekey="barMainResource1">
                    <Items>
                        <telerik:RadToolBarButton runat="server" Enabled="true" CheckedImageUrl="~/Common/Images/Icon/icon_m03.gif" DisabledImageUrl="~/Common/Images/icon_m03.gif" HoveredImageUrl="~/Common/Images/Icon/icon_m03.gif" ImageUrl="~/Common/Images/Icon/icon_m03.gif" Text="刪除" Value="Delete" meta:resourcekey="TBarButtonResource3">
                        </telerik:RadToolBarButton>
                        <telerik:RadToolBarButton runat="server" IsSeparator="True" Value="s1" meta:resourcekey="RadToolBarButtonResource2" />

                    </Items>
                </telerik:RadToolBar>

                <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                    <ContentTemplate>
                        <Fast:Grid ID="Grid1" runat="server" AllowSorting="True" AutoGenerateCheckBoxColumn="True"
                            AutoGenerateColumns="False" DataKeyNames="DOC_ID"
                            OnRowDataBound="Grid1_RowDataBound"
                            Width="100%" DataKeyOnClientWithCheckBox="False" OnPageIndexChanging="Grid1_PageIndexChanging" EnhancePager="True" AllowPaging="True" PageSize="15" OnSorting="Grid1_Sorting" OnRowCommand="Grid1_RowCommand">
                            <Columns>
                                <asp:TemplateField HeaderText="文件編號" SortExpression="DOC_SERIAL" meta:resourcekey="TemplateFieldResource7">
                                    <EditItemTemplate>
                                        <asp:TextBox runat="server" Text='<%# Bind("DOC_SERIAL") %>' ID="TextBox1"></asp:TextBox>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <span style="width: 80px;">
                                            <asp:Label runat="server" Text='<%# Bind("DOC_SERIAL") %>' ID="Label1"></asp:Label>
                                        </span>
                                    </ItemTemplate>
                                    <HeaderStyle Width="100px" Wrap="false" />
                                    <ItemStyle Width="100px" Wrap="false" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="文件名稱" meta:resourcekey="TemplateFieldResource3" SortExpression="DOC_NAME">
                                    <ItemTemplate>
                                        <span style="word-break: break-all; width: 100%;">
                                            <table>
                                                <tr>
                                                    <td style="min-width: 16px">
                                                        <asp:Image runat="server" ID="docIcon1" ImageUrl="~/DMS/images/icon/unknown.gif"></asp:Image>&nbsp; 
                                                    </td>
                                                    <td>
                                                        <asp:LinkButton ID="lbtnDocName" runat="server" Text='<%# Bind("DOC_NAME") %>'></asp:LinkButton>
                                                    </td>
                                                    <td  style="width:100%;">
                                                        <table style="width:100%;">
                                                            <tr>
                                                                <td style="text-align:right;">
                                                                    <asp:ImageButton ID="imgPDFViewer" CommandName="PDFViewer" CommandArgument='<%#Eval("DOC_ID")+","+Eval("MANUAL_VERSION") %>' Visible="false" runat="server" AlternateText="觀看文件" />
                                                                    <asp:Image ID="imgNoPDFViewer" runat="server" Visible="false"></asp:Image>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </span>
                                    </ItemTemplate>
                                    <HeaderStyle Wrap="false"/>
                                    <ItemStyle Wrap="false" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="MANUAL_VERSION" HeaderText="版本" meta:resourcekey="BoundFieldResource6" SortExpression="MANUAL_VERSION">
                                    <HeaderStyle Width="100px" Wrap="false" />
                                    <ItemStyle Width="100px" HorizontalAlign="Center" Wrap="false" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="狀態" meta:resourcekey="TemplateFieldResource4" SortExpression="DOC_STATUS">
                                    <ItemTemplate>
                                        <asp:Label runat="server" ID="lblStatus"></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle Width="100px" Wrap="false" />
                                    <ItemStyle HorizontalAlign="Center" Wrap="false" />
                                </asp:TemplateField>
                                 <asp:TemplateField HeaderText="開始審核時間" meta:resourcekey="BoundFieldResource4" SortExpression="ADD_DATE">
                                    <ItemTemplate>
                                        <asp:Label runat="server" ID="lblAddDate"></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle Width="150px" Wrap="false" />
                                    <ItemStyle Width="150px" Wrap="false" HorizontalAlign="Center" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="操作" meta:resourcekey="TemplateFieldResource6">
                                    <ItemTemplate>
                                        <asp:LinkButton runat="server" ID="lbtnInfo" Text="資訊" meta:resourceKey="lbtnInfoResource2"></asp:LinkButton>
                                        <%--<asp:LinkButton runat="server" ID="lbtnFlow1" meta:resourcekey="lbtnFlow1Resource1" Text="流程"></asp:LinkButton>--%>
                                    </ItemTemplate>
                                    <HeaderStyle Width="100px" Wrap="false" />
                                    <ItemStyle Width="100px" HorizontalAlign="Center" />
                                </asp:TemplateField>
                            </Columns>
                            <EnhancePagerSettings
                                ShowHeaderPager="True" FirstAltImageUrl="" FirstImageUrl="" LastAltImage="" LastImageUrl="" NextIAltImageUrl="" NextImageUrl="" PageInfoCssClass="" PageNumberCssClass="" PageNumberCurrentCssClass="" PageRedirectCssClass="" PreviousAltImageUrl="" PreviousImageUrl="" />
                        </Fast:Grid>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="RadToolbar1" EventName="ButtonClick" />
                    </Triggers>
                </asp:UpdatePanel>

                <asp:Label ID="lblCheckin" runat="server" Text="已存回" Visible="False" meta:resourcekey="lblCheckinResource1"></asp:Label>
                <asp:Label ID="lblCheckOut" runat="server" Text="已取出" Visible="False" meta:resourcekey="lblCheckOutResource1"></asp:Label>
                <asp:Label ID="lblApproval" runat="server" Text="審核中" Visible="False" meta:resourcekey="lblApprovalResource1"></asp:Label>
                <asp:Label ID="lblPublish" runat="server" Text="已公佈" Visible="False" meta:resourcekey="lblPublishResource1"></asp:Label>
                <asp:Label ID="lblInactive" runat="server" Text="已失效" Visible="False" meta:resourcekey="lblInactiveResource1"></asp:Label>
                <asp:Label ID="lblVoid" runat="server" Text="已作廢" Visible="False" meta:resourcekey="lblVoidResource1"></asp:Label>
                <asp:Label ID="lblTempInact" runat="server" Text="已下架" Visible="False" meta:resourcekey="lblTempInactResource1"></asp:Label>
                <asp:Label ID="lblOldVer" runat="server" Text="舊版本" Visible="False" meta:resourcekey="lblOldVerResource1"></asp:Label>
                <asp:Label ID="lblReAct" runat="server" Text="已上架" Visible="False" meta:resourcekey="lblReActResource1"></asp:Label>
                <asp:Label ID="labDocDeny" runat="server" meta:resourcekey="labDocDenyResource1"
                    Text="發佈拒絕" Visible="False"></asp:Label>
                <asp:Label ID="lblConfirmDelete" runat="server" Text="確定要刪除?" Visible="False" meta:resourcekey="lblConfirmDeleteResource1"></asp:Label>
                <asp:Label ID="lblPersonSend" runat="server" Text="個人送審文件" Visible="False" meta:resourcekey="lblPersonSendResource1"></asp:Label>
                <input id="hdAppPath" runat="server" style="width: 35px" type="hidden" />
                <asp:Label ID="labFileError" runat="server" ForeColor="Blue" Text="發生錯誤，檔案不存在！" Visible="False" meta:resourcekey="labFileErrorResource1"></asp:Label>
                <asp:Label ID="labAlert" runat="server" ForeColor="Blue" Text="正在進行檔案轉換，請稍後再觀看" Visible="False" meta:resourcekey="labAlertResource1"></asp:Label>
                <asp:Label ID="labPDFConvertERROR" runat="server" ForeColor="Blue" Text="發生錯誤，轉換失敗！" Visible="False" meta:resourcekey="labPDFConvertERRORResource1"></asp:Label>
                <asp:Label ID="lblNotsupportDoc" runat="server" Text="目錄設定為必須轉檔，但此檔案類型並不支援" ForeColor="Blue" Visible="False" meta:resourcekey="lblNotsupportDocResource1"></asp:Label>
                <asp:Label ID="lblProtectMsg" runat="server" Text="此為保全文件無法線上觀看" ForeColor="Blue" Visible="False" meta:resourcekey="lblProtectMsgResource1"></asp:Label>
                <asp:Label ID="lblFileNotTransferToUof" runat="server" Text="目前檔案仍在Proxy伺服器，正由系統進行傳輸中，請稍後！" Visible="False" ForeColor="Blue" meta:resourcekey="lblFileNotTransferToUofResource1"></asp:Label>
            </td>
        </tr>
    </table>
</asp:Content>

