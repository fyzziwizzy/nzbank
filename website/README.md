# Fern Bank

Fern Bank is a frontend product exercise for reviewing and extending a modern personal banking experience. It takes inspiration from the product patterns used by digital banks, but uses original branding, interface copy and implementation.

## Run it

No build step or dependencies are required.

```powershell
Set-Location C:\WFClawish\WorkingRepos\fyzziwizzy\website
python -m http.server 8000
```

Open `http://localhost:8000`.

## What is implemented

- Responsive application shell with hash-based navigation
- Multi-currency account overview and exchange preview
- Transfer validation, review and confirmation flow
- Physical card controls, including freeze and unfreeze
- Spending overview and lightweight analytics
- Profile, security and notification settings
- Light and dark Clawpilot themes
- Accessible labels, focus states, reduced-motion support and keyboard dismissal
- Toast feedback instead of browser alerts

All names, balances and transactions are fictional. This is not a real bank and no data leaves the browser.

## Project structure

```text
website/
|-- index.html
|-- css/
|   |-- styles.css
|   `-- responsive.css
|-- js/
|   `-- main.js
|-- EXERCISE.md
`-- legacy page redirects
```

The application deliberately stays framework-free so participants can focus on product reasoning, browser fundamentals and code quality.

## Design intent

The interface uses a Revolut-inspired product language: confident oversized typography, monochrome feature canvases, pill-shaped actions, broad whitespace and focused financial controls. Fern keeps its own branding, data, copy and implementation rather than copying Revolut assets or exact layouts.

## Important limitation

This is a frontend prototype. Production banking software would require authenticated server APIs, server-side validation, audit logging, fraud controls, encryption, regulatory review and extensive automated testing.
