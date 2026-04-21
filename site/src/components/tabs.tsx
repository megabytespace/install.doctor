import { VNode, h } from '@stencil/core';

interface TabsProps {
  [key: string]: string;
}

const Tabs = (_props: TabsProps, children: VNode) => <div class="ui-tabs">{children}</div>;

const TabBar = (_: any, children: VNode) => <div class="ui-tab-bar">{children}</div>;

interface TabBarButtonProps {
  tabSelect: () => void;
  selected: boolean;
}
const TabBarButton = ({ tabSelect, selected }: TabBarButtonProps, children: VNode) => (
  <div class={`ui-tab-bar__button${selected ? ' ui-tab-bar__button--selected' : ''}`} onClick={tabSelect}>
    {children}
  </div>
);

interface TabProps {
  selected: boolean;
  [key: string]: any;
}
const Tab = ({ selected }: TabProps, children: VNode) => (
  <div class="ui-tab" style={{ display: selected ? 'block' : 'none' }}>
    {children}
  </div>
);

export { Tabs, Tab, TabBar, TabBarButton };
