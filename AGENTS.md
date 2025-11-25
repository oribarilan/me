# Agent Guidelines for Hugo Personal Website

## Build & Development Commands
- **Local dev server**: `hugo server -D` (includes drafts)
- **Production build**: `hugo --gc --minify`
- **Clean build cache**: `hugo --cleanDestinationDir`

## Project Structure
- **Content**: `/content/` - Markdown files for posts and pages
- **Layouts**: `/layouts/` - HTML templates (overrides theme templates)
- **Static assets**: `/static/` - Served as-is (images, fonts, etc.)
- **Theme**: Uses Nightfall theme in `/themes/nightfall/`
- **Config**: `hugo.toml` - Site configuration

## Code Style & Conventions
- **HTML templates**: Use Go template syntax, prefer Hugo partials for reusability
- **CSS**: Inline styles in layout overrides acceptable, monospace fonts for terminal aesthetic
- **JavaScript**: Vanilla JS, use `DOMContentLoaded` for initialization
- **File naming**: kebab-case for content files, lowercase for layouts
- **Theme overrides**: Create files in root `/layouts/` to override theme templates
- **Terminal aesthetic**: Use monospace fonts, ASCII characters, command-line styling throughout
- **Simplicity**: Write simple, readable code - avoid unnecessary complexity
- **Single responsibility**: Keep files short and focused - one template/partial per concern
- **No over-engineering**: Prefer straightforward solutions over clever abstractions
- **Markdown content**: Use only one H1 header (`#`) per file - the title from front matter serves as the main heading

## Versioning
- **Version location**: Site version is stored in `hugo.toml` under `[params.version]`
- **Version format**: Semantic versioning (MAJOR.MINOR.PATCH)
- **When to bump**:
  - **Major**: Complete redesigns, major feature overhauls, fundamental changes
  - **Minor**: New features, new sections/pages, significant layout/functionality changes
  - **Patch**: Bug fixes, copy updates, small tweaks, styling adjustments
- **Important**: Always bump the version in `hugo.toml` after implementing changes according to the versioning scheme above

## Design Philosophy
- Terminal/developer aesthetic with typing animations, block cursors, and command-line UI elements
- Pixel art compatible (circular avatar with border-radius: 50%)
- Responsive design with mobile-first approach
