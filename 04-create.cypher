CREATE (lebron:PLAYER:COACH:GENERAL_MANAGER { name: "LeBron James", height: 2.01 })

CREATE (lebron:PLAYER:COACH:GENERAL_MANAGER { name: "LeBron James", height: 2.01 }) - [:PLAYS_FOR {salary: 40000000}] -> (:TEAM {name: "LA Lakers"})

CREATE (lebron:PLAYER:COACH:GENERAL_MANAGER { name: "LeBron James", height: 2.01 })
CREATE (:TEAM { name: "LA Lakers" })

MATCH (lebron:PLAYER { name: "LeBron James" }), (lakers:TEAM {name: "LA Lakers"})
CREATE (lebron) - [:PLAYS_FOR] -> (lakers)

// Merge processing
// Find or create a person with this name
MERGE (p:Person { name: 'McKenna Grace' })
// Only set the `createdAt` property if the node is created during this query
  ON CREATE SET p.createdAt = datetime()
// Only set the `updatedAt` property if the node was created previously
  ON MATCH SET p.updatedAt = datetime()
// Set the `born` property regardless
 SET p.born = 2006
RETURN p

// Create the relationship between two node
MATCH (apollo:Movie { title: 'Apollo 13' })
MATCH (tom:Person { name: 'Tom Hanks' })
MATCH (meg:Person { name: 'Meg Ryan' })
MATCH (danny:Person { name: 'Danny DeVito' })
MATCH (sleep:Movie { title: 'Sleepless in Seattle' })
MATCH (hoffa:Movie { title: 'Hoffa' })
MATCH (jack:Person { name: 'Jack Nicholson' })

// create the relationships between nodes
MERGE (tom)-[:ACTED_IN { role: 'Jim Lovell' }]->(apollo)
MERGE (tom)-[:ACTED_IN { role: 'Sam Baldwin' }]->(sleep)
MERGE (meg)-[:ACTED_IN { role: 'Annie Reed' }]->(sleep)
MERGE (danny)-[:ACTED_IN { role: 'Bobby Ciaro' }]->(hoffa)
MERGE (danny)-[:DIRECTED]->(hoffa)
MERGE (jack)-[:ACTED_IN { role: 'Jimmy Hoffa' }]->(hoffa)

// MATCH (a:Actor)-[:ACTED_IN]->(m:Movie)
// WITH a, m
// MERGE (r:ROLE {name: 'Role'})
// MERGE (a)-[:ACT_IN {role: r.name}]->(m)
// MERGE (a)-[:PLAYED {role: r.name}]->(r)
// MERGE (r)-[:IN_MOVIE {role: r.name}]->(m)
// return a,r,m

// final task
MATCH (a:Actor)-[ac:ACTED_IN]->(m:Movie)
WITH a, m, ac
MERGE (r:ROLE { name: ac.role })
MERGE (a)-[:PLAYED]->(r)
MERGE (r)-[:IN_MOVIE]->(m)
