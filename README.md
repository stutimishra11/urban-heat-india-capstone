# Beyond the Headlines: Rethinking Urban Heat Risk in Indian Cities
**Yale Environmental Data Science Certificate Program — Capstone Project**  
**Author:** Stuti Mishra | **Year:** 2025–2026

---

## The Argument

Delhi regularly makes international headlines for record-breaking heat. Bengaluru rarely does. But **absolute temperature and rate of warming are two different things.** A city that was already hot staying hot is not the same as a city that was mild becoming measurably warmer.

This project uses four datasets to ask: when we measure each city against its own long-term historical baseline — rather than comparing raw temperatures — which city is actually warming faster? And do the data on urbanisation, green cover loss, and public perception explain why Bengaluru's warming goes unreported?

The hypothesis is that Bengaluru — due to rapid urbanisation, dramatic loss of green cover, and a high-elevation climate sensitive to change — may be warming faster than Delhi on a relative basis. If true, the current media framing of urban heat in India is obscuring a serious and underreported risk.

---

## Research Questions

1. When measured against each city's own 30-year historical baseline, which city is warming faster: Delhi or Bengaluru?
2. Do temperature anomaly trends suggest Bengaluru's warming is being systematically underreported because headlines focus on absolute peak temperatures rather than relative change?

---

## Methodology

This project uses **temperature anomalies** — the same method used by NASA, NOAA, and the IPCC to measure global warming. Rather than comparing absolute temperatures (which will always favour Delhi), anomalies measure how much each city has deviated from its own long-term past.

- **Baseline period:** 1995–2024 (30-year monthly average per city) — consistent with WMO standards for climate normals
- **Anomaly:** Each monthly observation minus that city's 30-year average for that month
- **Data period:** January 1995 – December 2025 (31 years, 372 observations per city)

---

## Data Sources

| Source | What it measures | Coverage |
|---|---|---|
| NASA POWER MERRA-2 | Near-surface air temperature (T2M) at 2m, monthly averages | 1995–2025, both cities |
| Census of India | Population growth | 2001 & 2011 census |
| Global Forest Watch | Annual tree cover loss (hectares) | 2001–2024, both cities |
| Yale India Climate Opinion Maps | % of residents reporting heatwave experience and climate concern | 2025, district/state level |

**Delhi coordinates:** 28.63°N, 77.22°E  
**Bengaluru coordinates:** 12.97°N, 77.59°E  
**NASA POWER access:** https://power.larc.nasa.gov/data-access-viewer/  
**Yale data access:** https://climatecommunication.yale.edu/visualizations-data/ycomindia

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
│   ├── bengaluru_temperature_1995_2025.csv
│   ├── IND.xlsx (Global Forest Watch — India state level)
│   ├── IndiaMRP1.5_publicdata.xlsx (Yale India Climate Opinion Maps)
│   ├── Tree cover loss in Bangalore, Karnataka, India.zip
│   └── Tree cover loss in NCT of Delhi, India.zip
│
├── notebooks/
│   └── urban-heat-india-capstone.ipynb
│
├── scripts/
│   └── analysis.R
│
├── communication/
│   └── summary.md
│
└── README.md
```

---

## Key Findings

- In absolute terms, Delhi is far hotter than Bengaluru (summer peaks above 37°C vs ~28°C) — explaining the media disparity
- When temperature anomalies are calculated against each city's own 30-year baseline, Bengaluru's trend is positive (+0.0028°C/year) while Delhi's is negative (-0.0133°C/year) in 2010–2025
- Bengaluru recorded a +1.06°C anomaly in 2024 — over a full degree above its own 30-year normal
- Bengaluru grew 49% in population between 2001–2011 vs Delhi's 21%, driving rapid urban heat island intensification
- Both cities had almost no tree cover left by 2000; Bengaluru lost 6.2% of its remaining cover vs Delhi's 4.6%
- 76.2% of Delhi residents report personally experiencing a severe heatwave vs 65.6% in Bengaluru — a perception gap that translates into a policy gap

---

## Ethical Considerations

- **Privacy:** No personal data used. All data is satellite-derived or from public surveys.
- **Governance:** All datasets are open-access and free for educational use.
- **Bias:** MERRA-2 averages over ~50 km² grid cells, potentially smoothing local heat. Media bias toward absolute temperatures may systematically underrepresent warming risk in cities like Bengaluru.
- **Equity:** Urban heat disproportionately affects low-income communities — a dimension not captured here.

---

## Limitations

This analysis uses a 30-year baseline consistent with scientific standards. The T2M variable measures near-surface air temperature rather than land surface temperature, so street-level heat may be underestimated. The baseline period includes the warming trend being studied, which slightly compresses anomaly values. A fuller study would include additional Indian cities and lake/water body loss data for Bengaluru.

---

## How to Reproduce

1. Clone the repository: `git clone https://github.com/stutimishra11/urban-heat-india-capstone`
2. Install R (4.0+) and required packages:
   ```r
   install.packages(c("dplyr", "ggplot2", "tidyr", "readr", "readxl"))
   ```
3. Open `notebooks/urban-heat-india-capstone.ipynb` in CoCalc (R kernel)
4. All data files are in `data/` — no external downloads needed
5. Run all cells top to bottom

---

## Summary Statement

Analysis of 30 years of NASA POWER temperature data (1995–2025), alongside Census of India population figures, Global Forest Watch tree cover loss data, and Yale India Climate Opinion Maps, challenges the assumption that Delhi is India's most alarming urban heat story. Using temperature anomalies — each city measured against its own 30-year baseline — Bengaluru's rate of relative warming emerges as a significant and underreported risk, driven by rapid urbanisation, collapse of green cover, and a perception gap obscured by media coverage focused on Delhi's dramatic but already-expected absolute heat peaks.

---

*Yale School of the Environment — Environmental Data Science Certificate Program 2025–2026*
