using System;
using Robust.Server.GameObjects;
using SS14.Server.GameObjects;
using SS14.Server.IoC;
using SS14.Server.Network;

namespace Content.Server.Entireties.Borg
{
    /// <summary>
    /// Component representing a borg (cyborg) entity with comms toggle capability.
    /// </summary>
    [ComponentDefinition("Borg", "Represents a cyborg entity with toggleable comms.")]
    public class BorgComponent : Component
    {
        public override string Name => "Borg";

        private EntityUid _controllingPlayer;

        /// <summary>
        /// The player currently controlling this borg, if any.
        /// </summary>
        public EntityUid ControllingPlayer
        {
            get => _controllingPlayer;
            set => _controllingPlayer = value;
        }

        /// <summary>
        /// Toggles all comms on this borg.
        /// </summary>
        public void ToggleComms()
        {
            var system = EntityManager.System<BorgCommsSystem>();
            system.ToggleComms(Owner, _controllingPlayer);
        }

        public override ComponentState GetComponentState()
        {
            var system = EntityManager.System<BorgCommsSystem>();
            return new BorgComponentState(system.IsCommsEnabled(Owner));
        }
    }

    /// <summary>
    /// Network state for the Borg component.
    /// </summary>
    public class BorgComponentState : ComponentState
    {
        public readonly bool CommsEnabled;

        public BorgComponentState(bool commsEnabled) : base("Borg")
        {
            CommsEnabled = commsEnabled;
        }
    }
}
