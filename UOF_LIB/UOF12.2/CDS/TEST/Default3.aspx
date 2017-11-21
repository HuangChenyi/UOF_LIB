<%@ Page Title="" Language="C#" MasterPageFile="~/Master/DefaultMasterPage.master" AutoEventWireup="true" CodeFile="Default3.aspx.cs" Inherits="CDS_TEST_Default3" %>

<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Ede" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <Ede:Grid ID="Grid1" runat="server" AutoGenerateColumns="false"  AutoGenerateCheckBoxColumn="false" OnRowDataBound="Grid1_RowDataBound"  >
        <Columns>
            <asp:TemplateField>
                <ItemTemplate>
                    <asp:DropDownList ID="DropDownList1" OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged" AutoPostBack="true"   runat="server">
    
                    </asp:DropDownList>

                    <asp:DropDownList ID="DropDownList2"  runat="server"></asp:DropDownList>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </Ede:Grid>

</asp:Content>

