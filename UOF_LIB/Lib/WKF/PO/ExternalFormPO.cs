using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lib.WKF.PO
{
    internal class ExternalFormPO : Ede.Uof.Utility.Data.BasePersistentObject
    {
        internal DataTable QueryExernalForms()
        {
            string cmdTxt = @" SELECT 
	 [FORM_VERSION_ID] , 
	 [EXTERNAL_TABLE_NAME] , 
	 [EXTERNAL_GRID_TABLES_NAME]  
 FROM [dbo].[TB_CDS_EXTERNAL_FORM_MAPPING] ";

            DataTable dt = new DataTable();
            dt.Load(this.m_db.ExecuteReader(cmdTxt), LoadOption.OverwriteChanges);
            return dt;


        }

        internal DataTable QueryAllApplyForms(string tableName)
        {
            //格式不定，只能用*
            string cmdTxt = @" SELECT 
       *
 FROM [dbo].[{0}] 
WHERE STATUS IS NULL
AND ENABLED = 1 ";

            cmdTxt = string.Format(cmdTxt, tableName);

            DataTable dt = new DataTable();
            dt.Load(this.m_db.ExecuteReader(cmdTxt), LoadOption.OverwriteChanges);
            return dt;
        }

        /// <summary>
        /// 找明細資料
        /// </summary>
        /// <param name="tableName"></param>
        /// <param name="externalTaskId"></param>
        /// <returns></returns>
        internal DataTable QueryDataGridFieldData(string tableName, string externalTaskId)
        {
            //格式不定，只能用*
            string cmdTxt = @" SELECT 
       *
 FROM [dbo].[{0}] 
WHERE  EXTERNAL_TASK_ID=@EXTERNAL_TASK_ID 
ORDER BY GRID_SEQ";

            cmdTxt = string.Format(cmdTxt, tableName);

            DataTable dt = new DataTable();
            this.m_db.AddParameter("EXTERNAL_TASK_ID", externalTaskId);
            dt.Load(this.m_db.ExecuteReader(cmdTxt), LoadOption.OverwriteChanges);
            return dt;
        }


        internal string QueryVersionFields(string formVersionId)
        {
            string cmdTxt = @"SELECT VERSION_FIELD FROM TB_WKF_FORM_VERSION
                            WHERE FORM_VERSION_ID = @FORM_VERSION_ID";

            this.m_db.AddParameter("FORM_VERSION_ID", formVersionId);

            object obj = this.m_db.ExecuteScalar(cmdTxt);

            return obj.ToString();

        }

        internal void UpdateFormStatus(string externalTaskId, string tableName, string status, string taskId, string formNbr, string exception)
        {
            string cmdTxt = string.Format(@"  UPDATE [dbo].[{0}]  
 SET 
	 [EXCEPTION_MSG] = @EXCEPTION_MSG , 
	 [FORM_NUMBER] = @FORM_NUMBER , 
	 [TASK_ID] = @TASK_ID , 
	 [STATUS] = @STATUS , 
	 [MODIFY_TIME] = @MODIFY_TIME  

WHERE 
	[EXTERNAL_TASK_ID] = @EXTERNAL_TASK_ID", tableName);

            this.m_db.AddParameter("@EXCEPTION_MSG", exception);
            this.m_db.AddParameter("@FORM_NUMBER", formNbr);
            this.m_db.AddParameter("@TASK_ID", taskId);
            this.m_db.AddParameter("@STATUS", status);
            this.m_db.AddParameter("@MODIFY_TIME", DateTime.Now);
            this.m_db.AddParameter("@EXTERNAL_TASK_ID", externalTaskId);

            this.m_db.ExecuteNonQuery(cmdTxt);

        }
    }
}
