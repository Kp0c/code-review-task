IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Department]') AND type in (N'U'))
BEGIN
    CREATE TABLE Department (
        Id   INT NOT NULL IDENTITY(1,1),
        Name VARCHAR(32) NOT NULL,
        PRIMARY KEY (Id)
    )
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Employee]') AND type in (N'U'))
BEGIN
    CREATE TABLE Employee (
        Id           INT NOT NULL IDENTITY(1,1),
        Name         VARCHAR(32) NOT NULL,
        DepartmentId INT NOT NULL FOREIGN KEY REFERENCES Department(Id),
        PRIMARY KEY (Id)
    )
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Payments]') AND type in (N'U'))
BEGIN
    CREATE TABLE Payments (
        Id           INT NOT NULL IDENTITY(1,1),
        PaymentDate  DATE NOT NULL,
        Amount       INT NOT NULL,
        EmployeeId   INT NOT NULL FOREIGN KEY REFERENCES Employee(Id),
        PRIMARY KEY (Id)
    )
END
