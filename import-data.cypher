// import movie
LOAD CSV WITH HEADERS FROM 'https: //data.neo4j.com/importing/2-movieData.csv' AS row FIELDTERMINATOR ','
CREATE (n:Node { property1: row.field1, property2: row.field2 })

//process only Movie rows
WITH row
WHERE row.Entity = "Movie"
RETURN
toInteger(row.tmdbId),
toInteger(row.imdbId),
toInteger(row.movieId),
toFloat(row.imdbRating),
row.released,
row.title,
toInteger(row.year),
row.poster,
toInteger(row.runtime),
split(coalesce(row.countries, ""), "|"),
toInteger(row.imdbVotes),
toInteger(row.revenue),
row.plot,
row.url,
toInteger(row.budget),
split(coalesce(row.languages, ""), "|"),
split(coalesce(row.genres, ""), "|")
LIMIT 10

// import Movie
CALL {
  LOAD CSV WITH HEADERS
  FROM 'https: //data.neo4j.com/importing/2-movieData.csv' AS row
  WITH row 
  WHERE row.Entity = "Movie"
  MERGE (m:Movie { movieId: toInteger(row.movieId) }) 
  ON CREATE SET
    m.tmdbId = toInteger(row.tmdbId),
    m.imdbId = toInteger(row.imdbId),
    m.imdbRating = toFloat(row.imdbRating),
    m.released = datetime(row.released),
    m.title = row.title,
    m.year = toInteger(row.year),
    m.poster = row.poster,
    m.runtime = toInteger(row.runtime),
    m.countries = split(coalesce(row.countries, ""), "|"),
    m.imdbVotes = toInteger(row.imdbVotes),
    m.revenue = toInteger(row.revenue),
    m.plot = row.plot,
    m.url = row.url,
    m.budget = toInteger(row.budget),
    m.languages = split(coalesce(row.languages, ""), "|")
  WITH m, split(coalesce(row.genres, ""), "|") AS genres
  UNWIND genres AS genre
  WITH m, genre
  MERGE (g:Genre { name:genre })
  MERGE (m)-[:IN_GENRE]->(g)
}

// import person
LOAD CSV WITH HEADERS FROM 'https: //data.neo4j.com/importing/2-movieData.csv' AS row
WITH row 
WHERE row.Entity = "Person"
RETURN
  toInteger(row.tmdbId),
  toInteger(row.imdbId),
  row.bornIn,
  row.name,
  row.bio,
  row.poster,
  row.url

CASE row.born WHEN "" THEN null ELSE datetime(row.born) END
CASE row.died WHEN "" THEN null ELSE datetime(row.died) END

// second way import movie
CALL {
  LOAD CSV
  WITH HEADERS
  FROM 'https: //data.neo4j.com/importing/2-movieData.csv'
   AS row
  WITH row
  WHERE row.Entity = "Person"
  MERGE (p:Person { tmdbId: toInteger(row.tmdbId) })
    ON CREATE SET
  p.imdbId = toInteger(row.imdbId),
  p.bornIn = row.bornIn,
  p.name = row.name,
  p.bio = row.bio,
  p.poster = row.poster,
  p.url = row.url,
  p.born =
  
  
// import relationship
LOAD CSV WITH HEADERS
FROM 'https: //data.neo4j.com/importing/2-movieData.csv' AS row
WITH row
WHERE row.Entity = "Join" AND row.Work = "Acting"
RETURN toInteger(row.tmdbId), toInteger(row.movieId), row.role
LIMIT 10

// make through 23 moviedata file to credate Acted_in relationshiip
CALL {
  LOAD CSV WITH HEADERS
  FROM 'https: //data.neo4j.com/importing/2-movieData.csv' AS row
  WITH row
  WHERE row.Entity = "Join" AND row.Work = "Acting"
  MATCH (p:Person { tmdbId: toInteger(row.tmdbId) })
  MATCH (m:Movie { movieId: toInteger(row.movieId) })
  MERGE (p)-[r:ACTED_IN]->(m)
    ON CREATE
   SET r.role = row.role
   SET p:Actor
}

// import directed relationship
LOAD CSV WITH HEADERS
FROM 'https: //data.neo4j.com/importing/2-movieData.csv' AS row
WITH row
WHERE row.Entity = "Join" AND row.Work = "Directing"
RETURN
toInteger(row.tmdbId),
toInteger(row.movieId),
row.role
LIMIT 10

// add director label to person node
CALL {
  LOAD CSV WITH HEADERS
  FROM 'https: //data.neo4j.com/importing/2-movieData.csv' AS row
  WITH row
  WHERE row.Entity = "Join" AND row.Work = "Directing"
  MATCH (p:Person { tmdbId: toInteger(row.tmdbId) })
  MATCH (m:Movie { movieId: toInteger(row.movieId) })
  MERGE (p)-[r:DIRECTED]->(m)
    ON CREATE
   SET r.role = row.role
   SET p:Director
}

// create rated relationship
CALL {
  LOAD CSV WITH HEADERS
  FROM 'https: //data.neo4j.com/importing/2-ratingData.csv' AS row
  MATCH (m:Movie { movieId: toInteger(row.movieId) })
  MERGE (u:User { userId: toInteger(row.userId) })
    ON CREATE SET u.name = row.name
  MERGE (u)-[r:RATED]->(m)
    ON CREATE SET r.rating = toInteger(row.rating),
  r.timestamp = toInteger(row.timestamp)
}

// HOW MANY UNIQUE GENRES ARE REPRESENTED IN THESE TOP
MATCH (n:Movie)
WHERE n.imdbRating IS NOT null AND n.poster IS NOT null
WITH n {
  genres: [ (n)-[:IN_GENRE]->(g) | g { .name }]
}
 ORDER BY n.imdbRating DESC
LIMIT 4
RETURN size(apoc.coll.toSet(apoc.coll.flatten(collect(n.genres)))) AS uniqueGenreCount

// RETURN
MATCH (:Movie { title: 'Toy Story' })-[:IN_GENRE]->(g:Genre)<-[:IN_GENRE]-(m)
WHERE m.imdbRating IS NOT null
WITH g.name AS genre,
count(m) AS moviesInCommon,
sum(m.imdbRating) AS total
RETURN genre, moviesInCommon,
total/moviesInCommon AS score
 ORDER BY score DESC

// movie acted by tom hank and have average rate over 4
WITH 'Tom Hanks' AS theActor
MATCH (p:Person)-[:ACTED_IN]->(m:Movie)<-[r:RATED]-(:User)
WHERE p.name = theActor
WITH m, AVG(r.rating) AS avgRating
WHERE avgRating > 4
RETURN m.title AS Movie, avgRating AS `AverageRating`
 ORDER BY avgRating DESC

// import large csv file
LOAD CSV WITH HEADERS
FROM 'https: //xxx.com/xxx/large-file.csv' AS row
CALL {
  WITH row
  // ...
} IN TRANSACTIONS

LOAD CSV WITH HEADERS FROM 'https://data.neo4j.com/importing/MovieDataUnclean.csv' AS row FIELDTERMINATOR ','
WITH
  row.title AS Title,
  row.languages AS Field,
  split(row.languages,"|") AS FieldList
RETURN Title, Field, FieldList LIMIT 10