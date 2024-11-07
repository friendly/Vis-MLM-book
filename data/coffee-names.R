# Add rownames to coffee data

data(coffee, package = "matlib")

# Create larger vectors of names
male_names <- c(
  "Adam", "Ben", "Cole", "Dan", "Eric", 
  "Fred", "Gil", "Hans", "Ian", "Jack",
  "Karl", "Liam", "Mike", "Nate", "Owen",
  "Paul", "Quinn", "Ross", "Sam", "Tom"
)

female_names <- c(
  "Amy", "Beth", "Cara", "Dena", "Eve",
  "Fay", "Gwen", "Hope", "Iris", "Joy",
  "Kate", "Lisa", "Mia", "Nina", "Olga",
  "Pam", "Rose", "Sara", "Tess", "Uma"
)

# Combine into a single data frame
all_names <- data.frame(
  name = c(male_names, female_names),
  gender = rep(c("M", "F"), each = 20),
  initial = substr(c(male_names, female_names), 1, 1)
)

# For each letter, randomly select one name if multiple exist
set.seed(123) # for reproducibility
alphabetical_names <- by(all_names, all_names$initial, function(x) {
  if(nrow(x) > 0) {
    x[sample(nrow(x), 1), ]
  }
})

# Convert to data frame and sort
final_list <- do.call(rbind, alphabetical_names)
final_list <- final_list[order(final_list$initial), ]

# Display results
print(final_list[, c("name", "gender", "initial")], row.names = FALSE)

# Summary statistics
cat("\nCoverage Statistics:\n")
cat("Total unique initials:", nrow(final_list), "\n")
cat("Missing letters:", 
    paste(setdiff(LETTERS, final_list$initial), collapse = ", "), "\n")
cat("\nGender distribution in final selection:\n")
print(table(final_list$gender))

rownames(coffee) <- final_list$name[1:nrow(coffee)]
coffee
