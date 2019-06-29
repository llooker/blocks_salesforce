view: historical_snapshot {
  derived_table: {
    sql: with snapshot_window as ( select opportunity_history.*
                            , coalesce(lead(created_date,1) over(partition by opportunity_id order by created_date), current_date) as stage_end
                          from salesforce._opportunity_history AS opportunity_history
                        )
select dates.date as observation_date
  , snapshot_window.*
from snapshot_window
left join ${dates.SQL_TABLE_NAME} as dates
on dates.date >= snapshot_window.created_date
and dates.date <= snapshot_window.stage_end
where dates.date <= current_date
 ;;
    sql_trigger_value: select current_date ;;
    sortkeys: ["observation_date"]
    distribution: "opportunity_id"
  }

  # dimensions #

  dimension: id {
    type: string
    primary_key: yes
    sql: ${TABLE}.id ;;
  }

  dimension: opportunity_id {
    type: string
    hidden: yes
    sql: ${TABLE}.opportunity_id ;;
  }

  dimension_group: snapshot {
    type: time
    description: "What snapshot date are you interetsed in?"
    timeframes: [time, date, week, month]
    sql: ${TABLE}.observation_date ;;
  }

  dimension_group: created {
    type: time
    hidden: yes
    timeframes: [time, date, week, month]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: close {
    type: time
    description: "At the time of snapshot, what was the projected close date?"
    timeframes: [date, week, month]
    sql: ${TABLE}.close_date ;;
  }

  dimension_group: stage_end {
    type: time
    hidden: yes
    timeframes: [time, date, week, month]
    sql: ${TABLE}.stage_end ;;
  }

  dimension: expected_revenue {
    type: number
    sql: ${TABLE}.expected_revenue ;;
  }

  dimension: amount {
    type: number
    sql: ${TABLE}.amount ;;
  }

  dimension: stage_name {
    type: string
    hidden: yes
    sql: ${TABLE}.stage_name ;;
  }

  dimension: stage_name_funnel {
    description: "At the time of snapshot, what funnel stage was the prospect in?"

    case: {
      when: {
        sql: ${stage_name} = 'Active Lead' ;;
        label: "Lead"
      }

      when: {
        sql: ${stage_name} ilike '%Prospect%' ;;
        label: "Prospect"
      }

      when: {
        sql: ${stage_name} ilike '%Trial%' ;;
        label: "Trial"
      }

      when: {
        sql: ${stage_name} IN ('Proposal','Commit- Not Won','Negotiation') ;;
        label: "Winning"
      }

      when: {
        sql: ${stage_name} = 'Closed Won' ;;
        label: "Won"
      }

      when: {
        sql: ${stage_name} ilike '%Closed%' ;;
        label: "Lost"
      }

      when: {
        sql: true ;;
        label: "Unknown"
      }
    }
  }

  dimension: probability {
    type: number
    sql: ${TABLE}.probability ;;
  }

  dimension: probability_tier {
    case: {
      when: {
        sql: ${probability} = 100 ;;
        label: "Won"
      }

      when: {
        sql: ${probability} >= 80 ;;
        label: "80 - 99%"
      }

      when: {
        sql: ${probability} >= 60 ;;
        label: "60 - 79%"
      }

      when: {
        sql: ${probability} >= 40 ;;
        label: "40 - 59%"
      }

      when: {
        sql: ${probability} >= 20 ;;
        label: "20 - 39%"
      }

      when: {
        sql: ${probability} > 0 ;;
        label: "1 - 19%"
      }

      when: {
        sql: ${probability} = 0 ;;
        label: "Lost"
      }
    }
  }

  # measures #

  measure: total_amount {
    type: sum
    description: "At the time of snapshot, what was the total projected ACV?"
    sql: ${amount} ;;
    value_format: "$#,##0"
    drill_fields: [
      account.name,
      snapshot_date,
      close_date,
      amount,
      probability,
      stage_name_funnel
    ]
  }

  measure: count_opportunities {
    type: count_distinct
    sql: ${opportunity_id} ;;
  }

  # sets #

  set: detail {
    fields: [
      snapshot_date,
      id,
      opportunity_id,
      expected_revenue,
      amount,
      stage_name,
      close_date,
      stage_end_date
    ]
  }
}