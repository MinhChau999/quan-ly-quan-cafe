using quanLyQuanCafe.DAO;
using quanLyQuanCafe.DTO;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace quanLyQuanCafe
{
    public partial class AccountProfile : Form
    {
        private Account loginAcount;
        public Action<string> ChangeInfo;

        internal Account LoginAcount { get => loginAcount; set { loginAcount = value; ChangeAccount(loginAcount); } }
        public AccountProfile(Account acc)
        {
            InitializeComponent();
            this.LoginAcount = acc;
        }

        void ChangeAccount(Account acc)
        {
            txbUserName.Text = LoginAcount.UserName;
            txbDisplayName.Text = LoginAcount.DisplayName;
        }

        void UpdateAccount()
        {
            string displayName = txbDisplayName.Text;
            string password = txbPassWord.Text;
            string newpass = txbNewPassWord.Text;
            string reenterPass = txbReEnterPassWord.Text;
            string userName = txbUserName.Text;

            if (!newpass.Equals(reenterPass))
            {
                MessageBox.Show("Vui lòng nhập lại mất khẩu đúng với mật khẩu mới");
            }
            else
            {
                if (AccountDAO.Instance.UpdateAcount(userName, displayName, password, newpass))
                {
                    MessageBox.Show("Cập nhật thành công");
                    ChangeInfo.Invoke(displayName); //Thực thi delegate, để gọi hàm đã tạo ở form fTableManager
                }
                else
                {
                    MessageBox.Show("Vui lòng điền đúng mật khẩu");
                }
            }
        }



        private void btnExit_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void btnUpdate_Click(object sender, EventArgs e)
        {
            UpdateAccount();
        }
    }
}
