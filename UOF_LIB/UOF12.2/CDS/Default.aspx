<%@ Page Title="" Language="C#" MasterPageFile="~/Master/DefaultMasterPage.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="CDS_Default" %>

<%@ Register Assembly="Ede.Uof.Utility.Component.Grid" Namespace="Ede.Uof.Utility.Component" TagPrefix="Ede" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:Button ID="Button1" runat="server" Text="Button" CausesValidation="false" OnClick="Button1_Click" />
    <asp:Button ID="Button2" runat="server" Text="Button" OnClick="Button2_Click" />
    <asp:TextBox ID="TextBox2" runat="server"></asp:TextBox>
    <Ede:Grid ID="Grid1" runat="server" AutoGenerateCheckBoxColumn="false" AutoGenerateColumns="false">
        <Columns>
            <asp:TemplateField HeaderText="明細">
                <ItemTemplate>
                    <asp:TextBox ID="TextBox1" runat="server" Text='<%#Bind("RESULT") %>' Width="800px"
                        Height="100px" TextMode="MultiLine"></asp:TextBox>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>

    </Ede:Grid>
</asp:Content>

