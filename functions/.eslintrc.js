module.exports = {
  root: true,
  env: {
    es6: true,
    node: true,
  },
  extends: [
    "eslint:recommended",
    "google",
  ],
  rules: {
    "require-jsdoc": 0,
    "max-len": ["error", {"code": 200}],
    "quotes": ["error", "double"],
    "brace-style": ["error", "allman", {"allowSingleLine": true}],
    "space-before-function-paren": ["error", {
      "anonymous": "always",
      "named": "never",
      "asyncArrow": "always",
    }],
  },
  parserOptions: {
    "ecmaVersion": 2020,
  },
};
