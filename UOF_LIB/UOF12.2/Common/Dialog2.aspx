<%@ Page Language="C#" AutoEventWireup="true" Inherits="Common_Dialog2" Codebehind="Dialog2.aspx.cs" %>

<!DOCTYPE html>
<html>
<head runat="server">    
    <meta content="text/html; charset=utf-8" />
    <link id="Link1" rel="SHORTCUT ICON" href="~/logo.ico" runat="server" enableviewstate="False" />
    <link href="Style/uof-fixed.css" rel="stylesheet" />
    <style type="text/css">
            html, body, form, iframe {
                height: 100%;
                margin: 0;
                padding: 0;
            }
            body {
                overflow: hidden;
            }          
            #frameContainer {
                margin: 0px;
                position: fixed;
                top: 0px;
                left: 0px;
                width: 100%;
                height: 100%;
            }
            .ruInputs li {
                float: left;
                background-color: #add8e6;
                -webkit-border-radius: 3px;
                -moz-border-radius: 3px;
                border-radius: 3px;
                margin: 2px !important;
            }
            .ruInputs li:nth-last-child(1) {
                float: left;
                visibility: hidden;
            }
            .ruInputs .ruCancel, .ruInputs .ruRemove {
                color: transparent !important; /* Fix for Firefox */
                border-style: none !important;
                border-width: 0 !important;
                padding: 0 0 0 16px !important; /* Fix for Internet Explorer */
                margin: 6px 3px 3px 3px;
                text-align: left !important;
                width: 16px !important;
                height: 16px !important;
                line-height: 1 !important;
                background: transparent url("../common/images/icon/cancel.png") no-repeat scroll 0 0 !important;
                overflow: hidden !important;
                cursor: pointer !important;
            }
            .ruUploadOnHold {
                overflow: hidden;
                text-overflow: ellipsis;
                width: 120px;
            }
            .ruUploadCancelled {
                overflow: hidden;
                text-overflow: ellipsis;
                width: 120px;
            }
            .ruUploadProgress {
                overflow: hidden;
                text-overflow: ellipsis;
                width: 120px;
            }
            .ruUploadFailure {
                color: red;
                cursor: pointer;
            }
            .RadUpload {
                width: 100% !important;
                height: 30px;
                overflow: hidden;
            }
            .RadUpload .ruUploadProgress {
                background: transparent !important;
                padding-left: 8px !important;
            }
        </style>

</head>
<body style="background-image: url(<%=themePath %>/images/po_04.gif);">
    <form id="form1" runat="server">
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server">
            <Scripts>
                <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.Core.js" />
                <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQuery.js" />
                <asp:ScriptReference Assembly="Telerik.Web.UI" Name="Telerik.Web.UI.Common.jQueryInclude.js" />
                <asp:ScriptReference Path="~/Common/javascript/uofScript.js" ScriptMode="Release" />
                <asp:ScriptReference Path="~/Common/javascript/jQuery/plugin/jquery.blockUI.js" ScriptMode="Release" />
            </Scripts>
        </telerik:RadScriptManager>
        <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server" />
        <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server" DefaultLoadingPanelID="RadAjaxLoadingPanel1">
            <AjaxSettings>
                <telerik:AjaxSetting AjaxControlID="lbtnResetRadAsyncUpload">
                    <UpdatedControls>
                        <telerik:AjaxUpdatedControl ControlID="RadAsyncUpload1" />
                        <telerik:AjaxUpdatedControl ControlID="scriptBlock2" />
                        <telerik:AjaxUpdatedControl ControlID="hdnDownloadHandler" />
                        <telerik:AjaxUpdatedControl ControlID="hdnProxyIndex" />
                    </UpdatedControls>
                </telerik:AjaxSetting>
            </AjaxSettings>
        </telerik:RadAjaxManager>
        <div id="frameContainer">
            <div style="height: 0; background: #afeeee;" id="filePanel">
                <div id="fileUploadControl">
                    <telerik:RadAsyncUpload runat="server" ID="RadAsyncUpload1"
                        Skin="Metro"
                        EnableInlineProgress="True"
                        MultipleFileSelection="Automatic"
                        ManualUpload="False"
                        DisableChunkUpload="False"
                        OnClientAdded="uploadv3_ClientAdded"
                        OnClientFileSelected="uploadv3_ClientFileSelected"
                        OnClientFileUploading="uploadv3_ClientFileUploading"
                        OnClientFileUploaded="uploadv3_ClientFileUploaded"
                        OnClientFilesUploaded="uploadv3_ClientFilesUploaded"
                        OnClientValidationFailed="uploadv3_ClientValidationFailed"
                        OnClientFileUploadFailed="uploadv3_ClientFileUploadFailed"
                        OnClientFileUploadRemoved="uploadv3_ClienFileUploadRemoved" />
                </div>
            </div>
            <div style="height: 100%" id="contentPanel">
                <div id="dis" style="height: 100%; width: 100%; display: none">
                    <div id="loading" style="margin: 10px auto 10px auto; text-align: center">
                        <div class="LoadingText">Loading</div>
                        <div id="loadingAnimation" style="margin: 2px auto 2px auto;">
                            <div></div>
                            <div></div>
                            <div></div>
                            <div></div>
                            <div></div>
                            <div></div>
                            <div></div>
                            <div></div>
                        </div>
                    </div>
                </div>
                <iframe id="content" runat="server" style="height: 100%; width: 100%;" allowtransparency="false"></iframe>
            </div>
        </div>
        <input id="hdnDownloadHandler" type="hidden" runat="server" />
        <input id="hdnProxyIndex" type="hidden" runat="server" />
        <asp:LinkButton ID="lbtnResetRadAsyncUpload" runat="server" OnClick="lbtnResetRadAsyncUpload_OnClick"></asp:LinkButton>


        <telerik:RadScriptBlock runat="server">
            <script type="text/javascript">
                    //<![CDATA[
                    var dt=40;
                    var dl=40;
                    if (typeof(dialogArguments) == 'undefined' || typeof(dialogArguments.dialogTop) == 'undefined') {
                        dt = 40;
                        dl = 40;
                    } else {
                        t = dialogArguments.dialogLeft.replace('px', '');
                        dt = (t - 0) + 40;
                        l = dialogArguments.dialogLeft.replace('px', '');
                        dl = (l - 0) + 40;
                    }
                    window.dialogTop = dt + 'px';
                    window.dialogLeft = dl + 'px';

                    var uploadv3 = uploadv3 || {};
                    uploadv3._uploaded = uploadv3._uploaded || {};
                    uploadv3._filePanelOpened = false;
                    uploadv3._filePanelHeight = 40;
                    
                    $(function() {
                        $(window).resize(function() {
                            var wh = $(window).height();
                            if (uploadv3._filePanelOpened) {
                                $("#contentPanel").height(wh - uploadv3._filePanelHeight);
                            } else {
                                $("#contentPanel").height(wh);
                            }
                        });
                    
                    });

                    function select_file(source, ext) {
                        var upload = $find("<%= RadAsyncUpload1.ClientID %>");
                        if (upload.get_isUploading()) {
                            alert("Still uploading!");
                            return;
                        }                        
                        var clientId = source.get_clientId();
                        upload.set_allowedFileExtensions(ext);
                        upload["_uofFileGroupId"] = source.get_fileGroupId(); // save paras to radasyncupload
                        upload["_uofFileCenterClientId"] = clientId;
                        upload["_uofModuleName"] = source.get_moduleName();
                        upload["_uofSubFolder"] = source.get_subFolder();                           
                        upload["_uofGroupId"] = source.get_selectedGroupUofId();
                        $uof.fileCenterV3.add_source(clientId, source); // save source id to $uof.fileCenter                    
                        $telerik.$('.ruFileInput').first().click(); // dialog select file 
                    }

                    function add_source(source) {
                        var clientId = source.get_clientId();    
                        $uof.fileCenterV3.add_source(clientId, source); // save source id to $uof.fileCenter    
                    }

                    function get_uploaded(clientId) {
                        return uploadv3._uploaded[clientId];
                    }

                    function clear_uploaded(clientId) {
                        uploadv3._uploaded[clientId] = [];
                    }

                    function uploadv3_ClientAdded(sender, args) {
                        var upload1 = $find("<%= RadAsyncUpload1.ClientID %>");
                        // if cancel, remove row
                        setTimeout(function() {
                            $(".ruButton").on('click', function() {
                                if ($(this).val() == "Cancel") {
                                    var index = $(".ruButton").index($(this));
                                    $(this).parent().hide(300, function() { upload1.deleteFileInputAt(index); });
                                }
                            });
                        }, 500);
                    }

                    function uploadv3_ClientFileSelected(sender, args) {
                        var upload = $find("<%= RadAsyncUpload1.ClientID %>");
                        var source = $uof.fileCenterV3.get_source(upload["_uofFileCenterClientId"]);
                        var length = 0;
                        $.each(args.get_fileInputField().files, function(i, val) {
                            if (val.name == args.get_fileName()) {
                                length = val.size;
                            }
                        });
                        var act = source.get_isValidLength(length) ? '' : 'cancel';
                        var v3Obj = {
                            "fgid": upload["_uofFileGroupId"], 
                            "cid": upload["_uofFileCenterClientId"],
                            "module": upload["_uofModuleName"], 
                            "sub": upload["_uofSubFolder"],
                            "gid": upload["_uofGroupId"],
                            "act": act 
                        };
                        var $row = $(args.get_row());
                        var inputName = upload.getAdditionalFieldID("v3paras");
                        var inputType = "hidden";
                        var input = create_input(inputType, inputName, encodeURIComponent(JSON.stringify(v3Obj)));
                        $row.append(input); // append fileGroupId to row                    
                        _showFilePanel(); // show upload area                             
                    }

                    function uploadv3_ClientFileUploading(sender, args) {                    
                        var $row = $(args.get_row());                    
                        var v3Obj = JSON.parse(decodeURIComponent($row.find("input[type='hidden']:last-child").val()));
                        if (v3Obj.act == "cancel") {
                            args.set_cancel(true);
                            var $item = $row.find(".ruUploadProgress");
                            $item.addClass("ruUploadFailure");
                            $item.on("click", function() { alert(String.format("This file[{0}] exceeds the maximum allowed size.", args.get_fileName())); });
                            $item.text("ERROR! " + $item.text());
                            return;
                        }
                        // set request params
                        args.set_queryStringParams({ "fgid": v3Obj.fgid, "cid":v3Obj.cid, "module": encodeURIComponent(v3Obj.module), "sub": encodeURIComponent(v3Obj.sub), "gid": v3Obj.gid });
                    }

                    function uploadv3_ClientFileUploaded(sender, args) {
                        var finfo = args.get_fileInfo();
                        var msg = finfo.ErrorMessage;
                        var $row = $(args.get_row());
                        if (msg) {
                            var $item = $row.find(".ruUploadSuccess");
                            $item.removeClass("ruUploadSuccess").addClass("ruUploadFailure");
                            $item.on("click", function() { alert(msg); });
                            $item.text("ERROR! " + $item.text());
                        } else {
                            $row.hide(300).remove();
                            _ajaxCall(JSON.stringify(finfo), "DeleteFromRadTemp");
                            // save temp
                            var files = uploadv3._uploaded[finfo.FileCenterUcClientId];
                            if (files === undefined) {
                                files = [];
                            }
                            files[files.length] = {
                                'FileId': finfo.FileId,
                                'FileName': args.get_fileName(),
                                'Folder': finfo.FolderPath.replace(/\\/g, '!'),
                                'ContentLength': finfo.ContentLength,
                                'ContentType': finfo.ContentType,
                                'DownloadHandler': get_downloadHandler(),
                                'ProxyIndex': get_proxyIndex(),
                                'Ext': finfo.FileNameExtension,
                                'ImageWidth': finfo.ImageWidth,
                                'ImageHeight': finfo.ImageHeight,
                                'GroupUofId': finfo.GroupUofId
                            };
                            uploadv3._uploaded[finfo.FileCenterUcClientId] = files;

                            var source = $uof.fileCenterV3.get_source(finfo.FileCenterUcClientId);                            
                            try {
                                source.add_uploaded(finfo.FileId,
                                                    args.get_fileName(),
                                                    finfo.FolderPath.replace(/\\/g, '!'),
                                                    finfo.ContentLength,
                                                    finfo.ContentType,
                                                    get_downloadHandler(),
                                                    get_proxyIndex(),
                                                    finfo.FileNameExtension,
                                                    finfo.ImageWidth,
                                                    finfo.ImageHeight,
                                                    finfo.GroupUofId);
                            } catch (e) {
                                // not thing to do
                            }
                        }
                    }

                    function uploadv3_ClientFilesUploaded(sender) {
                        if ($telerik.$("input[name='RowRemove']").length == 0) {
                            setTimeout(function() { _hideFilePanel(); }, 500);
                            var source = $uof.fileCenterV3.get_source(sender["_uofFileCenterClientId"]);                            
                            try {
                                source.on_filesUploaded();
                            } catch (e) {
                                // 如果DialogContent裡上傳時的Postback事件裡將FCV3.Visible設為false
                            }
                        } 
                    }

                    function uploadv3_ClientValidationFailed(sender, args) {
                        var $row = $(args.get_row());
                        var message = _getClientValidationErrorMessage(sender, args);
                        var $item = $row.find(".ruUploadProgress");
                        $item.parent().on("click", function() { alert(message); });
                        $item.text("ERROR! " + $item.text());
                    }

                    function uploadv3_ClientFileUploadFailed(sender, args) {
                        args.set_handled(true);
                        var message = args.get_message();
                        var $row = $(args.get_row());
                        var $item = $row.find(".ruUploadFailure");
                        $item.on("click", function() { alert(message); });
                        $item.text("ERROR! " + $item.text());
                    }

                    function uploadv3_ClienFileUploadRemoved(sender, args) {
                        if ($telerik.$("input[name='RowRemove']").length == 0) { // means no files uploading....
                            setTimeout(function() { _hideFilePanel(); }, 50);                            
                        }
                    }

                    function _getClientValidationErrorMessage(sender, args) {
                        var allowedExt = sender.get_allowedFileExtensions().toLowerCase();
                        var name = args.get_fileName();
                        var fileExt = name.substring(name.lastIndexOf('.') + 1, name.length).toLowerCase();
                        if (name.lastIndexOf('.') != -1) {
                            //this checks if the extension is correct
                            if (allowedExt!="" && allowedExt.indexOf(fileExt) == -1) {
                                return ("This file type is not supported. File name: " + name);
                            } else {
                                return ("This file exceeds the maximum allowed size. File name: " + name);
                            }
                        } else {
                            return ("not correct extension. File name: " + name);
                        }
                    }

                    function _showFilePanel() {
                        uploadv3._filePanelOpened = true;
                        var wh = $(window).height();
                        $("#filePanel").animate({ height: uploadv3._filePanelHeight }, { duration: 300, queue: false });
                        $("#contentPanel").animate({ height: (wh - uploadv3._filePanelHeight) }, { duration: 300, queue: false });
                        $("#fileUploadControl").show();
                    }

                    function _hideFilePanel() {
                        uploadv3._filePanelOpened = false;
                        var wh = $(window).height();
                        $("#filePanel").animate({ height: 0 }, { duration: 300, queue: false });
                        $("#contentPanel").animate({ height: (wh) }, { duration: 300, queue: false });
                        $("#fileUploadControl").hide();
                    }

                    function cancel_upload() {
                        $telerik.$("input[name='RowRemove']").click();
                        $find("<%= RadAsyncUpload1.ClientID %>").deleteAllFileInputs();
                        _hideFilePanel();
                    }

                    function create_input(inputType, inputName, value) {
                        var input = '<input type="' + inputType + '" value="' + value + '" name="' + inputName + '" />';
                        return input;
                    }

                    function get_proxyIndex() { return $("#<%=hdnProxyIndex.ClientID%>").val(); }

                    function get_downloadHandler() { return $("#<%=hdnDownloadHandler.ClientID%>").val(); }

                    function resetRadAsyncUpload(args) { __doPostBack('<%=lbtnResetRadAsyncUpload.ID%>', args); }

                    function get_isUploading() {
                        return $find("<%= RadAsyncUpload1.ClientID %>").get_isUploading() || $telerik.$("input[name='RowRemove']").length > 0;
                    }

                    function check_isUploading() {
                        var upload = $find("<%= RadAsyncUpload1.ClientID %>");
                        return upload.get_isUploading();
                    }

                    function get_errorCount() { return $telerik.$('.ruUploadFailure').length; }

                    function _ajaxCall(jsonData, methodName) {
                        $.ajax({
                            type: "POST",
                            url: $(location).attr('pathname') + '/' + methodName,
                            data: jsonData,
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            async: true,
                        }).done(function(result) {
                            //alert(result.d);
                        }).fail(function(jqXhr, textStatus, errorThrown) {
                            try {
                                var response = JSON.parse(jqXhr.responseText);
                                alert(response.Message);
                            } catch (e) {
                                alert(jqXhr.responseText);
                            }
                        });
                    }

                    //]]>
            </script>
        </telerik:RadScriptBlock>

        <telerik:RadScriptBlock runat="server" ID="scriptBlock2">
            <script type="text/javascript">
                    //<![CDATA[            
                    // set custom http handler url
                    Telerik.Web.UI.RadAsyncUpload.prototype._initializeUploadModule = function() {
                        var $T = Telerik.Web.UI;
                        <asp:Literal runat="server" ID="litHandler"></asp:Literal>
                        if ($T.RadAsyncUpload.Modules.FileApi.isAvailable()) {
                            this._uploadModule = new $T.RadAsyncUpload.Modules.FileApi(this);
                        } else {
                            this._uploadModule = new $T.RadAsyncUpload.Modules.IFrame(this, this._pageGUID);
                        }
                    };
                    //]]>
            </script>
        </telerik:RadScriptBlock>

    </form>
</body>

</html>
