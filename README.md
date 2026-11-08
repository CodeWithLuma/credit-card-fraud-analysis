# Credit Card Fraud Pattern Analysis

**Tools:** Python (pandas, scikit-learn) · SQL · matplotlib

## The question

How do you spot the 0.172% of transactions that are fraud, without drowning
a fraud team in false alarms?

## The data

Public dataset from Kaggle: [Credit Card Fraud Detection](https://www.kaggle.com/datasets/mlg-ulb/creditcardfraud)
(collected by Worldline and the Machine Learning Group of Université Libre de
Bruxelles, ULB).

- **284,807 transactions** made by European cardholders in **September 2013**,
  over just two days.
- **492 fraudulent** (0.172%), **284,315 legitimate**. About **1 in 579**
  transactions is fraud.
- **31 columns:** `Time` (seconds since the first transaction), `V1`–`V28`,
  `Amount`, `Class` (1 = fraud, 0 = legitimate).
- `V1`–`V28` are the result of a PCA transformation. The original features
  are not available, so no real customer behaviour can be read from them —
  this analysis works with amounts, timing, and the anonymised components
  only.

The dataset is **not** included in this repo. See
[`data/DATA_SOURCE.md`](data/DATA_SOURCE.md) for where to get it.

## How to run it

1. Download `creditcard.csv` into `data/` (see `data/DATA_SOURCE.md`).
2. `pip install -r requirements.txt`
3. Open `notebooks/01-fraud-pattern-analysis.ipynb` and run it top to bottom.
4. The SQL queries in `sql/fraud_queries.sql` run on the same CSV loaded
   into a table called `creditcard_fraud`.

## What the data shows

- **Extreme imbalance.** Fraud is 492 out of 284,807 transactions (0.172%).
  Any approach that ignores this will look good on paper and fail in practice.
- **The accuracy trap.** Predicting every transaction as legitimate gives
  **99.83% accuracy** while detecting zero fraud. Accuracy on its own is
  meaningless here — this project judges models on precision, recall, F1
  and the area under the precision–recall curve (AUPRC), which is what the
  Kaggle page itself recommends.
- **Fraud is a small-amount problem in count, not in pattern.** The notebook
  compares the `Amount` distribution for fraud vs legitimate transactions
  and the fraud rate by amount band and by hour of day, all computed from
  the data.
- **A simple baseline works reasonably well.** In one published run of this
  dataset, logistic regression reached an average precision of **0.704** and
  ROC-AUC of **0.973**; a random forest reached average precision **0.838**
  and ROC-AUC **0.957**. The notebook builds the logistic-regression
  baseline with `class_weight='balanced'` and reports precision, recall,
  F1 and AUPRC — not accuracy alone.
- **What the metrics mean for a fraud team:** recall is the share of real
  fraud caught; precision is the share of flagged transactions that are
  really fraud. Raising recall usually means more false alarms, and every
  false alarm costs a real analyst's time. AUPRC summarises that trade-off
  in one number.

## Limitations — read this first

- The data covers **only two days in September 2013**. It cannot represent
  modern fraud patterns or how fraud changes over time.
- `V1`–`V28` are PCA-anonymised. Nothing in this analysis describes what a
  real fraudster does — only statistical patterns in anonymised components.
- These are associations in a public sample, not a production fraud system.
  A real system needs live data, more features, and a cost model for false
  alarms vs missed fraud.

## Files

- `notebooks/01-fraud-pattern-analysis.ipynb` — the full analysis
- `sql/fraud_queries.sql` — the same questions in SQL
- `requirements.txt` — Python packages
- `data/DATA_SOURCE.md` — where the dataset comes from
