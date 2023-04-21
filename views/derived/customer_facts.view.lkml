view: customer_facts {
  derived_table: {
    explore_source: order_items {
      column: user_id {}
      column: total_orders {}
      column: total_sale_price {}
    }
  }
  dimension: user_id {
    primary_key: yes
    type: number
  }
  dimension: lifetime_orders {
    type: tier
    tiers: [1,2,3,6,10]
    sql: ${total_orders} ;;
    style: integer
  }
  dimension: lifetime_sales {
    type: tier
    tiers: [0, 5, 20, 50, 100, 500, 1000]
    sql: ${total_lifetime_sales} ;;
    style:  integer
    value_format_name: usd_0
  }
  dimension: total_orders {
    type: number
  }
  dimension: total_lifetime_sales {
    type: number
    sql: ${TABLE}.total_sale_price ;;
  }
  measure: average_lifetime_sales {
    type: average_distinct
    sql: ${total_lifetime_sales} ;;
  }
  measure: count {}

}
