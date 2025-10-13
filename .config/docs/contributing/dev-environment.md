## Setting Up Development Environment

Before contributing to this project, you will have to make sure you have the tools that are utilized. We have made it incredibly easy to get started - just run `bash .start.sh` in the root of the repository. Most of the requirements (listed below) will automatically install (rootlessly) if they are missing from your system when you initialize the project by running `bash .start.sh`.

### Requirements

- **[Task](https://github.com/ProfessorManhattan/ansible-task)**
- **[Python 3](https://github.com/ProfessorManhattan/ansible-python)**, along with the `python3-netaddr` and `python3-pip` libraries (i.e. `sudo apt-get install python3 python3-netaddr python3-pip`)
- **[Docker](https://github.com/ProfessorManhattan/ansible-docker)**
- **[Node.js](https://github.com/ProfessorManhattan/ansible-nodejs)** >=12 which is used for the development environment which includes a pre-commit hook
- **[VirtualBox](https://github.com/ProfessorManhattan/ansible-virtualbox)** which is used for running Molecule tests

Docker and VirtualBox must be installed with root privileges. If they are missing from your system, running `bash .start.sh` will prompt you for your password and automatically install them. Otherwise, you can follow the official [directions for installing Docker](https://docs.docker.com/get-docker/) and [directions for installing VirtualBox](https://www.virtualbox.org/manual/ch02.html).

### Getting Started

With all the requirements installed, navigate to the root directory and run the following command to set up the development environment which includes installing the Python dependencies and installing the Ansible Galaxy dependencies:

```terminal
bash .start.sh
```

This will install all the dependencies and automatically register a pre-commit hook. More specifically, `bash .start.sh` will:

1. Install Task which provides an easy-to-use interface for performing common tasks while leveraging parallel execution
2. Install missing development tools like Node.js and Python
3. Install the Node.js development environment dependencies
4. Install a pre-commit hook using [husky]({{ misc.husky }})
5. Ensure that meta files and documentation are up-to-date
6. Install the Python 3 requirements
7. Install the Ansible Galaxy requirements
8. Re-generate documentation using the latest sources
9. Perform other miscellaneous tasks depending on the project type

### Tasks Available

With the dependencies installed, you can see a list of the available commands by running `task --list`. This will log a help menu to the console informing you about the available commands and what they do. After running the command, you will see something that looks like this:

```shell
❯ task --list

{{ task_list_output }}
```

Using the information provided above by running `task --list`, we can see that the `task lint:all` command will lint the project with all the available linters. You can see exactly what each command is doing by checking out the `Taskfile.yml` file (and following the imports). You can also get a detailed summary of any task reported by `task --list` by running `task group:task-name --summary`.
