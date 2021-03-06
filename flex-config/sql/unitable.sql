COMMENT ON TABLE osm.unitable IS 'All OpenStreetMap data from the source file in one big table.  NOT FOR PRODUCTION USE! Generated by osm2pgsql Flex output using pgosm-flex/flex-config/unitable.lua';
COMMENT ON COLUMN osm.unitable.tags IS 'Stores unaltered key/value pairs from OpenStreetMap.  A few tags are dropped by Lua script though most are preserved.';

ALTER TABLE osm.unitable
    ADD CONSTRAINT pk_osm_unitable_osm_id_type
    PRIMARY KEY (osm_id, geom_type)
;

COMMENT ON COLUMN osm.unitable.geom IS 'Geometry loaded by osm2pgsql.';
