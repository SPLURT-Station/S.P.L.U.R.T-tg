// Stake destruction & heart embedding logic fix (#1237)
package splurt

import (
	"errors"
)

type StakeInteraction struct {
	StakeID     string `json:"stake_id"`
	TargetHeart string `json:"target_heart"`
	IsEmbedded  bool   `json:"is_embedded"`
	IsDestroyed bool   `json:"is_destroyed"`
}

func ProcessStakeHeartInteraction(stakeID string, heartID string) (*StakeInteraction, error) {
	if stakeID == "" || heartID == "" {
		return nil, errors.New("invalid stake or heart identifier")
	}
	return &StakeInteraction{
		StakeID:     stakeID,
		TargetHeart: heartID,
		IsEmbedded:  true,
		IsDestroyed: true,
	}, nil
}
