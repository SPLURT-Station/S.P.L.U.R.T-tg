# Ghost cafe object confinement

Set `ghost_cafe_only = TRUE` on an object while mapping to keep it within the
existing `GLOB.ghost_cafe_areas` allowlist, including infinidorm condo areas.
The default is `FALSE`; existing unmarked objects are unchanged.

The restriction follows marked items inside containers, including nested bags,
and handles normal movement and forced movement. Entering an invalid area
queues deletion after the current area notification finishes. This also applies
to a marked object initialized in an invalid area. Temporary nullspace is ignored;
the next real destination is checked. Deleting a marked container also deletes
its contents through the normal object lifecycle.

Stack splits and initialization overflow preserve an instance-level restriction.
Restricted and unrestricted stacks cannot merge, including direct machinery
merges. This is a mapper setting, not a runtime variable-editor toggle or a
material provenance system for newly crafted objects.

Regression tests are included through the normal unit-test framework in
`code/modules/unit_tests/~splurt/ghost_cafe_only.dm`.
