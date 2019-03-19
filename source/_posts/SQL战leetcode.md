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

# 177.上升的温度
```sql
select 
w1.Id
from Weather w1 inner join Weather w2 
# on w1.RecordDate = date_add(w2.RecordDate,interval 1 Day)
on datediff(w1.RecordDate,w2.RecordDate) = 1
and w1.Temperature > w2.Temperature
```
- inner join当中，where和on的效果貌似没什么区别

# 176.第二高的薪水
- 这里就看出写法的问题了
```sql
select 
case when count(*) = 1 then Salary
else null end as SecondHighestSalary
from
(select Salary,@rownum := @rownum + 1 as rownum from
(select Salary 
from Employee group by Salary order by Salary desc) tmp,(select @rownum := 0) r) t
where rownum = 2
```
- 个人第二种解法
```sql
select 
case when count(*) > 0 then Salary
else null end as SecondHighestSalary
from Employee e1 where (select count(distinct Salary) from Employee e2 where e2.Salary > e1.Salary) =1
```
- 丫的还有这种玩法,外面再套一层的方式
```sql
select IFNULL((select distinct(Salary) 
from Employee
order by Salary desc
limit 1,1),null) as SecondHighestSalary
```
## 需要第N高使用limit N-1,1是最直接的，如果没有需要返回null，那么在外面再套一层就是了

# 262.行程和用户
```sql
select 
t.Request_at as Day,
round((sum(case when t.Status <> 'completed' then 1 else 0 end)/count(*)),2) as 'Cancellation Rate'
from Trips t
inner join Users u on t.Client_Id = u.Users_Id and u.Banned = 'No'
inner join Users u2 on t.Driver_Id = u2.Users_Id and u2.Banned = 'No'
where t.Request_at between '2013-10-01' and '2013-10-03'
group by t.Request_at order by t.Request_at asc
```
- 1.非禁止用户这是一个坑2.round的用法

# 196.删除重复的邮箱
```sql
delete Person from Person
left join (select 
min(Id) as mId
from Person group by Email ) tmp
on Id = tmp.mId where tmp.mId is null
```
- delete 后面的table不能使用别名
## 扩展，delete连表的语句
- 不可别名
- USING的使用
```sql
DELETE t1 FROM t1 LEFT JOIN T2 ON t1.id=t2.id WHERE t2.id IS NULL 

DELETE  FROM t1 USING t1 LEFT JOIN T2 ON t1.id=t2.id WHERE t2.id IS NULL 
```