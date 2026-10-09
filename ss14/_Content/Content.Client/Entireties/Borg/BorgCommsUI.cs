using System;
using Robust.Client.GameObjects;
using Robust.Client.Input;
using Robust.Client.Graphics;
using SS14.Client.GameObjects;
using SS14.Client.Input;
using SS14.Client.Sandbox;
using SS14.Client.Utility;
using SS14.Client.Localization;
using System.Threading.Tasks;

namespace Content.Client.Entireties.Borg
{
    /// <summary>
    /// Client-side UI handler for borg comms toggle.
    /// Shows a visual indicator when comms are disabled and provides a UI action.
    /// </summary>
    public class BorgCommsUI : ClientSystem
    {
        private IEntityManager _entityManager;
        private IInputManager _inputManager;
        private IDrawingManager _drawingManager;

        public override void Initialize()
        {
            _entityManager = IoCManager.Resolve<IEntityManager>();
            _inputManager = IoCManager.Resolve<IInputManager>();
            _drawingManager = IoCManager.Resolve<IDrawingManager>();

            Events.Subscribe<BorgCommsToggleMessage>(OnBorgCommsToggle);
            Events.Subscribe<BoundUIOpenEvent>(OnBoundUIOpen);
        }

        private void OnBorgCommsToggle(BorgCommsToggleMessage msg)
        {
            // Update UI to reflect new comms state
            UpdateCommsIndicator(msg.CommsEnabled);
        }

        private void UpdateCommsIndicator(bool commsEnabled)
        {
            // Update the visual indicator for the borg's comms status
            var uiElement = _entityManager.ClientIoC.Resolve<ISandboxManager>()
                .GetUIElement("BorgCommsIndicator");

            if (uiElement != null)
            {
                uiElement.SetVisible(commsEnabled);
                uiElement.SetTooltip(commsEnabled
                    ? Localization.Localizer.GetString("ui_borg_comms_enabled")
                    : Localization.Localizer.GetString("ui_borg_comms_disabled"));
            }
        }

        private void OnBoundUIOpen(BoundUIOpenEvent ev)
        {
            if (ev.UIName == "BorgCommsMenu")
            {
                ShowCommsMenu(ev.EntityUid);
            }
        }

        private void ShowCommsMenu(EntityUid borgId)
        {
            var system = _entityManager.System<BorgCommsSystem>();
            var enabled = system.IsCommsEnabled(borgId);

            var menu = new BoundUIMenu("BorgCommsMenu")
            {
                Title = Localization.Localizer.GetString("ui_borg_comms_title"),
                Options = new[]
                {
                    new UIMenuOption(
                        enabled
                            ? Localization.Localizer.GetString("ui_borg_comms_disable")
                            : Localization.Localizer.GetString("ui_borg_comms_enable"),
                        () => system.ToggleComms(borgId)
                    )
                },
                Hint = enabled
                    ? Localization.Localizer.GetString("ui_borg_comms_disable_hint")
                    : Localization.Localizer.GetString("ui_borg_comms_enable_hint")
            };

            _entityManager.ClientIoC.Resolve<IBoundUIManager>().OpenMenu(menu);
        }
    }
}
