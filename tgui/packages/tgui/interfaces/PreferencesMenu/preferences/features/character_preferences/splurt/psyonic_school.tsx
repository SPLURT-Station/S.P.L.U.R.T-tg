import type { FeatureChoiced } from '../../base';
import { FeatureDropdownInput } from '../../dropdowns';

export const psyonic_school: FeatureChoiced = {
  name: 'School',
  description: 'Choose a school, abilities of which you shall receive.',
  component: FeatureDropdownInput,
};

export const psyonic_school_secondary: FeatureChoiced = {
  name: 'Secondary School',
  description:
    'Choose a secondary school. Abilities from it will be less powerful.',
  component: FeatureDropdownInput,
};
