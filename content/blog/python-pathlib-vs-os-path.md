---
title: "Choose Your Path: Python's pathlib vs os.path"
date: 2024-02-13
draft: false
tags: ["python", "programming", "best-practices"]
categories: ["development"]
description: "A comparison of Python's pathlib and os.path modules for file system operations"
---

Python offers two main modules for interacting with the file system: `pathlib` and `os.path`. Let's compare the two!

Both modules provide functionalities to discover, create, modify, and delete files and directories (and much more), but they are fundamentally different in their approach. In this blog post, we'll explore the differences between `pathlib` and `os.path`, helping you decide which is more suitable for your project and situation.

## The os.path Module

The `os.path` submodule is part of the larger `os` module that provides a way of using operating system dependent functionality. In `os.path`, paths are represented as strings (for both input and output).

## The pathlib Module

Introduced in Python 3.4, `pathlib` offers an object-oriented approach to file system paths. It provides an abstraction over system paths by encapsulating the idea of a path as an object, allowing for more intuitive and readable code. With `pathlib`, you can perform most path manipulations using methods directly on path objects.

## Let's Compare

Here are some common scenarios to compare both libraries:

### Join Paths & File Attributes

**os.path:**
```python
import os

file_path = os.path.join('directory', 'subdirectory', 'file.txt')
file_exists = os.path.isfile(file_path)

parent_folder = os.path.dirname(file_path)  # directory/subdirectory
filename = os.path.basename(file_path)      # file.txt
extension = os.path.splitext(file_path)[1]  # .txt
```

**pathlib:**
```python
from pathlib import Path

file_path = Path('directory') / 'subdirectory' / 'file.txt'
file_exists = file_path.is_file()

parent_folder = file_path.parent   # directory/subdirectory
filename = file_path.name          # file.txt
extension = file_path.suffix       # .txt
```

🥇 **pathlib wins** with simpler and more straightforward access to file attributes.

### Reading Files

**os.path:**
```python
import os

file_path = os.path.join('directory', 'file.txt')
with open(file_path, 'r') as file:
    content = file.read()
```

**pathlib:**
```python
from pathlib import Path

file_path = Path('directory') / 'file.txt'
content = file_path.read_text()
```

🥇 **pathlib wins** with less boilerplate code for reading a file.

### Listing All Files in a Directory

**os.path:**
```python
import os

directory = 'some_directory'
files = [
    os.path.join(directory, f) 
    for f in os.listdir(directory) 
    if os.path.isfile(os.path.join(directory, f))
]
```

**pathlib:**
```python
from pathlib import Path

directory = Path('some_directory')
files = [f for f in directory.iterdir() if f.is_file()]
```

🥇 **pathlib wins** with a more concise and discoverable way to list a directory (less code to memorize).

### Creating a New Directory

**os.path:**
```python
import os

dir_path = os.path.join('path', 'to', 'new_directory')
if not os.path.exists(dir_path):
    os.makedirs(dir_path)
```

**pathlib:**
```python
from pathlib import Path

dir_path = Path('path') / 'to' / 'new_directory'
dir_path.mkdir(parents=True, exist_ok=True)
```

🥇 **pathlib wins** with built-in controls over common use-cases.

## Compatibility

Python 3.6 introduced `os.PathLike`, which standardizes the representation of file system paths. Moreover, you can use `PathLike` from `typing` to support accepting both strings and `os.PathLike` objects (e.g., `Path`). Many of Python's built-in methods already support it, for example, `open()`:

```python
import os
from pathlib import Path

# both of the following work with open(), although different types
file_path = os.path.join('directory', 'subdirectory', 'file.txt')
file_path = Path('directory') / 'subdirectory' / 'file.txt'

with open(file_path, 'r') as file:
    return file.read()
```

So, you can use this approach if you want to have your API support both strings and `PathLike` objects.

## Summary & Verdict

`pathlib` is a more modern approach to handle file system functionality. It provides an object-oriented interface which is more readable, saves you from repeating boilerplate code, exposes edge-case controls and much more. `os.path` provides a functional programming interface and a more low-level approach, that is coupled to the `os` module — which some may prefer, or some scenarios may require.

🏆 **For me, pathlib is the clear winner! OOP FTW!**

## Tip

If you read this far, you deserve a cool tip :)

There is a cool library that provides path-like interface for cloud stores (AWS S3, Azure Blob Storage, …) called [cloudpathlib](https://github.com/drivendataorg/cloudpathlib), check it out!

```python
from cloudpathlib import CloudPath

with CloudPath("s3://bucket/filename.txt").open("w+") as f:
    f.write("Send my changes to the cloud!")
```
