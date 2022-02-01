# CalculatorApp

Dummy calculator app as a basis to apply elixir tutorial learnings.
The idea is to have:
- 2 separate apps (core and API - and potentially a simple UI)
  - interpretation of "complex" calculations - e.g. `(3+2)/(5-9) = −1.25`
  - Can also consider dynamic supervision to "cache" computation
- dedicated processes per operation (`+`,`-`,`*`,`/`)
- supervision trees properly setup

