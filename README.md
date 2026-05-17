# SPC Monitoring Dashboard — Wafer Fabrication Process

A Statistical Process Control (SPC) monitoring pipeline built in R that 
detects out-of-control process signals across real semiconductor fabrication 
sensor data.

---

## Results
- Detected out-of-control signals in 22 of 25 parameter-step combinations
- pressure_torr in CMP flagged highest violations (190)
- temperature_c in Lithography and Oxidation identified as critical (187, 157)
- Automated full HTML report generation via R Markdown

---

## Tools & Libraries
- R 4.x
- qcc (Shewhart control charts, Western Electric Rules)
- ggplot2 (violations heatmap)
- dplyr (data wrangling)
- rmarkdown (automated HTML report)

---

## Dataset
**Semiconductor Wafer Defect Classification Dataset**
- Source: Kaggle
- 5,000 wafer sensor records
- Parameters monitored: temperature, pressure, etch rate, voltage, current
- Process steps: CMP, Deposition, Etching, Lithography, Oxidation

---

## Setup & Running Instructions

### Option 1 — Run the R Script (Charts Only)

1. Install R from https://cran.r-project.org
2. Install R Studio from https://posit.co/download/rstudio-desktop
3. Open R Studio and install required packages by running this in the console:
   
   install.packages(c("qcc", "ggplot2", "dplyr", "rmarkdown"))

4. Place semiconductor_wafer_defect_dataset.csv in the project folder
5. Open spc_dashboard.R and click Run All

### Option 2 — Generate Full HTML Report

1. Complete steps 1–4 above
2. Open spc_report.Rmd in R Studio
3. Click Knit → Knit to HTML
4. spc_report.html will be generated in your project folder

---

## Project Structure

spc-monitoring-dashboard/
│
├── spc_dashboard.R      # Control charts and violations summary
├── spc_report.Rmd       # R Markdown report source
├── spc_report.html      # Generated HTML report
├── semiconductor_wafer_defect_dataset.csv
└── README.md

---

## Key Findings

- pressure_torr and temperature_c are the most unstable parameters
- CMP, Lithography and Oxidation steps show the highest violation counts
- Only 3 parameter-step combinations are fully in control:
  temperature in Deposition, etch rate in Lithography, voltage in Oxidation

---

## Author
Sharon Lee (I build projects when I have nothing to do, yes I am insane)
www.linkedin.com/in/sharon-jia-yi-lee-211251358
