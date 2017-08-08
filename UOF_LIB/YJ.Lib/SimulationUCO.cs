using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace YJ.Lib
{
     public class SimulationUCO
    {

         SimulationPO m_PO = new SimulationPO();

        internal void DeleteSimulationData()
        {
            m_PO.DeleteSimulationData();
        }

        internal System.Data.DataTable GetNonEndForm()
        {
           return m_PO.GetNonEndForm();
        }

        internal void BindSimualationData(Ede.Uof.WKF.Engine.Task task)
        {
            Ede.Uof.WKF.Simulation.SimulationTask sTask = new Ede.Uof.WKF.Simulation.SimulationTask("", task.TaskId, false, task.Applicant.UserGUID, task.CurrentSite.SiteId, 0);

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


              m_PO.InsertSimulationData(fDr);
          }


        }

        public DataTable GetSimulationFormDT(DateTime startTime, DateTime endTime, string userGuid)
        {
            return m_PO.GetSimulationFormDT(startTime,endTime, userGuid); ;
        }
    }
}
