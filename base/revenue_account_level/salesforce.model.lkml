# preliminaries #

connection: "salesforce"

include: "*.view"

include: "*.dashboard"

# views to explore——i.e., "base views" #

explore: account {
  sql_always_where: NOT ${account.is_deleted}
    ;;
  fields: [ALL_FIELDS*, -account_owner.opportunity_set*, -creator.opportunity_set*]

  join: contact {
    sql_on: ${account.id} = ${contact.account_id} ;;
    relationship: one_to_many
  }

  join: creator {
    from: user
    sql_on: ${contact.created_by_id} = ${creator.id} ;;
    relationship: many_to_one
  }

  join: account_owner {
    from: user
    sql_on: ${account.owner_id} = ${account_owner.id} ;;
    relationship: many_to_one
  }
}

explore: lead {
  sql_always_where: NOT ${lead.is_deleted}
    ;;

  join: lead_owner {
    from: user
    sql_on: ${lead.owner_id} = ${lead_owner.id} ;;
    relationship: many_to_one
  }

  join: account {
    sql_on: ${lead.converted_account_id} = ${account.id} ;;
    relationship: many_to_one
  }

  join: account_owner {
    from: user
    sql_on: ${account.owner_id} = ${account_owner.id} ;;
    relationship: many_to_one
  }

  join: contact {
    sql_on: ${lead.converted_contact_id} = ${contact.id} ;;
    relationship: many_to_one
  }

  join: opportunity {
    sql_on: ${lead.converted_opportunity_id} = ${opportunity.id} ;;
    relationship: many_to_one
  }

  join: opportunity_owner {
    from: user
    sql_on: ${opportunity.owner_id} = ${opportunity_owner.id} ;;
    relationship: many_to_one
  }
}

explore: opportunity {
  sql_always_where: NOT ${opportunity.is_deleted}
    ;;

  join: account {
    sql_on: ${opportunity.account_id} = ${account.id} ;;
    relationship: many_to_one
  }

  join: account_owner {
    from: user
    sql_on: ${account.owner_id} = ${account_owner.id} ;;
    relationship: many_to_one
  }

  join: campaign {
    sql_on: ${opportunity.campaign_id} = ${campaign.id} ;;
    relationship: many_to_one
  }

  join: opportunity_owner {
    from: user
    sql_on: ${opportunity.owner_id} = ${opportunity_owner.id} ;;
    relationship: many_to_one
  }
}