# Run `just` with no arguments to list every command.

# Show all available commands
default:
    @just --list

# Serve the site locally with drafts at http://localhost:1313
run:
    hugo server -D

# Build the site in memory; fails on any Hugo build error
test:
    hugo --gc --minify --renderToMemory

# Check Markdown and SCSS formatting without writing changes
lint:
    npx prettier --check "content/**/*.md" "assets/**/*.scss"

# Format Markdown and SCSS in place
format:
    npx prettier --write "content/**/*.md" "assets/**/*.scss"

# Verify formatting and build without writing changes (CI gate)
validate: lint test
