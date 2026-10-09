using System;
using Robust.Shared.GameObjects;
using SS14.Shared.GameObjects;

namespace Content.Shared.Speech
{
    /// <summary>
    /// Filter that prevents comms traffic from being broadcast when a borg has comms disabled.
    /// </summary>
    public class BorgSpeechFilter : ISpeechFilter
    {
        private readonly Func<EntityUid, bool> _shouldBroadcast;
        private readonly Func<EntityUid, bool> _canReceive;

        public BorgSpeechFilter(Func<EntityUid, bool> shouldBroadcast, Func<EntityUid, bool> canReceive)
        {
            _shouldBroadcast = shouldBroadcast;
            _canReceive = canReceive;
        }

        public bool ShouldBroadcast(EntityUid speakerId)
        {
            return _shouldBroadcast(speakerId);
        }

        public bool CanReceive(EntityUid receiverId)
        {
            return _canReceive(receiverId);
        }
    }
}
