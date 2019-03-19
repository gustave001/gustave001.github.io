---
title: SQL战leetcode
tags: [SQL,leetcode]
date: 2019-03-19 01:15:14
updated: 2019-03-19 02:51:41
categories: SQL
---
 
#  180.连续出现的数字
```sql
select distinct tmp.ConsecutiveNums from
(select Num as ConsecutiveNums,
 case when @prev = Num then @count := @count+1
 when @prev :=Num then @count :=1
 end as count
 from Logs,(select @prev :=null,@count :=null) pc) tmp
 where tmp.count >=3
```
- 其实不够严谨，没有考虑Num为0的情况，应当把
`when @prev :=Num then @count :=1`改为`when (@prev :=Num) is not null then @count :=1`

# 184.部门工资最高的员工
```sql
select d.Name as Department,e.Name as Employee,e.Salary
from Employee e inner join Department d on e.DepartmentId = d.Id
inner join
(select 
DepartmentId,Max(Salary) as maxSalary
from Employee
group by DepartmentId) tmp
on e.DepartmentId = tmp.DepartmentId and e.Salary = tmp.maxSalary
```

# 178.分数排名
```sql
SELECT tmp.Score,
       CASE
         WHEN tmp.Score = @prev THEN convert(@rank,UNSIGNED )
         WHEN (@prev := tmp.Score) is not null THEN convert(@rank := @rank + 1,UNSIGNED )
           END AS Rank
FROM (SELECT Score FROM Scores ORDER BY Score DESC) tmp,
     (SELECT @prev := NULL, @rank := 0) pr
```
- 也是注意这里when后面的用法问题
```sql
SELECT s1.Score,(SELECT count(DISTINCT s2.Score)+1 FROM Scores s2 WHERE s2.Score >s1.Score ) as Rank
       FROM Scores s1 order by Score desc
```
- 子查询，看起来写法是简单了，但是实质上性能差了不少

# 177.第N高的薪水
- 要求如果不存在的话返回null
- 下方为自己的解法,判断null的问题居然还是多余的。。。
```sql
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  RETURN (
      # Write your MySQL query statement below.
      select
      case when count(*) = 1 then Salary
      else null end
      from
      (select e.Salary,@rownum := @rownum + 1 as rownum from
      (select Salary from Employee group by Salary order by Salary desc) e,(select @rownum := 0) r) tmp where rownum = N
  );
END
```
- 看起来简洁写法
```sql
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
      # Write your MySQL query statement below.
          set N = N-1;
  RETURN (
    select distinct ifnull(salary,null) from  employee order by salary desc limit N,1 
  );
  END
```