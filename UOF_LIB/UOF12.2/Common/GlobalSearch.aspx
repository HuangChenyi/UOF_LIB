<%@ Page Language="C#" MasterPageFile="~/Master/DefaultMasterPage.master" AutoEventWireup="true" Inherits="Common_GlobalSearch" Trace="false" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="GlobalSearch.aspx.cs" %>
<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="cc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        function RadToolBar1_ButtonClicking(sender, args) {

            var Key = args.get_item().get_value();

            if (Key == "AdvanceSearch") {
                var keyword = $("#<%=hfKeyworCID.Value %>").val();
                if (keyword == "") {
                    alert('<%=Ede.Uof.Utility.Page.Common.Resource.GetResource("Common","ErrorNotAllowEmpty", Ede.Uof.EIP.SystemInfo.Current.Culture) %>');
                }
            }
        }
</script>
   <table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%">
        <tr>
            <td style=" vertical-align:top; width:80%;">
                <table width="100%">
                    <tr>
                        <td>
                            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                <ContentTemplate>
                                    <telerik:RadToolBar ID="RadToolBar1" runat="server" Width="100%"  OnClientButtonClicking="RadToolBar1_ButtonClicking"
                                        onbuttonclick="RadToolBar1_ButtonClick">
                                        <Items>
                                            <telerik:RadToolBarButton runat="server" Value="DDL">
                                            <ItemTemplate>
                                                <table>
                                                    <tr>
                                                        <td style="padding-left:2px; padding-right:1px">
                                                            <asp:DropDownList ID="ddlSiteName" runat="server" Width="120px">
                                                            </asp:DropDownList>
                                                        </td>
                                                        <td style="padding-left:2px; padding-right:1px">
                                                            <asp:DropDownList ID="ddlSearchItem" runat="server" Width="120px">
                                                            </asp:DropDownList>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </ItemTemplate>
                                            </telerik:RadToolBarButton>
                                            <telerik:RadToolBarButton runat="server" IsSeparator="True" >
                                            </telerik:RadToolBarButton>
                                            <telerik:RadToolBarButton runat="server" Value="Querystr">
                                            <ItemTemplate>
                                                <table border="0" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td style="padding-left:2px; padding-right:1px">
                                                            <telerik:RadDatePicker ID="WebDateChooserBegin" runat="server">
                                                            </telerik:RadDatePicker>
                                                        </td>
                                                        <td style="padding-left:2px; padding-right:1px">
                                                            <asp:Label  runat="server" ID="Label1">~</asp:Label>
                                                        </td>
                                                        <td style="padding-left:2px; padding-right:1px">
                                                            <telerik:RadDatePicker ID="WebDateChooserEnd" runat="server">
                                                            </telerik:RadDatePicker>
                                                        </td>
                                                        <td style="padding-left:2px; padding-right:1px">
                                                            <asp:TextBox ID="Keyword" runat="server"></asp:TextBox>
                                                        </td>
                                                    </tr>
                                                </table>                                            
                                            </ItemTemplate>
                                            </telerik:RadToolBarButton>
                                            <telerik:RadToolBarButton runat="server" IsSeparator="True" >
                                            </telerik:RadToolBarButton>
                                            <telerik:RadToolBarButton runat="server" DisabledImageUrl="~/Common/Images/Icon/icon_m39.gif"
                                                HoveredImageUrl="~/Common/Images/Icon/icon_m39.gif" ImageUrl="~/Common/Images/Icon/icon_m39.gif"
                                                Value="AdvanceSearch" CheckedImageUrl="~/Common/Images/Icon/icon_m39.gif"
                                                Text="搜尋" meta:resourcekey="TBarButtonResource9">
                                            </telerik:RadToolBarButton>
                                            <telerik:RadToolBarButton runat="server" IsSeparator="True" >
                                            </telerik:RadToolBarButton>
                                            <telerik:RadToolBarButton runat="server" Value="Text"   >
                                            <ItemTemplate>
                                                 <asp:Label ID="Text" runat="server" ></asp:Label>
                                            </ItemTemplate>
                                            </telerik:RadToolBarButton>
                                        </Items>
                                    </telerik:RadToolBar>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <style>
                                OL
                                {
                                    padding-right: 0px;
                                    padding-left: 0px;
                                    padding-bottom: 0px;
                                    margin: 0px;
                                    padding-top: 0px;
                                    font-family: arial,sans-serif;
                                }
                                .med
                                {
                                    padding-right: 0px;
                                    padding-left: 0px;
                                    font-size: 16px;
                                    padding-bottom: 0px;
                                    margin: 0px;
                                    padding-top: 0px;
                                }
                                OL LI
                                {
                                    list-style-type: none;
                                    margin: 8px;
                                    list-style-position: outside;
                                }
                                H3
                                {
                                    padding-right: 0px;
                                    padding-left: 0px;
                                    font-size: 16px;
                                    padding-bottom: 0px;
                                    margin: 0px;
                                    padding-top: 0px;
                                }
                                
                                H3 A SPAN
                                {
                                    font-size: 16px;
                                    text-decoration: underline;
                                }
                                .m
                                {
                                    font-size: 13px;
                                    color: #676767;
                                    font-weight: normal;
                                }
                                .ss
                                {
                                    font-size: 13px;
                                    color: #676767;
                                    font-weight: normal;
                                     font-weight:bold;
                                }                                
                                .g
                                {
                                    margin: 1em;
                                    color: #000000;
                                }
                                LI DIV
                                {
                                    font-weight: normal;
                                }
                                EM
                                {
                                    color: #c03;
                                    font-style: normal;
                                }
                            </style>
                            <asp:UpdatePanel ID="UpdatePanel2" runat="server" RenderMode="Inline" UpdateMode="Conditional">
                                <ContentTemplate>
                                    <div>
                                        <ol>
                                            <cc1:Grid ID="Grid22" runat="server" AutoGenerateCheckBoxColumn="False" AllowPaging="True"
                                                EnhancePager="True"  DataKeyOnClientWithCheckBox="False"
                                                PageSize="15"   DefaultSortDirection="Ascending"
                                                DefaultSortColumnName="" GridLines="None" ShowHeader="False" OnSorting="Grid22_Sorting"
                                                AllowSorting="True" AutoGenerateColumns="False" BorderStyle="None" BorderWidth="0px"
                                                OnRowDataBound="Grid22_RowDataBound" Width="100%" OnPageIndexChanging="Grid22_PageIndexChanging">
                                                <ExportExcelSettings AllowExportToExcel="false" ExportType="GridContent" />
                                                <EnhancePagerSettings FirstAltImageUrl="~/App_Themes/SecondTheme/images/grid/arrow_01.gif"
                                                    FirstImageUrl="~/App_Themes/SecondTheme/images/grid/arrow_01.gif" LastAltImage="~/App_Themes/SecondTheme/images/grid/arrow_04.gif"
                                                    LastImageUrl="~/App_Themes/SecondTheme/images/grid/arrow_04.gif" NextImageUrl="~/App_Themes/SecondTheme/images/grid/arrow_03.gif"
                                                    PreviousImageUrl="~/App_Themes/SecondTheme/images/grid/arrow_02.gif" NextIAltImageUrl="~/App_Themes/SecondTheme/images/grid/arrow_03.gif"
                                                    PreviousAltImageUrl="~/App_Themes/SecondTheme/images/grid/arrow_02.gif" PageInfoCssClass="GridPagerPagerInfo"
                                                    PageNumberCssClass="GridPagerNumber" PageNumberCurrentCssClass="GridPagerCurrentNumber"
                                                    PageRedirectCssClass="GridPagerPagerInfoRedirect" ShowHeaderPager="True" />
                                                <AlternatingRowStyle BackColor="White" />
                                                <Columns>
                                                    <asp:TemplateField InsertVisible="False" ShowHeader="False">
                                                        <ItemTemplate>
                                                            <li class="g">
                                                                <h3>
                                                                    <asp:HyperLink runat="server" ID="hlLink" NavigateUrl='<%# Eval("Link")%>' >
                                                                        <asp:Label runat="server" Text='<%#Eval("Subject") %>' ID="Label11"></asp:Label>
                                                                    </asp:HyperLink>
                                                                    <asp:Label runat="server" CssClass="m" Text='<%# Eval("Time") %>' ID="lblTime"></asp:Label>
                                                                    <asp:Label runat="server" CssClass="m" Text='<%# Eval("ModuleName") %>' ID="lbDisplayName"></asp:Label>
                                                                    <asp:Label runat="server" CssClass="ss" Text='<%# Eval("SiteName") %>' ID="lblSiteName"></asp:Label>
                                                                </h3>
                                                                <div>
                                                                    <asp:Label runat="server" Text='<%# Eval("Abstract") %>' ID="lbCount"></asp:Label>
                                                                </div>
                                                            </li>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>
                                            </cc1:Grid>
                                            <asp:DataList ID="DataList1" runat="server" ShowFooter="False" ShowHeader="False"
                                                OnItemDataBound="DataList1_ItemDataBound" Visible="False">
                                                <ItemTemplate>
                                                    <li class="g">
                                                        <h3>
                                                            <asp:HyperLink runat="server" ID="hlLink" NavigateUrl='<%# Eval("Link")%>'>
                                                                <asp:Label runat="server" Text='<%#Eval("Subject") %>' ID="Label11"></asp:Label>
                                                            </asp:HyperLink>
                                                            <asp:Label runat="server" CssClass="m" Text='<%# Eval("Time") %>' ID="lblTime"></asp:Label>
                                                            <asp:Label runat="server" CssClass="m" Text='<%# Eval("ModuleName") %>' ID="lbDisplayName"></asp:Label>
                                                        </h3>
                                                        <div>
                                                            <asp:Label runat="server" Text='<%# Eval("Abstract") %>' ID="lbCount"></asp:Label>
                                                        </div>
                                                    </li>
                                                </ItemTemplate>
                                            </asp:DataList></ol>
                                    </div>
                                    <asp:Panel ID="plError" runat="server" Visible="false">
                                        <asp:Label ID="Label4" runat="server" ForeColor="Red" Text="搜尋時發生下列錯誤" meta:resourcekey="Label4Resource9"></asp:Label>
                                        <asp:DataList ID="DataList2" runat="server" ShowFooter="False" ShowHeader="False">
                                            <ItemTemplate>
                                                <asp:Label runat="server" Text='<%# Eval("Key")  %>' ID="lbCount"></asp:Label>
                                                <asp:Label runat="server" Text='<%# Eval("Value")  %>' ID="Label3"></asp:Label>
                                            </ItemTemplate>
                                        </asp:DataList>
                                    </asp:Panel>
                                </ContentTemplate>
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="RadToolBar1" EventName="ButtonClick" />
                                    <%--<asp:AsyncPostBackTrigger ControlID="RepeaterHotkeyWords" EventName="ItemCommand" />--%>
                                </Triggers>
                            </asp:UpdatePanel>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <asp:Label runat="server" ID="lblSearchDurtionTime" Text="共有{0}項結果 共耗時 {1:#,0.00;(#,0.00)}秒" Visible="false" meta:resourcekey="lblSearchDurtionTimResource1"></asp:Label>
    <asp:Label runat="server" ID="lblSearchAll" Text="全部" Visible="false" meta:resourcekey="lblSearchAllResource1"></asp:Label>
    <asp:Label runat="server" ID="lblAllSites" Text="全部" Visible="false" meta:resourcekey="lblAllSitesResource1"></asp:Label>
    <asp:Label runat="server" ID="lblLocal" Text="本地" Visible="false" meta:resourcekey="lblLocalResource1"></asp:Label>
    <asp:Label runat="server" ID="lblSource" Text="來源" Visible="false" meta:resourcekey="lblSourceResource1"></asp:Label>
    <asp:HiddenField ID="hfKeyworCID" runat="server" />
    <asp:HiddenField ID="hfCurrentUser" runat="server" />
</asp:Content>
