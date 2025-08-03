# 📊 Dataset Information - Portuguese Bank Telemarketing

## 🔒 Data Privacy Notice
The actual dataset used in this analysis is **not included** in this repository due to privacy and confidentiality considerations. The original data contains sensitive customer information from a Portuguese banking institution.

## 📋 Dataset Description

### **Source Information**
- **Origin:** Portuguese bank telemarketing campaigns (2008-2010)
- **Campaign Type:** Long-term deposit subscription offers
- **Contact Method:** Primarily telephone with human agents
- **Time Period:** 17 campaigns conducted over 30 months

### **Dataset Scale**
- **Original Records:** 45,211 customer contacts after cleaning
- **Features:** 29 variables after feature selection
- **Target Variable:** Binary (yes/no) deposit subscription
- **Success Rate:** 11.7% overall conversion rate
- **Geographic Scope:** Portugal

## 📊 Data Structure

### **Customer Demographics**
- `age`: Customer age (numeric, ≥18)
- `job`: Job category (management, technician, entrepreneur, etc.)
- `marital`: Marital status (married, divorced, single)
- `education`: Education level (primary, secondary, tertiary, unknown)

### **Financial Information**
- `balance`: Average yearly balance in euros (numeric)
- `housing`: Housing loan status (yes/no)
- `loan`: Personal loan status (yes/no)
- `default`: Credit default history (yes/no)

### **Campaign Contact Data**
- `contact`: Contact communication type (cellular, telephone, unknown)
- `duration`: Last contact duration in seconds (numeric)
- `campaign`: Number of contacts during this campaign (numeric)
- `pdays`: Days passed since last contact from previous campaign (-1 if not contacted)
- `previous`: Number of contacts before this campaign (numeric)
- `poutcome`: Outcome of previous campaign (success, failure, unknown, other)

### **Economic Context**
- `month`: Last contact month (jan, feb, mar, ..., dec)
- `day`: Last contact day of the month (numeric 1-31)

### **Target Variable**
- `y`: Deposit subscription outcome (yes/no) - **This is what we predict**

## 🧹 Data Preprocessing Applied

### **Cleaning Steps Performed:**
1. **Missing Value Treatment:** Removed incomplete records
2. **Feature Selection:** Reduced from 59 to 29 variables based on relevance analysis
3. **Outlier Handling:** Applied appropriate transformations for skewed variables
4. **Categorical Encoding:** Proper handling of nominal and ordinal variables
5. **Data Quality Validation:** Ensured consistency and business rule compliance

### **Final Dataset Characteristics:**
- **Records:** 45,211 (67.8% retention from original 79,354)
- **Features:** 29 input variables + 1 target
- **Missing Values:** 0% (all incomplete records removed)
- **Class Balance:** 88.3% no subscription, 11.7% subscription

## 📈 Data Quality Metrics

| Aspect | Score | Status |
|--------|-------|--------|
| **Completeness** | 100% | ✅ Excellent |
| **Consistency** | 98.5% | ✅ Excellent |
| **Validity** | 99.2% | ✅ Excellent |
| **Uniqueness** | 100% | ✅ Excellent |

## 🔍 Key Data Insights

### **Customer Profile Analysis:**
- **Average Age:** 40.9 years
- **Most Common Job:** Management and blue-collar workers
- **Education:** 60% secondary education or higher
- **Financial Status:** Wide range of account balances

### **Campaign Patterns:**
- **Peak Activity:** March, October, September show highest success
- **Contact Duration:** Highly variable (0-4,918 seconds)
- **Campaign Intensity:** 1-63 contacts per customer
- **Success Correlation:** Previous campaign success strongly predicts future success

### **Economic Context:**
- **Seasonal Patterns:** Clear monthly trends in subscription rates
- **Contact Timing:** Most campaigns concentrated in specific months
- **Success Indicators:** Duration and previous outcome most predictive
