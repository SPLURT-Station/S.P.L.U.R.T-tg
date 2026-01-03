/datum/plug13_connection
	var/is_connected = FALSE
	var/pending = FALSE
	var/error
	var/username
	var/code
	var/emote_sends_failed = 0
	var/failed_code_tries = 0
	var/client/owner

/datum/plug13_connection/New(client/owner)
	if (!owner)
		CRASH("Plug13 connection was created without an owner!")
	src.owner = owner

/datum/plug13_connection/proc/connect()
	if (is_connected || !code || pending) return
	if (!owner) return

	if (failed_code_tries > 30)
		error = "Too many code entry errors"
		return

	pending = TRUE
	error = ""

	var/body = list(
		"code" = code,
		"secret" = CONFIG_GET(string/plug13_secret),
		"key" = owner.key
	)

	var/datum/http_request/request = new
	request.prepare(RUSTG_HTTP_METHOD_POST, "[CONFIG_GET(string/plug13_url)]/api/game/connect", json_encode(body))
	request.begin_async()
	UNTIL(request.is_complete() || !owner)
	if (!owner) return

	var/datum/http_response/response = request.into_response()
	pending = FALSE

	if (response.errored || response.status_code != 200)
		error = "Connection error with Plug13"
		return

	var/data = json_decode(response.body)

	if (data["error"])
		error = data["error"]
		failed_code_tries++
		return

	is_connected = TRUE
	username = data["username"]


/datum/plug13_connection/proc/disconnect()
	is_connected = FALSE
	emote_sends_failed = 0
	username = null

/datum/plug13_connection/proc/send_emote(emote, strength, duration)
	set waitfor = FALSE

	if (!is_connected || !code) return
	if (!owner) return

	if (!(emote in PLUG13_ALL_EMOTES))
		CRASH("Plug13 error - Invalid emote type: \"[emote]\"")

	if (!isnum(strength) || strength <= 0 || strength > 100)
		CRASH("Plug13 error - Invalid emote strength: [strength]")

	if (!isnum(duration) || duration <= 0 || duration > PLUG13_MAX_CLIENT_INTERACTION_DURATION)
		CRASH("Plug13 error - Invalid emote duration: [duration]")

	var/body = list(
		"code" = code,
		"secret" = CONFIG_GET(string/plug13_secret),
		"emote" = emote,
		"strength" = strength,
		"duration" = duration,
		"key" = owner.key
	)

	var/datum/http_request/request = new
	request.prepare(RUSTG_HTTP_METHOD_POST, "[CONFIG_GET(string/plug13_url)]/api/game/emote", json_encode(body))
	request.begin_async()
	UNTIL(request.is_complete() || !owner)
	if (!owner) return

	var/datum/http_response/response = request.into_response()

	if (response.errored || FLOOR(response.status_code/100, 1) != 2) // 2xx codes
		if (++emote_sends_failed > 10)
			error = "Too many failed requests"
			disconnect()
		return

	emote_sends_failed = 0
