<%@ Page Title="站點設定" Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" Inherits="WKF_FlowManagement_SetFvrSiteSignSetting" culture="auto" meta:resourcekey="PageResource1" uiculture="auto" Codebehind="SetFvrSiteSignSetting.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<script>
    function onClick() {

    

        if ($('#<%=rbByForm.ClientID%>').prop("checked") == true) {
            $('#<%=Panel1.ClientID%>').hide();
         
        }
        else {
            $('#<%=Panel1.ClientID%>').show();
        }
    }

</script>

    <table class="PopTable" cellpadding=0 cellspacing=1>
        <tr>
            <td nowrap=nowrap>                
                <asp:Label ID="Label1" runat="server" Text="站點簽核設定" 
                    meta:resourcekey="Label1Resource1"></asp:Label>
            </td>
            <td>
                <table cellpadding=0 cellspacing=0>
                    <tr>
                        <td>
                            <asp:RadioButton ID="rbByForm" runat="server" GroupName="rbSetting" Text="繼承表單" 
                                onclick="onClick()" Checked=True meta:resourcekey="rbByFormResource1" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:RadioButton ID="rbBySite" runat="server" GroupName="rbSetting" 
                                Text="依站點設定" onclick="onClick()" meta:resourcekey="rbBySiteResource1"  />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Panel ID="Panel1" runat="server" meta:resourcekey="Panel1Resource1">
                                <asp:CheckBoxList ID="cbSignSettingList" runat="server" 
                                    meta:resourcekey="cbSignSettingListResource1" >
                                <asp:ListItem Selected="True" Value="AllowReject" 
                                        meta:resourcekey="ListItemResource1" Text="該站點允許否決"></asp:ListItem>
                                <asp:ListItem Selected="True" Value="AllowReturn" 
                                        meta:resourcekey="ListItemResource2" Text="該站點允許退簽"></asp:ListItem>
                                <asp:ListItem Selected="True" Value="AllowAdditional" 
                                        meta:resourcekey="ListItemResource3" Text="該站點允許加簽"></asp:ListItem>
                                <asp:ListItem Selected="False" Value="AllowAdvancedAdditional" Text="該站點允許進階加簽" meta:resourcekey="ListItemResource4"></asp:ListItem>
                            </asp:CheckBoxList>   
                            </asp:Panel>
                        </td>
                    </tr>
                </table>             
            </td>
        </tr>
    </table>
</asp:Content>

