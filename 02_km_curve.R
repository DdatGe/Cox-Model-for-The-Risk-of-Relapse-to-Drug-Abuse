library(survival)
library(survminer)

drug <- read.table("data/drugs.txt", header = TRUE)

drug$age_g <- as.numeric(drug$age > mean(drug$age))
drug$num_g <- as.numeric(drug$num > mean(drug$num))
drug$dep_g <- as.numeric(drug$dep > mean(drug$dep))

par(mfrow = c(3, 2))

km_fit1 <- survfit(Surv(days, relapse == 1) ~ treat, data = drug)
plot(km_fit1, main = "Treatment", xlab = "Days", ylab = "S(t)")

km_fit2 <- survfit(Surv(days, relapse == 1) ~ age_g, data = drug)
plot(km_fit2, main = "Age", xlab = "Days", ylab = "S(t)")

km_fit3 <- survfit(Surv(days, relapse == 1) ~ race, data = drug)
plot(km_fit3, main = "Race", xlab = "Days", ylab = "S(t)")

km_fit4 <- survfit(Surv(days, relapse == 1) ~ num_g, data = drug)
plot(km_fit4, main = "Num", xlab = "Days", ylab = "S(t)")

km_fit5 <- survfit(Surv(days, relapse == 1) ~ use, data = drug)
plot(km_fit5, main = "Use", xlab = "Days", ylab = "S(t)")

km_fit6 <- survfit(Surv(days, relapse == 1) ~ dep_g, data = drug)
plot(km_fit6, main = "Depression", xlab = "Days", ylab = "S(t)")
