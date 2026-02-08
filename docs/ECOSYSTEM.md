# Megabyte Labs Ecosystem

This project incorporates design patterns from the [Megabyte Labs](https://megabyte.space) ecosystem. The ecosystem is a set of repositories that integrate with one another through CI/CD. The repositories share configurations, common documentation partials, and developer tools.

## Goals

1. Keep projects up-to-date with the latest best practices
2. Make the management of large amounts of repositories easy
3. Implement development features proactively (within reason)
4. Maximize developer efficiency
5. Improve developer onboarding by providing tools that enforce design patterns with minimal oversight
6. Serve as an example of a bleeding-edge, production-ready full-stack development platform

## How Install Doctor Fits In

Install Doctor is the cornerstone of the Megabyte Labs ecosystem. It provisions developer workstations with all the tools, configurations, and integrations needed to work effectively across the entire ecosystem. When you run Install Doctor, it configures:

- **Development tools** - Language runtimes, compilers, linters, formatters, and build systems
- **Shell environment** - Customized Bash and ZSH configurations with productivity aliases, functions, and plugins
- **Security tooling** - Antivirus, rootkit detection, VPN, and encrypted secrets management
- **Infrastructure tools** - Docker, Vagrant, Terraform, Ansible, and Kubernetes CLI tools
- **CI/CD integration** - GitHub Actions, GitLab CI, and related tooling

## Shared Components

The ecosystem uses several shared components:

- **Taskfile** - All projects use [Task](https://taskfile.dev/) as the build system with shared Taskfile definitions
- **Common configurations** - Linter configs, editor settings, and CI/CD pipelines are synchronized across repos
- **Documentation** - Shared documentation partials and templates ensure consistent documentation
- **Logging** - The `logg` / `gum log` logging functions provide consistent output formatting

## Language Support

Projects in the ecosystem are built with:

- **Shell (Bash/ZSH)** - Provisioning scripts, shell configurations, and system automation
- **TypeScript** - CLI tools, web applications, and the ZX-based software installer
- **Python** - Ansible playbooks and automation scripts
- **Go** - CLI utilities and system tools
