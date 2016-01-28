- view: historical_snapshot
  derived_table:
    sql: |
      with snapshot_window as ( select opportunity_history.*
                                  , coalesce(lead(created_date,1) over(partition by opportunity_id order by created_date), current_date) as stage_end
                                from salesforce._opportunity_history AS opportunity_history
                              )
      select dates.date as observation_date
        , snapshot_window.*
      from snapshot_window
      left join ${dates.SQL_TABLE_NAME} as dates
      on dates.date >= snapshot_window.created_date
      and dates.date <= snapshot_window.stage_end
      where dates.date <= current_date
    sql_trigger_value: select current_date
    sortkeys: [observation_date]
    distkey: opportunity_id
  fields:

# dimensions #

  - dimension: id
    type: string
    primary_key: true
    sql: ${TABLE}.id

  - dimension: opportunity_id
    type: string
    hidden: true
    sql: ${TABLE}.opportunity_id

  - dimension_group: snapshot
    type: time
    description: 'What snapshot date are you interetsed in?'
    timeframes: [time, date, week, month]
    sql: ${TABLE}.observation_date

  - dimension_group: created
    type: time
    hidden: true
    timeframes: [time, date, week, month]
    sql: ${TABLE}.created_at

  - dimension: close
    type: time
    description: 'At the time of snapshot, what was the projected close date?'
    timeframes: [date, week, month]
    sql: ${TABLE}.close_date

  - dimension_group: stage_end
    type: time
    hidden: true
    timeframes: [time, date, week, month]
    sql: ${TABLE}.stage_end

  - dimension: expected_revenue
    type: number
    sql: ${TABLE}.expected_revenue

  - dimension: amount
    type: number
    sql: ${TABLE}.amount

  - dimension: stage_name
    type: string
    hidden: true
    sql: ${TABLE}.stage_name

  - dimension: stage_name_funnel
    description: 'At the time of snapshot, what funnel stage was the prospect in?'
    sql_case: 
      Lead: ${stage_name} = 'Active Lead'
      Prospect: ${stage_name} ilike '%Prospect%'
      Trial: ${stage_name} ilike '%Trial%'
      Winning:  ${stage_name} IN ('Proposal','Commit- Not Won','Negotiation')
      Won:  ${stage_name} = 'Closed Won'
      Lost: ${stage_name} ilike '%Closed%'
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

# measures #

  - measure: total_amount
    type: sum
    description: 'At the time of snapshot, what was the total projected ACV?'
    sql: ${amount}
    value_format: '$#,##0'
    drill_fields: [account.name, snapshot_date, close_date, amount, probability, stage_name_funnel]

  - measure: count_opportunities
    type: count_distinct
    sql: ${opportunity_id}

# sets #

  sets:
    detail:
      - snapshot_date
      - id
      - opportunity_id
      - expected_revenue
      - amount
      - stage_name
      - close_date
      - stage_end_date

