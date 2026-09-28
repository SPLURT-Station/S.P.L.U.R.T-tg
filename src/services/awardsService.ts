import { PlayerAwards } from '../models/PlayerAwards';
import { AwardType, DEFAULT_AWARDS } from '../types/awards';

export class AwardsService {
  static async getPlayerAwards(playerId: string): Promise<Record<string, number>> {
    const awardsDoc = await PlayerAwards.findOne({ playerId });
    const awards = awardsDoc?.awards.toObject() || {};
    // Every player receives the free Medal of Cheesers
    if (!awards['Medal_of_Cheesers']) {
      awards['Medal_of_Cheesers'] = 1;
    }
    return awards;
  }

  static async addAward(playerId: string, awardType: AwardType, count = 1): Promise<void> {
    const update = { $inc: { [`awards.${awardType}`]: count } };
    await PlayerAwards.findOneAndUpdate(
      { playerId },
      { $setOnInsert: { playerId, awards: { Medal_of_Cheesers: 1 }, lastUpdated: new Date() } },
      { upsert: true, new: true, setDefaultsOnInsert: true }
    ).then(() => PlayerAwards.updateOne({ playerId }, update));
  }

  static getAwardEmoji(awardType: AwardType): string {
    return DEFAULT_AWARDS.find(a => a.type === awardType)?.emoji || '';
  }
}