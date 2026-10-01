import { FeatureNumberInput, type FeatureNumeric } from '../../base';

export const cyborg_size: FeatureNumeric = {
  name: 'Cyborg size (%)',
  description:
    'Applies a resizer after selecting a cyborg module. 100% keeps the standard size. Uses the same limits and chassis restrictions as a resizer installed by robotics.',
  component: FeatureNumberInput,
};
