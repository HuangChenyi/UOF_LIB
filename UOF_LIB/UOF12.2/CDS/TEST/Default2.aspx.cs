using Ede.Uof.Utility.Page;
using Ede.Uof.WKF.Engine;
using Ede.Uof.WKF.Simulation;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class CDS_TEST_Default2 : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {

        PO po = new PO();
        po.DeleteSimulationData();
        DataTable taskDt = po.GetNonEndForm();

        foreach (DataRow dr in taskDt.Rows)
        {
            Task task = new Task(dr["TASK_ID"].ToString());

            if (task.TaskStatus == ActiveStatus.Exceptional)
            {
                continue;
            }
            else
            {
                BindSimualationGrid(task);

            }




        }
    }

    private void BindSimualationGrid(Task task)
    {
        SimulationTask sTask = new SimulationTask("", task.TaskId, false, task.Applicant.UserGUID, task.CurrentSite.SiteId, 0);

        DataTable dt = sTask.GetFlowSimulationDt();
        

        DataTable fDt = new DataTable();
        fDt.Columns.Add("TASK_ID");
         fDt.Columns.Add("USER_GUID");
         fDt.Columns.Add("BEGIN_TIME");
         fDt.Columns.Add("FORM_ID");
         fDt.Columns.Add("FORM_VERSION_ID");
          fDt.Columns.Add("FORM_NBR");

          foreach (DataRow dr in dt.Rows)
          {
              DataRow fDr = fDt.NewRow();
              fDr["TASK_ID"] = task.TaskId;
              fDr["USER_GUID"] = dr["ORIGINAL_SIGNER_GUID"];
              fDr["BEGIN_TIME"] = task.BeginTime.Value;
              fDr["FORM_ID"] = task.FormId;
              fDr["FORM_VERSION_ID"] = task.FormVersionId;
              fDr["FORM_NBR"] = task.FormNumber;

              PO po = new PO();
              po.InsertSimulationData(fDr);
          }


    }
}


class PO : Ede.Uof.Utility.Data.BasePersistentObject
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
        this.m_db.AddParameter("@BEGIN_TIME", dr["BEGIN_TIME"]);
        this.m_db.AddParameter("@FORM_ID", dr["FORM_ID"]);
        this.m_db.AddParameter("@FORM_VERSION_ID", dr["FORM_VERSION_ID"]);
        this.m_db.AddParameter("@FORM_NBR", dr["FORM_NBR"]);

        this.m_db.ExecuteNonQuery(cmdTxt);

    }
}