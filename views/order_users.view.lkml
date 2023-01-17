
view: order_users {

  derived_table: {
    explore_source: order_items {
      column: user_id {}
      column: created_date {}
      column: order_id {}
      column: total_gross_revenue {}
      derived_column: sequence_number {
        sql: ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY  created_date) ;;
      }

    }
  }

  # Define your dimensions and measures here, like this:

dimension: primary_key {
    type: string
   # sql: CONCAT(CAST(${user_id} as string), CAST(${order_id} as string)) ;;
   sql: ${user_id} ;;
    primary_key: yes
    hidden: yes
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: created_date {
    type: date
    sql: ${TABLE}.created_date ;;
  }

  dimension: sequence_number {
    type: number
    sql: ${TABLE}.sequence_number ;;
  }

  dimension: days_between_orders {
    type: number
    sql: ${TABLE}.days_between_orders ;;
  }

  measure: average_days_between_orders {
    type: average
    sql:  ${days_between_orders} ;;
    value_format_name: decimal_2
  }

  dimension: is_first_purchase {
    type: yesno
    sql: ${sequence_number} = 1 ;;
  }

  dimension: has_subsequent_order {
    type: yesno
    sql: ${sequence_number} > 1  ;;
  }

 measure: 60_day_repeat_customers {
    type: count_distinct
    sql: ${user_id} ;;
    filters: [days_between_orders: " <= 60"]
  }

  measure: count_customers {
    type: count
   # sql: ${user_id} ;;
    drill_fields: [user_id]
   # filters: [has_subsequent_order: "Yes,No"]
  }

  measure: one_time_purchasers {
    type: count_distinct
    sql: ${user_id} ;;
    #drill_fields: [user_id]
    filters: [has_subsequent_order: "No"]
  }

  measure: return_purchasers {
    type: count_distinct
   sql: ${user_id} ;;
   # drill_fields: [user_id]
    filters: [has_subsequent_order: "Yes"]
  }

  measure: one_time_purchasers_percentage {
    type: number
    sql: ${one_time_purchasers} / ${count_customers} ;;
    value_format_name: percent_2
  }

  measure: return_purchasers_percentage {
    type: number
    sql: ${return_purchasers} / ${count_customers} ;;
    value_format_name: percent_2
  }

  measure: 60_day_repeat_purchase_rate {
    type: number
    sql: 1.0*${60_day_repeat_customers}/nullif(${count_customers},0);;
    value_format_name: percent_2
  }

  measure: actual_revenue {
    type: sum
    sql: ${TABLE}.total_gross_revenue ;;
    filters: [has_subsequent_order: "No"]
    value_format_name: usd
  }

  measure: return_revenue {
    type: sum
    sql: ${TABLE}.total_gross_revenue ;;
    filters: [has_subsequent_order: "Yes"]
    value_format_name: usd
  }

}
