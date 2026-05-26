df <- read.csv("semiconductor_wafer_defect_dataset.csv")
cat("Rows:", nrow(df), "\n")
cat("Columns:", ncol(df), "\n")
print(head(df))

library(qcc)
library(ggplot2)
library(dplyr)

# split data by process step 
steps <- unique(df$process_step)
cat("Process steps found:", paste(steps, collapse=", "), "\n")

# function to generate Shewhart X-bar chart per process step
plot_xbar <- function(data, parameter, step_name) {
  step_data <- data %>%
    filter(process_step == step_name) %>%
    pull(!!sym(parameter))
  
  # need to group into subgroups of 5 for X-bar chart hfcuiehfiued
  n_groups <- floor(length(step_data) / 5)
  grouped  <- matrix(step_data[1:(n_groups * 5)], ncol=5, byrow=TRUE)
  
  qcc(grouped,
      type    = "xbar",
      title   = paste("X-bar Chart —", parameter, "(", step_name, ")"),
      xlab    = "Subgroup",
      ylab    = parameter,
      plot    = TRUE)
}

# generate control charts for temperature across all process steps
par(mfrow=c(2,3))  # 2 rows, 3 cols layout

for (step in steps) {
  plot_xbar(df, "temperature_c", step)
}

# generate charts for all key parameters
parameters <- c("temperature_c", "pressure_torr", "etch_rate_nm_min", 
                "voltage_v", "current_ma")

# loop through each parameter and each process step
for (param in parameters) {
  par(mfrow=c(2,3))
  for (step in steps) {
    plot_xbar(df, param, step)
  }
  mtext(paste("SPC Control Charts —", param), 
        side=3, line=-1.5, outer=TRUE, cex=1.2, font=2)
}

# Violations Summary Table 
results <- data.frame()

for (param in parameters) {
  for (step in steps) {
    step_data <- df %>%
      filter(process_step == step) %>%
      pull(!!sym(param))
    
    n_groups <- floor(length(step_data) / 5)
    grouped  <- matrix(step_data[1:(n_groups * 5)], ncol=5, byrow=TRUE)
    
    # run qcc silently without plotting
    chart <- qcc(grouped, type="xbar", plot=FALSE)
    
    beyond <- sum(chart$violations$beyond.limits)
    runs   <- length(chart$violations$violating.runs)
    
    results <- rbind(results, data.frame(
      Parameter     = param,
      Process_Step  = step,
      UCL           = round(chart$limits[,2][1], 3),
      LCL           = round(chart$limits[,1][1], 3),
      Beyond_Limits = beyond,
      Violating_Runs= runs,
      Status        = ifelse(beyond > 0 | runs > 0, "⚠ OUT OF CONTROL", "✓ Stable")
    ))
  }
}

print(results)

# Violations Heatmap
library(ggplot2)

# total violations per cell
results$Total_Violations <- results$Beyond_Limits + results$Violating_Runs

ggplot(results, aes(x=Process_Step, y=Parameter, fill=Total_Violations)) +
  geom_tile(color="white", linewidth=0.8) +
  geom_text(aes(label=ifelse(Total_Violations > 0, 
                             paste0("⚠ ", Total_Violations), "✓")), 
            size=3.5, color="white", fontface="bold") +
  scale_fill_gradient(low="#9b59b6", high="#ff69b4", name="Total\nViolations") +
  labs(
    title    = "SPC Violations Heatmap — Wafer Fabrication Process",
    subtitle = "Red = high violations | Blue = stable | ✓ = in control",
    x        = "Process Step",
    y        = "Parameter"
  ) +
  theme_minimal() +
  theme(
    plot.title    = element_text(face="bold", size=14),
    plot.subtitle = element_text(size=10),
    axis.text.x   = element_text(angle=45, hjust=1)
  )
par(bg="white", col.main="#9b59b6", col.lab="#9b59b6") #idc i like pink and purple
