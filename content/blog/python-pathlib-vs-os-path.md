---
title: "Choose Your Path: Python's pathlib vs os.path"
date: 2024-02-13
draft: false
tags: ["python", "programming", "best-practices"]
description: "Learn how to work with file system paths using Python's modern pathlib module"
toc: true
postId: "pathlib-vs-ospath"
image: "/thumb-pathlib.png"
---

For years, Python developers used the `os.path` module for file system operations, working with paths as strings. Python 3.4 introduced `pathlib`, a modern object-oriented approach that makes path handling more intuitive and readable.

In this post, I'll show you how `pathlib` improves upon traditional `os.path` patterns, helping you write cleaner path-handling code.

## The Traditional Approach: os.path

The `os.path` module represents paths as strings. While functional, this approach requires remembering various function names and often leads to verbose code:

```python
import os

file_path = os.path.join('directory', 'subdirectory', 'file.txt')
parent_folder = os.path.dirname(file_path)
filename = os.path.basename(file_path)
extension = os.path.splitext(file_path)[1]
```

## The Modern Approach: pathlib

Introduced in Python 3.4, `pathlib` provides an object-oriented interface where paths are objects with intuitive methods and properties. This makes code more discoverable and easier to read.

## Common Patterns Improved

Let me show you how `pathlib` simplifies common path operations.

### Working with Paths & File Attributes

Traditional approach:
```python
import os

file_path = os.path.join('directory', 'subdirectory', 'file.txt')
file_exists = os.path.isfile(file_path)

parent_folder = os.path.dirname(file_path)  # directory/subdirectory
filename = os.path.basename(file_path)      # file.txt
extension = os.path.splitext(file_path)[1]  # .txt
```

Modern approach with pathlib:
```python
from pathlib import Path

file_path = Path('directory') / 'subdirectory' / 'file.txt'
file_exists = file_path.is_file()

parent_folder = file_path.parent   # directory/subdirectory
filename = file_path.name          # file.txt
extension = file_path.suffix       # .txt
```

Notice how `pathlib` uses intuitive properties like `.parent`, `.name`, and `.suffix` instead of separate functions. The `/` operator for joining paths is also more readable than `os.path.join()`.

### Reading Files

Traditional approach:
```python
import os

file_path = os.path.join('directory', 'file.txt')
with open(file_path, 'r') as file:
    content = file.read()
```

Modern approach with pathlib:
```python
from pathlib import Path

file_path = Path('directory') / 'file.txt'
content = file_path.read_text()
```

The `read_text()` method eliminates boilerplate - no need to manually open and close files for simple read operations.

### Listing All Files in a Directory

Traditional approach:
```python
import os

directory = 'some_directory'
files = [
    os.path.join(directory, f) 
    for f in os.listdir(directory) 
    if os.path.isfile(os.path.join(directory, f))
]
```

Modern approach with pathlib:
```python
from pathlib import Path

directory = Path('some_directory')
files = [f for f in directory.iterdir() if f.is_file()]
```

The `iterdir()` method returns path objects, making it easy to chain operations. Much cleaner than juggling strings with `os.listdir()`.

## Compatibility

Python 3.6 introduced `os.PathLike`, which standardizes the representation of file system paths. This means most built-in functions (like `open()`) accept both strings and `Path` objects interchangeably:

```python
import os
from pathlib import Path

# both of the following work with open(), although different types
file_path = os.path.join('directory', 'subdirectory', 'file.txt')
file_path = Path('directory') / 'subdirectory' / 'file.txt'

with open(file_path, 'r') as file:
    content = file.read()
```

If you need to work with older APIs that only accept strings, simply use `str()` to convert a Path object.

## Why I Recommend pathlib

`pathlib` brings several advantages to modern Python code:

- **More readable**: The `/` operator and property-based access make intent clear
- **Less error-prone**: Methods are discoverable through autocomplete
- **Less boilerplate**: Built-in methods like `read_text()` eliminate common patterns
- **Object-oriented**: Easier to compose and pass around than strings

While `os.path` still works perfectly fine (and may be necessary for legacy codebases or performance-critical scenarios), I recommend using `pathlib` for new code. It's more Pythonic and easier to maintain.

## Bonus Tip

If you like the `pathlib` interface, check out [cloudpathlib](https://github.com/drivendataorg/cloudpathlib) - it extends the same path-like interface to cloud storage (AWS S3, Azure Blob Storage, etc.):

```python
from cloudpathlib import CloudPath

with CloudPath("s3://bucket/filename.txt").open("w+") as f:
    f.write("Send my changes to the cloud!")
```
