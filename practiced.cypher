:auto
CALL {
    LOAD CSV WITH HEADERS FROM 'file:///movies.csv' AS row
    WITH row 
    WHERE toInteger(row.id) is not null
    MERGE (m:Movie {id: toInteger(row.id)})
    SET m += row {
        .overview,
        .imdb_id,
        .title,
        .poster_path,
        .backdrop_path,
        .original_title,
        .original_language,
        .tagline,
        .status,
        .homepage,
        runtime: toFloat(row.runtime),
        release_date: date(datetime({epochmillis: apoc.date.parse(row.release_date, "ms", "dd/MM/yyyy")})),
        revenue: toFloat(row.revenue),
        popularity: toFloat(row.popularity),
        average_vote: toFloat(row.vote_average),
        vote_count: toInteger(row.vote_count),
        budget: toInteger(row.budget)
    }

    FOREACH (_ IN CASE WHEN row.original_language IS NOT NULL THEN [1] ELSE [] END |
        MERGE (l:Language {id: row.original_language})  
        MERGE (m)-[:ORIGINAL_LANGUAGE]->(l)
    )

    FOREACH (_ IN CASE WHEN row.video = 'True' THEN [1] ELSE [] END | SET m:Video )
    FOREACH (_ IN CASE WHEN row.adult = 'True' THEN [1] ELSE [] END | SET m:Adult )

    FOREACH (language IN apoc.convert.fromJsonList(row.spoken_languages) |
        MERGE (l:Language {id: language.iso_639_1}) ON CREATE SET l.name = language.name
        MERGE (m)-[:SPOKEN_IN_LANGUAGE]->(l)
    )

    FOREACH (country IN apoc.convert.fromJsonList(row.production_countries) |
        MERGE (c:Country {id: country.iso_3166_1}) ON CREATE SET c.name = country.name
        MERGE (m)-[:PRODUCED_IN_COUNTRY]->(c)
    )

    FOREACH (genre IN apoc.convert.fromJsonList(row.genres) |
        MERGE (g:Genre {id: genre.id}) ON CREATE SET g.name = genre.name
        MERGE (m)-[:IN_GENRE]->(g)
    )

    FOREACH (company IN apoc.convert.fromJsonList(row.production_companies) |
        MERGE (c:ProductionCompany {id: company.id}) ON CREATE SET c.name = company.name
        MERGE (m)-[:PRODUCED_BY]->(c)
    )

    FOREACH (collection IN CASE WHEN apoc.convert.fromJsonMap(row.belongs_to_collection) IS NOT NULL THEN [apoc.convert.fromJsonMap(row.belongs_to_collection)] ELSE [] END |
        MERGE (c:Collection {id: collection.id}) ON CREATE SET c += collection
        MERGE (m)-[:IN_COLLECTION]->(c)
    )

}
