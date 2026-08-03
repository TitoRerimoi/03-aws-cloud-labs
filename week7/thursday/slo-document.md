# KijaniKiosk Service Level Objectives

## kk-api (API Service)

### SLIs

1. **Availability**
   - Measures the percentage of successful HTTP requests.
   - Collected from the API health endpoint and nginx access logs.

2. **Latency**
   - Measures how quickly requests are served (95th percentile).
   - Collected using request response times from nginx logs.

3. **Error Rate**
   - Measures the percentage of requests returning HTTP 5xx errors.
   - Calculated from API requests recorded in the access logs.

### SLOs

| SLI | Target | Window | Error Budget |
|-----|--------|--------|--------------|
| Availability | 99.9% | 30 days | 43.2 minutes |
| Latency | 95% under 500 ms | 30 days | 5% may exceed 500 ms |
| Error Rate | Less than 0.1% | 30 days | 1 failure per 1,000 requests |

### Rollback Threshold Justification

The rollback thresholds are more conservative than the SLOs. Rolling back after three consecutive failures or high latency helps prevent a bad deployment from consuming the available error budget.

---

## kk-payments (Payments Service)

### SLIs

1. **Availability**
   - Measures successful payment API responses.
   - Collected from payment endpoint logs.

2. **Latency**
   - Measures payment response time (95th percentile).
   - Collected from request timing logs.

3. **Payment Error Rate**
   - Measures failed payment requests returning 5xx errors.
   - Calculated from payment API logs.

### SLOs

| SLI | Target | Window | Error Budget |
|-----|--------|--------|--------------|
| Availability | 99.9% | 30 days | 43.2 minutes |
| Latency | 95% under 500 ms | 30 days | 5% may exceed 500 ms |
| Payment Error Rate | Less than 0.1% | 30 days | 1 failure per 1,000 requests |

### Rollback Threshold Justification

The monitoring script reacts much faster than the SLO window. It detects deployment issues early so traffic can be switched back before users experience prolonged outages.
