# The name of this view in Looker is "Order Items"
view: order_items {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `looker-partners.thelook.order_items`
    ;;
  drill_fields: [order_item_id]
  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: order_item_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
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
      month_name,
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

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Inventory Item ID" in Explore.

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
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

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }
  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;;
    description: "Total Sale Price"
    value_format_name: usd
  }

 measure: average_sale_price {
    type: average
    sql: ${sale_price} ;;
    description: "Average Sale Price"
    value_format_name: usd
  }

 measure: cumulative_total_sales {
    type: running_total
    sql: ${total_sale_price} ;;
    description: "Cumulative Total Sales"
    value_format_name: usd
  }

 measure: total_gross_revenue {
    type: sum
    sql:  ${sale_price} ;;
    filters: [status: "Complete"]
    description: "Total Gross Revenue"
    value_format_name: usd

  }

 measure: avg_gross_revenue {
    type: average
    sql:  ${sale_price} ;;
    filters: [status: "Complete"]
    value_format_name: usd
 }

 measure: avg_lifetime_revenue {
  type: average
  sql: ${sale_price} ;;
  filters: [status: "complete"]
  description: "Average Lifetime_Revenue"
  value_format_name: usd
}

  measure: total_cost {
    type: sum
    sql: ${inventory_items.cost} ;;
    description: "Total_Cost"
    value_format_name: usd
    filters: [status: "Complete"]
  }

  measure: avg_cost {
    type: average
    sql: ${inventory_items.cost} ;;
    value_format_name: usd
    filters: [status: "Complete"]
  }

  measure: total_gross_margin_amount {
    type: number
    sql: ${total_gross_revenue} - ${total_cost} ;;
    description: "Total Gross Margin Amount"
    value_format_name: usd
    drill_fields: [products.brand,products.category,total_gross_margin_amount]
  }


  measure: avg_gross_margin_amount {
    type: number
    description: "Average Gross Margin Amount"
    sql: ${avg_gross_revenue} - ${avg_cost} ;;
    value_format_name: usd
  }


 measure: gross_margin_percentage {
    type: number
    description: "Gross Margin %"
    sql: SAFE_DIVIDE(${total_gross_margin_amount} , ${total_gross_revenue}) ;;
    value_format_name: percent_2
  }


 measure: number_of_items_returned {
    type: count_distinct
    sql: ${order_item_id} ;;
    description: "Number of Items Returned"
    filters: [status: "Returned"]
  }

  measure: total_number_of_items_sold {
    type: count
    filters: [status: "Complete",status: "Returned",status: "Processing"]

  }

  measure: item_return_rate {
    type: number
    sql: ${number_of_items_returned} /  ${total_number_of_items_sold} ;;
  }


  measure: number_of_customer_returning_item {
    type: count_distinct
    sql: ${user_id} ;;
    description: "Number of Customers Returning Item"
    filters: [status: "Returned"]
  }

  measure: total_number_of_customers {
    type: count_distinct
    description: "total number of customers"
    sql: ${user_id} ;;
  }

   measure: percentage_of_users_returning {
    type: number
    sql: ${number_of_customer_returning_item} / ${total_number_of_customers}  ;;
    value_format_name: percent_2

  }

 measure: average_spend_percustomers {
    type: number
    sql: ${total_sale_price}/${total_number_of_customers} ;;
    value_format_name: usd
    drill_fields: [users.age_group,users.gender,average_spend_percustomers]
    html: <font color="green">{{rendered_value}}</font> ;;

  }

 measure: total_revenue {
    type: sum
    sql: ${sale_price} ;;
    description: " Total Revenue"
    value_format_name: usd
    # html: <font color="green">{{rendered_value}}</font> ;;
 }

  measure: total_lifetime_revenue {
    type: sum
    sql: ${sale_price} ;;
    description: "total_lifetime_revenue"
    value_format_name: usd
  }

  measure: first_order_date  {
    type: date
    description: "First Order Date"
    sql: MIN(${TABLE}.created_at) ;;
  }

 measure: latest_order_date  {
    type: date
    description: "latest order date"
    sql: MAX(${TABLE}.created_at) ;;
  }


 measure: is_active {
  type: yesno
  description: "Is Active users"
  sql: DATE_DIFF(CURRENT_DATE(), ${latest_order_date}, DAY) < 90 ;;

  }

 measure: days_since_latest_order {
    type: number
    description: "days Since_latest_Order"
    sql: DATE_DIFF(CURRENT_DATE(), ${latest_order_date}, DAY) ;;

  }

 measure: repeat_customer {
     type: yesno
    description: "Repeat Customer"
    sql: ${order_count}>1 ;;
   }

  measure: Customer_Lifetime_Revenue {
   type: string
   description: "Customers_lifetime_revenue"
   sql: CASE
   WHEN ${total_revenue}>=  0.00   and ${total_revenue} <=4.99 then   "$ 0,00 - $ 4.99"
   When ${total_revenue}>=  5.00   and ${total_revenue}  <=19.99 then  "$ 5.00 - $19.99"
   When ${total_revenue}>=  20.00   and ${total_revenue}  <=49.99 then "$ 20.00 - $49.99"
   When ${total_revenue}>=  50.00   and ${total_revenue}  <=99.99 then  "$ 50.00 - $99.99"
   When ${total_revenue}>=  100.00   and ${total_revenue}  <=499.99 then"$ 100.00 - $499.99"
   When ${total_revenue}>=  500.00   and ${total_revenue}  <= 999.99 then"$ 500.00 - $999.99"
   When ${total_revenue}>=  1000.00  then "1000.00 +"
   Else "undefined" END;;

}


measure: count {
    type: count
    drill_fields: [detail*]
  }


measure: order_count {
  type: count_distinct
  description: "Customer Lifetime Orders"
  sql: ${order_id} ;;
}

  measure: tottal_lifetime_orders {
    type: count_distinct
    description: "Total Lifetime Orders"
    sql: ${order_id} ;;
  }


measure: customer_lifetime_orders {
  type: string
  sql:
  CASE
  WHEN ${order_count} =1  then "1 Order"
  WHEN ${order_count} = 2 then "2 Orders"
  WHEN ${order_count} >=3 and ${order_count}<=5 then "3-5 Orders"
  WHEN ${order_count} >=6 and ${order_count}<=9 then "6-9 Orders"
  WHEN ${order_count} >= 10 then " 10 +"
  Else "undefined" END;;

}

 set: detail {
    fields: [
      order_item_id,
      users.last_name,
      users.id,
      users.first_name,
      inventory_items.id,
      inventory_items.product_name,
      products.name,
      products.id
    ]
  }
}
