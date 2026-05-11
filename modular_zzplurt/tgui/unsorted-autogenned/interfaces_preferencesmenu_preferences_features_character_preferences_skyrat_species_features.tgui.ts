import { block, type ModularTguiPatch } from '../../modules/tgui_modular/index';

export const modularTgui = true;

export const overrides = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui/interfaces/PreferencesMenu/preferences/features/character_preferences/skyrat/species_features.tsx',
		operations: [
			{
				kind: "replace",
				anchor: block`
				  name: 'Floral Hair Emissive',
				  description: 'Emissive parts glow in the dark.',
				  component: CheckboxInput,
				};
				
				`,
				content: block`
				  name: 'Floral Hair Emissive',
				  description: 'Emissive parts glow in the dark.',
				  component: CheckboxInput,
				};
				
				export const mandibles_toggle: FeatureToggle = {
				  name: 'Mandibles',
				  component: CheckboxInput,
				};
				
				export const feature_mandibles: Feature<string> = {
				  name: 'Mandible Selection',
				  component: (
				    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
				  ) => {
				    return <FeatureDropdownInput buttons {...props} />;
				  },
				};
				
				export const mandibles_color: Feature<string[]> = {
				  name: 'Mandible Color',
				  component: FeatureTriColorInput,
				};
				
				export const spinneret_toggle: FeatureToggle = {
				  name: 'Spinneret',
				  component: CheckboxInput,
				};
				
				export const feature_spinneret: Feature<string> = {
				  name: 'Spinneret Selection',
				  component: (
				    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
				  ) => {
				    return <FeatureDropdownInput buttons {...props} />;
				  },
				};
				
				export const spinneret_color: Feature<string[]> = {
				  name: 'Mandible Color',
				  component: FeatureTriColorInput,
				};
				
				export const arachnid_legs_toggle: FeatureToggle = {
				  name: 'Arachnid Legs',
				  component: CheckboxInput,
				};
				
				export const feature_arachnid_legs: Feature<string> = {
				  name: 'Arachnid Leg Selection',
				  component: (
				    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
				  ) => {
				    return <FeatureDropdownInput buttons {...props} />;
				  },
				};
				
				export const arachnid_legs_color: Feature<string[]> = {
				  name: 'Arachnid Leg Color',
				  component: FeatureTriColorInput,
				};
				
				`,
				expectedOccurrences: 1,
			},
		],
	},
];
