---
title: ".ipynb: The Silent Collaboration Killer"
date: 2025-11-26
draft: false
tags: ["python", "productivity", "coding-agents"]
categories: ["development"]
description: "Notebooks break collaboration with humans and coding agents. Here's how to get interactive Python without the .ipynb friction."
toc: true
---

Whether you're collaborating with a human or a coding agent, `.ipynb` is a silent collaboration. Jupyter notebooks changed how we explore data. The ability to run code in cells, see outputs inline, and iterate quickly changed how we analyze data. But `.ipynb` files come with friction: version control is annoying, limited editor support, and a completely separate workflow from your production code.

But you don't have to choose between interactivity and sanity. Modern editors now support running Python interactively in regular `.py` files, giving you the best of both worlds.

## The Problem with .ipynb Files

Notebooks are JSON files containing code, outputs, and metadata. This creates several friction points:

**Version control is painful.** No native support for Diffs. Cell outputs bloat your repository. Merge conflicts are a nightmare. This creates bad practices like collaboration-taboo over notebooks.

**Limited editor features.** Although notebooks have come a long way in recent years, they are still lacking full IDE support. Refactoring, go-to-definition, picking up on virtual environment, PYTHONPATH support and more, are still clunky at best.

**Separate workflow.** Notebooks live in isolation. You prototype in a notebook, then manually copy code to `.py` files. The gap between exploration and production widens, and notebooks often become throwaway experiments.

**Coding agents can't work with them.** Tools like Cursor, Copilot, and Claude work by reading and editing your code. Notebooks are JSON blobs with base64-encoded outputs, cell metadata, and execution counts mixed in. When loaded into an agent's context, all that redundant structure eats up tokens that could be spent on actual code. IDE-integrated agents like Cursor can manage notebooks reasonably well since they hook into the editor's notebook support. But external agents (Claude Code, Codex, or any CI-based agent that operates directly on your repository) are basically useless with `.ipynb` files. They can't reliably parse cell structure or make targeted edits. As AI-assisted development becomes the norm, sticking with `.ipynb` means leaving your most powerful tools on the sideline.

## The Solution: Interactive Python in Your Editor

Both VS Code and Neovim (and other editors) now support Jupyter-style interactive execution in regular Python files. You write normal `.py` files, mark sections as cells, and run them interactively - with all the benefits of your full editor experience.

### VS Code: Python Interactive Window

VS Code's Python extension includes built-in Jupyter support for `.py` files. Define cells with `# %%` comments:

```python
# %%
import pandas as pd
import numpy as np

# %%
# Load and explore data
df = pd.read_csv('data.csv')
df.head()

# %%
# Feature engineering
df['new_feature'] = df['a'] * df['b']
df.describe()
```

Each `# %%` creates a cell. Click "Run Cell" or use `Ctrl+Enter` to execute and see results in the Python Interactive window. You get:

- **Variable explorer** - inspect all variables in your session
- **Data viewer** - double-click dataframes to view and filter
- **Plot viewer** - pan, zoom, and export matplotlib/altair figures
- **Full IntelliSense** - completions, type hints, documentation

The file is still just Python. No JSON, no cell outputs embedded in the file, perfect git diffs.

You can read more about this built-in feature [here](https://code.visualstudio.com/docs/python/jupyter-support-py).

### Neovim: iron.nvim

For Neovim users, I recommend [iron.nvim](https://github.com/Vigemus/iron.nvim) which provides similar functionality. It connects your editor to a REPL (IPython, Python, or any other) and lets you send code interactively.

```lua
-- Example iron.nvim setup
require("iron.core").setup {
  config = {
    repl_definition = {
      python = {
        command = { "ipython" }
      },
    },
  },
}
```

With iron.nvim you can send the current line, visual selection and even a motion (e.g., send until) to the REPL.

## When to Still Use Notebooks

I'm not saying notebooks are dead. They're still useful for:

- **Documentation** - tutorials and educational content where rendered outputs matter
- **Sharing with non-developers** - stakeholders who need to see code and results together
- **Colab** - some platforms are built around notebook interfaces

And probably other cases I haven't thought of.

## Conclusion

The interactive programming experience that made Jupyter notebooks so popular is now available in your regular editor, with regular Python files. You get clean version control, powerful editing features, and seamless integration with coding agents.

Try it now, and your future self (and your git history) will thank you.
