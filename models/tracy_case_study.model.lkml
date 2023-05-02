connection: "looker_partner_demo"

include: "/views/base/*.view.lkml"
include: "/views/derived/*.view.lkml"

explore: order_items {
  group_label: "Tracy BU Training"
  join: users {
    type: inner
    sql_on: ${order_items.user_id}=${users.id} ;;
    relationship: many_to_one
  }
  join: products {
    type: inner
    sql_on: ${order_items.product_id}=${products.id} ;;
    relationship: many_to_one
  }
}

explore: users {
  group_label: "Tracy BU Training"
}

explore: test_view {}

persist_for: "1 hour"
