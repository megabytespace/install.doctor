---
title: Documentation
description: Find out how the documentation system works for both the markdown files included in the Install Doctor project as well as the Install Doctor documentation portal. Learn how to contribute to the documentation.
sidebar_label: Documentation
slug: /contributing/documentation
---

Documentation is an important part of the process of developing software and tools. We want as many people as possible to be able to leverage our open-source work so all the insider know-how should be documented in both the repository and on the repository's corresponding documentation website.

## In-Repository Documentation

All of our projects include automation scripts that handle mundane tasks like adding styled headers to the README.md and keeping parts of the README.md / CONTRIBUTING.md up-to-date with their upstream sources.

### README.md

Each repository should include a markdown guide stored at `docs/partials/guide.md`. This guide will be injected into the README.md when `bash start.sh` is run. If you are adding features or modifying a repository, this markdown file should be updated with relevant details. Be sure to run the `bash start.sh` script before you commit changes if you made any changes to the documentation.

### Additional Markdown Files

Optionally, if the documentation is lengthy or would be better served as multiple markdown files then you can store additional documentation in the `docs/` folder with the name of the markdown document in all capitals. This document should be linked to from the `docs/partials/guide.md` file using a relative link (rather than a link starting with `https://github.com` or `https://gitlab.com`, for instance).

## Documentation Portal

All of our flagship projects are accompanied by a documentation portal. This page is part of a documentation portal. The documentation portals should contain in-depth information and guides on how to use the given project. If there is any information that could possibly be useful to end-users then that information should be stored in the documentation portal.

Making changes to the documentation portal is easy. All of the documentation pages contain a link that says, "Edit on GitHub." You can use these links to be directed to the markdown file that powers the page that you are editting. There, you can make changes to the documentation and then open a pull request which will then be used to create the page the next time the documentation portal's production files are uploaded to the portal's hosting provider.

### Building the Documentation Portal

For more lengthy or elaborate changes, you might want to test and / or preview changes before opening a pull request. You can do this by:

1. Cloning the repository that is linked to by all the, "Edit on GitHub"
2. Running `bash start.sh` or `npm install` if you want to bypass our automated system
3. Running `npm run serve` for a LiveReload environment where you can see changes you make to the source appear in your browser

### Building the Full Website

The documentation portal only accounts for the `/docs` section of the website. If you want to build the full website, which is required for deploying the full website, you will have to:

1. First, clone the website source code. You can find this by finding the documentation's repository (by referring the link opened when you click, "Edit on GitHub") and replacing the ending of the repository with `-site` instead of `-docs`.
2. Next, clone the `-docs` repository into a folder inside the root of the `-site` repository named `docs`.
3. Then, run `npm run build:production`. This will build the documentation production build first and then build the main site, while including the documentation files into the final bundle.
4. Finally, if you want to deploy the site to Firebase, then you can deploy the site by running `firebase deploy`. *Note: This requires Firebase permission that either needs to be shared or with a property that you own in your own Firebase account, for testing or cloning purposes.*

## Cloning Our Site

If you are using our site as a template for your own personal website / documentation portal, we recommend using Firebase since we have done some work ironing out Firebase-specific details like removing the trailing slash from the URL and ensuring that unfound pages are directed to the appropriate 404 page.

The source of our site is basically a modified rendition of the [CapacitorJS](https://capacitorjs.com/) website. Their [GitHub source code](https://github.com/ionic-team/capacitor-site) is configured to use a CMS SaaS called Prisma which costs hundreds of dollars per month. We have modified the source code to keep all of the data retrieved from Prisma during the build process directly into the source code. So, if you want to edit text on the landing page, for instance, you can edit the text that is stored at the top of the landing page's TypeScript file. This way, there is no dependency on a premium SaaS.

If you like the design of this website, then we highly recommend you use our fork since it introduces a handful of optimizations like better handling of meta tags for SEO, support for `.webp` images (which you must be sure to create when you are adding images), and a wide variety of other perfectionist-level tweaks. If you find our work useful, please consider opening a pull request with any improvements you might be able to offer!