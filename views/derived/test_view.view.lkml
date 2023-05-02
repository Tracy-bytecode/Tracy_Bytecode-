view: test_view {
  derived_table: {
    explore_source: order_items {
      column: country { field: users.country }
      column: total_gross_revenue {}
      column: gender { field: users.gender }
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
  dimension: gender {
    description: ""
  }

  measure: lifetime_revenue {
    type: sum
    sql: ${total_gross_revenue} ;;
  }
}
