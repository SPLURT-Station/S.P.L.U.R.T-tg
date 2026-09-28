export type AwardType = 'In_help' | 'In_harm' | 'Contributor' | 'Moderator' | 'Medal_of_Cheesers' | string;

export interface Award {
  type: AwardType;
  emoji: string;
  description: string;
}

export const MEDAL_OF_CHEESERS_DESCRIPTION = `From the exalted squeaks of Lord Mouse, Grand Roquefort of the Whisker Realm:

First and foremost, Sharp Aged Cheddar reigns supreme — it's looking extraordinarily sharp, and cheddar late than never! When matured in subterranean caverns for decades, its crystalline crunch is simply un-brie-lievable and makes every mouse squeak with utter devotion. It’s definitely nacho average cheese!

Second in our rodent lineage is the noble wheel of Gouda. Life is Gouda when this caramel-infused vintage variety rolls in. Its nutty aromatics invoke pure whisker-twitching joy, proving that grate minds think alike during clandestine midnight nibbles in the pantry maze.

Third stands the bold monarch of mold: French Roquefort. Veined with electric blue currents, its pungent funk will stop any cat dead in its tracks. It's a total feta-compli: one whiff of this blue majesty and you'll know this rodent ruler takes no cage for granted. You gouda brie kidding if you think any rat could resist!

Fourth, we bestow royal tail-wagging honors upon the legendary Parmigiano-Reggiano. Aged to crumbly perfection, its savory umami crunch makes every cheese-trap worth the risk. A truly grate cheese that proves mice will always find the whey to culinary glory!

Finally, we pay homage to the velvety majesty of authentic Brie de Meaux. Flowing like liquid gold, it’s simply brie-lliant! Sweet dreams are made of brie, and who are we to dis-a-brie? In this station, cheese is life, the mouse-trap is a myth, and the squeak shall inherit the stars!`;

export const DEFAULT_AWARDS: Award[] = [
  { type: 'In_help', emoji: '<:In_help:1056296636348899408>', description: 'Helped others in community' },
  { type: 'In_harm', emoji: '<:In_harm:1056296637909192794>', description: 'Maintained community harmony' },
  { type: 'Medal_of_Cheesers', emoji: '🧀', description: MEDAL_OF_CHEESERS_DESCRIPTION }
];