import { useState } from 'react';
//SPLURT EDIT START - Security cyborg management
//import { Box, Button, Flex, Modal, Section } from 'tgui-core/components';
import {
  Box,
  Button,
  Flex,
  Modal,
  Section,
  TextArea,
} from 'tgui-core/components';
//SPLURT EDIT END
import { capitalize } from 'tgui-core/string';

import { useBackend } from '../../backend';
import { AlertButton } from './AlertButton';
import { MessageModal } from './MessageModal';
import { type CommsConsoleData, ShuttleState } from './types';

export function PageMain(props) {
  const { act, data } = useBackend<CommsConsoleData>();
  const {
    alertLevel,
    callShuttleReasonMinLength,
    canBuyShuttles,
    canMakeAnnouncement,
    canMessageAssociates,
    canRecallShuttles,
    canRequestNuke,
    canSendToSectors,
    canSetAlertLevel,
    canToggleEmergencyAccess,
    canToggleEngineeringOverride, // BUBBER EDIT - Engineering override
    emagged,
    syndicate,
    emergencyAccess,
    engineeringOverride, // BUBBER EDIT - Engineering override
    importantActionReady,
    sectors,
    shuttleCalled,
    shuttleCalledPreviously,
    shuttleCanEvacOrFailReason,
    shuttleLastCalled,
    shuttleRecallable,
    // SPLURT EDIT - Security cyborg management
    canManageSecurityCyborgs,
    securityCyborgs,
    // SPLURT EDIT END
  } = data;

  const [callingShuttle, setCallingShuttle] = useState(false);
  const [messagingAssociates, setMessagingAssociates] = useState(false);
  const [messagingSector, setMessagingSector] = useState('');
  const [requestingNukeCodes, setRequestingNukeCodes] = useState(false);

  const [newAlertLevel, setNewAlertLevel] = useState('');
  const showAlertLevelConfirm = newAlertLevel && newAlertLevel !== alertLevel;
  // SPLURT EDIT START - Security cyborg management
  const [showSecurityCyborgManagement, setShowSecurityCyborgManagement] =
    useState(false);

  type CyborgAction = {
    ref: string;
    name: string;
    action: 'fire' | 'reinstate';
  };
  const [selectedCyborgAction, setSelectedCyborgAction] =
    useState<CyborgAction | null>(null);
  const [securityCyborgActionReason, setSecurityCyborgActionReason] =
    useState('');

  const closeSecurityCyborgManagement = () => {
    setShowSecurityCyborgManagement(false);
    setSelectedCyborgAction(null);
    setSecurityCyborgActionReason('');
  };

  const securityCyborgReasonLongEnough =
    securityCyborgActionReason.trim().length >= 3;
  // SPLURT EDIT END
  return (
    <Box>
      {!syndicate && (
        <Section title="Emergency Shuttle">
          {shuttleCalled ? (
            <Button.Confirm
              icon="space-shuttle"
              color="bad"
              disabled={!canRecallShuttles || !shuttleRecallable}
              tooltip={
                (canRecallShuttles &&
                  !shuttleRecallable &&
                  "It's too late for the emergency shuttle to be recalled.") ||
                'You do not have permission to recall the emergency shuttle.'
              }
              tooltipPosition="top"
              onClick={() => act('recallShuttle')}
            >
              Recall Emergency Shuttle
            </Button.Confirm>
          ) : (
            <Button
              icon="space-shuttle"
              disabled={shuttleCanEvacOrFailReason !== 1}
              tooltip={
                shuttleCanEvacOrFailReason !== 1
                  ? shuttleCanEvacOrFailReason
                  : undefined
              }
              tooltipPosition="top"
              onClick={() => setCallingShuttle(true)}
            >
              Call Emergency Shuttle
            </Button>
          )}
          {!!shuttleCalledPreviously &&
            (shuttleLastCalled ? (
              <Box>
                Most recent shuttle call/recall traced to:{' '}
                <b>{shuttleLastCalled}</b>
              </Box>
            ) : (
              <Box>Unable to trace most recent shuttle/recall signal.</Box>
            ))}
        </Section>
      )}

      {!!canSetAlertLevel && (
        <Section title="Alert Level">
          <Flex justify="space-between">
            <Flex.Item>
              <Box>
                Currently on <b>{capitalize(alertLevel)}</b> Alert
              </Box>
            </Flex.Item>

            <Flex.Item>
              <AlertButton
                alertLevel="green"
                onClick={() => setNewAlertLevel('green')}
              />

              <AlertButton
                alertLevel="blue"
                onClick={() => setNewAlertLevel('blue')}
              />

              {/* BUBBER EDIT ADDITION BEGIN - ALERTS */}
              <AlertButton
                alertLevel="violet"
                onClick={() => setNewAlertLevel('violet')}
              />

              <AlertButton
                alertLevel="orange"
                onClick={() => setNewAlertLevel('orange')}
              />

              <AlertButton
                alertLevel="amber"
                onClick={() => setNewAlertLevel('amber')}
              />
              {/* BUBBER EDIT ADDITION END - ALERTS */}
            </Flex.Item>
          </Flex>
        </Section>
      )}

      <Section title="Functions">
        <Flex direction="column">
          {!!canMakeAnnouncement && (
            <Button
              icon="bullhorn"
              onClick={() => act('makePriorityAnnouncement')}
            >
              Make Priority Announcement
            </Button>
          )}

          {!!canToggleEmergencyAccess && (
            <Button.Confirm
              icon="id-card-o"
              confirmIcon="id-card-o"
              color={emergencyAccess ? 'bad' : undefined}
              onClick={() => act('toggleEmergencyAccess')}
            >
              {emergencyAccess ? 'Disable' : 'Enable'} Emergency Maintenance
              Access
            </Button.Confirm>
          )}

          {/* BUBBER EDIT ADDITION START - Engineering Override */}
          {!!canToggleEngineeringOverride && (
            <Button.Confirm
              icon="wrench"
              color={engineeringOverride ? 'bad' : undefined}
              onClick={() => act('toggleEngOverride')}
            >
              {engineeringOverride ? 'Disable' : 'Enable'} Engineering Override
              Access
            </Button.Confirm>
          )}
          {/* BUBBER EDIT ADDITION END - Engineering Override */}

          {!syndicate && (
            <Button
              icon="desktop"
              onClick={() =>
                act('setState', { state: ShuttleState.CHANGING_STATUS })
              }
            >
              Set Status Display
            </Button>
          )}

          <Button
            icon="envelope-o"
            onClick={() => act('setState', { state: ShuttleState.MESSAGES })}
          >
            Message List
          </Button>

          {canBuyShuttles !== 0 && (
            <Button
              icon="shopping-cart"
              disabled={canBuyShuttles !== 1}
              // canBuyShuttles is a string detailing the fail reason
              // if one can be given
              tooltip={canBuyShuttles !== 1 ? canBuyShuttles : undefined}
              tooltipPosition="top"
              onClick={() =>
                act('setState', { state: ShuttleState.BUYING_SHUTTLE })
              }
            >
              Purchase Shuttle
            </Button>
          )}

          {!!canMessageAssociates && (
            <Button
              icon="comment-o"
              disabled={!importantActionReady}
              onClick={() => setMessagingAssociates(true)}
            >
              Send message to {emagged ? '[UNKNOWN]' : 'CentCom'}
            </Button>
          )}

          {!!canRequestNuke && (
            <Button
              icon="radiation"
              disabled={!importantActionReady}
              onClick={() => setRequestingNukeCodes(true)}
            >
              Request Nuclear Authentication Codes
            </Button>
          )}

          {!!emagged && !syndicate && (
            <Button icon="undo" onClick={() => act('restoreBackupRoutingData')}>
              Restore Backup Routing Data
            </Button>
          )}

          {/* BUBBER EDIT ADDITION BEGIN - Additional Calls */}
          {!!canMakeAnnouncement && (
            <Button icon="bullhorn" onClick={() => act('callThePolice')}>
              Call Terran Government 911: Marshals Response
            </Button>
          )}
          {!!canMakeAnnouncement && (
            <Button icon="bullhorn" onClick={() => act('callTheCatmos')}>
              Call Terran Government 811: Atmospherics Response
            </Button>
          )}
          {!!canMakeAnnouncement && (
            <Button icon="bullhorn" onClick={() => act('callTheParameds')}>
              Call Terran Government 911: Medical Response
            </Button>
          )}
          {!!emagged && (
            <Button icon="bullhorn" onClick={() => act('callThePizza')}>
              Place an Order with Dogginos Pizza
            </Button>
          )}
          {/* SPLURT EDIT START - Security cyborg management ID swipe modal */}
          {!!canManageSecurityCyborgs && (
            <Button
              icon="robot"
              onClick={() => setShowSecurityCyborgManagement(true)}
            >
              Security Cyborg Management
            </Button>
          )}
          {/* SPLURT EDIT END */}
          {/* BUBBER EDIT ADDITION END - Additional Calls */}
        </Flex>
      </Section>

      {!!canMessageAssociates && messagingAssociates && (
        <MessageModal
          label={`Message to transmit to ${
            emagged ? '[ABNORMAL ROUTING COORDINATES]' : 'CentCom'
          } via quantum entanglement`}
          notice="Please be aware that this process is very expensive, and abuse will lead to...termination. Transmission does not guarantee a response."
          icon="bullhorn"
          buttonText="Send"
          onBack={() => setMessagingAssociates(false)}
          onSubmit={(message) => {
            setMessagingAssociates(false);
            act('messageAssociates', {
              message,
            });
          }}
        />
      )}

      {!!canRequestNuke && requestingNukeCodes && (
        <MessageModal
          label="Reason for requesting nuclear self-destruct codes"
          notice="Misuse of the nuclear request system will not be tolerated under any circumstances. Transmission does not guarantee a response."
          icon="bomb"
          buttonText="Request Codes"
          onBack={() => setRequestingNukeCodes(false)}
          onSubmit={(reason) => {
            setRequestingNukeCodes(false);
            act('requestNukeCodes', {
              reason,
            });
          }}
        />
      )}

      {!!callingShuttle && (
        <MessageModal
          label="Nature of emergency"
          icon="space-shuttle"
          buttonText="Call Shuttle"
          minLength={callShuttleReasonMinLength}
          onBack={() => setCallingShuttle(false)}
          onSubmit={(reason) => {
            setCallingShuttle(false);
            act('callShuttle', {
              reason,
            });
          }}
        />
      )}

      {!!canSetAlertLevel && showAlertLevelConfirm && (
        <Modal>
          <Flex direction="column" textAlign="center" width="300px">
            <Flex.Item fontSize="16px" mb={2}>
              Swipe ID to confirm change
            </Flex.Item>

            <Flex.Item mr={2} mb={1}>
              <Button
                icon="id-card-o"
                color="good"
                fontSize="16px"
                onClick={() => {
                  act('changeSecurityLevel', {
                    newSecurityLevel: newAlertLevel,
                  });
                  setNewAlertLevel('');
                }}
              >
                Swipe ID
              </Button>

              <Button
                icon="times"
                color="bad"
                fontSize="16px"
                onClick={() => setNewAlertLevel('')}
              >
                Cancel
              </Button>
            </Flex.Item>
          </Flex>
        </Modal>
      )}

      {!!canSendToSectors && sectors.length > 0 && (
        <Section title="Allied Sectors">
          <Flex direction="column">
            {sectors.map((sectorName) => (
              <Flex.Item key={sectorName}>
                <Button
                  disabled={!importantActionReady}
                  onClick={() => setMessagingSector(sectorName)}
                >
                  Send a message to station in {sectorName} sector
                </Button>
              </Flex.Item>
            ))}

            {sectors.length > 2 && (
              <Flex.Item>
                <Button
                  disabled={!importantActionReady}
                  onClick={() => setMessagingSector('all')}
                >
                  Send a message to all allied station
                </Button>
              </Flex.Item>
            )}
          </Flex>
        </Section>
      )}

      {!!canSendToSectors && sectors.length > 0 && messagingSector && (
        <MessageModal
          label="Message to send to allied station"
          notice="Please be aware that this process is very expensive, and abuse will lead to...termination."
          icon="bullhorn"
          buttonText="Send"
          onBack={() => setMessagingSector('')}
          onSubmit={(message) => {
            act('sendToOtherSector', {
              destination: messagingSector,
              message,
            });

            setMessagingSector('');
          }}
        />
      )}
      {/* SPLURT EDIT START - Security cyborg management ID swipe modal */}
      {!!showSecurityCyborgManagement && !!canManageSecurityCyborgs && (
        <Modal>
          <Section width="430px">
            <Box bold mb={1}>
              Security Cyborg Management
            </Box>
            <Box mb={2} color="bad">
              Any demotion of a Security Cyborg MUST follow all (applicable)
              demotion procedures that you would for a normal Officer. This
              should not be used as your first response or punishment. Security
              Cyborgs following their given laws is not a valid reason for
              demotion. Any abuse of this system is subject to IMMEDIATE
              demotion by Central Command OR any deputized crew on board.
            </Box>
            {!securityCyborgs || securityCyborgs.length === 0 ? (
              <Box color="label">No security cyborgs currently active.</Box>
            ) : (
              <Flex direction="column" gap={1}>
                {securityCyborgs.map((borg) => (
                  <Flex key={borg.ref} justify="space-between" align="center">
                    <Flex.Item>
                      <Box
                        color={borg.fired ? 'average' : 'good'}
                        inline
                        mr={1}
                      >
                        ●
                      </Box>
                      {borg.name}
                      {borg.fired && (
                        <Box inline color="average" ml={1}>
                          (Relieved of Duty)
                        </Box>
                      )}
                    </Flex.Item>
                    <Flex.Item>
                      {borg.fired ? (
                        <Button
                          icon="user-plus"
                          color="good"
                          onClick={() => {
                            setSelectedCyborgAction({
                              ref: borg.ref,
                              name: borg.name,
                              action: 'reinstate',
                            });
                            setSecurityCyborgActionReason('');
                          }}
                        >
                          Reinstate
                        </Button>
                      ) : (
                        <Button
                          icon="user-times"
                          color="bad"
                          onClick={() => {
                            setSelectedCyborgAction({
                              ref: borg.ref,
                              name: borg.name,
                              action: 'fire',
                            });
                            setSecurityCyborgActionReason('');
                          }}
                        >
                          Relieve of Duty
                        </Button>
                      )}
                    </Flex.Item>
                  </Flex>
                ))}
              </Flex>
            )}
            <Box mt={2} textAlign="right">
              <Button
                icon="times"
                color="transparent"
                onClick={closeSecurityCyborgManagement}
              >
                Close
              </Button>
            </Box>
          </Section>
        </Modal>
      )}

      {!!selectedCyborgAction && (
        <Modal width="360px">
          <Flex direction="column" textAlign="center" width="100%">
            <Flex.Item fontSize="16px" mb={2}>
              {selectedCyborgAction.action === 'fire'
                ? `Relieve ${selectedCyborgAction.name} of duty?`
                : `Reinstate ${selectedCyborgAction.name}?`}
            </Flex.Item>
            <Flex.Item mb={2} color="label" fontSize="12px">
              Swipe your ID card to confirm.
            </Flex.Item>
            <Flex.Item mb={2}>
              <TextArea
                fluid
                height="10vh"
                maxLength={512}
                onChange={setSecurityCyborgActionReason}
                placeholder="Reason (required, min 3 characters)"
                value={securityCyborgActionReason}
                width="100%"
              />
            </Flex.Item>
            <Flex.Item mr={2} mb={1}>
              <Button
                icon="id-card-o"
                color={selectedCyborgAction.action === 'fire' ? 'bad' : 'good'}
                disabled={!securityCyborgReasonLongEnough}
                fontSize="16px"
                onClick={() => {
                  const { ref, action } = selectedCyborgAction;
                  act(action === 'fire' ? 'fireCyborg' : 'reinstateCyborg', {
                    borgRef: ref,
                    reason: securityCyborgActionReason,
                  });
                  closeSecurityCyborgManagement();
                }}
              >
                Swipe ID
              </Button>
              <Button
                icon="times"
                color="transparent"
                fontSize="16px"
                onClick={() => {
                  setSelectedCyborgAction(null);
                  setSecurityCyborgActionReason('');
                }}
              >
                Cancel
              </Button>
            </Flex.Item>
          </Flex>
        </Modal>
      )}
      {/* SPLURT EDIT END */}
    </Box>
  );
}
