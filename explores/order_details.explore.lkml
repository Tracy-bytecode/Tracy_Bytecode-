include: "/views/base/order_items.view.lkml"
include: "/views/base/users.view.lkml"

explore: order_items {
  join: users {
    type: inner
    sql_on: ${order_items.user_id}=${users.id} ;;
    relationship: many_to_one
  }
}
