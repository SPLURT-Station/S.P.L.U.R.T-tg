// Fix for Marked One's Sword sprite visibility (#1229)
package splurt

type WeaponSpriteConfig struct {
	ItemRef        string `json:"item_ref"`
	VisibleOnEquip bool   `json:"visible_on_equip"`
	LayerPriority  int    `json:"layer_priority"`
}

func GetMarkedOneSwordSpriteConfig() WeaponSpriteConfig {
	return WeaponSpriteConfig{
		ItemRef:        "marked_one_sword",
		VisibleOnEquip: true,
		LayerPriority:  5,
	}
}
