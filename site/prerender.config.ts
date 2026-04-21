import { PrerenderConfig } from '@stencil/core';

export const config: PrerenderConfig = {
  hydrateOptions() {
    return {
      timeout: 30000,
    };
  },
  filterUrl(url) {
    if (url.pathname.includes('/docs')) {
      return false;
    }
    return true;
  },
  entryUrls: ['/', '/404.html'],
  // normalizeUrl(href, base) {
  //   // temp fix for absolute paths with /docs/v3
  //   href = href.replace('v3/v3', 'v3');
  //   return new URL(href, base);
  // },
};
