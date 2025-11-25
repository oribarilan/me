# TODO - Code Quality Improvements

## Critical Issues (Blocking Production Quality)

### 1. Massive Inline Scripts in `head.html`
- **File**: `layouts/_partials/head.html`
- **Issue**: 450+ lines of inline JavaScript embedded in HTML
  - Notification system (66 lines, lines 30-66)
  - Navigation keybindings (109 lines, lines 69-159)
  - Search modal logic (199 lines, lines 249-449)
- **Impact**: Poor separation of concerns, hard to maintain, no caching, difficult to test

### 2. Inline Styles Mixed with HTML
- **Files**:
  - `layouts/_partials/head.html`: 81 lines of notification CSS (lines 162-242)
  - `layouts/_partials/theme-switcher.html`: 372 lines of CSS (lines 49-421)
  - `layouts/home.html`: 76 lines of CSS (lines 11-87)
- **Impact**: Defeats the purpose of SCSS modularization, no caching, duplicates styles

### 3. Duplicate Theme Color Definitions
- **Files**:
  - `assets/scss/_themes.scss`: Theme colors defined as CSS custom properties
  - `layouts/_partials/theme-switcher.html`: Same theme colors hardcoded in inline CSS (lines 228-365)
- **Impact**: Maintenance nightmare, need to update colors in multiple places, risk of inconsistency

## Medium Issues (Best Practice Violations)

### 4. Missing Security Headers
- **File**: `layouts/_partials/head.html`
- **Issue**: No security-related meta tags
  - No Content Security Policy (CSP)
  - No X-Frame-Options equivalent
  - No referrer policy
- **Impact**: Potential security vulnerabilities

### 5. HTML Validation Issues
- **Files**: Various layout files
- **Issue**:
  - Inconsistent `lang` attributes
  - Some HTML could be more semantic
  - Missing ARIA labels in some interactive elements

### 6. JavaScript Code Duplication
- **Files**: Multiple inline scripts across partials
- **Issue**:
  - Multiple `DOMContentLoaded` checks using different patterns
  - Similar event handling patterns repeated across files
  - No shared utility functions
- **Impact**: Code bloat, harder to maintain, inconsistent behavior

## Minor Issues

### 7. `.hugo_build.lock` Not in `.gitignore`
- **File**: `.gitignore`
- **Issue**: Build artifact not ignored by git
- **Impact**: Pollutes git history with generated files

### 8. Magic Numbers in JavaScript
- **Files**: Various inline scripts
- **Issue**: Hard-coded values without explanation
  - Timeouts: `3000`, `500`, `100`, `300`
  - Scroll amounts: `100`
  - Animation delays
- **Impact**: Harder to tune behavior, unclear intent

### 9. Inconsistent Code Formatting
- **Files**: JavaScript in various partials
- **Issue**:
  - Mixed use of quotes (single vs double)
  - Inconsistent indentation in some places
  - Varying comment styles

### 10. No JavaScript Documentation
- **Files**: All inline scripts
- **Issue**: Functions lack JSDoc comments
- **Impact**: Harder for others (and future you) to understand the code

## Future Enhancements (Nice to Have)

### 11. No CSS/JS Minification in Development
- **Issue**: Assets not optimized for production builds
- Could add build-time optimization

### 12. Missing Accessibility Testing
- **Issue**: No automated accessibility checks
- Could add a11y linting

### 13. No Performance Budget
- **Issue**: No tracking of bundle sizes or page load metrics
- Could add Lighthouse CI or similar

### 14. Limited Browser Testing Documentation
- **Issue**: No documented browser compatibility targets
- Could add browserslist configuration

---

## Priority Recommendation

1. **Phase 1 (Critical)**: Extract inline scripts and styles to proper files
2. **Phase 2 (Critical)**: Eliminate duplicate theme definitions
3. **Phase 3 (Medium)**: Add security headers and fix HTML validation
4. **Phase 4 (Medium)**: Refactor JavaScript for DRY principles
5. **Phase 5 (Minor)**: Clean up gitignore, magic numbers, formatting
