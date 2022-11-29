# The name of this view in Looker is "Users"
view: users {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `thelook.users`
    ;;
  drill_fields: [id]
  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.


  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }



  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Age" in Explore.

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: age_group {
    type: string
    sql:
    CASE
    WHEN ${age} >=15 and ${age}<=25 then "15-25 "
    WHEN ${age} >= 26 and ${age}<= 35 then " 26-35"
    WHEN ${age} >= 36 and ${age}<= 50 then " 36-50"
    WHEN ${age}>= 51 and ${age} <= 65 then " 51-65"
    WHEN ${age}>= 66  then "66 +"
    Else "undefined" END;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.


  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

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

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }


dimension: first_last_name {
  type: string
  sql: concat(${first_name},' ',${last_name});;
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
    map_layer_name: us_states
  }

  dimension: street_address {
    type: string
    sql: ${TABLE}.street_address ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: is_new_customer {
    type: yesno
    sql: DATE_DIFF(CURRENT_DATE(), ${created_date}, DAY) < 90 ;;

  }

  #days since customer sign up

  dimension: days_since_customer_sign_up {
    type: number
    sql: DATE_DIFF(${order_items.created_date}, ${created_date}, DAY) ;;
  }


    #avg days since customer sign up
  measure: avg_days_since_customer_sign_up {
    type: average
    sql: ${days_since_customer_sign_up} ;;
    value_format_name: decimal_2
  }

#Month since customer sign up
  dimension: month_since_customer_sign_up {
    type: number
    sql: DATE_DIFF(${order_items.created_date}, ${created_date}, MONTH) ;;
  }

    #Avg Month since customer sign up
  measure: avg_month_since_customer_sign_up {
    type: average
    sql: ${month_since_customer_sign_up} ;;
    value_format_name: decimal_2

  }



  measure: count {
    type: count
    drill_fields: [id, last_name, first_name, order_items.count, events.count]
  }
}
