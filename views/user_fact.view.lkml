view: user_fact {

# native derived table to capture summary level info about each customer, the number of orders he made,
# the earliest and latest time items within each order were ordered, and the revenue generated from each order

  derived_table: {
    explore_source: order_items {
      column: user_id {}
      column: count_orders {}
      column: min_order_date {}
      column: max_order_date {}
      column: total_gross_revenue {}
    }
  }

  dimension: user_id {
    primary_key: yes
    description: "Unique identifier of the user or customer who made the order"
    hidden: yes

  }


dimension: count_orders {
    type: number
    sql: count_orders ;;
    value_format_name: decimal_0
  }

  dimension: count_orders_tiers {
    description: "Distribution of customer across different number of orders"
    label: "Number of Orders Groups"
    type: tier
    tiers: [1, 2, 3, 6, 10]
    sql: ${count_orders} ;;
    style: integer
  }

  dimension: revenue_tiers {
    description: "Distribution of customer across different revenue brackets"
    label: "Revenue Brackets"
    type: tier
    tiers: [5, 20, 50, 100, 500, 1000]
    sql: total_gross_revenue ;;
    style: integer
    value_format_name: usd_0
  }

  dimension: is_active_user {
    description: "A customer is active if purchased from the website within the last 90 days"
    type: yesno
    sql: date_diff(current_timestamp, max_order_date, day) <= 90 ;;
  }

  dimension: days_since_last_order {
    description: "Number of days since the last order"
    type: number
    sql: date_diff(current_timestamp, max_order_date, day) ;;
  }

  dimension: is_repeat_customer {
    description: "A Repeat Customer purchased from the website more than once"
    type: yesno
    sql: count_orders > 1;;
  }

  measure: average_days_since_last_order {
    description: "Average number of days since the last order"
    type: average
    sql: date_diff(current_timestamp, max_order_date, day) ;;
    value_format_name: decimal_0
  }

  measure: count_of_orders {
    type: sum
    sql: count_orders ;;
    value_format_name: decimal_0
  }

  measure: average_count_of_orders {
    type: average
    sql: count_orders ;;
    value_format_name: decimal_1
  }

  measure: min_order_dt {
    description: "First Ordered"
    sql: min(min_order_date) ;;
  }

  measure: max_order_dt {
    description: "Last Ordered"
    sql: max(max_order_date) ;;
  }

  measure: revenue {
    description: "Total revenue from completed sales (canceled and returned orders excluded)"
    type: sum
    sql: ${TABLE}.total_gross_revenue ;;
    value_format_name: usd_0
  }

  measure: average_revenue {
    description: "Average revenue from completed sales (canceled and returned orders excluded)"
    type: average
    sql: total_gross_revenue ;;
    value_format_name: usd
  }

 measure: count_repeat_customers {
    description: "A Repeat Customer purchased from the website more than once"
    type: count_distinct
    sql: ${user_id};;
    filters:[is_repeat_customer: "yes"]
  }

  measure: count_1_time_customers {
    description: "A Repeat Customer purchased from the website more than once"
    type: count_distinct
    sql: ${user_id};;
    filters:[is_repeat_customer: "no"]
  }

  measure: count_customers {
    description: "A Repeat Customer purchased from the website more than once"
    type: count_distinct
    sql: ${user_id};;
  }

  measure: repeat_purchase_rate {
    description: "Total number of customers who have purchased more than once by the total number of customers"
    type: number
    sql:  ${count_repeat_customers} /  nullif(${count_customers},0);;
    value_format_name: percent_0
  }

}
