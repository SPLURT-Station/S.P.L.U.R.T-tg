import type { ModularTguiPatch } from '../.';

export const modularTgui = true;

export const overrides = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui/interfaces/PaperSheet/Stamp.tsx',
		operations: [
			{
				kind: "replace",
				anchor: "  const { activeStamp, sprite, x, y, rotation, opacity, yOffset = 0 } = props;\n  const stamp_transform = {\n    left: `${x}px`,\n    top: `${y + yOffset}px`,\n    transform: `rotate(${rotation}deg)`,",
				content: "  // SPLURT EDIT START - Added scale props for more dynamic stamps\n  const {\n    activeStamp,\n    sprite,\n    x,\n    y,\n    rotation,\n    opacity,\n    yOffset = 0,\n    scale = 1,\n  } = props; //SPLURT EDIT END\n  const stamp_transform = {\n    left: `${x}px`,\n    top: `${y + yOffset}px`,\n    transform: `rotate(${rotation}deg) scale(${scale})`, //SPLURT EDIT",
				expectedOccurrences: 1,
			},
		],
	},
];
