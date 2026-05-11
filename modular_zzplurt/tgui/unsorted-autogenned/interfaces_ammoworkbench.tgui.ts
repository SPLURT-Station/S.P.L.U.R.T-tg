import { block, type ModularTguiPatch } from '../../modules/tgui_modular/index';

export const modularTgui = true;

export const overrides = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui/interfaces/AmmoWorkbench.jsx',
		operations: [
			{
				kind: "replace",
				anchor: block`
				import { toTitleCase } from 'tgui-core/string';
				import { useState } from 'react';
				
				import { useBackend, useSharedState } from '../backend';
				import {
				  Box,
				  Button,
				  Flex,
				  NoticeBox,
				  NumberInput,
				  ProgressBar,
				  RoundGauge,
				  Section,
				  Stack,
				  Table,
				  Tabs,
				  Tooltip,
				} from 'tgui-core/components';
				`,
				content: block`
				import { useState } from 'react';
				import {
				  Box,
				  Button,
				  Flex,
				  NoticeBox,
				  NumberInput,
				  ProgressBar,
				  RoundGauge,
				  Section,
				  Stack,
				  Table,
				  Tabs,
				  Tooltip,
				} from 'tgui-core/components';
				import { toTitleCase } from 'tgui-core/string';
				
				import { useBackend, useSharedState } from '../backend';
				`,
				expectedOccurrences: 1,
			},
		],
	},
];
