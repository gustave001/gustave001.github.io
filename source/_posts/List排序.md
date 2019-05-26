---
title: List排序
tags: [List,Java]
date: 2019-05-24 12:28:32
updated: 2019-05-24 12:28:32
categories: Java
---

- 最近懈怠较重，急需正反馈
- 结合Lambda,初始list
```java
    @Test
    public void testLambda() {
        List<StudentCourse> list = new ArrayList<>();
        int[][] nums = new int[][]{{1, 4, 88}, {8, 4, 7}, {8, 2, 9}, {8, 2, 88}};
        for (int i = 0; i < nums.length; i++) {
            StudentCourse course = new StudentCourse();
            course.setSid(nums[i][0]);
            course.setCid(nums[i][1]);
            course.setScore(nums[i][2]);
            list.add(course);
        }
        list.sort(Comparator.comparing(StudentCourse::getSid).reversed()
                .thenComparing((s1, s2) -> s2.getCid().compareTo(s1.getCid()))
                .thenComparing(StudentCourse::getScore));
    }
```

# 根据某个字段的值排序
```java
        list.sort((o1, o2) -> o1.getCid().compareTo(o2.getCid()));
```

# 结合Comparator,注意可以使用reversed调转
```java
list.sort(Comparator.comparing(StudentCourse::getSid).reversed());
```

# 需要根据多个字段排序
```java
        list.sort(Comparator.comparing(StudentCourse::getSid).reversed()
                .thenComparing((s1, s2) -> s2.getCid().compareTo(s1.getCid()))
                .thenComparing(StudentCourse::getScore));
```