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
	Password nvarchar(250) not null default N'20720532132149213101239102231223249249135100218',
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
	Status int not null default 0, --1:đã thanh toán, 0 chưa thanh toán
	discount int default 0,
	totalPrice float default 0,
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
          N'1962026656160185351301320480154111117132155' , -- PassWord - nvarchar(1000)
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
          N'1962026656160185351301320480154111117132155' , -- PassWord - nvarchar(1000)
          0  -- Type - int
        )
GO

create PROC USP_GetAccountByUserName
AS 
BEGIN
	SELECT * FROM dbo.Account
END
GO

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
go



create proc USP_InsertBill  
@idTable int
as
begin
	INSERT	dbo.Bill
        ( DateCheckIn ,
          DateCheckOut ,
          idTable ,
          status,
		  discount
        )
	VALUES  
		( 
		  GETDATE() , -- DateCheckIn - date
          null , -- DateCheckOut - date
          @idTable , -- idTable - int
          0,  -- status - int
		  0
        )
end
go

create proc USP_InsertBillInfo
@idBill int, @idFood int, @count int
as
begin
	declare @isExitsBillInfo int
	declare @foodCount int = 1

	select @isExitsBillInfo= id, @foodCount=b.count from BillInfor as b where idBill = @idBill and idFood = @idFood

	if (@isExitsBillInfo > 0)
	begin
		declare @newCount int = @foodCount + @count
		if (@newCount > 0)
			update BillInfor set count = @foodCount + @count where idFood = @idFood
		else
			delete BillInfor where idBill = @idBill and idFood = @idFood
	end
	else
	begin
		INSERT	dbo.BillInfor
			( idBill, idFood, count )
		VALUES  ( @idBill, -- idBill - int
          @idFood, -- idFood - int
          @count  -- count - int
          )
	end

end
go


create TRIGGER UTG_UpdateBillInfo
ON dbo.BillInfor FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @idBill INT
	
	SELECT @idBill = idBill FROM Inserted
	
	DECLARE @idTable INT
	
	SELECT @idTable = idTable FROM dbo.Bill WHERE id = @idBill AND status = 0	
	
	DECLARE @count INT
	SELECT @count = COUNT(*) FROM dbo.BillInfor WHERE idBill = @idBill
	
	IF (@count > 0)
	BEGIN
	
		PRINT @idTable
		PRINT @idBill
		PRINT @count
		
		UPDATE dbo.TableFood SET status = N'Có người' WHERE id = @idTable		
		
	END		
	ELSE
	BEGIN
	PRINT @idTable
		PRINT @idBill
		PRINT @count
	UPDATE dbo.TableFood SET status = N'Trống' WHERE id = @idTable	
	end
	
END
GO

create trigger UTG_UpdateBill
on dbo.Bill for update
as
begin
	declare @idBill int
	
	select @idBill = id from inserted

	declare @idTable int

	select @idTable = idTable from dbo.Bill where id = @idBill

	declare @count int = 0

	select @count=count(*) from dbo.Bill where idTable = @idBill and status = 0

	if(@count = 0)
	begin
		Update dbo.TableFood set Status = N'Trống' where id = @idTable 
	end
end
go


create PROC USP_SwitchTabel
@idTable1 INT, @idTable2 int
AS BEGIN

	DECLARE @idFirstBill int
	DECLARE @idSeconrdBill INT
	
	DECLARE @isFirstTablEmty INT = 1
	DECLARE @isSecondTablEmty INT = 1
	
	
	SELECT @idSeconrdBill = id FROM dbo.Bill WHERE idTable = @idTable2 AND status = 0
	SELECT @idFirstBill = id FROM dbo.Bill WHERE idTable = @idTable1 AND status = 0
	
	IF (@idFirstBill IS NULL)
	BEGIN
		INSERT dbo.Bill
		        ( DateCheckIn ,
		          DateCheckOut ,
		          idTable ,
		          status,
				  discount
		        )
		VALUES  ( GETDATE() , -- DateCheckIn - date
		          NULL , -- DateCheckOut - date
		          @idTable1 , -- idTable - int
		          0,  -- status - int
				  0
		        )
		        
		SELECT @idFirstBill = MAX(id) FROM dbo.Bill WHERE idTable = @idTable1 AND status = 0
		
	END
	
	SELECT @isFirstTablEmty = COUNT(*) FROM dbo.BillInfor WHERE idBill = @idFirstBill
	

	IF (@idSeconrdBill IS NULL)
	BEGIN
		INSERT dbo.Bill
		        ( DateCheckIn ,
		          DateCheckOut ,
		          idTable ,
		          status,
				  discount
		        )
		VALUES  ( GETDATE() , -- DateCheckIn - date
		          NULL , -- DateCheckOut - date
		          @idTable2 , -- idTable - int
		          0,
				  0-- status - int
		        )
		SELECT @idSeconrdBill = MAX(id) FROM dbo.Bill WHERE idTable = @idTable2 AND status = 0
		
	END
	
	SELECT @isSecondTablEmty = COUNT(*) FROM dbo.BillInfor WHERE idBill = @idSeconrdBill


	SELECT id INTO IDBillInfoTable FROM dbo.BillInfor WHERE idBill = @idSeconrdBill
	
	UPDATE dbo.BillInfor SET idBill = @idSeconrdBill WHERE idBill = @idFirstBill
	
	UPDATE dbo.BillInfor SET idBill = @idFirstBill WHERE id IN (SELECT * FROM IDBillInfoTable)
	
	DROP TABLE IDBillInfoTable
	
	IF (@isFirstTablEmty = 0)
		UPDATE dbo.TableFood SET status = N'Trống' WHERE id = @idTable2
		
	IF (@isSecondTablEmty= 0)
		UPDATE dbo.TableFood SET status = N'Trống' WHERE id = @idTable1
END
GO  

create proc USP_GetListBillByDate
@checkIn date, @checkOut date
as
begin
	select t.name as [Tên bàn], b.DateCheckIn as [Ngày vào], b.DateCheckIn as [Ngày ra], b.discount as [Giảm giá],b.totalPrice as [Tổng tiền] from Bill as b
	join dbo.TableFood as t on b.idTable = t.id
	where b.DateCheckIn >= @checkIn and b.DateCheckOut <= @checkOut and b.Status = 1
end
go

create proc USP_UpdateAccount
@userName nvarchar(100),@displayName nvarchar(100), @password nvarchar(100), @newPassword nvarchar(100)
as
begin
	declare @isRigthPass int = 0
	select @isRigthPass = count(*) from dbo.account where UserName = @userName and Password = @password

	if (@isRigthPass = 1)
	begin
		if (@newPassword is null or @newPassword = '')
		begin
			update dbo.Account set DisplayName = @displayName where Username = @userName
		end
		else
		begin
			update dbo.Account set DisplayName = @displayName, Password = @newPassword where Username = @userName
		end
	end
end
go

CREATE TRIGGER UTG_DeleteBillInfo
ON dbo.BillInfor FOR DELETE
AS 
BEGIN
	DECLARE @idBillInfo INT
	DECLARE @idBill INT
	SELECT @idBillInfo = id, @idBill = Deleted.idBill FROM Deleted
	
	DECLARE @idTable INT
	SELECT @idTable = idTable FROM dbo.Bill WHERE id = @idBill
	
	DECLARE @count INT = 0
	
	SELECT @count = COUNT(*) FROM dbo.BillInfor AS bi join dbo.Bill AS b on b.id = bi.idBill where b.id = @idBill AND b.status = 0
	
	IF (@count = 0)
		UPDATE dbo.TableFood SET status = N'Trống' WHERE id = @idTable
END
GO


CREATE FUNCTION [dbo].[fuConvertToUnsign1] ( @strInput NVARCHAR(4000) ) RETURNS NVARCHAR(4000) AS BEGIN IF @strInput IS NULL RETURN @strInput IF @strInput = '' RETURN @strInput DECLARE @RT NVARCHAR(4000) DECLARE @SIGN_CHARS NCHAR(136) DECLARE @UNSIGN_CHARS NCHAR (136) SET @SIGN_CHARS = N'ăâđêôơưàảãạáằẳẵặắầẩẫậấèẻẽẹéềểễệế ìỉĩịíòỏõọóồổỗộốờởỡợớùủũụúừửữựứỳỷỹỵý ĂÂĐÊÔƠƯÀẢÃẠÁẰẲẴẶẮẦẨẪẬẤÈẺẼẸÉỀỂỄỆẾÌỈĨỊÍ ÒỎÕỌÓỒỔỖỘỐỜỞỠỢỚÙỦŨỤÚỪỬỮỰỨỲỶỸỴÝ' +NCHAR(272)+ NCHAR(208) SET @UNSIGN_CHARS = N'aadeoouaaaaaaaaaaaaaaaeeeeeeeeee iiiiiooooooooooooooouuuuuuuuuuyyyyy AADEOOUAAAAAAAAAAAAAAAEEEEEEEEEEIIIII OOOOOOOOOOOOOOOUUUUUUUUUUYYYYYDD' DECLARE @COUNTER int DECLARE @COUNTER1 int SET @COUNTER = 1 WHILE (@COUNTER <=LEN(@strInput)) BEGIN SET @COUNTER1 = 1 WHILE (@COUNTER1 <=LEN(@SIGN_CHARS)+1) BEGIN IF UNICODE(SUBSTRING(@SIGN_CHARS, @COUNTER1,1)) = UNICODE(SUBSTRING(@strInput,@COUNTER ,1) ) BEGIN IF @COUNTER=1 SET @strInput = SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)-1) ELSE SET @strInput = SUBSTRING(@strInput, 1, @COUNTER-1) +SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)- @COUNTER) BREAK END SET @COUNTER1 = @COUNTER1 +1 END SET @COUNTER = @COUNTER +1 END SET @strInput = replace(@strInput,' ','-') RETURN @strInput END
go

