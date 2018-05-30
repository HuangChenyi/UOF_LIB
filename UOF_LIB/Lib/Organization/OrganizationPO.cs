using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lib.Organization
{
    internal class OrganizationPO :Ede.Uof.Utility.Data.BasePersistentObject
    {
        internal string GetJobTitleId(string titleName)
        {
            string cmdTxt = @"SELECT TITLE_ID FROM TB_EB_JOB_TITLE
                            WHERE TITLE_NAME = @TITLE_NAME";

            this.m_db.AddParameter("TITLE_NAME", titleName);

            object obj = this.m_db.ExecuteScalar(cmdTxt);

            if(obj == null || obj == DBNull.Value)
            {
                return "";
            }

            return obj.ToString();

        }

    }
}
