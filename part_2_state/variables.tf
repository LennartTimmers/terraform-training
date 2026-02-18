variable "fruits" {
  type = map(object({
    color = string
    weight_in_kg = number
  }))
}
