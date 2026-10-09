using System;
using System.Collections.Generic;
using Robust.Server.GameObjects;
using Robust.Server.Input;
using Robust.Server.Network;
using SS14.Server.GameObjects;
using SS14.Server.IoC;
using SS14.Server.Network;
using SS14.Server.Localization;
using SS14.Server.Speech;
using SS14.Server.Event;
using System.Linq;

namespace Content.Server.Entireties.Borg
{
    /// <summary>
    /// Server-side system handling Borg communication toggling.
    /// When comms are disabled, borgs do not broadcast to any channels
    /// and do not receive comms traffic from other entities.
    /// </summary>
    public class BorgCommsSystem : ServerSystem
    {
        private readonly Dictionary<EntityUid, bool> _borgCommsEnabled = new();

        public override void Initialize()
        {
            base.Initialize();
            Events.Subscribe<ServerEntitySpawnEvent>(OnEntitySpawn);
            Events.Subscribe<StartPausedEvent>(OnStartPaused);
            Events.Subscribe<BorgCommsToggleMessage>(OnToggleCommsRequest);
        }

        private void OnStartPaused(StartPausedEvent ev)
        {
            foreach (var borg in EntityManager.GetAllEntities<BorgComponent>())
            {
                if (!_borgCommsEnabled.ContainsKey(borg.Owner))
                {
                    _borgCommsEnabled[borg.Owner] = true;
                }
            }
        }

        private void OnEntitySpawn(ServerEntitySpawnEvent ev)
        {
            if (ev.Entity.HasComponent<BorgComponent>() && !_borgCommsEnabled.ContainsKey(ev.Entity.Owner))
            {
                _borgCommsEnabled[ev.Entity.Owner] = true;
            }
        }

        private void OnToggleCommsRequest(BorgCommsToggleMessage msg)
        {
            // This message is handled through the bound UI action
        }

        /// <summary>
        /// Toggles all comms on/off for a borg entity.
        /// </summary>
        public void ToggleComms(EntityUid borgId, EntityUid playerUid)
        {
            if (!_borgCommsEnabled.ContainsKey(borgId))
            {
                _borgCommsEnabled[borgId] = true;
            }

            _borgCommsEnabled[borgId] = !_borgCommsEnabled[borgId];
            var enabled = _borgCommsEnabled[borgId];

            var logger = IoCManager.Resolve<IServerLogger>();
            logger.Info($"Borg comms {(enabled ? "enabled" : "disabled")} for entity {borgId}");

            // Broadcast the state change to all clients observing this borg
            var msg = new BorgCommsToggleMessage(enabled);
            NetworkManager.BroadcastToNearbyClients(borgId, msg);

            // Notify the controlling player
            if (playerUid != null && playerUid.IsValid())
            {
                var player = EntityManager.GetComponent<PlayerAttachedEntity>(playerUid);
                if (player != null)
                {
                    player.SendClientMessage(msg);
                }
            }
        }

        /// <summary>
        /// Returns whether comms are currently enabled for a borg.
        /// </summary>
        public bool IsCommsEnabled(EntityUid borgId)
        {
            return _borgCommsEnabled.GetValueOrDefault(borgId, true);
        }

        /// <summary>
        /// Called by the speech system to check if a borg should broadcast a message.
        /// </summary>
        public bool ShouldBroadcast(EntityUid borgId)
        {
            return IsCommsEnabled(borgId);
        }

        /// <summary>
        /// Called by the speech system to check if a borg should receive a message.
        /// </summary>
        public bool CanReceive(EntityUid borgId)
        {
            return IsCommsEnabled(borgId);
        }
    }
}
