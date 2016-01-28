- view: the_switchboard
  derived_table:
    sql: |
      with first_pass as (select 
                            -- company fields
                            regexp_replace(trim(both ' ' from regexp_replace(lower(coalesce(account.name, lead.company)), '(\.|,|\s)(inc|ltd|llc|llp|incorporated)+[^a-zA-Z]*$', '')), '[[:punct:]]', '') as company_name
                            , case
                                when opportunity.is_closed 
                                and opportunity.is_won
                                then true
                                else false
                              end as is_customer
                            -- lead fields
                            , lead.id AS lead_id
                            , lead.created_date AS lead_created_date
                            -- account fields
                            , account.id AS account_id
                            , account.created_date AS account_created_date
                            -- contact fields
                            , contact.id AS contact_id
                            , contact.created_date AS contact_created_date
                            -- opportunity fields
                            , opportunity.id AS opportunity_id
                            , opportunity.created_date AS opportunity_created_date
                            , opportunity.close_date AS opportunity_closed_date
                            , opportunity.is_won AS opportunity_is_won
                            , opportunity.is_closed AS opportunity_is_closed
                          from salesforce._lead as lead
                          left join salesforce._account as account
                          on lead.converted_account_id = account.id
                          left join salesforce._contact as contact
                          on 
                            case
                              when lead.converted_contact_id is not null
                              then lead.converted_contact_id = contact.id
                              else account.id = contact.account_id
                            end
                          left join salesforce._opportunity as opportunity
                          on opportunity.id = lead.converted_opportunity_id
                        )
      select company_name
        , case
            when company_name IN (select company_name from first_pass where is_customer)
            then 'Customer'
            else 'Prospect'
          end as company_type
        , first_value(account_id) over(partition by company_name order by account_created_date rows between unbounded preceding and unbounded following) as account_id
        , lead_id
        , contact_id
        , opportunity_id
      from first_pass
    sql_trigger_value: select current_date
    distkey: opportunity_id
    sortkeys: [company_name, opportunity_id]
  fields:

# dimensions #

  - dimension: company_name
    type: string
    sql: ${TABLE}.company_name

  - dimension: company_type
    type: string
    sql: ${TABLE}.company_type

  - dimension: account_id
    type: string
    hidden: true
    sql: ${TABLE}.account_id

  - dimension: lead_id
    type: string
    hidden: true
    sql: ${TABLE}.lead_id

  - dimension: contact_id
    type: string
    hidden: true
    sql: ${TABLE}.contact_id

  - dimension: opportunity_id
    type: string
    hidden: true
    sql: ${TABLE}.opportunity_id

# measures #

  - measure: count
    type: count
    drill_fields: detail*

# sets #

  sets:
    detail:
      - company_name
      - company_type
      - account_id
      - lead_id
      - contact_id
      - opportunity_id

