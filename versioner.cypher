// init
CALL graph.versioner.init('Printer', { uuid: 'abcd', name: 'Mark', ip: '124.1.1.1'}, {status: 'Ready'}, 'Ready')
YIELD node RETURN node

// sending our first job to our printer
MATCH (p:Printer {uuid: 'abcd'})
WITH p
CALL graph.versioner.update(p, { status: 'Printing', job: 1, fileUrl: 'http://file-path', template: 'postcard' }, 'Printing' )
YIELD node RETURN node