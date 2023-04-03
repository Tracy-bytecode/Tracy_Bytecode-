view: products {

  sql_table_name: `looker-partners.thelook.products` ;;
  drill_fields: [id]

##--DIMENSIONS--##
  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }
  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: distribution_center_id {
    type: number
    sql: ${TABLE}.distribution_center_id ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}.retail_price ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  ##--MEASURES--##
  measure: average_cost {
    type: average
    sql: ${cost} ;;
  }
  measure: count {
    type: count
    drill_fields: [id, name, order_items.count]
  }
  measure: total_cost {
    type: sum
    sql: ${cost} ;;
  }

}
