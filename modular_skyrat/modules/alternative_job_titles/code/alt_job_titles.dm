/**
 * This is the file you should use to add alternate titles for each job, just
 * follow the way they're done here, it's easy enough and shouldn't take any
 * time at all to add more or add some for a job that doesn't have any.
 */

/datum/job
	/// The list of alternative job titles people can pick from, null by default.
	var/list/alt_titles = null


/datum/job/ai
	alt_titles = list(
		"AI",
		"Automated Overseer",
		"Station Intelligence",
	)

/datum/job/assistant
	alt_titles = list(
		"Assistant",
		"Ambassador",
		"Artist",
		"Actor",
		"Businessman",
		"Businesswoman",
		"Butler",
		"Colonist",
		"Contractor",
		"Civilian",
		"Duke",
		"Diplomat",
		"Entertainer",
		"Freelancer",
		"Fitness Instructor",
		"Fisher",
		"Fisherman",
		"Fisherwoman",
		"Hobbyist",
		"Tourist",
		"Trader",
		"Performer",
		"Personal Physician",
		"Off-Duty Crew",
		"Off-Duty Staff",
		"Off-Duty Personnel",
		"Musician",
		"Waiter",
	)

/datum/job/atmospheric_technician
	alt_titles = list(
		"Atmospheric Technician",
		"Emergency Fire Technician",
		"Firefighter",
		"Life Support Technician",
		"HVAC Engineer",
		"Habitability Technician",
	)

/datum/job/barber
	alt_titles = list(
		"Barber",
		"Aethestician",
		"Colorist",
		"Masseuse",
		"Salon Manager",
		"Salon Technician",
		"Stylist",
	)

/datum/job/bartender
	alt_titles = list(
		"Bartender",
		"Barista",
		"Barkeeper",
		"Tavernkeeper",
		"Mixologist",
	)

/datum/job/bitrunner
	alt_titles = list(
		"Bitrunner",
		"Bitdomain Technician",
		"Data Retrieval Specialist",
		"Netdiver",
		"Pod Jockey",
		"Union Bitrunner",
		"Junior Runner",
		"Professional Gamer",
	)

/datum/job/blueshield
	alt_titles = list(
		"Blueshield",
		"Command Bodyguard",
		"Executive Protection Agent",
		"Command Security Specialist",
		"Command Protection Officer",
		"Henchman",
	)

/datum/job/botanist
	alt_titles = list(
		"Botanist",
		"Apiarist",
		"Apiculturist",
		"Beekeeper",
		"Botanical Researcher",
		"Farmer",
		"Florist",
		"Gardener",
		"Herbalist",
		"Hydroponicist",
		"Mycologist",
		"Junior Botanist",
	)

/datum/job/bouncer
	alt_titles = list(
		"Bouncer",
		"Service Guard",
		"Doorman",
		"Doorwoman",
	)

/datum/job/corrections_officer
	alt_titles = list(
		"Corrections Officer",
		"Brig Ethics Officer",
		"Brig Officer",
		"Prison Guard",
		"Prisoner Safety Team",
		"Rehabilitation Officer",
	)

/datum/job/captain
	alt_titles = list(
		"Captain",
		"Commanding Officer",
		"Chief Executive Officer",
		"Facility Director",
		"Site Manager",
		"Station Commander",
	)

/datum/job/cargo_technician
	alt_titles = list(
		"Cargo Technician",
		"Commodities Trader",
		"Crate Pusher",
		"Deck Worker",
		"Inventory Associate",
		"Mail Carrier",
		"Mailman",
		"Mailwoman",
		"Merchantman",
		"Merchantwoman",
		"Postman",
		"Postwoman",
		"Receiving Clerk",
		"Union Associate",
		"Warehouse Technician",
	)

/datum/job/chaplain
	alt_titles = list(
		"Chaplain",
		"Cleric",
		"Clockwork Priest",
		"Guru",
		"High Priest",
		"High Priestess",
		"Imam",
		"Magister",
		"Monk",
		"Nun",
		"Oracle",
		"Pontifex",
		"Preacher",
		"Priest",
		"Priestess",
		"Rabbi",
		"Reverend",
		"Shrine Guardian",
		"Shrine Maiden",
	)

/datum/job/chemist
	alt_titles = list(
		"Chemist",
		"Alchemist",
		"Pharmacist",
		"Pharmacologist",
		"Trainee Pharmacist",
	)

/datum/job/chief_engineer
	alt_titles = list(
		"Chief Engineer",
		"Chief Technical Officer",
		"Engineering Foreman",
		"Head Crystallomancer",
		"Head of Engineering",
	)

/datum/job/chief_medical_officer
	alt_titles = list(
		"Chief Medical Officer",
		"Chief Physician",
		"Head of Medical",
		"Head Physician",
		"Medical Director",
	)

/datum/job/clown
	alt_titles = list(
		"Clown",
		"Comedian",
		"Jester",
		"Joker",
		"Prankster",
	)

/datum/job/cook
	alt_titles = list(
		"Cook",
		"All-American Diner Employee",
		"Baker",
		"Butcher",
		"Chef",
		"Confectionist",
		"Culinary Artist",
		"Fry Cook",
		"Junior Chef",
		"Line Cook",
		"Pastry Chef",
		"Sous-Chef",
		"Tavern Chef",
	)

/datum/job/coroner
	alt_titles = list(
		"Coroner",
		"Forensic Pathologist",
		"Funeral Director",
		"Medical Examiner",
		"Mortician",
		"Undertaker",
	)

/datum/job/curator
	alt_titles = list(
		"Curator",
		"Adventurer",
		"Archaeologist",
		"Archivist",
		"Conservator",
		"Historian",
		"Journalist",
		"Librarian",
		"Professor",
		"Veteran Adventurer"
	)

/datum/job/customs_agent
	alt_titles = list(
		"Customs Agent",
		"Supply Guard",
	)

/datum/job/cyborg
	alt_titles = list(
		"Cyborg",
		"Android",
		"Robot",
		"Synthetic",
		"Servitor",
	)

/datum/job/detective
	alt_titles = list(
		"Detective",
		"CID Officer",
		"Criminal Investigator",
		"Forensic Scientist",
		"Forensic Technician",
		"Gumshoe",
		"Private Investigator",
	)

/datum/job/doctor
	alt_titles = list(
		"Medical Doctor",
		"Epidemiologist",
		"General Practitioner",
		"Junior Pathologist",
		"Medical Resident",
		"Medical Student",
		"Nurse",
		"Pathologist",
		"Physician",
		"Surgeon",
		"Virologist",
	)

/datum/job/geneticist
	alt_titles = list(
		"Geneticist",
		"Gene Tailor",
		"Genemancer",
		"Genetic Engineer",
		"Genetics Researcher",
		"Mutation Researcher",
	)

/datum/job/head_of_personnel
	alt_titles = list(
		"Head of Personnel",
		"Crew Supervisor",
		"Employment Officer",
		"Executive Officer",
		"Head of Fursonnel",
	)

/datum/job/head_of_security
	alt_titles = list(
		"Head of Security",
		"Chief Constable",
		"Chief of Security",
		"Chief Security Officer",
		"Commander of the Guard",
		"Commissioner of Security",
		"Security Commander",
		"Security Commissioner",
		"Sheriff",
	)

/datum/job/janitor
	alt_titles = list(
		"Janitor",
		"Concierge",
		"Custodial Technician",
		"Custodian",
		"Groundskeeper",
		"Maid",
		"Sanitation Technician",
	)

/datum/job/lawyer
	alt_titles = list(
		"Lawyer",
		"Barrister",
		"Defense Attorney",
		"Human Resources Agent",
		"Internal Affairs Agent",
		"Legal Clerk",
		"Magistrate",
		"Prosecutor",
		"Public Defender",
	)

/datum/job/mime
	alt_titles = list(
		"Mime",
		"Mummer",
		"Pantomimist",
	)

/datum/job/nanotrasen_consultant
	alt_titles = list(
		"Nanotrasen Consultant",
		"Nanotrasen Advisor",
		"Nanotrasen Diplomat",
		"Nanotrasen Representative",
		"Nanotrasen Liason",// SPLURT REMOVAL OF CENTCOM RENAMES
		"Command Advisor",
		"Command Consultant",
		"Corporate Diplomat",
		"Corporate Interest Officer",
		"Corporate Liason",
		"Corporate Representative",
	)

/datum/job/orderly
	alt_titles = list(
		"Orderly",
		"Medical Guard",
	) //other dept guards' alt-titles should be kept to [department] guard to avoid confusion, unless the department gets a re-do.

/datum/job/paramedic
	alt_titles = list(
		"Paramedic",
		"Emergency Medical Technician",
		"Search and Rescue Technician",
		"Trauma Team Responder",
	)

/datum/job/prisoner
	alt_titles = list(
		"Prisoner",
		"Protective Custody Prisoner",
		"Minimum Security Prisoner",
		"Maximum Security Prisoner",
		"SuperMax Security Prisoner",
	)

/datum/job/psychologist
	alt_titles = list(
		"Psychologist",
		"Counsellor",
		"Psychiatrist",
		"Shrink",
		"Therapist",
	)

/datum/job/quartermaster
	alt_titles = list(
		"Quartermaster",
		"Deck Chief",
		"Head of Supply",
		"Logistics Coordinator",
		"Supply Foreman",
		"Union Requisitions Officer",
		"Warehouse Supervisor",
	)

/datum/job/research_director
	alt_titles = list(
		"Research Director",
		"Biorobotics Director",
		"Chief Science Officer",
		"Lead Researcher",
		"Research Supervisor",
		"Silicon Administrator",
	)

/datum/job/roboticist
	alt_titles = list(
		"Roboticist",
		"Apprentice Roboticist",
		"Biomechanical Engineer",
		"Cyberneticist",
		"Machinist",
		"Mechatronic Engineer",
	)

/datum/job/science_guard //See orderly
	alt_titles = list(
		"Science Guard",
		"Research Guard",
	)

/datum/job/scientist
	alt_titles = list(
		"Scientist",
		"Anomalist",
		"Circuitry Designer",
		"Cytologist",
		"Graduate Student",
		"Lab Technician",
		"Ordnance Technician",
		"Plasma Researcher",
		"Research Assistant",
		"Resonance Researcher",
		"Theoretical Physicist",
		"Xenoarchaeologist",
		"Xenobiologist",
	)

/datum/job/security_officer
	alt_titles = list(
		"Security Officer",
		"Defense Contractor",
		"Guard",
		"Junior Officer",
		"Peacekeeper",
		"Security Assistant",
		"Security Cadet",
		"Security Constable",
		"Security Guard",
		"Security Operative",
		"Security Specialist",
	)

/datum/job/shaft_miner
	alt_titles = list(
		"Shaft Miner",
		"Apprentice Miner",
		"Contract Miner",
		"Dredger",
		"Drill Technician",
		"Excavator",
		"Prospector",
		"Spelunker",
		"Union Miner",
	)

/datum/job/station_engineer
	alt_titles = list(
		"Station Engineer",
		"Apprentice Engineer",
		"Electrician",
		"Emergency Damage Control Technician",
		"Engine Technician",
		"EVA Technician",
		"Mechanic",
		"Repairs Technician",
	)

/datum/job/telecomms_specialist
	alt_titles = list(
		"Telecomms Specialist",
		"Network Engineer",
		"Sysadmin",
		"Tram Technician",
		"Wireless Operator",
	)


/datum/job/warden
	alt_titles = list(
		"Warden",
		"Armory Superintendent",
		"Brig Governor",
		"Brig Sentry",
		"Brig Sergeant",
		"Deputy Commissioner of Security",
		"Deputy Commissioner",
		"Dispatch Officer",
		"Jailer",
		"Master-at-Arms",
	)
