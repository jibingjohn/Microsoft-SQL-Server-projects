select * from athlete_events$


-- sport or event in which India has won highest medals

select year, event, count(Medal) Medal from athlete_events$ where Team = 'India' 
and Medal <> 'NA'
group by Event , year 
order by year desc

 -- identify sports or event played most consecutively in summer olympic games

 select event , count(Sport) Events from athlete_events$ 
 where Season = 'Summer'
 group by Event
 order by count(Sport) desc


 ---details of all countries which have won most number of silver and Bronze and at least one Gold medal

 select Team, sum(Gold) Gold , sum(Silver) Silver , sum( Bronze) Bronze from
 ( 
 select * ,
 case Medal when 'Gold' then 1 else 0 end as Gold,
 case Medal when 'Silver' then 1 else 0 end as Silver,
 case Medal when 'Bronze' then 1 else 0 end as Bronze
 from athlete_events$
 ) innerT


 group by Team
  having sum(Gold) > 1
 order by sum(Silver) desc, 
 sum(Bronze) desc

 

 -- Player who has got maximum total of Gold and silver
select Name , Team,sum(Gold) Gold ,sum(Silver) Silver , sum(Gold)+ sum(Silver) total from
(
 select * ,
 case Medal when 'Gold' then 1 else 0 end as Gold,
 case Medal when 'Silver' then 1 else 0 end as Silver,
 case Medal when 'Bronze' then 1 else 0 end as Bronze
 from athlete_events$
 ) 
 innerT
 group by Name, Team
 order by total desc


 -- Sport which has maximum events
 select Sport,count(*) Events from athlete_events$
 group by Sport
 order by count(*) desc
 select * from athlete_events$

-- Year which had maximum events
 select Year,count(Sport) Events from athlete_events$
 group by Year
 order by count(Sport) desc
