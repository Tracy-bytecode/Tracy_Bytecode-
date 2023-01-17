# Define the database connection to be used for this model.
connection: "looker_partner_demo"


# include all the views
include: "/views/**/*.view"


# Datagroups define a caching policy for an Explore. To learn more,
# use the Quick Help panel on the right to see documentation.

datagroup: tracy_casse_study_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}



persist_with: tracy_casse_study_default_datagroup

# Explores allow you to join together different views (database tables) based on the
# relationships between fields. By joining a view into an Explore, you make those
# fields available to users for data analysis.
# Explores should be purpose-built for specific use cases.

# To see the Explore you’re building, navigate to the Explore menu and select an Explore under "Tracy Casse Study"

explore: order_items {
  # sql_always_where: date_diff(date(order_items.created_at , 'America/New_York'), date(current_timestamp , 'America/New_York'), day) <= 1
  # and date_diff(date(order_items.shipped_at,'America/New_York'), date(order_items.created_at, 'America/New_York'), day) >= 0 ;;
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

join: order_users {
  type: left_outer
  sql_on: ${order_items.order_id}= ${order_users.order_id} ;;
  relationship: many_to_one
}


  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${order_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }

  # join: user_fact {
  #   type: left_outer
  #   sql_on: ${user_fact.order_items_user_id} = ${order_items.user_id} ;;
  #   relationship: many_to_one
  # }

  join: user_fact {
    type: left_outer
    sql_on: ${user_fact.user_id} = ${order_items.user_id} ;;
    relationship: many_to_one
  }

 join: events {
  type: left_outer
  sql_on: ${events.user_id} = ${users.id} ;;
  relationship: many_to_one
 }


}

explore: order_users {}

explore: products {
  join: order_items {
    type: left_outer
    sql_on: ${order_items.product_id} = ${products.id} ;;
    relationship: one_to_many
  }
  join: order_users {
    type: left_outer
    sql_on: ${order_items.order_id}= ${order_users.order_id} ;;
    relationship: many_to_one
  }
  fields: [ALL_FIELDS*,
    -order_items.total_cost,-order_items.avg_cost]
}

explore: brand_comparison {}

#new requirement

# access_grant: can_view_data {
#   user_attribute: can_view
#   allowed_values: ["finance"]
# }

      explore: new_order_items {
       from: order_items

  # access_filter: {
  #   field: new_order_items.user_id
  #   user_attribute: can_view
  # }


  join: users {
    type: left_outer
    sql_on: ${new_order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
    fields: [users.age,users.first_name]
  }

  join: order_users {
    type: left_outer
    sql_on: ${new_order_items.order_id}= ${order_users.order_id} ;;
    relationship: many_to_one
  }sql_always_where:  DATE(new_order_items.created_at) > "2020-01-01";;

  # conditionally_filter: {
  #   filters: [status: "Complete"]
  #   unless: [created_date]
  # }

 always_filter: {
   filters: [new_order_items.created_date: "1 day"]
 }
  fields: [
    ALL_FIELDS*,
    -users.days_since_customer_sign_up,
    -users.month_since_customer_sign_up,
    -new_order_items.total_cost,
    -new_order_items.avg_cost
  ]
}

# explore: explore_reference {
#   extends: [brand_comparison]
# }
