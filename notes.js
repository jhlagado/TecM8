/* 

<program> ::= <statement_list>

<statement_list> ::= <statement> <newline> <statement_list> | <statement> <newline>

<statement> ::= <instruction_statement> | <directive_statement> | <conditional_directive> | <empty>

<instruction_statement> ::= <label>? <instruction>? <comment>?

<directive_statement> ::= <label>? <directive> <comment>?

<conditional_directive> ::= <if_directive> | <else_directive>

<if_directive> ::= ".if" <statement_list> ".endif"

<else_directive> ::= ".else" <statement_list> ".endif"

<label> ::= <identifier>

<directive> ::= <set_directive> | <org_directive> | <db_directive>

<instruction> ::= <opcode> | <opcode> <operand> | <opcode> <operand> "," <operand>

<operand> ::= <register> | <register_pair> | <memory_location> | <expression>

<register> ::= "A" | "B" | "C" | "D" | "E" | "H" | "L"

<register_pair> ::= "AF" | "BC" | "DE" | "HL" | "SP" | "IX" | "IY"

<memory_location> ::= "(" <register_pair> ")" | "(" <expression> ")"

<expression> ::= <term> | <term> "+" <expression> | <term> "-" <expression>

<term> ::= <factor> | <factor> "*" <term> | <factor> "/" <term>

<factor> ::= <number> | <hex_number> | <identifier> | "(" <expression> ")"

<number> ::= <digit>+

<hex_number> ::= "$" <hex_digit>+

<opcode> ::= "ADD" | "SUB" | "LD" | "JP" | "JR" | "CALL" | "RET" | "NOP" | "INC" | "DEC" | "AND" | "OR" | "XOR" | "CP"

<set_directive> ::= ".set" <identifier> "=" <expression>

<org_directive> ::= ".org" <expression>

<db_directive> ::= ".db" <expression_list>

<expression_list> ::= <expression> | <expression> "," <expression_list>

<comment> ::= ";" <any_character>*

<newline> ::= '\n' 

*/


const TokenType = {
    LABEL: 'LABEL',
    OPCODE: 'OPCODE',
    OPERAND: 'OPERAND',
    DIRECTIVE: 'DIRECTIVE',
    COMMENT: 'COMMENT',
    NEWLINE: 'NEWLINE',
    END: 'END',
    INVALID: 'INVALID'
};

const opcodes = {
    "ADD": true, "SUB": true, "LD": true, "JP": true, "JR": true, "CALL": true, "RET": true, "NOP": true, "INC": true, "DEC": true, "AND": true, "OR": true, "XOR": true, "CP": true
};

const directives = {
    ".org": true, ".set": true, ".db": true, ".if": true, ".else": true, ".endif": true
};

const registers = ["A", "B", "C", "D", "E", "H", "L", "(HL)", "BC", "DE", "HL", "SP", "IX", "IY"];

const isWhitespace = char => /\s/.test(char);
const isNewline = char => char === '\n';
const isDigit = char => /\d/.test(char);
const isHexDigit = char => /[0-9A-Fa-f]/.test(char);
const isLetter = char => /[a-zA-Z_]/.test(char);
const isIdentifierChar = char => /[a-zA-Z0-9_]/.test(char);
const isOperator = char => /[+\-*/()]/.test(char);

const nextChar = (state) => {
    state.index++;
    state.currentChar = state.index < state.input.length ? state.input[state.index] : null;
    return state;
};

const skipWhitespace = (state) => {
    while (isWhitespace(state.currentChar) && !isNewline(state.currentChar)) {
        state = nextChar(state);
    }
    return state;
};

const createToken = (type, value) => ({ type, value });

const tokenizer = (input) => {
    let state = { input, index: 0, currentChar: input[0] };
    let pushbackToken = null;

    return () => {
        if (pushbackToken) {
            const token = pushbackToken;
            pushbackToken = null;
            return token;
        }

        state = skipWhitespace(state);

        if (state.currentChar === null) {
            return createToken(TokenType.END, null);
        }

        if (isNewline(state.currentChar)) {
            state = nextChar(state);
            return createToken(TokenType.NEWLINE, '\n');
        }

        if (isLetter(state.currentChar)) {
            const startIdx = state.index;
            while (isIdentifierChar(state.currentChar)) {
                state = nextChar(state);
            }
            const identifierStr = state.input.slice(startIdx, state.index);
            if (opcodes[identifierStr.toUpperCase()]) {
                return createToken(TokenType.OPCODE, identifierStr.toUpperCase());
            } else if (directives[identifierStr.toLowerCase()]) {
                return createToken(TokenType.DIRECTIVE, identifierStr.toLowerCase());
            } else {
                return createToken(TokenType.LABEL, identifierStr);
            }
        }

        if (state.currentChar === '$') {
            const hexStart = state.index;
            state = nextChar(state);
            while (isHexDigit(state.currentChar)) {
                state = nextChar(state);
            }
            const hexStr = state.input.slice(hexStart, state.index);
            return createToken(TokenType.OPERAND, hexStr);
        }

        if (isDigit(state.currentChar)) {
            const numberStart = state.index;
            while (isDigit(state.currentChar)) {
                state = nextChar(state);
            }
            const numberStr = state.input.slice(numberStart, state.index);
            return createToken(TokenType.OPERAND, numberStr);
        }

        if (state.currentChar === ';') {
            const commentStart = state.index;
            while (state.currentChar !== '\n' && state.currentChar !== null) {
                state = nextChar(state);
            }
            const commentStr = state.input.slice(commentStart, state.index);
            return createToken(TokenType.COMMENT, commentStr);
        }

        if (isOperator(state.currentChar)) {
            const operator = state.currentChar;
            state = nextChar(state);
            return createToken(TokenType.OPERAND, operator);
        }

        return createToken(TokenType.INVALID, state.currentChar);
    };
};

const pushbackToken = (state, token) => {
    state.pushbackToken = token;
};

const createTokenizerState = (input) => {
    return {
        input,
        index: 0,
        currentChar: input[0],
        pushbackToken: null
    };
};

const getToken = (state) => {
    if (state.pushbackToken) {
        const token = state.pushbackToken;
        state.pushbackToken = null;
        return token;
    }

    state = skipWhitespace(state);

    if (state.currentChar === null) {
        return createToken(TokenType.END, null);
    }

    if (isNewline(state.currentChar)) {
        state = nextChar(state);
        return createToken(TokenType.NEWLINE, '\n');
    }

    if (isLetter(state.currentChar)) {
        const startIdx = state.index;
        while (isIdentifierChar(state.currentChar)) {
            state = nextChar(state);
        }
        const identifierStr = state.input.slice(startIdx, state.index);
        if (opcodes[identifierStr.toUpperCase()]) {
            return createToken(TokenType.OPCODE, identifierStr.toUpperCase());
        } else if (directives[identifierStr.toLowerCase()]) {
            return createToken(TokenType.DIRECTIVE, identifierStr.toLowerCase());
        } else {
            return createToken(TokenType.LABEL, identifierStr);
        }
    }

    if (state.currentChar === '$') {
        const hexStart = state.index;
        state = nextChar(state);
        while (isHexDigit(state.currentChar)) {
            state = nextChar(state);
        }
        const hexStr = state.input.slice(hexStart, state.index);
        return createToken(TokenType.OPERAND, hexStr);
    }

    if (isDigit(state.currentChar)) {
        const numberStart = state.index;
        while (isDigit(state.currentChar)) {
            state = nextChar(state);
        }
        const numberStr = state.input.slice(numberStart, state.index);
        return createToken(TokenType.OPERAND, numberStr);
    }

    if (state.currentChar === ';') {
        const commentStart = state.index;
        while (state.currentChar !== '\n' && state.currentChar !== null) {
            state = nextChar(state);
        }
        const commentStr = state.input.slice(commentStart, state.index);
        return createToken(TokenType.COMMENT, commentStr);
    }

    if (isOperator(state.currentChar)) {
        const operator = state.currentChar;
        state = nextChar(state);
        return createToken(TokenType.OPERAND, operator);
    }

    return createToken(TokenType.INVALID, state.currentChar);
};

// ==============================================================================================


const parseProgram = (input) => {
    const state = createTokenizerState(input);
    
    const nextToken = () => getToken(state);
    const pushbackToken = (token) => { state.pushbackToken = token; };
    
    const parseStatementList = () => {
        const statements = [];
        while (true) {
            const statement = parseStatement();
            if (!statement) break;
            statements.push(statement);
        }
        return statements;
    };

    const parseStatement = () => {
        let token = nextToken();
        if (token.type === TokenType.END) return null;

        if (token.type === TokenType.LABEL) {
            const label = token.value;
            token = nextToken();
            if (token.type === TokenType.OPCODE) {
                const instruction = parseInstruction(token);
                return { type: 'Instruction', label, ...instruction };
            } else if (token.type === TokenType.DIRECTIVE) {
                const directive = parseDirective(token);
                return { type: 'Directive', label, ...directive };
            } else {
                pushbackToken(token);
                return { type: 'Label', label };
            }
        } else if (token.type === TokenType.OPCODE) {
            return parseInstruction(token);
        } else if (token.type === TokenType.DIRECTIVE) {
            return parseDirective(token);
        } else if (token.type === TokenType.COMMENT) {
            return parseStatement(); // Skip comments
        }

        return null;
    };

    const parseInstruction = (opcodeToken) => {
        const operands = parseOperands();
        return { opcode: opcodeToken.value, operands };
    };

    const parseDirective = (directiveToken) => {
        const operands = parseOperands();
        return { directive: directiveToken.value, operands };
    };

    const parseOperands = () => {
        const operands = [];
        while (true) {
            const token = nextToken();
            if (token.type === TokenType.NEWLINE || token.type === TokenType.END) {
                pushbackToken(token);
                break;
            } else if (token.type === TokenType.OPERAND) {
                operands.push(token.value);
            } else {
                pushbackToken(token);
                break;
            }
        }
        return operands;
    };

    return parseStatementList();
};
