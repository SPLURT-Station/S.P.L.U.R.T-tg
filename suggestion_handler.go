// SPLURT Station Telegram Bot Helper (#1231)
package splurt

import (
	"context"
	"fmt"
)

type BotHandler struct {
	BotToken string
}

func NewBotHandler(token string) *BotHandler {
	return &BotHandler{BotToken: token}
}

func (b *BotHandler) HandleSuggestion(ctx context.Context, userID string, suggestion string) error {
	if suggestion == "" {
		return fmt.Errorf("suggestion cannot be empty")
	}
	// Logic to process suggestion and store in database/send notification
	return nil
}
