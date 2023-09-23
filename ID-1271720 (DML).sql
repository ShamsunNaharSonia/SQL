/*												SQL PROJECT ON
												CarPurchaseDB
												Project Made By
												Shamsun Nahar
												Trainee ID: 1271720
												Batch ID: ESAD-CS/USSL-A/53/01
*/





--- QUERY SCRIPTS
Use CarPurchaseDB
Go

Insert Into tbl_Customer Values

        (101,'Jhon','Doe','555-1234'),
        (102,'Jane','Smith','555-1235'),
        (103,'Frank','Lee','555-1236')
        Go
Insert Into tbl_Manufacturer Values
		(10,'Ford'),
		(11,'Charry'),
		(12,'Honda')
Go
--JUSTIFY INDEX
-- Exec sp_helpindex tbl_Manufacturer
Insert Into tbl_Car Values

		( 301,  'Fusion',  10),
		( 302,	'Impala',  11),
		( 303,	'Accord',  12)
Go
Insert Into tbl_Transactions Values

		(301,101,10,5000000,2015,1/1/2015,.50,(5000000-(5000000*.50))),
		(302,102,11,5400000,2015,1/3/2015,.60,(5400000-(5400000*.60))),
		(303,103,12,6000000,2014,2/1/2015,.60,(6000000-(6000000*.60))),
		(303,101,12,7000000,2015,1/1/2015,.70,(7000000-(7000000*.70)))
Go
Insert Into Customer_TCopy Values

		(101,'Jhon',20),
		(102,'Jane',23),
		(103,'Frank',36),
		(104,'Smith',40)
Go
insert into tbl_CarCopy values
		(  11,  'Fusion'),
		(  12,  'Accord')
go
---- MERGE
insert into tbl_Candidate values
		( 101, 'Nitu'),
		( 101, 'Mitu')
go

insert into tbl_Person values
		('Nitu', 20),
		('Ripa', 25)
go

Merge into tbl_student s using
 (
 select c.id, c.name, p.age from tbl_Candidate c
  join tbl_Person p on c.name=p.name
 ) r 
 on s.id=r.id
 when matched then
 update set s.name=r.name, s.age=r.age
 when not matched then 
 insert (id,name,age) values (r.id,r.name, r.age);

 --- JOIN QUERY
		select t.CustomerID, t.CarID,
		ca.CarModel,count(t.ManufacturerID)countmanufacturer from tbl_Transactions t
		join tbl_Car ca on ca.CarID=t.CarID
		group by  t.CustomerID ,t.CarID, ca.CarModel
		having count(t.ManufacturerID)>0

----SUB QUERY
select * from tbl_Transactions where CarID in
(
		select c.CarID , t.CustomerID, c.CarModel from tbl_car c
		join tbl_Transactions t on t.CarID= c.CarID
		where c.CarModel='Accord'
)

---PROCEDURE CALLING

		--InsertUpdateDeleteOutputErrorTran 'Select','','',''
		--InsertUpdateDeleteOutputErrorTran 'Insert','09','KK',''
		--InsertUpdateDeleteOutputErrorTran 'Update','09','KK',''
		--InsertUpdateDeleteOutputErrorTran 'Delete','09','',''

DECLARE @tbl_ManufacturerCount int
EXEC InsertUpdateDeleteOutputErrorTran 'Count','','', @tbl_ManufacturerCount OUTPUT
PRINT  @tbl_ManufacturerCount

----VIEW EXECUTION
select *from vw_caridwisemodel


--- CASE FUNCTION
--- SIMPLE CASE
select 
case CarID

when 301 then ' Car Model Fusion'
when 302 then 'Car Model Impala'
when 303 then 'Car Model Accord'

end 
as CarModel
from tbl_Car

--- SEARCH CASE
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


----CTE
With cte_SumPrice
as
(
select tr.CarID, r.CarModel,sum(tr.CarPrice)sumprice,cu.CustomerID,(cu.CustomerFastName+' '+cu.CustomerLastName)as Customer,
 tr.ManufacturerId, m.ManufacturerName from tbl_Transactions tr
join tbl_Car r on r.CarID =tr.CarID
join tbl_Customer cu on cu.CustomerID=tr.CustomerID
join tbl_Manufacturer m on m.ManufacturerID = r.ManufacturerID
group by tr.CarID, r.CarModel,cu.CustomerID,cu.CustomerFastName,cu.CustomerLastName, 
tr.ManufacturerId, m.ManufacturerName 
)
select  ct.Customer,ct.CarModel,ct.ManufacturerName ,ct.SumPrice from cte_SumPrice ct;


---Calling for Trigger (After Insert)
		Insert Into tbl_Customer Values(104,'Tony')

---Calling  for Trigger (After Update)
		Insert Into tbl_Customer Values(105,'Rony')

---Calling for Trigger (After Delete)
		Delete tbl_Customer Where CustomerID=104
		Delete tbl_Customer Where CustomerID=105
		
--Calling  for Trigger(Instead of Insert)
		Insert Into tbl_Customer Values(106,'Tony')

--Calling for Trigger(Instead of Update)
		Insert Into tbl_Customer Values(107,'Rony')

---Calling for Trigger(Instead of Delete)
		Delete tbl_Customer Where CustomerID=106
		Delete tbl_Customer Where CustomerID=107

--- DELETE QUERY
		delete from Customer_TCopy where
		CustomerID=101 and CustomerName= 'John'
--- UPDATE QUERY
		update  Customer_TCopy set CustomerName='Kabir' where CustomerID=103
