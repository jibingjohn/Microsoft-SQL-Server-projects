select * from IndiaCensus..Data1$


-- number of rows
select count (*) from Data1$
select count (*) from Data2



-- dataset for kerala and bihar


select * from Data1$ where State in ('Kerala' , 'Bihar')


-- total population


select * from IndiaCensus..Data2
select sum(Population) as ' Total Population' from Data2



-- average growth


select * from Data1$
select AVG(Growth)*100 as 'Average Growth' from Data1$



-- avg growth statewise


select State, AVG(Growth)*100 as 'Average Growth' from Data1$ group by State
select State, round(AVG(Sex_Ratio),3) as 'Average Sex Ratio' from Data1$ group by State order by 'Average Sex Ratio' DESC;


-- top 3 states showing highesy growth rate


select top 3 State, AVG(Growth)*100 as 'Average Growth' from Data1$ group by State order by 'Average Growth' desc
select  top 5 State, AVG(Literacy) as 'Average Literacy' from Data1$ group by State order by 'Average Literacy' asc

top and bottom 3 states 
select  top 5 State, AVG(Literacy) as 'Average Literacy' from Data1$ group by State order by 'Average Literacy' asc

create table #top
( State nvarchar(255),
topstates float
)

insert into #top
select State, round(AVG(Literacy),0) as 'Average Literacy' from IndiaCensus..Data1$ group by State order by 'Average Literacy' desc;

select top 4 * from #top order by #top.topstates desc;



--bottom

create table #bottom
( State nvarchar(255),
botstates float
)

insert into #bottom
select State, round(AVG(Literacy),0) as 'Average Literacy' from IndiaCensus..Data1$ group by State order by 'Average Literacy' desc;

select top 5 * from #bottom order by #bottom.botstates asc;




--for union no. of rows same

select * from (
select top 8 * from #top order by #top.topstates desc ) a
union
select * from (
select top 8 * from #bottom order by #bottom.botstates asc) b;



--states starting with "a"

select distinct state from IndiaCensus..Data1$ where State like 'a%' or state like '%i';

---joining tables
select d.state, sum(d.males) total_males, sum(d.females) total_females from
(select c.District, c.state, round(c.population / (c.Sex_Ratio +1 ),0) males,round(( c.Population * c.Sex_Ratio)/(c.Sex_Ratio + 1),0) females from 
(select a.District, a.state, a.Sex_Ratio/1000 Sex_Ratio, b.population from IndiaCensus..Data1$ a inner join IndiaCensus..Data2 b on a.district = b.District)c)d
group by d.state;



--total literacy rate

select c.state, sum(literate_ppl) total_LP, sum(illiterate_people) total_ILP from
(select d.district,d.state,round(d.literacy_ratio*d.population,0) literate_ppl, round((1- d.literacy_ratio) * d.population,0) illiterate_people from
(select a.district, a.state, a.literacy/100 literacy_ratio, b.population from IndiaCensus..Data1$ a inner join IndiaCensus..Data2 b on a.district = b.District) d
) c
group by c.state
 

--- population in previous census


select  sum(Total_PP) Total_2021 , sum(Total_CP) Total_2022 from
(
select d.state, sum(d.prev_population) Total_PP, sum(d.Current_population) Total_CP from
(
select c.district, c.state, round((c.population/((c.growth)+1)),0) prev_population, c.Population Current_population, c.growth Growth from
(
select a.district, a.state, a.Growth growth, b.population from IndiaCensus..Data1$ a 
inner join IndiaCensus..Data2 b on a.district = b.District ) c ) d
group by d.state) e


-- population vs area


select j.Total_Area/ j.Total_2021 A, j.Total_Area / j.Total_2022 B from
(
select h.*, i.Total_Area from
(
select '1' as new, f.* from
(
select sum(Area_km2) Total_Area from IndiaCensus..Data2) f)h inner join

(
select '1' as new, g.* from
(
select  sum(Total_PP) Total_2021 , sum(Total_CP) Total_2022 from
(
select d.state, sum(d.prev_population) Total_PP, sum(d.Current_population) Total_CP from
(
select c.district, c.state, round((c.population/((c.growth)+1)),0) prev_population, c.Population Current_population, c.growth Growth from
(
select a.district, a.state, a.Growth growth, b.population from IndiaCensus..Data1$ a 
inner join IndiaCensus..Data2 b on a.district = b.District ) c ) d
group by d.state)e) g) i on h.new = i.new
)j



-- window function

-- top 3 districts from each state with high literacy rate
output top 3 districts from each state with highest literacy rate
select a.*  from 
(
select district, state, literacy, rank() over( partition by state order by literacy desc) rank from IndiaCensus..Data1$
  ) a

where a.rank in (1,2,3) order by state