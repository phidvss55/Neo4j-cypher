MATCH (p:Actor)-[:ACTED_IN]-(m:Movie)
WHERE p.name = 'Tom Hanks' AND
'Drama' IN m.genres
RETURN m.title AS Movie

// use UNWIND to seperate value of a field in Node and insert into a new node
MATCH (m:Movie)
UNWIND m.languages AS language
WITH language, collect(m) AS movies
MERGE (l:Language { name:language })
WITH l, movies
UNWIND movies AS m
WITH l, m
MERGE (m)-[:IN_LANGUAGE]->(l);

// after insert for become a new node, we should delete the value in the previous node
MATCH (m:Movie)
 SET m.languages = null

// producer
MATCH (n:Actor)-[r:ACTED_IN]->(m:Movie)
CALL apoc.
MERGE .relationship(n, 'ACTED_IN_' + left(m.released, 4), { }, m ) YIELD rel
RETURN COUNT(*) AS `Number of relationships merged`

MATCH (p:Person)-[:ACTED_IN_1995|DIRECTED_1995]-()
RETURN p.name AS `Actor or Director`

MATCH (n:Director)-[:DIRECTED]->(m:Movie)
CALL apoc.
MERGE .relationship(n,
'DIRECTED_' + left(m.released, 4),
{ },
{ },
m ,
{ }
) YIELD rel
RETURN count(*) AS `Number of relationships merged`;

MATCH (n:User)-[r:RATED]->(m:Movie)
CALL apoc.
MERGE .relationship(n, 'RATED_' + left(m.released, 4), { }, m ) YIELD rel
RETURN COUNT(*) AS `Number of relationships merged`

// Modify this query to use the -[:RATED]->()
// relationship to  create a new RATED_{rating}
// relationship between the :User and a :Movie
MATCH (n:User)-[:RATED]->(m:Movie)
CALL apoc.
MERGE .relationship(n,
'RATED_' + left(m.released, 4),
{ },
{ },
m ,
{ }
) YIELD rel
RETURN count(*) AS `Number of relationships merged`

// convert a property from string to list
MATCH (m:Movie)
 SET m.countries = split(coalesce(m.countries, ""), "|"),
m.languages = split(coalesce(m.languages, ""), "|"),
m.genres = split(coalesce(m.genres, ""), "|")

MATCH (m:Movie)
UNWIND m.genres AS genre
WITH m, genre
MERGE (g:Genre {name:genre})
MERGE (m)-[:IN_GENRE]->(g)