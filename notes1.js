const TokenType = {
  LABEL: "LABEL",
  OPCODE: "OPCODE",
  DIRECTIVE: "DIRECTIVE",
  OPERAND: "OPERAND",
  COMMENT: "COMMENT",
  NEWLINE: "NEWLINE",
  END: "END",
  LPAREN: "LPAREN", // (
  RPAREN: "RPAREN", // )
  COMMA: "COMMA", // ,
};

const isWhitespace = (char) => /\s/.test(char);
const isDigit = (char) => /[0-9]/.test(char);
const isHexDigit = (char) => /[0-9a-fA-F]/.test(char);
const isAlphaNumeric = (char) => /[a-zA-Z0-9_]/.test(char);

const tokenizer = (input) => {
  let index = 0;
  const tokens = [];
  let currentToken = null;

  const pushToken = (type, value) => {
    tokens.push({ type, value });
  };

  const nextChar = () => {
    return input[index++];
  };

  const pushbackChar = () => {
    index--;
  };

  const skipWhitespace = () => {
    let char = input[index];
    while (char && isWhitespace(char)) {
      index++;
      char = input[index];
    }
  };

  const tokenize = () => {
    let char = nextChar();
    while (char !== undefined) {
      if (isWhitespace(char)) {
        skipWhitespace();
      } else if (char === ";") {
        // Comment
        while (char && char !== "\n" && char !== null) {
          char = nextChar();
        }
        if (char === "\n") {
          pushToken(TokenType.COMMENT, ";");
        }
      } else if (char === "\n") {
        // Newline
        pushToken(TokenType.NEWLINE, "\n");
      } else if (char === ":") {
        // Label
        pushToken(TokenType.LABEL, ":");
      } else if (isDigit(char)) {
        // Number or hexadecimal number
        let value = char;
        char = nextChar();
        if (value === "0" && char === "x") {
          value += char;
          char = nextChar();
          while (char && isHexDigit(char)) {
            value += char;
            char = nextChar();
          }
          pushToken(TokenType.OPERAND, value);
        } else {
          while (char && isDigit(char)) {
            value += char;
            char = nextChar();
          }
          pushbackChar();
          pushToken(TokenType.OPERAND, value);
        }
      } else if (isAlphaNumeric(char)) {
        // Identifier, opcode, or directive
        let value = char;
        char = nextChar();
        while (char && isAlphaNumeric(char)) {
          value += char;
          char = nextChar();
        }
        pushbackChar();
        if (value === ".org" || value === ".db" || value === ".set") {
          pushToken(TokenType.DIRECTIVE, value);
        } else {
          pushToken(TokenType.OPCODE, value);
        }
      } else if (char === "(") {
        pushToken(TokenType.LPAREN, "(");
      } else if (char === ")") {
        pushToken(TokenType.RPAREN, ")");
      } else if (char === ",") {
        pushToken(TokenType.COMMA, ",");
      } else {
        // Unknown character
        char = nextChar();
      }

      char = nextChar();
    }

    // End of input
    pushToken(TokenType.END, "");
  };

  tokenize();

  let tokenIndex = 0;
  const nextToken = () => {
    if (tokenIndex < tokens.length) {
      return tokens[tokenIndex++];
    } else {
      return { type: TokenType.END, value: "" };
    }
  };

  const pushbackToken = () => {
    tokenIndex--;
  };

  return { nextToken, pushbackToken };
};

const parseOperands = () => {
  let operands = [];

  let currentToken = nextToken();
  if (currentToken.type === TokenType.LPAREN) {
    // Parse memory location
    let memoryLocation = currentToken.value;
    currentToken = nextToken();
    while (currentToken.type !== TokenType.RPAREN) {
      operands.push(currentToken.value);
      currentToken = nextToken();
      if (currentToken.type === TokenType.RPAREN) {
        memoryLocation += operands.join("");
        memoryLocation += currentToken.value;
        operands = [memoryLocation];
        currentToken = nextToken();
        break;
      }
    }
  } else {
    operands.push(currentToken.value);
    currentToken = nextToken();
    if (currentToken.type === TokenType.COMMA) {
      // Skip the comma token if it exists
      currentToken = nextToken();
    }
    if (currentToken.type === TokenType.OPERAND) {
      operands.push(currentToken.value);
    } else {
      pushbackToken();
    }
  }

  return operands;
};

const parseInstruction = () => {
  let currentToken = nextToken();
  if (currentToken.type === TokenType.OPCODE) {
    const operands = parseOperands();
    // Handle operands as needed
  } else {
    pushbackToken();
  }
};

const parseDirective = () => {
  let currentToken = nextToken();
  if (currentToken.type === TokenType.DIRECTIVE) {
    const operands = parseOperands();
    // Handle operands as needed
  } else {
    pushbackToken();
  }
};

const parseLabelStatement = () => {
  let currentToken = nextToken();
  if (currentToken.type === TokenType.LABEL) {
    const label = currentToken.value;
    currentToken = nextToken();
    if (currentToken.type === TokenType.OPCODE) {
      parseInstruction();
      // Handle instruction with label
    } else if (currentToken.type === TokenType.DIRECTIVE) {
      parseDirective();
      // Handle directive with label
    } else {
      pushbackToken();
      // Handle label alone
    }
  } else {
    pushbackToken();
  }
};

const parseStatement = () => {
  let currentToken = nextToken();
  switch (currentToken.type) {
    case TokenType.END:
      break;
    case TokenType.LABEL:
      parseLabelStatement();
      break;
    case TokenType.OPCODE:
      parseInstruction();
      break;
    case TokenType.DIRECTIVE:
      parseDirective();
      break;
    case TokenType.COMMENT:
    case TokenType.NEWLINE:
      break; // Skip comments and newlines
    default:
      pushbackToken();
      break;
  }
};

const parseProgram = () => {
  while (true) {
    parseStatement();
    let currentToken = nextToken();
    if (currentToken.type === TokenType.END) break;
  }
};
