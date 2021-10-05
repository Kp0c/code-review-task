;WITH EligibleEmployee AS (
    SELECT
        Id = EmployeeId
    FROM Payments
    GROUP BY EmployeeId
    HAVING MIN(Amount) >= 5000
),
AvgSalariesEmployee AS (
    SELECT 
        EligibleEmployee.Id,
        AvgSalary = AVG(Amount)
    FROM EligibleEmployee
    INNER JOIN Payments ON EligibleEmployee.Id = Payments.EmployeeId
    WHERE PaymentDate >= DATEADD(MONTH, -3, GETDATE())
    GROUP BY EligibleEmployee.Id
),
EmployeeRankedAvgSalariesPerDepartment AS (
    SELECT 
        DepartmentId,
        AvgSalary,
        Name,
        [Rank] = DENSE_RANK() OVER (PARTITION BY DepartmentId ORDER BY AvgSalary DESC)
    FROM AvgSalariesEmployee
    INNER JOIN Employee ON Employee.Id = AvgSalariesEmployee.Id
)
SELECT Department = Department.Name,
       Employee = EmployeeRankedAvgSalariesPerDepartment.Name,
       AvgSalary
FROM EmployeeRankedAvgSalariesPerDepartment
INNER JOIN Department ON EmployeeRankedAvgSalariesPerDepartment.DepartmentId = Department.Id
WHERE [Rank] <= 3
ORDER BY DepartmentId, AvgSalary DESC
