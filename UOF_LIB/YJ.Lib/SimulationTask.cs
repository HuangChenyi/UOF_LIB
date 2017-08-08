using Ede.Uof.WKF.Engine;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;


namespace YJ.Lib
{
    public class SimulationTask : Ede.Uof.Utility.Task.BaseTask
    {
        public override void Run(params string[] args)
        {
            //throw new NotImplementedException();

            SimulationUCO uco = new SimulationUCO();
            uco.DeleteSimulationData();
            DataTable taskDt = uco.GetNonEndForm();

            foreach (DataRow dr in taskDt.Rows)
            {
                Task task = new Task(dr["TASK_ID"].ToString());

                if (task.TaskStatus == ActiveStatus.Exceptional)
                {
                    continue;
                }
                else
                {
                    uco.BindSimualationData(task);

                }




            }

        }
    }
}
