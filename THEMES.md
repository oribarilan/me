# Color Themes - Developer Reference

Technical documentation for extending the theme system.

## Current Themes

- `default` - Original Nightfall colors
- `tokyonight` - Purple-blue neon
- `gruvbox` - Warm earthy tones
- `catppuccin` - Soft pastels (Mocha)
- `nord` - Arctic blue-grey

## Adding a New Theme

### 1. Define Theme Colors

Add to `/assets/main.scss` after existing theme blocks:

```scss
[data-theme="themename"] {
  --bg-primary: #...;
  --bg-secondary: #...;
  --bg-darker: #...;
  --text-primary: #...;
  --text-secondary: #...;
  --text-dim: #...;
  --accent-primary: #...;
  --accent-secondary: #...;
  --accent-warning: #...;
  --accent-error: #...;
  --prompt-user: #...;
  --prompt-host: #...;
  --prompt-path: #...;
  --code-bg: #...;
  --code-text: #...;
  --border-color: #...;
  --selection-bg: #...;
}
```

### 2. Add to Terminal Picker

Add to `/layouts/_partials/theme-switcher.html` in `.terminal-options`:

```html
<button class="terminal-option" data-theme="themename">
    <span class="option-bracket">[</span><span class="option-num">N</span><span class="option-bracket">]</span>
    <span class="option-name">themename</span>
    <span class="option-desc">// short description</span>
</button>
```

Update number `N` sequentially and update keyboard handler if needed.

## Architecture

- **Theme storage**: CSS custom properties in `/assets/main.scss`
- **Theme switching**: JavaScript in `/layouts/_partials/theme-switcher.html`
- **Theme application**: `data-theme` attribute on `<html>` element
- **Persistence**: localStorage key `color-theme`
- **All components**: Use `var(--variable-name)` to reference theme colors

## Reference Implementations

Individual theme files in `/assets/themes/*.scss` show color values but are not actively loaded.


