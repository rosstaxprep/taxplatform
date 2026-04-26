# PRIMEWEB — COMPLETE UI WIREFRAME PACK
## Enterprise Tax Platform (TaxSlayer-Class, Superior)

**Document Version:** 1.0  
**Date:** April 26, 2026  
**Author:** Manus AI  
**Status:** Production-Ready  
**Classification:** UI/UX Design Specification  
**Owner:** Condre Dvon Ross  

---

## TABLE OF CONTENTS

1. [Design System](#design-system)
2. [Public Pages](#public-pages)
3. [Authentication Flows](#authentication-flows)
4. [Office Dashboard](#office-dashboard)
5. [Return Editor Workspace](#return-editor-workspace)
6. [Client Portal](#client-portal)
7. [Self-Service Wizard](#self-service-wizard)
8. [Alert Center](#alert-center)
9. [Multi-Office Management](#multi-office-management)
10. [IRS Live Feed Panel](#irs-live-feed-panel)
11. [AI Assistant Interface](#ai-assistant-interface)

---

# DESIGN SYSTEM

## Color Palette

**Primary Colors:**
- Navy Blue: `#001F3F` - Primary brand, headers, navigation
- Gold: `#D4AF37` - Accents, highlights, CTAs
- White: `#FFFFFF` - Backgrounds, text
- Cream: `#F5F1E8` - Secondary backgrounds, cards

**Semantic Colors:**
- Success: `#10B981` (Green) - Approved, filed, completed
- Warning: `#F59E0B` (Amber) - Pending, attention needed
- Error: `#DC2626` (Red) - Critical, holds, errors
- Info: `#0EA5E9` (Blue) - Information, notices
- Neutral: `#6B7280` (Gray) - Disabled, secondary text

**Severity Levels (IRS TC Codes):**
- CRITICAL: `#DC2626` (Red)
- WARNING: `#F59E0B` (Amber)
- INFO: `#0EA5E9` (Blue)

## Typography

**Font Family:** Inter, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif

**Font Sizes & Weights:**
- H1: 32px, Bold (700) - Page titles
- H2: 24px, Bold (700) - Section headers
- H3: 20px, Semibold (600) - Subsection headers
- Body: 16px, Regular (400) - Main text
- Small: 14px, Regular (400) - Secondary text
- Tiny: 12px, Regular (400) - Labels, metadata
- Mono: 14px, Regular (400) - Code, technical text

## Spacing System

- xs: 4px
- sm: 8px
- md: 16px
- lg: 24px
- xl: 32px
- 2xl: 48px

## Components

**Buttons:**
- Primary: Navy background, white text, gold hover
- Secondary: Cream background, navy text, gold border
- Danger: Red background, white text
- Ghost: Transparent, navy text, navy border

**Cards:**
- White background, subtle shadow, 8px border radius
- Padding: 16px (md)
- Border: 1px solid #E5E7EB

**Forms:**
- Input height: 40px
- Border: 1px solid #D1D5DB
- Focus: Navy border, gold shadow
- Labels: 12px, bold, navy

**Tables:**
- Header: Navy background, white text
- Rows: Alternating white/cream
- Hover: Light gold background

---

# PUBLIC PAGES

## Page 1: Landing Page (`/`)

```
┌─────────────────────────────────────────────────────────────────┐
│  PRIMEWEB  [Logo]                    [Features] [Pricing] [Login]│
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│                    HERO SECTION                                  │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │                                                               │ │
│  │  PrimeWeb                                                    │ │
│  │  Enterprise Tax Platform with Live IRS Intelligence          │ │
│  │                                                               │ │
│  │  Prepare returns faster. Reduce risk. Maximize refunds.       │ │
│  │                                                               │ │
│  │  [For Firms]  [For Solo Preparers]  [Book a Demo]           │ │
│  │                                                               │ │
│  │  ✓ Live IRS Transcript Feed                                 │ │
│  │  ✓ AI-Powered Tax Agent                                     │ │
│  │  ✓ Multi-Office Management                                  │ │
│  │  ✓ SOC 2 Certified                                          │ │
│  │                                                               │ │
│  └─────────────────────────────────────────────────────────────┘ │
│                                                                   │
│                    FEATURES SECTION                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐           │
│  │ 📊 Live IRS  │  │ 🤖 AI Agent  │  │ 🏢 Multi-    │           │
│  │ Transcript   │  │ Guidance     │  │ Office       │           │
│  │ Feed         │  │              │  │ Management   │           │
│  └──────────────┘  └──────────────┘  └──────────────┘           │
│                                                                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐           │
│  │ 🔒 Enterprise│  │ ⚡ Real-Time │  │ 📱 Client    │           │
│  │ Security     │  │ Calculations │  │ Portal       │           │
│  └──────────────┘  └──────────────┘  └──────────────┘           │
│                                                                   │
│                    PRICING SECTION                               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐           │
│  │ Per Office   │  │ Per Preparer │  │ Per Return   │           │
│  │ $299/month   │  │ $99/month    │  │ $9.99/return │           │
│  └──────────────┘  └──────────────┘  └──────────────┘           │
│                                                                   │
│                    FOOTER                                        │
│  [About] [Security] [Privacy] [Terms] [Contact]                 │
│  © 2026 PrimeWeb. All rights reserved.                           │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

**Key Elements:**
- Hero image: Enterprise tax office, modern workspace
- Feature cards: 6 main features with icons
- Pricing table: 3 tiers with comparison
- Social proof: "Trusted by 500+ firms"
- CTA buttons: Primary gold, secondary navy

## Page 2: Features (`/features`)

```
┌─────────────────────────────────────────────────────────────────┐
│  PRIMEWEB  [Logo]                    [Features] [Pricing] [Login]│
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  Features                                                        │
│                                                                   │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │ 1. Tax Engine & Forms                                        │ │
│  │    ✓ 1040 + all schedules                                   │ │
│  │    ✓ 1099s, W-2s, K-1s                                      │ │
│  │    ✓ Real-time calculations                                 │ │
│  │    ✓ Scenario planning                                      │ │
│  └─────────────────────────────────────────────────────────────┘ │
│                                                                   │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │ 2. IRS Live Transcript Feed                                  │ │
│  │    ✓ Real-time account updates                              │ │
│  │    ✓ TC code intelligence                                   │ │
│  │    ✓ Automatic alerts                                       │ │
│  │    ✓ Compliance monitoring                                  │ │
│  └─────────────────────────────────────────────────────────────┘ │
│                                                                   │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │ 3. AI Tax Agent                                              │ │
│  │    ✓ Return explanations                                    │ │
│  │    ✓ Risk detection                                         │ │
│  │    ✓ Optimization suggestions                               │ │
│  │    ✓ Client communication                                   │ │
│  └─────────────────────────────────────────────────────────────┘ │
│                                                                   │
│  [Learn More] buttons for each feature                           │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

## Page 3: Security (`/security`)

```
┌─────────────────────────────────────────────────────────────────┐
│  PRIMEWEB  [Logo]                    [Features] [Pricing] [Login]│
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  Security & Compliance                                           │
│                                                                   │
│  ✓ SOC 2 Type II Certified                                      │
│  ✓ IRS e-file Provider                                          │
│  ✓ HIPAA Compliant                                              │
│  ✓ Encryption at Rest & In Transit                              │
│  ✓ Multi-Factor Authentication                                  │
│  ✓ Audit Logging                                                │
│  ✓ Data Residency (US)                                          │
│  ✓ 99.99% Uptime SLA                                            │
│                                                                   │
│  [Download Security Whitepaper] [Contact Security Team]         │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

---

# AUTHENTICATION FLOWS

## Login Page (`/login`)

```
┌─────────────────────────────────────────────────────────────────┐
│  PRIMEWEB  [Logo]                                                │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│                      ┌──────────────────┐                        │
│                      │  Sign In          │                        │
│                      │  ──────────────   │                        │
│                      │                  │                        │
│                      │ Email:           │                        │
│                      │ [______________] │                        │
│                      │                  │                        │
│                      │ Password:        │                        │
│                      │ [______________] │                        │
│                      │                  │                        │
│                      │ [Remember Me] □  │                        │
│                      │                  │                        │
│                      │ [Sign In]        │                        │
│                      │                  │                        │
│                      │ Don't have an    │                        │
│                      │ account?         │                        │
│                      │ [Sign Up]        │                        │
│                      │                  │                        │
│                      │ [Forgot Password]│                        │
│                      └──────────────────┘                        │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

## MFA Verification (`/login/mfa`)

```
┌─────────────────────────────────────────────────────────────────┐
│  PRIMEWEB  [Logo]                                                │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│                  ┌──────────────────────┐                        │
│                  │  Verify Your Identity │                        │
│                  │  ──────────────────   │                        │
│                  │                      │                        │
│                  │ Enter the 6-digit    │                        │
│                  │ code from your       │                        │
│                  │ authenticator app:   │                        │
│                  │                      │                        │
│                  │ [___] [___] [___]    │                        │
│                  │ [___] [___] [___]    │                        │
│                  │                      │                        │
│                  │ [Verify]             │                        │
│                  │                      │                        │
│                  │ [Use backup code]    │                        │
│                  └──────────────────────┘                        │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

---

# OFFICE DASHBOARD

## Main Dashboard (`/app/dashboard`)

```
┌──────────────────────────────────────────────────────────────────────┐
│ PRIMEWEB                                  [Notifications] [👤 John]   │
├──────────────────────────────────────────────────────────────────────┤
│                                                                        │
│ ┌──────────────────┐  ┌────────────────────────────────────────────┐ │
│ │ NAVIGATION       │  │ Welcome Back, John!                        │ │
│ │ ──────────────── │  │ Austin Office | 5 Preparers | 45 Returns  │ │
│ │                  │  │                                             │ │
│ │ Dashboard        │  │ ┌────────────────────────────────────────┐ │ │
│ │ Clients          │  │ │ LIVE IRS FEED STREAM                 │ │ │
│ │ Returns          │  │ │ ──────────────────────────────────── │ │ │
│ │ IRS Feed         │  │ │ • TC 150 - Refund Issued (2h ago)   │ │ │
│ │ Alerts           │  │ │   Jane Smith (XXX-XX-6789)          │ │ │
│ │ Offices          │  │ │   Amount: $2,500                    │ │ │
│ │ Billing          │  │ │                                      │ │ │
│ │ Settings         │  │ │ • TC 810 - Return Accepted (4h ago) │ │ │
│ │ Logout           │  │ │   John Doe (XXX-XX-5678)            │ │ │
│ │                  │  │ │   Status: ACCEPTED                  │ │ │
│ │                  │  │ │                                      │ │ │
│ │                  │  │ │ • TC 800 - Return Filed (1d ago)    │ │ │
│ │                  │  │ │   Mary Johnson (XXX-XX-9012)        │ │ │
│ │                  │  │ │   Status: FILED                     │ │ │
│ │                  │  │ │                                      │ │ │
│ │                  │  │ │ [View All Updates]                  │ │ │
│ │                  │  │ └────────────────────────────────────┘ │ │
│ │                  │  │                                             │ │
│ │                  │  │ ┌────────────────────────────────────────┐ │ │
│ │                  │  │ │ CRITICAL ALERTS                      │ │ │
│ │                  │  │ │ ──────────────────────────────────── │ │ │
│ │                  │  │ │ 🔴 TC 580 - Refund Frozen           │ │ │
│ │                  │  │ │    Client: John Doe                 │ │ │
│ │                  │  │ │    Action: Contact IRS immediately  │ │ │
│ │                  │  │ │    [Acknowledge] [View Details]     │ │ │
│ │                  │  │ └────────────────────────────────────┘ │ │
│ │                  │  │                                             │ │
│ │                  │  │ ┌────────────────────────────────────────┐ │ │
│ │                  │  │ │ OFFICE PRODUCTION                    │ │ │
│ │                  │  │ │ ──────────────────────────────────── │ │ │
│ │                  │  │ │ Returns in Progress: 12             │ │ │
│ │                  │  │ │ Pending Review: 5                   │ │ │
│ │                  │  │ │ Ready to File: 3                    │ │ │
│ │                  │  │ │ Filed: 25                           │ │ │
│ │                  │  │ │ Accepted: 20                        │ │ │
│ │                  │  │ │                                      │ │ │
│ │                  │  │ │ Avg Processing Time: 3.2 days       │ │ │
│ │                  │  │ │ Client Satisfaction: 4.8/5.0        │ │ │
│ │                  │  │ └────────────────────────────────────┘ │ │
│ │                  │  │                                             │ │
│ │                  │  │ ┌────────────────────────────────────────┐ │ │
│ │                  │  │ │ REVENUE SNAPSHOT                     │ │ │
│ │                  │  │ │ ──────────────────────────────────── │ │ │
│ │                  │  │ │ This Month: $12,450                 │ │ │
│ │                  │  │ │ Year to Date: $145,200              │ │ │
│ │                  │  │ │ Avg Return Value: $325              │ │ │
│ │                  │  │ └────────────────────────────────────┘ │ │
│ │                  │  │                                             │ │
│ └──────────────────┘  └────────────────────────────────────────────┘ │
│                                                                        │
└──────────────────────────────────────────────────────────────────────┘
```

**Key Features:**
- Real-time IRS feed with latest TC codes
- Critical alerts with action buttons
- Office metrics and KPIs
- Revenue tracking
- Quick action buttons

---

# RETURN EDITOR WORKSPACE

## Return Editor (`/app/returns/:returnId`)

```
┌──────────────────────────────────────────────────────────────────────┐
│ PRIMEWEB                                  [Notifications] [👤 John]   │
├──────────────────────────────────────────────────────────────────────┤
│                                                                        │
│ ┌──────────────────┐  ┌──────────────────┐  ┌────────────────────┐  │
│ │ CLIENT INFO      │  │ ACTIVE FORM      │  │ IRS TRANSCRIPT     │  │
│ │ ──────────────── │  │ ──────────────── │  │ ──────────────────┐  │
│ │                  │  │                  │  │                    │  │
│ │ Jane Smith       │  │ Schedule C       │  │ Balance: $0        │  │
│ │ XXX-XX-6789      │  │ (Self-Employment)│  │ Refunds: $2,500    │  │
│ │                  │  │                  │  │ Payments: $0       │  │
│ │ Tax Year: 2025   │  │ [Form Fields]    │  │                    │  │
│ │ Status: Draft    │  │                  │  │ TC Code Timeline:  │  │
│ │                  │  │ • Business Name  │  │ ──────────────────┐  │
│ │ NAVIGATION:      │  │ • EIN            │  │ • TC 150 ✓         │  │
│ │ • Summary        │  │ • Gross Income   │  │   Refund Issued    │  │
│ │ • Forms          │  │ • COGS           │  │   (2 days ago)     │  │
│ │ • Interview      │  │ • Deductions     │  │                    │  │
│ │ • Documents      │  │ • Net Income     │  │ • TC 810 ✓         │  │
│ │ • IRS Feed       │  │                  │  │   Return Accepted  │  │
│ │ • AI Assistant   │  │ Calculated:      │  │   (4 days ago)     │  │
│ │                  │  │ Net: $45,000     │  │                    │  │
│ │                  │  │ Tax: $8,500      │  │ • TC 800 ✓         │  │
│ │                  │  │                  │  │   Return Filed     │  │
│ │                  │  │ [Save] [Next]    │  │   (5 days ago)     │  │
│ │                  │  │                  │  │                    │  │
│ │                  │  │ VALIDATION:      │  │ ALERTS:            │  │
│ │                  │  │ ✓ All required   │  │ ⚠️ Schedule C      │  │
│ │                  │  │   fields filled  │  │    income high     │  │
│ │                  │  │                  │  │    (audit flag)    │  │
│ │                  │  │                  │  │                    │  │
│ │                  │  │                  │  │ [View Details]     │  │
│ │                  │  │                  │  │ [AI Explanation]   │  │
│ │                  │  │                  │  │                    │  │
│ └──────────────────┘  └──────────────────┘  └────────────────────┘  │
│                                                                        │
└──────────────────────────────────────────────────────────────────────┘
```

**Key Features:**
- Three-column layout (client info, form editor, IRS transcript)
- Live validation and calculations
- TC code timeline
- AI explanations
- Real-time sync with Avalon engine

---

# CLIENT PORTAL

## Client Dashboard (`/client/dashboard`)

```
┌─────────────────────────────────────────────────────────────────┐
│  PRIMEWEB CLIENT PORTAL              [Messages] [👤 Jane] [Logout]│
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  Welcome Back, Jane!                                             │
│                                                                   │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │ MY RETURNS                                                   │ │
│  │ ─────────────────────────────────────────────────────────── │ │
│  │                                                               │ │
│  │ 2025 Tax Return                                              │ │
│  │ Status: Ready for Review                                    │ │
│  │ Last Updated: 2 hours ago                                   │ │
│  │ [View Details] [Download PDF]                               │ │
│  │                                                               │ │
│  │ 2024 Tax Return                                              │ │
│  │ Status: Filed & Accepted                                    │ │
│  │ Refund: $2,500 (Deposited)                                  │ │
│  │ [View Details]                                              │ │
│  │                                                               │ │
│  └─────────────────────────────────────────────────────────────┘ │
│                                                                   │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │ MY DOCUMENTS                                                 │ │
│  │ ─────────────────────────────────────────────────────────── │ │
│  │                                                               │ │
│  │ W-2 2025.pdf (Uploaded: 2 weeks ago)                        │ │
│  │ 1099-NEC 2025.pdf (Uploaded: 2 weeks ago)                   │ │
│  │ Prior Year Return 2024.pdf (Uploaded: 1 month ago)          │ │
│  │                                                               │ │
│  │ [Upload New Document]                                        │ │
│  │                                                               │ │
│  └─────────────────────────────────────────────────────────────┘ │
│                                                                   │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │ MY MESSAGES                                                  │ │
│  │ ─────────────────────────────────────────────────────────── │ │
│  │                                                               │ │
│  │ [1] John (Preparer): "We're ready to file your return!"     │ │
│  │     Sent: 2 hours ago                                       │ │
│  │     [Reply]                                                  │ │
│  │                                                               │ │
│  │ [2] Office: "Please upload your 1099-NEC"                  │ │
│  │     Sent: 1 day ago                                         │ │
│  │     [Reply]                                                  │ │
│  │                                                               │ │
│  └─────────────────────────────────────────────────────────────┘ │
│                                                                   │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │ IRS SUMMARY                                                  │ │
│  │ ─────────────────────────────────────────────────────────── │ │
│  │                                                               │ │
│  │ 2025 Account Status: NORMAL                                 │ │
│  │ Current Balance: $0                                         │ │
│  │ Expected Refund: $2,500                                     │ │
│  │ Expected Deposit: May 10, 2026                              │ │
│  │                                                               │ │
│  │ [View Full Transcript]                                       │ │
│  │                                                               │ │
│  └─────────────────────────────────────────────────────────────┘ │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

---

# SELF-SERVICE WIZARD

## Wizard Step 1: Identity & Year Selection

```
┌─────────────────────────────────────────────────────────────────┐
│  PRIMEWEB TAX WIZARD                              [Progress: 1/8] │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  Step 1 of 8: Identity & Year Selection                          │
│  ─────────────────────────────────────────────────────────────  │
│                                                                   │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │ What is your name?                                           │ │
│  │ First Name: [________________]  Last Name: [________________]│ │
│  │                                                               │ │
│  │ What is your Social Security Number?                         │ │
│  │ [___-__-____]                                                │ │
│  │                                                               │ │
│  │ What year are you filing for?                                │ │
│  │ ○ 2024  ○ 2025  ○ 2026                                       │ │
│  │                                                               │ │
│  │ [Back] [Next]                                                │ │
│  │                                                               │ │
│  │ 💡 Need help? [Ask AI Assistant]                             │ │
│  │                                                               │ │
│  └─────────────────────────────────────────────────────────────┘ │
│                                                                   │
│  Right Panel:                                                    │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │ AI ASSISTANT                                                 │ │
│  │ ─────────────────────────────────────────────────────────── │ │
│  │                                                               │ │
│  │ "Hi Jane! I'm here to help you prepare your tax return."    │ │
│  │                                                               │ │
│  │ "Let's start with your basic information so we can create   │ │
│  │  your return."                                              │ │
│  │                                                               │ │
│  │ "What questions do you have?"                                │ │
│  │                                                               │ │
│  │ [Type your question...]                                      │ │
│  │                                                               │ │
│  └─────────────────────────────────────────────────────────────┘ │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

## Wizard Step 2: Filing Status & Dependents

```
┌─────────────────────────────────────────────────────────────────┐
│  PRIMEWEB TAX WIZARD                              [Progress: 2/8] │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  Step 2 of 8: Filing Status & Dependents                         │
│  ─────────────────────────────────────────────────────────────  │
│                                                                   │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │ What is your filing status?                                  │ │
│  │                                                               │ │
│  │ ○ Single                                                     │ │
│  │ ○ Married Filing Jointly                                     │ │
│  │ ○ Married Filing Separately                                  │ │
│  │ ○ Head of Household                                          │ │
│  │ ○ Qualifying Widow(er)                                       │ │
│  │                                                               │ │
│  │ Do you have any dependents?                                  │ │
│  │ ○ Yes  ○ No                                                  │ │
│  │                                                               │ │
│  │ If yes, how many?                                            │ │
│  │ [_]                                                          │ │
│  │                                                               │ │
│  │ [Back] [Next]                                                │ │
│  │                                                               │ │
│  └─────────────────────────────────────────────────────────────┘ │
│                                                                   │
│  Right Panel:                                                    │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │ AI ASSISTANT                                                 │ │
│  │ ─────────────────────────────────────────────────────────── │ │
│  │                                                               │ │
│  │ "Filing status determines your tax brackets and standard    │ │
│  │  deduction amount."                                         │ │
│  │                                                               │ │
│  │ "Dependents can reduce your taxable income through the      │ │
│  │  Child Tax Credit and other benefits."                      │ │
│  │                                                               │ │
│  │ [Show Examples]                                              │ │
│  │                                                               │ │
│  └─────────────────────────────────────────────────────────────┘ │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

---

# ALERT CENTER

## Alert Center (`/app/irs/alerts`)

```
┌──────────────────────────────────────────────────────────────────────┐
│ PRIMEWEB                                  [Notifications] [👤 John]   │
├──────────────────────────────────────────────────────────────────────┤
│                                                                        │
│ ┌──────────────────┐  ┌────────────────────────────────────────────┐ │
│ │ NAVIGATION       │  │ ALERT CENTER                               │ │
│ │ ──────────────── │  │ ────────────────────────────────────────── │ │
│ │                  │  │                                             │ │
│ │ Dashboard        │  │ Filter:                                    │ │
│ │ Clients          │  │ [All ▼] [Critical ▼] [Open ▼]             │ │
│ │ Returns          │  │ [Mark all as read]                         │ │
│ │ IRS Feed         │  │                                             │ │
│ │ Alerts           │  │ ┌────────────────────────────────────────┐ │ │
│ │ Offices          │  │ │ 🔴 CRITICAL - TC 580 - Refund Frozen  │ │ │
│ │ Billing          │  │ │    Client: John Doe (XXX-XX-5678)     │ │ │
│ │ Settings         │  │ │    Refund frozen due to compliance    │ │ │
│ │ Logout           │  │ │    review                             │ │ │
│ │                  │  │ │    Action Required: Contact IRS       │ │ │
│ │                  │  │ │    Time: 2 hours ago                  │ │ │
│ │                  │  │ │    Status: Open                       │ │ │
│ │                  │  │ │    [View Details] [Acknowledge]       │ │ │
│ │                  │  │ │    [AI Explanation]                   │ │ │
│ │                  │  │ └────────────────────────────────────────┘ │ │
│ │                  │  │                                             │ │
│ │                  │  │ ┌────────────────────────────────────────┐ │ │
│ │                  │  │ │ 🟡 WARNING - TC 570 - Refund Offset   │ │ │
│ │                  │  │ │    Client: Mary Johnson (XXX-XX-9012) │ │ │
│ │                  │  │ │    Refund offset applied for other    │ │ │
│ │                  │  │ │    tax liabilities                    │ │ │
│ │                  │  │ │    Action Required: Review offset     │ │ │
│ │                  │  │ │    Time: 5 hours ago                  │ │ │
│ │                  │  │ │    Status: In Progress                │ │ │
│ │                  │  │ │    [View Details] [Acknowledge]       │ │ │
│ │                  │  │ │    [AI Explanation]                   │ │ │
│ │                  │  │ └────────────────────────────────────────┘ │ │
│ │                  │  │                                             │ │
│ │                  │  │ ┌────────────────────────────────────────┐ │ │
│ │                  │  │ │ 🔵 INFO - TC 150 - Refund Issued      │ │ │
│ │                  │  │ │    Client: Jane Smith (XXX-XX-6789)   │ │ │
│ │                  │  │ │    Refund has been issued             │ │ │
│ │                  │  │ │    Amount: $2,500                     │ │ │
│ │                  │  │ │    Time: 1 day ago                    │ │ │
│ │                  │  │ │    Status: Resolved                   │ │ │
│ │                  │  │ │    [View Details]                     │ │ │
│ │                  │  │ └────────────────────────────────────────┘ │ │
│ │                  │  │                                             │ │
│ │                  │  │ [Load More]                                │ │
│ │                  │  │                                             │ │
│ └──────────────────┘  └────────────────────────────────────────────┘ │
│                                                                        │
└──────────────────────────────────────────────────────────────────────┘
```

---

# MULTI-OFFICE MANAGEMENT

## Office Management (`/app/offices`)

```
┌──────────────────────────────────────────────────────────────────────┐
│ PRIMEWEB                                  [Notifications] [👤 John]   │
├──────────────────────────────────────────────────────────────────────┤
│                                                                        │
│ MULTI-OFFICE MANAGEMENT                                              │
│                                                                        │
│ ┌────────────────────────────────────────────────────────────────────┐ │
│ │ OFFICE LIST                                                        │ │
│ │ ────────────────────────────────────────────────────────────────── │ │
│ │                                                                     │ │
│ │ Name          │ Location │ Preparers │ Production │ IRS Feed │ Status │ │
│ ├────────────────────────────────────────────────────────────────────┤ │
│ │ Austin HQ     │ Austin   │ 5         │ 45 returns │ ✓ Active │ ✓ Active│ │
│ │ Dallas Branch │ Dallas   │ 3         │ 28 returns │ ✓ Active │ ✓ Active│ │
│ │ Houston Ops   │ Houston  │ 2         │ 15 returns │ ✓ Active │ ✓ Active│ │
│ │ San Antonio   │ San Ant. │ 1         │ 8 returns  │ ⚠ Offline│ ✓ Active│ │
│ │                                                                     │ │
│ │ [Add New Office]                                                   │ │
│ │                                                                     │ │
│ └────────────────────────────────────────────────────────────────────┘ │
│                                                                        │
│ ┌────────────────────────────────────────────────────────────────────┐ │
│ │ PRODUCTION METRICS                                                 │ │
│ │ ────────────────────────────────────────────────────────────────── │ │
│ │                                                                     │ │
│ │ Total Returns: 96                                                  │ │
│ │ Filed: 65 (67%)  │  Pending: 20 (21%)  │  Draft: 11 (11%)        │ │
│ │                                                                     │ │
│ │ Avg Processing Time: 3.1 days                                      │ │
│ │ Client Satisfaction: 4.8/5.0                                       │ │
│ │ E-File Success Rate: 99.2%                                         │ │
│ │                                                                     │ │
│ │ Revenue This Month: $28,500                                        │ │
│ │ Revenue YTD: $285,000                                              │ │
│ │                                                                     │ │
│ └────────────────────────────────────────────────────────────────────┘ │
│                                                                        │
│ ┌────────────────────────────────────────────────────────────────────┐ │
│ │ IRS FEED HEALTH                                                    │ │
│ │ ────────────────────────────────────────────────────────────────── │ │
│ │                                                                     │ │
│ │ Austin HQ:    ✓ Healthy (1,245 updates today)                     │ │
│ │ Dallas Branch: ✓ Healthy (842 updates today)                      │ │
│ │ Houston Ops:  ✓ Healthy (456 updates today)                       │ │
│ │ San Antonio:  ⚠ Offline (last update: 2 hours ago)                │ │
│ │                                                                     │ │
│ └────────────────────────────────────────────────────────────────────┘ │
│                                                                        │
└──────────────────────────────────────────────────────────────────────┘
```

---

# IRS LIVE FEED PANEL

## Live Feed Panel (Right Sidebar)

```
┌─────────────────────────────────┐
│ IRS LIVE FEED                   │
│ ─────────────────────────────── │
│                                  │
│ Filter: [All ▼] [Critical ▼]    │
│                                  │
│ ┌─────────────────────────────┐ │
│ │ 🟢 TC 150                   │ │
│ │ Refund Issued               │ │
│ │ Jane Smith                  │ │
│ │ $2,500                      │ │
│ │ 2 hours ago                 │ │
│ │ [View]                      │ │
│ └─────────────────────────────┘ │
│                                  │
│ ┌─────────────────────────────┐ │
│ │ 🟢 TC 810                   │ │
│ │ Return Accepted             │ │
│ │ John Doe                    │ │
│ │ Status: ACCEPTED            │ │
│ │ 4 hours ago                 │ │
│ │ [View]                      │ │
│ └─────────────────────────────┘ │
│                                  │
│ ┌─────────────────────────────┐ │
│ │ 🟢 TC 800                   │ │
│ │ Return Filed                │ │
│ │ Mary Johnson                │ │
│ │ Status: FILED               │ │
│ │ 1 day ago                   │ │
│ │ [View]                      │ │
│ └─────────────────────────────┘ │
│                                  │
│ ┌─────────────────────────────┐ │
│ │ 🔴 TC 580                   │ │
│ │ Refund Frozen               │ │
│ │ John Doe                    │ │
│ │ CRITICAL                    │ │
│ │ 2 hours ago                 │ │
│ │ [View] [AI Help]            │ │
│ └─────────────────────────────┘ │
│                                  │
│ [View All Updates]              │
│                                  │
└─────────────────────────────────┘
```

---

# AI ASSISTANT INTERFACE

## AI Assistant Chat Panel

```
┌─────────────────────────────────┐
│ AI TAX ASSISTANT                │
│ ─────────────────────────────── │
│                                  │
│ [Explain Return]                │
│ [Check for Issues]              │
│ [Optimize Return]               │
│ [Summarize for Client]          │
│                                  │
│ ┌─────────────────────────────┐ │
│ │ Assistant:                  │ │
│ │                             │ │
│ │ "Hi John! I've reviewed    │ │
│ │  Jane's return. The        │ │
│ │  Schedule C income is high │ │
│ │  compared to prior years.  │ │
│ │  This might trigger an     │ │
│ │  audit flag."              │ │
│ │                             │ │
│ │ [See Details] [Explain]    │ │
│ └─────────────────────────────┘ │
│                                  │
│ ┌─────────────────────────────┐ │
│ │ You:                        │ │
│ │                             │ │
│ │ "What should I do?"         │ │
│ └─────────────────────────────┘ │
│                                  │
│ ┌─────────────────────────────┐ │
│ │ Assistant:                  │ │
│ │                             │ │
│ │ "I recommend:               │ │
│ │ 1. Request supporting docs │ │
│ │ 2. Add Schedule C notes     │ │
│ │ 3. Consider conservative   │ │
│ │    deductions"              │ │
│ │                             │ │
│ │ [Apply Suggestions]         │ │
│ └─────────────────────────────┘ │
│                                  │
│ [Type your question...]         │
│                                  │
└─────────────────────────────────┘
```

---

## RESPONSIVE DESIGN GUIDELINES

**Mobile (< 768px):**
- Single column layout
- Collapsible navigation
- Stacked cards
- Touch-friendly buttons (48px minimum)

**Tablet (768px - 1024px):**
- Two column layout
- Sidebar navigation
- Responsive grid

**Desktop (> 1024px):**
- Three column layout (nav, content, sidebar)
- Full feature set
- Optimized spacing

---

## ACCESSIBILITY REQUIREMENTS

- WCAG 2.1 Level AA compliance
- Keyboard navigation support
- Screen reader compatibility
- Color contrast ratios (4.5:1 minimum)
- Focus indicators on all interactive elements
- Alt text for all images
- Semantic HTML structure

---

## ANIMATION & MICRO-INTERACTIONS

**Transitions:**
- Fade in/out: 200ms
- Slide in/out: 300ms
- Color changes: 150ms

**Hover States:**
- Buttons: Darken 10%, scale 1.02
- Links: Underline, color change to gold
- Cards: Subtle shadow increase

**Loading States:**
- Skeleton screens for data
- Spinner for actions
- Progress bars for uploads

---

**END OF UI WIREFRAME PACK**

**Version:** 1.0  
**Status:** ✅ Production-Ready  
**Last Updated:** April 26, 2026
