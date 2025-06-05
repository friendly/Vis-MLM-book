# Test elmer / anthropic
devtools::install_github("hadley/elmer")
library(elmer)

# set in .Renviron
#Sys.setenv(ANTHROPIC_API_KEY = "your_api_key_here")

# Create a chat object
chat <- chat_anthropic(model = "claude-sonnet-4-20250514")

# Test with a simple query
chat$chat("Hello, can you help me with R code?")

response <- chat$chat("
Create a ggplot2 example for visualizing multivariate data with 
3 continuous variables and 2 categorical variables using faceting 
and color aesthetics.
")

cat(response)

#--------------------

install.packages("anthropic")
library(anthropic)

# Simple message
response <- claude(
  model = "claude-sonnet-4-20250514",
  messages = list(
    list(role = "user", content = "Write R code to create a scatter plot matrix")
  ),
  max_tokens = 1000
)

# Extract and display the response
cat(response$content[[1]]$text)

# Helper function for quick queries
ask_claude <- function(prompt, model = "claude-sonnet-4-20250514") {
  response <- claude(
    model = model,
    messages = list(list(role = "user", content = prompt)),
    max_tokens = 2000
  )
  cat(response$content[[1]]$text)
}

ask_claude("Create a ggplot2 code example for visualizing correlation matrix")

