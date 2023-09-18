view: test_derived_table {
  derived_table: {
    explore_source: order_items {
      column: country { field: users.country }
      column: total_gross_revenue {}
    }
  }
  dimension: country {
    description: ""
  }
  dimension: total_gross_revenue {
    description: ""
    value_format: "$#,##0.00"
    type: number
  }

  measure: average_total_gross_revenue {
    type: average
    sql: ${total_gross_revenue} ;;
  }
}
