MATCH (n)
WHERE ID(n) = 3
 SET n.age = 24, n.height = 2.02
RETURN n

MATCH (lebron)
WHERE ID(n) = 3
 SET lebron:REF
RETURN lebron

MATCH (lebron { name: "LeBron James" }) - [contract:PLAYS_FOR] -> (:TEAM)
 SET contract.salary = 60000000

MATCH (lebron)
WHERE ID(n) = 3
REMOVE lebron:REF
RETURN lebron

MATCH (lebron)
WHERE ID(n) = 3
REMOVE lebron.age
RETURN lebron

// set property for the relationship
MERGE (p:Person { name: 'Michael Caine' })
MERGE (m:Movie { title: 'Batman Begins' })
MERGE (p)-[:ACTED_IN { roles: ['Alfred Penny'] }]->(m)
RETURN p, m

//
MATCH (p:Person)-[r:ACTED_IN]->(m:Movie)
WHERE p.name = 'Michael Caine' AND m.title = 'The Dark Knight'
 SET r.roles = ['Alfred Penny'], r.year = 2008
RETURN p, r, m

// remove property
MATCH (p:Person)-[r:ACTED_IN]->(m:Movie)
WHERE p.name = 'Michael Caine' AND m.title = 'The Dark Knight'
REMOVE r.roles
RETURN p, r, m
