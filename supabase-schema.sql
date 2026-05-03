-- ============================================================================
-- SUPABASE SCHEMA: Protótipo Temporal de Macroalgas - Multi-Device Sync
-- ============================================================================
-- Crie um novo SQL Editor no Supabase Dashboard e cole TODO este código
-- Execution: Run (Ctrl+Enter)
-- ============================================================================

-- 1. ENABLE REQUIRED EXTENSIONS
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "http";

-- 2. CAMPAIGNS TABLE
CREATE TABLE campaigns (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL UNIQUE,
  description TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

ALTER TABLE campaigns ENABLE ROW LEVEL SECURITY;

CREATE POLICY "campaigns_read_all" ON campaigns
  FOR SELECT
  USING (true);

CREATE POLICY "campaigns_insert_anon" ON campaigns
  FOR INSERT
  WITH CHECK (true);

-- 3. DEVICES TABLE
CREATE TABLE devices (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  campaign_id UUID NOT NULL REFERENCES campaigns(id) ON DELETE CASCADE,
  device_name TEXT NOT NULL,
  device_id_field TEXT NOT NULL, -- user-provided ID (e.g., "Tablet-001")
  created_at TIMESTAMP DEFAULT NOW(),
  last_sync TIMESTAMP,
  UNIQUE(campaign_id, device_id_field)
);

ALTER TABLE devices ENABLE ROW LEVEL SECURITY;

CREATE POLICY "devices_read_own_campaign" ON devices
  FOR SELECT
  USING (true); -- All devices visible (can see other devices in campaign)

CREATE POLICY "devices_insert_anon" ON devices
  FOR INSERT
  WITH CHECK (true);

-- 4. STATIONS TABLE (ESTAÇÕES)
CREATE TABLE stations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  campaign_id UUID NOT NULL REFERENCES campaigns(id) ON DELETE CASCADE,
  device_id UUID NOT NULL REFERENCES devices(id) ON DELETE CASCADE,
  local_id TEXT, -- device's local ID before sync
  station_name TEXT,
  latitude DECIMAL(10, 7),
  longitude DECIMAL(10, 7),
  observation TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  synced_at TIMESTAMP
);

ALTER TABLE stations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "stations_read_campaign" ON stations
  FOR SELECT
  USING (
    campaign_id IN (SELECT id FROM campaigns)
  );

CREATE POLICY "stations_insert_own_device" ON stations
  FOR INSERT
  WITH CHECK (true);

CREATE POLICY "stations_update_own_device" ON stations
  FOR UPDATE
  USING (true)
  WITH CHECK (true);

-- Index for performance
CREATE INDEX idx_stations_campaign_id ON stations(campaign_id);
CREATE INDEX idx_stations_device_id ON stations(device_id);

-- 5. QUADRATS TABLE (QUADRADOS)
CREATE TABLE quadrats (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  station_id UUID NOT NULL REFERENCES stations(id) ON DELETE CASCADE,
  campaign_id UUID NOT NULL REFERENCES campaigns(id) ON DELETE CASCADE,
  device_id UUID NOT NULL REFERENCES devices(id) ON DELETE CASCADE,
  local_id TEXT, -- device's local ID before sync
  quadrat_number INTEGER,
  depth_m DECIMAL(5, 2),
  cover_percent DECIMAL(5, 2),
  notes TEXT,
  morphofunctional_groups TEXT, -- JSON array as string
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  synced_at TIMESTAMP
);

ALTER TABLE quadrats ENABLE ROW LEVEL SECURITY;

CREATE POLICY "quadrats_read_campaign" ON quadrats
  FOR SELECT
  USING (
    campaign_id IN (SELECT id FROM campaigns)
  );

CREATE POLICY "quadrats_insert_own_device" ON quadrats
  FOR INSERT
  WITH CHECK (true);

CREATE POLICY "quadrats_update_own_device" ON quadrats
  FOR UPDATE
  USING (true)
  WITH CHECK (true);

-- Index for performance
CREATE INDEX idx_quadrats_station_id ON quadrats(station_id);
CREATE INDEX idx_quadrats_campaign_id ON quadrats(campaign_id);
CREATE INDEX idx_quadrats_device_id ON quadrats(device_id);

-- 6. SYNC_EVENTS TABLE (auditoria)
CREATE TABLE sync_events (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  campaign_id UUID NOT NULL REFERENCES campaigns(id) ON DELETE CASCADE,
  device_id UUID NOT NULL REFERENCES devices(id) ON DELETE CASCADE,
  station_count INTEGER,
  quadrat_count INTEGER,
  sync_status TEXT DEFAULT 'success', -- success, error
  error_message TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

ALTER TABLE sync_events ENABLE ROW LEVEL SECURITY;

CREATE POLICY "sync_events_read_campaign" ON sync_events
  FOR SELECT
  USING (
    campaign_id IN (SELECT id FROM campaigns)
  );

CREATE POLICY "sync_events_insert_anon" ON sync_events
  FOR INSERT
  WITH CHECK (true);

-- Index for performance
CREATE INDEX idx_sync_events_campaign_id ON sync_events(campaign_id);
CREATE INDEX idx_sync_events_device_id ON sync_events(device_id);

-- 7. REALTIME CONFIGURATION
-- Enable realtime for each table
ALTER PUBLICATION supabase_realtime ADD TABLE campaigns;
ALTER PUBLICATION supabase_realtime ADD TABLE devices;
ALTER PUBLICATION supabase_realtime ADD TABLE stations;
ALTER PUBLICATION supabase_realtime ADD TABLE quadrats;
ALTER PUBLICATION supabase_realtime ADD TABLE sync_events;

-- ============================================================================
-- MANUAL STEPS AFTER RUNNING THIS SQL:
-- ============================================================================
-- 1. Go to Supabase Dashboard → Authentication → Policies
-- 2. Verify all RLS policies are created (should see 9 policies listed)
-- 3. Go to Realtime → Enable realtime for the project
-- 4. Verify tables are listed under "Realtime enabled tables"
-- 5. Copy your Project URL and Anon Key from Settings → API
-- 6. Update app_campo_macroalgas.html with these credentials
-- ============================================================================
