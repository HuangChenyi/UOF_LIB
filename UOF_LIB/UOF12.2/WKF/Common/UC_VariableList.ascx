<%@ Control Language="C#" AutoEventWireup="true" Inherits="WKF_Common_UC_VariableList" Codebehind="UC_VariableList.ascx.cs" %>
<script  type="text/javascript">


    function CopyText(ClientID) {
        //Add code to handle your event here.

        clipboardData.setData("Text",  $('#'+ClientID).text());

    }


</script>

<table width = "300px" class = "PopTable" cellspacing ="0" align="center" cellpadding="0" >
    <colgroup class = "PopTableLeftTD" ></colgroup>
    <colgroup class = "PopTableRightTD"></colgroup>
    <tr>
        <td class = "PopTableHeader" colspan = 2  style="text-align:center!important" >
            <asp:Label ID="Label1" runat="server" Text="可用變數列表" 
                meta:resourcekey="Label1Resource1"></asp:Label>
        </td>
    </tr>
    <tr>
        <td class = "PopTableHeader" style="text-align:center!important" >
            <asp:Label ID="Label2" runat="server" Text="變數名稱" 
                meta:resourcekey="Label2Resource1"></asp:Label>
        </td>
        <td class = "PopTableHeader" style="text-align:center!important">
            <asp:Label ID="Label3" runat="server" Text="變數說明" 
                meta:resourcekey="Label3Resource1"></asp:Label>
        </td>
    </tr>
    <tr>
        <td >
            <asp:TextBox ID="txtFormName" runat="server" Text="{#formName}" ReadOnly="true" Style="text-align: right; border-width: 0px; background-color: initial"></asp:TextBox>
        </td>
        <td style="text-align:left">
            <asp:TextBox ID="TextBox1" runat="server" Text="表單名稱" ReadOnly="true" Style="text-align: left; border-width: 0px; background-color: initial"></asp:TextBox>
        </td>
    </tr>

    <tr>
        <td >
            <asp:TextBox ID="txtFormVersion" runat="server" Text="{#formVersion}" ReadOnly="true" Style="text-align: right; border-width: 0px; background-color: initial"></asp:TextBox>
        </td>
        <td style="text-align:left">
            <asp:TextBox ID="TextBox2" runat="server" Text="表單版本" ReadOnly="true" Style="text-align: left; border-width: 0px; background-color: initial"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td >
            <asp:TextBox ID="txtFormNo" runat="server" Text="{#formNo}" ReadOnly="true" Style="text-align: right; border-width: 0px; background-color: initial"></asp:TextBox>
        </td>
        <td style="text-align:left">
            <asp:TextBox ID="TextBox3" runat="server" Text="表單單號" ReadOnly="true" Style="text-align: left; border-width: 0px; background-color: initial"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td >
            <asp:TextBox ID="txtApplicant" runat="server" Text="{#applicant}" ReadOnly="true" Style="text-align: right; border-width: 0px; background-color: initial"></asp:TextBox>
        </td>
        <td style="text-align:left">
            <asp:TextBox ID="TextBox4" runat="server" Text="申請者" ReadOnly="true" Style="text-align: left; border-width: 0px; background-color: initial"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td >
            <asp:TextBox ID="txtApplyTime" runat="server" Text="{#applyTime}" ReadOnly="true" Style="text-align: right; border-width: 0px; background-color: initial"></asp:TextBox>
        </td>
        <td style="text-align:left">
            <asp:TextBox ID="TextBox5" runat="server" Text="申請時間" ReadOnly="true" Style="text-align: left; border-width: 0px; background-color: initial"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td >
            <asp:TextBox ID="txtFormStatus" runat="server" Text="{#formStatus}" ReadOnly="true" Style="text-align: right; border-width: 0px; background-color: initial"></asp:TextBox>
        </td>
        <td style="text-align:left">
            <asp:TextBox ID="TextBox6" runat="server" Text="表單狀態" ReadOnly="true" Style="text-align: left; border-width: 0px; background-color: initial"></asp:TextBox>
        </td>
    </tr>
    <tr>
        <td >
            <asp:TextBox ID="txtFormResult" runat="server" Text="{#formResult}" ReadOnly="true" Style="text-align: right; border-width: 0px; background-color: initial"></asp:TextBox>
        </td>
        <td style="text-align:left">
            <asp:TextBox ID="TextBox7" runat="server" Text="申請結果" ReadOnly="true" Style="text-align: left; border-width: 0px; background-color: initial"></asp:TextBox>
        </td>
    </tr>       
    <tr id="lastSignerTr" runat="server">
        <td >
            <asp:TextBox ID="txtLastSigner" runat="server" Text="{#lastSigner}" ReadOnly="true" Style="text-align: right; border-width: 0px; background-color: initial"></asp:TextBox>
        </td>
        <td style="text-align:left">
            <asp:TextBox ID="TextBox8" runat="server" Text="上一站簽核者" ReadOnly="true" Style="text-align: left; border-width: 0px; background-color: initial"></asp:TextBox>
        </td>
    </tr>      
    <tr id="discussionTr" runat="server">
        <td>
            <asp:TextBox ID="txtFormDiscussion" runat="server" Text="{#formForumReply}" ReadOnly="true" Style="text-align: right; border-width: 0px; background-color: initial"></asp:TextBox>
        </td>
        <td>
            <asp:TextBox ID="TextBox9" runat="server" Text="表單討論回覆內容" ReadOnly="true" Style="text-align: left; border-width: 0px; background-color: initial"></asp:TextBox>
        </td>
    </tr>     
</table>
<asp:Label ID="Label4" runat="server" Text="*點擊變數名稱可複製變數名稱"  CssClass="SizeMemo" Visible="False"
    meta:resourcekey="Label4Resource1" ></asp:Label>