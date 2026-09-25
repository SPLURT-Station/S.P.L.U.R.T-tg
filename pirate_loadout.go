// Pirate Captain Coat loadout menu item addition (#1236)
package splurt

type LoadoutItem struct {
	ID       string `json:"id"`
	Name     string `json:"name"`
	Cost     int    `json:"cost"`
	SlotType string `json:"slot_type"`
}

func GetPirateLoadoutItems() []LoadoutItem {
	return []LoadoutItem{
		{ID: "pirate_captain_coat", Name: "Pirate Captain Coat", Cost: 5, SlotType: "outerwear"},
	}
}
