import { Fragment, h } from '@stencil/core';
import { Route, createRouter, staticState, match } from '@stencil/router';
import { getBlogData, getAllBlogData } from './data.server/blog';
import { CommunityPageData, defaults, EnterprisePageData, LandingPageData } from './store';

declare let window: any;
window.mobileSliderHero =
  'ontouchstart' in window ||
  navigator.maxTouchPoints > 0 ||
  (navigator as any).msMaxTouchPoints > 0 ||
  window.innerWidth < 1024;
export const Router = createRouter();

export default Router;

export const Routes = () => (
  <Router.Switch>
    <Route
      path="/"
      render={() => (
        <Fragment>
          <landing-page data={LandingPageData} />
        </Fragment>
      )}
    />

    <Route
      path="/blog"
      mapParams={staticState(getAllBlogData)}
      render={(_, data) => (
        <Fragment>
          <blog-page
            defaults={defaults}
            data={data instanceof Map ? Object.values(Object.fromEntries(data))[0] : data}
          />
        </Fragment>
      )}
    />

    <Route
      path={match('/blog/:slug*')}
      mapParams={staticState(getBlogData)}
      render={(_, data) => (
        <Fragment>
          <blog-post
            defaults={defaults}
            data={data instanceof Map ? Object.values(Object.fromEntries(data))[0] : data}
          />
        </Fragment>
      )}
    />

    <Route
      path="/community"
      render={() => {
        return (
          <Fragment>
            <community-page data={CommunityPageData} />
          </Fragment>
        );
      }}
    />

    <Route
      path="/terms"
      render={() => (
        <Fragment>
          <terms-service-page defaults={defaults} />
        </Fragment>
      )}
    />

    <Route
      path="/privacy"
      render={() => (
        <Fragment>
          <privacy-policy-page defaults={defaults} />
        </Fragment>
      )}
    />

    <Route
      path="/enterprise"
      render={() => (
        <Fragment>
          <enterprise-page data={EnterprisePageData} />
        </Fragment>
      )}
    />

    <Route
      path={match('/solution/:solutionId*')}
      render={(params) => (
        <Fragment>
          <solution-page solutionId={params.solutionId} defaults={defaults} />
        </Fragment>
      )}
    />

    <Route
      path={match('/:nada')}
      render={() => (
        <Fragment>
          <not-found-page defaults={defaults} />
        </Fragment>
      )}
    />

    <Route
      path={match('/:bada/:bing')}
      render={() => (
        <Fragment>
          <not-found-page defaults={defaults} />
        </Fragment>
      )}
    />

    <Route
      path={match('/:big/:giant/:elevator')}
      render={() => (
        <Fragment>
          <not-found-page defaults={defaults} />
        </Fragment>
      )}
    />
  </Router.Switch>
);

Router.on('change', (newUrl, oldUrl) => {
  if (window.revapi4) {
    window.revapi4.revkill();
  }
  if (newUrl.pathname === '/') {
    document.body.classList.add('home');
    if (window.revapi2) {
      window.revapi2.revredraw();
    }
  } else {
    document.body.classList.remove('home');
    if (window.revapi2) {
      window.revapi2.revpause();
    }
  }
  requestAnimationFrame(() => window.scrollTo(0, 0));
  if (newUrl.hash) {
    const id = newUrl.hash.slice(1);
    setTimeout(() => {
      const el = document.getElementById(id);
      if (el) {
        el.scrollIntoView && el.scrollIntoView();
      }
    }, 50);
  }
});
