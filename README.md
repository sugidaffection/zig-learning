# Zig Learning Workspace

A progressive Zig workspace for learning by doing.

This repository is my long-term Zig learning space. I will start from zero knowledge, build small projects step by step, and grow into more advanced concepts over time.

## Goal

The goal is not just to read about Zig, but to learn it by building.

In this workspace, I will:

- learn the language from the ground up
- practice concepts through real code
- revisit earlier ideas as I improve
- build many small projects in one place
- grow from beginner exercises to advanced applications

## What This Workspace Is

This is a single Zig workspace for many different project types, such as:

- libraries
- CLI tools
- small apps
- utilities
- experiments
- algorithms and data structure practice

The idea is to keep everything in one evolving workspace instead of starting over every time.

## Learning Approach

I will develop this project in a progressive way:

1. start with the basics
2. build small things first
3. understand each concept by using it
4. add more complexity only when ready
5. keep improving the codebase over time

This means the workspace will likely look simple at first and become more capable as I learn more Zig.

## Planned Direction

Over time, this workspace may include:

- language fundamentals
- control flow and functions
- structs, enums, and unions
- memory management
- collections and data structures
- algorithms and problem solving
- file and terminal programs
- reusable libraries
- larger applications

## Status

Early stage. This repository is being prepared as the base for a long-term Zig learning journey.

## Getting Started

### Prerequisites

- **Zig 0.15.2** or later (check with `zig version`)

### Running Projects

This workspace uses a single `build.zig` to manage multiple projects located in the `projects/` directory.

To run a specific project:
```bash
zig build <project_name>
```

Available projects:
- `hello_world`: `zig build hello_world`
- `basics`: `zig build basics`
- `bank_account`: `zig build bank_account`

### Testing

You can run tests for the entire workspace or for individual projects.

- **Run all tests:** `zig build test`
- **Run project tests:** `zig build test-<project_name>` (e.g., `zig build test-bank_account`)

### Other Commands

- **List all build steps:** `zig build --help`
- **Install all binaries:** `zig build` (executables will be in `zig-out/bin/`)

## License

This project is licensed under the MIT License. See `LICENSE` for details.
