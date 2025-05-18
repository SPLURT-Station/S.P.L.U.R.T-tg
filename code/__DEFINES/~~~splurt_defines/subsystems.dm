/*
 * # INIT_ORDER_INTERACTIONS
 * Used by the Interactions subsystems, used to set it's own position in the queue.
 * This puts this last on priority, very far from other subsystems,
*/
#define INIT_ORDER_INTERACTIONS		-150

#define INIT_ORDER_HILBERTSHOTEL -160

// Vote subsystem counting methods
/// Each person ranks their votes in order of preference
#define VOTE_COUNT_METHOD_RANKED 3

/// The choice with the most votes wins. Ties are broken by the first choice to reach that number of votes.
#define VOTE_WINNER_METHOD_RANKED "Ranked"
