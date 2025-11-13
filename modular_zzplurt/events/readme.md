# The Modular Event System - v1.0

## Introduction

So, I heard you wanted to write code / make assets for your events, but using icon injectors and clever elements won't cut it? Well, here is where you can include your own code, sprites, sounds, maps, and more for your events!

## Why do this?

Good question! Instead of scattering your code and assets across the separated folders within `modular_zzplurt`, you can now keep everything related to your event in one single folder. This makes it easier to manage, share, and update your events. Additionally, event code and assets are generally more temporary compared to core game code, so isolating them helps maintain a cleaner codebase, in case you want to remove or update an event (and its assets) later on.

## Structure

Each event "framework" should have its own folder within `modular_zzplurt/events/`. For smaller events, you can keep everything in a single folder. For larger events, you can create subfolders within the event folder to organize your code and assets better. Think of each section as a mini-event within the larger event framework.

### Small event structure example

In this example, all code and assets are kept within a single folder for the event:

```
modular_zzplurt/
└── events/
	└── my_small_event/
		├── code/
		|	├── A.dm
		|	├── B.dm
		|	└── C.dm
		├── icons/
		|	├── D.dmi
		|	└── E.dmi
		└── sound/
			├── F.ogg
			└── G.ogg
```

### Large event structure example

For larger event frameworks, you can create subfolders within the event folder to better organize your code and assets:

```
modular_zzplurt/
└── events/
	└── my_large_event/
		|── section_alpha/
		|	├── code/
		|	|	├── A.dm
		|	|	├── B.dm
		|	|	└── C.dm
		|	├── icons/
		|	|	├── D.dmi
		|	|	└── E.dmi
		|	|── sound/
		|	|	├── F.ogg
		|	|	└── G.ogg
		|	└── maps/
		|		├── H.dmm
		|		└── I.dmm
		└── section_beta/
			├── code/
			|	├── J.dm
			|	├── K.dm
			|	└── L.dm
			├── icons/
			|	├── M.dmi
			|	└── N.dmi
			├── sound/
			|	├── O.ogg
			|	└── P.ogg
			└── maps/
				├── Q.dmm
				└── R.dmm
```

## Who's event is what?

To avoid confusion and ensure that assets are not tampered with, it is is highly suggested that each event folder have a `readme.md` file that specifies the event's name, description, and author(s). This will help keep things organized and make it easier for others to understand the purpose of each event.

## Modularity

While the file structure is different than the core game code, the modular event system still adheres to the same principles of modularity. It would be best to follow the conventions outlined in `The Modularization Handbook - S.P.L.U.R.T. Style, v1.0` when writing code for your events. This will ensure that your event code doesn't cause conflicts with other events or the core game code.

## Afterword

That's it for the modular event system! I hope this system makes it easier for you to create and manage your events. If you have any questions or suggestions, feel free to reach out!
