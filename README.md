# **Pagex** 📖

<img width="1792" height="592" alt="github" src="https://github.com/user-attachments/assets/122356a0-efd8-4da4-aee1-fe8e19ce7a35" />


[![Hex.pm](https://img.shields.io/hexpm/v/pagex.svg)](https://hex.pm/packages/pagex)
[![Documentation](https://img.shields.io/badge/docs-hexdocs-blue.svg)](https://hexdocs.pm/pagex)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/Null-logic-0/pagex/blob/master/LICENSE)

> **Fast, minimal, production-ready pagination for Ecto and Phoenix.**

Inspired by [Pagy (Ruby)](https://github.com/ddnexus/pagy), **Pagex** is designed specifically for the Elixir/Phoenix ecosystem. It takes the approach of **explicit, small functions** over magic. No `use Pagex` in your schema, no global config macros, and no hidden schema introspection. 

---

## 🚀 **Example Integration**
If you want to see a full, production-ready implementation of `pagex` in a Phoenix application, check out our example repository:

👉 **[Simple Pagination Example](https://github.com/Null-logic-0/simple_pagination)**

This example project demonstrates:
- ✅ **Phoenix LiveView** pagination.
- ✅ **JSON API** pagination.

## 📺 **Demo Videos**

### **Phoenix LiveView Integration**
See how smoothly `pagex` handles real-time pagination in LiveView:

<details open>
  <summary>Click to view LiveView Demo</summary>
  <video src="https://private-user-images.githubusercontent.com/157907877/579322071-4870b05a-ef99-4d16-a2f6-6beb6a9be095.mov?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NzYzNTI4MzcsIm5iZiI6MTc3NjM1MjUzNywicGF0aCI6Ii8xNTc5MDc4NzcvNTc5MzIyMDcxLTQ4NzBiMDVhLWVmOTktNGQxNi1hMmY2LTZiZWI2YTliZTA5NS5tb3Y_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjYwNDE2JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI2MDQxNlQxNTE1MzdaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1hMzU0ZjgzZDBkYTI4NjA5OTAwM2U5ZTkzMWFiNTJmM2FkNTMwNDNiODVkMGRlNmMwNDM0ZWJjY2E3NDE5ZWRiJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCZyZXNwb25zZS1jb250ZW50LXR5cGU9dmlkZW8lMkZxdWlja3RpbWUifQ.NSP8Yj4AduU6RCC9OjXsPtF4mroVIvhTf8zfNmLa6V8" controls="controls" muted="muted" style="max-width: 100%; border-radius: 10px;">
  </video>
</details>

### **JSON API Response**
Standardized metadata structure ready for any front-end:

<details open>
  <summary>Click to view JSON API Demo</summary>
  <video src="https://private-user-images.githubusercontent.com/157907877/579322264-67de5491-e434-4c22-8cbe-c05562d74e94.mov?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NzYzNTI4MzcsIm5iZiI6MTc3NjM1MjUzNywicGF0aCI6Ii8xNTc5MDc4NzcvNTc5MzIyMjY0LTY3ZGU1NDkxLWU0MzQtNGMyMi04Y2JlLWMwNTU2MmQ3NGU5NC5tb3Y_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjYwNDE2JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI2MDQxNlQxNTE1MzdaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1hYTE2NzZkOThkMTk1OWE4NjZlMmU2NWRiMmNhYmQwMGY5MzNjY2U4MmMwNWM5NTY4ZjU1NzdlMWU0NmE3MjA5JlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCZyZXNwb25zZS1jb250ZW50LXR5cGU9dmlkZW8lMkZxdWlja3RpbWUifQ.lLot9DtrIHInpNZjYwjMWSe6nOEsLivan89yw0-Q2JM" controls="controls" muted="muted" style="max-width: 100%; border-radius: 10px;">
  </video>
</details>

---

# ✨ **Features & Comparison**

Pagex offers a modern alternative to existing pagination libraries by combining performance with extreme simplicity.

| Feature | Pagex | Scrivener | Paginator |
| :--- | :---: | :---: | :---: |
| **Offset pagination** | ✅ | ✅ | ✅ |
| **Cursor pagination** | ✅ | ❌ | ✅ |
| **LiveView helpers** | ✅ | ❌ | ❌ |
| **JSON API support** | ✅ | Partial | Partial |
| **No macros/DSLs** | ✅ | ❌ | ❌ |
| **Max page size guard** | ✅ | ❌ | ❌ |
| **Optional count query** | ✅ | ❌ | ❌ |


--- 

# 📦 **Installation**
 
Add `pagex` to your list of dependencies in `mix.exs`:

```elixir
# mix.exs
def deps do
  [
    {:pagex, "~> 0.2.1"}
  ]
end
```
Then, run mix deps.get in your terminal.

---

# 📖 Documentation

Full API documentation is available via HexDocs:

👉 https://hexdocs.pm/pagex


To generate and view the full API documentation locally:

```bash
mix docs
```
Then open:

```bash 
open doc/index.html
```

On Linux:

```bash 
xdg-open doc/index.html
```

Or simply open doc/index.html in your browser.

---

# 🚀 **Quick Start**

Pagex provides a clean and straightforward API. You can paginate your Ecto queries using either Offset or Cursor-based pagination.

## **Offset Pagination**

Ideal for standard table views and web interfaces.

```elixir 
alias App.Repo
alias App.Blog.Post

# Using default params
{posts, meta} = Pagex.paginate(Post, params, Repo)

# With a custom Ecto query
query = from p in Post, where: p.published == true, order_by: [desc: p.inserted_at]
{posts, meta} = Pagex.paginate(query, %{"page" => 2, "page_size" => 20}, Repo)
```

## **Cursor Pagination**

Highly recommended for large datasets, JSON APIs, and infinite scrolling interfaces.

```elixir 
{posts, meta} = Pagex.paginate_cursor(Post, params, Repo)
```
###### *(Note: The returned meta struct contains helpful data like next_cursor, prev_cursor, total_pages, etc., depending on your chosen pagination strategy.)*

----

# 💻 **Phoenix & LiveView Integration**

Pagex is built with Phoenix in mind. While staying un-intrusive, it ships with out-of-the-box helpers for:


- HTML Views: Easy-to-use template functions to generate pagination links.
- LiveView: Drop-in helpers for managing pagination state and events without boilerplate.
- JSON APIs: Standardized metadata structures ready to be merged into your API responses.

--- 

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
├── CHANGELOG.md
└── LICENSE
```
---- 

# 🤝 **Contributing**

Contributions, bug reports, and feature requests are welcome!

Feel free to check the issues page to get involved.


1. Fork and Clone

  First, fork the repository by clicking the "Fork" button at the top right of this page [1]. Then, clone your fork to your local machine:

```bash
    git clone https://github.com/Null-logic-0/pagex.git
    cd pagex
```

2. Install Dependencies

  Pagex is an Elixir project. Fetch the required dependencies using mix:

```bash 
    mix deps.get
```

3. Create a Branch

  Create a new branch for your feature, improvement, or bug fix:

```bash 
    git checkout -b feature/my-awesome-feature
```

4. Make Your Changes

  Write your code and implement your
  changes. If you are adding a new feature or fixing a bug, please write tests to cover your changes to maintain the library's stability.

5. Run Tests & Format Code

Before committing, ensure that all tests pass and that the code adheres to the standard Elixir formatting rules:

```bash 
# Run the test suite
mix test

# Format the code
mix format
```

6. Commit and Push

Commit your changes with a descriptive message and push the branch to your fork:

```bash 
git add .
git commit -m "Add my awesome feature"
git push origin feature/my-awesome-feature
```

7. Open a Pull Request

Go back to the main Pagex repository and you'll see a prompt to open a Pull Request. Submit your PR against the master branch and describe the changes you've made!

### Why this is helpful:
* **Elixir specific:** It uses the standard `mix` commands 
(`mix deps.get`, `mix test`, `mix format`) that Elixir developers expect.

* **Step-by-step:** It walks beginners completely through the process of interacting with a GitHub repo, making it much more inviting for open-source newcomers.

---

# 📜 **License**

Pagex is open-source software released under the MIT [LICENSE](https://github.com/Null-logic-0/pagex/blob/master/LICENSE)
