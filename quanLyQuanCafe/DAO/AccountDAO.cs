using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace quanLyQuanCafe.DAO
{
    internal class AccountDAO
    {
        private static AccountDAO instance;

        internal static AccountDAO Instance 
        {
            get { if (instance == null) instance = new AccountDAO(); return instance; } 
            set => instance = value; 
        }

        private AccountDAO() { }

        public bool Login(string userName, string password)
        {
            string query = "USP_Login @userName , @password";

            DataTable result = DataProvider.Instance.ExecuteQuery(query, new object[] {userName, password});

            return result.Rows.Count > 0;
        }
    }
}
