import type {
  Feature,
  FeatureChoicedServerData,
  FeatureValueProps,
} from '../../base';
import { FeatureDropdownInput } from '../../dropdowns';

export const eye_type: Feature<string> = {
  name: 'Eye style',
  description: 'Select the eye sprite style for your character.',
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    return <FeatureDropdownInput buttons {...props} />;
  },
};
