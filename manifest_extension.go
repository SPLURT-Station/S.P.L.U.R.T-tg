// Add silicon and ashwalker options to manifest UI list (#1234)
package splurt

import (
	"context"
)

type ManifestEntry struct {
	RoleName string `json:"role_name"`
	Category string `json:"category"`
	Enabled  bool   `json:"enabled"`
}

func GetExtendedManifest() []ManifestEntry {
	return []ManifestEntry{
		{RoleName: "Silicon / Cyborg", Category: "Synthetic", Enabled: true},
		{RoleName: "Ashwalker", Category: "Lizardfolk", Enabled: true},
	}
}
