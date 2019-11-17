show tables from HMS;
ALTER TABLE Apartment CHANGE RentMonth payment_date DATE;
ALTER TABLE Apartment CHANGE Paid_Rental_amount paid_Amount FLOAT;
drop schema HMS;
create schema HMS;
ALTER Table Leasing_Office RENAME LeasingOffice ;

drop table Apartment CASCADE;

Set FOREIGN_KEY_CHECKS=0 ;drop table Apartment cascade; Set FOREIGN_KEY_CHECKS=1;
select * from LeasedORpurchased_By;
select * from Individual;
select * from Property_Apartment_type;

insert into Apartment values (1400,'201','2018-11-12',800,default,'yes',123456,234512);
insert into Individual values (Individual_ID,'998976567','jhgkfjghkf','1991-10-11',2,2);

USE HMS;
INSERT INTO LeasedORpurchased_By
(
 Apt_Number ,
  Identifier ,
  Individual_ID ,
  A_status  ,
  Lease_Start_DateORPurchased_Date 
  )
VALUES
(19,"A5",2,"Leased",DATE_ADD(CURDATE(), INTERVAL -837 DAY));

select p.Property_ID,p.No_leased_Apartment,A_status from Apartment a,Property p,LeasedORpurchased_By l 
where p.Property_ID = a.Property_ID AND a.Apt_Number = l.Apt_Number AND a.Identifier= l.Identifier AND A_status='Leased';
select * from Apartment ;where Property_ID='7';
select * from Property;
select * from LeasedORpurchased_By;
select * from LeasedORpurchased_By where Individual_ID IN(6,11,18);
select * from LeasedORpurchased_By where Individual_ID IN(select Individual_ID from LeaseORSell_to where Office_ID='7');
select * from Individual where Individual_ID IN(select Individual_ID from LeaseORSell_to where Office_ID='7');
select * from LeaseORSell_to where Office_ID='7';

select * from LeasingOffice;

Alter Table LeasedORpurchased_By Add Column Lease_End_Date DATE ;

delete from LeasedORpurchased_By where Apt_Number=19 and Identifier='A5' and Individual_ID="2" and Lease_Start_DateORPurchased_Date='2017-03-08';

update LeasedORpurchased_By set Lease_End_Date = DATE_ADD(CURDATE(), INTERVAL - 925 DAY) where Apt_Number=19 and Identifier='A5' and Individual_ID="2" and Lease_Start_DateORPurchased_Date='2016-08-20';



select p.Property_ID,No_leased_Apartment,No_Vacant_Apartment,No_purchased_Apartment ,a.Apt_Number,a.Identifier,A_status from Property p,Apartment  a,LeasedORpurchased_By L where p.Property_ID = a.Property_ID AND a.Apt_Number = L.Apt_Number AND a.Identifier= L.Identifier;


#1.get the details of individual ID,SSN, Name and leasing office ID ,location 
#who purchased apartment from property "Et Waters" with their date of purchase
select I.Individual_ID,SSN,IName,Lo.Office_Id,Lo.OfficeLocation,Lease_Start_DateORPurchased_Date,Lp.A_status,P.PName 
from Individual I ,LeasingOffice Lo,Property P,LeaseORSell_to Ls,LeasedORpurchased_By Lp 
where I.Individual_ID = Lp.Individual_ID AND Lp.A_status = "Owned" 
AND Ls.Individual_ID=I.Individual_ID AND Ls.Office_Id = Lo.Office_Id
AND Lo.Property_ID =P.Property_ID AND P.PName="Et Waters";






select I.Individual_ID,SSN,IName,Lo.Office_Id,Lo.Property_ID,P.PName 
from Individual I ,LeasingOffice Lo,Property P,LeaseORSell_to Ls,LeasedORpurchased_By Lp 
where I.Individual_ID = Lp.Individual_ID AND Lp.A_status = "Owned" 
AND Ls.Individual_ID=I.Individual_ID AND Ls.Office_Id = Lo.Office_Id
AND Lo.Property_ID =P.Property_ID AND P.PName="Et Waters";






select * from  Apartment a,Individual i,LeasedORpurchased_By l where i.Individual_ID = l.Individual_ID
And  a.Apt_Number = l.Apt_Number and a.Identifier = l.Identifier order by i.Individual_ID ;






#2.Retrieve apartment ID and Payment attributes for which the actual amount is not paid 
#i.e.(actual amount – paid amount) due amount to be paid.
select DISTINCT A.Apt_Number,A.Identifier,Payment_date,
Paid_amount ,Actual_RentORPurchased_Amount ,
(Actual_RentORPurchased_Amount-Paid_amount) AS Tobepaid
from (Apartment A JOIN LeasedORpurchased_By L ON A.Apt_Number=L.Apt_Number) 
JOIN Individual  I ON L.Individual_ID = I.Individual_ID 
where (Actual_RentORPurchased_Amount-Paid_amount)>0;


# 3fetch the Complaint ID,status along with Individual ID,Name with their apartment ID
#who submitted compaints earlier than 7 days whose status is not resolved

select Complaint_ID,Complaint_Status,Complaint_Date ,DATEDIFF(CURDATE(),Complaint_Date) As Days,
I.Individual_ID ,IName,A.Apt_Number,A.Identifier
from Individual I,Complaint C , LeasedORpurchased_By L,Apartment A 
where C.Individual_ID = I.Individual_ID and I.Individual_ID = L.Individual_ID 
and L.Apt_Number=A.Apt_Number and L.Identifier=A.Identifier
and DATEDIFF(CURDATE(),Complaint_Date) >=7 and Complaint_Status !='RESOLVED' order by Complaint_ID;

# 4Retrive names of individual along with apartment ID whose are currenly on lease 
select DISTINCT I.Individual_ID,Iname,Apt_Number,Identifier
from Individual I, LeasedORpurchased_By 
where (Apt_Number,Identifier,I.Individual_ID) IN (select Apt_Number,Identifier,Individual_ID 
												  from LeasedORpurchased_By 
												  where A_Status ="Leased" and Lease_End_Date IS NULL);


#5update lease end date of any apartment whose Lease start date is 2014 
#to "2018-01-07" and lease_end_date is null for Apatment ID(69,EC1)
update LeasedORpurchased_By 
set  Lease_End_Date = '2018-06-07' 
where Lease_End_Date IS NULL and Lease_Start_DateORPurchased_Date and 
YEAR(Lease_Start_DateORPurchased_Date) =2014 and Apt_Number='69' and Identifier='EC1';


#6insert values intlo table Property

INSERT INTO Property(
  PName ,
  Location,
  IS_PetsAllowed ,
  No_leased_Apartment ,
  No_Vacant_Apartment ,
  No_purchased_Apartment )
values
 ("West Ghoshen","Downington","No",2,5,1),
 ("UNC Homes","Exton","Yes",2,6,1),
 ("Harrison Hill","West Chester","Yes",2,3,1);
 
 
 
#7retrive Employee details  who work for more then one leasing office
#along with number of office he/she work with .

select E.EMPLOYEE_ID,ESSN,FName,LName,DOB,count(*) 
from Works_With W,Employee E 
where W.EMPLOYEE_ID=E.EMPLOYEE_ID 
Group by EMPLOYEE_ID 
having  Count(*)>1;




select W.EMPLOYEE_ID,E.EMPLOYEE_ID,ESSN,FName,LName,DOB,Office_Id
from Works_With W,Employee E 
where W.EMPLOYEE_ID=E.EMPLOYEE_ID;

# list vacant apartments(Apartment ID available at dayton location for peppertree 
#and along with property ID,Pname and location and Apartment ID 
 
select P.Property_ID,PName,P.Location,A.Office_Id,A.Apt_Number,A.Identifier 
from Apartment A ,Property P
where (A.Apt_Number,A.Identifier) NOT IN
			(select L.Apt_Number,L.Identifier 
		     from Apartment A,LeasedORpurchased_By L 
		     where A.Apt_Number = L.Apt_Number and A.Identifier=L.Identifier 
             AND L.A_status IN("Leased","Owned"))
		AND
        A.Property_ID=P.Property_ID and
        Location="Dayton" and PName="Peppertree";

select * from Property where Location="Dayton" and PName="Peppertree";

select L.Apt_Number,L.Identifier ,L.A_status from Apartment A,LeasedORpurchased_By L 
where A.Apt_Number = L.Apt_Number and A.Identifier=L.Identifier and L.A_status IN("Leased","Owned");

#Retrive All apartment Details(Apartemnt ID,OFficeID,Property Id) along with their Apartmnet vacany status
#Note status will be null for vacant apartment.

select DISTINCT A.Apt_Number,A.Identifier ,L.A_status,Office_Id,Property_ID 
from (Apartment A Left OUTER JOIN LeasedORpurchased_By L 
on A.Apt_Number = L.Apt_Number and A.Identifier=L.Identifier );

#8.Alter table 

Alter table Property_Apartment_type Rename Property_Apartment_types;
Alter table Apartment change Actual_Annual_RentORPurchased_Amount Actual_RentORPurchased_Amount FLOAT NOT NULL;

select * from Apartment;

#get the details of individuals and leasing office details 
#who purchased apartment from property "Et Waters" with their date of purchase
select I.Individual_ID,Lo.Office_Id,Lo.Property_ID,P.PName 
from Individual I ,LeasingOffice Lo,Property P,LeaseORSell_to Ls,LeasedORpurchased_By Lp 
where I.Individual_ID = Lp.Individual_ID AND Lp.A_status = "Leased" 
AND Ls.Individual_ID=I.Individual_ID AND Ls.Office_Id = Lo.Office_Id
AND Lo.Property_ID =P.Property_ID AND P.PName="Et Waters";






#Retrieve apartment ID for which the actual amount is not paid (actualamount – paid amount) is positive.
select A.Apt_Number,A.Identifier,Payment_date,
Paid_amount ,Actual_Annual_RentORPurchased_Amount ,
(Actual_Annual_RentORPurchased_Amount-Paid_amount) AS Tobepaid
from (Apartment A JOIN LeasedORpurchased_By L ON A.Apt_Number=L.Apt_Number) 
JOIN Individual  I ON L.Individual_ID = I.Individual_ID 
where (Actual_Annual_RentORPurchased_Amount-Paid_amount)>0;











#Paid_amount!= Actual_Annual_RentORPurchased_Amount and 

select * from LeasedORpurchased_By;

select * from Individual;
select * from Apartment;
select Count(*) from Apartment where Actual_Annual_RentORPurchased_Amount-Paid_amount<=0 ;

select * from LeasedORpurchased_By L JOIN Individual I where L.Individual_ID = I.Individual_ID ;






