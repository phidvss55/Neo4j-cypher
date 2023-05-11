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
