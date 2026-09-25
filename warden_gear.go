// Security megaphone item addition for Warden locker (#1235)
package splurt

import (
	"context"
)

type LockerItem struct {
	ID          string `json:"id"`
	Name        string `json:"name"`
	Category    string `json:"category"`
	IsRestricted bool   `json:"is_restricted"`
}

func GetWardenLockerItems() []LockerItem {
	return []LockerItem{
		{ID: "sec_megaphone", Name: "Security Megaphone", Category: "Warden Gear", IsRestricted: true},
	}
}
