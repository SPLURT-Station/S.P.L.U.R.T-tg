using Robust.Shared.GameObjects;

namespace Content.Shared.Entireties.Borg
{
    /// <summary>
    /// Shared component for borg entities.
    /// Indicates that this entity is a borg with toggleable comms.
    /// </summary>
    [ComponentDefinition("Borg", "A cyborg entity with toggleable communication channels.")]
    public class BorgComponent : Component
    {
        public override string Name => "Borg";
    }
}
