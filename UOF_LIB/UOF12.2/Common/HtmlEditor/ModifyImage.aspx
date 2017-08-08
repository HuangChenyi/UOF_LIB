<%@ Page Language="C#" AutoEventWireup="true" Inherits="Common_HtmlEditor_ModifyImage" Culture="auto" meta:resourcekey="PageResource1" UICulture="auto" Codebehind="ModifyImage.aspx.cs" %>
<html>
<head runat="server">
    <title>Modify Image Size</title>
</head>
<body scroll=no>
    <form id="form1" runat="server">
    
   <table cellpadding="2" cellspacing="2" border="0" align=center>
                <tr>
                    <td align="right">
                        Height:</td>
                    <td>
                        <input type="text" value='' id='imageHeight' size="5" maxlength="3" /></td>
                </tr>
                <tr>
                    <td align="right">
                        Width:</td>
                    <td>
                        <input type="text" value='' id='imageWidth' size="5" maxlength="3" /></td>
                </tr>
                <tr>
                    <td>
                        <input type="button" value="OK" onclick='setImage();'></td>
                    <td>
                        <input type="button" value="Cancel" onclick='top.close();'></td>
                </tr>
            </table>
    <script>
        
        document.all['imageHeight'].value=  window.dialogArguments.height;
        document.all['imageWidth'].value=  window.dialogArguments.width;
        
        function setImage()
        {         
          window.dialogArguments.height=document.all['imageHeight'].value;
          window.dialogArguments.style.height=document.all['imageHeight'].value+"px";
          window.dialogArguments.width=document.all['imageWidth'].value;
          window.dialogArguments.style.width=document.all['imageWidth'].value+"px";
          top.close();
        }
    </script>
    </form>
</body>
</html>
