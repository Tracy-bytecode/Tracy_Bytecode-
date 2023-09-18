view: order_items {

  sql_table_name: `looker-partners.thelook.order_items`;;
  drill_fields: [id]


##--DIMENSIONS--##
  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: created_dyn {
    label_from_parameter: date_grain
    sql: {% if date_grain._parameter_value=='year' %} ${created_year}
    {% elsif date_grain._parameter_value== 'month' %} ${created_month}
    {% elsif date_grain._parameter_value=='week' %} ${created_week}
    {% elsif date_grain._parameter_value=='day' %} ${created_date}
    {% else %} NULL {% endif %};;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.delivered_at ;;
  }

  dimension: inventory_item_id {
    type: number
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: is_complete {
    type: yesno
    sql: ${status}<>'Cancelled' and ${returned_raw} is null ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: product_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.product_id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

##--MEASURES--##
  measure: average_sale_price {
    type: average
    sql: ${sale_price} ;;
  }
  measure: count {
    type: count
    drill_fields: [detail*]
  }
  measure: total_gross_revenue {
    type: sum
    sql: ${sale_price} ;;
    filters: [is_complete: "yes"]
    value_format_name: usd
  }

  measure: cumulative_total_sales {
    type: running_total
    sql: ${total_sale_price} ;;
  }

  measure: spend_per_customer {
    type: number
    sql: ${total_sale_price}/nullif(${total_customers},0) ;;
    value_format_name: usd
  }
  measure: total_customers {
    type:count_distinct
    sql: ${user_id} ;;
  }

  measure: total_orders {
    type: count_distinct
    sql: ${order_id} ;;
  }
  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  parameter: date_grain {
    type: unquoted
    default_value: "year"
    allowed_value: {
      label: "Day"
      value: "day"
    }
    allowed_value: {
      label: "Week"
      value: "week"
    }
    allowed_value: {
      label: "Month"
      value: "month"
    }
    allowed_value: {
      label: "Year"
      value: "year"
    }
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.last_name,
      users.id,
      users.first_name,
      products.name,
      products.id
    ]
  }
}
