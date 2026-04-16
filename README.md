# **Pagex**


[![Hex.pm](https://img.shields.io/hexpm/v/pagex.svg)](https://hex.pm/packages/pagex)
[![Documentation](https://img.shields.io/badge/docs-hexdocs-blue.svg)](https://hexdocs.pm/pagex)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Fast, minimal, production-ready pagination for Ecto and Phoenix.

Inspired by Pagy (Ruby) — designed specifically for the Elixir/Phoenix ecosystem.

---

## **Why Pagex?**
 
| | Pagex | Scrivener | Paginator |
|---|---|---|---|
| Offset pagination | ✅ | ✅ | ✅ |
| Cursor pagination | ✅ | ❌ | ✅ |
| LiveView helpers | ✅ | ❌ | ❌ |
| JSON API support | ✅ | Partial | Partial |
| No macros/DSLs | ✅ | ❌ | ❌ |
| Max page size guard | ✅ | ❌ | ❌ |
| Optional count query | ✅ | ❌ | ❌ |
 
Pagex takes the approach of **explicit, small functions** over magic. No `use Pagex` in your schema, no global config macros, no schema introspection.

--- 

# **Installation**
 
```elixir
# mix.exs
def deps do
  [
    {:pagex, "~> 0.1"}
  ]
end
```

# **Quick Start**

```elixir
# Offset pagination
{posts, meta} = FastPaginate.paginate(Post, params, Repo)
 
# Cursor pagination
{posts, meta} = FastPaginate.paginate_cursor(Post, params, Repo)
```
----

# **Project Structure**

```
pagex/
├── lib/
│   ├── pagex.ex                  # Public API — paginate/4 and paginate_cursor/4
│   └── pagex/
│       ├── meta.ex               # Meta struct + constructors
│       ├── params.ex             # Parameter validation
│       ├── offset.ex             # Offset pagination engine
│       ├── cursor.ex             # Cursor pagination engine
│       ├── phoenix/
│             └── live_view.ex    # Phoenix LiveView helpers
│             └── html.ex       # HTML helper functions
│ 
│ 
│               
├── test/
│   └── pagex/
│       ├── params_test.exs
│       ├── meta_test.exs
│       ├── cursor_encode_test.exs
│       └── phoenix/
│           ├── html_test.exs
│           ├── live_view_test.exs
├── benchmarks/
│   └── support/
│       ├── post.ex
│       ├── repo.ex
│   └── pagination_benchmark.exs
│   └── setup.exs
├── mix.exs
├── README.md
├── LICENSE.md
└── CHANGELOG.md
```
---- 

# **License**
 
MIT — see [LICENSE](LICENSE).
