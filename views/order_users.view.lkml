
view: order_users {
  # Or, you could make this view a derived table, like this:
  derived_table: {
    sql: SELECT
          order_items.user_id  AS order_items_user_id,
          order_items.order_id as order_id,
          order_items.created_at as created_dt,
          ROW_NUMBER() OVER(PARTITION BY order_items.user_id ORDER BY  order_items.created_at)
          as sequence_number,
          date_diff(min(timestamp(created_at)), lag(min(timestamp(created_at)),1) over(partition by user_id order by
          min(timestamp(created_at))), Day) as days_between_orders

      FROM `looker-partners.thelook.order_items`

           AS order_items
          group by 1,2,3

      ;;
  }

  # Define your dimensions and measures here, like this:
  dimension: user_id {
    type: number
    sql: ${TABLE}.order_items_user_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }


  dimension: created_date {
    type: date
    sql: ${TABLE}.created_dt ;;
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
    type: count_distinct
    sql: ${user_id} ;;
  }

  measure: 60_day_repeat_purchase_rate {
    type: number
    sql: 1.0*${60_day_repeat_customers}/nullif(${count_customers},0);;
    value_format_name: percent_2
  }


}
