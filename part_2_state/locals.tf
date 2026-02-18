locals {
fruits = {
  "orange" = {
    color = "orange"
    weight_in_kg = 1
  }
  "apple" = {
    color = "green"
    weight_in_kg = 0.2
  }
  "lemon" = {
    color = "yellow"
    weight_in_kg = 0.2
  }
}

merged_fruits = merge(local.fruits, var.fruits)


localset = toset([
for name, fruit in local.fruits :
[name, fruit.color, fruit.weight_in_kg]
])
  
variableset = toset([
for name, fruit in var.fruits :
[name, fruit.color, fruit.weight_in_kg]
])

matchset = setintersection(local.localset, local.variableset)

matchmap = {
    for t in local.matchset :
    t[0] => {
      color  = t[1]
      weight_in_kg = t[2]
    }
}

}