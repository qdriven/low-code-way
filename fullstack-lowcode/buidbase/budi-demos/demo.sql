CREATE TABLE budi_demo."Vehicles" (
  "id" SERIAL PRIMARY KEY,
  "Registration" TEXT NULL,
  "Make" TEXT NULL,
  "Model" TEXT NULL,
  "Colour" TEXT NULL,
  "Year" INT NULL);
  

CREATE TABLE budi_demo."ServiceLog" (
  "id" SERIAL PRIMARY KEY,
  "Description" TEXT NULL,
  "VehicleId" INT NULL,
  "ServiceDate" TIMESTAMP NULL,
  "Category" TEXT NULL,
  "Mileage" INT NULL);


INSERT INTO budi_demo."Vehicles"("Registration", "Make", "Model", "Colour", "Year")
VALUES ('FAZ 9837','Volkswagen','Polo','White',2002);
INSERT INTO budi_demo."Vehicles"("Registration", "Make", "Model", "Colour", "Year")
VALUES ('JHI 8827','BMW','M3','Black',2013);
INSERT INTO budi_demo."Vehicles"("Registration", "Make", "Model", "Colour", "Year")
VALUES ('D903PI','Volvo','XC40','Grey',2014);
INSERT INTO budi_demo."Vehicles"("Registration", "Make", "Model", "Colour", "Year")
VALUES ('YFI002','Volkswagen','Golf','Dark Blue',2018);
INSERT INTO budi_demo."Vehicles"("Registration", "Make", "Model", "Colour", "Year")
VALUES ('HGT5677','Skoda','Octavia','Graphite',2009);
INSERT INTO budi_demo."Vehicles"("Registration", "Make", "Model", "Colour", "Year")
VALUES ('PPF9276','Skoda','Octavia','Graphite',2021);
INSERT INTO budi_demo."Vehicles"("Registration", "Make", "Model", "Colour", "Year")
VALUES ('J893FT','Toyota','Corolla','Red',2015);
INSERT INTO budi_demo."Vehicles"("Registration", "Make", "Model", "Colour", "Year")
VALUES ('MJK776','Honda','HR-V','Silver',2015);


INSERT INTO budi_demo."ServiceLog"("Description", "VehicleId", "ServiceDate", "Category", "Mileage")
VALUES ('Change front brakes', 1, '2021-05-04', 'Brakes', 20667);
INSERT INTO budi_demo."ServiceLog"("Description", "VehicleId", "ServiceDate", "Category", "Mileage")
VALUES ('Tyres - full set', 1, '2021-05-04', 'Tyres', 20667);
INSERT INTO budi_demo."ServiceLog"("Description", "VehicleId", "ServiceDate", "Category", "Mileage")
VALUES ('Engine tune up', 2, '2021-07-14', 'Engine', 50889);
INSERT INTO budi_demo."ServiceLog"("Description", "Vehicl
eId", "ServiceDate", "Category", "Mileage")
VALUES ('Replace transmission', 3, '2021-09-26', 'Transmission', 98002);