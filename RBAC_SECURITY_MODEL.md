# RBAC & IRS-COMPLIANT SECURITY MODEL
## PrimeWeb Enterprise Tax Platform

**Document Version:** 1.0  
**Date:** April 26, 2026  
**Author:** Manus AI  
**Status:** Production-Ready  
**Classification:** Security & Compliance  
**Owner:** Condre Dvon Ross  

---

## TABLE OF CONTENTS

1. [Security Overview](#security-overview)
2. [Role-Based Access Control (RBAC)](#role-based-access-control-rbac)
3. [Permission Matrix](#permission-matrix)
4. [IRS Compliance Requirements](#irs-compliance-requirements)
5. [Data Protection](#data-protection)
6. [Authentication & Authorization](#authentication--authorization)
7. [Audit & Logging](#audit--logging)
8. [Incident Response](#incident-response)

---

# SECURITY OVERVIEW

## Security Principles

PrimeWeb implements a **defense-in-depth** security model with multiple layers of protection:

1. **Authentication** - Verify user identity
2. **Authorization** - Verify user permissions
3. **Encryption** - Protect data in transit and at rest
4. **Audit** - Log all access and changes
5. **Compliance** - Meet IRS, SOC 2, and HIPAA requirements

## Compliance Standards

| Standard | Requirement | Implementation |
|----------|-------------|-----------------|
| **IRS Pub 1345** | E-file provider security | Encryption, audit logs, access control |
| **SOC 2 Type II** | Security controls audit | Annual third-party audit |
| **HIPAA** | Health information privacy | Data encryption, access controls |
| **PCI-DSS** | Payment card security | Tokenization, no card storage |
| **GDPR** | Data privacy (EU) | Consent, data portability, deletion |

---

# ROLE-BASED ACCESS CONTROL (RBAC)

## Role Hierarchy

```
┌─────────────────────────────────────────────────────────┐
│                    SUPERADMIN                           │
│  (Manus/System administrators only)                     │
└────────────────────────┬────────────────────────────────┘
                         │
        ┌────────────────┼────────────────┐
        │                │                │
┌───────▼────────┐  ┌────▼────────┐  ┌──▼──────────────┐
│  OWNER         │  │ OFFICE MGR  │  │  PREPARER      │
│ (Office owner) │  │(Multi-office)│  │(Tax preparer)  │
└────────┬───────┘  └────┬────────┘  └──┬──────────────┘
         │               │              │
    ┌────▼────────┐  ┌───▼────────┐  ┌─▼─────────────┐
    │  CLIENT     │  │  REVIEWER  │  │  SUPPORT     │
    │(Taxpayer)   │  │(QA review) │  │(Help desk)   │
    └─────────────┘  └────────────┘  └──────────────┘
```

## Role Definitions

### 1. SUPERADMIN (Manus Only)

**Purpose:** System administration and compliance oversight

**Permissions:**
- ✅ Access all offices and returns
- ✅ Manage all users and roles
- ✅ View audit logs
- ✅ Configure system settings
- ✅ Manage compliance reports
- ✅ Override access controls (with logging)

**Restrictions:**
- ❌ Cannot modify client data (audit trail only)
- ❌ Cannot access client SSN without reason
- ❌ Cannot delete data (only archive)

### 2. OWNER (Office Owner)

**Purpose:** Office management and business operations

**Permissions:**
- ✅ Manage office settings and configuration
- ✅ Create and manage team members
- ✅ View all office returns and clients
- ✅ View office production metrics
- ✅ Configure billing and payments
- ✅ View office audit logs
- ✅ Manage integrations
- ✅ Export office data (with audit log)

**Restrictions:**
- ❌ Cannot access other offices
- ❌ Cannot modify user roles (preparer/reviewer only)
- ❌ Cannot delete returns (only archive)
- ❌ Cannot access superadmin functions

### 3. OFFICE MANAGER (Multi-Office)

**Purpose:** Manage multiple offices for larger organizations

**Permissions:**
- ✅ Manage assigned offices
- ✅ Create and manage team members in assigned offices
- ✅ View all returns in assigned offices
- ✅ View production metrics
- ✅ Configure office settings
- ✅ View office audit logs

**Restrictions:**
- ❌ Cannot access other offices
- ❌ Cannot modify billing
- ❌ Cannot manage integrations
- ❌ Cannot access owner functions

### 4. PREPARER (Tax Preparer)

**Purpose:** Prepare and file tax returns

**Permissions:**
- ✅ Create and edit returns
- ✅ View assigned clients
- ✅ Upload documents
- ✅ Calculate returns (Avalon)
- ✅ File returns with IRS
- ✅ View client messages
- ✅ Add notes to returns
- ✅ View IRS transcript data

**Restrictions:**
- ❌ Cannot access other preparers' returns
- ❌ Cannot delete returns
- ❌ Cannot modify client information
- ❌ Cannot access office settings
- ❌ Cannot view other preparers' notes

### 5. REVIEWER (QA/Compliance)

**Purpose:** Review and approve returns before filing

**Permissions:**
- ✅ View all returns (read-only)
- ✅ Add review comments
- ✅ Approve/reject returns
- ✅ View compliance issues
- ✅ Generate compliance reports
- ✅ View audit logs

**Restrictions:**
- ❌ Cannot edit returns
- ❌ Cannot file returns
- ❌ Cannot access client data
- ❌ Cannot modify office settings

### 6. CLIENT (Taxpayer)

**Purpose:** Self-service tax preparation and status tracking

**Permissions:**
- ✅ View own returns
- ✅ Upload documents
- ✅ View refund status
- ✅ Send messages to preparer
- ✅ View own profile
- ✅ Update own contact info
- ✅ Access self-service wizard

**Restrictions:**
- ❌ Cannot view other clients' data
- ❌ Cannot file returns
- ❌ Cannot access calculations
- ❌ Cannot view office data

### 7. SUPPORT (Help Desk)

**Purpose:** Customer support and troubleshooting

**Permissions:**
- ✅ View client information (limited)
- ✅ View return status (read-only)
- ✅ Send messages to clients
- ✅ View FAQ and knowledge base
- ✅ Escalate to preparer

**Restrictions:**
- ❌ Cannot edit returns
- ❌ Cannot file returns
- ❌ Cannot access SSN or full data
- ❌ Cannot access office settings

---

# PERMISSION MATRIX

## Resource-Level Permissions

| Resource | Superadmin | Owner | Office Mgr | Preparer | Reviewer | Client | Support |
|----------|-----------|-------|-----------|----------|----------|--------|---------|
| **Return** |
| View | ✅ All | ✅ Office | ✅ Office | ✅ Assigned | ✅ All | ✅ Own | ❌ |
| Create | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ (Wizard) | ❌ |
| Edit | ✅ | ❌ | ❌ | ✅ Assigned | ❌ | ✅ Own | ❌ |
| Delete | ✅ (Archive) | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| File | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ |
| **Client** |
| View | ✅ All | ✅ Office | ✅ Office | ✅ Assigned | ❌ | ✅ Own | ✅ Limited |
| Create | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Edit | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ Own | ❌ |
| Delete | ✅ (Archive) | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| **User** |
| View | ✅ All | ✅ Office | ✅ Office | ❌ | ❌ | ❌ | ❌ |
| Create | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Edit | ✅ | ✅ (Role) | ✅ (Role) | ❌ | ❌ | ✅ Own | ❌ |
| Delete | ✅ (Archive) | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| **Office** |
| View | ✅ All | ✅ Own | ✅ Assigned | ❌ | ❌ | ❌ | ❌ |
| Edit | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Settings | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| **Audit Log** |
| View | ✅ All | ✅ Office | ✅ Office | ❌ | ✅ Office | ❌ | ❌ |
| Export | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |

---

# IRS COMPLIANCE REQUIREMENTS

## Publication 1345 Compliance

**IRS Publication 1345** specifies security requirements for electronic return originators (EROs). PrimeWeb implements all required controls:

### 1. Access Control

```typescript
interface AccessControl {
  // User authentication
  authentication: {
    method: 'OAuth2' | 'SAML' | 'MFA';
    mfaRequired: boolean;
    passwordPolicy: {
      minLength: 12;
      requireUppercase: true;
      requireNumbers: true;
      requireSpecialChars: true;
      expirationDays: 90;
    };
  };

  // Session management
  session: {
    timeout: 15 * 60 * 1000; // 15 minutes
    maxConcurrentSessions: 1;
    requireReauth: true;
  };

  // IP restrictions
  ipWhitelist: {
    enabled: true;
    allowedRanges: ['10.0.0.0/8', '172.16.0.0/12'];
  };
}
```

### 2. Data Encryption

```typescript
interface DataEncryption {
  // In-transit encryption
  transit: {
    protocol: 'TLS 1.3';
    cipherSuites: [
      'TLS_AES_256_GCM_SHA384',
      'TLS_CHACHA20_POLY1305_SHA256'
    ];
  };

  // At-rest encryption
  atRest: {
    algorithm: 'AES-256-GCM';
    keyManagement: 'AWS KMS';
    keyRotation: 'Annual';
  };

  // Field-level encryption
  fieldLevel: {
    ssn: true;
    ein: true;
    bankAccount: true;
    routingNumber: true;
  };
}
```

### 3. Audit Logging

```typescript
interface AuditLog {
  timestamp: string;           // ISO 8601
  userId: string;              // User ID
  action: string;              // Action performed
  resource: string;            // Resource accessed
  resourceId: string;          // Resource ID
  changes: {
    field: string;
    oldValue: string;
    newValue: string;
  }[];
  ipAddress: string;           // User IP
  userAgent: string;           // Browser/client
  status: 'success' | 'failure';
  errorMessage?: string;
}
```

### 4. Return Transmission Security

```typescript
interface ReturnTransmission {
  // Encryption
  encryption: 'PGP' | 'S/MIME';
  signatureRequired: true;
  
  // Transmission method
  method: 'HTTPS' | 'SFTP';
  
  // Acknowledgment
  acknowledgmentRequired: true;
  acknowledgmentTimeout: 24 * 60 * 60 * 1000; // 24 hours
  
  // Retention
  retentionPeriod: 7 * 365; // 7 years
}
```

---

# DATA PROTECTION

## Personally Identifiable Information (PII)

**Protected Fields:**
- Social Security Number (SSN)
- Employer Identification Number (EIN)
- Bank account numbers
- Routing numbers
- Credit card numbers
- Driver's license numbers
- Passport numbers

**Protection Measures:**
1. **Encryption** - AES-256-GCM at rest
2. **Tokenization** - Replace with tokens in logs
3. **Masking** - Display only last 4 digits
4. **Access Control** - Limit to authorized roles
5. **Audit Logging** - Log all access

### Masking Examples

```typescript
// SSN masking
const ssn = "123-45-6789";
const masked = `XXX-XX-${ssn.slice(-4)}`; // XXX-XX-6789

// Bank account masking
const account = "1234567890";
const masked = `****${account.slice(-4)}`; // ****7890

// Email masking
const email = "john.doe@example.com";
const masked = "j***@example.com";
```

## Data Retention Policy

| Data Type | Retention | Reason |
|-----------|-----------|--------|
| Tax Returns | 7 years | IRS requirement |
| Audit Logs | 7 years | Compliance |
| Client Documents | 7 years | Compliance |
| Deleted Data | 30 days | Recovery window |
| Backups | 30 days | Disaster recovery |

---

# AUTHENTICATION & AUTHORIZATION

## Authentication Methods

### 1. OAuth 2.0 (Primary)

```typescript
interface OAuth2Flow {
  provider: 'Manus' | 'Google' | 'Microsoft';
  scopes: ['email', 'profile', 'offline_access'];
  redirectUri: 'https://primeweb.app/auth/callback';
  
  // Token management
  accessTokenExpiry: 1 * 60 * 60 * 1000; // 1 hour
  refreshTokenExpiry: 30 * 24 * 60 * 60 * 1000; // 30 days
}
```

### 2. Multi-Factor Authentication (MFA)

```typescript
interface MFA {
  // Required for: Owner, Reviewer, Preparer
  required: ['owner', 'reviewer', 'preparer'];
  
  // Methods
  methods: {
    totp: {
      enabled: true;
      issuer: 'PrimeWeb';
      algorithm: 'SHA1';
      digits: 6;
      period: 30;
    };
    sms: {
      enabled: true;
      provider: 'Twilio';
    };
    email: {
      enabled: true;
      provider: 'Brevo';
    };
  };
  
  // Backup codes
  backupCodes: {
    count: 10;
    length: 8;
    regenerateOnUse: false;
  };
}
```

### 3. Session Management

```typescript
interface Session {
  // Session creation
  sessionId: string;
  userId: string;
  createdAt: string;
  expiresAt: string;
  
  // Security
  httpOnly: true;
  secure: true;
  sameSite: 'Strict';
  
  // Tracking
  ipAddress: string;
  userAgent: string;
  lastActivity: string;
}
```

## Authorization

### JWT Token Structure

```json
{
  "header": {
    "alg": "RS256",
    "typ": "JWT"
  },
  "payload": {
    "sub": "user_123",
    "iss": "https://primeweb.app",
    "aud": "primeweb-api",
    "iat": 1619000000,
    "exp": 1619003600,
    "role": "preparer",
    "office_id": "office_456",
    "permissions": [
      "return:create",
      "return:edit",
      "return:file"
    ]
  },
  "signature": "..."
}
```

### Permission Checking

```typescript
// Middleware to check permissions
async function requirePermission(permission: string) {
  return (req: Request, res: Response, next: NextFunction) => {
    const token = req.headers.authorization?.split(' ')[1];
    const decoded = jwt.verify(token, SECRET_KEY);
    
    if (!decoded.permissions.includes(permission)) {
      return res.status(403).json({ error: 'Forbidden' });
    }
    
    next();
  };
}

// Usage
app.post('/api/returns/:id/file', 
  requirePermission('return:file'),
  fileReturnHandler
);
```

---

# AUDIT & LOGGING

## Audit Log Events

| Event | Severity | Logged Data |
|-------|----------|------------|
| User Login | Info | User ID, IP, timestamp |
| Failed Login | Warning | Email, IP, timestamp |
| MFA Enabled | Info | User ID, method, timestamp |
| Return Created | Info | Return ID, preparer, client |
| Return Modified | Info | Return ID, field, old/new value |
| Return Filed | Critical | Return ID, timestamp, IRS response |
| Return Deleted | Critical | Return ID, preparer, reason |
| Access Denied | Warning | User ID, resource, permission |
| Data Export | Critical | User ID, data type, count, timestamp |
| Settings Changed | Info | Setting, old/new value, user |

## Log Storage & Retention

```typescript
interface AuditLogStorage {
  // Primary storage
  database: {
    table: 'audit_logs';
    retention: 7 * 365; // 7 years
    indexed: ['userId', 'timestamp', 'action'];
  };

  // Archive storage
  archive: {
    location: 'AWS S3';
    bucket: 'primeweb-audit-logs';
    encryption: 'AES-256';
    retention: 7 * 365; // 7 years
  };

  // Real-time monitoring
  monitoring: {
    tool: 'ELK Stack';
    alerting: true;
    criticalEvents: [
      'return:filed',
      'return:deleted',
      'data:exported',
      'access:denied'
    ];
  };
}
```

---

# INCIDENT RESPONSE

## Incident Classification

| Severity | Description | Response Time |
|----------|-------------|----------------|
| **Critical** | Data breach, system down | 15 minutes |
| **High** | Unauthorized access, data loss | 1 hour |
| **Medium** | Failed authentication, audit log gap | 4 hours |
| **Low** | Minor security event | 24 hours |

## Incident Response Plan

```
1. DETECTION
   - Monitor audit logs for suspicious activity
   - Alert on critical events
   - Automated anomaly detection

2. CONTAINMENT
   - Isolate affected systems
   - Revoke compromised credentials
   - Block suspicious IPs

3. INVESTIGATION
   - Review audit logs
   - Identify root cause
   - Assess impact scope

4. REMEDIATION
   - Fix vulnerability
   - Restore from backup if needed
   - Verify fix effectiveness

5. NOTIFICATION
   - Notify affected users
   - Notify IRS if required
   - Document incident

6. PREVENTION
   - Update security controls
   - Implement additional monitoring
   - Conduct security training
```

## Breach Notification

**If a data breach is suspected:**

1. **Immediate Actions (< 1 hour)**
   - Isolate affected systems
   - Preserve evidence
   - Notify security team

2. **Investigation (< 24 hours)**
   - Determine scope of breach
   - Identify affected records
   - Assess regulatory requirements

3. **Notification (< 72 hours)**
   - Notify affected individuals
   - Notify regulatory authorities (if required)
   - Notify IRS (if tax data involved)

4. **Documentation**
   - Create incident report
   - Document remediation steps
   - Update security controls

---

**END OF RBAC & IRS-COMPLIANT SECURITY MODEL**

**Version:** 1.0  
**Status:** ✅ Production-Ready  
**Last Updated:** April 26, 2026
