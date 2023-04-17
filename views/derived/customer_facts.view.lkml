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
    sql: ${total_sale_price} ;;
    style:  integer
    value_format_name: usd_0
  }
  dimension: total_orders {
    type: number
  }
  dimension: total_sale_price {
    type: number
  }
  measure: count {}
}
