# 🛡️ SecureSociety

> **Smart Apartment Service & Verified Worker Entry System**  
> A high-security, full-stack housing society management platform featuring ticket diagnostics, specialized technician assignment, and cryptographic QR-based security verification for on-site services.

---



## 🔍 Overview

**SecureSociety** bridges the gap between home residential maintenance requests and physical security constraints in modern high-rises. In traditional complexes, calling an electrician or painter involves opening your door to complete strangers. 

SecureSociety solves this by coupling a streamlined **Resident Ticket Manager** with a **Cryptographically-Recorded Worker Verification System**:
1. **Residents** report issues and get smart diagnostic checklists powered by **Gemini AI**.
2. **Admins** dispatch specialized, verified technical workers to solve the ticket.
3. **Workers** arrive on-scene and supply a secure visual QR verification key.
4. **Residents** scan the QR through the app to verify the worker is currently assigned to this ticket before opening the front door.


## ✨ Key Capabilities & Features

### 👤 1. Multi-Role Smart Onboarding (`AuthPage.tsx`)
- Customized onboarding for three distinct roles:
  - **Residents**: Register with block letter, floor number, and door number indicators.
  - **Technical Workers**: Onboard with specialized credentials (such as Plumber, Electrician, and Carpenter).
  - **Society Administrators**: General system supervisors.
- Clean design with real-time password security requirement validation indicators.

### 🏠 2. Resident Experience Portal (`ResidentDashboard.tsx`)
- **Complaints Desktop**: Lodge physical complaints specifying custom details or overrides.
- **Gemini AI Diagnostics**: Instant step-by-step smart troubleshooting guide detailing safety precautions to take before the worker arrives.
- **Micro-Camera verification scanner**: Utilizes the system camera to scan temporary worker QR codes to confirm the assigned worker in real-time.
- **Feedback & Rating loop**: Rate workers on promptness and behavior after completion.

### 👷 3. Field Worker Engine (`WorkerDashboard.tsx`)
- **Duty Dashboard**: Real-time view of active tickets, travel status, and work checklist.
- **Cryptographic QR Generator**: Builds temporary QR authorization codes tied to specific worker IDs and current ticket metadata.
- **Trade Certification & Status Tracker**: Manage availability states and track ratings.

### 👑 4. Grand Society Administrator Terminal (`AdminDashboard.tsx`)
- **Control Center & Analytics**: View overall status metrics and completion ratios.
- **Visual Dispatches**: Manually route specialized tickets to matched tradespeople.
- **Cryptographic Compliance Log Audits**: Permanent inspectable list of identity verification checks recorded on the compound.
- **Staff Audits**: Manage user registries, revoke permissions, or delete accounts if needed.

---

## ⚙️ Tech Stack

- **Frontend Environment**: React 18, Vite, Tailwind CSS, Lucide Icons, Framer Motion
- **Database Store**: Supabase Cloud PostgreSQL API
- **Backend Architecture**: Node.js, Express, `jsonwebtoken`, `bcryptjs`, `@supabase/supabase-js`
- **Bundling & Production Systems**: `esbuild` compiling down to standard `.cjs` (CommonJS) bundled output for fast and containerized deployments 
- **Verification Toolkit**: Built-in `html5-qrcode` & NodeJS side `qrcode` generators

---

## 📂 Directory Structure

```bash
├── package.json               # Full dependency lists and compilation pipeline
├── server.ts                  # Express Backend Service, Supabase hooks, JWT & API routes
├── schema.sql                 # Primary database tables creation definitions
├── tsconfig.json              # TypeScript compilation specifications
├── vite.config.ts             # Vite/React configurations & plugin pipelines
├── metadata.json              # Access credentials, sandbox configurations
├── src/
│   ├── main.tsx               # Frontend client bundle entry point
│   ├── App.tsx                # Main Router, role controller & root layouts
│   ├── types.ts               # Shared robust TS Interface & Enum boundaries
│   ├── index.css              # Global Tailwind configuration imports
│   └── components/            # UI Module Boundaries
│       ├── AuthPage.tsx       # Secure credentials registry and OAuth triggers
│       ├── ResidentDashboard.tsx # Homeowner self-service complaints & QR client
│       ├── WorkerDashboard.tsx   # Technician dispatch manager & QR creator
│       └── AdminDashboard.tsx    # Head-Office supervisory console & audits
```

---

