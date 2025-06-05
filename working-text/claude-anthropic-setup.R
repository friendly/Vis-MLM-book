# Using `anthropic` package
# -------------------------
# Claude API Setup Script for RStudio
# Save this as: claude_setup.R
# 
# Instructions:
# 1. Get your API key from https://console.anthropic.com
# 2. Set up billing and add credits
# 3. Replace "your_api_key_here" below with your actual API key
# 4. Run this script to set up Claude API access in R

# =============================================================================
# STEP 1: Install and Load Required Packages
# =============================================================================

# Install anthropic package if not already installed
if (!require(anthropic)) {
  install.packages("anthropic")
  library(anthropic)
}

# =============================================================================
# STEP 2: Set Up API Key
# =============================================================================

# Option A: Set for current session (replace with your actual key)
# Sys.setenv(ANTHROPIC_API_KEY = "your_api_key_here")

# Option B: Set permanently in .Renviron file (recommended)
# Uncomment and run these lines once:
# usethis::edit_r_environ()
# Then add this line to the file that opens:
# ANTHROPIC_API_KEY=your_api_key_here
# Save, close, and restart R

# Check if API key is set
if (Sys.getenv("ANTHROPIC_API_KEY") == "") {
  cat("WARNING: ANTHROPIC_API_KEY not found in environment variables.\n")
  cat("Please set your API key using one of the methods above.\n")
} else {
  cat("API key found! ✓\n")
}

# =============================================================================
# STEP 3: Basic Usage Function
# =============================================================================

# Simple function to query Claude
ask_claude <- function(prompt, model = "claude-sonnet-4-20250514", max_tokens = 2000) {
  tryCatch({
    response <- claude(
      model = model,
      messages = list(list(role = "user", content = prompt)),
      max_tokens = max_tokens
    )
    cat(response$content[[1]]$text)
    return(invisible(response$content[[1]]$text))
  }, error = function(e) {
    cat("Error:", e$message, "\n")
    return(NULL)
  })
}

# =============================================================================
# STEP 4: Multi-turn Conversation Function
# =============================================================================

# Function for ongoing conversations with message history
chat_with_claude <- function(user_message, conversation_history = list(), 
                             model = "claude-sonnet-4-20250514", max_tokens = 2000) {
  tryCatch({
    # Add user message to history
    conversation_history <- append(
      conversation_history, 
      list(list(role = "user", content = user_message))
    )
    
    # Get response from Claude
    response <- claude(
      model = model,
      messages = conversation_history,
      max_tokens = max_tokens
    )
    
    # Extract assistant response
    assistant_message <- response$content[[1]]$text
    
    # Add assistant response to history
    conversation_history <- append(
      conversation_history,
      list(list(role = "assistant", content = assistant_message))
    )
    
    # Print the response
    cat(assistant_message, "\n")
    
    # Return updated conversation history
    return(conversation_history)
    
  }, error = function(e) {
    cat("Error:", e$message, "\n")
    return(conversation_history)
  })
}

# =============================================================================
# STEP 5: Specialized Helper Functions for Data Science
# =============================================================================

# Function for data visualization code help
get_viz_code <- function(description, include_sample_data = TRUE) {
  prompt <- paste0(
    "Create R code for data visualization: ", description, ". ",
    "Use ggplot2 and modern visualization techniques. ",
    if(include_sample_data) "Include sample data generation. " else "",
    "Focus on advanced techniques suitable for multivariate data analysis."
  )
  ask_claude(prompt)
}

# Function for statistical modeling help
get_model_code <- function(description, include_diagnostics = TRUE) {
  prompt <- paste0(
    "Create R code for statistical modeling: ", description, ". ",
    if(include_diagnostics) "Include model fitting, diagnostics, and interpretation. " else "",
    "Provide complete, runnable code with explanations."
  )
  ask_claude(prompt)
}

# Function for data manipulation help
get_data_code <- function(description) {
  prompt <- paste0(
    "Create R code for data manipulation: ", description, ". ",
    "Use tidyverse packages (dplyr, tidyr) where appropriate. ",
    "Include sample data and clear explanations."
  )
  ask_claude(prompt)
}

# Function for code review and improvement
review_code <- function(code_text) {
  prompt <- paste0(
    "Please review this R code and suggest improvements for efficiency, ",
    "readability, and best practices:\n\n", code_text
  )
  ask_claude(prompt)
}

# =============================================================================
# STEP 6: Conversation Management
# =============================================================================

# Initialize a new conversation
start_conversation <- function() {
  cat("Starting new conversation with Claude...\n")
  return(list())
}

# Save conversation to file
save_conversation <- function(conversation_history, filename = NULL) {
  if (is.null(filename)) {
    filename <- paste0("claude_conversation_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".rds")
  }
  saveRDS(conversation_history, filename)
  cat("Conversation saved to:", filename, "\n")
}

# Load conversation from file
load_conversation <- function(filename) {
  if (file.exists(filename)) {
    conversation <- readRDS(filename)
    cat("Conversation loaded from:", filename, "\n")
    return(conversation)
  } else {
    cat("File not found:", filename, "\n")
    return(list())
  }
}

# =============================================================================
# STEP 7: Test Functions
# =============================================================================

# Test basic functionality
test_claude_connection <- function() {
  cat("Testing Claude API connection...\n")
  result <- ask_claude("Say 'Hello from Claude!' and confirm you're working correctly.")
  if (!is.null(result)) {
    cat("\n✓ Connection successful!\n")
    return(TRUE)
  } else {
    cat("\n✗ Connection failed. Check your API key and internet connection.\n")
    return(FALSE)
  }
}

# =============================================================================
# EXAMPLE USAGE
# =============================================================================

# Uncomment these lines to test after setting up your API key:

# # Test connection
# test_claude_connection()
# 
# # Simple query
# ask_claude("Write a simple R function to calculate the mean of a vector")
# 
# # Get visualization code
# get_viz_code("correlation matrix heatmap with hierarchical clustering")
# 
# # Start a conversation
# conversation <- start_conversation()
# conversation <- chat_with_claude("Help me create a PCA analysis in R", conversation)
# conversation <- chat_with_claude("Now show me how to create a biplot", conversation)
# 
# # Save the conversation
# save_conversation(conversation)

# =============================================================================
# HELPFUL REMINDERS
# =============================================================================

cat("Claude API Setup Complete!\n\n")
cat("Available functions:\n")
cat("  - ask_claude(prompt)                    # Simple one-off queries\n")
cat("  - chat_with_claude(message, history)   # Multi-turn conversations\n")
cat("  - get_viz_code(description)            # Get visualization code\n")
cat("  - get_model_code(description)          # Get statistical modeling code\n")
cat("  - get_data_code(description)           # Get data manipulation code\n")
cat("  - review_code(code_text)               # Get code review and suggestions\n")
cat("  - test_claude_connection()             # Test API connection\n")
cat("  - start_conversation()                 # Initialize new conversation\n")
cat("  - save_conversation(history, filename) # Save conversation to file\n")
cat("  - load_conversation(filename)          # Load conversation from file\n\n")
cat("Remember to set your ANTHROPIC_API_KEY environment variable!\n")
cat("Visit https://console.anthropic.com to get your API key.\n")