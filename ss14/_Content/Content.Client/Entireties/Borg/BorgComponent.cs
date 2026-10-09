using Robust.Client.GameObjects;

namespace Content.Client.Entireties.Borg
{
    /// <summary>
    /// Client-side borg component. Handles visual representation of comms state.
    /// </summary>
    [ComponentDefinition("Borg", "Client-side representation of a borg entity.")]
    public class BorgComponent : Component
    {
        public override string Name => "Borg";
    }
}
