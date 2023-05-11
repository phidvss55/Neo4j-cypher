// Deleting a Node (Not going to work)
MATCH (ja { name: "Ja Morant" })
DELETE ja

// Delete node and relationships
MATCH (ja { name: "Ja Morant" })
DETACH DELETE ja

// Delete relationship
MATCH (joel { name: "Joel Embiid" }) - [rel:PLAYS_FOR] -> (:TEAM)
DELETE rel

// DELETE RELATIONSHIP
MATCH (m:Movie { title: 'The Matrix' })
MERGE (p:Person { name: 'Jane Doe' })
MERGE (p)-[:ACTED_IN]->(m)
RETURN p, m

// delete a label
MERGE (p:Person { name: 'Jane Doe' })
RETURN p

// add new label to this node
MATCH (p:Person { name: 'Jane Doe' })
 SET p:Developer
RETURN p

// newly-added
MATCH (p:Person { name: 'Jane Doe' })
REMOVE p:Developer
RETURN p
