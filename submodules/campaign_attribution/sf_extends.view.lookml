- view: campaign_touch
  extends: _campaign_member
  fields:
  
# dimensions #

  - dimension: touch_before_lead_converted
    type: yesno
    sql: |
      CASE 
        WHEN ${lead.converted_time} IS NOT NULL 
        THEN ${campaign_touch.created_date} <= ${lead.converted_time} 
        ELSE ${campaign_touch.created_date} <= CURRENT_DATE
      END

  - dimension: touch_before_close
    type: yesno
    sql: ${compaign_touch.created_date} <= COALESCE(${opportunity.close_date}, CURRENT_DATE)


- view: task
  extends: _task