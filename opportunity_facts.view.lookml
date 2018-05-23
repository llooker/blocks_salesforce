- view: opportunity_facts
  derived_table:
    sql: |
      select account_id
        , sum(case
                when stage_name = 'Closed Won'
                then 1
                else 0
              end) as lifetime_opportunities_won
        , sum(case
                when stage_name = 'Closed Won'
                then acv
                else 0
              end) as lifetime_acv
      from salesforce._opportunity
      group by 1
    sortkeys: [account_id]
    distkey: account_id
    sql_trigger_value: select current_date
  fields:

# dimensions #

  - dimension: account_id
    type: string
    primary_key: true
    hidden: true
    sql: ${TABLE}.account_id

  - dimension: lifetime_opportunities_won
    type: number
    sql: ${TABLE}.lifetime_opportunities_won

  - dimension: lifetime_acv
    label: 'Lifetime ACV'
    type: number
    sql: ${TABLE}.lifetime_acv
