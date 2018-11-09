using Ede.Uof.WKF.Engine;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


namespace Lib.WKF
{
    /// <summary>
    /// 
    /// </summary>
    public class TaskPro
    {
        /// <summary>
        /// 
        /// </summary>
        private Task m_Task = null;
        public Task Task { get { return m_Task; } }


        public TaskPro(string taskId)
        {
            m_Task = new Task(taskId);
            
        }

    }
}
