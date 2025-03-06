## **📌 Python Code for A/B Test Analysis**

```
import numpy as np
import scipy.stats as stats
from scipy.stats import beta
import matplotlib.pyplot as plt
import seaborn as sns

# Set random seed for reproducibility
np.random.seed(42)

# Simulate user data for both groups
n_A = 5000  # Sample size for control group A
n_B = 5000  # Sample size for treatment group B

# Assume true certification rates for simulation
true_p_A = 0.45  # Control group certification rate
true_p_B = 0.51  # Treatment group certification rate

# Simulate certification outcomes (1 = certified, 0 = not certified)
cert_A = np.random.binomial(1, true_p_A, n_A)
cert_B = np.random.binomial(1, true_p_B, n_B)

# Calculate observed certification rates
obs_p_A = np.mean(cert_A)
obs_p_B = np.mean(cert_B)

```
## 1️⃣ Frequentist Approach (Z-Test)
```
# Compute pooled proportion
p_pooled = (cert_A.sum() + cert_B.sum()) / (n_A + n_B)
se_pooled = np.sqrt(p_pooled * (1 - p_pooled) * (1 / n_A + 1 / n_B))

# Compute Z-score
z_score = (obs_p_B - obs_p_A) / se_pooled

# Compute p-value for two-tailed test
p_value_z_test = 2 * (1 - stats.norm.cdf(abs(z_score)))

# Compute Lift Estimate and Confidence Interval
lift = (obs_p_B - obs_p_A) / obs_p_A  # Relative lift calculation
se_lift = np.sqrt((obs_p_A * (1 - obs_p_A) / n_A) + (obs_p_B * (1 - obs_p_B) / n_B))
z_critical = stats.norm.ppf(0.975)  # 1.96 for 95% CI
ci_lower = lift - z_critical * se_lift
ci_upper = lift + z_critical * se_lift

print(f"Frequentist Z-Test Results:")
print(f"Z-Score: {z_score:.4f}")
print(f"P-Value: {p_value_z_test:.4f}")
print(f"Lift Estimate: {lift * 100:.2f}%")
print(f"95% Confidence Interval for Lift: ({ci_lower * 100:.2f}%, {ci_upper * 100:.2f}%)")

```
## 2️⃣ Bayesian Approach (Beta-Binomial)
```
# Prior Parameters
alpha_prior, beta_prior = 1, 1  # Non-informative prior

# Posterior parameters
alpha_A = alpha_prior + cert_A.sum()
beta_A = beta_prior + (n_A - cert_A.sum())
alpha_B = alpha_prior + cert_B.sum()
beta_B = beta_prior + (n_B - cert_B.sum())

# Compute posterior means
posterior_mean_A = alpha_A / (alpha_A + beta_A)
posterior_mean_B = alpha_B / (alpha_B + beta_B)

# Compute probability that B is better than A
prob_B_better_than_A = 1 - beta.cdf(posterior_mean_A, alpha_B, beta_B)

print(f"\nBayesian Test Results:")
print(f"Posterior Mean (A): {posterior_mean_A:.4f}")
print(f"Posterior Mean (B): {posterior_mean_B:.4f}")
print(f"Probability that B is better than A: {prob_B_better_than_A:.4f}")

```
## 3️⃣ Bayesian Posterior Distributions
```
# Generate Bayesian posterior samples using Beta distribution
posterior_samples_A = beta.rvs(alpha_A, beta_A, size=10000)
posterior_samples_B = beta.rvs(alpha_B, beta_B, size=10000)

# Plot the posterior distributions
plt.figure(figsize=(10, 6))
plt.hist(posterior_samples_A, bins=50, alpha=0.5, color="blue", label="Control Group (A)", density=True)
plt.hist(posterior_samples_B, bins=50, alpha=0.5, color="orange", label="Treatment Group (B)", density=True)

# Plot vertical lines for posterior means
plt.axvline(np.mean(posterior_samples_A), color='blue', linestyle='dashed', label=f'Posterior Mean A: {np.mean(posterior_samples_A):.4f}')
plt.axvline(np.mean(posterior_samples_B), color='orange', linestyle='dashed', label=f'Posterior Mean B: {np.mean(posterior_samples_B):.4f}')

plt.xlabel("Certification Rate")
plt.ylabel("Density")
plt.title("Bayesian Posterior Distributions for Certification Rates")
plt.legend()
plt.show()
```
<img width="1107" alt="Screenshot 2025-03-06 at 8 17 26 pm" src="https://github.com/user-attachments/assets/c6005412-e82c-4020-9605-11f88ffed339" />

