export type AwardType = 'In_help' | 'In_harm' | 'Contributor' | 'Moderator' | 'Medal_of_Cheesers' | string;

export interface Award {
  type: AwardType;
  emoji: string;
  description: string;
}

export const MEDAL_OF_CHEESERS_DESCRIPTION = `From the exalted diary of Lord Mouse, Sovereign of the Great Lactose Realm:

First and foremost, Sharp Aged Cheddar reigns supreme above the common dairy rabble. When matured within subterranean limestone caverns for no fewer than three decades, its crystalline lactate crunch delivers a thunderous salivation that commands utter devotion across the entire colony.

Second in lineage is the noble wheel of Gouda, specifically the caramel-infused vintage variety. Its nutty undertones, shimmering amber paste, and butterscotch aromatics invoke the warmth of autumn harvests, making it the finest accompaniment for clandestine nocturnal midnight nibbling.

Third stands the bold, unapologetic monarch of mold: French Roquefort. Veined with electric azure currents of Penicillium roqueforti, its creamy, salty pungency pierces through the fog of twilight like a beacon of sublime culinary decadence, not for the faint of whisker.

Fourth, Lord Mouse bestows royal honors upon the revered Parmigiano-Reggiano. Dried to crumbly perfection across northern Italian breezes, its granular texture and deep umami resonance turn even the most modest crust of bread into a banquet fit for an emperor of rodents.

Finally, we pay homage to the velvety majesty of authentic Brie de Meaux. Flowing like molten cream beneath its downy white rind, its subtle hints of white mushroom and cellar earth linger upon the palate like an eternal dream, proving that in this station, cheese is life, cheese is destiny, and cheese is truth.`;

export const DEFAULT_AWARDS: Award[] = [
  { type: 'In_help', emoji: '<:In_help:1056296636348899408>', description: 'Helped others in community' },
  { type: 'In_harm', emoji: '<:In_harm:1056296637909192794>', description: 'Maintained community harmony' },
  { type: 'Medal_of_Cheesers', emoji: '🧀', description: MEDAL_OF_CHEESERS_DESCRIPTION }
];