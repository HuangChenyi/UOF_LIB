<%@ Page Title="" Language="C#" MasterPageFile="~/Master/DefaultMasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="CDS_Form_Default" %>
<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Fast" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <table>
        <tr>
            <td>
                <telerik:RadToolBar ID="toolBar" runat="server" OnButtonClick="toolBar_ButtonClick" Width="100%">
                    <Items>
                        <telerik:RadToolBarButton Value="Keyword">
                            <ItemTemplate>
                                <table>
                                    <tr>
                                        <td>
                                            <asp:Label ID="Label1" runat="server" Text="申請日期:"></asp:Label>
                                        </td>
                                        <td>
                                            <telerik:RadDatePicker ID="radDateStart" runat="server"></telerik:RadDatePicker>
                                        </td>
                                        <td>
                                            <asp:Label ID="Label2" runat="server" Text="~"></asp:Label>
                                        </td>
                                        <td>
                                            <telerik:RadDatePicker ID="radDateEnd" runat="server"></telerik:RadDatePicker>
                                        </td>
                                    </tr>
                                </table>
                            </ItemTemplate>
                        </telerik:RadToolBarButton>
                        <telerik:RadToolBarButton Value="Query" Text="查詢" 
                            CheckedImageUrl="~/Common/Images/Icon/icon_m39.gif"
                            HoveredImageUrl="~/Common/Images/Icon/icon_m39.gif"
                            ImageUrl="~/Common/Images/Icon/icon_m39.gif"
                            
                             ></telerik:RadToolBarButton>
                    </Items>
                </telerik:RadToolBar>
             </td>
        </tr>
        <tr>
            <td>
                <Fast:Grid ID="grid" runat="server" AutoGenerateCheckBoxColumn="false" AutoGenerateColumns="false" OnRowDataBound="grid_RowDataBound"
                     AllowPaging="true" OnPageIndexChanging="grid_PageIndexChanging"
                    >
                    <Columns>
                        <asp:TemplateField HeaderText="表單編號">
                            <ItemTemplate>
                                <asp:LinkButton ID="lbtnFormNbr" Text='<%# Bind("FORM_NBR") %>' runat="server"></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField  HeaderText="表單名稱" DataField="FORM_NAME"/>
                         <asp:BoundField  HeaderText="申請日期" DataField="BEGIN_TIME"/>
                        <asp:BoundField  HeaderText="申請者" DataField="APPLICANT_NAME"/>
                    </Columns>
                </Fast:Grid>
            </td>
        </tr>
    </table>
</asp:Content>

