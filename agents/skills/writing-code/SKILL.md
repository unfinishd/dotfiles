---
name: writing-code
description: ALWAYS use this skill whenever you are writing any code. This contains important principles to always follow when writing code.
---

The examples might be in Haskell/Rust/Java/Ruby, but the principles apply to any language.

# Architecture

* Consider using DDD patterns when applicable
* Consider reusability of code -- extract common code into libraries or modules

# Types

Make invalid states unrepresentable. Example:
```haskell
-- GOOD
data Interval = Infinite | Fixed Int

-- BAD (Interval {ty = Infinite, val = Just 1} is invalid!)
data IntervalType = Infinite | Fixed
data Interval
    = Interval
    { ty :: IntervalType
    , val :: Maybe Int
    }
```

Always use strong types for as long as possible: parse/deserialize early, serialize as late as possible. Example: Use `Instant` over `String`/`Long` for timestamps in domain types.

Follow the "parse, don't validate" principle. Example:
```haskell
-- GOOD: convert intake to domain type early (note that "parsing" applies in general, not just for strings. can also "parse" complex data structures into other structures)
parseInterval :: String -> Maybe Interval
parseInterval "infinity" = Just Infinite
parseInterval s = case reads s of
    [(val, "")] -> Just (Fixed val)
    _ -> Nothing

-- BAD: this function, interval gets passed as String and continously validated in the codebase.
validateInterval :: String -> Bool
validateInterval "infinity" = True
validateInterval s = case reads s of
    [(val, "")] -> True
    _ -> False

```

# Function Preconditions

Express function preconditions in types and force the caller to provide them (rather than checking in callee):

```rust
// GOOD
fn frobnicate(walrus: Walrus) {
    ...
}

// BAD
fn frobnicate(walrus: Option<Walrus>) {
    let walrus = match walrus {
        Some(it) => it,
        None => return,
    };
    ...
}
```

**Rationale:** this makes control flow explicit at the call site.
Call-site has more context, it often happens that the precondition falls out naturally or can be bubbled up higher in the stack.

Avoid splitting precondition check and precondition use across functions:

```rust
// GOOD
fn main() {
    let s: &str = ...;
    if let Some(contents) = string_literal_contents(s) {

    }
}

fn string_literal_contents(s: &str) -> Option<&str> {
    if s.starts_with('"') && s.ends_with('"') {
        Some(&s[1..s.len() - 1])
    } else {
        None
    }
}

// BAD
fn main() {
    let s: &str = ...;
    if is_string_literal(s) {
        let contents = &s[1..s.len() - 1];
    }
}

fn is_string_literal(s: &str) -> bool {
    s.starts_with('"') && s.ends_with('"')
}
```

In the "Bad" version, the precondition that `1` and `s.len() - 1` are valid string literal boundaries is checked in `is_string_literal` but used in `main`.
In the "Good" version, the precondition check and usage are checked in the same block, and then encoded in the types.

**Rationale:** non-local code properties degrade under change.

# Control Flow

As a special case of the previous rule, do not hide control flow inside functions, push it to the caller:

```rust
// GOOD
if cond {
    f()
}

// BAD
fn f() {
    if !cond {
        return;
    }
    ...
}
```

# Functions with many parameters

Avoid creating functions with many optional or boolean parameters.
Introduce a new type to carry them instead. When working within DDD, consider making a domain type with corresponding operations on them instead.

```rust
// GOOD
pub struct AnnotationConfig {
    pub binary_target: bool,
    pub annotate_runnables: bool,
    pub annotate_impls: bool,
}

pub fn annotations(
    db: &RootDatabase,
    file_id: FileId,
    config: AnnotationConfig
) -> Vec<Annotation> {
    ...
}

// MAYBE GOOD
pub struct Annotation {
    pub name: String,
    pub case_sensitive: bool,
}

impl Annotation {
    pub fn all(self) -> Vec<Item> { ... }
    pub fn first(self) -> Option<Item> { ... }
}

// BAD
pub fn annotations(
    db: &RootDatabase,
    file_id: FileId,
    binary_target: bool,
    annotate_runnables: bool,
    annotate_impls: bool,
) -> Vec<Annotation> {
    ...
}
```

**Rationale:** reducing churn. If the function has many parameters, they most likely change frequently. By packing them into a struct we protect all intermediary functions from changes.

# Prefer Separate Functions Over Parameters

If a function has a `bool` or an `Option` parameter, and it is always called with `true`, `false`, `Some` and `None` literals, split the function in two.

```rust
// GOOD
fn caller_a() {
    foo()
}

fn caller_b() {
    foo_with_bar(Bar::new())
}

fn foo() { ... }
fn foo_with_bar(bar: Bar) { ... }

// BAD
fn caller_a() {
    foo(None)
}

fn caller_b() {
    foo(Some(Bar::new()))
}

fn foo(bar: Option<Bar>) { ... }
```

**Rationale:** more often than not, such functions display "false sharing" -- they have additional `if` branching inside for two different cases.
Splitting the two different control flows into two functions simplifies each path, and remove cross-dependencies between the two paths.
If there's common code between `foo` and `foo_with_bar`, extract *that* into a common helper.

# Early Returns

Do use early returns

```rust
// GOOD
fn foo() -> Option<Bar> {
    if !condition() {
        return None;
    }

    Some(...)
}

// BAD
fn foo() -> Option<Bar> {
    if condition() {
        Some(...)
    } else {
        None
    }
}
```

**Rationale:** reduce cognitive stack usage.

# Error handling

Prefer explicit `Result` types over throwing. Use `return Err(err)` to return an error.

# Helper methods

Only introduce helper methods if they are either used in multiple places, or complex enough to warrant it. But when they get complex, consider extracting them into a separate class (e.g. see domain driven design (DDD) for examples on application services, domain services and domain types).

# Code smells to avoid

If you end up naming a method `maybe_create_and_save_draft_invoice`, you are probably doing something wrong: this method is doing too much (create and save), and the "maybe" is clear from the signature of the method (returns e.g. `Result<Option<DraftInvoice>, Error>`).
