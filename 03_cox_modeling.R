library(survival)

drug <- read.table("data/drugs.txt", header = TRUE)

# Full Cox model
full_model <- coxph(Surv(days, relapse) ~ treat + age + race + num + use + dep, data = drug)

# Stepwise model selection
step_both <- step(full_model, direction = "both")
step_for  <- step(full_model, direction = "forward")
step_back <- step(full_model, direction = "backward")

# Compare candidate models
AIC(step_both, step_for, step_back)

# Selected model
select_model <- step_both
summary(select_model)

# Cumulative hazard plot
surv_obj <- survfit(select_model)
plot(surv_obj, fun = "cumhaz", mark.time = FALSE,
     xlab = "Days", ylab = "Cumulative hazard")
