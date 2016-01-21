- explore: the_switchboard
  view_label: 'Company'
  joins:
    - join: account
      sql_on: ${the_switchboard.account_id} = ${account.id}
      relationship: many_to_one

    - join: account_owner
      from: user
      sql_on: ${account.owner_id} = ${account_owner.id}
      relationship: many_to_one

    - join: contact
      sql_on: ${the_switchboard.contact_id} = ${contact.id}
      relationship: many_to_one  

    - join: attributable_contact
      from: contact
      sql_on: ${the_switchboard.attributable_contact_id} = ${attributable_contact.id}
      relationship: many_to_one

    - join: campaign
      sql_on: ${the_switchboard.campaign_id} = ${campaign.id}
      relationship: many_to_one

    - join: first_campaign
      from: campaign
      sql_on: ${the_switchboard.attributable_campaign_id} = ${first_campaign.id}
      relationship: many_to_one

    - join: prior_campaign
      from: campaign
      sql_on: ${the_switchboard.prior_campaign_id} = ${prior_campaign.id}
      relationship: many_to_one

    - join: modified_first_campaign
      from: campaign
      sql_on: ${the_switchboard.modified_first_campaign_id} = ${modified_first_campaign.id}
      relationship: many_to_one

    - join: lead
      sql_on: ${the_switchboard.lead_id} = ${lead.id}
      relationship: many_to_one

    - join: attributable_lead
      from: lead
      sql_on: ${the_switchboard.attributable_lead_id} = ${attributable_lead.id}
      relationship: many_to_one

    - join: opportunity
      sql_on: ${the_switchboard.opportunity_id} = ${opportunity.id}
      relationship: many_to_one  

    - join: opportunity_owner
      from: user
      sql_on: ${opportunity.owner_id} = ${opportunity_owner.id}
      relationship: many_to_one

    - join: meeting
      sql_on: ${the_switchboard.meeting_id} = ${meeting.id}
      relationship: many_to_one