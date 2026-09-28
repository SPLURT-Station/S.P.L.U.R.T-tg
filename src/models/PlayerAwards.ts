import { Schema, model, Document } from 'mongoose';
import { AwardType } from '../types/awards';

interface IPlayerAwards extends Document {
  playerId: string;
  awards: Record<AwardType, number>;
  lastUpdated: Date;
}

const playerAwardsSchema = new Schema<IPlayerAwards>({
  playerId: { type: String, required: true, unique: true },
  awards: {
    type: Map,
    of: Number,
    default: () => ({})
  },
  lastUpdated: { type: Date, default: Date.now }
});

export const PlayerAwards = model<IPlayerAwards>('PlayerAwards', playerAwardsSchema);