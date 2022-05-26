using quanLyQuanCafe.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace quanLyQuanCafe.DAO
{
    internal class MenuDAO
    {
        private static MenuDAO instance;
        internal static MenuDAO Instance {
            get { if (instance == null) instance = new MenuDAO(); return instance; }
            private set => instance = value;
        }

        private MenuDAO() { }

        public List<Menu> getListMenuTable(int id)
        {
            List<Menu> list = new List<Menu>();

            string query = "select f.name, bi.count,f.price, f.price*bi.count as totalPrice from BillInfor as bi join Bill as b on bi.idBill = b.id join Food as f on bi.idFood = f.id where b.Status = 0 and b.idTable =" + id;

            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            foreach (DataRow item in data.Rows)
            {
                Menu menu = new Menu(item);
                list.Add(menu);
            }

            return list;

        }
    }
}
