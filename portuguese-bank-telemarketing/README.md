# 🏦 Portuguese Bank Telemarketing Campaign Optimization

**Predictive modeling to improve deposit subscription campaigns using data-driven customer targeting**

## 📋 Executive Summary
Analyzed telemarketing campaign data from a Portuguese bank to optimize deposit subscription rates. Current broad-approach campaigns achieve only 8% conversion with $2 per call costs. Through advanced analytics, identified targeting strategies that could achieve 46% conversion rates for high-potential customer segments.

## 🎯 Business Problem
- **Low Efficiency:** 8% baseline conversion rate across all customers
- **High Costs:** $2 per call with 14 calls/agent/hour capacity
- **Resource Waste:** Broad targeting leads to poor resource allocation
- **ROI Challenge:** Current strategy operates at a loss

## 📊 Dataset Overview
- **Source:** Portuguese bank telemarketing campaigns (2008-2010)
- **Scale:** 45,211 customer contacts across 17 campaigns  
- **Success Rate:** 11.7% after data cleaning (5,289 successful subscriptions)
- **Features:** 29 variables including demographics, contact history, economic indicators

## 🔬 Methodology

### **CRISP-DM Framework Applied:**
1. **Business Understanding:** Campaign efficiency optimization
2. **Data Understanding:** Exploratory analysis of 45K+ contacts
3. **Data Preparation:** Feature selection, missing value treatment
4. **Modeling:** Logistic regression, decision trees, SVM comparison
5. **Evaluation:** ROC analysis, lift curves, business impact assessment
6. **Deployment:** Strategic recommendations for implementation

### **Models Developed:**
- **Logistic Regression:** Interpretable coefficients for business insights
- **Decision Trees:** Rule-based targeting strategies  
- **Support Vector Machine:** Highest predictive accuracy (93.8% AUC)

## 🚀 Key Findings

### **Critical Success Factors:**
1. **Call Duration Impact:** 
   - Calls >9 minutes: 46% conversion rate
   - Calls <9 minutes: 8% conversion rate
   - **Insight:** Quality over quantity approach needed

2. **Optimal Timing:**
   - Peak months: March, October, September
   - **Strategy:** Concentrate campaigns during high-conversion periods

3. **Customer Segmentation:**
   - Previous subscribers: 5x higher conversion probability
   - Higher bank balance customers: significantly more likely to subscribe
   - Housing loan holders: lower conversion rates

4. **Contact Frequency:**
   - Diminishing returns with multiple contacts
   - **Recommendation:** Limit follow-ups to avoid customer fatigue

## 💰 Business Impact Analysis

### **Current State:**
- Cost per call: $2
- Calls per hour: 14
- Success rate: 8%
- **Result:** Loss-making operation

### **Optimized Strategy:**
- Target high-potential segments (top 10% predicted probability)
- Focus on 9+ minute quality calls
- Campaign during peak months
- **Projected Results:**
  - 1,000 targeted calls → 460 deposits
  - Revenue: $9,200 (assuming $20 profit per deposit)
  - Cost: $2,000
  - **Net Profit: $7,200**

## 📈 Model Performance

| Model | AUC Score | Lift (Top 10%) | Business Application |
|-------|-----------|----------------|---------------------|
| Logistic Regression | 0.870 | 2.8x | Interpretable insights |
| Decision Tree | 0.868 | 2.7x | Rule-based targeting |
| **SVM** | **0.938** | **3.2x** | **Highest accuracy** |

## 🎯 Strategic Recommendations

### **Immediate Actions:**
1. **Agent Training:** Implement scripts for 9+ minute engagement
2. **Customer Prioritization:** Focus on previous subscribers and high-balance accounts
3. **Campaign Timing:** Schedule major efforts in March, October, September
4. **Contact Limits:** Maximum 2-3 attempts per customer

### **Long-term Strategy:**
1. **Predictive Scoring:** Implement SVM model for real-time customer scoring
2. **A/B Testing:** Validate findings through controlled experiments
3. **Performance Monitoring:** Track conversion rates and ROI improvements
4. **Continuous Improvement:** Regular model updates with new campaign data

## 🛠️ Technical Implementation

### **Files Structure:**
- `analysis/bank.R`: Core logistic regression analysis
- `analysis/bank_ExtendedAnalysis.R`: Advanced modeling with trees and SVM
- `reports/telemarketing_analysis.pdf`: Executive presentation
- `outputs/`: Model results and performance metrics

### **Key R Packages Used:**
```r
library(rpart)      # Decision trees
library(e1071)      # SVM modeling  
library(car)        # Statistical analysis
library(psych)      # Descriptive statistics
library(rattle)     # Data visualization
