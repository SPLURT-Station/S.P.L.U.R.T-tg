export type AwardType = 'In_help' | 'In_harm' | 'Contributor' | 'Moderator' | string;

export interface Award {
  type: AwardType;
  emoji: string;
  description: string;
}

export const DEFAULT_AWARDS: Award[] = [
  { type: 'In_help', emoji: '<:In_help:1056296636348899408>', description: 'Helped others in community' },
  { type: 'In_harm', emoji: '<:In_harm:1056296637909192794>', description: 'Maintained community harmony' }
];