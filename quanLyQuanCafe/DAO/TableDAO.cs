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

    }
}
