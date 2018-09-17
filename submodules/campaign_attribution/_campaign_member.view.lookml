- view: _campaign_member
  sql_table_name: salesforce._campaign_member
  fields:

# dimensions #

  - dimension: id
    primary_key: true
    type: string
    sql: ${TABLE}.id

  - dimension: campaign_id
    type: string
    hidden: true
    sql: ${TABLE}.campaign_id

  - dimension: contact_id
    type: string
    hidden: true
    sql: ${TABLE}.contact_id

  - dimension: created_by_id
    type: string
    sql: ${TABLE}.created_by_id

  - dimension_group: created
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.created_date

  - dimension_group: first_responded
    type: time
    timeframes: [date, week, month]
    convert_tz: false
    sql: ${TABLE}.first_responded_date

  - dimension: has_responded
    type: yesno
    sql: ${TABLE}.has_responded

  - dimension: is_deleted
    type: yesno
    sql: ${TABLE}.is_deleted

  - dimension: last_modified_by_id
    type: string
    sql: ${TABLE}.last_modified_by_id

  - dimension_group: last_modified
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.last_modified_date

  - dimension: lead_id
    type: string
    hidden: true
    sql: ${TABLE}.lead_id

  - dimension: status
    type: string
    sql: ${TABLE}.status

  - dimension_group: system_modstamp
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.system_modstamp

# measures #

  - measure: count
    type: count
    drill_fields: [id, lead.last_name, lead.first_name, lead.name, lead.id]