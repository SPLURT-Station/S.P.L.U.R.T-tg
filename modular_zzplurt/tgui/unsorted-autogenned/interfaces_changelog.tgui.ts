import type { ModularTguiPatch } from '../.';

export const modularTgui = true;

export const overrides = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui/interfaces/Changelog.jsx',
		operations: [
			{
				kind: "replace-all",
				anchor: "        <h1>Bubberstation 13</h1>",
				content: "        <h1>S.P.L.U.R.T Station 13</h1>",
				expectedOccurrences: 1,
			},
			{
				kind: "replace-all",
				anchor: "          /tg/ Station, Skyrat Space Station 13, Traditional Games 13,",
				content: "          /tg/ Station, Bubberstation, Skyrat Space Station 13, Traditional",
				expectedOccurrences: 1,
			},
			{
				kind: "replace-all",
				anchor: "          Baystation 12, /vg/station, NTstation, CDK Station",
				content: "          Games 13, Baystation 12, /vg/station, NTstation, CDK Station",
				expectedOccurrences: 1,
			},
		],
	},
];
