# preliminaries #

- connection: salesforce
- include: "*.view.lookml"
- include: "*.dashboard.lookml"


# views to explore——i.e., "base views" #

- explore: attribution
  joins:
    - join: campaign
      sql_on: ${attribution.campaign_id} = ${campaign.id}
      relationship: many_to_one

    - join: contact
      sql_on: ${attribution.contact_id} = ${contact.id}
      relationship: many_to_one

    - join: lead
      sql_on: ${attribution.lead_id} = ${lead.id}
      relationship: many_to_one


- explore: campaign_touch
  fields: [ALL_FIELDS*, -campaign_touch.touch_before_close]
  sql_always_where: |
    NOT ${campaign_touch.is_deleted}
  joins:
    - join: campaign
      sql_on: ${campaign_touch.campaign_id} = ${campaign.id}
      relationship: many_to_one

    - join: contact
      sql_on: ${campaign_touch.contact_id} = ${contact.id}
      relationship: many_to_one

    - join: lead
      sql_on: ${campaign_touch.lead_id} = ${lead.id}
      relationship: many_to_one