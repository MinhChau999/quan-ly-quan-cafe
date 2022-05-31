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
    }
}
