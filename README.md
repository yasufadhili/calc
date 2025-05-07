
# 🧮Calc – Expression Interpreter Console

**Calc** is a somewhat high-performance terminal-based expression interpreter written in **C11**, utilising **Flex** and **Bison** to deliver a powerful, extensible **REPL (Read-Eval-Print Loop)**. 

It offers an expressive and programmable interface for evaluating complex expressions, conversions, and utilities with Unix philosophy in mind.

---

## 📌 Features

### 🔧 Core Expression Engine
- Arithmetic: `+`, `-`, `*`, `/`, `%`, `**`
- Bitwise: `&`, `|`, `^`, `~`, `<<`, `>>`
- Logical: `&&`, `||`, `!`
- Comparison: `==`, `!=`, `<`, `>`, `<=`, `>=`
- Full operator precedence and associativity support
- Unary operations: `+`, `-`, `!`, `~`

### 🧠 Typed Evaluation
- **64-bit signed integers**
- Input in multiple bases: binary (`0b`), octal (`0o`), decimal, hexadecimal (`0x`)
- Type inference in outputs: `int64`, `char`, `utf8`, `string`

### 📚 Built-in Functions
- Conversion: `str()`, `hex()`, `bin()`, `oct()`, `chr()`, `ord()`
- Encoding: `ansi()`, `utf8()`, `unicode()`
- Maths: `abs()`, `min()`, `max()`, `gcd()`, `lcm()`, `fact()`, `mod()`, `divmod()`
- Bit utilities: `setbit()`, `clrbit()`, `togglebit()`, `isbit()`, `rol()`, `ror()`
- Type introspection: `type()`, `len()`, `dump()`

### 🖍 Terminal UX (Linux only)
- ANSI-colour formatted results and errors
- Emoji-enhanced output (✔ success, ✖ error, → result)
- Real-time parenthesis matching
- Syntax-highlighted REPL echo
- Custom themes via `:theme` or `CALC_THEME`

### 🛠 Meta Commands
- `:help`, `:exit`, `:vars`, `:functions`, `:doc`, `:save`, `:copy`, `:clear`
- `:precision`, `:debug`, `:ast`, `:tokens` for introspection

### 🖇 Shell Integration
- Shell piping and redirection
- Environment variable access: `env("USER")`
- Clipboard support via `xclip`
- Terminal-aware formatting (`:cols`, `:rows`)

### 🧾 Session Management
- Persistent command history (`~/.calc_history`)
- Named variables: `x = 42`
- Last result reference via `_`
- Mini macros and function aliases: `def double(x) = x * 2`

---

Developed with precision and flexibility in mind by [Yasu Fadhili](https://github.com/yasufadhili).

---

> ⚠️ Note: Currently optimised for **Linux** terminals. Partial support for Windows via MinGW is experimental.
