library(survival)
library(timereg)
library(survminer)

drug <- read.table("data/drugs.txt", header = TRUE)

# Basic EDA
head(drug)
summary(drug)

# Grouping variables for visualization
drug$age_g <- as.numeric(drug$age > mean(drug$age))
drug$num_g <- as.numeric(drug$num > mean(drug$num))
drug$dep_g <- as.numeric(drug$dep > mean(drug$dep))

# Histograms
par(mfrow = c(3, 2))
hist(drug$treat, main = "Treatment", xlab = "treat")
hist(drug$age, main = "Age", xlab = "age")
hist(drug$race, main = "Race", xlab = "race")
hist(drug$num, main = "Previous Treatments", xlab = "num")
hist(drug$use, main = "Recent Drug Use", xlab = "use")
hist(drug$dep, main = "Depression Score", xlab = "dep")

# Pairwise relationships
pairs(drug)
