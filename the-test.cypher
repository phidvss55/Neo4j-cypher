//clean up data
MATCH (u:User)
DETACH DELETE u;

MATCH (p:Person)
DETACH DELETE p;

MATCH (m:Movie)
DETACH DELETE m;

MATCH (n)
DETACH DELETE n

// re-import

// transform properties
MATCH (m:Movie)
 SET m.countries = split(coalesce(m.countries, ""), "|"),
m.languages = split(coalesce(m.languages, ""), "|"),
m.genres = split(coalesce(m.genres, ""), "|")

// add node named Director
MATCH (p:Person)-[:DIRECTED]->()
WITH DISTINCT p SET p:Director

// Create constraint for genre graph
CREATE CONSTRAINT Genre_name IF NOT EXISTS
FOR (x:Genre)
REQUIRE x.name IS UNIQUE

// checking constraint
SHOW CONSTRAINTS

// Create Node Genre
MATCH (m:Movie)
UNWIND m.genres AS genre
WITH m, genre
MERGE (g:Genre { name:genre })
MERGE (m)-[:IN_GENRE]->(g)

// clean up genre property in Movie
MATCH (m:Movie)
 SET m.genres = null

// checking
CALL db.schema.visualization
