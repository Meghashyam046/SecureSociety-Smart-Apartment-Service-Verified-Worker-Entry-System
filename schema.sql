-- SQL Schema for SecureSociety Supabase PostgreSQL Integration
-- Go to your Supabase project -> SQL Editor, paste this block, and click "Run".

CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  phone VARCHAR(50),
  role VARCHAR(50) NOT NULL CHECK (role IN ('resident', 'worker', 'admin')),
  skill_type VARCHAR(100), -- nullable for resident/admin, trade category for technicians
  password_hash VARCHAR(255) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  
  -- Resident housing attributes (optional/nullable based on role)
  block VARCHAR(50),
  floor VARCHAR(50),
  door_no VARCHAR(50)
);

-- Index user queries for accelerated email lookups during authentication
CREATE INDEX IF NOT EXISTS idx_users_email ON users (email);
