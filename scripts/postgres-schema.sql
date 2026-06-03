-- PostgreSQL schema for FloodGuard.
-- Run this file in pgAdmin Query Tool after creating/selecting your database.

CREATE TABLE IF NOT EXISTS app_state (
  collection TEXT PRIMARY KEY,
  data JSONB NOT NULL,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS app_state_data_gin_idx
  ON app_state
  USING GIN (data);

COMMENT ON TABLE app_state IS 'Stores FloodGuard collections as JSONB documents for the current app API.';
COMMENT ON COLUMN app_state.collection IS 'Collection name, for example users, rescueRequests, safeZones.';
COMMENT ON COLUMN app_state.data IS 'JSON array/object data used by the Express API.';

