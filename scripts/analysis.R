# ============================================================
# Beyond the Headlines: Rethinking Urban Heat Risk in Indian Cities
# Yale Environmental Data Science Capstone 2025-2026
# Author: Stuti Mishra
# Data: NASA POWER MERRA-2, Census of India, Global Forest Watch,
#       Yale India Climate Opinion Maps
# ============================================================

library(dplyr)
library(ggplot2)
library(tidyr)
library(readr)
library(readxl)

# ── 1. LOAD NASA POWER TEMPERATURE DATA ──────────────────────────────────────
delhi_raw <- read_csv("data/delhi_temperature_1995_2025.csv",
                      skip = 9, show_col_types = FALSE)
bengaluru_raw <- read_csv("data/bengaluru_temperature_1995_2025.csv",
                          skip = 9, show_col_types = FALSE)

# ── 2. CLEAN & RESHAPE ────────────────────────────────────────────────────────
clean_city_data <- function(raw_data, city_name) {
  raw_data %>%
    select(-PARAMETER, -ANN) %>%
    mutate(across(where(is.numeric), ~ ifelse(. == -999, NA, .))) %>%
    pivot_longer(cols = JAN:DEC, names_to = "month", values_to = "temp_c") %>%
    mutate(
      city      = city_name,
      month_num = match(month, toupper(month.abb)),
      date      = as.Date(paste(YEAR, sprintf("%02d", month_num), "01", sep = "-"))
    ) %>%
    rename(year = YEAR) %>%
    select(city, year, month, month_num, date, temp_c)
}

delhi_clean     <- clean_city_data(delhi_raw,     "Delhi")
bengaluru_clean <- clean_city_data(bengaluru_raw, "Bengaluru")
combined        <- bind_rows(delhi_clean, bengaluru_clean)

cat("Missing values:", sum(is.na(combined$temp_c)), "\n")
cat("Total rows:", nrow(combined), "\n")

# ── 3. COMPUTE 30-YEAR BASELINE & ANOMALIES ───────────────────────────────────
baseline <- combined %>%
  filter(year %in% 1995:2024) %>%
  group_by(city, month) %>%
  summarize(baseline_temp = mean(temp_c, na.rm = TRUE), .groups = "drop")

combined <- combined %>%
  left_join(baseline, by = c("city", "month")) %>%
  mutate(anomaly = temp_c - baseline_temp)

annual_anomaly <- combined %>%
  group_by(city, year) %>%
  summarize(mean_anomaly = mean(anomaly, na.rm = TRUE), .groups = "drop")

# ── 4. EDA VISUALIZATIONS ─────────────────────────────────────────────────────

# Plot 1: Seasonal profiles (headline view)
monthly_avg <- combined %>%
  group_by(city, month_num, month) %>%
  summarize(avg_temp = mean(temp_c, na.rm = TRUE), .groups = "drop") %>%
  mutate(month = factor(month, levels = month.abb))

ggplot(monthly_avg, aes(x = month, y = avg_temp, color = city, group = city)) +
  geom_line(linewidth = 1.3) + geom_point(size = 3) +
  scale_color_manual(values = c("Delhi" = "#E76F51", "Bengaluru" = "#2A9D8F")) +
  labs(title = "The Headline View: Absolute Monthly Temperatures (30-Year Average)",
       x = "Month", y = "Average Temperature (°C)", color = "City",
       caption = "Source: NASA POWER MERRA-2") +
  theme_minimal(base_size = 13)

# Plot 2: Temperature spread boxplot
ggplot(combined, aes(x = city, y = temp_c, fill = city)) +
  geom_boxplot(alpha = 0.7, outlier.colour = "red") +
  scale_fill_manual(values = c("Delhi" = "#E76F51", "Bengaluru" = "#2A9D8F")) +
  labs(title = "Temperature Spread: Delhi Has Far Greater Variability",
       x = "City", y = "Monthly Temperature (°C)",
       caption = "Source: NASA POWER MERRA-2") +
  theme_minimal(base_size = 13)

# ── 5. FINAL ANALYSIS VISUALIZATIONS ─────────────────────────────────────────

# Plot 3: Annual anomaly trend (core finding)
ggplot(annual_anomaly, aes(x = year, y = mean_anomaly, color = city, group = city)) +
  geom_hline(yintercept = 0, linetype = "dotted", color = "grey50") +
  geom_line(linewidth = 1.2) + geom_point(size = 3) +
  geom_smooth(method = "lm", se = TRUE, linetype = "dashed", alpha = 0.12) +
  scale_color_manual(values = c("Delhi" = "#E76F51", "Bengaluru" = "#2A9D8F")) +
  scale_x_continuous(breaks = seq(1995, 2025, by = 5)) +
  labs(title = "The Real Warming Story: Annual Temperature Anomaly vs 30-Year Baseline",
       x = "Year", y = "Temperature Anomaly (°C above/below baseline)",
       caption = "Source: NASA POWER MERRA-2 | Baseline = 1995-2024") +
  theme_minimal(base_size = 13)

# Plot 4: Monthly anomaly heatmap
combined_heat <- combined %>%
  mutate(month = factor(month, levels = rev(month.abb)))

ggplot(combined_heat, aes(x = factor(year), y = month, fill = anomaly)) +
  geom_tile(color = "white", linewidth = 0.3) +
  scale_fill_gradient2(low = "#313695", mid = "white", high = "#A50026",
                       midpoint = 0, name = "Anomaly (°C)") +
  facet_wrap(~ city, ncol = 1) +
  scale_x_discrete(breaks = as.character(seq(1995, 2025, by = 5))) +
  labs(title = "Monthly Temperature Anomalies: Delhi vs Bengaluru",
       caption = "Source: NASA POWER MERRA-2 | Baseline = 1995-2024") +
  theme_minimal(base_size = 12) +
  theme(strip.text = element_text(face = "bold"),
        axis.text.x = element_text(angle = 45, hjust = 1))

# Plot 5: Cumulative anomaly
cumulative_anomaly <- combined %>%
  arrange(city, date) %>%
  group_by(city) %>%
  mutate(cumulative = cumsum(ifelse(is.na(anomaly), 0, anomaly))) %>%
  ungroup()

ggplot(cumulative_anomaly, aes(x = date, y = cumulative, color = city)) +
  geom_line(linewidth = 1.3) +
  geom_hline(yintercept = 0, linetype = "dotted", color = "grey50") +
  scale_color_manual(values = c("Delhi" = "#E76F51", "Bengaluru" = "#2A9D8F")) +
  labs(title = "Cumulative Temperature Anomaly (1995-2025)",
       x = "Date", y = "Cumulative Anomaly (°C)",
       caption = "Source: NASA POWER MERRA-2 | Baseline = 1995-2024") +
  theme_minimal(base_size = 13)

# ── 6. REGRESSION ─────────────────────────────────────────────────────────────
recent <- annual_anomaly %>% filter(year >= 2010)
delhi_lm     <- lm(mean_anomaly ~ year, data = recent %>% filter(city == "Delhi"))
bengaluru_lm <- lm(mean_anomaly ~ year, data = recent %>% filter(city == "Bengaluru"))

cat("\n=== Delhi Warming Rate (2010-2025) ===\n")
print(summary(delhi_lm))
cat("\n=== Bengaluru Warming Rate (2010-2025) ===\n")
print(summary(bengaluru_lm))
cat("Delhi:    ", round(coef(delhi_lm)["year"], 4), "deg C per year\n")
cat("Bengaluru:", round(coef(bengaluru_lm)["year"], 4), "deg C per year\n")

# ── 7. POPULATION DATA (Census of India) ──────────────────────────────────────
population <- data.frame(
  city = rep(c("Delhi", "Bengaluru"), each = 2),
  year = rep(c(2001, 2011), 2),
  population = c(13.85, 16.79, 5.70, 8.50)
)

ggplot(population, aes(x = year, y = population, color = city, group = city)) +
  geom_line(linewidth = 1.5) + geom_point(size = 5) +
  scale_color_manual(values = c("Delhi" = "#E76F51", "Bengaluru" = "#2A9D8F")) +
  scale_x_continuous(breaks = c(2001, 2011), limits = c(1999, 2014)) +
  labs(title = "Population Growth: Delhi vs Bengaluru (2001-2011)",
       subtitle = "Bengaluru grew 49% vs Delhi's 21%",
       x = "Census Year", y = "Population (millions)",
       caption = "Source: Census of India 2001 & 2011") +
  theme_minimal(base_size = 13)

# ── 8. TREE COVER LOSS (Global Forest Watch) ──────────────────────────────────
delhi_trees <- read_csv(
  unz("data/Tree cover loss in NCT of Delhi, India.zip", "treecover_loss__ha.csv"),
  show_col_types = FALSE)

blr_trees <- read_csv(
  unz("data/Tree cover loss in Bangalore, Karnataka, India.zip",
      "treecover_loss__ha.csv"),
  show_col_types = FALSE)

all_years <- data.frame(year = 2001:2024)
delhi_y <- delhi_trees %>%
  rename(year = umd_tree_cover_loss__year, delhi = umd_tree_cover_loss__ha) %>%
  select(year, delhi)
blr_y <- blr_trees %>%
  rename(year = umd_tree_cover_loss__year, bengaluru = umd_tree_cover_loss__ha) %>%
  select(year, bengaluru)

tree_combined <- all_years %>%
  left_join(delhi_y, by = "year") %>%
  left_join(blr_y, by = "year") %>%
  replace(is.na(.), 0) %>%
  pivot_longer(cols = c(delhi, bengaluru),
               names_to = "city", values_to = "loss_ha") %>%
  mutate(city = ifelse(city == "delhi", "Delhi", "Bengaluru"))

ggplot(tree_combined, aes(x = year, y = loss_ha, fill = city)) +
  geom_col(position = "dodge", width = 0.7, alpha = 0.85) +
  scale_fill_manual(values = c("Delhi" = "#E76F51", "Bengaluru" = "#2A9D8F")) +
  labs(title = "Annual Tree Cover Loss: Delhi vs Bengaluru (2001-2024)",
       x = "Year", y = "Tree cover lost (ha)",
       caption = "Source: Global Forest Watch | Baseline 2000: Delhi=262ha, Bengaluru=162ha") +
  theme_minimal(base_size = 13) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# ── 9. PERCEPTION GAP (Yale India Climate Opinion Maps) ───────────────────────
perception <- data.frame(
  city = rep(c("Delhi", "Bengaluru"), 4),
  question = rep(c(
    "Personally experienced\nsevere heatwave",
    "Personally experienced\nglobal warming effects",
    "Think GW will harm\ntheir community",
    "Worried about\nglobal warming"), each = 2),
  percent = c(76.2, 65.6, 95.6, 88.6, 86.8, 78.5, 93.2, 89.2)
)

ggplot(perception, aes(x = question, y = percent, fill = city)) +
  geom_col(position = "dodge", width = 0.6) +
  geom_text(aes(label = paste0(percent, "%")),
            position = position_dodge(width = 0.6),
            vjust = -0.5, size = 3.5) +
  scale_fill_manual(values = c("Delhi" = "#E76F51", "Bengaluru" = "#2A9D8F")) +
  scale_y_continuous(limits = c(0, 105), labels = function(x) paste0(x, "%")) +
  labs(title = "The Perception Gap: Climate Attitudes in Delhi vs Bengaluru (2025)",
       x = NULL, y = "% of adult population",
       caption = "Source: Yale India Climate Opinion Maps, November 2025") +
  theme_minimal(base_size = 13)
