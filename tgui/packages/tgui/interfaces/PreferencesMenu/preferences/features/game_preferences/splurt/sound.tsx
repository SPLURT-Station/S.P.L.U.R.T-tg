import {
  type FeatureChoiced,
} from '../../base';
import { FeatureDropdownInput } from '../../dropdowns';

export const preferred_announcer: FeatureChoiced = {
  name: 'Announcer Preference',
  category: 'SOUND',
  description: 'Choose which announcer you\'d like hear.',
  component: FeatureDropdownInput,
};
