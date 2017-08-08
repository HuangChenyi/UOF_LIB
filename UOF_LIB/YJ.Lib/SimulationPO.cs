using Ede.Uof.Utility.Log;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace YJ.Lib
{
    internal class SimulationPO :Ede.Uof.Utility.Data.BasePersistentObject
    {


        public DataTable GetNonEndForm()
        {
            string cmdTxt = @"SELECT TASK_ID FROM TB_WKF_TASK WHERE END_TIME IS  NULL";

            DataTable dt = new DataTable();
            dt.Load(this.m_db.ExecuteReader(cmdTxt), LoadOption.OverwriteChanges);

            return dt;

        }

        public void DeleteSimulationData()
        {
            string cmdTxt = @"DELETE TB_YJ_SIMULATION_FLOW";
            this.m_db.ExecuteNonQuery(cmdTxt);
            //TB_YJ_SIMULATION_FLOW
        }

        public void InsertSimulationData(DataRow dr)
        {
            string cmdTxt = @"  INSERT INTO [dbo].[TB_YJ_SIMULATION_FLOW]  
(	 [TASK_ID] , 
	 [USER_GUID] , 
	 [BEGIN_TIME] , 
	 [FORM_ID] , 
	 [FORM_VERSION_ID] , 
	 [FORM_NBR]  
) 
 VALUES 
 (	 @TASK_ID , 
	 @USER_GUID , 
	 @BEGIN_TIME , 
	 @FORM_ID , 
	 @FORM_VERSION_ID , 
	 @FORM_NBR  
)";

            this.m_db.AddParameter("@TASK_ID", dr["TASK_ID"]);
            this.m_db.AddParameter("@USER_GUID", dr["USER_GUID"]);
            this.m_db.AddParameter("@BEGIN_TIME",  Convert.ToDateTime( dr["BEGIN_TIME"]));
            this.m_db.AddParameter("@FORM_ID", dr["FORM_ID"]);
            this.m_db.AddParameter("@FORM_VERSION_ID", dr["FORM_VERSION_ID"]);
            this.m_db.AddParameter("@FORM_NBR", dr["FORM_NBR"]);
          //  Logger.WriteError(dr["BEGIN_TIME"].ToString());
            this.m_db.ExecuteNonQuery(cmdTxt);

        }

        internal DataTable GetSimulationFormDT(DateTime startTime, DateTime endTime, string userGuid)
        {
            string cmdTxt = @"
SELECT [TB_YJ_SIMULATION_FLOW].[TASK_ID]
      ,[TB_YJ_SIMULATION_FLOW].[USER_GUID]
      ,[TB_YJ_SIMULATION_FLOW].[BEGIN_TIME]
      ,TB_WKF_FORM.[FORM_ID]
      ,TB_YJ_SIMULATION_FLOW.[FORM_VERSION_ID]
      ,[TB_YJ_SIMULATION_FLOW].FORM_NBR,
      FORM_NAME , 
      TB_EB_USER.NAME AS APPLICANT_NAME
  FROM [dbo].[TB_YJ_SIMULATION_FLOW]
  INNER JOIN TB_WKF_FORM ON [TB_YJ_SIMULATION_FLOW].FORM_ID = TB_WKF_FORM.FORM_ID
  INNER JOIN TB_WKF_TASK ON TB_WKF_TASK.TASK_ID = [TB_YJ_SIMULATION_FLOW].TASK_ID
  INNER JOIN TB_EB_USER ON TB_EB_USER.USER_GUID = TB_WKF_TASK.USER_GUID
  WHERE [TB_YJ_SIMULATION_FLOW].[USER_GUID]= @USER_GUID
  AND [TB_YJ_SIMULATION_FLOW].BEGIN_TIME >= @startTime
  AND[TB_YJ_SIMULATION_FLOW].BEGIN_TIME < @endTime";

            this.m_db.AddParameter("USER_GUID", userGuid);
            this.m_db.AddParameter("startTime", startTime);
            this.m_db.AddParameter("endTime", endTime.AddDays(1));

            DataTable dt = new DataTable();
            dt.Load(this.m_db.ExecuteReader(cmdTxt));

            return dt;
        }
    }
}
