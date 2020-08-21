using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lib.TipTop
{
    internal class WKFPO :Ede.Uof.Utility.Data.BasePersistentObject
    {

        /// <summary>
        /// 透過GroupCode反查GroupId
        /// </summary>
        /// <param name="ProgramID"></param>
        /// <returns></returns>
        public string GetGroupIdByGroupCode(string groupCode)
        {
            string cmdTxt = @"SELECT TOP 1 GROUP_ID FROM 
                            TB_EB_GROUP
                            WHERE GROUP_CODE=@GROUP_CODE";

            this.m_db.AddParameter("GROUP_CODE", groupCode);

            object obj = this.m_db.ExecuteScalar(cmdTxt);

            if(obj == null || obj == DBNull.Value)
            {
                return "";
            }
            else
            {
                return obj.ToString();
            }

        }

        public string GetFormVersionID(string ProgramID)
        {
            string cmdTxt = @"SELECT TOP 1 ISNULL( USING_VERSION_ID,'') FROM TB_WKF_FORM
WHERE FORM_NAME  LIKE @ProgramID";
             
            this.m_db.AddParameter("ProgramID" , ProgramID+"%");

            return this.m_db.ExecuteScalar(cmdTxt).ToString();
        }
    }
}
