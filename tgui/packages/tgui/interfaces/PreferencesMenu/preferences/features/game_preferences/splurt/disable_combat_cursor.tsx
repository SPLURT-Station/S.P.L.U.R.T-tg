import { CheckboxInput, type FeatureToggle } from '../../base';

export const disable_combat_cursor: FeatureToggle = {
  name: 'Disable combat cursor',
  category: 'GAMEPLAY',
  description: `
    When toggled, your mouse cursor will not change to a combat
    icon while in combat mode or combat focus.
  `,
  component: CheckboxInput,
};
