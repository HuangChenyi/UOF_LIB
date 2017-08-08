﻿<%@ Control Language="C#" AutoEventWireup="true" Inherits="Basic_Personal_UC_ChangePassword" Codebehind="UC_ChangePassword.ascx.cs" %>


<style type="text/css">
    .PasswordStrength1_Text
    {
        color: #0000ff;
        font-family: Arial;
        font-size: 9pt;
        padding: 0px 3px 2px 15px;
    }

    .ImgInvisible
    {
        display: none;
    }
</style>
<table class="PopTable" cellspacing="1" style="font-size:small">
    <tr>
        <td style="white-space: nowrap">
            <span style="color: #ff0000">*</span><asp:Label ID="labNewPassword" runat="server" Text="新密碼" meta:resourcekey="labNewPasswordResource1"></asp:Label></td>
        <td>
            <asp:TextBox ID="txbNewPassword" runat="server" TextMode="Password"
                meta:resourcekey="txbNewPasswordResource1" MaxLength="20"></asp:TextBox>
            <br />
            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ForeColor="Red"
                ErrorMessage="密碼格式不正確" ControlToValidate="txbNewPassword" Display="Dynamic"
                SetFocusOnError="True" ValidationExpression="^[a-zA-Z0-9]{6,20}$"
                meta:resourcekey="RegularExpressionValidator1Resource1" Enabled="False"></asp:RegularExpressionValidator>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txbNewPassword" ForeColor="Red"
                Display="Dynamic" ErrorMessage="請輸入新密碼" SetFocusOnError="True" meta:resourcekey="RequiredFieldValidator2Resource1"></asp:RequiredFieldValidator>
            <asp:CustomValidator ID="CustomValidator1" runat="server" ForeColor="Red"
                ControlToValidate="txbNewPassword" Display="Dynamic"
                ErrorMessage="密碼格式不正確" meta:resourcekey="CustomValidator1Resource1"
                ClientValidationFunction="checkPassword"></asp:CustomValidator>
            <asp:CustomValidator ID="CustomValidator3" runat="server" ForeColor="Red"
                ControlToValidate="txbNewPassword" Display="Dynamic"
                ErrorMessage="新密碼不能與前{0}次密碼相同,請重新輸入" meta:resourcekey="CustomValidator1Resource3"></asp:CustomValidator>
        </td>
    </tr>
    <tr>
        <td style="white-space: nowrap">
            <asp:Label ID="lbPasswordComplexityRequest" runat="server" Text="密碼設定要求"
                meta:resourcekey="lbPasswordComplexityRequestResource1"></asp:Label>
        </td>
        <td>
            <table cellpadding="0" cellspacing="0" style="font-size:small">
                <tr>
                    <td>
                        <asp:Image ID="imgReqMinLength" runat="server"
                            ImageUrl="~/Common/Images/Icon/icon_m173.gif"
                            CssClass="ImgInvisible" meta:resourcekey="imgReqMinLengthResource1" />
                    </td>
                    <td style="white-space: nowrap;">
                        <asp:Label
                            ID="lbReqMinLength" runat="server"
                            Text="密碼最小長度:" meta:resourcekey="lbReqMinLengthResource1"></asp:Label>
                    </td>
                    <asp:CustomValidator ID="CustomValidator2" runat="server"
                        ErrorMessage="CustomValidator" ForeColor="Red"
                        meta:resourcekey="CustomValidator2Resource1"></asp:CustomValidator>
                </tr>
                <tr>
                    <td>
                        <asp:Image ID="imgReqMinUpper" runat="server"
                            ImageUrl="~/Common/Images/Icon/icon_m173.gif"
                            CssClass="ImgInvisible" meta:resourcekey="imgReqMinUpperResource1" />
                    </td>
                    <td style="white-space: nowrap">
                        <asp:Label
                            ID="lbReqMinUpper" runat="server"
                            Text="最少大寫字母個數:" meta:resourcekey="lbReqMinUpperResource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Image ID="imgReqMinLower" runat="server"
                            ImageUrl="~/Common/Images/Icon/icon_m173.gif"
                            CssClass="ImgInvisible" meta:resourcekey="imgReqMinLowerResource1" />
                    </td>
                    <td style="white-space: nowrap">
                        <asp:Label
                            ID="lbReqMinLower" runat="server"
                            Text="最少小寫字母個數:" meta:resourcekey="lbReqMinLowerResource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Image ID="imgReqMinNumeric" runat="server"
                            ImageUrl="~/Common/Images/Icon/icon_m173.gif"
                            CssClass="ImgInvisible" meta:resourcekey="imgReqMinNumericResource1" />
                    </td>
                    <td style="white-space: nowrap">
                        <asp:Label
                            ID="lbReqMinNumeric" runat="server"
                            Text="最少數字個數:" meta:resourcekey="lbReqMinNumericResource1"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Image ID="imgReqMinSymbol" runat="server"
                            ImageUrl="~/Common/Images/Icon/icon_m173.gif"
                            CssClass="ImgInvisible" meta:resourcekey="imgReqMinSymbolResource1" />
                    </td>
                    <td style="white-space: nowrap">
                        <asp:Label
                            ID="lbReqMinSymbol" runat="server"
                            Text="最少符號個數:" meta:resourcekey="lbReqMinSymbolResource1"></asp:Label>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td style="white-space: nowrap">
            <span style="color: #ff0000">*</span><asp:Label ID="labConfirmPassword" runat="server" Text="確認密碼" meta:resourcekey="labConfirmPasswordResource1"></asp:Label>
        </td>
        <td>
            <asp:TextBox ID="txbConfirmPassword" runat="server" TextMode="Password"
                meta:resourcekey="txbConfirmPasswordResource1" MaxLength="20"></asp:TextBox>
            <br />
            <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToCompare="txbNewPassword"
                ControlToValidate="txbConfirmPassword" Display="Dynamic" ErrorMessage="密碼不符,請重新輸入密碼" ForeColor="Red"
                SetFocusOnError="True" meta:resourcekey="CompareValidator1Resource1"></asp:CompareValidator>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txbConfirmPassword" ForeColor="Red"
                Display="Dynamic" ErrorMessage="請輸入確認密碼" SetFocusOnError="True" meta:resourcekey="RequiredFieldValidator1Resource1"></asp:RequiredFieldValidator></td>
    </tr>
</table>
<script>
    function checkPassword(obj, args) {

        var pwd = PasswordAnalyzer(args.Value);

        args.IsValid = (pwd[0] >= reqLength
            && pwd[1] >= reqUpperCount
            && pwd[2] >= reqLowerCount
            && pwd[3] >= reqDigitCount
            && pwd[4] >= reqSymbolCount);
    }

    function CheckPassword(password) {
        var pwd = PasswordAnalyzer(password);

        var className = null;
        $('#<%=imgReqMinLength.ClientID %>').attr("class", className = pwd[0] >= reqLength ? "" : "ImgInvisible");
            $('#<%=imgReqMinUpper.ClientID %>').attr("class", className = pwd[1] >= reqUpperCount && reqUpperCount != 0 ? "" : "ImgInvisible");
            $('#<%=imgReqMinLower.ClientID %>').attr("class", className = pwd[2] >= reqLowerCount && reqLowerCount != 0 ? "" : "ImgInvisible");
            $('#<%=imgReqMinNumeric.ClientID %>').attr("class", className = pwd[3] >= reqDigitCount && reqDigitCount != 0 ? "" : "ImgInvisible");
            $('#<%=imgReqMinSymbol.ClientID %>').attr("class", className = pwd[4] >= reqSymbolCount && reqSymbolCount != 0 ? "" : "ImgInvisible");
        }

        function PasswordAnalyzer(password) {
            var numb = '0123456789';
            var lwr = 'abcdefghijklmnopqrstuvwxyz';
            var upr = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
            var sym = "~!@#$%^&*()_+`-=[]\\{}|;':\",./<>?";


            var upperCount = 0;
            var lowerCount = 0;
            var digitCount = 0;
            var symbolCount = 0;

            for (var i = 0; i < password.length; i++) {
                if (upr.indexOf(password.charAt(i)) > -1)
                    upperCount++;
                else if (lwr.indexOf(password.charAt(i)) > -1)
                    lowerCount++;
                else if (numb.indexOf(password.charAt(i)) > -1)
                    digitCount++;
                else if (sym.indexOf(password.charAt(i)) > -1)
                    symbolCount++;
            }

            var pwd = [password.length, upperCount, lowerCount, digitCount, symbolCount];
            return pwd;
        }
</script>
