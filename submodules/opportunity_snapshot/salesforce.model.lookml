# preliminaries #

- connection: salesforce
- include: "*.view.lookml"
- include: "*.dashboard.lookml"


# views to explore——i.e., "base views" #

- explore: historical_snapshot    
  label: '(3) Historical Opportunity Snapshot'
  joins:
    - join: opportunity
      view_label: 'Current Opportunity State'
      sql_on: ${historical_snapshot.opportunity_id} = ${opportunity.id}
      relationship: many_to_one
      fields: [export_set*]
      type: inner