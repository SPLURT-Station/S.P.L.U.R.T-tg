import type { ModularTguiPatch } from '../.';

export const modularTgui = true;

export const overrides = [];

export const patches: ModularTguiPatch[] = [
	{
		target: 'packages/tgui/interfaces/CommunicationsConsole/Main.tsx',
		operations: [
			{
				kind: "replace",
				anchor: "import { Box, Button, Flex, Modal, Section } from 'tgui-core/components';",
				content: "//SPLURT EDIT START - Security cyborg management\n//import { Box, Button, Flex, Modal, Section } from 'tgui-core/components';\nimport {\n  Box,\n  Button,\n  Flex,\n  Modal,\n  Section,\n  TextArea,\n} from 'tgui-core/components';\n//SPLURT EDIT END",
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "    shuttleRecallable,",
				position: "after",
				content: "\n    // SPLURT EDIT - Security cyborg management\n    canManageSecurityCyborgs,\n    securityCyborgs,\n    // SPLURT EDIT END",
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "  const showAlertLevelConfirm = newAlertLevel && newAlertLevel !== alertLevel;",
				position: "after",
				content: "\n  // SPLURT EDIT START - Security cyborg management\n  const [showSecurityCyborgManagement, setShowSecurityCyborgManagement] =\n    useState(false);",
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "  return (",
				position: "before",
				content: "  type CyborgAction = {\n    ref: string;\n    name: string;\n    action: 'fire' | 'reinstate';\n  };\n  const [selectedCyborgAction, setSelectedCyborgAction] =\n    useState<CyborgAction | null>(null);\n  const [securityCyborgActionReason, setSecurityCyborgActionReason] =\n    useState('');\n\n  const closeSecurityCyborgManagement = () => {\n    setShowSecurityCyborgManagement(false);\n    setSelectedCyborgAction(null);\n    setSecurityCyborgActionReason('');\n  };\n\n  const securityCyborgReasonLongEnough =\n    securityCyborgActionReason.trim().length >= 3;\n  // SPLURT EDIT END\n",
				expectedOccurrences: 1,
			},
			{
				kind: "insert",
				anchor: "          {/* BUBBER EDIT ADDITION END - Additional Calls */}",
				position: "before",
				content: "          {/* SPLURT EDIT START - Security cyborg management ID swipe modal */}\n          {!!canManageSecurityCyborgs && (\n            <Button\n              icon=\"robot\"\n              onClick={() => setShowSecurityCyborgManagement(true)}\n            >\n              Security Cyborg Management\n            </Button>\n          )}\n          {/* SPLURT EDIT END */}\n",
				expectedOccurrences: 1,
			},
			{
				kind: "replace",
				anchor: "      )}\n    </Box>",
				content: "      )}\n      {/* SPLURT EDIT START - Security cyborg management ID swipe modal */}\n      {!!showSecurityCyborgManagement && !!canManageSecurityCyborgs && (\n        <Modal>\n          <Section width=\"430px\">\n            <Box bold mb={1}>\n              Security Cyborg Management\n            </Box>\n            <Box mb={2} color=\"bad\">\n              Any demotion of a Security Cyborg MUST follow all (applicable)\n              demotion procedures that you would for a normal Officer. This\n              should not be used as your first response or punishment. Security\n              Cyborgs following their given laws is not a valid reason for\n              demotion. Any abuse of this system is subject to IMMEDIATE\n              demotion by Central Command OR any deputized crew on board.\n            </Box>\n            {!securityCyborgs || securityCyborgs.length === 0 ? (\n              <Box color=\"label\">No security cyborgs currently active.</Box>\n            ) : (\n              <Flex direction=\"column\" gap={1}>\n                {securityCyborgs.map((borg) => (\n                  <Flex key={borg.ref} justify=\"space-between\" align=\"center\">\n                    <Flex.Item>\n                      <Box\n                        color={borg.fired ? 'average' : 'good'}\n                        inline\n                        mr={1}\n                      >\n                        ●\n                      </Box>\n                      {borg.name}\n                      {borg.fired && (\n                        <Box inline color=\"average\" ml={1}>\n                          (Relieved of Duty)\n                        </Box>\n                      )}\n                    </Flex.Item>\n                    <Flex.Item>\n                      {borg.fired ? (\n                        <Button\n                          icon=\"user-plus\"\n                          color=\"good\"\n                          onClick={() => {\n                            setSelectedCyborgAction({\n                              ref: borg.ref,\n                              name: borg.name,\n                              action: 'reinstate',\n                            });\n                            setSecurityCyborgActionReason('');\n                          }}\n                        >\n                          Reinstate\n                        </Button>\n                      ) : (\n                        <Button\n                          icon=\"user-times\"\n                          color=\"bad\"\n                          onClick={() => {\n                            setSelectedCyborgAction({\n                              ref: borg.ref,\n                              name: borg.name,\n                              action: 'fire',\n                            });\n                            setSecurityCyborgActionReason('');\n                          }}\n                        >\n                          Relieve of Duty\n                        </Button>\n                      )}\n                    </Flex.Item>\n                  </Flex>\n                ))}\n              </Flex>\n            )}\n            <Box mt={2} textAlign=\"right\">\n              <Button\n                icon=\"times\"\n                color=\"transparent\"\n                onClick={closeSecurityCyborgManagement}\n              >\n                Close\n              </Button>\n            </Box>\n          </Section>\n        </Modal>\n      )}\n\n      {!!selectedCyborgAction && (\n        <Modal width=\"360px\">\n          <Flex direction=\"column\" textAlign=\"center\" width=\"100%\">\n            <Flex.Item fontSize=\"16px\" mb={2}>\n              {selectedCyborgAction.action === 'fire'\n                ? `Relieve ${selectedCyborgAction.name} of duty?`\n                : `Reinstate ${selectedCyborgAction.name}?`}\n            </Flex.Item>\n            <Flex.Item mb={2} color=\"label\" fontSize=\"12px\">\n              Swipe your ID card to confirm.\n            </Flex.Item>\n            <Flex.Item mb={2}>\n              <TextArea\n                fluid\n                height=\"10vh\"\n                maxLength={512}\n                onChange={setSecurityCyborgActionReason}\n                placeholder=\"Reason (required, min 3 characters)\"\n                value={securityCyborgActionReason}\n                width=\"100%\"\n              />\n            </Flex.Item>\n            <Flex.Item mr={2} mb={1}>\n              <Button\n                icon=\"id-card-o\"\n                color={selectedCyborgAction.action === 'fire' ? 'bad' : 'good'}\n                disabled={!securityCyborgReasonLongEnough}\n                fontSize=\"16px\"\n                onClick={() => {\n                  const { ref, action } = selectedCyborgAction;\n                  act(action === 'fire' ? 'fireCyborg' : 'reinstateCyborg', {\n                    borgRef: ref,\n                    reason: securityCyborgActionReason,\n                  });\n                  closeSecurityCyborgManagement();\n                }}\n              >\n                Swipe ID\n              </Button>\n              <Button\n                icon=\"times\"\n                color=\"transparent\"\n                fontSize=\"16px\"\n                onClick={() => {\n                  setSelectedCyborgAction(null);\n                  setSecurityCyborgActionReason('');\n                }}\n              >\n                Cancel\n              </Button>\n            </Flex.Item>\n          </Flex>\n        </Modal>\n      )}\n      {/* SPLURT EDIT END */}\n    </Box>",
				expectedOccurrences: 1,
			},
		],
	},
];
