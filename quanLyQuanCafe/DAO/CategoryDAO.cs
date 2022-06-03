using quanLyQuanCafe.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace quanLyQuanCafe.DAO
{
    internal class CategoryDAO
    {
        private static CategoryDAO instance;

        internal static CategoryDAO Instance
        {
            get { if (instance == null) instance = new CategoryDAO(); return instance; }
            set => instance = value;
        }

        private CategoryDAO() { }


        public List<Category> GetListCategory()
        {
            List<Category> list = new List<Category>();

            string query = "select * from FoodCategory";

            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            foreach (DataRow item in data.Rows)
            {
                Category category = new Category(item);
                list.Add(category);
            }


            return list;
        }

        public Category GetCategoryByID(int id)
        {
            Category category = null;

            string query = "select * from FoodCategory where id =" + id;

            DataTable data = DataProvider.Instance.ExecuteQuery(query);

            foreach (DataRow item in data.Rows)
            {
                category = new Category(item);
                return category;
            }
            return category;
        }

        public bool InsertCategory(string name)
        {
            string query = string.Format("insert dbo.FoodCategory (name) values (N'{0}')", name);
            int data = DataProvider.Instance.ExecuteNonQuery(query);
            return data > 0;
        }
        public bool UpdateCategory(int id, string name)
        {
            string query = string.Format("update dbo.FoodCategory set name = N'{0}' where id = {1}", name, id);
            int data = DataProvider.Instance.ExecuteNonQuery(query);
            return data > 0;
        }

        public bool DeleteCategory(int id)
        {
            FoodDAO.Instance.DeleteFoodByCategoryID(id);
            string query = string.Format("delete dbo.FoodCategory where id = {0}", id);
            int data = DataProvider.Instance.ExecuteNonQuery(query);
            return data > 0;
        }
    }
}
