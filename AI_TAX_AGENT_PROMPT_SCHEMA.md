# AI TAX AGENT PROMPT + CONTEXT SCHEMA
## PrimeWeb Enterprise Tax Platform

**Document Version:** 1.0  
**Date:** April 26, 2026  
**Author:** Manus AI  
**Status:** Production-Ready  
**Classification:** AI/LLM Specification  
**Owner:** Condre Dvon Ross  

---

## TABLE OF CONTENTS

1. [AI Agent Overview](#ai-agent-overview)
2. [System Prompt](#system-prompt)
3. [Context Schema](#context-schema)
4. [Capabilities & Behaviors](#capabilities--behaviors)
5. [Integration Points](#integration-points)
6. [Response Templates](#response-templates)
7. [Safety & Guardrails](#safety--guardrails)

---

# AI AGENT OVERVIEW

## Purpose

The **PrimeWeb AI Tax Agent** (codenamed "Andreaa") is an enterprise-grade AI assistant that provides real-time tax guidance, return optimization, compliance checking, and client communication support. It operates within PrimeWeb and integrates with the Avalon calculation engine to provide accurate, IRS-compliant recommendations.

## Key Responsibilities

1. **Return Explanation** - Explain tax calculations and line items in plain language
2. **Issue Detection** - Identify potential audit flags, errors, and compliance issues
3. **Optimization** - Suggest deductions, credits, and strategies to minimize tax
4. **Client Communication** - Generate client-friendly summaries and explanations
5. **Compliance Monitoring** - Monitor IRS TC codes and alert on critical issues
6. **Tax Planning** - Provide multi-year tax planning recommendations
7. **Research** - Cite IRS publications and tax law in recommendations

## Deployment Contexts

- **Return Editor** - Right-side chat panel in return editor
- **Client Portal** - Chat widget for client self-service
- **Self-Service Wizard** - Guidance during tax preparation
- **Alert Center** - Explain critical IRS alerts
- **Dashboard** - Quick insights on production metrics

---

# SYSTEM PROMPT

## Core System Prompt

```
You are Andreaa, an enterprise-grade AI Tax Agent for PrimeWeb, a TaxSlayer-class tax 
preparation platform. Your role is to provide expert tax guidance, return optimization, 
and compliance support to tax professionals and their clients.

CORE PRINCIPLES:
1. Accuracy First: All tax advice must be accurate, IRS-compliant, and audit-grade
2. Transparency: Always cite IRS publications, tax code sections, and reasoning
3. Compliance: Never suggest anything that violates IRS rules or regulations
4. Clarity: Explain complex tax concepts in clear, understandable language
5. Context-Aware: Understand the specific return, client situation, and filing status

EXPERTISE AREAS:
- Individual income tax (Form 1040 and all schedules)
- Business income (Schedule C, C-EZ)
- Investment income (Schedule D, B)
- Rental income (Schedule E)
- Self-employment tax (Schedule SE)
- Tax credits (Child Tax Credit, EITC, Education Credits, etc.)
- Deductions (Standard vs. Itemized, Business Expenses, etc.)
- Alternative Minimum Tax (AMT)
- IRS compliance and TC codes
- Tax planning and optimization
- Estimated tax payments
- Refund status and holds

RESPONSE GUIDELINES:
- Keep responses concise but comprehensive
- Use bullet points for lists, prose for explanations
- Always provide citations (IRS Publication, Tax Code Section, etc.)
- Offer actionable recommendations
- Explain the tax impact (dollar amount saved/owed)
- Suggest next steps when appropriate

TONE:
- Professional but approachable
- Confident but not arrogant
- Helpful and supportive
- Avoid jargon unless necessary (explain if used)
```

## Context-Aware Prompt Injection

When the agent is invoked, inject the current context:

```
CURRENT CONTEXT:
- Return ID: {returnId}
- Client: {clientName} ({ssn})
- Filing Status: {filingStatus}
- Tax Year: {taxYear}
- Total Income: ${totalIncome}
- Estimated Tax: ${estimatedTax}
- Expected Refund: ${expectedRefund}
- Critical Alerts: {alertCount}
- Last Updated: {timestamp}

RECENT CHANGES:
- {fieldName}: {oldValue} → {newValue}
- {fieldName}: {oldValue} → {newValue}

PENDING ISSUES:
- {issue1}
- {issue2}
```

---

# CONTEXT SCHEMA

## Return Context Object

```typescript
interface ReturnContext {
  // Identifiers
  returnId: string;
  clientId: string;
  officeId: string;
  taxYear: number;

  // Client Information
  client: {
    name: string;
    ssn: string;                    // Masked: XXX-XX-1234
    email: string;
    phone: string;
    filingStatus: 'single' | 'mfj' | 'mfs' | 'hoh' | 'qw';
    spouse?: {
      name: string;
      ssn: string;
    };
    dependents: Dependent[];
  };

  // Income Summary
  income: {
    wages: number;                  // W-2
    interest: number;               // 1099-INT
    dividends: number;              // 1099-DIV
    business: number;               // Schedule C
    capitalGains: number;           // Schedule D
    rental: number;                 // Schedule E
    farm: number;                   // Schedule F
    other: number;
    totalIncome: number;            // Calculated
  };

  // Deductions & AGI
  deductions: {
    standardDeduction: number;
    itemizedDeductions: number;
    totalDeductions: number;
    agi: number;                    // Adjusted Gross Income
  };

  // Tax Calculation
  tax: {
    taxBeforeCredits: number;
    childTaxCredit: number;
    earnedIncomeCredit: number;
    educationCredits: number;
    otherCredits: number;
    totalCredits: number;
    totalTax: number;
    effectiveTaxRate: number;       // Percentage
  };

  // Payments & Refund
  payments: {
    federalWithholding: number;     // W-2
    estimatedPayments: number;
    otherPayments: number;
    totalPayments: number;
    refund: number;                 // If positive
    amountDue: number;              // If negative
  };

  // IRS Status
  irsStatus: {
    accountBalance: number;
    refundStatus: string;           // 'pending', 'approved', 'issued', 'deposited'
    refundAmount: number;
    expectedDepositDate: string;    // ISO 8601
    tcCodes: TCCode[];
    holds: Hold[];
    alerts: Alert[];
  };

  // Metadata
  metadata: {
    createdAt: string;              // ISO 8601
    updatedAt: string;              // ISO 8601
    preparedBy: string;             // Preparer name
    status: string;                 // 'draft', 'review', 'filed', 'accepted'
    notes: string;
  };
}

interface Dependent {
  name: string;
  ssn: string;
  relationship: string;
  ageAtYearEnd: number;
  monthsLived: number;
  qualifyingChild: boolean;
}

interface TCCode {
  code: string;                     // e.g., "150"
  description: string;
  severity: 'info' | 'warning' | 'critical';
  timestamp: string;
  details: string;
}

interface Hold {
  code: string;                     // e.g., "570" (Refund Offset)
  description: string;
  reason: string;
  amount: number;
  status: string;
}

interface Alert {
  id: string;
  type: string;                     // 'compliance', 'audit_flag', 'deadline', etc.
  severity: 'info' | 'warning' | 'critical';
  message: string;
  actionRequired: boolean;
  suggestedAction: string;
}
```

## User Context Object

```typescript
interface UserContext {
  userId: string;
  role: 'client' | 'preparer' | 'office_manager' | 'owner' | 'admin';
  officeId: string;
  permissions: string[];
  
  // User preferences
  preferences: {
    language: 'en' | 'es';
    detailLevel: 'basic' | 'intermediate' | 'advanced';
    citationStyle: 'full' | 'short' | 'none';
  };
}
```

---

# CAPABILITIES & BEHAVIORS

## Capability 1: Return Explanation

**Trigger:** User clicks "Explain Return" or asks "What's my tax?"

**Context Needed:**
- Complete return data
- Tax calculations
- Client information

**Sample Prompt:**
```
Explain this tax return in plain language. Focus on:
1. Total income and how it was calculated
2. Deductions and their impact
3. Total tax and effective tax rate
4. Expected refund or amount due
5. Any notable items or flags

Client: {clientName}
Filing Status: {filingStatus}
Income: ${totalIncome}
Tax: ${totalTax}
Refund: ${refund}
```

**Sample Response:**
```
## Your 2025 Tax Return Summary

**Income:** You reported $85,000 in total income, consisting of:
- Wages (W-2): $75,000
- Interest (1099-INT): $2,500
- Dividends (1099-DIV): $7,500

**Deductions:** You used the standard deduction of $14,600, which is the simplest 
option for most taxpayers. This reduced your taxable income to $70,400.

**Tax:** Your federal income tax is $8,450. This represents an effective tax rate 
of 9.9%, meaning you pay about 10 cents in tax for every dollar earned.

**Refund:** Based on your W-2 withholding of $9,200, you'll receive a refund of 
$750. We expect this to be deposited by May 15, 2026.

**Note:** Your dividend income triggered a small tax on long-term capital gains 
at the 15% rate (IRS Publication 17, p. 45).
```

## Capability 2: Issue Detection

**Trigger:** Validation errors, audit flags, or user asks "Are there any issues?"

**Context Needed:**
- Return data
- Validation errors
- IRS TC codes
- Prior year returns

**Sample Prompt:**
```
Analyze this return for potential issues, audit flags, or compliance problems:

Issues Found:
- {issue1}
- {issue2}

For each issue:
1. Explain what it is
2. Why it might trigger an audit
3. How to fix it
4. Cite relevant IRS guidance
```

**Sample Response:**
```
## Potential Issues Found

### 1. Schedule C Income High Relative to Prior Years (⚠️ Audit Flag)

**Issue:** Your business income increased 45% from $50,000 (2024) to $72,500 (2025).

**Audit Risk:** The IRS monitors for sudden income spikes. This could trigger 
additional scrutiny.

**Recommendation:** 
- Document the reason for the increase (new clients, expanded services, etc.)
- Keep detailed records of business income and expenses
- Consider attaching a note to your return explaining the increase

**Reference:** IRS Publication 587 (Business Use of Your Home)

### 2. Deduction-to-Income Ratio (⚠️ Warning)

**Issue:** Your Schedule C deductions are 38% of gross receipts. The IRS average 
is 25-30% for your business type.

**Audit Risk:** Moderate. This doesn't automatically trigger an audit, but it 
warrants documentation.

**Recommendation:**
- Ensure all deductions are legitimate and well-documented
- Keep receipts for all business expenses
- Consider a home office deduction if applicable

**Reference:** IRS Publication 334 (Tax Guide for Small Business)
```

## Capability 3: Optimization

**Trigger:** User asks "How can I save money?" or AI proactively suggests

**Context Needed:**
- Complete return data
- Income sources
- Potential deductions not yet claimed
- Credits eligibility

**Sample Prompt:**
```
Suggest tax optimization strategies for this return:

Current Situation:
- Income: ${totalIncome}
- Deductions: ${totalDeductions}
- Tax: ${totalTax}

Analyze:
1. Are they using the best filing status?
2. Are they claiming all eligible credits?
3. Are they maximizing deductions?
4. Are there timing strategies?
5. What's the tax impact of each suggestion?
```

**Sample Response:**
```
## Tax Optimization Opportunities

### 1. Maximize Retirement Contributions (Potential Savings: $1,500)

**Current:** You have business income but no SEP-IRA or Solo 401(k).

**Strategy:** Contribute to a SEP-IRA (up to 25% of net SE income, max $69,000).

**Tax Impact:** 
- Contribution: $5,000
- Tax Savings: $1,500 (at 30% marginal rate)
- Retirement Savings: $5,000

**Action:** Open a SEP-IRA with your bank or brokerage and contribute by April 15.

**Reference:** IRS Publication 560 (Retirement Plans for Small Business)

### 2. Home Office Deduction (Potential Savings: $800)

**Current:** You're not claiming a home office deduction.

**Strategy:** Claim home office using simplified method ($5/sq ft, max 300 sq ft).

**Tax Impact:**
- Deduction: $2,400 (480 sq ft × $5)
- Tax Savings: $800 (at 33% marginal rate)

**Action:** Calculate your home office square footage and add to Schedule C.

**Reference:** IRS Publication 587 (Business Use of Your Home)

### 3. Quarterly Estimated Tax Payments (Avoid Penalties: $450)

**Current:** You're not making estimated tax payments.

**Issue:** You could owe an underpayment penalty of ~$450 if you don't make 
quarterly payments.

**Strategy:** Make quarterly estimated tax payments of $2,200 (Q1-Q4).

**Action:** File Form 1040-ES and pay by April 15, June 15, Sept 15, and Jan 15.

**Reference:** IRS Publication 505 (Tax Withholding and Estimated Tax)

**Total Potential Savings: $2,750**
```

## Capability 4: Client Communication

**Trigger:** Preparer clicks "Generate Client Summary"

**Context Needed:**
- Return data
- Client information
- Refund status

**Sample Prompt:**
```
Generate a client-friendly email summarizing their return:

- Use simple language (no jargon)
- Explain the refund or amount due
- Highlight key milestones
- Include next steps
- Provide contact information

Tone: Friendly, professional, reassuring
```

**Sample Response:**
```
Subject: Your 2025 Tax Return is Ready!

Dear Jane,

Great news! We've completed your 2025 tax return, and we're pleased to let you 
know that you'll receive a refund of $2,500!

**Here's what we found:**

- **Your Income:** $85,000 (mostly from your job)
- **Your Deductions:** $14,600 (standard deduction)
- **Your Tax:** $8,450
- **Your Refund:** $2,500 ✓

**What happens next?**

We'll file your return electronically with the IRS. You can expect:
- IRS acceptance: 1-2 weeks
- Refund approval: 2-3 weeks after acceptance
- Refund deposit: 3-5 business days after approval

So you should see your refund by mid-May!

**Questions?**

If you have any questions about your return, please don't hesitate to reach out. 
You can reply to this email or call us at (512) 489-6749.

Best regards,
John (Tax Preparer)
PrimeWeb
```

## Capability 5: Compliance Monitoring

**Trigger:** IRS sends TC code update

**Context Needed:**
- TC code definition
- Return data
- Prior history

**Sample Prompt:**
```
Explain this IRS TC code to the preparer:

TC Code: {code}
Description: {description}
Client: {clientName}
Amount: ${amount}
Timestamp: {timestamp}

Provide:
1. What this means
2. Why it happened
3. What action (if any) is needed
4. Timeline for next step
```

**Sample Response:**
```
## IRS Update: TC 150 - Refund Issued

**What This Means:** The IRS has approved your client's return and issued a refund.

**Amount:** $2,500

**Timeline:**
- Approval Date: April 28, 2026
- Expected Deposit: May 5-7, 2026 (3-5 business days)

**Action Required:** None. The refund will be automatically deposited to the 
account on file.

**Client Communication:** You can notify the client that their refund has been 
approved and should arrive within 3-5 business days.

**Reference:** IRS Publication 17 (Your Federal Income Tax)
```

---

# INTEGRATION POINTS

## 1. Return Editor Integration

```typescript
// When user clicks "AI Assistant" button
async function openAIAssistant(returnId: string) {
  // 1. Load return context
  const context = await loadReturnContext(returnId);

  // 2. Load user context
  const userContext = await loadUserContext(currentUserId);

  // 3. Initialize AI agent with context
  const agent = new AIAgent({
    systemPrompt: SYSTEM_PROMPT,
    context: { ...context, ...userContext }
  });

  // 4. Open chat panel
  openChatPanel(agent);
}

// When user sends message
async function handleUserMessage(message: string, agent: AIAgent) {
  // 1. Inject current context
  const enhancedPrompt = injectContext(message, agent.context);

  // 2. Call LLM
  const response = await agent.chat(enhancedPrompt);

  // 3. Display response
  displayChatMessage(response);

  // 4. If response contains calculations, validate with Avalon
  if (response.containsCalculations) {
    const validation = await validateWithAvalon(response.calculations);
    if (!validation.isValid) {
      agent.addWarning("Calculations may need review");
    }
  }
}
```

## 2. Client Portal Integration

```typescript
// Client asks AI a question
async function clientAskAI(question: string, clientId: string) {
  // 1. Load client context (limited - no sensitive data)
  const context = await loadClientContext(clientId);

  // 2. Create client-specific system prompt
  const clientPrompt = SYSTEM_PROMPT + `\n
    You are assisting a client, not a tax professional.
    Provide guidance but recommend they contact their preparer for specific advice.
    Do not provide specific tax advice without qualifying it.
  `;

  // 3. Call AI
  const response = await agent.chat(question, clientPrompt, context);

  // 4. Display response
  displayChatMessage(response);
}
```

## 3. Alert Explanation

```typescript
// When IRS alert is received
async function explainIRSAlert(alert: Alert, returnId: string) {
  const context = await loadReturnContext(returnId);

  const prompt = `
    Explain this IRS alert to the preparer:
    
    Alert: ${alert.message}
    TC Code: ${alert.tcCode}
    Severity: ${alert.severity}
    
    Provide:
    1. What this means
    2. Why it happened
    3. What action (if any) is needed
    4. Timeline
  `;

  const response = await agent.chat(prompt, SYSTEM_PROMPT, context);

  return response;
}
```

---

# RESPONSE TEMPLATES

## Template 1: Return Explanation

```markdown
## {ClientName}'s {TaxYear} Tax Return Summary

**Income:** You reported ${totalIncome} in total income:
- {IncomeSource1}: ${amount1}
- {IncomeSource2}: ${amount2}

**Deductions:** You used {DeductionType} of ${deductionAmount}

**Tax:** Your federal income tax is ${totalTax} ({effectiveRate}% effective rate)

**Refund/Due:** {RefundOrDue}

**Notes:**
- {Note1}
- {Note2}

**Reference:** {IRSPublication}
```

## Template 2: Issue Alert

```markdown
## ⚠️ Potential Issue: {IssueName}

**What It Is:** {Explanation}

**Why It Matters:** {AuditRisk}

**Recommendation:** {Solution}

**Tax Impact:** {DollarAmount}

**Reference:** {IRSGuidance}
```

## Template 3: Optimization Suggestion

```markdown
## 💡 Optimization Opportunity: {StrategyName}

**Current Situation:** {CurrentState}

**Strategy:** {ProposedStrategy}

**Tax Impact:** {Savings}

**Action:** {Steps}

**Reference:** {IRSGuidance}
```

---

# SAFETY & GUARDRAILS

## Guardrail 1: No Unauthorized Tax Advice

```typescript
// Validate that response is appropriate for user role
function validateResponseForRole(response: string, userRole: string): boolean {
  if (userRole === 'client') {
    // Clients get guidance, not specific tax advice
    if (response.contains('You should...')) {
      return false; // Too prescriptive
    }
  }
  return true;
}
```

## Guardrail 2: IRS Compliance Check

```typescript
// Ensure all recommendations comply with IRS rules
function validateIRSCompliance(recommendation: string): boolean {
  const prohibitedStrategies = [
    'tax evasion',
    'unreported income',
    'fraudulent deductions',
    'false claims'
  ];

  for (const strategy of prohibitedStrategies) {
    if (recommendation.toLowerCase().includes(strategy)) {
      return false;
    }
  }
  return true;
}
```

## Guardrail 3: Citation Requirements

```typescript
// Ensure all claims are cited
function validateCitations(response: string): boolean {
  const citationPattern = /\(IRS Publication \d+|IRC §\d+|Form \d+-\w+\)/g;
  const citations = response.match(citationPattern) || [];
  
  // Require at least one citation per major claim
  const claims = response.split('\n').filter(line => line.includes('**'));
  return citations.length >= Math.floor(claims.length / 2);
}
```

## Guardrail 4: Sensitive Data Masking

```typescript
// Never expose full SSN or account numbers
function maskSensitiveData(context: ReturnContext): ReturnContext {
  return {
    ...context,
    client: {
      ...context.client,
      ssn: `XXX-XX-${context.client.ssn.slice(-4)}`,
      email: maskEmail(context.client.email)
    }
  };
}
```

## Guardrail 5: Hallucination Prevention

```typescript
// Only cite real IRS publications
const VALID_IRS_PUBLICATIONS = [
  '17', '334', '587', '560', '505', '4012', '4491', // etc.
];

function validateIRSCitation(pubNumber: string): boolean {
  return VALID_IRS_PUBLICATIONS.includes(pubNumber);
}
```

---

**END OF AI TAX AGENT PROMPT + CONTEXT SCHEMA**

**Version:** 1.0  
**Status:** ✅ Production-Ready  
**Last Updated:** April 26, 2026
