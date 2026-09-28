import React from 'react';
import { AwardsService } from '../../services/awardsService';
import { AwardType } from '../../types/awards';

interface AwardsDisplayProps {
  playerId: string;
}

export const AwardsDisplay: React.FC<AwardsDisplayProps> = ({ playerId }) => {
  const [awards, setAwards] = React.useState<Record<string, number>>({});

  React.useEffect(() => {
    AwardsService.getPlayerAwards(playerId).then(setAwards);
  }, [playerId]);

  return (
    <div className="awards-container">
      <h3>Your Awards</h3>
      {Object.entries(awards).length === 0 ? (
        <p>No awards yet. Earn some by helping others!</p>
      ) : (
        <div className="awards-grid">
          {Object.entries(awards).map(([type, count]) => (
            <div key={type} className="award-item">
              <span className="award-emoji">
                {AwardsService.getAwardEmoji(type as AwardType)}
              </span>
              <span className="award-count">{count}x</span>
            </div>
          ))}
        </div>
      )}
    </div>
  );
};