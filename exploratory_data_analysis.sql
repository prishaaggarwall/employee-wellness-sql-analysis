alter table employee_wellness
add column age_group varchar(30);

update employee_wellness
set age_group=
case 
when age between 18 and 24 then '18-24(Early career)'
when age between 25 and 34 then '25-34(Young professionals)'
when age between 35 and 44 then '35-44(Mid career)'
else '45+(Seniors)'
end;

select * from employee_wellness limit 10;

# which age group faces the most work interference due to mental health issues
select age_group, count(*) as no_participants,
sum(case when work_interfere in ('often','sometimes') then 1 else 0 end) as interference_Cases,
round(100*sum(case when work_interfere in ('often','sometimes') then 1 else 0 end)/count(*),2) as interference_rate
from employee_wellness
group by age_group
order by interference_rate desc;

# which age group is more likely to sought treatment
select age_group, count(*) as no_participants,
sum(case when treatment='yes' then 1 else 0 end) as yes_treatment,
round(100*sum(case when treatment='yes' then 1 else 0 end)/count(*),2) as treatment_rate
from employee_wellness
group by age_group
order by treatment_rate desc;

#Which age groups feel comfortable talking about mental health with coworkers?
with base as(
select coworkers, count(*) as participants
from employee_wellness
group by coworkers)
select coworkers, participants, round(participants*100/sum(participants) over(),2) as percentage 
from base
group by coworkers,participants;

select age_group, count(*) as participants, 
sum(case when coworkers in ('yes','some of them') then 1 else 0 end) as willing_to_discuss,
round(100*sum(case when coworkers in ('yes','some of them') then 1 else 0 end)/count(*),2) as willing_rate
from employee_wellness
group by age_group
order by willing_rate desc;

select age_group, count(*) as participants, 
sum(case when coworkers='yes' then 1 else 0 end) as willing_to_discuss,
round(100*sum(case when coworkers='yes' then 1 else 0 end)/count(*),2) as willing_rate
from employee_wellness
group by age_group
order by willing_rate desc;

## which age group is believe that discussing mental health issues will result in negative consequences 
with base as(
select mental_health_consequence, count(*) as participants from employee_wellness group by mental_health_consequence)
select mental_health_consequence,participants, round(participants*100/sum(participants) over(),2) as percentage
from base
group by mental_health_consequence,participants;

select age_group, count(*) as participants, 
sum(case when mental_health_consequence in ('yes','maybe') then 1 else 0 end) as negative_consequences,
round(100*sum(case when mental_health_consequence in ('yes','maybe') then 1 else 0 end)/count(*),2) as percentage
from employee_wellness
group by age_group
order by percentage desc;


# Does work interference differ by gender?
select gender, count(*) as no_participants,
sum(case when work_interfere in ('often','sometimes') then 1 else 0 end) as interference_cases,
round(100*sum(case when work_interfere in ('often','sometimes') then 1 else 0 end)/count(*),2) as interference_rate
from employee_wellness
where gender in ('male','female','Non-binary/other')
group by gender
order by inference_rate desc;

#Are male or female respondents more likely to seek mental health treatment?
select gender,count(*) as no_participants,
sum(Case when treatment='yes' then 1 else 0 end) as yes_treatment,
round(100*sum(Case when treatment='yes' then 1 else 0 end)/count(*),2) as treatment_rate
from employee_Wellness
group by gender;

#are male or female more likely to share with coworkers
select gender, count(*) as participants, 
sum(case when coworkers in ('yes','some of them') then 1 else 0 end) as willing_to_discuss,
round(100*sum(case when coworkers in ('yes','some of them') then 1 else 0 end)/count(*),2) as willing_rate
from employee_wellness
where gender in ('female','male','non-binary/other')
group by gender
order by willing_rate desc;

select gender, count(*) as participants, 
sum(case when coworkers='yes' then 1 else 0 end) as willing_to_discuss,
round(100*sum(case when coworkers='yes' then 1 else 0 end)/count(*),2) as willing_rate
from employee_wellness
group by gender
order by willing_rate desc;


select gender, count(*) as participants, 
sum(case when mental_health_consequence in ('yes','maybe') then 1 else 0 end) as negative_consequences,
round(100*sum(case when mental_health_consequence in ('yes','maybe') then 1 else 0 end)/count(*),2) as percentage
from employee_wellness
where gender in ('female','male','non-binary/other')
group by gender
order by percentage desc;


#Are employees experiencing work interference more likely to seek treatment?
select treatment, count(*) as no_participants,
sum(case when work_interfere in ('often','sometimes') then 1 else 0 end) as interference_cases,
round(100*sum(case when work_interfere in ('often','sometimes') then 1 else 0 end)/count(*),2) as interference_rate
from employee_wellness
group by treatment
order by interference_rate desc;

#Do employees with workplace benefits experience less work interference?
select benefits, count(*) as no_participants,
sum(case when work_interfere in ('often','sometimes') then 1 else 0 end) as interference_cases,
round(100*sum(case when work_interfere in ('often','sometimes') then 1 else 0 end)/count(*),2) as interference_rate
from employee_wellness
group by benefits
order by interference_rate desc;

#Do employees with mental health benefits seek treatment more often?
select benefits,count(*) as no_participants,
sum(Case when treatment='yes' then 1 else 0 end) as yes_treatment,
round(100*sum(Case when treatment='yes' then 1 else 0 end)/count(*),2) as treatment_rate
from employee_Wellness
group by benefits;

#Do larger companies provide mental health benefits more often?
select no_employees as company_size, benefits, count(*) as no_participants,
round(count(*)*100/sum(count(*)) over (partition by no_employees),2) as percentage
from employee_wellness
where benefits in ('no','yes',"don't know")
group by company_size, benefits
order by  percentage desc;

#company size and treatment
select no_employees as company_size,count(*) as no_participants,
sum(Case when treatment='yes' then 1 else 0 end) as yes_treatment,
round(100*sum(Case when treatment='yes' then 1 else 0 end)/count(*),2) as treatment_rate
from employee_Wellness
group by company_size
order by treatment_rate;

#Company Size vs Work Interference
select no_employees as company_Size, count(*) as no_participants,
sum(case when work_interfere in ('often','sometimes') then 1 else 0 end) as interference_cases,
round(100*sum(case when work_interfere in ('often','sometimes') then 1 else 0 end)/count(*),2) as interference_rate
from employee_wellness
group by company_size
order by interference_rate desc;

# benefits, work interfere, treatment
select benefits,treatment,count(*) as participants,
sum(case when work_interfere in ('Often','Sometimes') then 1 else 0 end) as interference_cases,
round(sum(case when work_interfere in ('Often','Sometimes')then 1 else 0 end)*100.0 / COUNT(*),2) as interference_rate
from employee_wellness
where benefits in ('Yes','No',"Don't know")
group by benefits, treatment
order by benefits, treatment;

#family history and treatment
select family_history, count(*) as participants,
sum(Case when treatment='yes' then 1 else 0 end) as yes_treatment,
round(100*sum(Case when treatment='yes' then 1 else 0 end)/count(*) ,2) as treatment_rate
from employee_Wellness
group by family_history;

select family_history,treatment,count(*) as participants,
sum(case when work_interfere in ('Often','Sometimes') then 1 else 0 end) as interference_cases,
round(sum(case when work_interfere in ('Often','Sometimes')then 1 else 0 end)*100.0 / COUNT(*),2) as interference_rate
from employee_wellness
where benefits in ('Yes','No',"Don't know")
group by family_history, treatment
order by interference_rate;

select family_history,count(*) as participants,
sum(case when work_interfere in ('Often','Sometimes') then 1 else 0 end) as interference_cases,
round(sum(case when work_interfere in ('Often','Sometimes')then 1 else 0 end)*100.0 / COUNT(*),2) as interference_rate
from employee_wellness
where benefits in ('Yes','No',"Don't know")
group by family_history
order by interference_rate;

 #does perceieved anonymity encourage treatment
select anonymity, count(*) as participants,
sum(Case when treatment='yes' then 1 else 0 end) as yes_treatment,
round(100*sum(Case when treatment='yes' then 1 else 0 end)/count(*) ,2) as treatment_rate
from employee_Wellness
group by anonymity;

#Do employees who report difficulty taking leave experience more work interference?
select `leave`,count(*) as participants,
sum(case when work_interfere in ('Often','Sometimes') then 1 else 0 end) as interference_cases,
round(sum(case when work_interfere in ('Often','Sometimes')then 1 else 0 end)*100.0 / COUNT(*),2) as interference_rate
from employee_wellness
where benefits in ('Yes','No',"Don't know")
group by `leave`
order by interference_rate;

#Do employees who know their care options seek treatment more often?
select care_options, count(*) as participants,
sum(Case when treatment='yes' then 1 else 0 end) as yes_treatment,
round(100*sum(Case when treatment='yes' then 1 else 0 end)/count(*) ,2) as treatment_rate
from employee_Wellness
group by care_options;

#company size and care options
select no_employees as company_size,care_options, count(*) as no_participants,
round(count(*)*100/sum(count(*)) over (partition by no_employees),2) as percentage
from employee_wellness
where benefits in ('no','yes',"don't know")
group by company_size, care_options
order by  percentage desc;

## workplace culture
select mental_health_consequence, count(*) as participants,
sum(Case when treatment='yes' then 1 else 0 end) as yes_treatment,
round(100*sum(Case when treatment='yes' then 1 else 0 end)/count(*) ,2) as treatment_rate
from employee_Wellness
group by mental_health_consequence;

# mental health consequences vs work interference
select mental_health_consequence,count(*) as participants,
sum(case when work_interfere in ('Often','Sometimes') then 1 else 0 end) as interference_cases,
round(sum(case when work_interfere in ('Often','Sometimes')then 1 else 0 end)*100.0 / COUNT(*),2) as interference_rate
from employee_wellness
where benefits in ('Yes','No',"Don't know")
group by mental_health_consequence
order by interference_rate;

#supervisors and work interference
select supervisor,count(*) as participants,
sum(case when work_interfere in ('Often','Sometimes') then 1 else 0 end) as interference_cases,
round(sum(case when work_interfere in ('Often','Sometimes')then 1 else 0 end)*100.0 / COUNT(*),2) as interference_rate
from employee_wellness
where benefits in ('Yes','No',"Don't know")
group by supervisor
order by interference_rate; #---> not such inference

#Do employees fear consequences because they have seen them happen?
select obs_consequence, mental_health_consequence, count(*) as participants,
round(100*count(*)/sum(count(*))over(partition by obs_consequence),2) as percentage
from employee_Wellness
group by obs_consequence, mental_health_consequence;

#Do employees in larger companies fear fewer consequences when discussing mental health?
select no_employees as company_size, mental_health_consequence, count(*) as participants,
round(100*count(*)/sum(count(*))over(partition by no_employees),2) as percentage
from employee_Wellness
group by company_size,mental_health_consequence
order by percentage;
