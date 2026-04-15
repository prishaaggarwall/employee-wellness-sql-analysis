# Age distribution of respondents
create table age_distribution as
with base as(
select 
case 
when age between 18 and 24 then '18-24'
when age between 25 and 34 then '25-34'
when age between 35 and 44 then '35-44'
else '45+'
end as age_group,
count(*) as no_participants 
from employee_wellness
group by age_group)
select age_group,
case when age_group = '18-24' then 'Early career'
when age_group = '25-34' then 'Young professional'
when age_group = '35-44' then 'Mid career'
else 'Senior'
end as career_stage
,no_participants, round(no_participants*100/sum(no_participants)over(),2) as percentage from base
order by 
case career_stage
when 'Early career' then 1
when 'Young professional' then 2
when 'Mid career' then 3 
else 4
end;

select * from age_distribution;

# gender distribution
select gender, count(*) as no_participants,round(count(*)*100/sum(count(*)) over(),2) as percentage from employee_wellness
group by gender;

#3. What % of respondents are self-employed?
select self_employed, count(*) as no_participants,
round(count(*) * 100/ sum(count(*)) over(),2) as percentage
from employee_wellness
group by self_employed
order by percentage desc;

#4. What % of respondents are from tech company?
select tech_company, count(*) as no_participants,
round(count(*) * 100/ sum(count(*)) over(),2) as percentage
from employee_wellness
group by tech_company
order by percentage desc;

#5. What % of respondents do remote work?
select remote_work, count(*) as no_participants,
round(count(*) * 100/ sum(count(*)) over(),2) as percentage
from employee_wellness
group by remote_work
order by percentage desc;


#Company size
select no_employees as company_size, count(*) as no_participants, round(count(*)*100/sum(count(*)) over(),2) as percentage
from employee_wellness
group by company_size
order by percentage desc;

#work interference distribution
with base as(
select work_interfere, count(*) as participants 
from employee_wellness
where work_interfere in ('often','sometimes','rarely','never')
group by work_interfere)
select work_interfere, participants,round(participants*100/sum(participants) over(),2) as percentage
from base;

#binary metric distribution of work interference
select 
case when work_interfere in ('often','sometimes')then 'interference reported' else' Little or no interfence' end as interference
, count(*) as no_participants, round(count(*)*100/sum(count(*)) over(),2) as percentage
from employee_wellness
where work_interfere in ('often','sometimes','rarely','never')
group by interference;


#benefits distribution
select benefits, count(*) as no_participants, round(count(*)*100/sum(count(*)) over(),2) as percentage
from employee_wellness
group by benefits
order by percentage desc;

#what % of respondents have a family history of mental illness
select family_history, count(*) as no_participants,
round(count(*) * 100/ sum(count(*)) over(),2) as percentage
from employee_wellness
group by family_history
order by percentage desc;

#what % of respondents gave sought treatment
select treatment, count(*) as no_participants,
round(count(*) * 100/ sum(count(*)) over(),2) as percentage
from employee_wellness
group by treatment
order by percentage desc;

select country from employee_wellness;
select country, count(*) as no_participants,
round(count(*) * 100/ sum(count(*)) over(),2) as percentage
from employee_wellness
group by country
order by percentage desc;

#How many employees know the mental health care options their employer provides?
select care_options, count(*) as no_participants,
round(count(*) * 100/ sum(count(*)) over(),2) as percentage
from employee_wellness
group by care_options
order by percentage desc;

#How often do employers actively discuss mental health through wellness programs?
select wellness_program, count(*) as no_participants,
round(count(*) * 100/ sum(count(*)) over(),2) as percentage
from employee_wellness
group by wellness_program
order by percentage desc;

#Do employees have access to educational resources about mental health?
select seek_help, count(*) as no_participants,
round(count(*) * 100/ sum(count(*)) over(),2) as percentage
from employee_wellness
group by seek_help
order by percentage desc;

#
select mental_health_consequence, count(*) as no_participants,
round(count(*) * 100/ sum(count(*)) over(),2) as percentage
from employee_wellness
group by mental_health_consequence
order by percentage desc;

#
select phys_health_consequence, count(*) as no_participants,
round(count(*) * 100/ sum(count(*)) over(),2) as percentage
from employee_wellness
group by phys_health_consequence
order by percentage desc;

select mental_vs_physical, count(*) as no_participants,
round(count(*) * 100/ sum(count(*)) over(),2) as percentage
from employee_wellness
group by mental_vs_physical
order by percentage desc;

select supervisor, count(*) as no_participants,
round(count(*) * 100/ sum(count(*)) over(),2) as percentage
from employee_wellness
group by supervisor
order by percentage desc;

select obs_consequence, count(*) as no_participants,
round(count(*) * 100/ sum(count(*)) over(),2) as percentage
from employee_wellness
group by obs_consequence
order by percentage desc;

select mental_health_interview, count(*) as no_participants,
round(count(*) * 100/ sum(count(*)) over(),2) as percentage
from employee_wellness
group by mental_health_interview
order by percentage desc;




