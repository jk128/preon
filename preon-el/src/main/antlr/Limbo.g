grammar Limbo;

options {
output=AST;
backtrack=true;
}

tokens {
    REFERENCE;
    PROP;
    INDEX;
}

@header {
package org.codehaus.preon.el;
}

@lexer::header {
package org.codehaus.preon.el;
}

relationalOp
	:	('<=' | '>=' | '<' | '>' | '==' )
	;

condExpression
	:   relationalExpression (('&&'|'||')^ relationalExpression)*;

relationalExpression
	:	additiveExpression (relationalOp^ additiveExpression)?
	|	booleanLiteral
	|   '('! condExpression ')'!
	;

booleanLiteral
	:	'true'
	|	'false'
	;

additiveExpression
	: 	multiplicativeExpression(('+'|'-')^ multiplicativeExpression)*
	;

multiplicativeExpression
	: 	powExpression (('*'|'/')^ powExpression)*
	;

powExpression
	: unaryExpression ('^'^ powExpression)?
	;

unaryExpression
 	: 	number
	| 	reference
	| 	'('! additiveExpression ')'!
	|   string
	;

reference 
	:	ID selector* -> ^(REFERENCE ID selector*)
	;

selector
    :   '.' ID -> ^(PROP ID)
    |   '[' additiveExpression ']' -> ^(INDEX additiveExpression)
    ;

	
number
    :	INT
    |   BININT
    |   HEXINT;
    
string
    :   STRING;

ID 	: ('a'..'z'|'A'..'Z')('a'..'z'|'A'..'Z'|'0'..'9'|'_')* ;
BININT : '0' 'b' ('0' | '1')+;
HEXINT : '0' 'x' ('0'..'7'|'a'..'f'|'A'..'F')+;
INT 	: '0'..'9'+ ;
WS : ( ' ' | '\t' | '\r' | '\n' )+ { $channel = HIDDEN; } ;
STRING : '\''! ~('\'')* '\''!;
