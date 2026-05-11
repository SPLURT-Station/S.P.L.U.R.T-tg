import type { ModularTguiPatch } from '../.';

export const modularTgui = true;

export const overrides = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui/interfaces/PreferencesMenu/preferences/features/character_preferences/skyrat/species_features.tsx',
		operations: [
			{
				kind: "replace",
				anchor: "  name: 'Floral Hair Emissive',\n  description: 'Emissive parts glow in the dark.',\n  component: CheckboxInput,\n};\n",
				content: "  name: 'Floral Hair Emissive',\n  description: 'Emissive parts glow in the dark.',\n  component: CheckboxInput,\n};\n\nexport const mandibles_toggle: FeatureToggle = {\n  name: 'Mandibles',\n  component: CheckboxInput,\n};\n\nexport const feature_mandibles: Feature<string> = {\n  name: 'Mandible Selection',\n  component: (\n    props: FeatureValueProps<string, string, FeatureChoicedServerData>,\n  ) => {\n    return <FeatureDropdownInput buttons {...props} />;\n  },\n};\n\nexport const mandibles_color: Feature<string[]> = {\n  name: 'Mandible Color',\n  component: FeatureTriColorInput,\n};\n\nexport const spinneret_toggle: FeatureToggle = {\n  name: 'Spinneret',\n  component: CheckboxInput,\n};\n\nexport const feature_spinneret: Feature<string> = {\n  name: 'Spinneret Selection',\n  component: (\n    props: FeatureValueProps<string, string, FeatureChoicedServerData>,\n  ) => {\n    return <FeatureDropdownInput buttons {...props} />;\n  },\n};\n\nexport const spinneret_color: Feature<string[]> = {\n  name: 'Mandible Color',\n  component: FeatureTriColorInput,\n};\n\nexport const arachnid_legs_toggle: FeatureToggle = {\n  name: 'Arachnid Legs',\n  component: CheckboxInput,\n};\n\nexport const feature_arachnid_legs: Feature<string> = {\n  name: 'Arachnid Leg Selection',\n  component: (\n    props: FeatureValueProps<string, string, FeatureChoicedServerData>,\n  ) => {\n    return <FeatureDropdownInput buttons {...props} />;\n  },\n};\n\nexport const arachnid_legs_color: Feature<string[]> = {\n  name: 'Arachnid Leg Color',\n  component: FeatureTriColorInput,\n};\n",
				expectedOccurrences: 1,
			},
		],
	},
];
