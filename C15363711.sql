/*
o Your Student Number - C15363711
o Your Name - Fatema Bader
o Your Programme Code
o Your Lab Group -Group A
*/

--1. Drop tables
DROP TABLE NonDrugSale CASCADE CONSTRAINTS PURGE;

DROP TABLE Product_PackSize CASCADE CONSTRAINTS PURGE;

DROP TABLE PackSize CASCADE CONSTRAINTS PURGE;

DROP TABLE Product CASCADE CONSTRAINTS PURGE;

DROP TABLE Supplier CASCADE CONSTRAINTS PURGE;

DROP TABLE Brand CASCADE CONSTRAINTS PURGE;

DROP TABLE DrugType CASCADE CONSTRAINTS PURGE;

DROP TABLE Prescription CASCADE CONSTRAINTS PURGE;

DROP TABLE Doctor CASCADE CONSTRAINTS PURGE;

DROP TABLE Customer CASCADE CONSTRAINTS PURGE;

DROP TABLE Staff CASCADE CONSTRAINTS PURGE;

DROP TABLE StaffRole CASCADE CONSTRAINTS PURGE;

-- Create tables
-- StaffRole(roleID,roleDesc)
CREATE TABLE StaffRole
(
	roleID               NUMBER(6) NOT NULL ,
	roleDesc             VARCHAR2(50) NULL ,
  
CONSTRAINT  StaffRole_pk PRIMARY KEY (roleID)
);

/*
Staff(staffID, staffName, staffAddress, staffPhone, staffEmail,staffPPSN,roleID)

Staff email addresses must contain the @
symbol, if no email address is provided a default value will be used.
All other data must be provided. (Must be Not Null)*/
CREATE TABLE Staff
(
	staffID              NUMBER(6) NOT NULL ,
	staffName            VARCHAR2(50) NOT NULL ,
	staffAddress         VARCHAR2(50) NOT NULL ,
	staffPhone           VARCHAR2(50) NOT NULL ,
	staffEmail           VARCHAR2(50) DEFAULT  'example@example.com',
	staffPPSN            VARCHAR2(50) NOT NULL ,
	roleID               NUMBER(6) NOT NULL ,
  
CONSTRAINT  staff_pk PRIMARY KEY (staffID),
CONSTRAINT  staffEmail_chk CHECK ( staffEmail like '%@%'),
CONSTRAINT staff_StaffRole_pk FOREIGN KEY (roleID) REFERENCES StaffRole (roleID)
);

/*
Customer(custId, custname, custaddress, mednum, custEmail, custPhone)

Kevin will create a new record for the customer (name,
address, contact details, medical card number (if any)).*/
CREATE TABLE Customer
(
	custId               NUMBER(6) NOT NULL ,
	custname             VARCHAR2(50) NOT NULL ,
	custaddress          VARCHAR2(50) NOT NULL ,
	mednum               VARCHAR2(50) NULL ,
	custEmail            VARCHAR2(50) NOT NULL ,
	custPhone            VARCHAR2(50) NOT NULL ,
  
CONSTRAINT  Customer_pk PRIMARY KEY (custId)
);

/*
Doctor(doctorId, dname, surgDetails, surgName, surgAddress)

 Kevin will create a new record
for the doctor (doctor’s name, surgery name and surgery address) and assign a unique ID.*/
CREATE TABLE Doctor
(
	doctorId             NUMBER(6) NOT NULL ,
	dname                VARCHAR2(50) NOT NULL ,
	surgDetails          VARCHAR2(50) NULL ,
	surgName             VARCHAR2(50) NOT NULL ,
	surgAddress          VARCHAR2(50) NOT NULL ,
  
CONSTRAINT  Doctor_pk PRIMARY KEY (doctorId)
);

/*
Prescription(prescriptionID, doctorId, staffID, custId, numofdays, specificProd)

Kevin will input partial details for the prescription
including the customer details and prescribing doctor details. 
The system will assign a unique prescription ID.*/
CREATE TABLE Prescription
(
	prescriptionID       NUMBER(6) NOT NULL ,
	doctorId             NUMBER(6) NOT NULL ,
	staffID              NUMBER(6) NULL ,
	custId               NUMBER(6) NULL ,
	numofdays            NUMBER(6) NULL ,
	specificProd         VARCHAR2(50) NULL ,
CONSTRAINT  Prescription_pk PRIMARY KEY (prescriptionID),
CONSTRAINT Prescription_Staff_fk FOREIGN KEY (staffID) REFERENCES Staff (staffID),
CONSTRAINT Prescription_Customer_fk FOREIGN KEY (custId) REFERENCES Customer (custId),
CONSTRAINT Prescription_Doctor_fk FOREIGN KEY (doctorId) REFERENCES Doctor (doctorId)
);

/*
DrugType(drugTypeName,dosage,prescription, pinstructions,cinstructions)

The information required about a
drug type is a name, a normal dosage, a ‘P’ if it is prescription only, dispensing instructions (for the
pharmacist) and use instructions (for the customer).*/
CREATE TABLE DrugType
(
	drugTypeName         VARCHAR2(50) NOT NULL ,
	dosage               VARCHAR2(50) NULL ,
	prescription         VARCHAR2(50) NULL ,
	pinstructions        VARCHAR2(50) NULL ,
	cinstructions        VARCHAR2(50) NULL ,
	prescriptionID       NUMBER(6) NULL ,
CONSTRAINT  DrugType_pk PRIMARY KEY (drugTypeName),
CONSTRAINT DrugType_Prescription_fk FOREIGN KEY (prescriptionID) REFERENCES Prescription (prescriptionID)
);

/*
Brand(brandID,brandName,drugTypeName)*/
CREATE TABLE Brand
(
	brandID              NUMBER(6) NOT NULL ,
	brandName            VARCHAR2(50) NULL ,
	drugTypeName         VARCHAR2(50) NULL ,
CONSTRAINT  Brand_pk PRIMARY KEY (brandID),
CONSTRAINT Brand_DrugType_fk FOREIGN KEY (drugTypeName) REFERENCES DrugType (drugTypeName)
);

/*
Supplier(suppID,suppName,suppAddress,suppPhone)

needed (Use NOT NULL is the
name of the supplier, address, and main telephone contact number.*/
CREATE TABLE Supplier
(
	suppID               NUMBER(6) NOT NULL ,
	suppName             VARCHAR2(50) NOT NULL ,
	suppAddress          VARCHAR2(50) NOT NULL ,
	suppPhone            VARCHAR2(50) NOT NULL ,
CONSTRAINT  Supplier_pk PRIMARY KEY (suppID)
);

/*
Product (stockcode, prodDesc, prodCostPrice, prodRetailPrice, brandID, suppID, collected, drugTypeName)
Each supplier has a unique ID.
*/
CREATE TABLE Product
(
	stockcode            NUMBER(6) NOT NULL ,
	prodDesc             VARCHAR2(50) NULL ,
	prodCostPrice        NUMBER(6,2) NULL ,   -- Scale provided
	prodRetailPrice      NUMBER(6,2) NULL ,
	brandID              NUMBER(6) NULL ,
	suppID               NUMBER(6) NULL ,
	collected            CHAR(1) NULL ,
	drugTypeName         VARCHAR2(50) NULL ,
CONSTRAINT  Product_pk PRIMARY KEY (stockcode),
CONSTRAINT Product_Brand_fk FOREIGN KEY (brandID) REFERENCES Brand (brandID),
CONSTRAINT Product_Supplier_fk FOREIGN KEY (suppID) REFERENCES Supplier (suppID),
CONSTRAINT Product_DrugType_fk FOREIGN KEY (drugTypeName) REFERENCES DrugType (drugTypeName)
);

/*
PackSize (sizeID, sizeDesc)*/
CREATE TABLE PackSize
(
	sizeID               NUMBER(6) NOT NULL ,
	sizeDesc             VARCHAR2(50) NULL ,
  
CONSTRAINT  PackSize_pk PRIMARY KEY (sizeID)
);
/*Product_PackSize(stockcode, sizeID)*/
CREATE TABLE Product_PackSize
(
	stockcode            NUMBER(6) NOT NULL ,
	sizeID               NUMBER(6) NOT NULL ,
  
CONSTRAINT  Product_PackSize_pk PRIMARY KEY (stockcode,sizeID),
CONSTRAINT Product_PackSize_Product_fk FOREIGN KEY (stockcode) REFERENCES Product (stockcode),
CONSTRAINT Product_PackSize_PackSize_fk FOREIGN KEY (sizeID) REFERENCES PackSize (sizeID)
);

/*
NonDrugSale (stockcode, staffID, datetimeofSale, qtySold)

No customer details are recorded for non-drug products but details of the product,
the amount sold, the date, time and member of staff who made the sale must be recorded.*/
CREATE TABLE NonDrugSale
(
	stockcode            NUMBER(6) NOT NULL ,
	staffID              NUMBER(6) NOT NULL ,
	datetimeofSale       TIMESTAMP(6) NULL ,
	qtySold              NUMBER(6) NULL ,
  
CONSTRAINT  NonDrugSale_pk PRIMARY KEY (stockcode),
CONSTRAINT NonDrugSale_Product_fk FOREIGN KEY (stockcode) REFERENCES Product (stockcode),
CONSTRAINT NonDrugSale_Staff_fk FOREIGN KEY (staffID) REFERENCES Staff (staffID)
);


--2. Insert data
INSERT INTO StaffRole(roleID,roleDesc)
VALUES(1,'pharmacist');
INSERT INTO StaffRole(roleID,roleDesc)
VALUES(2,'counter staff');
INSERT INTO StaffRole(roleID,roleDesc)
VALUES(3,'stock clerk');
INSERT INTO StaffRole(roleID,roleDesc)
VALUES(4,'security');
INSERT INTO StaffRole(roleID,roleDesc)
VALUES(5,'dispencer');


insert into Staff(staffID, staffName, staffAddress, staffPhone, staffEmail,staffPPSN,roleID)
values (1001,	'Fatema','1 street',014022849,	'ak@mail.com','D1523',1);
insert into Staff(staffID, staffName, staffAddress, staffPhone, staffEmail,staffPPSN,roleID)
values (1002,	'Daragh','4 street',01503449,	'h@mail.com','K1523',2);
insert into Staff(staffID, staffName, staffAddress, staffPhone, staffEmail,staffPPSN,roleID)
values (1003,	'Thomas','98 street',01698849,	'hy@mail.com','P1523',3);
insert into Staff(staffID, staffName, staffAddress, staffPhone, staffEmail,staffPPSN,roleID)
values (1004,	'Sylvia','90 street',0147809,	'lli@mail.com','L1523',4);
insert into Staff(staffID, staffName, staffAddress, staffPhone,staffPPSN,roleID)
values (1005,	'Rachel','13 street',01566849,'K1523',5);

insert into Customer(custId, custname, custaddress, mednum, custEmail, custPhone)
values (9001, 'Sylvia',		'7 street',	'D52837', 'some@mail.com', 1247 );
insert into Customer(custId, custname, custaddress, mednum, custEmail, custPhone)
values (9002, 'Brendan',		'75 street',	'I88837', 'soh@mail.com', 683647 );
insert into Customer(custId, custname, custaddress, mednum, custEmail, custPhone)
values (9003, 'Jamie',		'77 street',	'S52837', 'sh@mail.com', 45647 );
insert into Customer(custId, custname, custaddress, mednum, custEmail, custPhone)
values (9004, 'Oliver',		'78 street',	'O52837', 'sllop@mail.com', 8897 );
insert into Customer(custId, custname, custaddress, mednum, custEmail, custPhone)
values (9005, 'Smith',		'79 street',	'L52837', 'kke@mail.com', 7647 );

insert into Doctor(doctorId, dname, surgDetails, surgName, surgAddress)
values (3001, 'Moh','Eye surgery',	'Optical Express', '86 road');
insert into Doctor(doctorId, dname, surgDetails, surgName, surgAddress)
values (3002, 'malek','Bone surgery',	'Express200', '76 road');
insert into Doctor(doctorId, dname, surgDetails, surgName, surgAddress)
values (3003, 'omar','Skin surgery',	'Volvic Express', '70 road');
insert into Doctor(doctorId, dname, surgDetails, surgName, surgAddress)
values (3004, 'ahmed','Bladder surgery',	'Specsaver', '98 road');
insert into Doctor(doctorId, dname, surgDetails, surgName, surgAddress)
values (3005, 'nafa','Hand surgery',	'Vincents', '87road');

--Partial Inserts
insert into Prescription(prescriptionID, doctorId, staffID, custId, numofdays, specificProd)
values (6001,3001,1001,9001,5,'vaseline');
insert into Prescription(prescriptionID, doctorId, staffID, custId, numofdays)
values (6002,3002,1002,9002,2	);
insert into Prescription(prescriptionID, doctorId, staffID, custId, numofdays)
values (6003,3003,1003,9003,3	);
insert into Prescription(prescriptionID, doctorId, staffID, custId, numofdays)
values (6004,3004,1004,9004,1	);
insert into Prescription(prescriptionID, doctorId, staffID, custId, numofdays)
values (6005,3004,1005,9005,9	);

insert into DrugType(drugTypeName,dosage,prescription, pinstructions,cinstructions)
values ('Paracetemol',33,'N','No more than20mg','Take after food');
insert into DrugType(drugTypeName,dosage,prescription, pinstructions,cinstructions,prescriptionID)
values ('Virex',23,'P','No more than20mg','Take after food',6001);
insert into DrugType(drugTypeName,dosage,prescription, pinstructions,cinstructions)
values ('FDA',13,'N','No more than20mg','No more than 6');
insert into DrugType(drugTypeName,dosage,prescription, pinstructions,cinstructions,prescriptionID)
values ('Isotretinone',55,'P','No more than20mg','Take before food',6002);
insert into DrugType(drugTypeName,dosage,prescription, pinstructions,cinstructions)
values ('Extra',10,'N','No more than20mg','Take after food');

insert into Brand(brandID,brandName,drugTypeName)
values (2001,'Panadol','Paracetemol');
insert into Brand(brandID,brandName,drugTypeName)
values (2002,'Tylenol','Paracetemol');
insert into Brand(brandID,brandName,drugTypeName)
values (2003,'Roaccutane','Isotretinone');
insert into Brand(brandID,brandName,drugTypeName)
values (2004,'Colgate','FDA');
insert into Brand(brandID,brandName,drugTypeName)
values (2005,'Carmax','Virex');

insert into Supplier(suppID,suppName,suppAddress,suppPhone)
values (8001,'ACG','79 brodroad',0133474);
insert into Supplier(suppID,suppName,suppAddress,suppPhone)
values (8002,'Adents','13 brodroad',017674);
insert into Supplier(suppID,suppName,suppAddress,suppPhone)
values (8003,'pharmapack','38 brodroad',012674);
insert into Supplier(suppID,suppName,suppAddress,suppPhone)
values (8004,'Campack','56 brodroad',0122474);
insert into Supplier(suppID,suppName,suppAddress,suppPhone)
values (8005,'Paro','87 brodroad',0189974);

insert into Product (stockcode, prodDesc, prodCostPrice, prodRetailPrice, brandID, suppID, collected, drugTypeName)
values (112233, 'Relief of pain and aches', 7.00, 10.00, 2001, 8001, 'Y', 'Paracetemol');
insert into Product (stockcode, prodDesc, prodCostPrice, prodRetailPrice, brandID, suppID, collected, drugTypeName)
values (223344, 'Disinfect', 9.00, 18.00, 2005, 8002, 'N', 'Virex');
insert into Product (stockcode, prodDesc, prodCostPrice, prodRetailPrice, brandID, suppID, collected, drugTypeName)
values (334455, 'Dental hygiene', 8.00, 5.00, 2004, 8003, 'Y', 'FDA');
insert into Product (stockcode, prodDesc, prodCostPrice, prodRetailPrice, brandID, suppID, collected, drugTypeName)
values (445566, 'Relief of pain and aches', 7.00, 13.00, 2003,8004, 'Y', 'Isotretinone');
insert into Product (stockcode, prodDesc, prodCostPrice, prodRetailPrice, brandID, suppID, collected, drugTypeName)
values (556677, 'Dental hygiene', 2.00, 10.00, 2002, 8005, 'Y','Paracetemol');

insert into PackSize (sizeID, sizeDesc)
values (12, 'Air Packed');
insert into PackSize (sizeID, sizeDesc)
values (24, 'Air Packed');
insert into PackSize (sizeID, sizeDesc)
values (16, 'Air Packed');
insert into PackSize (sizeID, sizeDesc)
values (13, 'Air Packed');
insert into PackSize (sizeID, sizeDesc)
values (22, 'Air Packed');

insert into Product_PackSize(stockcode, sizeID)
values (112233, 12);
insert into Product_PackSize(stockcode, sizeID)
values (223344, 24);
insert into Product_PackSize(stockcode, sizeID)
values (334455, 16);
insert into Product_PackSize(stockcode, sizeID)
values (445566, 13);
insert into Product_PackSize(stockcode, sizeID)
values (556677, 22);

insert into NonDrugSale (stockcode, staffID, datetimeofSale, qtySold)
values (112233, 1001, '21 Mar 2016 13:23:44' , 1);
insert into NonDrugSale (stockcode, staffID, datetimeofSale, qtySold)
values (223344, 1002,'03 Apr 2016 13:23:44' , 3);
insert into NonDrugSale (stockcode, staffID, datetimeofSale, qtySold)
values (334455, 1003,'11 Jun 2016 13:23:44' , 1);
insert into NonDrugSale (stockcode, staffID, datetimeofSale, qtySold)
values (445566, 1004, '18 Jul 2016 13:23:44', 1);
insert into NonDrugSale (stockcode, staffID, datetimeofSale, qtySold)
values (556677, 1005,'20 Mar 2016 13:23:44' , 3);

commit;

/*3(a) Involving Two tables Brand and DrugType
  using character single row function LOWER
  Retrieve BrandID and drugTypeName of all drugs.
Output displays column drugTypeName column as ‘Drug’ 
*/
SELECT brandID,
  LOWER('drugTypeName') "Drug"
FROM BRAND
JOIN DrugType
USING (drugTypeName);

/* Involving Three different tables
  using general purpose single row function CASE
  
  Cost Prices between 0 and 4 are considered
‘Low’; between 5 and 10 are considered ‘Moderate’; all other Cost Prices are considered ‘High’.
This comment should be called ‘Cost Level’.
*/
SELECT prodCostPrice ,
 brandName,
  suppName,
  CASE
    WHEN prodCostPrice BETWEEN 0.00 AND 4.00
    THEN 'Low'
    WHEN prodCostPrice BETWEEN 5.00 AND 10.00
    THEN 'Moderate'
    ELSE 'High'
  END
  AS "Cost Level"
FROM Product
JOIN Brand
USING (brandID)
JOIN Supplier
USING (suppID);


/*Outer joins
		LEFT OUTER JOIN
    The LEFT JOIN keyword returns all rows from the left table (drugType),
    with the matching rows in the right table (Product).
    The result is NULL in the right side when there is no match.*/
SELECT  drugTypeName,prodDesc
FROM DrugType
LEFT JOIN Product
USING (drugTypeName);

/*Outer joins
		RIGHT OUTER JOIN using different tables
    The RIGHT JOIN keyword returns all rows from the right table (doctor),
    with the matching rows in the left table (prescription). 
    The result is NULL in the left side when there is no match.*/
SELECT dname,specificProd
FROM Prescription
RIGHT JOIN Doctor
USING (doctorId);

/*AGGREGATION FUNCTION WITH GROUP
Find the number of staff employed in each role within the pharmacy and display
their names*/
SELECT staffName,count(staffName)
FROM Staff
JOIN StaffRole
USING (roleID)
GROUP BY (staffName);

/*AGGREGATION FUNCTION USING "AVG" WITH GROUP
2. Note: Using HAVING
Find the drug/drugs with a average costprice greater than 6*/
SELECT drugTypeName, AVG(prodCostPrice)
FROM Product
GROUP BY drugTypeName
HAVING AVG(prodCostPrice)> 6;

/*UPDATE SEELCTED DATA USING SUBQUERY
UPDATE VIREX COSTPRICE TO INCREASE BY 25%*/
UPDATE Product
SET prodCostPrice= prodCostPrice*1.25
WHERE brandID IN 
				(SELECT brandID
				FROM Brand
				WHERE drugTypeName= 'Virex');

/*Add column
Add column to nondrugsale table called onsale*/
ALTER TABLE NonDrugSale
ADD onsale CHAR(1);

    --PUT VALUES INSIDE COLUMN
    UPDATE NonDrugSale
    SET onsale='N' ;
--	Modify this column so that it is not null.
ALTER TABLE NonDrugSale MODIFY onsale NOT NULL;

--	Delete the column onsale from the nondrugsale table. 
ALTER TABLE NonDrugSale DROP COLUMN onsale;

--	Add a constraint to the table so that it can accept values
-- between 1000.00 and 3500.00.
ALTER TABLE Product
ADD CONSTRAINT prodRetailPrice_chk CHECK (prodRetailPrice > 2);

--Drop constraint
ALTER TABLE Product DROP CONSTRAINT prodRetailPrice_chk;

