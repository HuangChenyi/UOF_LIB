<%@ WebHandler Language="C#" Class="ResizePhoto" %>

using System;
using System.Web;
using Ede.Uof.EIP.Album.Data;
using Ede.Uof.EIP.Album;
using System.Drawing;
using System.Drawing.Drawing2D;
using Ede.Uof.Utility.Configuration;

public class ResizePhoto : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        string photoId = context.Request.QueryString["photoId"];
        string fileId = context.Request.QueryString["fileId"];
        string url = context.Request.QueryString["url"];
        MakeAlbumImages(url, 800, 600, photoId, fileId);
    }

    public void MakeAlbumImages(string url, int maxWidth, int maxHeight, string photoId, string fileId)
    {
        Setting setting = new Setting();
        AlbumDataSet albumDS = new AlbumDataSet();
        AlbumUCO albumUCO = new AlbumUCO();
        string resizeUrl = "{0}/Common/FileCenter/Downloadfile.ashx?id={1}&amp;type=image";
        
        //縮圖回存
        albumDS = albumUCO.QueryAlbumPhoto(photoId);
        if (albumDS.TB_EIP_ALBUM_PHOTO.Rows.Count > 0)
        {
            AlbumDataSet.TB_EIP_ALBUM_PHOTORow dr = (AlbumDataSet.TB_EIP_ALBUM_PHOTORow)albumDS.TB_EIP_ALBUM_PHOTO.Rows[0];
            if(dr.IsRESIZE_FILE_IDNull() || dr.RESIZE_FILE_ID =="")
            {
                albumUCO.UpdateAlbumMidPhoto(albumDS.TB_EIP_ALBUM_PHOTO.Rows[0]);
            } 
        }

        //取出縮圖
        albumDS.Clear();
        albumDS = albumUCO.QueryAlbumPhoto(photoId);
        if (albumDS.TB_EIP_ALBUM_PHOTO.Rows.Count > 0)
        {
            url = string.Format(resizeUrl, setting["SiteUrl"], Convert.ToString(albumDS.TB_EIP_ALBUM_PHOTO.Rows[0]["RESIZE_FILE_ID"]));
        }
        
        
        //從指定URL取得圖片資源轉為Stream
        System.Drawing.Image originalImage = System.Drawing.Image.FromStream(new System.IO.MemoryStream(new System.Net.WebClient().DownloadData(url)));
        using (Graphics thumbGraphic = Graphics.FromImage(originalImage))
        {
            thumbGraphic.CompositingQuality = CompositingQuality.HighQuality;
            thumbGraphic.SmoothingMode = SmoothingMode.HighQuality;
            thumbGraphic.InterpolationMode = InterpolationMode.HighQualityBicubic;
            Rectangle thumbRectangle = new Rectangle(0, 0, originalImage.Width, originalImage.Height);
            thumbGraphic.DrawImage(originalImage, thumbRectangle);

            System.IO.MemoryStream ms = new System.IO.MemoryStream();
            originalImage.Save(ms, System.Drawing.Imaging.ImageFormat.Jpeg);
            HttpContext.Current.Response.Clear();
            HttpContext.Current.Response.ContentType = "image/Jpeg";
            HttpContext.Current.Response.BinaryWrite(ms.ToArray());

        }
    }


    public bool IsReusable {
        get {
            return false;
        }
    }

}
