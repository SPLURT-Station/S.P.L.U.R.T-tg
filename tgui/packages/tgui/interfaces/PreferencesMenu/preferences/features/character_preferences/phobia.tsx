import type { FeatureChoiced } from '../base';
import { FeatureDropdownInput } from '../dropdowns';

export const phobia: FeatureChoiced = {
  name: 'Phobia',
  component: FeatureDropdownInput,
};

export const secondary_phobia: FeatureChoiced = {
  name: 'Secondary Phobia',
  component: FeatureDropdownInput,
};

export const tertiary_phobia: FeatureChoiced = {
  name: 'Tertiary Phobia',
  component: FeatureDropdownInput,
};
