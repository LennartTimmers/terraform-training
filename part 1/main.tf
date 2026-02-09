# Creating the first file
resource "local_file" "foo" {
  content  = "foo!"
  filename = "${path.module}/foo.bar"
}

# if color of fruit is red create the file, otherwise not
resource "local_file" "fruits" {
  for_each = {for k, v in var.fruits: k => v if lower(v.color) == "red"}
  content  = "Color = ${each.value.color} and weight = ${each.value.weight_in_kg}" 
  filename = each.key
}

# create all fruits in var.fruits
resource "local_file" "all_fruits" {
  for_each = var.fruits
  content  = "Color = ${each.value.color} and weight = ${each.value.weight_in_kg}" 
  filename = each.key
}

# # Create fruits starting with ap
# resource "local_file" "ap_fruits" {
#   for_each = {for k, v in var.fruits: k => v if startswith(k, "ap")}
#   content  = "Color = ${each.value.color} and weight = ${each.value.weight_in_kg}" 
#   filename = each.key
# }

# # Create fruits which result from merging local.fruits with var.fruits
resource "local_file" "all_fruits" {
  for_each = local.merged_fruits
  content  = "Color = ${each.value.color} and weight = ${each.value.weight_in_kg}" 
  filename = each.key
}

# # Create fruits which exists in both maps
# resource "local_file" "all_fruits" {
#   for_each = local.matchmap
#   content  = "Color = ${each.value.color} and weight = ${each.value.weight_in_kg}" 
#   filename = each.key
# }