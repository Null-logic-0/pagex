# Changelog

---

All notable changes to this project will be documented in this file. 

The format is based on Keep a Changelog,

and this project adheres to Semantic Versioning.

----

**[Released] [0.1.0] - 2026-04-16**

----


# Added

- Offset pagination via Pagex.paginate/4
- Cursor pagination via Pagex.paginate_cursor/4
- Pagex.Meta struct with to_map/1 for JSON serialization
- Pagex.Params for safe parameter validation and clamping
- Pagex.PhoenixHTML with pagination_links/3 and cursor_links/3
- Pagex.LiveView with LiveView-compatible helpers
- Max page size protection
- Optional count query toggle (count: false)
- Base64 encoded opaque cursors
- Multi-field cursor support via :cursor_fields option
- Full ExUnit test suite
- Benchee benchmark setup
