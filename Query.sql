;WITH EligibleEmployee AS (
    SELECT
        Id = EmployeeId
    FROM Payments
    GROUP BY EmployeeId
    HAVING MIN(Amount) >= 5000
),
SumSalariesEmployee AS (
    SELECT 
        EligibleEmployee.Id,
        SumSalary = SUM(Amount)
    FROM EligibleEmployee
    INNER JOIN Payments ON EligibleEmployee.Id = Payments.EmployeeId
    WHERE PaymentDate >= DATEADD(MONTH, -3, GETDATE())
    GROUP BY EligibleEmployee.Id
),
EmployeeRankedSumSalariesPerDepartment AS (
    SELECT 
        DepartmentId,
        SumSalary,
        Name,
        [Rank] = DENSE_RANK() OVER (PARTITION BY DepartmentId ORDER BY SumSalary DESC)
    FROM SumSalariesEmployee
    INNER JOIN Employee ON Employee.Id = SumSalariesEmployee.Id
)
SELECT Department = Department.Name,
       Employee = EmployeeRankedSumSalariesPerDepartment.Name,
       SumSalary
FROM EmployeeRankedSumSalariesPerDepartment
INNER JOIN Department ON EmployeeRankedSumSalariesPerDepartment.DepartmentId = Department.Id
WHERE [Rank] <= 3
ORDER BY DepartmentId, SumSalary DESC
