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

    - join: lead
      sql_on: ${the_switchboard.lead_id} = ${lead.id}
      relationship: many_to_one

    - join: opportunity
      sql_on: ${the_switchboard.opportunity_id} = ${opportunity.id}
      relationship: many_to_one  

    - join: opportunity_owner
      from: user
      sql_on: ${opportunity.owner_id} = ${opportunity_owner.id}
      relationship: many_to_one