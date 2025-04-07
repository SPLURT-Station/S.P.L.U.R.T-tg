import {
  CheckboxInput,
  Feature,
  FeatureChoiced,
  FeatureNumberInput,
  FeatureToggle,
} from '../../base';
import { FeatureDropdownInput } from '../../dropdowns';

export const pregnancy_chance: Feature<number> = {
  name: 'Pregnancy: Chance',
  description:
    'How likely your character is to get pregnant whenever any of their valid genitals gets inseminated.',
  component: FeatureNumberInput,
};

export const pregnancy_duration: Feature<number> = {
  name: 'Pregnancy: Duration',
  description: 'How long, in minutes, your characters pregnancy will last.',
  component: FeatureNumberInput,
};

export const pregnancy_genetic_distribution: Feature<number> = {
  name: 'Pregnancy: Genetic distribution',
  description:
    'How heavily weighed the genetic distribution of your offspring is to your genes. \
    At 100, 100% of your genes are inherited. At 50%, 50% of your genes and 50% of the fathers genes are inherited. \
    At 0%, all of the genes are inherited from the father.',
  component: FeatureNumberInput,
};
export const pregnancy_egg_duration: Feature<number> = {
  name: 'Pregnancy: Egg duration',
  description:
    'How long, in minutes, it takes for an egg laid by your character to hatch.',
  component: FeatureNumberInput,
};

export const pregnancy_oviposition: FeatureToggle = {
  name: 'Pregnancy: Oviposition',
  description:
    'Whether or not your character will lay an egg instead of giving birth.',
  component: CheckboxInput,
};

export const pregnancy_cryptic: FeatureToggle = {
  name: 'Pregnancy: Cryptic',
  description:
    'Cryptic pregnancies cannot be medically detected, no matter the stage.',
  component: CheckboxInput,
};

export const pregnancy_belly_inflation: FeatureToggle = {
  name: 'Pregnancy: Belly inflation',
  description:
    'When toggled, pregnancy will make your characters belly increase in size.',
  component: CheckboxInput,
};

export const pregnancy_insemination_womb: FeatureToggle = {
  name: 'Pregnancy: Womb insemination',
  description: 'When toggled, you cannot get pregnant without a womb.',
  component: CheckboxInput,
};

export const pregnancy_insemination_vagina: FeatureToggle = {
  name: 'Pregnancy: Vaginal insemination',
  description:
    'When toggled, you can get impregnated from vaginal insemination.',
  component: CheckboxInput,
};

export const pregnancy_insemination_anus: FeatureToggle = {
  name: 'Pregnancy: Anal insemination',
  description: 'When toggled, you can get impregnated from anal insemination.',
  component: CheckboxInput,
};

export const pregnancy_insemination_mouth: FeatureToggle = {
  name: 'Pregnancy: Oral insemination',
  description: 'When toggled, you can get impregnated from oral insemination.',
  component: CheckboxInput,
};

export const pregnancy_egg_skin: FeatureChoiced = {
  name: 'Pregnancy: Egg Skin',
  description: 'Type of egg used for oviposition pregnancy.',
  component: FeatureDropdownInput,
};
