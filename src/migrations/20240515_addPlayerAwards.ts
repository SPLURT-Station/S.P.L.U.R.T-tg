import { PlayerAwards } from '../models/PlayerAwards';
import { AwardType } from '../types/awards';

export async function up(): Promise<void> {
  // Initialize awards for existing players who have admin awards
  const playersWithAwards = await Player.find({ 'admin.awards': { $exists: true, $ne: [] } });

  for (const player of playersWithAwards) {
    const awards = player.admin.awards.reduce((acc: Record<AwardType, number>, award: string) => {
      const type = award.split(':')[0] as AwardType;
      acc[type] = (acc[type] || 0) + 1;
      return acc;
    }, {});

    await new PlayerAwards({
      playerId: player._id.toString(),
      awards
    }).save();
  }
}

export async function down(): Promise<void> {
  // No down migration needed as this is additive
}