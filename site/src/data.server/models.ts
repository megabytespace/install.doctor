import { Document as PrismicDocument } from 'prismic-javascript/d.ts/documents';
import ApiSearchResponse from 'prismic-javascript/d.ts/ApiSearchResponse';
import { PageNavigation, MarkdownResults, TableOfContents } from '@stencil/ssg/parse';

export interface PrismicDocsResponse {
  docs: PrismicDocument[];
  _prismic: ApiSearchResponse;
}

export interface BlogPostDocument extends PrismicDocument {}

export interface BlogPostsResponse extends PrismicDocsResponse {}

export interface DocsData extends MarkdownResults {
  contributors?: string[];
  lastUpdated?: string;
  navigation?: PageNavigation;
  editUrl?: string;
  editApiUrl?: string;
  tableOfContents?: TableOfContents;
  template?: DocsTemplate;
  announcement_bar?: any;
  canonicalUrl?: string;
}

export type DocsTemplate = 'docs' | 'plugins' | 'cli';
