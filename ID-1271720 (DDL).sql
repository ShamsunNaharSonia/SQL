/*												SQL PROJECT ON
												CarPurchaseDB
												Project Made By
												Shamsun Nahar
												Trainee ID: 1271720
												Batch ID: ESAD-CS/USSL-A/53/01
*/






---CREATING OBJECT SCRIPTS
Use master
Go
If DB_ID ('CarPurchaseDB')is not null
Drop Database CarPurchaseDB
Go

Create Database CarPurchaseDB
On
(
	Name= CarPurchaseDB_Data_1,
	FileName= 'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\CarPurchaseDB_Data_1.mdf',
	Size= 25mb,
	MaxSize= 100mb,
	FileGrowth=5%
)
Log On
(
	Name= CarPurchaseDB_Log_1,
	FileName= 'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\CarPurchaseDB_Log_1.ldf',
	Size= 2mb,
	MaxSize= 50mb,
	FileGrowth= 1mb
)
Go

Use CarPurchaseDB
Go

Create Table tbl_Customer
(
       CustomerID int Primary Key Not Null,
       CustomerFastName Varchar(7) Not Null,
       CustomerLastName Varchar(7) Not Null,
       CustomerPhone Varchar(11) Not Null
)
Create Table tbl_Manufacturer
(
	   ManufacturerID int Primary Key NonClustered Not Null,
	   ManufacturerName Varchar(12) Not Null
)
Create Clustered Index	ix_tbl_Manufacturer_ManufacturerName
on tbl_Manufacturer(ManufacturerName)
Create Table tbl_Car
(
	  CarID int Unique Not Null,
	  CarModel Varchar(8) unique Not Null,
	  ManufacturerID int Not Null References tbl_Manufacturer (ManufacturerID),
Primary Key (CarID, CarModel,ManufacturerID)

)
Create Table tbl_Transactions
(
		CarID int  Not Null References tbl_Car(CarID) ,
		CustomerID int Not Null References tbl_Customer(CustomerID),
		ManufacturerID int Not Null References  tbl_Manufacturer (ManufacturerID),
		CarPrice Money Not Null,
		PurchaseYear int Not Null,
		PurchaseDate DateTime Not Null,
		CarLoan Float,
		CashPayment Money Not Null,
Primary Key (CarID,CustomerID,ManufacturerID)

)
----TABLE FOR DELETE & UPDATE
Create Table Customer_TCopy
(

		CustomerID int Not Null,
		CustomerName Varchar(7) Not Null,
		Age int

)
--- table for merge
Create Table tbl_Candidate
(
		id int not null,
		name varchar(6)
)

Create Table tbl_Person
(
		name varchar(6) not null,
		age int
)
create table tbl_student
(
		id int not null,
		name varchar(6) not null,
		age int
)

--------PROCEDURE
CREATE Proc InsertUpdateDeleteOutputErrorTran
		@Processtype varchar(10),
		@ManufacturerID int,
		@ManufacturerName varchar(12),
		@processCount int output
		AS
		BEGIN

		Begin TRY
		BEGIN Tran
--SELECT
		if @Processtype='Select'
		Begin
		SELECT * FROM tbl_Manufacturer
		End


--INSERT
		if @Processtype='Insert'
		BEGIN 
		Insert Into tbl_Manufacturer values(@ManufacturerID,@ManufacturerName)
		End

--UPDATE
		if @Processtype='Update'
		Begin
		UPDATE tbl_Manufacturer SET ManufacturerID  = @ManufacturerID WHERE ManufacturerName = @ManufacturerName
		End

--DELETE
		if @Processtype='Delete'
		Begin
		Delete FROM tbl_Manufacturer WHERE @ManufacturerName=@ManufacturerName
		End

--COUNT
		if @Processtype='Count'
		Begin
		SELECT @processCount=COUNT(*) FROM tbl_Manufacturer
		End

		Commit Tran
		End TRY
		Begin CATCH
		SELECT ERROR_LINE() AS ErrorLine,
		ERROR_MESSAGE() as ErrorMessage,
		ERROR_NUMBER() AS ErrorNo,
		ERROR_SEVERITY() AS Severity,
		ERROR_STATE() AS ErState
		ROLLBACK TRAN
		END CATCH
		END


---(SCALAR FUNCTION)
		CREATE FUNCTION fnGetcaridbycarmodel( @CarID int)
		RETURNS int
		AS
		BEGIN
		DECLARE @CarID int
		SELECT @CarID=count(@CarID)FROM tbl_Car WHERE CarID=@CarID
		RETURN @CarID
		END

----VIEW
		create view vw_caridwisemodel
		as
		select c.CarID , t.CustomerID, c.CarModel from tbl_car c
		join tbl_Transactions t on t.CarID= c.CarID
		where c.CarModel='Accord'
	

--CASE FUNCTION
--SIMPLE FUNCTION

select 
case CarID

		when 301 then ' Car Model Fusion'
		when 302 then 'Car Model Impala'
		when 303 then 'Car Model Accord'

end 
as CarModel
from tbl_Car

--SEARCH CASE
select CarID,CarPrice ,
case
		when CarPrice=5000000
		then 'Price is Low'
		when CarPrice<=7000000
		then 'Price is very High'
		when CarPrice=6000000
		then 'Price is Average'
		else 'Normal price'

end as PriceStatus
from tbl_Transactions

---TRIGGER
--AFTER INSERT
Create Trigger Customer_Insert
		On tbl_Customer

		After Insert
		AS
		Begin
		Select CustomerID,CustomerFastName From inserted
		End

--AFTER UPDATE
		Create Trigger Customer_Update
		On tbl_Customer
		After Update
		As
		Begin
		Update tbl_Customer
		Set CustomerFastName=Upper(CustomerFastName)
		Where CustomerID IN (Select CustomerID from inserted)
		End

--AFTER DELETE
        Create Trigger Customer_Delete
		On tbl_Customer
		After Delete
		As
		Begin
		Insert Into tbl_Customer(CustomerID,CustomerFastName)
		Select CustomerID,CustomerFastName From deleted
		End

--INSTEAD OF INSERT
		Create Trigger Customer_Insert_InsteadOf
		On tbl_Customer
		Instead of Insert
		AS
		Begin
		Select CustomerID,CustomerFastName From inserted
		End

--INSERT OF UPDATE
		Create Trigger Customer_Update_InsteadOf
		On tbl_Customer
		Instead of Update
		As
		Begin
		Update tbl_Customer
		Set CustomerFastName=Upper(CustomerFastName)
		Where CustomerID IN (Select CustomerID From inserted)
		End

--INSTEAD OF DELETE

Create Trigger Customer_Delete_InsteadOf
		On tbl_Customer
		Instead of Delete
		As
		Begin
		Insert Into tbl_Customer(CustomerID,CustomerFastName)
		Select CustomerID,CustomerFastName From deleted
		End

 ---- CURSOR
 create table tbl_CarCopyy
 (
		 CarID int Primary key not null,
		 CarModel varchar(8) not null
 )
 

		declare @CarID int
		declare @CarModel varchar (15)
		declare @CarCount int
		set @CarCount=0;
declare CarCount_cursor cursor
for select * from tbl_CarCopy
open  CarCount_cursor
fetch next from CarCount_cursor into @CarID,@CarModel;
while @@FETCH_STATUS<>-1
begin
insert into tbl_CarCopy values (@CarID,@CarModel);
set @CarCount=@CarCount+1;
fetch next from CarCount_cursor into @CarID,@CarModel
end
close CarCount_cursor
deallocate CarCount_cursor
print convert (varchar, @CarCount)+'rows inserted'

----RANK FUNCTION
Select CarID,CustomerID, CarPrice,
	Rank() over(order by CarID)as Ranking,
	Dense_Rank () over(order by CarPrice)as D_Ranking,
	Row_Number() over (partition by CarID order by CustomerID) as RowNumber,
	Ntile (1) over (order by ManufacturerID)as N_Tile
from tbl_Transactions


----IIF AND CHOOSE FUNCTION
SELECT CarID, CashPayment ,avg(CarPrice) as AvgPrice,
	iif(avg(CarPrice)>=4000000,'High Price', 'Low Price') as iif_f,
	choose(CashPayment,'Have Risk','No Risk') as Choose_f
FROM tbl_Transactions

Group by CarID, CashPayment

----ISNULL AND COALESCE 
SELECT CarID,CustomerID,
	isnull(CarPrice,'0.00') as NewPrice_issNull,
	Coalesce(CarPrice,'0.00') as NewPrice_Coalesce
FROM tbl_Transactions

----GROUPING
SELECT CarID,CustomerID,
CASE
	when Grouping(CarID)=1 then 'all'
	Else 'CarID'
	End as GStatus
FROM tbl_Transactions
Group by CarID,CustomerID with rollup

----CONVERT
Select Convert (Time,'1900-01-01 11:00 AM ') Time

----CAST
Select CAST ('1900-01-01 11:00 AM ' AS Date) Date

---COLUMN DROP
alter table  Customer_TCopy
drop column Age

---TABLE DROP
drop table  Customer_TCopy*/









