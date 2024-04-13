WITH Agg_submission  AS(
        SELECT
            submission_date,
            hacker_id,
            Count(*) as Submission
        FROM
            Submissions
        Group BY
            submission_date,
            hacker_id
),
Max_Submissions as (
        SELECT 
            Agg_submission.submission_date,
            MAX(Agg_submission.Submission) as max_submission    
        FROM
           Agg_submission
        GROUP BY
            Agg_submission.submission_date
),
Max_Hacker_S as (
        SELECT 
            a.submission_date,
            a.hacker_id,
            a.Submission,
            m.max_submission
        FROM
            Agg_submission as a
        LEFT JOIN 
            Max_Submissions m on a.submission_date=m.submission_date
        WHERE 
            a.Submission=m.max_submission
),
Min_Hacker_id AS ( 
        SELECT 
            submission_date,
            Submission,
            Min(hacker_id) as ID
        FROM 
            Max_Hacker_S
        Group By
            submission_date,
            Submission
),
Hacker_Submission as (
        Select 
      mh.submission_date,
      mh.Submission,
      mh.ID,
      h.name
 FROM
     Min_Hacker_id mh
LEFT JOIN 
     Hackers h on mh.ID=h.hacker_id
),

Unique_Hacker_and_Sub AS ( 
     SELECT
        DISTINCT submission_date, hacker_id
     FROM
        Submissions
    ),
Unique_Hacker_List as (
    SELECT 
        hacker_id,
        Count(*) as Unique_sub
    FROM 
        Unique_Hacker_and_Sub
    GROUP BY 
        hacker_id
    HAVING 
        Count(*) = 15
),

Total_Unique_Submission as ( 
 SELECT
  t.submission_date,
  COUNT(*) as U_Each_Day
  FROM   
 (Select 
      t1.submission_date,
      t1.hacker_id,
      (
             Select 
                COUNT(*) 
             FROM 
                Unique_Hacker_and_Sub t2 
             Where t2.hacker_id = t1.hacker_id AND
              t2.submission_date<=t1.submission_date
      ) as COUNTS,
       (SELECT DATEDIFF(day, "2016-02-29",t1.submission_date )) as DateDiff
  FROM 
    Unique_Hacker_and_Sub t1
) t
WHERE 
    t.COUNTS=t.DateDiff
GROUP BY
    t.submission_date
)

Select
hs.submission_date,
tus.U_Each_Day,
hs.ID,
hs.name
FROM
Hacker_Submission hs
LEFT JOIN 
  Total_Unique_Submission tus on hs.submission_date=tus.submission_date
order by 
hs.submission_date
  
  
 

  
