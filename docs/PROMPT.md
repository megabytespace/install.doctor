---
title: Shell Script Guidelines
description: Guidelines and best practices for writing and maintaining shell scripts in the Install Doctor project.
sidebar_label: Shell Script Guidelines
slug: /prompt
---

# Shell Script Guidelines

This document describes the coding conventions and best practices used throughout the Install Doctor shell scripts.

## Variable Naming

- **Environment variables and constants**: Use UPPERCASE with underscores (e.g., `SUDO_PASSWORD`, `SOFTWARE_GROUP`)
- **Local variables**: Use lowercase or camelCase within functions (e.g., `exitCode`, `tmpDir`)
- **Export variables** that need to be available to child processes

## Error Handling

- Use `set -eo pipefail` at the top of scripts to catch errors early
- Capture exit codes with `|| EXIT_CODE=$?` when a command failure should not terminate the script
- Always provide fallback behavior or meaningful error messages when commands fail
- Use `timeout` to prevent commands from hanging indefinitely

## Non-Interactive Execution

All scripts must support fully automated, headless execution:

- Every interactive prompt must have a timeout (default: 30 seconds)
- Check for `HEADLESS_INSTALL` environment variable to skip prompts entirely
- Use `--noconfirm` (pacman), `-y` (apt-get, dnf, yum), or equivalent flags for package managers
- Pipe `echo |` to Homebrew install to bypass its confirmation prompt

## Logging

Use the `logg` function for all output:

- `logg info "message"` - Informational messages
- `logg warn "message"` - Warning messages
- `logg error "message"` - Error messages
- `logg success "message"` - Success messages
- `logg star "message"` - Highlighted messages
- `logg md "file.md"` - Render markdown files

## Platform Detection

Use standard detection patterns:

```bash
# macOS
if [ -d /Applications ] && [ -d /System ]; then

# Linux distribution detection
if [ -f /etc/debian_version ]; then      # Debian/Ubuntu
if [ -f /etc/redhat-release ]; then      # RHEL/CentOS/Fedora
if [ -f /etc/arch-release ]; then        # Archlinux
if [ -f /etc/alpine-release ]; then      # Alpine

# Package manager detection (fallback)
if command -v apt-get > /dev/null; then
if command -v dnf > /dev/null; then
```

## Documentation

- Use `# @file`, `# @brief`, `# @description` JSDoc-style comments for file headers
- Use `# @description` for function documentation
- Document environment variables with `@envvar`
- Document parameters with `@arg`
