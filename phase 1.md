# Phase 1: Choosing a Statistical Test for A/B Testing

For this A/B test, I propose using **both a Frequentist (Two-Proportion Z-Test) and a Bayesian approach** to determine if there is a significant difference in certification rates between the control group (A) and the treatment group (B).

While both methods provide insights, **I ultimately recommend using the Bayesian approach** for decision-making.

---

# Phase 1: A/B Test Results – Frequentist vs Bayesian Approach

## **1️⃣ Frequentist Test (Two-Proportion Z-Test)**
- **Z-Score**: **1.9546**
- **P-Value**: **0.0506**
- **Lift Estimate**: **13.75%** (B is estimated to have a 13.75% higher certification rate than A)
- **95% Confidence Interval for Lift**: **(7.56%, 19.93%)**
- **Conclusion**: *Fail to Reject Null Hypothesis* (at the 0.05 threshold)

### **Does "Fail to Reject Null" mean B is not better than A?**
No. It means that **the evidence is not strong enough** to conclude that B is **statistically significantly** better than A, **given the threshold of 0.05**.  
However, this does **not mean** that B isn't better—it only means we can't **rule out the possibility that the observed effect is due to chance**.

---

## **2️⃣ Bayesian Test (Beta-Binomial)**
- **Posterior Mean for A (Control)**: **0.4495** (~44.95% certification rate)
- **Posterior Mean for B (Treatment)**: **0.5110** (~51.10% certification rate)
- **Probability that B is better than A**: **99.71%**
- **Conclusion**: *P(B > A) = 0.9971*, strong evidence that **B is better than A**.

### **Interpretation of Bayesian Results**
- Instead of a **p-value**, Bayesian testing gives us a **probability**: we are **~99.7% confident** that **B outperforms A**.
- This is **easier to interpret** and **more actionable** than a p-value.
- However, Bayesian testing **can lead to early stopping** if not monitored correctly.

---

## **📌 Key Takeaways**
| **Aspect**  | **Frequentist (Z-Test)** | **Bayesian (Beta-Binomial)** |
|------------|----------------------|--------------------------|
| **Interpretability** | P-value (0.0506) tells us if we reject H₀ | **P(B > A) = 0.9971**, a probability-based decision |
| **Confidence Interval for Lift** | (7.56%, 19.93%) | Bayesian model does not provide a CI for lift directly |
| **Decision Making** | Needs a fixed sample size, can’t continuously monitor | Can update posterior probability as data comes in |
| **Early Stopping Risk** | No, requires a fixed test duration | Yes, risk of stopping too soon |
| **Business Relevance** | Harder to explain to stakeholders | More intuitive (probability-based) |

Given the above, I **recommend using Bayesian testing**, but ensuring a **minimum test duration** to avoid premature stopping.

---

## **📌 Python Code for A/B Test Analysis**
### **1️⃣ Frequentist Test (Two-Proportion Z-Test)**
```python
import numpy as np
import pandas as pd
import scipy.stats as stats

# Compute proportions and sample sizes for A and B
cert_A = contingency_table.loc['A', 1]
total_A = contingency_table.loc['A'].sum()
cert_B = contingency_table.loc['B', 1]
total_B = contingency_table.loc['B'].sum()

# Proportions
p_A = cert_A / total_A
p_B = cert_B / total_B

# Pooled proportion for standard error calculation
p_pooled = (cert_A + cert_B) / (total_A + total_B)
se_pooled = np.sqrt(p_pooled * (1 - p_pooled) * (1 / total_A + 1 / total_B))

# Compute Z-score
z_score = (p_B - p_A) / se_pooled

# Compute p-value for two-tailed test
p_value_z_test = 2 * (1 - stats.norm.cdf(abs(z_score)))

# Compute the confidence interval for the lift
lift = (p_B - p_A) / p_A  # Relative lift calculation
se_lift = np.sqrt((p_A * (1 - p_A) / total_A) + (p_B * (1 - p_B) / total_B))
z_critical = stats.norm.ppf(0.975)  # 1.96 for 95% CI
ci_lower = lift - z_critical * se_lift
ci_upper = lift + z_critical * se_lift

print(f"Z-Score: {z_score:.4f}")
print(f"P-Value: {p_value_z_test:.4f}")
print(f"Lift Estimate: {lift * 100:.2f}%")
print(f"95% Confidence Interval for Lift: ({ci_lower * 100:.2f}%, {ci_upper * 100:.2f}%)")

