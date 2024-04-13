/*
Enter your query here.
*/
Select
        c.contest_id,
        c.hacker_id,
        c.name,
        Sum(s.total_submissions) as Total_submission,
        Sum(s.total_accepted_submissions) as total_accepted_submission,
        SUM(v.total_views) as total_view,
        SUM(v.total_unique_views) as total_unique_view
From
        Contests c
Left Join 
        Colleges cg on c.contest_id=cg.contest_id
Left join 
        Challenges chg on cg.college_id = chg.college_id
Left Join 
        (Select
             challenge_id,
             Sum(total_views) as total_views,
             SUM(total_unique_views) as total_unique_views
         FROM
            View_Stats
         Group By 
            challenge_id
        ) v on chg.challenge_id=v.challenge_id
Left Join 
        (SELECT
            challenge_id,
            Sum(total_submissions) as total_submissions,
            SUM(total_accepted_submissions) as total_accepted_submissions
         FROM
            Submission_Stats
         Group By
            challenge_id
        ) s on chg.challenge_id = s.challenge_id
Group by 
        c.contest_id,
        c.hacker_id,
        c.name
Having 
        Sum(s.total_submissions) > 0 OR
        Sum(s.total_accepted_submissions) > 0 OR
        SUM(v.total_views) > 0 OR
         SUM(v.total_unique_views)  > 0
 Order by 
 c.contest_id;
