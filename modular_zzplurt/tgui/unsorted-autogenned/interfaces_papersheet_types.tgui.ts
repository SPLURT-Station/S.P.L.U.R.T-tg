import { block, type ModularTguiPatch } from '../../modules/tgui_modular/index';

export const modularTgui = true;

export const overrides = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui/interfaces/PaperSheet/types.ts',
		operations: [
			{
				kind: "replace",
				anchor: block`
				  color: string;
				  bold: boolean;
				  advanced_html: boolean;
				}>;
				
				type StampInput = {
				  class: string;
				  x: number;
				  y: number;
				  rotation: number;
				};
				
				export enum InteractionType {
				  reading = 0,
				  writing = 1,
				  stamping = 2,
				}
				
				export type WritingImplement = {
				  interaction_mode: InteractionType;
				} & Partial<{
				  color: string;
				  font: string;
				  stamp_class: string;
				`,
				content: block`
				  color: string; //SPLURT ADDITION
				  bold: boolean; //SPLURT ADDITION
				  advanced_html: boolean;
				}>;
				
				type StampInput = {
				  class: string;
				  x: number;
				  y: number;
				  rotation: number;
				  color?: string; //SPLURT ADDITION
				  scale?: number; //SPLURT ADDITION
				};
				
				export enum InteractionType {
				  reading = 0,
				  writing = 1,
				  stamping = 2,
				}
				
				export type WritingImplement = {
				  interaction_mode: InteractionType;
				} & Partial<{
				  color: string;
				  font: string;
				  stamp_class: string;
				  stamp_color: string; //SPLURT ADDITION
				  stamp_scale: number; //SPLURT ADDITION
				`,
				expectedOccurrences: 1,
			},
		],
	},
];
