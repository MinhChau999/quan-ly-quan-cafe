using quanLyQuanCafe.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace quanLyQuanCafe.DAO
{
    internal class FoodDAO
    {
        private static FoodDAO instance;

        internal static FoodDAO Instance
        {
            get { if (instance == null) instance = new FoodDAO(); return instance; }
            set => instance = value;
        }

        private FoodDAO() { }

        public List<Food> GetFoodListByCategoryID(int id)
        {
            List<Food> list = new List<Food>();

            string query = "select * from Food where IdCategory =" + id;

            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            foreach (DataRow item in data.Rows)
            {
                Food food = new Food(item);
                list.Add(food);
            }

            return list;
        }
        public List<Food> SearchListFoodByName(string name)
        {
            List<Food> list = new List<Food>();

            string query = string.Format("select * from dbo.Food where dbo.fuConvertToUnsign1(name) like N'%' + dbo.fuConvertToUnsign1(N'{0}') + '%'", name);

            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            foreach (DataRow item in data.Rows)
            {
                Food food = new Food(item);
                list.Add(food);
            }

            return list;
        }

        public DataTable GetListFood()
        {
            //List<Food> list = new List<Food>();

            string query = "select * from Food";

            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            //foreach (DataRow item in data.Rows)
            //{
            //    Food food = new Food(item);
            //    list.Add(food);
            //}

            return data;
        }

        public bool InsertFood(string name, int idCategory, float price)
        {
            string query = string.Format("insert dbo.Food (name, IdCategory, price) values (N'{0}',{1},{2})",name,idCategory,price);
            int data = DataProvider.Instance.ExecuteNonQuery(query);
            return data > 0;
        }
        public bool UpdateFood(int id, string name, int idCategory, float price)
        {
            string query = string.Format("update dbo.Food set name = N'{0}', IdCategory = {1}, price = {2} where id = {3}", name, idCategory, price, id);
            int data = DataProvider.Instance.ExecuteNonQuery(query);
            return data > 0;
        }

        public bool DeleteFood(int id)
        {
            BillInfoDAO.Instance.DeleteBillInfoByFoodID(id);
            string query = string.Format("delete dbo.Food where id = {0}", id);
            int data = DataProvider.Instance.ExecuteNonQuery(query);
            return data > 0;
        }

        public bool DeleteFoodByCategoryID(int CategoryID)
        {
            BillInfoDAO.Instance.DeleteBillInfoByCategoryID(CategoryID);
            string query = string.Format("delete dbo.Food where IdCategory = {0}", CategoryID);
            int data = DataProvider.Instance.ExecuteNonQuery(query);
            return data > 0;
        }
    }
}