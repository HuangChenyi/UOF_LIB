using Ede.Uof.Utility.Configuration;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PochenPOC
{
    public class FileSystem
    { 
         public string m_Token;
         public string Token { get{return m_Token; }  }
        public string SiteUrl { get; set; }
        File.FileTarget m_FileTarget = File.FileTarget.EIP;
        public FileSystem(string token)
        {
            Setting setting = new Setting();
            SiteUrl = setting["SiteUrl"];

            m_Token = token;
        }





        /// <summary>
        /// 轉換檔案格式
        /// </summary>
        /// <param name="fileInfo"></param>
        private string ConvertFileSessionToFileGroup(string  formNbr, string sessionId, string fileGroupID)
        {
            File.FileCenter service = new File.FileCenter();
            service.Url = SiteUrl + "/PublicAPI/Utility/FileCenter.asmx";
            service.Timeout = 180 * 1000;//三分鐘逾時
           // string fileGroupID = Guid.NewGuid().ToString();

            service.ConvertFileSessionToFileGroup(m_Token, m_FileTarget, sessionId, formNbr +".png", fileGroupID);
            service.CommitFileGroup(m_Token, fileGroupID);

            return fileGroupID;
        }

        private void WriteFileSession(MemoryStream ms, string sessionId )
        {
            File.FileCenter service = new File.FileCenter();
            service.Url = SiteUrl + "/PublicAPI/Utility/FileCenter.asmx";
            service.Timeout = 180 * 1000;//三分鐘逾時
       //     FileStream fs = new FileStream(fileInfo.FullName, FileMode.Open);

            int index = 0;

            while (ms.Length > index)
            {
                long buffer = 102400;

                if (index + buffer >= ms.Length)
                {
                    buffer = ms.Length - index;
                }

                byte[] bytes = new byte[buffer];

                int i = ms.Read(bytes, 0, Convert.ToInt32(buffer));



                service.WriteFileSession(m_Token, m_FileTarget, sessionId, index, bytes);

                index +=Convert.ToInt32( buffer);
            }


            ms.Close();
        }

        /// <summary>
        /// 新增暫存檔
        /// </summary>
        /// <param name="fileInfo"></param>
        private string CreateTempFile(MemoryStream ms)
        {
            File.FileCenter service = new File.FileCenter();
            service.Url = SiteUrl + "/PublicAPI/Utility/FileCenter.asmx";
            service.Timeout = 180 * 1000;//三分鐘逾時
            return service.AllocFileSession(m_Token, m_FileTarget, Convert.ToInt32(ms.Length));
        }





        internal string UploadFileToUOF(MemoryStream ms, string formNbr)
        {
         //   FileInfo fileInfo = new FileInfo(filePath);
            m_FileTarget =  File.FileTarget.DMS_SOURCE;
            //建立暫存檔
            string sessionId = CreateTempFile(ms);

            //上傳實體檔
            WriteFileSession(ms, sessionId );

            return ConvertFileSessionToFileGroup(formNbr, sessionId, System.Guid.NewGuid().ToString());
        }
    }
}
