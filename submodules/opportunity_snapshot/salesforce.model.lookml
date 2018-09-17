# preliminaries #

- connection: salesforce
- include: "*.view.lookml"
- include: "*.dashboard.lookml"


# views to explore——i.e., "base views" #

- explore: historical_snapshot    
  label: 'Historical Opportunity Snapshot'
  joins:
    - join: opportunity
      view_label: 'Current Opportunity State'
      sql_on: ${historical_snapshot.opportunity_id} = ${opportunity.id}
      type: inner
      relationship: many_to_one

    - join: account
      sql_on: ${opportunity.account_id} = ${account.id}
      relationship: many_to_one

    - join: opportunity_facts
      view_label: 'Account'
    	sql_on: ${opportunity.account_id} = ${opportunity_facts.account_id}
      relationship: many_to_one

    - join: account_owner
      from: user
      sql_on: ${account.owner_id} = ${account_owner.id}
      relationship: many_to_one       
