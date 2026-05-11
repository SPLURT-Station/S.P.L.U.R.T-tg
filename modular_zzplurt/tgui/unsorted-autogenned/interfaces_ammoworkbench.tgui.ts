import type { ModularTguiPatch } from '../.';

export const modularTgui = true;

export const overrides = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui/interfaces/AmmoWorkbench.jsx',
		operations: [
			{
				kind: "replace",
				anchor: "import { toTitleCase } from 'tgui-core/string';\nimport { useState } from 'react';\n\nimport { useBackend, useSharedState } from '../backend';\nimport {\n  Box,\n  Button,\n  Flex,\n  NoticeBox,\n  NumberInput,\n  ProgressBar,\n  RoundGauge,\n  Section,\n  Stack,\n  Table,\n  Tabs,\n  Tooltip,\n} from 'tgui-core/components';",
				content: "import { useState } from 'react';\nimport {\n  Box,\n  Button,\n  Flex,\n  NoticeBox,\n  NumberInput,\n  ProgressBar,\n  RoundGauge,\n  Section,\n  Stack,\n  Table,\n  Tabs,\n  Tooltip,\n} from 'tgui-core/components';\nimport { toTitleCase } from 'tgui-core/string';\n\nimport { useBackend, useSharedState } from '../backend';",
				expectedOccurrences: 1,
			},
		],
	},
];
