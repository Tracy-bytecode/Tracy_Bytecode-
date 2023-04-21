include: "/views/base/order_items.view.lkml"
include: "/views/base/users.view.lkml"
include: "/views/base/products.view.lkml"

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
