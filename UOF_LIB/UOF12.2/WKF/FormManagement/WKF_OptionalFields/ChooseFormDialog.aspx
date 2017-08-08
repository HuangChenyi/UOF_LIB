<%@ Page Title="表單選取" Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" CodeBehind="ChooseFormDialog.aspx.cs" Inherits="Ede.Uof.Web.WKF.FormManagement.WKF_OptionalFields.ChooseFormDialog" culture="auto" meta:resourcekey="PageResource1" uiculture="auto" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>
<%@ Register Src="~/WKF/FormUse/UC_FormList.ascx" TagPrefix="uc1" TagName="UC_FormList" %>
<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Fast" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <telerik:RadToolBar ID="radToolBar1" runat="server" Width="100%" OnButtonClick="radToolBar1_ButtonClick" meta:resourcekey="radToolBar1Resource1">
        <Items>
            <telerik:RadToolBarButton runat="server" Value="formList" meta:resourcekey="RadToolBarButtonResource1">
                <ItemTemplate>
                    <asp:Label ID="lblFormName" runat="server" Text="表單名稱" meta:resourcekey="lblFormNameResource1"></asp:Label>
                    <asp:DropDownList ID="ddlFormList" runat="server" Width="160px" meta:resourcekey="ddlFormListResource1"></asp:DropDownList>
                </ItemTemplate>
            </telerik:RadToolBarButton>
            <telerik:RadToolBarButton IsSeparator="true" runat="server" meta:resourcekey="RadToolBarButtonResource2"></telerik:RadToolBarButton>
            <telerik:RadToolBarButton runat="server" Value="taskResult" meta:resourcekey="RadToolBarButtonResource3">
                <ItemTemplate>
                    <asp:Label ID="lblTaskResult" runat="server" Text="表單狀態" meta:resourcekey="lblTaskResultResource1"></asp:Label>
                    <asp:DropDownList ID="ddlTaskResult" runat="server" meta:resourcekey="ddlTaskResultResource1">
                        <asp:ListItem Text="所有狀態" Value="all" Selected="True" meta:resourcekey="ListItemResource1"></asp:ListItem>
                        <asp:ListItem Text="簽核中" Value="1" meta:resourcekey="lblSigningResource1"></asp:ListItem>
                        <asp:ListItem Text="同意" Value="2" meta:resourcekey="lblAgreedResource1"></asp:ListItem>
                        <asp:ListItem Text="否決" Value="3" meta:resourcekey="lblRejectedResource1"></asp:ListItem>
                        <asp:ListItem Text="作廢" Value="4" meta:resourcekey="lblVoidResource1"></asp:ListItem>
                        <asp:ListItem Text="異常" Value="5" meta:resourcekey="lblErrorResource1"></asp:ListItem>
                        <asp:ListItem Text="退回申請者" Value="6" meta:resourcekey="lblReturnResource1"></asp:ListItem>
                    </asp:DropDownList>
                </ItemTemplate>
            </telerik:RadToolBarButton>
            <telerik:RadToolBarButton runat="server" IsSeparator="true" meta:resourcekey="RadToolBarButtonResource4"></telerik:RadToolBarButton>
            <telerik:RadToolBarButton runat="server" Value="queryText" meta:resourcekey="RadToolBarButtonResource5">
                <ItemTemplate>
                    <asp:Label ID="lblQueryText" runat="server" Text="關鍵字查詢" meta:resourcekey="lblQueryTextResource1"></asp:Label>
                    <asp:TextBox ID="txtQueryText" runat="server" Width="120px" meta:resourcekey="txtQueryTextResource1"></asp:TextBox>
                </ItemTemplate>
            </telerik:RadToolBarButton>
            <telerik:RadToolBarButton runat="server" IsSeparator="true" meta:resourcekey="RadToolBarButtonResource6"></telerik:RadToolBarButton>
            <telerik:RadToolBarButton runat="server" Value="queryDate" meta:resourcekey="RadToolBarButtonResource7">
                <ItemTemplate>
                    <asp:Label ID="Label23" runat="server" Text="申請日期" ForeColor="Black" meta:resourcekey="Label23Resource1"></asp:Label>
                    <telerik:RadDatePicker ID="wdcDateBeginByKey" runat="server"></telerik:RadDatePicker>
                    <asp:Label ID="Label1" runat="server" Text="~" meta:resourcekey="Label1Resource1"></asp:Label>
                    <telerik:RadDatePicker ID="wdcDateEndByKey" runat="server"></telerik:RadDatePicker>
                </ItemTemplate>
            </telerik:RadToolBarButton>
            <telerik:RadToolBarButton runat="server" IsSeparator="true" meta:resourcekey="RadToolBarButtonResource8"></telerik:RadToolBarButton>
            <telerik:RadToolBarButton runat="server" Value="QUERY" Text="查詢" ImageUrl="~/Common/Images/Icon/icon_m39.gif" meta:resourcekey="RadToolBarButtonResource9"></telerik:RadToolBarButton>
            <telerik:RadToolBarButton runat="server" IsSeparator="true" meta:resourcekey="RadToolBarButtonResource10"></telerik:RadToolBarButton>
        </Items>
    </telerik:RadToolBar>
    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>
            <Fast:Grid ID="grdQuery" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateSelectButton="True"
                AutoGenerateCheckBoxColumn="False" OnRowCommand="grdQuery_RowCommand" OnRowDataBound="grdQuery_RowDataBound"
                AutoGenerateColumns="False" DataKeyOnClientWithCheckBox="False" DefaultSortDirection="Ascending"
                EnhancePager="True" OnPageIndexChanging="grdQuery_PageIndexChanging"
                OnSorting="grdQuery_Sorting" PageSize="15" DataKeyNames="TASK_ID"
                Style="margin-bottom: 4px" Width="100%" meta:resourcekey="grdQueryResource1">
                <EnhancePagerSettings ShowHeaderPager="True"/>
                <ExportExcelSettings AllowExportToExcel="False" />
                <Columns>
                    <asp:BoundField DataField="DOC_NBR" HeaderText="表單編號" SortExpression="DOC_NBR" meta:resourcekey="BoundFieldResource1">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Width="15%" />
                    </asp:BoundField>
                    <asp:BoundField HeaderText="表單名稱" SortExpression="FORM_NAME" DataField="FORM_NAME" meta:resourcekey="BoundFieldResource2">
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Width="20%" />
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="標題" meta:resourceKey="TITLEResource6" >
                        <ItemTemplate>
                            <asp:Label ID="lblDisplayTitle" runat="server"></asp:Label>
                        </ItemTemplate>
                        <ItemStyle Width="20%" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="申請者" meta:resourcekey="TemplateFieldResource1">
                        <ItemTemplate>
                            <asp:Label ID="lblApplicant" runat="server" meta:resourcekey="lblApplicantResource1"></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="APPLICANT" HeaderText="申請者" Visible="False" meta:resourcekey="BoundFieldResource3">
                        <ItemStyle Width="15%" />
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="結果" SortExpression="TASK_STATUS" meta:resourcekey="TemplateFieldResource2">
                        <ItemTemplate>
                            <asp:Label ID="lblResultQuery" runat="server" Text='<%# Eval("TASK_STATUS") %>' meta:resourcekey="lblResultQueryResource1"></asp:Label>
                        </ItemTemplate>
                        <HeaderStyle Wrap="False" />
                        <ItemStyle HorizontalAlign="Center" Width="5%" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="申請日期" meta:resourcekey="BoundFieldResource4" SortExpression="BEGIN_TIME" >
                        <ItemTemplate>
                            <asp:Label ID="lblBeginTime" runat="server" meta:resourcekey="lblApplicantResource1"></asp:Label>
                        </ItemTemplate>
                        <HeaderStyle Wrap="False" />
                        <ItemStyle HorizontalAlign="Center" Width="18%" />
                    </asp:TemplateField>
                    <asp:TemplateField Visible="False" meta:resourcekey="TemplateFieldResource3">
                        <ItemTemplate>
                            <asp:Label ID="lblTASK_ID" runat="server" Text='<%# Eval("TASK_ID") %>' meta:resourcekey="lblTASK_IDResource1"></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>

                </Columns>
            </Fast:Grid>
        </ContentTemplate>
    </asp:UpdatePanel>

    <input id="hiddenDropSourceNode" type="hidden" runat="server" />
    <input id="hiddenDropTargetNode" type="hidden" runat="server" />
    <input id="hiddenNodeId" type="hidden" runat="server" />
    <input id="hiddenTreeId" type="hidden" runat="server" />
    <asp:Label ID="lblError" runat="server" Text="異常" Visible="False" meta:resourcekey="lblErrorResource1"></asp:Label>
    <asp:Label ID="lblSigning" runat="server" Text="簽核中" Visible="False" meta:resourcekey="lblSigningResource1"></asp:Label>
    <asp:Label ID="lblAgreed" runat="server" Text="同意" Visible="False" meta:resourcekey="lblAgreedResource1"></asp:Label>
    <asp:Label ID="lblRejected" runat="server" Text="否決" Visible="False" meta:resourcekey="lblRejectedResource1"></asp:Label>
    <asp:Label ID="lblVoid" runat="server" Text="作廢" Visible="False" meta:resourcekey="lblVoidResource1"></asp:Label>
    <asp:Label ID="lblReturn" runat="server" Text="退回申請者" Visible="False" meta:resourcekey="lblReturnResource1"></asp:Label>
    <asp:HiddenField ID="hiddenX" runat="server" />
    <asp:HiddenField ID="hiddenY" runat="server" />
    <asp:HiddenField ID="hfFormLimit" runat="server" />
    <asp:HiddenField ID="hfFormApplicant" runat="server" />
</asp:Content>
