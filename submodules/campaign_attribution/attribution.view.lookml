- view: who_meeting
  derived_table:
    sql: |
      select who_id
        , max(created_date) as meeting_date
      from salesforce._task
      where type = 'Intro Meeting'
      group by 1


- view: touches_before_meeting
  derived_table:
    sql: |
      select coalesce(a.name, l.company) as company_name
        , md5(regexp_replace(trim(both ' ' from regexp_replace(lower(coalesce(a.name, l.company)), '(\.|,|\s)(inc|ltd|llc|llp|incorporated)+[^a-zA-Z]*$', '')), '[[:punct:]]', '')) as company_id
        , cm.id as campaign_touch_id
        , cm.campaign_id
        , cm.created_date
        , datediff(day, lag(cm.created_date, 1) over(partition by md5(regexp_replace(trim(both ' ' from regexp_replace(lower(coalesce(a.name, l.company)), '(\.|,|\s)(inc|ltd|llc|llp|incorporated)+[^a-zA-Z]*$', '')), '[[:punct:]]', '')) order by cm.created_date), cm.created_date) as days_between_touches
        , datediff(day, last_value(coalesce(contact_meeting.meeting_date, lead_meeting.meeting_date) ignore nulls) over(partition by md5(regexp_replace(trim(both ' ' from regexp_replace(lower(coalesce(a.name, l.company)), '(\.|,|\s)(inc|ltd|llc|llp|incorporated)+[^a-zA-Z]*$', '')), '[[:punct:]]', '')) order by coalesce(contact_meeting.meeting_date, lead_meeting.meeting_date) rows between unbounded preceding and unbounded following), cm.created_date) as days_from_meeting
        , cm.lead_id
        , cm.contact_id
        , last_value(coalesce(contact_meeting.meeting_date, lead_meeting.meeting_date) ignore nulls) over(partition by md5(regexp_replace(trim(both ' ' from regexp_replace(lower(coalesce(a.name, l.company)), '(\.|,|\s)(inc|ltd|llc|llp|incorporated)+[^a-zA-Z]*$', '')), '[[:punct:]]', '')) order by coalesce(contact_meeting.meeting_date, lead_meeting.meeting_date) rows between unbounded preceding and unbounded following) as meeting_date
      from salesforce._campaign_member as cm
      left join salesforce._lead as l
      on cm.lead_id = l.id
      left join salesforce._contact as c
      on cm.contact_id = c.id
      left join salesforce._account as a
      on c.account_id = a.id
      left join ${who_meeting.SQL_TABLE_NAME} as lead_meeting
      on lead_meeting.who_id = cm.lead_id
      left join ${who_meeting.SQL_TABLE_NAME} as contact_meeting
      on contact_meeting.who_id = cm.contact_id
      where not cm.is_deleted


- view: session_boundaries
  derived_table:
    sql: |
      select company_id
        , created_date as session_start
        , lead(created_date, 1) over(partition by company_id order by created_date) as next_session_start
        , row_number() over(partition by company_id order by created_date) as company_session
      from ${touches_before_meeting.SQL_TABLE_NAME}
      where days_between_touches > 30 or days_between_touches is null
    
    
- view: attribution
  derived_table:
    sql: |
      select row_number() over(order by 1) as id
        , touches_before_meeting.*
        , session_boundaries.company_session
        , last_value(case when touches_before_meeting.created_date <= touches_before_meeting.meeting_date then session_boundaries.company_session else null end ignore nulls) over(partition by touches_before_meeting.company_id order by touches_before_meeting.created_date rows between unbounded preceding and unbounded following) AS session_before_meeting
      from ${touches_before_meeting.SQL_TABLE_NAME} as touches_before_meeting
      left join ${session_boundaries.SQL_TABLE_NAME} as session_boundaries
      on touches_before_meeting.company_id = session_boundaries.company_id
      and (touches_before_meeting.created_date between session_boundaries.session_start and session_boundaries.next_session_start)
    sql_trigger_value: select current_date
    distkey: company_id
    sortkeys: [company_id]
  fields:

# dimensions #  

  - dimension: id
    primary_key: true
    type: number
    value_format_name: id
    sql: ${TABLE}.id

  - dimension: company_id
    type: number
    value_format_name: id
    sql: ${TABLE}.company_id

  - dimension: campaign_touch_id
    type: number
    hidden: true
    sql: ${TABLE}.campaign_touch_id

  - dimension: campaign_id
    type: number
    hidden: true
    sql: ${TABLE}.campaign_id

  - dimension: lead_id
    type: number
    hidden: true
    sql: ${TABLE}.lead_id

  - dimension: contact_id
    type: number
    hidden: true
    sql: ${TABLE}.contact_id

  - dimension: company_name
    type: string
    sql: ${TABLE}.company_name

  - dimension: created
    type: time
    timeframes: [date]
    sql: ${TABLE}.created_date

  - dimension: days_between_touches
    type: number
    sql: ${TABLE}.days_between_touches

  - dimension: days_from_meeting
    type: number
    sql: ${TABLE}.days_from_meeting

  - dimension: company_session
    type: number
    sql: ${TABLE}.company_session

  - dimension: session_before_meeting
    type: string
    sql: ${TABLE}.session_before_meeting

# measures #

  - measure: company_count
    type: count_distinct
    sql: ${company_id}

  - measure: lead_count
    type: count_distinct
    sql: ${lead_id}

  - measure: contact_count
    type: count_distinct
    sql: ${contact_id}