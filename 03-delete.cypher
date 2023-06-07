// Deleting a Node (Not going to work)
MATCH (ja { name: "Ja Morant" })
DELETE ja

// Delete node and relationships
MATCH (ja { name: "Ja Morant" })
DETACH DELETE ja

// Delete relationship
MATCH (joel { name: "Joel Embiid" }) - [rel:PLAYS_FOR] -> (:TEAM)
DELETE rel

// REMOTE PROPERTY
MATCH (m:Movie) SET m.genres = null

// delete a label
MERGE (p:Person { name: 'Jane Doe' })
RETURN p

// add new label to this node
MATCH (p:Person { name: 'Jane Doe' })
 SET p:Developer
RETURN p
