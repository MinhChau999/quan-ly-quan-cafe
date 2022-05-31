using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace quanLyQuanCafe.DTO
{
    internal class Food
    {
        private int iD;
        private string name;
        private int idCategory;
        private float price;

        public Food(int id, string name, int idcategory, float price)
        {
            this.ID = id;
            this.Name = name;
            this.IdCategory = idcategory;
            this.Price = price;
        }

        public Food(DataRow row)
        {
            this.ID = (int)row["ID"];
            this.Name = row["Name"].ToString();
            this.IdCategory = (int)row["IDCategory"];
            this.Price = (float)Convert.ToDouble(row["price"].ToString());
        }

        public int ID { get => iD; set => iD = value; }
        public string Name { get => name; set => name = value; }
        public int IdCategory { get => idCategory; set => idCategory = value; }
        public float Price { get => price; set => price = value; }
    }
}
