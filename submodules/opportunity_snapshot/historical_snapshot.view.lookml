- view: historical_snapshot
  derived_table:
    sql_trigger_value: select current_date
    sortkeys: [observation_date]
    distkey: opportunity_id
    sql: |
      WITH snapshot_window
      AS
      (SELECT opportunity_history.*
      ,COALESCE(LEAD(created_date,1) OVER (PARTITION BY opportunity_id ORDER BY created_date),getdate()) AS stage_end
      FROM salesforce._opportunity_history AS opportunity_history 
      )
      
      SELECT     dates.date AS observation_date
                ,snapshot_window.*
      
      FROM       snapshot_window
      LEFT JOIN ${dates.SQL_TABLE_NAME} as dates
                ON dates.date >= snapshot_window.created_date
                AND dates.date <= snapshot_window.stage_end
      
      WHERE dates.date <= getdate()
      AND   snapshot_window.opportunity_id not in ('006E000000PpVkjIAF-1', '006E000000LGyvPIAT-2', '006E000000LGyvPIAT-1')
      

  fields:
  
  - dimension_group: snapshot
    type: time
    description: 'What snapshot date are you interetsed in?'
    timeframes: [time, date, week, month]
    sql: ${TABLE}.observation_date

  - dimension: id
    type: string
    primary_key: true
    sql: ${TABLE}.id

  - dimension: opportunity_id
    type: string
    sql: ${TABLE}.opportunity_id

  - dimension: expected_revenue
    type: number
    sql: ${TABLE}.expected_revenue

  - dimension: amount
    type: number
    sql: ${TABLE}.amount
    
  - measure: total_amount
    type: sum
    description: 'At the time of snapshot, what was the total projected ACV?'
    sql: ${amount}
    value_format: '$#,##0'
    drill_fields: [account.name, snapshot_date, close_date, amount, probability, stage_name_funnel]

  - dimension: stage_name
    type: string
    hidden: true
    sql: ${TABLE}.stage_name

  - dimension: stage_name_funnel
    description: 'At the time of snapshot, what funnel stage was the prospect in?'
    sql_case: 
      Lead: ${stage_name} IN ('Active Lead')
      Prospect: ${stage_name} like '%Prospect%'
      Trial: ${stage_name} like '%Trial%'
      Winning:  ${stage_name} IN ('Proposal','Commit- Not Won','Negotiation')
      Won:  ${stage_name} IN ('Closed Won')
      Lost: ${stage_name} like '%Closed%' 
      Unknown: true

  - dimension: probability
    type: number
    sql: ${TABLE}.probability
  
  - dimension: probability_tier
    sql_case:
      'Won': ${probability} = 100
      '80 - 99%': ${probability} >= 80
      '60 - 79%': ${probability} >= 60
      '40 - 59%': ${probability} >= 40
      '20 - 39%': ${probability} >= 20
      '1 - 19%': ${probability} > 0
      'Lost': ${probability} = 0

  - dimension_group: created
    type: time
    hidden: true
    timeframes: [time, date, week, month]
    sql: ${TABLE}.created_at

  - dimension: close
    type: time
    description: 'At the time of snapshot, what was the projected close date?'
    timeframes: [date, week, month]
    sql:  to_date (${TABLE}.close_date, 'YYYY-MM-DD')
#     sql: ${TABLE}.close_date

  - dimension_group: stage_end
    type: time
    hidden: true
    timeframes: [time, date, week, month]
    sql: ${TABLE}.stage_end
    
  - measure: count_opportunities
    type: count_distinct
    sql: ${opportunity_id}
  

  sets:
    detail:
      - observation_date_time
      - id
      - opportunity_id
      - expected_revenue
      - amount
      - stage_name
      - created_at_time
      - close_date
      - stage_end_time

