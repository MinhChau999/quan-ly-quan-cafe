create database QuanLyQuanCafe
go

use QuanLyQuanCafe
go

-- Food
-- Table
-- FoodCategory
-- Account
-- Bill
-- BillInfor

create  table TableFood
(
	id int identity primary  key,
	name nvarchar(100) not null default N'Chưa đặt tên',
	status nvarchar(100) not null default N'Trống' -- Trống || Có người
)
go


create  table Account
(
	Username nvarchar(100) primary key,
	DisplayName nvarchar(100) not null default N'Kter',
	Password nvarchar(250) not null,
	Type int default 0 --1:admin && 0:staff
)
go

create table FoodCategory
(
	id int identity primary  key,
	name nvarchar(100) not null default N'Chưa đặt tên',
)
go

create table Food
(
	id int identity primary  key,
	name nvarchar(100) not null default N'Chưa đặt tên',
	IdCategory int not null,
	price  float not null default 0,

	foreign key (IdCategory) references FoodCategory(id)

)

go

create table Bill
(
	id int identity primary  key,
	DateCheckIn date not null,
	DateCheckOut date,
	idTable int not null,
	Status int not null, --1:đã thanh toán, 0 chưa thanh toán
	foreign key (idTable) references TableFood(id)
)
go

create table  BillInfor
(
	id int identity primary  key,
	idBill int not null,
	idFood int not null,
	count int not null default 0

	foreign key (idBill) references Bill(id),
	foreign key (idFood) references Food(id)
)
go

INSERT INTO dbo.Account
        ( UserName ,
          DisplayName ,
          PassWord ,
          Type
        )
VALUES  ( N'K9' , -- UserName - nvarchar(100)
          N'RongK9' , -- DisplayName - nvarchar(100)
          N'1' , -- PassWord - nvarchar(1000)
          1  -- Type - int
        )
INSERT INTO dbo.Account
        ( UserName ,
          DisplayName ,
          PassWord ,
          Type
        )
VALUES  ( N'staff' , -- UserName - nvarchar(100)
          N'staff' , -- DisplayName - nvarchar(100)
          N'1' , -- PassWord - nvarchar(1000)
          0  -- Type - int
        )
GO

create PROC USP_GetAccountByUserName
AS 
BEGIN
	SELECT * FROM dbo.Account
END
GO

select * from Account where Username = N'K9' and Password = N'1'
go

create proc USP_Login
@userName nvarchar(100), @password nvarchar(100)
as
begin
	select Username from dbo.Account where Username = @userName and Password = @password
end
go

DECLARE @i INT = 1

WHILE @i <= 20
BEGIN
	INSERT dbo.TableFood ( name)VALUES  ( N'Bàn ' + CAST(@i AS nvarchar(100)))
	SET @i = @i + 1
END
go

create proc USP_GetTableList
as select * from TableFood
go

update dbo.TableFood set status =N'Có nngười' where id=9
go

-- thêm category
INSERT dbo.FoodCategory
        ( name )
VALUES  ( N'Hải sản'  -- name - nvarchar(100)
          )
INSERT dbo.FoodCategory
        ( name )
VALUES  ( N'Nông sản' )
INSERT dbo.FoodCategory
        ( name )
VALUES  ( N'Lâm sản' )
INSERT dbo.FoodCategory
        ( name )
VALUES  ( N'Sản sản' )
INSERT dbo.FoodCategory
        ( name )
VALUES  ( N'Nước' )

-- thêm món ăn
INSERT dbo.Food
        ( name, idCategory, price )
VALUES  ( N'Mực một nắng nước sa tế', -- name - nvarchar(100)
          1, -- idCategory - int
          120000)
INSERT dbo.Food
        ( name, idCategory, price )
VALUES  ( N'Nghêu hấp xả', 1, 50000)
INSERT dbo.Food
        ( name, idCategory, price )
VALUES  ( N'Dú dê nướng sữa', 2, 60000)
INSERT dbo.Food
        ( name, idCategory, price )
VALUES  ( N'Heo rừng nướng muối ớt', 3, 75000)
INSERT dbo.Food
        ( name, idCategory, price )
VALUES  ( N'Cơm chiên mushi', 4, 999999)
INSERT dbo.Food
        ( name, idCategory, price )
VALUES  ( N'7Up', 5, 15000)
INSERT dbo.Food
        ( name, idCategory, price )
VALUES  ( N'Cafe', 5, 12000)

-- thêm bill
INSERT	dbo.Bill
        ( DateCheckIn ,
          DateCheckOut ,
          idTable ,
          status
        )
VALUES  ( GETDATE() , -- DateCheckIn - date
          NULL , -- DateCheckOut - date
          3 , -- idTable - int
          0  -- status - int
        )
        
INSERT	dbo.Bill
        ( DateCheckIn ,
          DateCheckOut ,
          idTable ,
          status
        )
VALUES  ( GETDATE() , -- DateCheckIn - date
          NULL , -- DateCheckOut - date
          4, -- idTable - int
          0  -- status - int
        )
INSERT	dbo.Bill
        ( DateCheckIn ,
          DateCheckOut ,
          idTable ,
          status
        )
VALUES  ( GETDATE() , -- DateCheckIn - date
          GETDATE() , -- DateCheckOut - date
          5 , -- idTable - int
          1  -- status - int
        )

-- thêm bill info
INSERT	dbo.BillInfor
        ( idBill, idFood, count )
VALUES  ( 1, -- idBill - int
          1, -- idFood - int
          2  -- count - int
          )
INSERT	dbo.BillInfor
        ( idBill, idFood, count )
VALUES  ( 1, -- idBill - int
          3, -- idFood - int
          4  -- count - int
          )
INSERT	dbo.BillInfor
        ( idBill, idFood, count )
VALUES  ( 1, -- idBill - int
          5, -- idFood - int
          1  -- count - int
          )
INSERT	dbo.BillInfor
        ( idBill, idFood, count )
VALUES  ( 2, -- idBill - int
          1, -- idFood - int
          2  -- count - int
          )
INSERT	dbo.BillInfor
        ( idBill, idFood, count )
VALUES  ( 2, -- idBill - int
          6, -- idFood - int
          2  -- count - int
          )
INSERT	dbo.BillInfor
        ( idBill, idFood, count )
VALUES  ( 3, -- idBill - int
          5, -- idFood - int
          2  -- count - int
          )         
          
GO

select * from dbo.BillInfor
select * from dbo.Bill
GO

select * from Bill where idTable = 3 and Status = 0

select * from BillInfor where idBill = 2
GO

select f.name, bi.count,f.price, f.price*bi.count as totalPrice from BillInfor as bi
join Bill as b on bi.idBill = b.id
join Food as f on bi.idFood = f.id
where b.idTable = 3 and b.Status = 0