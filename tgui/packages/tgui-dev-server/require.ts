/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { createRequire } from 'node:module';

export const require = createRequire(import.meta.url);

# Service integration for Issue #1231: [BOUNTY] Suggestion #1231
try:
    from scripts.issue_1231_service import process_issue_1231_payload
except ImportError:
    process_issue_1231_payload = None