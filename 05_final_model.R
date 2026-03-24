library(survival)
library(timereg)

drug <- read.table("data/drugs.txt", header = TRUE)

# Stratified Cox model
fit_st <- coxph(
  Surv(days, relapse == 1) ~ strata(treat) + age + race + num + dep,
  data = drug
)

summary(fit_st)

# Log-linearity check for stratified model
fit_ut <- cox.aalen(
  Surv(days, relapse == 1) ~ strata(treat) + prop(age) + prop(race) + prop(num) + prop(dep),
  data = drug,
  weighted.test = 0,
  residuals = 1,
  rate.sim = 0,
  n.sim = 1000
)

par(mfrow = c(2, 2))
plot(fit_ut, score = TRUE, xlab = "Time")

# Term plot
par(mfrow = c(2, 2))
termplot(fit_st, se = TRUE)

# PH assumption
zph_result <- cox.zph(fit_st, transform = "log")
print(zph_result)

par(mfrow = c(2, 2))
plot(zph_result)

# Survival / cumulative hazard plot
baseline_covar <- data.frame(age = 1, race = 1, num = 1, dep = 1)
surv_st <- survfit(fit_st, newdata = baseline_covar)

par(mfrow = c(1, 1))
plot(surv_st, fun = "cumhaz", log = TRUE,
     mark.time = FALSE, lty = 1:2,
     xlab = "Days", ylab = "log Cumulative hazard")
legend("bottomright", c("3 months", "6 months"),
       title = "treatment", lty = 1:2, bty = "n")
