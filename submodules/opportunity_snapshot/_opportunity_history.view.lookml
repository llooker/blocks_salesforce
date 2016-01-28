- view: _opportunity_history
  sql_table_name: salesforce._opportunity_history
  fields:

# dimensions #

  - dimension: id
    primary_key: true
    sql: ${TABLE}.id

  - dimension: amount
    type: number
    sql: ${TABLE}.amount

  - dimension_group: close
    type: time
    timeframes: [date, week, month]
    convert_tz: false
    sql: ${TABLE}.close_date

  - dimension: created_by_id
    hidden: true
    sql: ${TABLE}.created_by_id

  - dimension_group: created
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.created_date

  - dimension: expected_revenue
    type: number
    sql: ${TABLE}.expected_revenue

  - dimension: forecast_category
    type: string
    sql: ${TABLE}.forecast_category

  - dimension: is_deleted
    type: yesno
    sql: ${TABLE}.is_deleted

  - dimension: opportunity_id
    type: string
    hidden: true
    sql: ${TABLE}.opportunity_id

  - dimension: probability
    type: number
    sql: ${TABLE}.probability

  - dimension: stage_name
    type: string
    sql: ${TABLE}.stage_name

  - dimension_group: system_modstamp
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.system_modstamp

# measures #

  - measure: count
    type: count
    drill_fields: [id, stage_name]

