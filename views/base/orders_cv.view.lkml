view: orders_cv {

measure: total_revenue_new {
  type: sum
  sql: ${order_items.sale_price} ;;
  filters: [users.created_last_90_days: "yes"]
}

  measure: total_revenue_old {
    type: sum
    sql: ${order_items.sale_price} ;;
    filters: [users.created_last_90_days: "no"]
  }

  measure: total_gross_margin {
    type: sum
    sql: ${order_items.sale_price}-${products.cost} ;;
    filters: [order_items.is_complete: "yes"]
    value_format_name: usd
  }

  measure: dyn_measure{
    type: number
    sql: {% if selected_metric._parameter_value=='total_revenue' %} ${order_items.total_gross_revenue}
    {% elsif selected_metric._parameter_value=='total_orders' %} ${order_items.total_orders}
    {% elsif selected_metric._parameter_value=='total_gross_margin' %} ${orders_cv.total_gross_margin}
    {% else %} 0
    {% endif %} ;;
    value_format_name: decimal_2
    }

  parameter: selected_metric {
    type: unquoted
    default_value: "total_revenue"
    allowed_value: {
      label: "Total Orders"
      value: "total_orders"
    }
    allowed_value: {
      label: "Total Revenue"
      value: "total_revenue"
    }
    allowed_value: {
      label: "Total Gross Margin"
      value: "total_gross_margin"
    }
  }
   }
