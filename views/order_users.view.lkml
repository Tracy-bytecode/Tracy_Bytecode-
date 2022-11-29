
view: order_users {
  # Or, you could make this view a derived table, like this:
  derived_table: {
    sql: SELECT
          order_items.user_id  AS order_items_user_id,
          order_items.created_at as created_dt,
          ROW_NUMBER() OVER(PARTITION BY order_items.user_id ORDER BY  order_items.created_at)
          as sequence_number

      FROM `looker-partners.thelook.order_items`

           AS order_items

      ;;
  }

  # Define your dimensions and measures here, like this:
  dimension: user_id {
    type: number
    sql: ${TABLE}.order_items_user_id ;;
  }


  dimension: created_date {
    type: date
    sql: ${TABLE}.created_dt ;;
  }

  dimension: sequence_number {
    type: number
    sql: ${TABLE}.sequence_number ;;
  }

  dimension: is_first_purchase {
    type: yesno
    sql: ${sequence_number} = 1 ;;
  }
}
