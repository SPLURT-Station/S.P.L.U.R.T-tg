import { Button, Stack } from 'tgui-core/components';

import { useBackend } from '../../../backend';

type ContentPrefsInfo = {
  // Master ERP pref
  master_erp_pref: boolean;
  // Base ERP toggle
  base_erp_pref: boolean;
  // Core ERP prefs
  erp_sounds_pref: boolean;
  sextoy_pref: boolean;
  sextoy_sounds_pref: boolean;
  bimbofication_pref: boolean;
  aphro_pref: boolean;
  breast_enlargement_pref: boolean;
  breast_shrinkage_pref: boolean;
  penis_enlargement_pref: boolean;
  penis_shrinkage_pref: boolean;
  gender_change_pref: boolean;
  autocum_pref: boolean;
  autoemote_pref: boolean;
  genitalia_removal_pref: boolean;
  new_genitalia_growth_pref: boolean;
  // SPLURT additions
  butt_enlargement_pref: boolean;
  butt_shrinkage_pref: boolean;
  belly_enlargement_pref: boolean;
  belly_shrinkage_pref: boolean;
  forced_neverboner_pref: boolean;
  custom_genital_fluids_pref: boolean;
  cumflation_pref: boolean;
  cumflates_partners_pref: boolean;
  // Vore prefs
  vore_enable_pref: boolean;
  vore_overlays: boolean;
  vore_overlay_options: boolean;
};

type ContentPreferencesTabProps = {
  searchText: string;
};

export const ContentPreferencesTab = ({
  searchText,
}: ContentPreferencesTabProps) => {
  const { act, data } = useBackend<ContentPrefsInfo>();
  const {
    // Master ERP pref
    master_erp_pref,
    // Base ERP toggle
    base_erp_pref,
    // Core ERP prefs
    erp_sounds_pref,
    sextoy_pref,
    sextoy_sounds_pref,
    bimbofication_pref,
    aphro_pref,
    breast_enlargement_pref,
    breast_shrinkage_pref,
    penis_enlargement_pref,
    penis_shrinkage_pref,
    gender_change_pref,
    autocum_pref,
    autoemote_pref,
    genitalia_removal_pref,
    new_genitalia_growth_pref,
    // SPLURT additions
    butt_enlargement_pref,
    butt_shrinkage_pref,
    belly_enlargement_pref,
    belly_shrinkage_pref,
    forced_neverboner_pref,
    custom_genital_fluids_pref,
    cumflation_pref,
    cumflates_partners_pref,
    // Vore prefs
    vore_enable_pref,
    vore_overlays,
    vore_overlay_options,
  } = data;

  const renderToggle = (
    key: string,
    value: boolean,
    label: string,
    tooltip?: string,
  ) => {
    // Filter based on search text
    if (
      searchText &&
      !label.toLowerCase().includes(searchText.toLowerCase()) &&
      (!tooltip || !tooltip.toLowerCase().includes(searchText.toLowerCase()))
    ) {
      return null;
    }

    return (
      <Stack.Item>
        <Button
          fluid
          mb={-0.7}
          icon={value ? 'toggle-on' : 'toggle-off'}
          selected={value}
          onClick={() =>
            act('pref', {
              pref: key,
            })
          }
          tooltip={tooltip}
        >
          {label}
        </Button>
      </Stack.Item>
    );
  };

  return (
    <Stack vertical fill>
      {/* Master ERP Toggle */}
      {renderToggle(
        'master_erp_pref',
        master_erp_pref,
        'Enable ERP Content',
        'Master toggle for all ERP content',
      )}

      {!!master_erp_pref && (
        <>
          {/* Base ERP Toggle */}
          {renderToggle(
            'base_erp_pref',
            base_erp_pref,
            'Enable ERP',
            'Toggle for basic ERP functionality',
          )}

          {/* Core ERP Preferences */}
          {renderToggle('erp_sounds_pref', erp_sounds_pref, 'ERP Sounds')}
          {renderToggle('sextoy_pref', sextoy_pref, 'Sex Toy Interaction')}
          {renderToggle(
            'sextoy_sounds_pref',
            sextoy_sounds_pref,
            'Sex Toy Sounds',
          )}
          {renderToggle(
            'bimbofication_pref',
            bimbofication_pref,
            'Bimbofication',
          )}
          {renderToggle('aphro_pref', aphro_pref, 'Aphrodisiacs')}
          {renderToggle(
            'breast_enlargement_pref',
            breast_enlargement_pref,
            'Breast Enlargement',
          )}
          {renderToggle(
            'breast_shrinkage_pref',
            breast_shrinkage_pref,
            'Breast Shrinkage',
          )}
          {renderToggle(
            'penis_enlargement_pref',
            penis_enlargement_pref,
            'Penis Enlargement',
          )}
          {renderToggle(
            'penis_shrinkage_pref',
            penis_shrinkage_pref,
            'Penis Shrinkage',
          )}
          {renderToggle(
            'gender_change_pref',
            gender_change_pref,
            'Gender Change',
          )}
          {renderToggle('autocum_pref', autocum_pref, 'Automatic Climax')}
          {renderToggle('autoemote_pref', autoemote_pref, 'Automatic Emotes')}
          {renderToggle(
            'genitalia_removal_pref',
            genitalia_removal_pref,
            'Allow Genitalia Removal',
          )}
          {renderToggle(
            'new_genitalia_growth_pref',
            new_genitalia_growth_pref,
            'Allow New Genitalia Growth',
          )}

          {/* SPLURT Additions */}
          {renderToggle(
            'butt_enlargement_pref',
            butt_enlargement_pref,
            'Butt Enlargement',
          )}
          {renderToggle(
            'butt_shrinkage_pref',
            butt_shrinkage_pref,
            'Butt Shrinkage',
          )}
          {renderToggle(
            'belly_enlargement_pref',
            belly_enlargement_pref,
            'Belly Enlargement',
          )}
          {renderToggle(
            'belly_shrinkage_pref',
            belly_shrinkage_pref,
            'Belly Shrinkage',
          )}
          {renderToggle(
            'forced_neverboner_pref',
            forced_neverboner_pref,
            'Forced Never Boner',
          )}
          {renderToggle(
            'custom_genital_fluids_pref',
            custom_genital_fluids_pref,
            'Custom Genital Fluids',
          )}
          {renderToggle(
            'cumflation_pref',
            cumflation_pref,
            'Cumflation',
            'Allow your genitals to get cumflated',
          )}
          {renderToggle(
            'cumflates_partners_pref',
            cumflates_partners_pref,
            'Cumflates Partners',
            'Your character cumflates partners.',
          )}

          {/* Vore Preferences */}
          {renderToggle('vore_enable_pref', vore_enable_pref, 'Enable Vore')}
          {!!vore_enable_pref && (
            <>
              {renderToggle('vore_overlays', vore_overlays, 'Vore Overlays')}
              {renderToggle(
                'vore_overlay_options',
                vore_overlay_options,
                'Vore Overlay Options',
              )}
            </>
          )}
        </>
      )}
    </Stack>
  );
};
