run "default_greeting" {
  # By default, terraform test uses the parent directory as the source,
  # so we don't need to specify "source" explicitly for root-module tests.

  # Content and filename are known at plan time, so no real file is written
  command = plan

  # Use the module with default variables, then assert on the outputs
  assert {
    condition     = output.greeting_content == "TODO"
    error_message = "TODO: describe what went wrong"
  }
}

run "custom_greeting" {
  command = plan

  # Override the greeting variable for this run
  variables {
  }

  assert {
    condition     = output.greeting_content == "TODO"
    error_message = "TODO: describe what went wrong"
  }

  # Bonus: assert that the file path ends in greeting.txt
}

