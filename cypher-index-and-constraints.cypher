// create uniqueness constraint for single property
CREATE CONSTRAINT <constraint_name> IF NOT EXISTS
FOR (x:<node_label>)
REQUIRE x.<property_key> IS UNIQUE
// ex: CREATE CONSTRAINT Movie_movieId_unique IF NOT EXISTS FOR (x:Movie) REQUIRE <x.movieId, x.name> IS UNIQUE
// UNIQUE, IS NOT EXIST

// create index
CREATE INDEX <index_name> IF NOT EXISTS
FOR (x:<node_label>)
ON x.<property_key>

// SYNTAX REATE A RANGE
CREATE INDEX <index_name> IF NOT EXISTS
FOR ()-[x:<RELATIONSHIP_TYPE>]-()
ON (x.<property_key>)

// multiple index
CREATE INDEX <index_name> IF NOT EXISTS
FOR (x:<node_label>)
ON (x.<property_key1>, x.<property_key2>, ...)

// create text index
CREATE TEXT INDEX <index_name> IF NOT EXISTS
FOR (x:<node_label>)
ON x.<property_key>

// create text index for list
CREATE TEXT INDEX <index_name> IF NOT EXISTS
FOR ()-[x:<RELATIONSHIP_TYPE>]-()
ON (x.<property_key>)

// syntax create full-text index
CREATE FULLTEXT INDEX <index_name> IF NOT EXISTS
FOR (x:<node_label>)
ON EACH [x.<property_key>]

// syntax full text with relationship
CREATE FULLTEXT INDEX <index_name> IF NOT EXISTS
FOR ()-[x:<RELATIONSHIP_TYPE>]-()
ON EACH [x.<property_key>]

// syntax create full-text with multiple node label and properties
CREATE FULLTEXT INDEX <index_name> IF NOT EXISTS
(x:<node_label1> | <node_label2> | ...)
ON EACH [x.<property_key1>, x.<property_key2>, ...]
