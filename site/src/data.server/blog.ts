import type { MapParamData } from '@stencil/router';
import fs from 'fs';
import { join } from 'path';
import { parseMarkdown, MarkdownResults, JsxAstNode } from '@stencil/ssg/parse';

const repoRootDir = join(__dirname, '..', '..');
const blogDir = join(repoRootDir, 'pages', 'blog');

export interface BlogData extends MarkdownResults {
  authorName?: string;
  authorEmail?: string;
  authorUrl?: string;
  authorImageName?: string;
  authorDescription?: string;
  description?: string;
  featuredImage?: string;
  featuredImageAlt?: string;
  date?: string;
  preview?: boolean;
  announcement_bar?: any;
  tags?: string;
  modifiedDate?: string | boolean;
}

export const getAllBlogData: any = async () => {
  const results: BlogData[] = [];
  const fileNames = fs.readdirSync(blogDir);

  await Promise.all(
    fileNames.map(async (file) => {
      const fileName = file.split('.')[0];
      const page = await getFormattedData(fileName, true);

      results.push(page);
    })
  );

  results.sort((a: BlogData, b: BlogData) => {
    if (a.date > b.date) return -1;
    if (a.date < b.date) return 1;
    return 0;
  });

  return results;
};

export const getBlogData: MapParamData = async ({ slug }) => {
  return getFormattedData(slug);
};

const getFormattedData = async (slug: string, preview = false) => {
  const opts = getParseOpts(slug, preview);
  const blogPath = join(blogDir, slug);
  let results: BlogData = await parseMarkdown(blogPath, opts);

  const authorString = results.attributes.author;
  const emailIndex = authorString.indexOf('<');
  results.authorName = authorString.slice(0, emailIndex).trim();
  results.authorEmail = authorString.slice(emailIndex + 1, authorString.indexOf('>')).trim();
  results.authorUrl = results.attributes.authorUrl;
  results.tags = results.attributes.tags;
  results.authorImageName = results.attributes.authorImageName;
  results.authorDescription = results.attributes.authorDescription;

  results.date = new Date(results.attributes.date).toISOString();
  if (results.attributes.modifiedDate) {
    results.modifiedDate = new Date(results.attributes.modifiedDate).toISOString();
  } else {
    results.modifiedDate = false;
  }

  results.featuredImage = results.attributes.featuredImage;
  results.featuredImageAlt = results.attributes.featuredImageAlt;

  results.preview = hasPreviewMarker(results.ast);

  results.slug = results.attributes.slug || slug;

  results = updateAnchors(results, slug);

  results.announcement_bar = null;

  return results;
};

const updateAnchors = (results: BlogData, slug: string) => {
  const { anchors } = results;
  // ast = ast.map((node: JsxAstNode) => updateAnchorJsx(node, slug));

  results.anchors = anchors.map(({ text, href }) => {
    if (!href) return;

    return {
      text,
      href: href.replace('$POST', `/blog/${slug}`),
    };
  });

  return results;
};

const updateAnchorJsx = (node: JsxAstNode, slug: string) => {
  if (!node) return;

  if (node[0] === 'a') {
    const props = node[1];

    if (props.hasOwnProperty('href') && props.href.includes('$POST')) {
      node[1].href = props.href.replace('$POST', `/blog/${slug}`);
    }

    return node;
  }

  if (Array.isArray(node) && node.length > 0) {
    return node.map((node: JsxAstNode) => updateAnchorJsx(node, slug));
  }

  return node;
};

const hasPreviewMarker = (ast: JsxAstNode[]) => {
  const hasPreview = ast.find((item) => item[0] === 'preview-end');

  return !!hasPreview;
};

const getParseOpts = (slug: string, preview: boolean) => {
  if (preview) {
    return {
      async beforeHtmlSerialize(frag: DocumentFragment) {
        if (frag.querySelector('preview-end')) {
          const notInPreview = frag.querySelectorAll('preview-end ~ *');
          // const h1s = frag.querySelectorAll('h1');

          // h1s.forEach(h1 => {
          //   const h2 = frag.createElement('h2');
          //   h2.innerHTML = h1.innerHTML;
          //   h1.parentNode.replaceChild(h1, h2);
          // });

          notInPreview.forEach((el) => el.remove());

          hookUpDesignSystem(frag);
          interpolatePostLink(frag, slug);
        }
      },
    };
  } else {
    return {
      headingAnchors: true,
      beforeHtmlSerialize(frag: DocumentFragment) {
        const previewSelector = frag.querySelector('preview-end');
        previewSelector?.remove();

        hookUpDesignSystem(frag);
        interpolatePostLink(frag, slug);
      },
    };
  }
};

export const hookUpDesignSystem = (frag: DocumentFragment) => {
  const headings = frag.querySelectorAll('h1, h2, h3, h4, h5, h6');
  const paragraphs = frag.querySelectorAll('p:not([class*="ui-paragraph"]):not([class*="ui-heading"])');
  const links = frag.querySelectorAll('a');
  const listsItems = frag.querySelectorAll('ul li, ol li');

  headings.forEach((heading) => {
    const level = heading.nodeName?.split('')[1];

    heading.classList.add(`ui-heading`);
    heading.classList.add(`ui-heading-${level}`);
    heading.classList.add(`ui-theme--editorial`);
  });

  paragraphs.forEach((paragraph) => {
    paragraph.classList.add(`ui-paragraph`);
    paragraph.classList.add(`ui-paragraph--prose`);
    paragraph.classList.add(`ui-paragraph-3`);
  });

  listsItems.forEach((paragraph) => {
    paragraph.classList.add(`ui-paragraph`);
    paragraph.classList.add(`ui-paragraph--prose`);
    paragraph.classList.add(`ui-paragraph-3`);
  });

  links.forEach((link) => {
    link.rel = 'noopener';
    link.target = '_blank';
  });

  return frag;
};

export const interpolatePostLink = (frag: DocumentFragment, slug: string) => {
  const links = frag.querySelectorAll('a');

  links.forEach((link) => {
    link.href = link.href.replace('$POST', `/blog/${slug}`);
    link.target = '_blank';
  });
};
