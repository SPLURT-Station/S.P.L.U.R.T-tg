import React from 'react';
import { AwardsDisplay } from '../components/Profile/AwardsDisplay';

interface ProfileProps {
  playerId: string;
}

export const Profile: React.FC<ProfileProps> = ({ playerId }) => {
  return (
    <div className="profile-container">
      {/* Existing profile content */}
      <AwardsDisplay playerId={playerId} />
    </div>
  );
};