#define TRAINSTATION_TITLE_HTML {"
<html>
<head>
<meta http-equiv='X-UA-Compatible' content='IE=edge'>
<meta http-equiv='Content-Type' content='text/html; charset=UTF-8' />
<style type='text/css'>

@font-face {
    font-family: 'Fixedsys';
    src: url('FixedsysExcelsior3.01Regular.ttf');
}

@font-face {
    font-family: 'OCR-A';
    src: url('OCRAExtended.ttf');
}

/* ===== BODY ===== */
body, html {
    margin: 0;
    padding: 0;
    overflow: hidden;
    height: 100vh;
    width: 100vw;
    background: transparent;
    color: #ffdd99;
    font-family: 'Fixedsys', 'OCR-A', 'Courier New', Courier, monospace;
    font-smooth: never;
    -webkit-font-smoothing: none;
    -moz-osx-font-smoothing: grayscale;
    image-rendering: pixelated;
    text-rendering: geometricPrecision;
    -ms-user-select: none;
    cursor: default;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
}

body::after {
    content: '';
    position: fixed;
    inset: 0;
    width: 100vw;
    height: 100vh;
    background: radial-gradient(circle at center, transparent 30%, rgba(0,0,0,0.85) 80%);
    pointer-events: none;
    z-index: 0;
}

img.bg {
    position: fixed;
    inset: 0;
    width: 100vw;
    height: 100vh;
    object-fit: cover;
    z-index: -2;
    image-rendering: pixelated;
}

/* ===== TERMINAL ===== */
.container_terminal {
    position: relative;
    width: auto;
    max-width: 85vmin;
    overflow: hidden;
    padding: 2vmin 3vmin;
    z-index: 1;
    margin: 1vmin auto;
}

.terminal_text {
    display: block;
    width: 100%;
    text-align: left;
    color: #e8c68a;
    text-shadow: 1px 1px 0 #000, 2px 2px 4px #000;
    font-family: 'Fixedsys', monospace;
    font-size: 2.1vmin;
    line-height: 1.35;
    letter-spacing: 0.8px;
    white-space: pre-wrap;
    word-break: break-all;
}

/* ===== PROGRESS ===== */
.container_progress {
    position: relative;
    height: 5vmin;
    width: 55vmin;
    margin: 3vmin auto;
    padding: 3px;
    background: rgba(10, 12, 25, 0.92);
    border: 3px solid #ffcc44;
    border-image: linear-gradient(#ffcc44, #aa8800) 1;
    box-shadow: inset 0 0 12px #ffaa0044;
    image-rendering: crisp-edges;
}

.progress_bar {
    width: 0%;
    height: 100%;
    background: linear-gradient(to right, #ffdd55, #ff8800);
    box-shadow: 0 0 12px #ffaa00;
}

/* ===== MENU PANEL ===== */
.container_nav {
    position: relative;
    top: 8vh;
    z-index: 1;
    background: transparent;
    border: none;
    padding: 0;
    margin: 2vmin auto;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 1.2vmin;
	transform: translateY(10vh);
}

.container_nav hr {
    display: none;
}

/* ===== MENU BUTTON ===== */
.menu_button {
    display: inline-block;
    font-family: 'Fixedsys', monospace;
    font-size: 1.6vmin;
    line-height: 1.1;
    padding: 0.8vmin 3vmin;
    min-width: 25vmin;
    text-align: center;
    color: #e8c68a;
    text-shadow: 2px 2px 0 #000;
    letter-spacing: 1.5px;
    cursor: pointer;
    white-space: nowrap;
    transition: all 0.18s ease;
    border: 2px solid transparent;
    background: transparent;
    image-rendering: crisp-edges;
}

.menu_button:hover {
    color: #ffff88;
    text-shadow: 0 0 10px #ffdd55, 2px 2px 0 #000;
    background: transparent;
    transform: translateX(8px);
    letter-spacing: 2.2px;
}

.menu_button:active {
    transform: translate(3px, 3px);
    filter: brightness(0.85);
}

.menu_button:hover::before {
    content: ">>";
    margin-right: 1.5vmin;
    color: #ffdd55;
}

/* ===== NOTICE ===== */
.container_notice {
    position: relative;
    top: 8vh;
    z-index: 1;
    margin: 2vmin auto;
    padding: 1.5vmin 3vmin;
    max-width: 70vmin;
}

.menu_notice {
    display: block;
    text-align: center;
    color: #cccccc;
    font-family: 'Fixedsys', monospace;
    font-size: 1.6vmin;
    line-height: 1.3;
    text-shadow: 2px 2px 0 #000;
}

/* ===== STATES ===== */
.unchecked { color: #ff4444; }
.checked   { color: #44ff88; }

/* ===== ANIMATIONS ===== */
@keyframes fade_out {
    to { opacity: 0; }
}

.fade_out {
    animation: fade_out 1.8s forwards;
}

</style>
</head>
<body>
"}

/datum/controller/subsystem/train_controller/proc/update_tittle_screen()
	SStitle.title_html = TRAINSTATION_TITLE_HTML
	SStitle.show_title_screen()
	/*
	var/custom_css = file('fenysha_events/html/trainstation_tittle.css')
	if(custom_css)
		SStitle.current_title_screen = new(styles = custom_css)
		SStitle.current_title_screen.title_css = custom_css
	SStitle.set_title_image_silent('fenysha_events/icons/lobby/trainstation_v2.png')
	*/
	SSticker.set_lobby_music('fenysha_events/sounds/trainstation_lobbymusic.ogg', override = TRUE)
	for(var/client/C in GLOB.clients)
//		SStitle.show_title_screen_to(C)
		C?.playtitlemusic(volume_multiplier = 1)

#undef TRAINSTATION_TITLE_HTML

/datum/asset/simple/lobby
	assets = list(
		"OCRAExtended.ttf" = 'fenysha_events/html/OCRAEXT.TTF',
	)

/datum/controller/subsystem/train_controller/proc/announce_game()
	to_chat(world, span_boldnotice( \
		"[span_big("Trainstation mode - active")] \n \
		\n \
		The station will be replaced with a train, which is tasked with an important mission: to deliver a valuable cargo. \
		To do this, the train crew will have to guide the train across the trans-atlantic railway. \
		On the way to the goal, the train will face numerous threats and obstacles. \
		Drive the train and reach the final station. \n \
		\n \
		Event author: Fenysha, \n \
		Special thanks: Kierri, Mold, TYWONKA, V1S1Ti, Arturlang \n \
		Inspired by: The final station, Far: Lone Sails\
	"))


/datum/controller/subsystem/train_controller/proc/set_lobby_screen()
	SStitle.change_title_screen('fenysha_events/icons/lobby/trainstation_v3.png')
	return

/*
/datum/controller/subsystem/title/proc/set_title_image_silent(desired_image_file)
	if(desired_image_file)
		if(!isfile(desired_image_file))
			CRASH("Not a file passed to `/datum/controller/subsystem/title/proc/set_title_image`")
	else
		desired_image_file = pick_title_image()

	if(!current_title_screen)
		current_title_screen = new(screen_image_file = desired_image_file)
	else
		current_title_screen.set_screen_image(desired_image_file)

	for(var/mob/dead/new_player/viewer as anything in GLOB.new_player_list)
		INVOKE_ASYNC(src, PROC_REF(update_title_image_for_client), viewer.client)
*/
