using quanLyQuanCafe.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace quanLyQuanCafe.DAO
{
    internal class BillInfoDAO
    {
        private static BillInfoDAO instance;
        internal static BillInfoDAO Instance 
        {
            get { if (instance == null) instance = new BillInfoDAO(); return instance; }
            private set => instance = value;
        }

        private BillInfoDAO() { }

        public List<BillInfo> GetListBillInfo(int id)
        {
            List<BillInfo> listBillInfo = new List<BillInfo>();

            DataTable data = DataProvider.Instance.ExecuteQuery("select * from BillInfor where idBill = " + id);

            foreach(DataRow item in data.Rows)
            {
                BillInfo info = new BillInfo(item);
                listBillInfo.Add(info);
            }

            return listBillInfo;
        }
    }
}
