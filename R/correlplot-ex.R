# correlogram examples

install.packages("Correlplot")
library(Correlplot)

data("studentsR", package = "Correlplot")
correlogram(studentsR, cex = 1.5)

# compar4e with biplot
data(students, package = "Correlplot")

students.pca <- prcomp(students)
biplot(students.pca)

