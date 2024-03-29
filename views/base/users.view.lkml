view: users {

  sql_table_name: `looker-partners.thelook.users`;;
  drill_fields: [id]

##--DIMENSIONS--##
  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: age_group {
    type: tier
    tiers: [15,25,35,50,65]
    style: integer
    sql: ${age} ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
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

  dimension: created_last_90_days{
    type: yesno
    sql: date_diff(current_date, ${created_date},day)<=90 ;;
  }

  dimension: days_since_signup {
    type: number
    sql: date_diff(current_date,${created_date},day) ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: full_name {
    type: string
    sql: ${first_name}||' '||${last_name} ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: postal_code {
    type: string
    sql: ${TABLE}.postal_code ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: street_address {
    type: string
    sql: ${TABLE}.street_address ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  ##--MEASURES--##
  measure: average_age {
    type: average
    sql: ${age} ;;
  }

  measure: count {
    type: count
    drill_fields: [id, last_name, first_name, order_items.count]
  }

  measure: total_age {
    hidden: yes
    type: sum
    sql: ${age} ;;
  }

}
