// Hypno Sword item implementation for Pirate Ship Ruin (#1232)
package splurt

type RuinItem struct {
	ID        string `json:"id"`
	Name      string `json:"name"`
	Location  string `json:"location"`
	HasEffect bool   `json:"has_effect"`
}

func GetPirateShipRuinItems() []RuinItem {
	return []RuinItem{
		{ID: "hypno_sword", Name: "Hypno Sword", Location: "Pirate Ship Ruin", HasEffect: true},
	}
}
