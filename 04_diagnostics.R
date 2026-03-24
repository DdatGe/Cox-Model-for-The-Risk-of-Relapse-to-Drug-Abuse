library(survival)
library(timereg)

drug <- read.table("data/drugs.txt", header = TRUE)

select_model <- coxph(Surv(days, relapse) ~ treat + age + race + num + dep, data = drug)

# Log-linearity check
fit_ut <- cox.aalen(
  Surv(days, relapse == 1) ~ prop(treat) + prop(age) + prop(race) + prop(num) + prop(dep),
  data = drug,
  weighted.test = 0,
  residuals = 1,
  rate.sim = 0,
  n.sim = 1000
)

par(mfrow = c(2, 3))
plot(fit_ut, score = TRUE, xlab = "Time")

# Proportional hazards assumption
zph_result <- cox.zph(select_model, transform = "log")
print(zph_result)

par(mfrow = c(1, 1))
plot(zph_result)
