import { CheckboxInput, type FeatureToggle } from '../../base';

export const intents: FeatureToggle = {
  name: 'Intents',
  category: 'GAMEPLAY',
  description: 'When enabled, use old intents instead of combat mode.',
  component: CheckboxInput,
};
