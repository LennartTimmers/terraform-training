locals {
  docs_storage_account_map = {
    for cont in var.docs_storage_containers : "${cont.access_type}_${cont.name}" => cont
  }
}
