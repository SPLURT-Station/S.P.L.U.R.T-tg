import { block, type ModularTguiPatch } from '../../modules/tgui_modular/index';

export const modularTgui = true;

export const overrides = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui/interfaces/PreferencesMenu/CharacterPreferences/MainPage.tsx',
		operations: [
			{
				kind: "replace",
				anchor: block`
				            <Stack.Item>
				              <CharacterControls
				                gender={data.character_preferences.misc.gender}
				                handleOpenSpecies={props.openSpecies}
				                handleRotate={(value) => {
				                  act('rotate', { backwards: value }); // BUBBER EDIT CHANGE - Original: handleRotate={() => { act('rotate'); }}
				                }}
				                // BUBBER EDIT ADDITION BEGIN
				                handleFood={() => {
				                  act('open_food');
				                }}
				                // BUBBER EDIT ADDITION END
				                setGender={createSetPreference(act, 'gender')}
				                showGender={
				                  currentSpeciesData ? !!currentSpeciesData.sexes : true
				                }
				                canDeleteCharacter={
				                  Object.values(data.character_profiles).filter(
				                    (name) => !!name,
				                  ).length > 1
				                }
				                handleDeleteCharacter={() => setDeleteCharacterPopupOpen(true)}
				              />
				            </Stack.Item>
				
				            {/* BUBBER EDIT ADDITION BEGIN: Preview Selection */}
				            <Stack.Item position="relative">
				              <SideDropdown
				                selected={data.preview_selection}
				                options={data.preview_options}
				                onSelected={(value) =>
				                  act('update_preview', {
				                    updated_preview: value,
				                  })
				                }
				              />
				            </Stack.Item>
				            {/* BUBBER EDIT ADDITION END: Preview Selection */}
				
				            {/* BUBBER EDIT ADDITION START: Background Selection */}
				            <Stack.Item position="relative">
				              <SideDropdown
				                selected={data.character_preferences.misc.background_state}
				                options={serverData?.background_state.choices || []}
				                onSelected={(value) =>
				                  act('update_background', {
				                    new_background: value,
				                  })
				                }
				              />
				            </Stack.Item>
				            {/* BUBBER EDIT ADDITION END: Background Selection */}
				            <Stack.Item height="545px">
				              <CharacterPreview
				                height="100%"
				                width="270px" // BUBBER EDIT ADDITION
				                id={data.character_preview_view}
				              />
				            </Stack.Item>
				
				            <Stack.Item position="relative">
				              <NameInput
				                name={data.character_preferences.names[data.name_to_use]}
				                handleUpdateName={createSetPreference(act, data.name_to_use)}
				                openMultiNameInput={() => {
				                  setMultiNameInputOpen(true);
				                }}
				              />
				            </Stack.Item>
				`,
				content: block`
				            {/* SPLURT EDIT - Puts the name pref first  */}
				            <Stack.Item position="relative">
				              <NameInput
				                name={data.character_preferences.names[data.name_to_use]}
				                handleUpdateName={createSetPreference(act, data.name_to_use)}
				                openMultiNameInput={() => {
				                  setMultiNameInputOpen(true);
				                }}
				              />
				            </Stack.Item>
				            {/* SPLURT EDIT END */}
				            <Stack.Item>
				              <CharacterControls
				                gender={data.character_preferences.misc.gender}
				                handleOpenSpecies={props.openSpecies}
				                handleRotate={(value) => {
				                  act('rotate', { backwards: value }); // BUBBER EDIT CHANGE - Original: handleRotate={() => { act('rotate'); }}
				                }}
				                // BUBBER EDIT ADDITION BEGIN
				                handleFood={() => {
				                  act('open_food');
				                }}
				                // BUBBER EDIT ADDITION END
				                setGender={createSetPreference(act, 'gender')}
				                showGender={
				                  currentSpeciesData ? !!currentSpeciesData.sexes : true
				                }
				                canDeleteCharacter={
				                  Object.values(data.character_profiles).filter(
				                    (name) => !!name,
				                  ).length > 1
				                }
				                handleDeleteCharacter={() => setDeleteCharacterPopupOpen(true)}
				              />
				            </Stack.Item>
				
				            {/* BUBBER EDIT ADDITION BEGIN: Preview Selection */}
				            <Stack.Item position="relative">
				              <SideDropdown
				                selected={data.preview_selection}
				                options={data.preview_options}
				                onSelected={(value) =>
				                  act('update_preview', {
				                    updated_preview: value,
				                  })
				                }
				              />
				            </Stack.Item>
				            {/* BUBBER EDIT ADDITION END: Preview Selection */}
				
				            {/* BUBBER EDIT ADDITION START: Background Selection */}
				            <Stack.Item position="relative">
				              <SideDropdown
				                selected={data.character_preferences.misc.background_state}
				                options={serverData?.background_state.choices || []}
				                onSelected={(value) =>
				                  act('update_background', {
				                    new_background: value,
				                  })
				                }
				              />
				            </Stack.Item>
				            {/* BUBBER EDIT ADDITION END: Background Selection */}
				            <Stack.Item height="545px">
				              <CharacterPreview
				                height="100%"
				                width="270px" // BUBBER EDIT ADDITION
				                id={data.character_preview_view}
				              />
				            </Stack.Item>
				            {/* SPLURT EDIT - Puts the name pref first
				            <Stack.Item position="relative">
				              <NameInput
				                name={data.character_preferences.names[data.name_to_use]}
				                handleUpdateName={createSetPreference(act, data.name_to_use)}
				                openMultiNameInput={() => {
				                  setMultiNameInputOpen(true);
				                }}
				              />
				            </Stack.Item>
				            SPLURT EDIT END */}
				`,
				expectedOccurrences: 1,
			},
		],
	},
];
