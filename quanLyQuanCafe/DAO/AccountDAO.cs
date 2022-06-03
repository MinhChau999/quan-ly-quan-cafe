using quanLyQuanCafe.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Security.Cryptography;
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
        public string MyEncrypt(string s)
        {
            byte[] temp = ASCIIEncoding.ASCII.GetBytes(s);

            byte[] hashData = new MD5CryptoServiceProvider().ComputeHash(temp);
            string hashPass = "";
            foreach (byte item in hashData)
            {
                hashPass += item;
            }

            return hashPass;
        }

        public bool Login(string userName, string password)
        {
            string hassPass = MyEncrypt(password);
            
            string query = "USP_Login @userName , @password";

            DataTable result = DataProvider.Instance.ExecuteQuery(query, new object[] {userName, hassPass});

            return result.Rows.Count > 0;
        }

         
        public DataTable GetListAccount()
        {
            return DataProvider.Instance.ExecuteQuery("select Username, DisplayName, Type from dbo.Account");
        }
        public bool UpdateAcount(string user, string display, string pass, string newpass)
        {
            string hassPass = MyEncrypt(pass);
            string hassNewPass = MyEncrypt(newpass);

            int result = DataProvider.Instance.ExecuteNonQuery("exec USP_UpdateAccount @userName , @displayName , @password , @newPassword", new object[] {user, display, hassPass, hassNewPass});
            return result > 0;
        }

        public Account GetAccoutByUserName(String userNAme)
        {
            DataTable data = DataProvider.Instance.ExecuteQuery("select * from account where username = '" + userNAme +"'");

            foreach (DataRow item in data.Rows)
            {
                return new Account(item);
            }

            return null;
        }

        public bool InsertAccount(string userName, string displayName, int type)
        {
            string hassPass0 = MyEncrypt("0");
            string query = string.Format("insert dbo.Account (UserName, DisplayName, PassWord, Type) values (N'{0}',N'{1}',N'{2}',{3})", userName, displayName, hassPass0, type);
            int data = DataProvider.Instance.ExecuteNonQuery(query);
            return data > 0;
        }
        public bool UpdateAccount(string userName, string displayName, int type)
        {
            string query = string.Format("update dbo.Account set DisplayName = N'{0}', Type = {1} where UserName = N'{2}'", displayName, type, userName);
            int data = DataProvider.Instance.ExecuteNonQuery(query);
            return data > 0;
        }

        public bool DeleteAccount(string userName)
        {
            string query = string.Format("delete dbo.Account where UserName = N'{0}'", userName);
            int data = DataProvider.Instance.ExecuteNonQuery(query);
            return data > 0;
        }

        public bool ResetPassword(string userName)
        {
            string hassPass0 = MyEncrypt("0");
            string query = string.Format("update dbo.Account set Password = N'{0}' where UserName = N'{1}'", hassPass0, userName);
            int data = DataProvider.Instance.ExecuteNonQuery(query);
            return data > 0;
        }
    }
}
