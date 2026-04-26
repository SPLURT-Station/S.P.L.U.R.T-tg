import {
  type Feature,
  type FeatureChoiced,
  FeatureShortTextInput,
} from '../../base';
import { FeatureDropdownInput } from '../../dropdowns';

export const exoresp_gas: FeatureChoiced = {
  name: 'Gas Selection',
  component: FeatureDropdownInput,
};
