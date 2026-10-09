using System.Collections.Generic;
using Robust.Shared.GameObjects;
using Robust.Shared.IoC;
using Robust.Shared.Map;
using Robust.Shared.Physics;
using SS14.Shared.GameObject;
using SS14.Shared.IoC;
using SS14.Shared.Content;
using SS14.Shared.Containers;
using SS14.Shared.Physics;
using SS14.Shared.Network;
using SS14.Shared.GameState;
using SS14.Shared.Map;
using SS14.Shared.GameObjects;
using SS14.Shared.Player;
using SS14.Shared.Speech;
using SS14.Shared.Utility;
using SS14.Shared.Log;
using System.Linq;

namespace Content.Shared.Entireties.Borg
{
    /// <summary>
    /// Shared system handling Borg communication toggling.
    /// Allows borgs to disable all comms channels to reduce clutter during RP.
    /// </summary>
    public class BorgCommsSystem : SharedSystem
    {
        private readonly Dictionary<EntityUid, bool> _borgCommsEnabled = new();

        public override void Initialize()
        {
            base.Initialize();
            Events.Subscribe<StartPausedEvent>(OnStartPaused);
            Events.Subscribe<OnEntityEnterMapEvent>(OnEntityEnterMap);
        }

        private void OnStartPaused(StartPausedEvent ev)
        {
            // Initialize all existing borgs with comms enabled by default
            foreach (var borg in EntityManager.GetAllEntities<BorgComponent>())
            {
                if (!_borgCommsEnabled.ContainsKey(borg.Owner))
                {
                    _borgCommsEnabled[borg.Owner] = true;
                }
            }
        }

        private void OnEntityEnterMap(OnEntityEnterMapEvent ev)
        {
            if (ev.Entity.HasComponent<BorgComponent>() && !_borgCommsEnabled.ContainsKey(ev.Entity.Owner))
            {
                _borgCommsEnabled[ev.Entity.Owner] = true;
            }
        }

        /// <summary>
        /// Toggles all comms on/off for a borg entity.
        /// When disabled, the borg will not transmit or receive any comms traffic.
        /// </summary>
        public void ToggleComms(EntityUid borgId)
        {
            if (!_borgCommsEnabled.ContainsKey(borgId))
            {
                _borgCommsEnabled[borgId] = true;
            }

            _borgCommsEnabled[borgId] = !_borgCommsEnabled[borgId];

            var enabled = _borgCommsEnabled[borgId];
            var logger = IoCManager.Resolve<ILogger>();
            logger.Info($"Borg comms {(enabled ? "enabled" : "disabled")} for entity {borgId}");

            // Notify the client if applicable
            if (ServerEntityManager.HasComponent<PlayerAttachedEntity>(borgId))
            {
                var player = ServerEntityManager.GetComponent<PlayerAttachedEntity>(borgId);
                var msg = new BorgCommsToggleMessage(enabled);
                player.SendClientMessage(msg);
            }
        }

        /// <summary>
        /// Returns whether comms are currently enabled for a borg.
        /// </summary>
        public bool IsCommsEnabled(EntityUid borgId)
        {
            return _borgCommsEnabled.GetValueOrDefault(borgId, true);
        }
    }

    /// <summary>
    /// Message sent to client when borg comms are toggled.
    /// </summary>
    public class BorgCommsToggleMessage : ClientMessage
    {
        public readonly bool CommsEnabled;

        public BorgCommsToggleMessage(bool commsEnabled) : base("BorgCommsToggle")
        {
            CommsEnabled = commsEnabled;
        }
    }
}
