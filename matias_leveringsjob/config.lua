-- config.lua
Config = {}

-- Cooldown tid i sekunder
Config.CooldownTime = 600000  -- 10 minutter hvor langtid der skal gå før man kan starte det igen

-- Koordinater for afleveringsstedet
Config.DeliveryZones = {
    { x = -273.9335, y = 6171.8818, z = 31.4739 }, -- -273.9335, 6171.8818, 31.4739
    { x = -1135.4518, y = 2690.9553, z = 18.8004 }, -- -1135.4518, 2690.9553, 18.8004, 325.9309
    { x = 1373.4233, y = 3618.1506, z = 34.8919 }, -- 1373.4233, 3618.1506, 34.8919 
    -- Tilføj flere afleveringssteder her
}

-- Radius af afleveringszonen
Config.DeliveryZoneRadius = 5.0

-- Belønning for at aflevere bilen
Config.RewardAmount = 35000

-- Koordinater for bilens spawn
Config.VehicleSpawnCoords = vector3(769.7209, -3202.9722, 5.6390)


-- Retning af bilen ved spawn
Config.VehicleHeading = 269.6957

-- Koordinater for spawn NPC og øje funktionen
Config.NPCSpawnCoords = vector3(764.4934, -3208.0234, 6.0338)

-- Model af NPC
Config.NPCModel = `s_m_m_ccrew_01`
