# me

My personal website

## Prerequisites

- [Hugo Extended](https://gohugo.io/installation/) (v0.152.0+)
- [Node.js](https://nodejs.org/) (for Pagefind search)
- [Dart Sass](https://sass-lang.com/dart-sass) (for SCSS compilation)

## Setup

1. Clone the repository with submodules:
```bash
git clone --recurse-submodules https://github.com/oribarilan/me.git
cd me
```

2. Install dependencies:
```bash
npm install
```

## Local Development

Quick start (build + serve with search):
```bash
npm start
```

Or dev server only (without search index):
```bash
npm run dev
```

Visit `http://localhost:1313`

## Build

Build for production with search index:
```bash
npm run build
```

The Pagefind search index will be generated in `public/pagefind/`.

## Deploy

Automatically deploys to GitHub Pages on push to `main` branch via GitHub Actions.

## Features

- Terminal aesthetic with typing animations
- Keyboard navigation (j/k to scroll, g for home, b for blog, p for portfolio, w for about, t for themes)
- Full-text search with Pagefind (press `/` to open search)
- Multiple color themes (Nord, Dark, Light, Tokyo Night, Gruvbox, Catppuccin)
- Responsive design
