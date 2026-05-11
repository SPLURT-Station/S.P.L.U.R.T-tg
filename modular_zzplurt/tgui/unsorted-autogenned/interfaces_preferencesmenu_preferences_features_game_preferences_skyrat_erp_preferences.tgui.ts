import { block, type ModularTguiPatch } from '../../modules/tgui_modular/index';

export const modularTgui = true;

export const overrides = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui/interfaces/PreferencesMenu/preferences/features/game_preferences/skyrat/erp_preferences.tsx',
		operations: [
			{
				kind: "replace",
				anchor: block`
				import {
				  CheckboxInput,
				  type FeatureChoiced,
				  type FeatureToggle,
				} from '../../base';
				import { FeatureDropdownInput } from '../../dropdowns';
				`,
				content: "import { CheckboxInput, type FeatureToggle } from '../../base';",
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "export const erp_sexuality_pref: FeatureChoiced = {",
				position: "before",
				content: block`
				/* SPLURT EDIT REMOVAL - No
				
				`,
				expectedOccurrences: 1,
			},
			{
				kind: "replace",
				anchor: block`
				};
				
				export const genitalia_removal_pref: FeatureToggle = {
				`,
				content: block`
				};
				*/ // SPLURT EDIT REMOVAL END
				
				export const genitalia_removal_pref: FeatureToggle = {
				`,
				expectedOccurrences: 1,
			},
		],
	},
];
