import type { ModularTguiPatch } from '../.';

export const modularTgui = true;

export const overrides = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui/interfaces/PreferencesMenu/preferences/features/game_preferences/skyrat/erp_preferences.tsx',
		operations: [
			{
				kind: "replace",
				anchor: "import {\n  CheckboxInput,\n  type FeatureChoiced,\n  type FeatureToggle,\n} from '../../base';\nimport { FeatureDropdownInput } from '../../dropdowns';",
				content: "import { CheckboxInput, type FeatureToggle } from '../../base';",
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "export const erp_sexuality_pref: FeatureChoiced = {",
				position: "before",
				content: "/* SPLURT EDIT REMOVAL - No\n",
				expectedOccurrences: 1,
			},
			{
				kind: "replace",
				anchor: "};\n\nexport const genitalia_removal_pref: FeatureToggle = {",
				content: "};\n*/ // SPLURT EDIT REMOVAL END\n\nexport const genitalia_removal_pref: FeatureToggle = {",
				expectedOccurrences: 1,
			},
		],
	},
];
