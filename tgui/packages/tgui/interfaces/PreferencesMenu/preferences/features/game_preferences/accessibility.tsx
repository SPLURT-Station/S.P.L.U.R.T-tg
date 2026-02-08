import { CheckboxInput, type FeatureToggle } from '../base';

export const darkened_flash: FeatureToggle = {
  name: 'Enable darkened flashes',
  category: 'ACCESSIBILITY',
  description: `
    When toggled, being flashed will show a dark screen rather than a
    bright one.
  `,
  component: CheckboxInput,
};

export const screen_shake_darken: FeatureToggle = {
  name: 'Darken screen shake',
  category: 'ACCESSIBILITY',
  description: `
      When toggled, experiencing screen shake will darken your screen.
    `,
  component: CheckboxInput,
};

export const recoil_punch_darken: FeatureToggle = {
  name: 'Recoil uses screen dim instead of view punch',
  category: 'ACCESSIBILITY',
  description: `
      When toggled, uses a screen dimming effect in favor of camera
      view punch for gun recoil.
    `,
  component: CheckboxInput,
};

export const remove_double_click: FeatureToggle = {
  name: 'Remove double click',
  category: 'ACCESSIBILITY',
  description: `
      When toggled, actions that require a double click will instead offer
      alternatives, good if you have a not-so-functional mouse.
    `,
  component: CheckboxInput,
};
