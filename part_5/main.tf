resource "local_file" "greeting" {
  filename = "${path.module}/greeting.txt"
  content  = var.greeting
}

output "greeting_file_path" {
  value = local_file.greeting.filename
}

output "greeting_content" {
  value = local_file.greeting.content
}