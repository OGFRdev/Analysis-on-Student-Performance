use StudentsPerformance
go 

select * from StudentsPerformance

-- 1. What is the distribution of students by gender?

select Gender, count(*) as Student_Count from StudentsPerformance
group by Gender;

-- 2. How do average scores compare between male and female?

select Gender,
avg(Math_Score) as avg_math,
avg(Reading_Score) as avg_reading,
avg(Writing_Score) as avg_writing from StudentsPerformance
group by Gender;

-- 3. Which race/ethnicity has the highest average scores?

select Race_Ethnicity,
avg(Average) as Overall_average_score from StudentsPerformance
group by Race_Ethnicity
order by Overall_average_score desc;

-- 4. Does parental level of education affect students performance?

select Parental_Level_Of_Education, 
avg(Average) as Overall_average_score from StudentsPerformance
group by Parental_Level_Of_Education
order by Overall_average_score desc;

-- 5. Do students with standard lunch perform better than those with free/reduced lunch?

select Lunch,
avg(Average) as Overall_average_score from StudentsPerformance
group by Lunch
order by Overall_average_score desc;

-- 6. Did students who took test prep perform better than those who didn’t?

select Test_Preparation_Course,
avg(Average) as Overall_average_score from StudentsPerformance
group by Test_Preparation_Course
order by Overall_average_score desc;

-- 7. Does test prep affect genders differently? 

select Gender, Test_Preparation_Course,
avg(Average) as Overall_average_score from StudentsPerformance
group by Gender, Test_Preparation_Course
order by Overall_average_score desc;

-- 8. How did students whose parents completed a Master's Degree compare with those whose parent only completed High School?

with Education_Groups as (
	select 
		Parental_Level_Of_Education, Grade, 
		count(Grade) as Number_of_Students, 
		sum(count(Grade)) over (partition by Parental_Level_Of_Education) Total_in_Education_Group 
	from StudentsPerformance
	where Parental_Level_Of_Education = 'High School'
	or Parental_Level_Of_Education = 'Master''S Degree' 
	group by Parental_Level_Of_Education, Grade
)
select Parental_Level_Of_Education as Level_Of_Education, Grade, Number_of_Students,
	round((Number_of_Students * 100 / Total_in_Education_Group), 1) as Percentage
from Education_Groups
order by Level_Of_Education, Number_of_Students desc;

-- 9. How many students scored above 90 in all three subjects? 

select count(*) as Best_Students from StudentsPerformance
where Math_Score > 90 and Reading_Score > 90 and Writing_Score > 90;

-- 10. How many students are struggling (scores < 50 in any subject)?

select count(*) as Poor_Performing from StudentsPerformance
where Math_Score < 50 and Reading_Score < 50 and Writing_Score < 50;