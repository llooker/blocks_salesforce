
connection: "salesforce"

include: "*.view"

include: "*.dashboard"



explore: historical_snapshot {
  label: "Historical Opportunity Snapshot"

  join: opportunity {
    view_label: "Current Opportunity State"
    sql_on: ${historical_snapshot.opportunity_id} = ${opportunity.id} ;;
    type: inner
    relationship: many_to_one
  }

  join: account {
    sql_on: ${opportunity.account_id} = ${account.id} ;;
    relationship: many_to_one
  }

  join: account_owner {
    from: user
    sql_on: ${account.owner_id} = ${account_owner.id} ;;
    relationship: many_to_one
  }

  join: opportunity_facts {
    view_label: "Account"
    sql_on: ${opportunity.account_id} = ${opportunity_facts.account_id} ;;
    relationship: many_to_one
  }
}