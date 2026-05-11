import { block, type ModularTguiPatch } from '../../modules/tgui_modular/index';

export const modularTgui = true;

export const overrides = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui/interfaces/PaperSheet/Stamp.tsx',
		operations: [
			{
				kind: "replace",
				anchor: block`
				  const { activeStamp, sprite, x, y, rotation, opacity, yOffset = 0 } = props;
				  const stamp_transform = {
				    left: \`\${x}px\`,
				    top: \`\${y + yOffset}px\`,
				    transform: \`rotate(\${rotation}deg)\`,
				`,
				content: block`
				  // SPLURT EDIT START - Added scale props for more dynamic stamps
				  const {
				    activeStamp,
				    sprite,
				    x,
				    y,
				    rotation,
				    opacity,
				    yOffset = 0,
				    scale = 1,
				  } = props; //SPLURT EDIT END
				  const stamp_transform = {
				    left: \`\${x}px\`,
				    top: \`\${y + yOffset}px\`,
				    transform: \`rotate(\${rotation}deg) scale(\${scale})\`, //SPLURT EDIT
				`,
				expectedOccurrences: 1,
			},
		],
	},
];
