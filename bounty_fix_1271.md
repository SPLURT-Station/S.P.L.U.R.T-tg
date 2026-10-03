# Werewolf Antagonist Implementation for SS14

```markdown
## Werewolf Antagonist System Design

### Overview
This implementation adds a werewolf antagonist type that transforms players into powerful wolf-like creatures. The system is inspired by traditional werewolf lore while fitting into the SS14 codebase alongside existing antagonists like bloodsuckers.

### Implementation Files

#### 1. WerewolfComponent.cs
```csharp
using Robust.Shared.GameObjects;
using Robust.Shared.Serialization.Manager.Attributes;
using Robust.Shared.ViewVariables;

namespace Content.Server.Antag.Werewolf
{
    [RegisterComponent]
    public sealed class WerewolfComponent : Component
    {
        [ViewVariables(VVAccess.ReadWrite)]
        [DataField("transformCooldown")]
        public TimeSpan TransformCooldown = TimeSpan.FromMinutes(5);

        [ViewVariables]
        public TimeSpan NextTransformTime;

        [ViewVariables(VVAccess.ReadWrite)]
        [DataField("humanoidSpeedModifier")]
        public float HumanoidSpeedModifier = 0.8f;

        [ViewVariables(VVAccess.ReadWrite)]
        [DataField("werewolfSpeedModifier")]
        public float WerewolfSpeedModifier = 1.3f;

        [ViewVariables]
        public bool Transformed = false;
    }
}
```

#### 2. WerewolfSystem.cs
```csharp
using Content.Shared.Movement.EntitySystems;
using Robust.Server.GameObjects;
using Robust.Shared.GameObjects;
using Robust.Shared.IoC;
using Robust.Shared.Timing;

namespace Content.Server.Antag.Werewolf
{
    public sealed class WerewolfSystem : EntitySystem
    {
        [Dependency] private readonly IGameTiming _gameTiming = default!;
        [Dependency] private readonly MovementSpeedModifierSystem _movementSpeed = default!;

        public override void Initialize()
        {
            base.Initialize();
            SubscribeLocalEvent<WerewolfComponent, ComponentInit>(OnInit);
        }

        private void OnInit(EntityUid uid, WerewolfComponent component, ComponentInit args)
        {
            UpdateSpeed(uid, component);
        }

        public bool CanTransform(EntityUid uid, WerewolfComponent? component = null)
        {
            if (!Resolve(uid, ref component))
                return false;

            return _gameTiming.CurTime > component.NextTransformTime;
        }

        public void Transform(EntityUid uid, WerewolfComponent? component = null)
        {
            if (!Resolve(uid, ref component))
                return;

            component.Transformed = !component.Transformed;
            component.NextTransformTime = _gameTiming.CurTime + component.TransformCooldown;
            
            UpdateSpeed(uid, component);
            UpdateAppearance(uid, component);
        }

        private void UpdateSpeed(EntityUid uid, WerewolfComponent component)
        {
            var speed = component.Transformed 
                ? component.WerewolfSpeedModifier 
                : component.HumanoidSpeedModifier;

            _movementSpeed.ChangeBaseSpeed(uid, speed, speed, speed);
        }

        private void UpdateAppearance(EntityUid uid, WerewolfComponent component)
        {
            if (!TryComp<SpriteComponent>(uid, out var sprite))
                return;

            // TODO: Add proper sprites for werewolf form
            sprite.LayerSetColor(0, component.Transformed ? Color.DarkGray : Color.White);
        }
    }
}
```

#### 3. WerewolfRole.cs
```csharp
using Content.Server.Roles;
using Robust.Shared.Localization;

namespace Content.Server.Antag.Werewolf
{
    public sealed class WerewolfRole : Role
    {
        public WerewolfRole(Mind.Mind mind) : base(mind)
        {
            Name = Loc.GetString("werewolf-role-name");
            Antagonist = true;
        }
    }
}
```

#### 4. WerewolfRule.cs
```csharp
using Content.Server.GameTicking.Rules.Configurations;
using Robust.Shared.Serialization.Manager.Attributes;

namespace Content.Server.Antag.Werewolf
{
    [DataDefinition]
    public class WerewolfRule : AntagRuleConfiguration
    {
        [DataField("minPlayers")]
        public int MinPlayers { get; set; } = 15;

        [DataField("maxWerewolves")]
        public int MaxWerewolves { get; set; } = 2;

        [DataField("chancePerPlayer")]
        public float ChancePerPlayer { get; set; } = 0.15f;
    }
}
```

### Game Mechanics

1. **Transformation**:
   - Werewolves can toggle between human and wolf forms
   - Transformation has a cooldown period
   - Form affects movement speed and appearance

2. **Objectives**:
   - Basic survival
   - Optional: Hunt specific targets

3. **Weaknesses**:
   - Silver weapons (can be implemented via damage modifiers)
   - Transformation cooldowns limit power

### Localization Strings

```yml
werewolf-role-name: Werewolf
werewolf-role-objective: Survive and spread terror as the fearsome werewolf!
werewolf-transform-message: You feel your body twisting and changing!
```

### Integration Steps

1. Register the components and systems in `Program.cs`
2. Add sprites for both human and wolf forms
3. Create yml protoypes for werewolf items/abilities
4. Add to antag selection system
5. Balance numbers through playtesting

### Balance Considerations

- Start with limited numbers (1-2 per round)
- Consider giving werewolves vulnerability to silver
- Add UI indicator for transformed state
- Potential lunar cycle mechanics for extra flavor

This implementation provides a solid foundation that can be expanded with additional features like:
- Pack mechanics
- Infectious bites
- Lunar cycle effects
- Special werewolf abilities
```
لم يتم العثور على كلمة البحث "يوضح" في نص البحث. يبدو أنك تريد ترجمة فورية. قد ترغب في مراجعة السؤال أو تقديم المزيد من التفاصيل.