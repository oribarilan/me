# Personal Website Implementation Plan

## Overview
Transform this repository into a Hugo-based personal website hosted on GitHub Pages with complete CI/CD automation.

---

## Phase 1: Local Development Setup

### Goal
Create a functional Hugo website that can be developed and tested locally.

### Prerequisites
- Hugo installed (Extended version recommended)
- Git configured
- Text editor/IDE

### Step 1: Install Hugo

**macOS Installation:**
```bash
brew install hugo
```

**Verify Installation:**
```bash
hugo version
# Should show v0.120.0 or higher
```

### Step 2: Initialize Hugo Site

```bash
cd /Users/orbarila/repos/personal/me
hugo new site . --force
```

**Expected Structure:**
```
/
├── archetypes/          # Content templates
├── assets/              # Files to be processed (SCSS, JS)
├── content/             # Your markdown content
├── data/                # Data files (JSON, YAML, TOML)
├── layouts/             # Custom HTML templates
├── static/              # Static files (images, CSS, JS)
├── themes/              # Hugo themes
├── hugo.toml            # Site configuration
├── PLAN.md              # This file
└── README.md            # Existing file
```

### Step 3: Choose and Add a Theme

**Recommended Themes for Personal Sites:**

1. **PaperMod** - Clean, fast, feature-rich blog theme
   - Best for: Blog-focused personal sites
   - Features: Dark mode, search, archives, social links
   - Repo: https://github.com/adityatelange/hugo-PaperMod

2. **Terminal** - Minimal, developer-focused
   - Best for: Technical/developer portfolios
   - Features: Minimalist design, fast loading
   - Repo: https://github.com/panr/hugo-theme-terminal

3. **Anatole** - Modern portfolio theme
   - Best for: Portfolio showcase
   - Features: Beautiful design, project galleries
   - Repo: https://github.com/lxndrblz/anatole

4. **Hugo Profile** - Modern profile/resume theme
   - Best for: Professional portfolio/resume sites
   - Features: Skills, experience, projects sections
   - Repo: https://github.com/gurusabarish/hugo-profile

**Add Theme (Example with PaperMod):**
```bash
git submodule add --depth=1 https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod
git submodule update --init --recursive
```

### Step 4: Configure Site

**Edit `hugo.toml`:**
```toml
baseURL = 'https://<your-username>.github.io/'
languageCode = 'en-us'
title = 'Your Name - Personal Website'
theme = 'PaperMod'  # Or your chosen theme

[params]
  description = "Personal website and blog"
  author = "Your Name"
  
  # Theme-specific parameters
  # Consult your theme's documentation

[menu]
  [[menu.main]]
    identifier = "about"
    name = "About"
    url = "/about/"
    weight = 10
  
  [[menu.main]]
    identifier = "posts"
    name = "Posts"
    url = "/posts/"
    weight = 20
```

### Step 5: Create Initial Content

**Create About Page:**
```bash
hugo new content/about.md
```

**Edit `content/about.md`:**
```markdown
---
title: "About Me"
date: 2025-11-23
draft: false
---

Write your bio here...
```

**Create First Post:**
```bash
hugo new content/posts/hello-world.md
```

**Edit `content/posts/hello-world.md`:**
```markdown
---
title: "Hello World"
date: 2025-11-23
draft: false
tags: ["first-post"]
---

Your first blog post content...
```

### Step 6: Test Locally

**Start Development Server:**
```bash
hugo server -D
```

**Flags:**
- `-D` or `--buildDrafts` - Include draft content
- `--navigateToChanged` - Auto-navigate to changed content
- `-p 8080` - Use different port

**Access Site:**
- Open browser to http://localhost:1313
- Site auto-reloads on file changes

**Validation Checklist:**
- [ ] Homepage loads correctly
- [ ] Navigation menu works
- [ ] About page displays
- [ ] Blog posts are listed and accessible
- [ ] Theme styling applied correctly
- [ ] No console errors
- [ ] Responsive design works on mobile

### Step 7: Build Static Site (Optional Test)

```bash
hugo --minify
```

This generates the static site in `./public/` directory.

---

## Phase 2: CI/CD Pipeline

### Goal
Automate deployment to GitHub Pages on every push to main branch.

### Step 1: Create .gitignore

**Create `.gitignore`:**
```gitignore
# Hugo
/public/
/resources/_gen/
/assets/jsconfig.json
hugo_stats.json

# OS
.DS_Store
Thumbs.db

# Editor
.vscode/
.idea/
*.swp
*.swo
*~

# Node (if using npm for additional tooling)
node_modules/
```

### Step 2: Create GitHub Actions Workflow

**Create `.github/workflows/hugo.yml`:**

```yaml
name: Deploy Hugo site to Pages

on:
  push:
    branches: ["main"]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

defaults:
  run:
    shell: bash

jobs:
  build:
    runs-on: ubuntu-latest
    env:
      HUGO_VERSION: 0.128.0
    steps:
      - name: Install Hugo CLI
        run: |
          wget -O ${{ runner.temp }}/hugo.deb https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.deb \
          && sudo dpkg -i ${{ runner.temp }}/hugo.deb
      
      - name: Install Dart Sass
        run: sudo snap install dart-sass
      
      - name: Checkout
        uses: actions/checkout@v4
        with:
          submodules: recursive
          fetch-depth: 0
      
      - name: Setup Pages
        id: pages
        uses: actions/configure-pages@v5
      
      - name: Install Node.js dependencies
        run: "[[ -f package-lock.json || -f npm-shrinkwrap.json ]] && npm ci || true"
      
      - name: Build with Hugo
        env:
          HUGO_ENVIRONMENT: production
          HUGO_ENV: production
        run: |
          hugo \
            --gc \
            --minify \
            --baseURL "${{ steps.pages.outputs.base_url }}/"
      
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: ./public

  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

### Step 3: Configure GitHub Repository

**Enable GitHub Pages:**
1. Go to repository Settings
2. Navigate to "Pages" section (left sidebar)
3. Under "Build and deployment":
   - Source: Select "GitHub Actions"
4. Save changes

**Note:** No need to select a branch - GitHub Actions handles deployment.

### Step 4: Commit and Push

```bash
git add .
git commit -m "Initial Hugo site setup with GitHub Pages deployment"
git push origin main
```

### Step 5: Monitor Deployment

1. Go to repository "Actions" tab
2. Watch the workflow run
3. Verify both "build" and "deploy" jobs succeed
4. Check deployment URL: `https://<username>.github.io/`

### Step 6: Validation Checklist

- [ ] GitHub Actions workflow completes successfully
- [ ] Site is accessible at GitHub Pages URL
- [ ] All pages render correctly
- [ ] Navigation works
- [ ] Assets (CSS, images) load properly
- [ ] Theme styling applied
- [ ] No 404 errors
- [ ] Mobile responsive

---

## Workflow Summary

### Development Workflow

1. **Local Development:**
   ```bash
   hugo server -D
   # Make changes, preview at localhost:1313
   ```

2. **Create Content:**
   ```bash
   hugo new content/posts/my-new-post.md
   # Edit the file
   # Preview locally
   ```

3. **Commit and Push:**
   ```bash
   git add .
   git commit -m "Add new blog post"
   git push origin main
   ```

4. **Automatic Deployment:**
   - GitHub Actions triggers automatically
   - Builds Hugo site
   - Deploys to GitHub Pages
   - Site live in ~1-2 minutes

### Content Creation

**Blog Post Template:**
```markdown
---
title: "Post Title"
date: 2025-11-23
draft: false
tags: ["tag1", "tag2"]
categories: ["category"]
description: "Post description for SEO"
---

Your content here...
```

**Page Template:**
```markdown
---
title: "Page Title"
date: 2025-11-23
draft: false
---

Your page content...
```

---

## Advanced Configuration (Future Enhancements)

### Custom Domain
1. Add `CNAME` file in `static/` directory with your domain
2. Configure DNS records with your domain provider
3. Update `baseURL` in `hugo.toml`

### Analytics
Add Google Analytics or other tracking:
```toml
[params]
  googleAnalytics = "G-XXXXXXXXXX"
```

### Comments
Integrate Disqus, Utterances, or Giscus for blog comments.

### Search
Enable search functionality (theme-dependent).

### RSS Feed
Hugo generates RSS automatically at `/index.xml`.

### Social Media Cards
Configure Open Graph and Twitter Card metadata for better sharing.

---

## Troubleshooting

### Hugo Server Issues
```bash
# Clear cache and restart
hugo server --noHTTPCache -D
```

### Build Fails on GitHub Actions
- Check Hugo version compatibility with theme
- Verify submodules are properly configured
- Review workflow logs for specific errors

### Theme Not Applied
- Ensure theme is in `themes/` directory
- Verify `theme = "theme-name"` in `hugo.toml`
- Check theme documentation for required configuration

### 404 Errors on GitHub Pages
- Verify `baseURL` matches GitHub Pages URL
- Ensure content files have `draft: false`
- Check that files are in correct content directory

---

## Resources

### Documentation
- [Hugo Documentation](https://gohugo.io/documentation/)
- [Hugo Themes](https://themes.gohugo.io/)
- [GitHub Pages Docs](https://docs.github.com/en/pages)

### Theme Documentation
- Consult your chosen theme's README and documentation
- Check theme's example site for configuration examples

### Community
- [Hugo Discourse Forum](https://discourse.gohugo.io/)
- [Hugo GitHub Discussions](https://github.com/gohugoio/hugo/discussions)

---

## Success Criteria

### Phase 1 Complete When:
- [ ] Hugo installed and working
- [ ] Site initializes successfully
- [ ] Theme installed and configured
- [ ] Basic content created (About page, 1 blog post)
- [ ] Local server runs without errors
- [ ] Site looks good and functions correctly locally

### Phase 2 Complete When:
- [ ] GitHub Actions workflow created
- [ ] Workflow runs successfully
- [ ] Site deploys to GitHub Pages
- [ ] Site accessible at public URL
- [ ] All content renders correctly online
- [ ] Can make changes and see them deploy automatically

---

## Next Steps After Setup

1. **Content Strategy:**
   - Plan your site structure
   - Create content calendar for blog posts
   - Prepare portfolio/project showcases

2. **Customization:**
   - Customize theme colors/fonts
   - Add custom layouts if needed
   - Implement additional features

3. **SEO Optimization:**
   - Add meta descriptions
   - Configure sitemap
   - Submit to search engines

4. **Performance:**
   - Optimize images
   - Enable caching
   - Test with PageSpeed Insights

5. **Maintenance:**
   - Keep Hugo updated
   - Update theme regularly
   - Monitor and fix broken links
