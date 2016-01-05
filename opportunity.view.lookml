- view: opportunity
  sql_table_name: salesforce._opportunity
  fields:

# dimensions #

  - dimension: id
    primary_key: true
    type: string
    sql: ${TABLE}.id

  - dimension: account_id
    type: string
    hidden: true
    sql: ${TABLE}.account_id

  - dimension: amount
    type: number
    sql: ${TABLE}.amount

  - dimension: campaign_id
    type: string
    hidden: true
    sql: ${TABLE}.campaign_id
    
  - dimension_group: close
    type: time
    timeframes: [date, week, month]
    convert_tz: false
    sql: ${TABLE}.close_date

  - dimension: created_by_id
    type: string
    hidden: true
    sql: ${TABLE}.created_by_id

  - dimension_group: created
    type: time
    timeframes: [date, week, month]
    sql: ${TABLE}.created_date

  - dimension: description
    type: string
    sql: ${TABLE}.description

  - dimension: fiscal
    type: string
    sql: ${TABLE}.fiscal

  - dimension: fiscal_quarter
    type: number
    sql: ${TABLE}.fiscal_quarter

  - dimension: fiscal_year
    type: number
    sql: ${TABLE}.fiscal_year

  - dimension: forecast_category
    type: string
    sql: ${TABLE}.forecast_category

  - dimension: forecast_category_name
    type: string
    sql: ${TABLE}.forecast_category_name

  - dimension: has_opportunity_line_item
    type: yesno
    sql: ${TABLE}.has_opportunity_line_item

  - dimension: is_closed
    type: yesno
    sql: ${TABLE}.is_closed

  - dimension: is_deleted
    type: yesno
    sql: ${TABLE}.is_deleted

  - dimension: is_won
    type: yesno
    sql: ${TABLE}.is_won

  - dimension_group: last_activity
    type: time
    timeframes: [date, week, month]
    convert_tz: false
    sql: ${TABLE}.last_activity_date

  - dimension: last_modified_by_id
    type: string
    hidden: true
    sql: ${TABLE}.last_modified_by_id

  - dimension_group: last_modified
    type: time
    timeframes: [date, week, month]
    sql: ${TABLE}.last_modified_date

  - dimension_group: last_referenced
    type: time
    timeframes: [date, week, month]
    sql: ${TABLE}.last_referenced_date

  - dimension_group: last_viewed
    type: time
    timeframes: [date, week, month]
    sql: ${TABLE}.last_viewed_date

  - dimension: lead_source
    type: string
    sql: ${TABLE}.lead_source

  - dimension: name
    type: string
    sql: ${TABLE}.name

  - dimension: owner_id
    type: string
    hidden: true
    sql: ${TABLE}.owner_id

  - dimension: pricebook_2_id
    type: string
    hidden: true
    sql: ${TABLE}.pricebook_2_id

  - dimension: probability
    type: number
    sql: ${TABLE}.probability

  - dimension: stage_name
    type: string
    sql: ${TABLE}.stage_name

  - dimension: synced_quote_id
    type: string
    hidden: true
    sql: ${TABLE}.synced_quote_id

  - dimension_group: system_modstamp
    type: time
    timeframes: [date, week, month]
    sql: ${TABLE}.system_modstamp

  - dimension: type
    type: string
    sql: ${TABLE}.type
    
  - dimension: days_open
    type: number
    sql: datediff(days, ${created_date}, coalesce(${close_date}, current_date) ) 
    
  - dimension:  created_to_closed_in_60 
    hidden: true
    type: yesno
    sql: ${days_open} <=60 AND ${is_closed} = 'yes' AND ${is_won} = 'yes'    

# measures #

  - measure: count
    type: count
    drill_fields: [id, name, stage_name, forecast_category_name]
  
  - measure: count_won
    type: count
    filters:
      is_won: Yes
    drill_fields: [opportunity.id, account.name, type]
    
  - measure: average_days_open
    type: avg
    sql: ${days_open}
    
  - measure: count_closed
    type: count
    filters: 
      is_closed: Yes
      
  - measure: count_open
    type: count
    filters:
      is_closed: No
    
  - measure: count_lost
    type: count
    filters:
      is_closed: Yes
      is_won: No
    drill_fields: [opportunity.id, account.name, type] 

  - measure: win_percentage
    type: number
    sql: 100.00 * ${count_won} / NULLIF(${count}, 0)
    value_format: '#0.00\%'
    
  - measure: open_percentage
    type: number
    sql: 100.00 * ${count_open} / NULLIF(${count}, 0)
    value_format: '#0.00\%'