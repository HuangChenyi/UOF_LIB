<%@ Page Title="" Language="C#" MasterPageFile="~/Master/MobileMasterPage.master" AutoEventWireup="true" CodeFile="SignPad.aspx.cs" Inherits="CDS_WKF_Fields_SignPad" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    

    <style>
    body {
  
  font-family: Helvetica, Sans-Serif;

  -moz-user-select: none;
  -webkit-user-select: none;
  -ms-user-select: none;
}

.m-signature-pad {
  position: absolute;
  font-size: 10px;
  width: 700px;
  height: 400px;
  top: 50%;
  left: 50%;
  margin-left: -350px;
  margin-top: -200px;
  border: 1px solid #e8e8e8;
  background-color: #fff;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.27), 0 0 40px rgba(0, 0, 0, 0.08) inset;
  border-radius: 4px;
}

.m-signature-pad:before, .m-signature-pad:after {
	position: absolute;
  z-index: -1;
  content: "";
	width: 40%;
	height: 10px;
	left: 20px;
	bottom: 10px;
	background: transparent;
	-webkit-transform: skew(-3deg) rotate(-3deg);
	-moz-transform: skew(-3deg) rotate(-3deg);
	-ms-transform: skew(-3deg) rotate(-3deg);
	-o-transform: skew(-3deg) rotate(-3deg);
	transform: skew(-3deg) rotate(-3deg);
	box-shadow: 0 8px 12px rgba(0, 0, 0, 0.4);
}

.m-signature-pad:after {
	left: auto;
	right: 20px;
	-webkit-transform: skew(3deg) rotate(3deg);
	-moz-transform: skew(3deg) rotate(3deg);
	-ms-transform: skew(3deg) rotate(3deg);
	-o-transform: skew(3deg) rotate(3deg);
	transform: skew(3deg) rotate(3deg);
}

.m-signature-pad--body {
  position: absolute;
  left: 20px;
  right: 20px;
  top: 20px;
  bottom: 60px;
  border: 1px solid #f4f4f4;
}

.m-signature-pad--body
  canvas {
    position: absolute;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    border-radius: 4px;
    box-shadow: 0 0 5px rgba(0, 0, 0, 0.02) inset;
  }

.m-signature-pad--footer {
  position: absolute;
  left: 20px;
  right: 20px;
  bottom: 20px;
  height: 40px;
}

.m-signature-pad--footer
  .description {
    color: #C3C3C3;
    text-align: center;
    font-size: 1.2em;
    margin-top: 1.8em;
  }

.m-signature-pad--footer
  .button {
    position: absolute;
    bottom: 0;
  }

.m-signature-pad--footer
  .button.clear {
    left: 0;
  }

.m-signature-pad--footer
  .button.save {
    right: 0;
  }

@media screen and (max-width: 1024px) {
  .m-signature-pad {
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    width: auto;
    height: auto;
    min-width: 250px;
    min-height: 140px;
    margin: 5%;
  }
  #github {
    display: none;
  }
}

@media screen and (min-device-width: 768px) and (max-device-width: 1024px) {
  .m-signature-pad {
    margin: 10%;
  }
}

@media screen and (max-height: 320px) {
  .m-signature-pad--body {
    left: 0;
    right: 0;
    top: 0;
    bottom: 32px;
  }
  .m-signature-pad--footer {
    left: 20px;
    right: 20px;
    bottom: 4px;
    height: 28px;
  }
  .m-signature-pad--footer
    .description {
      font-size: 1em;
      margin-top: 1em;
    }
}



</style>
    <asp:TextBox ID="txtImgTemp" runat="server"   TextMode="MultiLine" style="display:none"  Width="200px" Height="200px" ></asp:TextBox>
    <asp:Panel id="pan" runat="server" style="vertical-align:middle; height:900px" >
      <div id="signature-pad" >
    <div style="vertical-align:middle"  >
        
            <center>     
                <canvas   id ="canvas_"  style="width:90%;height:400px;border:solid;border-width:1px;"  ></canvas>

            </center>
 
    </div>
    <div >
      <button type="button" id="btnClear" data-action="clear"  style="display:none" >清除</button>
      <button type="button"  data-action="save"  style="display:none" >Save</button>
    </div>
  </div>
        </asp:Panel>
    <asp:Label ID="lblClear" runat="server" Text="清除" Visible="false"></asp:Label>


      <script type="text/javascript">

          function DoSave()
          {
              UpdateImageData();
          }

          function DoClear()
          {

              btnClear.click();
              return false;
          }

          Sys.Application.add_load(function () { setImg(); });
          function UpdateImageData() {

              $('#<%= txtImgTemp.ClientID%>').val(signaturePad.toDataURL());
         //    img.src = signaturePad.toDataURL();
         }

         function setImg() {

             if ($('#<%= txtImgTemp.ClientID%>').val() != '') {
                 signaturePad.fromDataURL($('#<%= txtImgTemp.ClientID%>').val());
               //  img.src = $('#<%= txtImgTemp.ClientID%>').val();
             }
         }

       


  </script>
    <script type="text/javascript"  src="http://172.16.3.13/UOF_SIGN/CDS/WKF_Fields/js/signature_pad.js"></script>
    <script  src="http://172.16.3.13/UOF_SIGN/CDS/WKF_Fields/js/app.js"></script>

</asp:Content>

