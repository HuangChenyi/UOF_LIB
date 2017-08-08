<%@ Page Title="" Language="C#" MasterPageFile="~/Master/DialogMasterPage.master" AutoEventWireup="true" CodeFile="UploadImg.aspx.cs" Inherits="CDS_WKF_Fields_UI_UploadImg" %>

<%@ Register Src="~/Common/FileCenter/V3/UC_FileCenter.ascx" TagPrefix="uc1" TagName="UC_FileCenter" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <uc1:UC_FileCenter runat="server" ID="UC_FileCenter" ModuleName="CDS" SubFolder="UploadImg"
         AllowedFileType="Image" AllowedMultipleFileSelection="false"  />
</asp:Content>
