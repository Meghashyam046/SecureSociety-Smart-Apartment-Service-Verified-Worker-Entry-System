# 🛡️ SecureSociety

> **Smart Apartment Service & Verified Worker Entry System**  
> A high-security, full-stack housing society management platform featuring AI-assisted ticket diagnostics, specialized technician assignment, and cryptographic QR-based security verification for on-site services.

---

## 📖 Table of Contents
1. [Overview](#-overview)
2. [What We Upgraded (New Enterprise Auth Integration)](#-what-we-upgraded)
3. [Key Capabilities & Features](#-key-capabilities--features)
4. [Architecture & Flow](#-architecture--flow)
5. [Tech Stack](#-tech-stack)
6. [Directory Structure](#-directory-structure)
7. [Supabase SQL Schema](#-supabase-sql-schema)
8. [Environmental Variables Setup](#-environmental-variables-setup)
9. [Getting Started & Development scripts](#-getting-started--development-scripts)
10. [Troubleshooting Common Deployment Issues](#-troubleshooting-common-deployment-issues)
    - [Why `/undefined/` occurs in API URLs](#1-why-undefined-occurs-in-api-urls)
    - [Unexpected token `<` (`<!doctype html>`) JSON Parsing Error](#2-unexpected-token--doctype-html-json-parsing-error)
    - [Google OAuth Integration details](#3-google-oauth-integration-details)

---

## 🔍 Overview

**SecureSociety** bridges the gap between home residential maintenance requests and physical security constraints in modern high-rises. In traditional complexes, calling an electrician or painter involves opening your door to complete strangers. 

SecureSociety solves this by coupling a streamlined **Resident Ticket Manager** with a **Cryptographically-Recorded Worker Verification System**:
1. **Residents** report issues and get smart diagnostic checklists powered by **Gemini AI**.
2. **Admins** dispatch specialized, verified technical workers to solve the ticket.
3. **Workers** arrive on-scene and supply a secure visual QR verification key.
4. **Residents** scan the QR through the app to verify the worker is currently assigned to this ticket before opening the front door.

---

## 🚀 What We Upgraded (New Enterprise Auth Integration)

We transitioned the authentication system from a basic file-based layout to a high-security, industry-standard mechanism:

1. **Supabase PostgreSQL Integration**:
   - Switched the primary data store to Supabase PostgreSQL, ensuring atomic transaction handling, durable cloud storage, and rapid relational querying.
   - Leveraged database constraints to enforce unique keys and prevent email duplication.

2. **Bcrypt Password Hashing**:
   - Zero plain-text storage. All user passwords are dynamically salted and hashed using `bcryptjs` before insertion into the Supabase database.
   - Built a secure legacy migration path during authentication to automatically parse and verify legacy accounts.

3. **Stateless JWT Authorization**:
   - Implemented JSON Web Token (JWT) tracking with a secure key handshake verified via the `JWT_SECRET` environment variable.
   - Generated tokens are valid for **7 days** and securely carry the logged-in user's ID, unique email address, and distinct role context (`resident`, `worker`, `admin`) to eliminate stale session manipulation.
   - Updated the backend Express stack with a central `authenticateToken` middleware validating tokens for all protected API routes (complaints boards, admin command centers, staff logs, and AI evaluation engines).
   - Upgraded React's local state and session managers to secure the token inside `localStorage` under `securesociety_token` and transmit it accurately within request headers as `Authorization: Bearer <TOKEN>`.

4. **Robust Google OAuth Callback Processing**:
   - Refactored Google callback endpoints to retrieve user profiles, verify domain compliance (`@gmail.com`), upsert records into Supabase PostgreSQL, generate stateless JWT authentications, and securely transition authentication keys directly into localized browser storage.

---

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
- **AI Integration**: `@google/genai` (Official modern SDK)
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

## 🗄️ Supabase SQL Schema

The structural layout of the `users` collection is declared as follows in `/schema.sql`:

```sql
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(50),
    role VARCHAR(50) CHECK (role IN ('resident', 'worker', 'admin')) NOT NULL,
    skill_type VARCHAR(100), -- nullable for resident and admin
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
```

---

## 🔑 Environmental Variables Setup

The application is fully full-stack server-proxied to ensure API keys or connection secrets never reach the client's browser. Create a `.env` file at the root of the project with the following keys:

```env
# Server Secrets (Do NOT prefix with VITE_)
PORT=3000
GEMINI_API_KEY=your_google_gemini_api_key_here
GOOGLE_CLIENT_ID=your_google_oauth_client_id_here
GOOGLE_CLIENT_SECRET=your_google_oauth_client_secret_here

# Supabase Credentials
SUPABASE_URL=https://your-supabase-project.supabase.co
SUPABASE_ANON_KEY=your-supabase-anon-key-here

# JWT Security
JWT_SECRET=your-jwt-auth-secret-key-here

# Client Side Configs (Exposed to Vite bundle)
VITE_API_URL=https://securesociety-smart-apartment-service.onrender.com
```

---

## 🚦 Getting Started & Development Scripts

Install absolute baseline elements and launch the development environment:

### 1. Install Dependencies
```bash
npm install
```

### 2. Run Locally in Development Mode
Runs the backend Express server on Node.js using `tsx`, while automatically mounting Vite's HMR middleware for instantaneous frontend refresh:
```bash
npm run dev
```
Open your browser at `http://localhost:3000`.

### 3. Build & Compile for Production
Creates the static frontend build and bundles the TypeScript backend down to a production CJS module inside `dist/`:
```bash
npm run build
```

### 4. Direct Production Run
Launches the built high-speed application:
```bash
npm run start
```

---

## 🛠️ Troubleshooting Common Deployment Issues

### 1. Why `/undefined/` occurs in API URLs
If your application requests endpoints like:
```text
https://securesociety-smart-apartment-service.onrender.com/undefined/api/auth/google/url
```
**The root cause is a reference to an uninitialized env variable.**
- **The Issue**: If the environment variable isn't injected correctly during the *Vite build step* (via Vercel dashboard or local environment setup), `import.meta.env.VITE_API_URL` resolves to JavaScript `undefined`. When string interpolated, this literally outputs the string `"/undefined/"` inside the query string.
- **The Fix**: Double-check that your static hosting target (Vercel) has `VITE_API_URL` set in its **Environment Variables** dashboard. Note that Vite compiles variables *at build time*, meaning you must redeploy after saving settings so the bundler replaces references with hard strings.

---

### 2. Unexpected token `<` (`<!doctype html>`) JSON Parsing Error
When a developer clicks a button and is met with this response error:
```javascript
Unexpected token '<', "<!doctype "... is not valid JSON
```
**This indicates that the server responded with an HTML page (like `index.html`) when the frontend expected JSON.**

#### Why it Happens in Node/Express/Render + Vercel Architecture:
- Under Single Page Application (SPA) routing, both the server and static hosting deploy catch-alls (`*` fallbacks) so page reloads on sub-routes serve the root index file.
- If your backend URL base is configured incorrectly or points directly to the frontend static server (Vercel) instead of the actual API server (Render), calling `/api/auth/google/url` will land on Vercel's SPA routing. Vercel notices it has no match, so it returns `index.html` (which starts with `<!doctype html>`).
- When the frontend calls `response.json()`, the browser attempts to parse this HTML text as JSON, immediately causing the parse crash.

#### How to verify and troubleshoot:
1. **Log raw responses before parsing**:
   ```javascript
   const response = await fetch(`${API_URL}/api/auth/google/url`);
   const text = await response.text();
   console.log("Raw response body:", text);
   ```
2. **Test Backend Separately**: Request the route directly in your browser. If `https://securesociety-smart-apartment-service.onrender.com/api/auth/google/url` returns legitimate JSON structures, the backend is correct, and the error lies in incorrect frontend URL variable routing.

---

### 3. Google OAuth Integration details
- Ensure Google Cloud Console has valid redirect URIs:
  - Authorized JavaScript Origins: `https://securesociety-smart-apartment-service.onrender.com`
  - Authorized Redirect URIs: `https://securesociety-smart-apartment-service.onrender.com/api/auth/google/callback`
- In local development sandboxes (e.g. running on port 3000), a mock local login flow bypasses Google client certificate requirements for rapid design verification. Ensure production deployment files point exclusively to live credentials.

---

*SecureSociety is built to prioritize security, physical safety, and technical transparency.*
