---
title: Pull Requests
description: Learn how to contribute to Install Doctor projects or any project in the Megabyte Labs eco-system by opening pull requests the right way, the first time.
sidebar_label: Pull Requests
slug: /contributing/pull-requests
---

Whenever you have changes that you would like to contribute to either [Install Doctor](https://github.com/megabyte-labs/install.doctor), the [Install Doctor site](https://github.com/megabyte-labs/install.doctor-site), the [Install Doctor documentation](https://github.com/megabyte-labs/install.doctor-docs), or any supporting repository in the [Megabyte Labs eco-system](https://gitlab.com/megabyte-labs), you will need to propose the change as a pull request either on GitHub or GitLab.

## Pull Request Branch

When creating a pull request, you will have to create a branch. The branch's name should be prefixed by `pullrequest/` so we can identify branches that are intended to be merged and so we can potentially include CI/CD pipelines that are specific to pull request branches. If you are editting the code directly on GitHub, you will be prompted for the branch name while committing your code. If you want to create a pull request (also known as a merge request on GitLab) from the terminal, you can:

1. Clone the master branch
2. Make changes to the master branch (and test them, obviously)
3. Commit your changes
4. Create a pull request branch from the local master branch by running `git checkout -b pullrequest/branch-name`
5. Push the `pullrequest/branch-name` branch to the origin on either GitLab or GitHub by running `git push origin pullrequest/branch-name`
6. Follow the link given by the commit message, add relevant details to the pull request message, and open the pull request from the GitHub / GitLab web UI. *Be sure to read this page in its entirety to learn about how to leverage pull request message and commit message syntax in order to automate some tasks like closing relevant issues.*

## Commit Messages

In our projects, we leverage git hooks which are hooks that execute whenever you perform certain actions like committing code with git. To ensure that these hooks are enabled for the project, you should run `bash start.sh` whenever starting with a new repository. After running the start script, whenever you commit code, some special things will happen:

1. Formatting and even some technical code patterns will be autofixed
2. The files that are part of the commit will be linted
3. A terminal UI prompt will appear and ask you for input like a commit message, issues that the commit relates to, and the type of commit that it is
4. The commit message is then linted and, for flair, an emoji is automatically added which depends on the type of commit

After all of these things successfully run, you can then push your code with `git push origin pullrequest/branch-name`.

### Bypassing Git Hooks

In some cases, you might want to bypass the git hooks when making a change. To do this, you can use the following format which will bypass all the pre-commit logic:

```shell
HUSKY=0 git commit -m "My commit message" --no-verify
```

That said, you should still make use of the git hooks whenever possible. This will ensure our commit messages are properly linted (as well as the code that is part of the commit).

## Linking Commits / Issues / Pull Requests

In order to automate some of the overhead involved with merging new code, attention should be paid to GitHub / GitLab commit and pull request message formatting.

### GitHub

On GitHub, you can crosslink commits and pull requests to issues they address or fix by adding text in the message that says, "Closes #10," for instance. More details on the syntax that GitHub accepts is on their [Linking a pull request to an issue page](https://docs.github.com/en/issues/tracking-your-work-with-issues/linking-a-pull-request-to-an-issue).

### GitLab

On GitLab, you can crosslink commits to issues, merge requests, and snippets by including the following in your pull request messages (i.e. the text you enter at the pull request web UI screen):

* To reference an issue: #123
* To reference a MR: !123
* To reference a snippet $123

More can be learned by sifting through [GitLab's tutorial on message formatting](https://about.gitlab.com/blog/2016/03/08/gitlab-tutorial-its-all-connected/) and [GitLab's documentation on crosslinking issues](https://docs.gitlab.com/ee/user/project/issues/crosslinking_issues.html). You will learn that you can have an issue automatically closed when the pull request is merged (as well as an issue in another repository) by using the following commit message:

```shell
git commit -m "Awesome commit message (Fixes #21 and Closes group/otherproject#22)"
```

### Automated Linking

When starting off a project, if you run `bash start.sh`, git hooks will be installed. One of these git hooks will guide you through a few inputs that allow you to add your commit message and prompt you for issues that the commit addresses. With these prompts, you can allow the automated prompts handle the crosslinking for you.