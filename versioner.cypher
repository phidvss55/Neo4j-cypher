// init
CALL graph.versioner.init('Printer', { uuid: 'abcd', name: 'Mark', ip: '124.1.1.1'}, {status: 'Ready'}, 'Ready')
YIELD node RETURN node

// sending our first job to our printer
MATCH (p:Printer {uuid: 'abcd'})
WITH p
CALL graph.versioner.update(p, { status: 'Printing', job: 1, fileUrl: 'http://file-path', template: 'postcard' }, 'Printing' )
YIELD node RETURN node

// an error has occurred 
MATCH (p:Printer {uuid: 'abcd'})
WITH p
CALL graph.versioner.update(p, { status: 'Error', job: 1, fileUrl: 'http://file-path', template: 'postcard', context: 'Cannot apply the given template to the given file' }, 'Error' )
YIELD node RETURN node

// what's going wrong 
MATCH (p:Printer)
WITH p
CALL graph.versioner.get.by.label(p, 'Error')
YIELD node RETURN node

// when was everything good
MATCH (p:Printer)
WITH p
CALL graph.versioner.get.by.label(p, 'Ready')
YIELD node RETURN node

// rollback needed
MATCH (p:Printer {uuid: 'abcd'})-[:HAS_STATE]->(s:Ready)
WHERE id(s) = ?
WITH p, s
CALL graph.versioner.rollback.to(p, s)
YIELD node RETURN node

// let's go back to work
MATCH (p:Printer {uuid: 'abcd'})
WITH p
CALL graph.versioner.update(p, { status: 'Printing', job: 1, fileUrl: 'http://file-path', template: 'poster' }, 'Printing' )
YIELD node RETURN node

// everything done
MATCH (p:Printer {uuid: 'abcd'})
WITH p
CALL graph.versioner.update(p, { status: 'Printed', job: 1, fileUrl: 'http://file-path', template: 'poster' }, 'Printed' )
YIELD node RETURN node

// ready to print something else
MATCH (p:Printer {uuid: 'abcd'})
WITH p
CALL graph.versioner.update(p, { status: 'Ready' }, 'Ready' )
YIELD node RETURN node

-----------------------------------------------------------------------------------------------
// With database
// CALL sql.versioner.init('postgres', 'localhost', 5432, 'research_test', 'postgres', '12345678') YIELD node return node

//CALL sql.versioner.reload('postgres', 5432, 'postgres', '12345678') YIELD node return node