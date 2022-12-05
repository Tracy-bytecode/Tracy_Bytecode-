

view: brand_comparison {
  derived_table: {
    explore_source: products {
      column: brand {}
      column: category {}
      column: total_revenue { field: order_items.total_revenue }
      column: order_count { field: order_items.order_count }
      column: created_date { field: order_items.created_date }
    }
  }

  # dimension: created_date {
  #   description: ""
  #   type: date
  # }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      month_name,
      quarter,
      year
    ]
    sql: ${TABLE}.created_date ;;
  }

  dimension: brand {
    description: ""
  }
  dimension: category {
    description: ""
  }
  dimension: total_revenue {
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

  dimension: brand_compare {
    type: string
    sql: case when {% condition select_brand %} ${brand} {% endcondition %}
              then ${brand}
              else 'Other Brands'
           end ;;
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
    sql: ${total_revenue} ;;
    filters: [is_compared_brand: "Yes"]
    value_format_name: usd
  }

  measure: gross_revenue_other_brand {
    type: sum
    sql: ${total_revenue} ;;
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
