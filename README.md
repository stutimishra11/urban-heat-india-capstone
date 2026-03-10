# Beyond the Headlines: Rethinking Urban Heat Risk in Indian Cities
**Yale Environmental Data Science Certificate Program — Capstone Project**  
**Author:** Stuti Mishra | **Year:** 2025–2026

---

## The Argument

Delhi regularly makes international headlines for record-breaking heat. Bengaluru rarely does. But **absolute temperature and rate of warming are two different things.** A city that was already hot staying hot is not the same as a city that was mild becoming measurably warmer.

This project uses 30 years of NASA satellite data (1995–2025) to ask: when we measure each city against its own long-term historical baseline, rather than comparing raw temperatures, which city is actually warming faster?

The hypothesis is that Bengaluru, due to rapid urbanisation, dramatic loss of green cover, and a high-elevation climate sensitive to change, may be warming faster than Delhi on a relative basis. If true, the current media framing of urban heat in India is obscuring an underreported risk.

---

## Research Questions

1. When measured against each city's own 30-year historical baseline, which city is warming faster: Delhi or Bengaluru?
2. Do temperature anomaly trends suggest Bengaluru's warming is being systematically underreported because headlines focus on absolute peak temperatures rather than relative change?

---

## Methodology

This project uses **temperature anomalies** — the same method used by NASA, NOAA, and the IPCC to measure global warming. Rather than comparing absolute temperatures (which will always favour Delhi), anomalies measure how much each city has deviated from its own long-term past.

**Baseline period:** 1995–2024 (30-year monthly average per city) — consistent with WMO standards for climate normals  
**Anomaly:** Each monthly observation minus that city's 30-year average for that month  
**Data period:** January 1995 – December 2025 (31 years, 372 observations per city)

---

## Data Source

| Field | Details |
|---|---|
| **Provider** | NASA POWER (Prediction Of Worldwide Energy Resources) |
| **Dataset** | MERRA-2 Reanalysis |
| **Variable** | T2M — Near-surface air temperature at 2 meters (°C), monthly averages |
| **Period** | January 1995 – December 2025 |
| **Delhi coordinates** | 28.63°N, 77.22°E |
| **Bengaluru coordinates** | 12.97°N, 77.59°E |
| **Access** | https://power.larc.nasa.gov/data-access-viewer/ |
| **License** | NASA Open Data — free for research and educational use |

### Data Dictionary

| Variable | Description | Units |
|---|---|---|
| `city` | City name (Delhi or Bengaluru) | — |
| `year` | Calendar year | 1995–2025 |
| `month` | Month abbreviation | JAN–DEC |
| `month_num` | Month as a number | 1–12 |
| `date` | First day of the month | YYYY-MM-DD |
| `temp_c` | Average air temperature at 2m above ground | °C |
| `baseline_temp` | City's 30-year average for that month (1995–2024) | °C |
| `anomaly` | Deviation from baseline (temp_c minus baseline_temp) | °C |

---

## Repository Structure

```
urban-heat-india-capstone/
│
├── data/
│   ├── delhi_temperature_1995_2025.csv
│   └── bengaluru_temperature_1995_2025.csv
│
├── notebooks/
│   └── urban-heat-india-capstone.ipynb
│
├── scripts/
│   └── analysis.R
│
├── cleaning/
├── analysis/
├── communication/
│   └── summary.md
│
└── README.md
```

---

## Key Findings

- In absolute terms, Delhi is far hotter than Bengaluru (summer peaks above 37°C vs ~28°C) — explaining the media disparity.
- When temperature anomalies are calculated against each city's own 30-year baseline, both cities are compared on equal terms.
- The regression slope of each city's anomaly trend (2010–2025) reveals which city is warming faster *relative to its own past*.
- Bengaluru's rapid urbanisation — millions of new residents, extensive loss of lakes and tree cover — is a plausible and underreported driver of relative warming.

---

## Ethical Considerations

- **Privacy:** No personal data used. All data is satellite-derived.
- **Governance:** NASA POWER is open-access, free for educational use.
- **Bias:** MERRA-2 averages over ~50 km² grid cells, potentially smoothing local heat. Media bias toward absolute temperatures may systematically underrepresent warming risk in cities like Bengaluru.
- **Equity:** Urban heat disproportionately affects low-income communities — a dimension not captured here.

---

## Limitations

This analysis uses a 30-year baseline consistent with scientific standards. The T2M variable measures near-surface air temperature rather than land surface temperature, so street-level heat may be underestimated. The baseline period includes the warming trend being studied, which slightly compresses anomaly values. A fuller study would include additional Indian cities.

---

## How to Reproduce

1. Clone the repository: `git clone https://github.com/stutimishra11/urban-heat-india-capstone`
2. Install R (4.0+) and required packages:
   ```r
   install.packages(c("dplyr", "ggplot2", "tidyr", "readr"))
   ```
3. Open `notebooks/urban-heat-india-capstone.ipynb` in CoCalc (R kernel).
4. Data files are in `data/` — no external downloads needed.
5. Run all cells top to bottom.

---

## Summary Statement

> Analysis of 30 years of NASA POWER temperature data (1995–2025) challenges the assumption that Delhi is India's most alarming urban heat story. Using temperature anomalies — each city measured against its own 30-year baseline — Bengaluru's rate of relative warming emerges as a significant and underreported risk, obscured by media coverage focused on Delhi's dramatic but already-expected absolute heat peaks.

---

*Yale School of the Environment — Environmental Data Science Certificate Program 2025–2026*
