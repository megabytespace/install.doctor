<!-- ⚠️ This README has been generated from the file(s) ".config/docs/blueprint-contributing.md" ⚠️--><div align="center">
  <center><h1 align="center">Contributing Guide</h1></center>
</div>

First of all, thanks for visiting this page 😊 ❤️ ! We are _stoked_ that you may be considering contributing to this project. You should read this guide if you are considering creating a pull request or plan to modify the code for your own purposes.

<a href="#table-of-contents" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Overview](#overview)
  - [List Build Tool Commands](#list-build-tool-commands)
  - [Dotfiles](#dotfiles)
- [Architecture](#architecture)
- [Preferred Libraries](#preferred-libraries)
  - [Logger](#logger)
  - [CLI / Help Menu](#cli--help-menu)
  - [Interactive CLI Prompts](#interactive-cli-prompts)
  - [Data Model Validation](#data-model-validation)
  - [Update Notifier](#update-notifier)
  - [Environment Variables](#environment-variables)
- [ESLint](#eslint)
  - [Disabling ESLint Features](#disabling-eslint-features)
- [Testing](#testing)
  - [Using `npm link`](#using-npm-link)
- [Pull Requests](#pull-requests)
  - [How to Commit Code](#how-to-commit-code)
  - [Pre-Commit Hook](#pre-commit-hook)
- [Style Guides](#style-guides)
  - [Recommended Style Guides](#recommended-style-guides)
  - [Strict Linting](#strict-linting)
- [Contributors](#contributors)

<a href="#code-of-conduct" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Code of Conduct

This project and everyone participating in it is governed by the [Code of Conduct](https://github.com/megabyte-labs/install.doctor/blob/master/docs/CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to [help@megabyte.space](mailto:help@megabyte.space).

<a href="#overview" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Overview

This repository uses a customized starting template that is inspired by the [TypeScript Starter](https://github.com/bitjson/typescript-starter) project on GitHub. It includes many different build tools and files meant to improve team efficiency. All of the code and assets are stored in the `src/` folder. All of our NPM packages should follow the same format and use the same design patterns so it is important to check out a few of [our NPM repositories](https://gitlab.com/megabyte-labs/npm) before diving into the code. Our [Buildr](repository.project.buildr) project is a great example of what we are looking for.

After you clone this repository, you can get started by running `npm i` (with [Node.js >9](repository.project.node) installed). This will install the dependencies as well as perform a few maintenance tasks such as synchronizing the common development-related dotfiles and re-generating the documentation.

### List Build Tool Commands

After you run `npm i`, you can view the available pre-defined build tool commands by running `npm run info`. A chart will be displayed in your terminal that looks something like this:

```
❯ npm run info

> @mblabs/install-doctor@1.0.4 info
> npm-scripts-info

build:
  Clean and rebuild the project
commit:
  Automatically fix errors and guides you through the commit process
cov:
  Rebuild, run tests, then create and open the coverage report
doc:json:
  Generate API documentation in typedoc JSON format
doc:
  Generate HTML API documentation and open it in a browser
fix:
  Try to automatically fix any linting problems
info:
  Display information about the package scripts
prepare-release:
  One-step: clean, build, test, publish docs, and prep a release
reset:
  Delete all untracked files and reset the repo to the last commit
test:
  Lint and unit test the project
version:
  Bump package.json version, update CHANGELOG.md, tag release
watch:
  Watch and rebuild the project on save, then rerun relevant tests
```

You should then realize that you can build the project by running `npm run build` or test the project by running `npm run test`.

### Dotfiles

As you may have noticed, this project contains many files in the root directory. Many of these files are dotfiles. These files are intended to help our team of developers create code that is consistent and also compliant with industry best practices. Most of the dotfiles (and dot-folders) are synchronized across all of [our NPM packages](https://gitlab.com/megabyte-labs/npm). This means that any changes you make to the dotfiles will eventually be over-written. If you need to make a change to any of the dotfiles, you will have to open a pull request against our [common NPM files repository](https://gitlab.com/megabyte-labs/common/npm). Bear in mind that any changes you make to the common NPM files will be propagated to all of our NPM repositories.

<a href="#architecture" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Architecture

For the most part, when working on one of our NPM packages, all of the code should be placed in the `src/` folder. Usually, at the minimum, the `src/` folder will contain:

- **`app.ts`** - This is the main starting file for the project. This is the file that should house the main logic and any bootstrapping that needs to be done.
- **`cli.ts`** - Entry point for CLI commands. If the project supports CLI commands, then you should handle the logic for the CLI and help menu in this file.
- **`index.ts`** - Entry point to the package for other packages that are including it as a dependency. This is where you would export methods that you want to expose publicly.

We adhere to strict design-patterns across all of our NPM packages. In order for you to get a feel for what we are looking for, you should browse through our [`Buildr`](repository.project.buildr) project's files. After browsing through the Buildr project's source code, you will notice that we include other files/folders in the `src/` folder:

- `constants/` - This folder houses all the constant variables used in the project. The constants are generally seperated out into different files based on where they are being used in the application.
- `lib/` - This folder contains all the pieces of the app that would generally be utilized by the `app.ts` file.
- `models/` - This folder contains all of the data models that are used. Data models are important to use especially in larger projects because they provide type definitions and also open the door to data validation which is touched on in the [Preferred Libraries](#preferred-libraries) section.
- `tsconfig.json` - This file is included to address a Visual Studio Code bug that occurs if you open the `src/` directory and not the root folder

When building a new project, try to follow the same design patterns that are used by the [`Buildr`](repository.project.buildr) project. In most cases, all of the aforementioned files and folders should be part of the project.

<a href="#preferred-libraries" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Preferred Libraries

A lot of research has gone into determining what the best tool is for each common task that gets performed. These tasks can range from generating a CLI help menu to validating user inputs. You can browse through the dependencies in the `package.json` file of our [NPM package starting template](https://gitlab.com/megabyte-labs/templates/npm) to get a better idea of what we prefer.

### Logger

If you browsed through the `package.json` file mentioned above, you will see that we are including `pino` and `pino-pretty` as dependencies. Both should be used to handle all logging. There should be no `console.log` commands in the project. Instead, all of the logging should be handled by a Logger class. You can see an [example provided by the Buildr project here](https://gitlab.com/megabyte-labs/npm/buildr/-/blob/master/src/lib/log.ts). When creating a Logger class, feel free to copy and paste from the linked Buildr Logger class file.

### CLI / Help Menu

[Commander.js](https://www.npmjs.com/package/commander) is the leading solution for handling CLI commands and generating terminal help menus. The library is included in the aforementioned starting template and should be used in any project that includes CLI command capabilities or CLI help menus. Using this library is not a hard requirement but any deviations from it should be approved by the project's maintainer.

### Interactive CLI Prompts

[Inquirer.js](https://www.npmjs.com/package/inquirer) is our preferred library for providing enhanced CLI prompts. You might choose to use this library if part of the app includes prompting the user for different values. Browsing through the capabilities of Inquirer.js using the link provided is highly encouraged. If you are not utilizing this dependency then it should be removed from the `package.json`. The same goes for any package that is unused - if it is not being used then throw it out!

### Data Model Validation

One feature we like to include in all of our projects that rely on any input parameters is data validation. For instance, if one of the parameters that is passed in is supposed to be a FQDN and the user passes in a string that does not match the RegEx of a FQDN, then the user should be notified with a simple, well-formatted error message (which is generated by `pino`). We accomplish this by leveraging the [`class-validator`](https://www.npmjs.com/package/class-validator) library. There are tons of examples provided on their page and we highly encourage you to get comfortable using the library by checking out the link.

In order to utilize `class-validator`, you have to assign all input data to a model. The model is then set up to use `class-validator` decorators on each attribute. With the data model populated, you can use the `class-validator` library to validate the input. Take the following as an example:

```
import { validate, IsInt, IsFQDN, Min, Max } from 'class-validator';

export class Post {
  @IsInt() // This is a decorator
  @Min(0)
  @Max(10)
  rating: number;

  @IsFQDN()
  site: string;
}

let post = new Post();
post.rating = 11;          // Should not pass validation
post.site = 'googlecom';   // Should not pass validation

validate(post).then(errors => {
  // errors is an array of validation errors
  if (errors.length > 0) {
    console.log('validation failed. errors: ', errors);
  } else {
    console.log('validation succeed');
  }
});
```

Using the library above can provide real value to our users. By validating the data before running any business logic, we can save the user time by taking out the guess work required for debugging. Please note that in practice, the `Post` model/class would be seperated into a file stored in `src/models/post.model.ts`.

**All data inputs should utilize this form of validation.** If the `class-validator` project does not provide a decorator that can properly validate the input data then you can extend the library by creating a custom validation decorator. There is an [example of how to create a custom validator in the Buildr project](https://gitlab.com/megabyte-labs/npm/buildr/-/blob/master/src/lib/validators/is-true.validator.ts).

### Update Notifier

As a feature meant to make our packages stand out from the crowd, we prefer that you incorporate [`update-notifier`](https://www.npmjs.com/package/update-notifier) in the project to notify users of any updates to the NPM package.

### Environment Variables

In some cases, a package might rely on sensitive data that should not be included in git repositories. In this case, you may choose to utilize environment variables. If that is the case, then please include support for [dotenv](https://www.npmjs.com/package/dotenv) which allows users to load environment variables by defining a `.env` file. The users can then add `.env` to their `.gitignore` file to keep the `.env` file out of their project's repository.

<a href="#eslint" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## ESLint

In the root of this project, you will see a file titled `.eslintrc`. This file controls how [ESLint](https://eslint.org/) works. As mentioned in the [Overview](#overview), our `.eslintrc` file is shared across all of [our NPM packages](https://gitlab.com/megabyte-labs/npm). If you make changes to the `.eslintrc` file then they will be overwritten. Instead, if you absolutely need to change the `.eslintrc` file's definitions, then you should open up a pull request against the repository that houses all of the [common NPM package files](https://gitlab.com/megabyte-labs/common/npm).

### Disabling ESLint Features

Instead of changing the `.eslintrc` file, we prefer that you instruct ESLint to disable checks for a specific rule on a specific line. For example, if you want to disable the `no-console` rule for one line of code, then you could accomplish this by modifying the code to follow the format below:

```
/* eslint-disable no-console */
console.log('foo');
/* eslint-enable no-console */
```

The above method is preferred over disabling all ESLint features. For example, we prefer that you never disable all checks on a line like this:

```
/* eslint-disable */
console.log('bar');
/* eslint-enable */
```

It is important that you include the second `/* eslint-enable */` line so that ESLint does not remain disabled for the rest of the file. Do not do this but, for your information, you can disable ESLint for an entire file by placing `/* eslint-disable */` at the top of the file.

**You should fix the lint error instead of using `/* eslint-disable */` whenever possible.**

For more details, see the [official ESLint docs](https://eslint.org/docs/2.13.1/user-guide/configuring#disabling-rules-with-inline-comments).

<a href="#testing" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Testing

For each feature in an NPM package, some basic unit tests should be added. Although it may seem trivial for a new project, the unit tests can be helpful for spotting regressions when the project grows or when it is refactored years down the line. You can check out some examples of unit tests by checking out the `*.spec.ts` files listed on [this TypeScript Starter page](https://github.com/bitjson/typescript-starter/tree/master/src/lib).

### Using `npm link`

If you are creating a CLI, it is possible to install the module for testing before you publish the module to npm. After running `npm i && npm run build`, you can then run `npm link` in the root of the project. You can then access the app from its' shortcut defined in `package.json` under the `"bin"` value.

Take the following as an example:

**package.json**

```
{
    "name": "@megabytelabs/myapp",
    "bin": {
        "myclicommand": "bin/cli"
    },
}
```

Running `npm link` with the `package.json` configuration listed above will install the app so that it is accessible by running `myclicommand`.

<a href="#pull-requests" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Pull Requests

All pull requests should be associated with issues. You can find the [issues board on GitLab](https://gitlab.com/megabyte-labs/docker/install-doctor/-/issues). The pull requests should be made to [the GitLab repository](https://gitlab.com/megabyte-labs/docker/install-doctor) instead of the [GitHub repository](ProfessorManhattan/npm-install-doctor). This is because we use GitLab as our primary repository and mirror the changes to GitHub for the community.

### How to Commit Code

Instead of using `git commit`, we prefer that you use `npm run commit`. You will understand why when you try it but basically it streamlines the commit process and helps us generate better CHANGELOG files.

### Pre-Commit Hook

Even if you decide not to use `npm run commit`, you will see that `git commit` behaves differently because there is a pre-commit hook that installs automatically after you run `npm i`. This pre-commit hook is there to test your code before committing and help you become a better coder. If you need to bypass the pre-commit hook, then you may add the `--no-verify` tag at the end of your `git commit` command (e.g. `git commit -m "Commit" --no-verify`).

<a href="#style-guides" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Style Guides

All code projects have their own style. Coding style will vary from coder to coder. Although we do not have a strict style guide for each project, we do require that you be well-versed in what coding style is most acceptable and _best_. To do this, you should read through style guides that are made available by organizations that have put a lot of effort into studying the reason for coding one way or another.

### Recommended Style Guides

Style guides are generally written for a specific language but a great place to start learning about the best coding practices is on [Google Style Guides](https://google.github.io/styleguide/). Follow the link and you will see style guides for most popular languages. We also recommend that you look through the following style guides, depending on what language you are coding with:

- [Airbnb JavaScript Style Guide](https://github.com/airbnb/javascript)
- [Angular Style Guide](https://angular.io/guide/styleguide)
- [Effective Go](https://go.dev/doc/effective_go)
- [PEP 8 Python Style Guide](https://www.python.org/dev/peps/pep-0008/)
- [Git Style Guide](https://github.com/agis/git-style-guide)

For more informative links, refer to the [GitHub Awesome Guidelines List](https://github.com/Kristories/awesome-guidelines).

### Strict Linting

One way we enforce code style is by including the best standard linters into our projects. We normally keep the settings pretty strict. Although it may seem pointless and annoying at first, these linters will make you a better coder since you will learn to adapt your style to the style of the group of people who spent countless hours creating the linter in the first place.

{{ load:.config/docs/common/contributing/troubleshooting.md }}

<a href="#contributors" style="width:100%"><img style="width:100%" src="https://gitlab.com/megabyte-labs/assets/-/raw/master/png/aqua-divider.png" /></a>

## Contributors

Thank you so much to our contributors!

contributors_list
