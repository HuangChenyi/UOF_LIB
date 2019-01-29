using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lib.TipTop
{
    internal class WKFPO :Ede.Uof.Utility.Data.BasePersistentObject
    {
        public string GetFormVersionID(string ProgramID)
        {
            string cmdTxt = @"SELECT TOP 1 ISNULL( USING_VERSION_ID,'') FROM TB_WKF_FORM
WHERE FORM_NAME  LIKE @ProgramID";
             
            this.m_db.AddParameter("ProgramID" , ProgramID+"%");

            return this.m_db.ExecuteScalar(cmdTxt).ToString();
        }
    }
}
