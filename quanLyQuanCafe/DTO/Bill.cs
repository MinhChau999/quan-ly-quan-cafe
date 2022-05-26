using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace quanLyQuanCafe.DTO
{
    internal class Bill
    {
        private int iD;

        private DateTime? dateCheckIn;

        private DateTime? dateCheckOut;

        private int status;

        public Bill(int id, DateTime? datecheckin, DateTime? datecheckout,int status)
        {
            this.iD = id;
            this.dateCheckIn = datecheckin;
            this.dateCheckOut = datecheckout;
            this.status = status;
        }

        public Bill(DataRow row)
        {
            this.ID = (int)row["id"];
            this.DateCheckIn = (DateTime?)row["dateCheckIn"];

            var dateCheckOutTemp = row["dateCheckOut"];
            if (dateCheckOutTemp.ToString() != "")
                this.DateCheckOut = (DateTime?)row["dateCheckOut"];
            this.Status = (int)row["status"];
        }

        public int ID { get => iD; set => iD = value; }
        public DateTime? DateCheckIn { get => dateCheckIn; set => dateCheckIn = value; }
        public DateTime? DateCheckOut { get => dateCheckOut; set => dateCheckOut = value; }
        public int Status { get => status; set => status = value; }
    }
}
