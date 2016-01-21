- view: opportunity_facts
  derived_table:
    sql: |
      SELECT account_id AS account_id
        , SUM(CASE
                WHEN stage_name = 'Closed Won'
                THEN 1
                ELSE 0
              END) AS opportunities_won
        , SUM(CASE
                WHEN stage_name = 'Closed Won'
                THEN acv
                ELSE 0
              END) AS all_time_acv
      FROM salesforce._opportunity
      GROUP BY 1
    sortkeys: [account_id]
    distkey: account_id
    sql_trigger_value: SELECT CURRENT_DATE
  fields:
  
# DIMENSIONS #

  - dimension: account_id
    hidden: true
    primary_key: true
    sql: ${TABLE}.account_id

  - dimension: lifetime_opportunities_won
    type: number
    sql: ${TABLE}.opportunities_won

  - dimension: lifetime_acv
    label: 'Lifetime ACV'
    type: number
    sql: ${TABLE}.all_time_acv
