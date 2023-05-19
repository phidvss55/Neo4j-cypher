//clean up data
MATCH (u:User)
DETACH DELETE u;

// clean up all
MATCH (n)
DETACH DELETE n

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

// select person is actor and director and born between 1950 - 1960
MATCH (p:Person)
WHERE p:Acotr AND p:Director AND 1950 <= p.born.year < 1960
RETURN count(p.name)

// multiple pattern match clause
MATCH (a:Person)-[:ACTED_IN]->(m:Movie), (m)<-[:DIRECTED]-(d:Person)
WHERE m.year > 2000
RETURN a.name, m.title, d.name

// multiple but with single pattern
MATCH (a:Person)-[:ACTED_IN]->(m:Movie)<-[:DIRECTED]-(d:Person)
WHERE m.year > 2000
RETURN a.name, m.title, d.name

// optional matching rows
MATCH (m:Movie)
WHERE m.title = "Kiss Me Deadly"
MATCH (m)-[:IN_GENRE]->(g:Genre)<-[:IN_GENRE]-(rec:Movie)
MATCH (m)<-[:ACTED_IN]-(a:Actor)-[:ACTED_IN]->(rec)
RETURN rec.title, a.name

//
MATCH (m:Movie)
WHERE m.released IS NOT null
RETURN m.title AS title,
m.released AS releaseDate
 ORDER BY m.released DESC
LIMIT 100

// condition returning data
MATCH (m:Movie)<-[:ACTED_IN]-(p:Person)
WHERE p.name = 'Charlie Chaplin'
RETURN m.title AS movie,


CASE
 WHEN m.runtime < 120 THEN "Short"
 WHEN m.runtime >= 120 THEN "Long"
END AS runTime

// sort movie according to number of actors
MATCH (a:Actor)-[:ACTED_IN]->(m:Movie)
RETURN m.title AS movie,
collect(a.name) AS Actors,
size(collect(a.name)) AS num
 ORDER BY num desc

// get minutes between 2 datetimes
RETURN duration.between(x.datetime1, x.datetime2).minutes AS aasfsadf

// WITH
WITH 'toy story' AS mt, 'Tom Hanks' AS actorName
MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
WITH m, toLower(m.title) AS movieTitle
WHERE p.name = actorName
 AND movieTitle CONTAINS mt
RETURN m.title AS movies, movieTitle

// SUBQUERY WITH PARAMS
MATCH (m:Movie)
CALL {
  WITH m
  MATCH (m)<-[r:RATED]-(u:User)
  WHERE r.rating = 5
  RETURN count(u) AS numReviews
}
RETURN m.title, numReviews
 ORDER BY numReviews DESC

// UNION WITH SUB QUERY
MATCH (p:Person)
WITH p
LIMIT 100
CALL {
  WITH p
  OPTIONAL MATCH (p)-[:ACTED_IN]->(m:Movie)
  RETURN m.title + ": " + "Actor" AS work 
  UNION
  WITH p
  OPTIONAL MATCH (p)-[:DIRECTED]->(m:Movie)
  RETURN m.title+ ": " + "Director" AS work
}
RETURN p.name, collect(work)

// using profile to get hit
PROFILE
MATCH (a:Actor)
WHERE a.born.year >= 1980
// leave off the Movie label to get better performance
WITH a, [(a)-[:ACTED_IN]->(m)
WHERE 2000 <= m.year <= 2005 | m.title] AS Movies
WHERE size(Movies) > 0
RETURN a.name AS Actor, a.born AS Born, Movies

// count avatar time between release date and reviewd date
MATCH (u:User)-[r:RATED]-(m:Movie)
WHERE u.name = 'Angela Thompson'
WITH count(m) AS NumMovies, collect(duration.between(datetime({ epochseconds:r.timestamp }), date(m.released))) AS ReviewPeriods
UNWIND ReviewPeriods AS x
RETURN NumMovies, sum(x), sum(x)/NumMovies

// average test
MATCH (m:Movie)
WITH avg(m.imdbVotes) AS AverageVote
MATCH (m2:Movie)
WHERE m2.year = 2010 AND m2.imdbVotes > AverageVote
RETURN AverageVote AS OverallAverageVote, m2.title AS Title , m2.imdbVotes AS AverageVote

// average with between
MATCH (a:Actor)
WHERE
a.born IS NOT null
 AND a.name STARTS
WITH 'Tom'
WITH count(a) AS NumActors, collect(duration.between(date(a.born), date())) AS Ages
UNWIND Ages AS x
WITH NumActors, sum(x) AS TotalAges, avg(x) AS AverageAge
RETURN TotalAges, TotalAges/NumActors, AverageAge

// calculate the percentage
MATCH (m:Movie)
WHERE m.year = 2000
WITH count(*) AS totalMovies
MATCH ()-[r:RATED]-(m)
WHERE r.rating > 4 AND m.year = 2000
WITH count( DISTINCT m) AS goodMovies, totalMovies
RETURN goodMovies, totalMovies, round(toFloat(goodMovies) / toFloat(totalMovies) * 100) AS PercentGood
// round(toFloat(goodMovies) / toFloat(totalMovies) * 100) AS PercentGood

// determine percentage from a list
UNWIND [80, 10, 20, 30, 40, 50, 60, 70] AS x
RETURN percentileCont(x, .50)

// find movie that two actors acted_in the same
MATCH (p1:Person)-[:ACTED_IN]->(m1)
MATCH (m2)<-[:ACTED_IN]-(p2:Person)
WHERE p1.name = 'Tom Hanks'
 AND p2.name = 'Meg Ryan'
 AND m1 = m2
RETURN m1.title
