# PRIMEWEB — COMPLETE ROUTE MAP & API SPECIFICATION
## Enterprise Tax Platform (TaxSlayer-Class, Superior)

**Document Version:** 1.0  
**Date:** April 26, 2026  
**Author:** Manus AI  
**Status:** Production-Ready  
**Classification:** API & Route Specification  
**Owner:** Condre Dvon Ross  

---

## TABLE OF CONTENTS

1. [Architecture Overview](#architecture-overview)
2. [Public Routes](#public-routes)
3. [Authentication Routes](#authentication-routes)
4. [Office Dashboard Routes](#office-dashboard-routes)
5. [Return Editor Routes](#return-editor-routes)
6. [Client Portal Routes](#client-portal-routes)
7. [IRS Feed & Monitoring Routes](#irs-feed--monitoring-routes)
8. [Multi-Office Management Routes](#multi-office-management-routes)
9. [Admin & Settings Routes](#admin--settings-routes)
10. [API Endpoints (REST + tRPC)](#api-endpoints-rest--trpc)

---

# ARCHITECTURE OVERVIEW

## Route Organization

**Base URL:** `https://primeweb.app`

**Route Structure:**
```
/                          → Public pages
/auth                      → Authentication flows
/app                       → Office dashboard & main app
/client                    → Client portal
/api                       → Backend API endpoints
/api/trpc                  → tRPC endpoints
/api/irs                   → IRS integration endpoints
/api/admin                 → Admin endpoints
```

## HTTP Methods

| Method | Purpose | Idempotent |
|--------|---------|-----------|
| GET | Retrieve data | ✓ Yes |
| POST | Create new resource | ✗ No |
| PUT | Replace entire resource | ✓ Yes |
| PATCH | Partial update | ✓ Yes |
| DELETE | Remove resource | ✓ Yes |

## Response Format

**Success Response (200-299):**
```json
{
  "status": "success",
  "data": { /* resource data */ },
  "meta": {
    "timestamp": "2026-04-26T10:30:00Z",
    "version": "1.0"
  }
}
```

**Error Response (400-599):**
```json
{
  "status": "error",
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid request parameters",
    "details": [
      { "field": "email", "message": "Invalid email format" }
    ]
  },
  "meta": {
    "timestamp": "2026-04-26T10:30:00Z",
    "requestId": "req_123456"
  }
}
```

---

# PUBLIC ROUTES

## Landing Page & Marketing

| Route | Method | Purpose | Auth | Response |
|-------|--------|---------|------|----------|
| `/` | GET | Landing page | None | HTML page |
| `/features` | GET | Features page | None | HTML page |
| `/pricing` | GET | Pricing page | None | HTML page |
| `/security` | GET | Security & compliance | None | HTML page |
| `/blog` | GET | Blog listing | None | HTML page |
| `/blog/:slug` | GET | Blog article | None | HTML page |
| `/contact` | GET | Contact form | None | HTML page |
| `/contact` | POST | Submit contact form | None | JSON response |
| `/demo` | GET | Demo request form | None | HTML page |
| `/demo` | POST | Submit demo request | None | JSON response |
| `/docs` | GET | API documentation | None | HTML page |
| `/status` | GET | System status | None | JSON response |

---

# AUTHENTICATION ROUTES

## Login & Registration

| Route | Method | Purpose | Auth | Request | Response |
|-------|--------|---------|------|---------|----------|
| `/auth/login` | GET | Login page | None | - | HTML page |
| `/auth/login` | POST | Submit login | None | `{ email, password }` | JWT token + session |
| `/auth/signup` | GET | Registration page | None | - | HTML page |
| `/auth/signup` | POST | Create account | None | `{ email, password, name, office }` | User + JWT |
| `/auth/forgot-password` | GET | Forgot password page | None | - | HTML page |
| `/auth/forgot-password` | POST | Request password reset | None | `{ email }` | Confirmation message |
| `/auth/reset-password/:token` | GET | Reset password page | None | - | HTML page |
| `/auth/reset-password/:token` | POST | Reset password | None | `{ password }` | Success message |
| `/auth/verify-email/:token` | GET | Email verification | None | - | Redirect to app |
| `/auth/logout` | POST | Logout | User | - | Redirect to login |
| `/auth/mfa/setup` | GET | MFA setup page | User | - | HTML page |
| `/auth/mfa/setup` | POST | Enable MFA | User | `{ method }` | QR code + backup codes |
| `/auth/mfa/verify` | POST | Verify MFA code | User | `{ code }` | JWT token |
| `/auth/refresh-token` | POST | Refresh JWT | User | `{ refreshToken }` | New JWT token |

---

# OFFICE DASHBOARD ROUTES

## Main Dashboard

| Route | Method | Purpose | Auth | Response |
|-------|--------|---------|------|----------|
| `/app/dashboard` | GET | Main dashboard | Office | Dashboard data + IRS feed |
| `/app/dashboard/stats` | GET | Dashboard statistics | Office | KPI metrics |
| `/app/dashboard/alerts` | GET | Dashboard alerts | Office | Alert list |
| `/app/dashboard/production` | GET | Production metrics | Office | Returns by status |

## Clients Management

| Route | Method | Purpose | Auth | Request | Response |
|-------|--------|---------|------|---------|----------|
| `/app/clients` | GET | Client roster | Office | Query: `{ year, status, search }` | Client list |
| `/app/clients` | POST | Add new client | Office | `{ name, ssn, email, phone }` | Created client |
| `/app/clients/:clientId` | GET | Client details | Office | - | Client profile |
| `/app/clients/:clientId` | PUT | Update client | Office | `{ name, email, phone, ... }` | Updated client |
| `/app/clients/:clientId` | DELETE | Delete client | Office | - | Success message |
| `/app/clients/:clientId/returns` | GET | Client returns | Office | Query: `{ year }` | Returns list |
| `/app/clients/:clientId/documents` | GET | Client documents | Office | - | Documents list |
| `/app/clients/:clientId/documents` | POST | Upload document | Office | FormData | Uploaded document |
| `/app/clients/:clientId/messages` | GET | Client messages | Office | - | Messages list |
| `/app/clients/:clientId/messages` | POST | Send message | Office | `{ message }` | Created message |
| `/app/clients/bulk-import` | POST | Bulk import clients | Office | CSV file | Import results |

---

# RETURN EDITOR ROUTES

## Return Management

| Route | Method | Purpose | Auth | Request | Response |
|-------|--------|---------|------|---------|----------|
| `/app/returns` | GET | Returns list | Office | Query: `{ year, status, search }` | Returns list |
| `/app/returns` | POST | Create new return | Office | `{ clientId, taxYear }` | Created return |
| `/app/returns/:returnId` | GET | Return details | Office | - | Return data |
| `/app/returns/:returnId` | PUT | Update return | Office | Return data | Updated return |
| `/app/returns/:returnId` | DELETE | Delete return | Office | - | Success message |
| `/app/returns/:returnId/summary` | GET | Return summary | Office | - | Summary data |
| `/app/returns/:returnId/forms` | GET | Return forms | Office | - | Forms list |
| `/app/returns/:returnId/forms/:formId` | GET | Form data | Office | - | Form fields |
| `/app/returns/:returnId/forms/:formId` | PUT | Update form | Office | Form data | Updated form |
| `/app/returns/:returnId/calculate` | POST | Recalculate return | Office | - | Calculation results |
| `/app/returns/:returnId/validate` | POST | Validate return | Office | - | Validation errors |
| `/app/returns/:returnId/file` | POST | File return with IRS | Office | - | Filing confirmation |
| `/app/returns/:returnId/preview` | GET | PDF preview | Office | - | PDF file |
| `/app/returns/:returnId/transcript` | GET | IRS transcript | Office | - | Transcript data |
| `/app/returns/:returnId/history` | GET | Change history | Office | - | History log |

## Schedules & Forms

| Route | Method | Purpose | Auth | Request | Response |
|-------|--------|---------|------|---------|----------|
| `/app/returns/:returnId/schedule-a` | GET | Schedule A data | Office | - | Schedule A fields |
| `/app/returns/:returnId/schedule-a` | PUT | Update Schedule A | Office | Schedule A data | Updated Schedule A |
| `/app/returns/:returnId/schedule-c` | GET | Schedule C data | Office | - | Schedule C fields |
| `/app/returns/:returnId/schedule-c` | PUT | Update Schedule C | Office | Schedule C data | Updated Schedule C |
| `/app/returns/:returnId/schedule-d` | GET | Schedule D data | Office | - | Schedule D fields |
| `/app/returns/:returnId/schedule-d` | PUT | Update Schedule D | Office | Schedule D data | Updated Schedule D |
| `/app/returns/:returnId/schedule-e` | GET | Schedule E data | Office | - | Schedule E fields |
| `/app/returns/:returnId/schedule-e` | PUT | Update Schedule E | Office | Schedule E data | Updated Schedule E |

---

# CLIENT PORTAL ROUTES

## Client Dashboard

| Route | Method | Purpose | Auth | Response |
|-------|--------|---------|------|----------|
| `/client/dashboard` | GET | Client dashboard | Client | Dashboard data |
| `/client/returns` | GET | My returns | Client | Returns list |
| `/client/returns/:returnId` | GET | Return details | Client | Return data |
| `/client/documents` | GET | My documents | Client | Documents list |
| `/client/documents` | POST | Upload document | Client | Uploaded document |
| `/client/documents/:docId` | DELETE | Delete document | Client | Success message |
| `/client/messages` | GET | My messages | Client | Messages list |
| `/client/messages` | POST | Send message | Client | Created message |
| `/client/messages/:messageId` | GET | Message thread | Client | Message thread |
| `/client/profile` | GET | My profile | Client | Profile data |
| `/client/profile` | PUT | Update profile | Client | Updated profile |
| `/client/settings` | GET | My settings | Client | Settings data |
| `/client/settings` | PUT | Update settings | Client | Updated settings |
| `/client/irs-summary` | GET | IRS account summary | Client | Account summary |
| `/client/refund-status` | GET | Refund status | Client | Refund data |

## Self-Service Wizard

| Route | Method | Purpose | Auth | Request | Response |
|-------|--------|---------|------|---------|----------|
| `/client/wizard` | GET | Wizard start | Client | - | Wizard page |
| `/client/wizard/step/:step` | GET | Wizard step | Client | - | Step form |
| `/client/wizard/step/:step` | POST | Submit step | Client | Step data | Next step |
| `/client/wizard/preview` | GET | Return preview | Client | - | Return summary |
| `/client/wizard/submit` | POST | Submit return | Client | - | Confirmation |
| `/client/wizard/download` | GET | Download return | Client | - | PDF file |

---

# IRS FEED & MONITORING ROUTES

## Live Transcript Feed

| Route | Method | Purpose | Auth | Request | Response |
|-------|--------|---------|------|---------|----------|
| `/app/irs/feed` | GET | Live feed stream | Office | Query: `{ limit, offset }` | Feed events |
| `/app/irs/feed/:feedId` | GET | Feed event details | Office | - | Event data |
| `/app/irs/alerts` | GET | IRS alerts | Office | Query: `{ severity, status }` | Alerts list |
| `/app/irs/alerts/:alertId` | GET | Alert details | Office | - | Alert data |
| `/app/irs/alerts/:alertId/acknowledge` | POST | Acknowledge alert | Office | - | Updated alert |
| `/app/irs/tc-codes` | GET | TC code definitions | Office | Query: `{ category }` | TC codes list |
| `/app/irs/tc-codes/:tcCode` | GET | TC code details | Office | - | TC code data |
| `/app/irs/transcript/:clientId` | GET | Client transcript | Office | - | Transcript data |
| `/app/irs/transcript/:clientId/refresh` | POST | Refresh transcript | Office | - | Updated transcript |
| `/app/irs/holds` | GET | Holds & freezes | Office | - | Holds list |
| `/app/irs/holds/:holdId` | GET | Hold details | Office | - | Hold data |
| `/app/irs/compliance-check` | POST | Run compliance check | Office | `{ clientId, taxYear }` | Check results |

---

# MULTI-OFFICE MANAGEMENT ROUTES

## Office Management

| Route | Method | Purpose | Auth | Request | Response |
|-------|--------|---------|------|---------|----------|
| `/app/offices` | GET | Office list | Owner | - | Offices list |
| `/app/offices` | POST | Create office | Owner | `{ name, location, ... }` | Created office |
| `/app/offices/:officeId` | GET | Office details | Owner | - | Office data |
| `/app/offices/:officeId` | PUT | Update office | Owner | Office data | Updated office |
| `/app/offices/:officeId` | DELETE | Delete office | Owner | - | Success message |
| `/app/offices/:officeId/team` | GET | Office team | Owner | - | Team members |
| `/app/offices/:officeId/team` | POST | Add team member | Owner | `{ email, role }` | Created member |
| `/app/offices/:officeId/team/:memberId` | PUT | Update member | Owner | Member data | Updated member |
| `/app/offices/:officeId/team/:memberId` | DELETE | Remove member | Owner | - | Success message |
| `/app/offices/:officeId/production` | GET | Office production | Owner | - | Production metrics |
| `/app/offices/:officeId/irs-feed` | GET | Office IRS feed | Owner | - | Feed events |
| `/app/offices/:officeId/settings` | GET | Office settings | Owner | - | Settings data |
| `/app/offices/:officeId/settings` | PUT | Update settings | Owner | Settings data | Updated settings |

---

# ADMIN & SETTINGS ROUTES

## Account Settings

| Route | Method | Purpose | Auth | Request | Response |
|-------|--------|---------|------|---------|----------|
| `/app/settings/profile` | GET | Profile settings | User | - | Profile data |
| `/app/settings/profile` | PUT | Update profile | User | Profile data | Updated profile |
| `/app/settings/password` | POST | Change password | User | `{ oldPassword, newPassword }` | Success message |
| `/app/settings/mfa` | GET | MFA settings | User | - | MFA data |
| `/app/settings/mfa` | POST | Update MFA | User | MFA data | Updated MFA |
| `/app/settings/security` | GET | Security settings | User | - | Security data |
| `/app/settings/notifications` | GET | Notification settings | User | - | Notification data |
| `/app/settings/notifications` | PUT | Update notifications | User | Notification data | Updated settings |
| `/app/settings/billing` | GET | Billing settings | Owner | - | Billing data |
| `/app/settings/billing` | PUT | Update billing | Owner | Billing data | Updated billing |
| `/app/settings/integrations` | GET | Integrations | Owner | - | Integrations list |
| `/app/settings/integrations/:integrationId` | POST | Enable integration | Owner | - | Enabled integration |
| `/app/settings/integrations/:integrationId` | DELETE | Disable integration | Owner | - | Success message |
| `/app/settings/audit-log` | GET | Audit log | Owner | Query: `{ limit, offset }` | Audit entries |

## Admin Panel (Superadmin Only)

| Route | Method | Purpose | Auth | Request | Response |
|-------|--------|---------|------|---------|----------|
| `/admin/dashboard` | GET | Admin dashboard | Superadmin | - | Dashboard data |
| `/admin/users` | GET | All users | Superadmin | Query: `{ search, role }` | Users list |
| `/admin/users/:userId` | GET | User details | Superadmin | - | User data |
| `/admin/users/:userId` | PUT | Update user | Superadmin | User data | Updated user |
| `/admin/users/:userId` | DELETE | Delete user | Superadmin | - | Success message |
| `/admin/offices` | GET | All offices | Superadmin | - | Offices list |
| `/admin/offices/:officeId` | GET | Office details | Superadmin | - | Office data |
| `/admin/compliance` | GET | Compliance status | Superadmin | - | Compliance data |
| `/admin/system-health` | GET | System health | Superadmin | - | Health metrics |
| `/admin/logs` | GET | System logs | Superadmin | Query: `{ level, limit }` | Logs list |

---

# API ENDPOINTS (REST + tRPC)

## tRPC Procedures

PrimeWeb uses tRPC for type-safe API calls. All procedures are organized by router.

### Auth Router

```typescript
// Login
trpc.auth.login.mutate({ email, password })
→ { user, token, refreshToken }

// Signup
trpc.auth.signup.mutate({ email, password, name, office })
→ { user, token, refreshToken }

// Get current user
trpc.auth.me.useQuery()
→ { user }

// Logout
trpc.auth.logout.mutate()
→ { success }

// Refresh token
trpc.auth.refreshToken.mutate({ refreshToken })
→ { token, refreshToken }

// Setup MFA
trpc.auth.setupMFA.mutate({ method })
→ { qrCode, backupCodes }

// Verify MFA
trpc.auth.verifyMFA.mutate({ code })
→ { token }
```

### Client Router

```typescript
// Get all clients
trpc.client.list.useQuery({ year, status, search })
→ { clients: Client[] }

// Get client details
trpc.client.get.useQuery({ clientId })
→ { client: Client }

// Create client
trpc.client.create.mutate({ name, ssn, email, phone })
→ { client: Client }

// Update client
trpc.client.update.mutate({ clientId, data })
→ { client: Client }

// Delete client
trpc.client.delete.mutate({ clientId })
→ { success }

// Get client returns
trpc.client.getReturns.useQuery({ clientId, year })
→ { returns: Return[] }

// Get client documents
trpc.client.getDocuments.useQuery({ clientId })
→ { documents: Document[] }

// Upload document
trpc.client.uploadDocument.mutate({ clientId, file })
→ { document: Document }
```

### Return Router

```typescript
// Get all returns
trpc.return.list.useQuery({ year, status, search })
→ { returns: Return[] }

// Get return details
trpc.return.get.useQuery({ returnId })
→ { return: Return }

// Create return
trpc.return.create.mutate({ clientId, taxYear })
→ { return: Return }

// Update return
trpc.return.update.mutate({ returnId, data })
→ { return: Return }

// Calculate return
trpc.return.calculate.mutate({ returnId })
→ { calculations: Calculations }

// Validate return
trpc.return.validate.mutate({ returnId })
→ { errors: ValidationError[] }

// File return
trpc.return.file.mutate({ returnId })
→ { filingConfirmation: FilingConfirmation }

// Get return transcript
trpc.return.getTranscript.useQuery({ returnId })
→ { transcript: Transcript }

// Get return history
trpc.return.getHistory.useQuery({ returnId })
→ { history: HistoryEntry[] }
```

### IRS Router

```typescript
// Get live feed
trpc.irs.getLiveFeed.useQuery({ limit, offset })
→ { events: IrsEvent[] }

// Get alerts
trpc.irs.getAlerts.useQuery({ severity, status })
→ { alerts: Alert[] }

// Acknowledge alert
trpc.irs.acknowledgeAlert.mutate({ alertId })
→ { alert: Alert }

// Get TC code definition
trpc.irs.getTCCodeDefinition.useQuery({ tcCode })
→ { definition: TCCodeDefinition }

// Get TC codes by category
trpc.irs.getTCCodesByCategory.useQuery({ category })
→ { codes: TCCode[] }

// Get client transcript
trpc.irs.getTranscript.useQuery({ clientId })
→ { transcript: Transcript }

// Refresh transcript
trpc.irs.refreshTranscript.mutate({ clientId })
→ { transcript: Transcript }

// Get holds
trpc.irs.getHolds.useQuery()
→ { holds: Hold[] }

// Run compliance check
trpc.irs.runComplianceCheck.mutate({ clientId, taxYear })
→ { results: ComplianceResults }
```

### Office Router

```typescript
// Get all offices
trpc.office.list.useQuery()
→ { offices: Office[] }

// Get office details
trpc.office.get.useQuery({ officeId })
→ { office: Office }

// Create office
trpc.office.create.mutate({ name, location })
→ { office: Office }

// Update office
trpc.office.update.mutate({ officeId, data })
→ { office: Office }

// Get office team
trpc.office.getTeam.useQuery({ officeId })
→ { members: TeamMember[] }

// Add team member
trpc.office.addTeamMember.mutate({ officeId, email, role })
→ { member: TeamMember }

// Get office production
trpc.office.getProduction.useQuery({ officeId })
→ { metrics: ProductionMetrics }

// Get office IRS feed
trpc.office.getIRSFeed.useQuery({ officeId })
→ { events: IrsEvent[] }
```

### AI Router

```typescript
// Explain return
trpc.ai.explainReturn.mutate({ returnId })
→ { explanation: string }

// Check for issues
trpc.ai.checkForIssues.mutate({ returnId })
→ { issues: Issue[] }

// Optimize return
trpc.ai.optimizeReturn.mutate({ returnId })
→ { suggestions: Suggestion[] }

// Generate client summary
trpc.ai.generateClientSummary.mutate({ returnId })
→ { summary: string }

// Chat with assistant
trpc.ai.chat.mutate({ message, context })
→ { response: string }
```

---

## REST API Endpoints (Legacy Support)

For systems that require REST API instead of tRPC:

### Authentication

```
POST /api/auth/login
POST /api/auth/signup
POST /api/auth/logout
POST /api/auth/refresh-token
GET  /api/auth/me
POST /api/auth/mfa/setup
POST /api/auth/mfa/verify
```

### Clients

```
GET    /api/clients
POST   /api/clients
GET    /api/clients/:clientId
PUT    /api/clients/:clientId
DELETE /api/clients/:clientId
GET    /api/clients/:clientId/returns
GET    /api/clients/:clientId/documents
POST   /api/clients/:clientId/documents
GET    /api/clients/:clientId/messages
POST   /api/clients/:clientId/messages
```

### Returns

```
GET    /api/returns
POST   /api/returns
GET    /api/returns/:returnId
PUT    /api/returns/:returnId
DELETE /api/returns/:returnId
POST   /api/returns/:returnId/calculate
POST   /api/returns/:returnId/validate
POST   /api/returns/:returnId/file
GET    /api/returns/:returnId/transcript
GET    /api/returns/:returnId/history
```

### IRS Integration

```
GET    /api/irs/feed
GET    /api/irs/alerts
POST   /api/irs/alerts/:alertId/acknowledge
GET    /api/irs/tc-codes
GET    /api/irs/tc-codes/:tcCode
GET    /api/irs/transcript/:clientId
POST   /api/irs/transcript/:clientId/refresh
GET    /api/irs/holds
POST   /api/irs/compliance-check
```

### Offices

```
GET    /api/offices
POST   /api/offices
GET    /api/offices/:officeId
PUT    /api/offices/:officeId
DELETE /api/offices/:officeId
GET    /api/offices/:officeId/team
POST   /api/offices/:officeId/team
PUT    /api/offices/:officeId/team/:memberId
DELETE /api/offices/:officeId/team/:memberId
GET    /api/offices/:officeId/production
GET    /api/offices/:officeId/irs-feed
```

---

## Error Codes

| Code | HTTP | Meaning |
|------|------|---------|
| `UNAUTHORIZED` | 401 | User not authenticated |
| `FORBIDDEN` | 403 | User lacks permission |
| `NOT_FOUND` | 404 | Resource not found |
| `VALIDATION_ERROR` | 400 | Invalid request data |
| `CONFLICT` | 409 | Resource already exists |
| `RATE_LIMITED` | 429 | Too many requests |
| `INTERNAL_ERROR` | 500 | Server error |
| `SERVICE_UNAVAILABLE` | 503 | Service temporarily down |

---

## Rate Limiting

**Public endpoints:** 100 requests/hour per IP  
**Authenticated endpoints:** 1,000 requests/hour per user  
**Admin endpoints:** 10,000 requests/hour per admin  

Rate limit headers:
```
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1619000000
```

---

## Pagination

All list endpoints support pagination:

```
GET /api/returns?page=1&limit=20&sort=createdAt&order=desc
```

Response:
```json
{
  "data": [ /* items */ ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 245,
    "pages": 13
  }
}
```

---

## WebSocket Events (Real-Time Updates)

**Connection:** `wss://primeweb.app/ws`

**Subscribe to live feed:**
```json
{
  "action": "subscribe",
  "channel": "irs:feed:office:123"
}
```

**Receive event:**
```json
{
  "type": "irs:update",
  "data": {
    "tcCode": "150",
    "clientId": "456",
    "timestamp": "2026-04-26T10:30:00Z"
  }
}
```

---

**END OF ROUTE MAP & API SPECIFICATION**

**Version:** 1.0  
**Status:** ✅ Production-Ready  
**Last Updated:** April 26, 2026
