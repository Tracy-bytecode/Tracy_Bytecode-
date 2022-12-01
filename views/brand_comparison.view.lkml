

view: brand_comparison {
  derived_table: {
    explore_source: products {
      column: brand {}
      column: category {}
      column: total_gross_revenue { field: order_items.total_gross_revenue }
      column: order_count { field: order_items.order_count }
    }
  }
  dimension: brand {
    description: ""
  }
  dimension: category {
    description: ""
  }
  dimension: total_gross_revenue {
    description: ""
    value_format: "$#,##0.00"
    type: number
  }
  dimension: order_count {
    description: ""
    type: number
  }

  parameter: select_brand {
    suggest_explore: products
    suggest_dimension: products.brand
  }

  dimension: is_compared_brand {
    type: yesno
    sql: ${brand}={{select_brand._parameter_value}} ;;
  }

  parameter: metric_selector {
    type: unquoted

    allowed_value: {
      label: "Revenue"
      value: "total_gross_revenue"
    }

    allowed_value: {
      label: "Volume"
      value: "order_count"
    }
  }

  measure: gross_revenue_selected_brand {
    type: sum
    sql: ${total_gross_revenue} ;;
    filters: [is_compared_brand: "Yes"]
    value_format_name: usd
  }

  measure: gross_revenue_other_brand {
    type: sum
    sql: ${total_gross_revenue} ;;
    filters: [is_compared_brand: "No"]
    value_format_name: usd
  }

  measure: order_count_selected_brand {
    type: sum
    sql: ${order_count} ;;
    filters: [is_compared_brand: "Yes"]
    value_format_name: usd
  }


  measure: order_count_other_brand {
    type: sum
    sql: ${order_count} ;;
    filters: [is_compared_brand: "No"]
    value_format_name: usd

}

measure: metric_base {
  type: number
  sql:
  {% if metric_selector._parameter_value == 'total_gross_revenue'  %}
  ${gross_revenue_selected_brand}
  {% elsif metric_selector._parameter_value == 'order_count' %}
  ${order_count_selected_brand}
  {% else %}
  null
  {% endif %};;
  value_format_name: decimal_2
}

  measure: metric_compared {
    type: number
    sql:
      {% if metric_selector._parameter_value == 'total_gross_revenue'  %}
      ${gross_revenue_other_brand}
     {% elsif metric_selector._parameter_value == 'order_count' %}
       ${order_count_other_brand}
       {% else %}
       null
       {% endif %};;
    value_format_name: decimal_2
  }




































}
