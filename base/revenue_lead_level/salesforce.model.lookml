# preliminaries #

- connection: salesforce
- include: "*.view.lookml"
- include: "*.dashboard.lookml"


# views to explore——i.e., "base views" #

- explore: account
  joins:
    - join: account_owner
      from: user
      sql_on: ${account.owner_id} = ${account_owner.id}
      relationship: many_to_one


- explore: lead
  joins:
    - join: account
      sql_on: ${lead.converted_account_id} = ${account.id}
      relationship: many_to_one

    - join: account_owner
      from: user
      sql_on: ${account.owner_id} = ${account_owner.id}
      relationship: many_to_one

    - join: contact
      sql_on: ${lead.converted_contact_id} = ${contact.id}
      relationship: many_to_one

    - join: opportunity
      sql_on: ${lead.converted_opportunity_id} = ${opportunity.id}
      relationship: many_to_one

    - join: opportunity_owner
      from: user
      sql_on: ${opportunity.owner_id} = ${opportunity_owner.id}
      relationship: many_to_one       


- explore: opportunity
  joins:
    - join: account
      sql_on: ${opportunity.account_id} = ${account.id}
      relationship: many_to_one

    - join: account_owner
      from: user
      sql_on: ${account.owner_id} = ${account_owner.id}
      relationship: many_to_one 

    - join: campaign
      sql_on: ${opportunity.campaign_id} = ${campaign.id}
      relationship: many_to_one

    - join: opportunity_owner
      from: user
      sql_on: ${opportunity.owner_id} = ${opportunity_owner.id}
      relationship: many_to_one