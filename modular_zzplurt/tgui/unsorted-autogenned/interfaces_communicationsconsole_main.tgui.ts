import { block, type ModularTguiPatch } from '../../modules/tgui_modular/index';

export const modularTgui = true;

export const overrides = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui/interfaces/CommunicationsConsole/Main.tsx',
		operations: [
			{
				kind: "replace",
				anchor: "import { Box, Button, Flex, Modal, Section } from 'tgui-core/components';",
				content: block`
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
				`,
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "    shuttleRecallable,",
				position: "after",
				content: block`
				
				    // SPLURT EDIT - Security cyborg management
				    canManageSecurityCyborgs,
				    securityCyborgs,
				    // SPLURT EDIT END
				`,
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "  const showAlertLevelConfirm = newAlertLevel && newAlertLevel !== alertLevel;",
				position: "after",
				content: block`
				
				  // SPLURT EDIT START - Security cyborg management
				  const [showSecurityCyborgManagement, setShowSecurityCyborgManagement] =
				    useState(false);
				`,
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "  return (",
				position: "before",
				content: block`
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
				
				`,
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "          {/* BUBBER EDIT ADDITION END - Additional Calls */}",
				position: "before",
				content: block`
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
				
				`,
				expectedOccurrences: 1,
			},
			{
				kind: "replace",
				anchor: block`
				      )}
				    </Box>
				`,
				content: block`
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
				                ? \`Relieve \${selectedCyborgAction.name} of duty?\`
				                : \`Reinstate \${selectedCyborgAction.name}?\`}
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
				`,
				expectedOccurrences: 1,
			},
		],
	},
];
