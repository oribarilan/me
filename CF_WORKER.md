# WORKER.md -- Blog Metrics Worker (views + likes)

This document describes how the **blog metrics worker** is set up for
`oribi.sh` / `www.oribi.sh`, so future agents (and future-me) can reason
about it without reverse-engineering.

------------------------------------------------------------------------

## 1. High-level architecture

-   Static site is hosted on **GitHub Pages**.
-   DNS and TLS are handled by **Cloudflare**.
-   A **Cloudflare Worker** (`blog-metrics`) exposes a small JSON API
    for:
    -   per-post **view counts**
    -   per-post **likes**
-   Data is stored in a **Cloudflare KV namespace** (`blog-metrics`),
    bound into the worker as `env.METRICS`.
-   The API is exposed under the **`www.oribi.sh`** origin, at:
    -   `https://www.oribi.sh/api/views`
    -   `https://www.oribi.sh/api/likes`

The blog frontend calls these endpoints from the browser and renders
counts on each post.

------------------------------------------------------------------------

## 2. DNS + TLS setup (relevant bits)

**Zone:** `oribi.sh`

### DNS records

-   Apex (root) → GitHub Pages IPs (**DNS only** -- not proxied):

        A  @  185.199.108.153   DNS only
        A  @  185.199.109.153   DNS only
        A  @  185.199.110.153   DNS only
        A  @  185.199.111.153   DNS only

-   `www` → GitHub Pages user site (**proxied** -- orange cloud):

        CNAME  www  oribarilan.github.io   Proxied

### GitHub Pages

In the repo:

-   **Settings → Pages**
    -   Custom domain: `www.oribi.sh` (canonical)
    -   "Enforce HTTPS": **enabled**

A `CNAME` file exists at repo root with:

    www.oribi.sh

### Cloudflare SSL / redirects

In Cloudflare for `oribi.sh`:

-   **SSL/TLS → Overview**
    -   Mode: `Full`
-   **SSL/TLS → Edge Certificates**
    -   `Always Use HTTPS`: ON
    -   `Automatic HTTPS Rewrites`: ON

(Optionally, there can be a rule redirecting `oribi.sh/*` →
`https://www.oribi.sh/$1` so all traffic uses `www`.)

------------------------------------------------------------------------

## 3. Worker: `blog-metrics`

### Purpose

Single Worker that:

-   Tracks **views** (increments on every GET by default).
-   Tracks **likes** (increments on POST, read on GET).
-   Stores counts in KV as simple integers (strings in KV).

### KV namespace

-   Namespace name in Cloudflare: `blog-metrics` (or similar).

-   Bound to Worker as:

    -   **Settings → Bindings → KV Namespace Bindings**
        -   Variable name: `METRICS`
        -   Namespace: `blog-metrics`

Inside the worker code, data is accessed as `env.METRICS`.

### Routes

In the Worker:

    www.oribi.sh/api/*

------------------------------------------------------------------------

## 4. API surface

### Health check

    GET /api/health

### Views API

    GET /api/views?slug=/path[&mode=get]

### Likes API

    GET  /api/likes?slug=/path
    POST /api/likes?slug=/path&action=like

------------------------------------------------------------------------

## 5. Worker code shape

See worker source in Cloudflare dashboard.

------------------------------------------------------------------------

## 6. Frontend integration

### Views snippet

``` js
<script>
(function () {
  const slug = window.location.pathname.replace(/\/$/, "") || "/";
  const url = "/api/views?slug=" + encodeURIComponent(slug);

  fetch(url)
    .then(r => r.json())
    .then(data => {
      const el = document.getElementById("view-count");
      if (el && typeof data.views === "number") {
        el.textContent = data.views.toLocaleString();
      }
    });
})();
</script>
```

### Likes snippet

``` js
<script>
(function () {
  const slug = window.location.pathname.replace(/\/$/, "") || "/";
  const base = "/api/likes?slug=" + encodeURIComponent(slug);

  function refreshLikes() {
    fetch(base).then(r => r.json()).then(data => {
      const el = document.getElementById("like-count");
      if (el && typeof data.likes === "number") {
        el.textContent = data.likes.toLocaleString();
      }
    });
  }

  document.getElementById("like-button")?.addEventListener("click", () => {
    fetch(base + "&action=like", { method: "POST" })
      .then(r => r.json())
      .then(data => {
        const el = document.getElementById("like-count");
        if (el && typeof data.likes === "number") {
          el.textContent = data.likes.toLocaleString();
        }
      });
  });

  refreshLikes();
})();
</script>
```
