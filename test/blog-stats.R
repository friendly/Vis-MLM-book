load("data/chunks.RData")
cat("Dimensions:", nrow(chunks), "x", ncol(chunks), "\n")
cat("Names:", paste(names(chunks), collapse=", "), "\n\n")
cat("fold_status table:\n")
print(sort(table(chunks$fold_status), decreasing=TRUE))
cat("\nfold-only figure chunks (HTML folded but code still shows in PDF):\n")
fo <- chunks[chunks$fold_status == "fold-only" & chunks$is_fig,
             c("chapter", "label", "file")]
print(fo, row.names=FALSE)
cat("\nTotal fig chunks:", sum(chunks$is_fig), "\n")
cat("Fig chunks with 'both':", sum(chunks$is_fig & chunks$fold_status=="both"), "\n")
cat("Fig chunks with 'neither':", sum(chunks$is_fig & chunks$fold_status=="neither"), "\n")
