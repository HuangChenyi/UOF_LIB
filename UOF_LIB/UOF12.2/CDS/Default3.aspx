<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default3.aspx.cs" Inherits="CDS_Default3" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
<form method="post" id="formLogin" onsubmit="go();return false">

    <div style="display:none">
    <p>用户：<input type="text" name="user" size="20" value="admin"/></p>     
    <p>密码：<input type="text" name="password" size="20" value="manager"/></p>
    <p>登录成功后的跳转地址：<input type="text" name="surl" size="20" value="manager"/></p>
    <p>登录失败后的跳转地址：<input type="text" name="furl" size="20" value="manager"/></p>     
    <p><input type="submit" value="确定" name="B1"/></p> 
        </div>
</form>
 
    <script>

        go();

        function go()
{
    formLogin.action = "http://172.16.15.71:18080/smartbi/vision/index.jsp";
    formLogin.user.value = "uof";
    formLogin.password.value = "u9706789";
    formLogin.surl.value = "http://172.16.15.71:18080/smartbi/vision/index.jsp"; // 登录成功后的跳转地址；若该地址为外部链接，需要包含协议名，如以 http:// 开头
    formLogin.furl.value = "http://eip.edetw.com/eb2006"; // 登录失败后的跳转地址
    formLogin.submit();
    return true; 
}

        </script>

</body>
</html>
