- view: campaign_touch
  extends: _campaign_member
  fields:
  
# dimensions #

  - dimension: touch_before_lead_converted
    type: yesno
    sql: |
      CASE 
        WHEN ${lead.converted_time} IS NOT NULL 
        THEN ${_campaign_member.created_date} <= ${lead.converted_time} 
        ELSE ${_campaign_member.created_date} <= CURRENT_DATE
      END

  - dimension: touch_before_close
    type: yesno
    sql: ${_campaign_member.created_date} <= COALESCE(${opportunity.close_date}, CURRENT_DATE)


- view: task
  extends: _task
  fields: