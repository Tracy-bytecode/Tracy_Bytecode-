view: user_fact {
  derived_table: {
    sql: SELECT
          order_items.user_id  AS order_items_user_id,
          DATE_DIFF(CURRENT_DATE(), ( (DATE(MAX(order_items.created_at) , 'America/Los_Angeles')) ), DAY)  AS order_items_days_since_latest_order,
          COALESCE(SUM(order_items.sale_price ), 0) AS order_items_total_lifetime_revenue,
          COUNT(DISTINCT order_items.order_id ) AS order_items_tottal_lifetime_orders,
          CASE
  WHEN ( COUNT(DISTINCT order_items.order_id ) ) =1  then "1 Order"
  WHEN ( COUNT(DISTINCT order_items.order_id ) ) = 2 then "2 Orders"
  WHEN ( COUNT(DISTINCT order_items.order_id ) ) >=3 and ( COUNT(DISTINCT order_items.order_id ) )<=5 then "3-5 Orders"
  WHEN ( COUNT(DISTINCT order_items.order_id ) ) >=6 and ( COUNT(DISTINCT order_items.order_id ) )<=9 then "6-9 Orders"
  WHEN ( COUNT(DISTINCT order_items.order_id ) ) >= 10 then " 10 +"
  Else "undefined" END AS order_items_customer_lifetime_orders
      FROM `looker-partners.thelook.order_items`

           AS order_items
      GROUP BY
          1
           ;;
  }



  dimension: order_items_user_id {
    type: number
    sql: ${TABLE}.order_items_user_id ;;
    primary_key: yes
    hidden: yes
  }

  measure: average_days_since_latest_order {
    type: average
    sql: ${TABLE}.order_items_days_since_latest_order ;;
    view_label: "Order Items"
    value_format_name: decimal_2
  }

  dimension: customer_orders_group {
    type: string
    sql: ${TABLE}.order_items_customer_lifetime_orders ;;
    view_label: "Order Items"
  }

  measure: average_lifetime_revenue {
    type: average
    sql: ${TABLE}.order_items_total_lifetime_revenue ;;
    view_label: "Order Items"
    value_format_name: usd
  }

  measure: average_lifetime_orders {
    type: average
    sql: ${TABLE}.order_items_tottal_lifetime_orders ;;
    view_label: "Order Items"
    value_format_name: decimal_2
  }

  dimension: customer_revenue_group {
    label: "Customer Revenue Group"
    type: tier
    tiers: [5,20,50,100,500,1000]
    sql:  ${TABLE}.order_items_total_lifetime_revenue ;;
    style:  integer
    value_format: "$#,##0"
    view_label: "Order Items"
  }



}
