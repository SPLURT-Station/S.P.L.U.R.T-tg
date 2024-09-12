import { CheckboxInputInverse, FeatureToggle } from '../base';

export const classic_rightclick: FeatureToggle = {
  name: 'Classic right-click',
  category: 'GAMEPLAY',
  description:
    'When enabled, will revert to using the right-click context menu by default and use shift-right-click for interactions.',
  component: CheckboxInputInverse,
};
