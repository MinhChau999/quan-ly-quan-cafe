using quanLyQuanCafe.DAO;

namespace quanLyQuanCafe
{
    public partial class Login : Form
    {
        public Login()
        {
            InitializeComponent();
        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBox2_TextChanged(object sender, EventArgs e)
        {

        }


        private void Login_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (MessageBox.Show("Bạn có thật sự muốn thoát chương trình?","Thông báo",MessageBoxButtons.OKCancel) != DialogResult.OK)
            {
                e.Cancel = true;
            }
        }

        private void btnLogin_Click(object sender, EventArgs e)
        {
            string userName = txbUserName.Text;
            string password = txbPassword.Text;
            if (login(userName, password))
            {
                TableManager f = new TableManager();
                this.Hide();
                f.ShowDialog();
                this.Show();
            } else
            {
                MessageBox.Show("Sai tên tài khoản hoặc mật khẩu");
            }
            
        }

        private static bool login(string userName, string password)
        {
            return AccountDAO.Instance.Login(userName, password);
        }
        private void btnExit_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }
    }
}