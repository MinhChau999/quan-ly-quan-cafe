using quanLyQuanCafe.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace quanLyQuanCafe.DAO
{
    internal class TableDAO
    {
        private static TableDAO instance;

        internal static TableDAO Instance {
            get { if (instance == null) instance = new TableDAO(); return instance; }
            set => instance = value;
        }

        private TableDAO() { }

        public static int TableWidth = 120;
        public static int TableHeight = 100;

        public List<Table> LoadTableList()
        {
            List<Table> list = new List<Table>();

            DataTable data = DataProvider.Instance.ExecuteQuery("USP_GetTableList");

            foreach (DataRow row in data.Rows)
            {
                Table table = new Table(row);
                list.Add(table);
            }

            return list;
        }

        public void SwitchTable(int id1, int id2)
        {
            DataProvider.Instance.ExecuteQuery("USP_SwitchTabel @idTable1 , @idTabel2", new object[] { id1, id2 });
        }
        public bool InsertTable(string name)
        {
            string query = string.Format("insert dbo.TableFood (name) values (N'{0}')", name);
            int data = DataProvider.Instance.ExecuteNonQuery(query);
            return data > 0;
        }
        public bool UpdateTable(int id, string name)
        {
            string query = string.Format("update dbo.TableFood set name = N'{0}' where id = {1}", name, id);
            int data = DataProvider.Instance.ExecuteNonQuery(query);
            return data > 0;
        }

        public bool DeleteTable(int id)
        {
            BillDAO.Instance.DeleteBillByTableID(id);
            string query = string.Format("delete dbo.TableFood where id = {0}", id);
            int data = DataProvider.Instance.ExecuteNonQuery(query);
            return data > 0;
        }
    }
}
