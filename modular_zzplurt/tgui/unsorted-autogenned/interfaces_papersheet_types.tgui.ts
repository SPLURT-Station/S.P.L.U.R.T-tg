import type { ModularTguiPatch } from '../.';

export const modularTgui = true;

export const overrides = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui/interfaces/PaperSheet/types.ts',
		operations: [
			{
				kind: "replace",
				anchor: "  color: string;\n  bold: boolean;\n  advanced_html: boolean;\n}>;\n\ntype StampInput = {\n  class: string;\n  x: number;\n  y: number;\n  rotation: number;\n};\n\nexport enum InteractionType {\n  reading = 0,\n  writing = 1,\n  stamping = 2,\n}\n\nexport type WritingImplement = {\n  interaction_mode: InteractionType;\n} & Partial<{\n  color: string;\n  font: string;\n  stamp_class: string;",
				content: "  color: string; //SPLURT ADDITION\n  bold: boolean; //SPLURT ADDITION\n  advanced_html: boolean;\n}>;\n\ntype StampInput = {\n  class: string;\n  x: number;\n  y: number;\n  rotation: number;\n  color?: string; //SPLURT ADDITION\n  scale?: number; //SPLURT ADDITION\n};\n\nexport enum InteractionType {\n  reading = 0,\n  writing = 1,\n  stamping = 2,\n}\n\nexport type WritingImplement = {\n  interaction_mode: InteractionType;\n} & Partial<{\n  color: string;\n  font: string;\n  stamp_class: string;\n  stamp_color: string; //SPLURT ADDITION\n  stamp_scale: number; //SPLURT ADDITION",
				expectedOccurrences: 1,
			},
		],
	},
];
