﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" CodeFile="B.aspx.cs" Inherits="CDS_LAB_WebPage_B" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <table class="PopTable">
        <tr>
            <td>
                <asp:Label ID="Label2" runat="server" Text="返回值"></asp:Label>
            </td>
            
            <td>
                <asp:TextBox ID="txtReturnValue" runat="server"></asp:TextBox>
            </td>
        </tr>
    </table>
</asp:Content>

