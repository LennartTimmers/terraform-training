run "default_greeting" {
  # By default, terraform test uses the parent directory as the source,
  # so we don't need to specify "source" explicitly for root-module tests.

  # Content and filename are known at plan time, so no real file is written
  command = plan

  # Use the module with default variables, then assert on the outputs
  assert {
    condition     = output.greeting_content == "Hello, Terraform!"
    error_message = "Expected default greeting to be 'Hello, Terraform!'"
  }
}

run "custom_greeting" {
  command = plan

  # Override the greeting variable for this run
  variables {
    greeting = "Hi from test!"
  }

  assert {
    condition     = output.greeting_content == var.greeting
    error_message = "Expected greeting_content to match var.greeting"
  }

  assert {
    condition     = endswith(output.greeting_file_path, "/greeting.txt")
    error_message = "Expected greeting_file_path to end with '/greeting.txt'"
  }
}
