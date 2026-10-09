using System;
using Robust.Server.GameObjects;
using SS14.Server.GameObjects;

namespace Content.Server.Speech
{
    /// <summary>
    /// Server-side speech filter for borg comms.
    /// Integrates with the BorgCommsSystem to block comms when disabled.
    /// </summary>
    public class BorgSpeechFilter : ISpeechFilter
    {
        private readonly BorgCommsSystem _commsSystem;

        public BorgSpeechFilter(BorgCommsSystem commsSystem)
        {
            _commsSystem = commsSystem;
        }

        public bool ShouldBroadcast(EntityUid speakerId)
        {
            return _commsSystem.ShouldBroadcast(speakerId);
        }

        public bool CanReceive(EntityUid receiverId)
        {
            return _commsSystem.CanReceive(receiverId);
        }
    }
}
