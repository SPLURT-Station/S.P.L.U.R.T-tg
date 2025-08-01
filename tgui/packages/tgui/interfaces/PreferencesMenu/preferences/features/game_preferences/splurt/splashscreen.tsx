import { CheckboxInput, FeatureToggle } from '../../base';

export const hide_splashscreen: FeatureToggle = {
  name: 'Hide Splashscreen',
  description:
    "Hide the round's splashscreen and show the default splashscreen instead.",
  category: 'UI',
  component: CheckboxInput,
};
