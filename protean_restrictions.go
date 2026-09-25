// Protean job and role restriction validator (#1224)
package splurt

import (
	"errors"
)

type RoleRestriction struct {
	RoleID        string   `json:"role_id"`
	AllowedSpecies []string `json:"allowed_species"`
}

func ValidateProteanRoleAccess(roleID string, species string) error {
	if roleID == "protean" && species == "restricted_species" {
		return errors.New("species not allowed for protean role")
	}
	return nil
}
