using quanLyQuanCafe.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace quanLyQuanCafe.DAO
{
    internal class BillDAO
    {
        private static BillDAO instance;

        internal static BillDAO Instance {
            get { if (instance == null) instance = new BillDAO(); return instance; }
            private set => instance = value;
        }

        private BillDAO() { }

        /// <summary>
        /// Thành công: bill ID
        /// Thất bại: -1
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int GetUnCheckBillIDByTableID(int id)
        {
            DataTable data = DataProvider.Instance.ExecuteQuery("select * from Bill where idTable = " + id +" and Status = 0");

            if (data.Rows.Count > 0)
            {
                Bill bill = new Bill(data.Rows[0]);
                return (int)bill.ID;
            }
            return -1;
        }
    }
}
