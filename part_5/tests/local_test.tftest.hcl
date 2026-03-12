run "default_greeting" {
  # By default, terraform test uses the parent directory as the source,
  # so we don't need to specify "source" explicitly for root-module tests.

  # Use the module with default variables, then assert on the outputs
  assert {
    condition     = output.greeting_content == "Hello, Terraform!"
    error_message = "Expected default greeting to be 'Hello, Terraform!'"
  }
}

run "custom_greeting" {
  # Override the greeting variable for this run
  variables {
    greeting = "Hi from test!"
  }

  assert {
    condition     = output.greeting_content == "Hi from test!"
    error_message = "Expected greeting_content to match the custom greeting"
  }

  assert {
    condition     = can(regex(".*/greeting.txt$", output.greeting_file_path))
    error_message = "Expected greeting_file_path to end with 'greeting.txt'"
  }
}