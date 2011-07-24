local SoundList = { }
local Punctuation = {"", " ", ".", ",", "!", "\"", "'", "?", "~", "*", "-", "=", "+", "(", ")", ":", ";", "#", "_", "&", "^", "@"}
local EndingOnlyPunctuation = {"s"}
local MutedPlayers = { }

SoundList[ "%." ] = { {0.3, ""} }

SoundList[ "we trusted you" ] = { 
{1.2233107089996, "vo/npc/male01/wetrustedyou01.wav"},
{1.0182087421417, "vo/npc/male01/wetrustedyou02.wav"} }

SoundList[ "yay" ] = { {1.0434467792511, "vo/coast/odessa/female01/nlo_cheer01.wav"} }
SoundList[ "what the hell" ] = { {0.87698417901993, "vo/k_lab/ba_whatthehell.wav"} }
SoundList[ "woohoo" ] = { {1.0753742456436, "vo/coast/odessa/female01/nlo_cheer02.wav"} }

SoundList[ "*cheer*" ] = { 
{1.0434467792511, "vo/coast/odessa/female01/nlo_cheer01.wav"},
{1.0753742456436, "vo/coast/odessa/female01/nlo_cheer02.wav"}, 
{2.4729251861572, "vo/coast/odessa/female01/nlo_cheer03.wav"}, 
{3.3680045604706, "vo/coast/odessa/male01/nlo_cheer01.wav"}, 
{1.4649434089661, "vo/coast/odessa/male01/nlo_cheer02.wav"},
{3.0941951274872, "vo/coast/odessa/male01/nlo_cheer03.wav"}, 
{2.6286849975586, "vo/coast/odessa/male01/nlo_cheer04.wav"} }

SoundList[ "hurray" ] = { {2.4729251861572, "vo/coast/odessa/female01/nlo_cheer03.wav"} }
SoundList[ "duck" ] = { {1.0245579481125, "vo/npc/barney/ba_duck.wav"} }
SoundList[ "can't talk" ] = {{2.5875964164734, "vo/trainyard/male01/cit_pedestrian03.wav"} }
SoundList[ "i can't take it anymore" ] = { {1.5496145486832, "vo/trainyard/wife_canttake.wav"} }


SoundList[ "over here" ] = { {1.1348526477814, "vo/streetwar/sniper/ba_overhere.wav"},
{0.8297278881073, "vo/trainyard/al_overhere.wav"} }

SoundList[ "grenades" ] = { {2.1695013046265, "vo/streetwar/sniper/ba_nag_grenade05.wav"} }

SoundList[ "incoming" ] = { 
{2.4329025745392, "vo/k_lab2/ba_incoming.wav"}, 
{0.90900230407715, "vo/npc/male01/incoming02.wav"}, 
{1.0505669116974, "vo/canals/female01/stn6_incoming.wav"}, 
{2.0555329322815, "vo/canals/male01/stn6_incoming.wav"} }

SoundList[ "cheese" ] = { {3.4074831008911, "vo/npc/male01/question06.wav"} }

SoundList[ "sorry" ] = { 
{0.46963718533516, "vo/npc/male01/sorry01.wav"}, 
{0.38149660825729, "vo/npc/male01/sorry02.wav"}, 
{0.58195018768311, "vo/npc/female01/sorry01.wav"}, 
{0.73723357915878, "vo/npc/female01/sorry02.wav"} }

SoundList[ "sorry for the scare" ] = { {3.1238322257996, "vo/trainyard/ba_sorryscare.wav"} }
SoundList[ "this is bad" ] = { {0.70736968517303, "vo/npc/male01/gordead_ques10.wav"} }

SoundList[ "NO D:" ] = { { 1.3854422569275, "vo/npc/male01/no02.wav"} }

SoundList[ "no!" ] = { 
{1.3854422569275, "vo/npc/male01/no02.wav"}, 
{1.3793425559998, "vo/npc/male01/no01.wav"}, 
{2.1246259212494, "vo/coast/odessa/female01/nlo_cubdeath01.wav"}, 
{0.74594110250473, "vo/coast/odessa/female01/nlo_cubdeath02.wav"}, 
{0.93965989351273, "vo/streetwar/alyx_gate/al_no.wav"}, 
{1.1253062486649, "vo/npc/barney/ba_no01.wav"}, 
{1.0149886608124, "vo/npc/barney/ba_no02.wav"}, 
{0.78303861618042, "vo/citadel/br_no.wav"}  }
SoundList[ "noo" ] = SoundList[ "no!" ]

SoundList[ "oh no" ] = { 
{0.59782320261002, "vo/npc/male01/ohno.wav"}, 
{0.79238098859787, "vo/npc/female01/ohno.wav"}, 
{0.8271656036377, "vo/npc/female01/gordead_ans05.wav"},
{1.1217688322067, "vo/npc/alyx/ohno_startle01.wav"},
{1.6478004455566, "vo/npc/alyx/ohno_startle03.wav"} }
SoundList[ "oh noes" ] = SoundList[ "oh no" ]

SoundList[ "ok" ] = { 
{0.64480727910995, "vo/npc/male01/ok02.wav"}, 
{0.46235829591751, "vo/npc/male01/ok01.wav"}, 
{0.48616790771484, "vo/npc/female01/ok01.wav"}, 
{0.49850350618362, "vo/npc/female01/ok02.wav"} }
SoundList[ "okay" ] = SoundList[ "ok" ]
SoundList[ "okey" ] = SoundList[ "ok" ]
SoundList[ "kay" ] = SoundList[ "ok" ]

SoundList[ "one for me" ] = { {2.6738777160645, "vo/npc/male01/oneforme.wav"} }
SoundList[ "follow" ] = { {0.79269850254059, "vo/coast/cardock/le_followme.wav"} }
SoundList[ "this way" ] = { {1.1672109365463, "vo/npc/barney/ba_followme01.wav"} }
SoundList[ "come on" ] = {
{0.97054427862167, "vo/npc/barney/ba_followme02.wav"},
{1.2309523820877, "vo/npc/barney/ba_followme03.wav"},
{0.66603177785873, "vo/citadel/al_comeon.wav"} }
SoundList[ "c'mon" ] = SoundList[ "come on" ]

SoundList[ "lol" ] = { 
{1.315328836441, "vo/npc/barney/ba_laugh01.wav"}, 
{1.4632879495621, "vo/npc/barney/ba_laugh02.wav"}, 
{1.4139683246613, "vo/npc/barney/ba_laugh04.wav"},
{3.8755328655243, "vo/citadel/br_laugh01.wav"} }

SoundList[ "haha" ] = SoundList[ "lol" ]
SoundList[ "hahah" ] = SoundList[ "lol" ]
SoundList[ "hahaha" ] = SoundList[ "lol" ]
SoundList[ "hahahah" ] = SoundList[ "lol" ]
SoundList[ "hahahaha" ] = SoundList[ "lol" ]
SoundList[ "lolol" ] = SoundList[ "lol" ]
 
SoundList[ "ok i'm ready" ] = {
{1.0902267694473, "vo/npc/male01/okimready03.wav"},
{0.7572563290596, "vo/npc/male01/okimready02.wav"},
{0.93755108118057, "vo/npc/male01/okimready01.wav"},
{0.95346939563751, "vo/npc/female01/okimready03.wav"},
{0.97741502523422, "vo/npc/female01/okimready02.wav"},
{0.85551029443741, "vo/npc/female01/okimready01.wav"} }

SoundList[ "hm" ] = {
{0.25126990675926, "vo/k_lab/al_hmm.wav"},
{0.29308399558067, "vo/k_lab/al_buyyoudrink01.wav"} }

SoundList[ "uh oh" ] = { {0.69757372140884, "vo/novaprospekt/al_uhoh_np.wav"} }
SoundList[ "shut it down" ] = { {1.4982086420059, "vo/k_lab/eli_shutdown.wav"} }




SoundList[ "behind you" ] = { {0.99174612760544, "vo/k_lab/eli_behindyou.wav"} }




SoundList[ "sweet" ] = { {0.9059864282608, "vo/eli_lab/al_sweet.wav"} }
SoundList[ "run" ] = { {2.0011339187622, "vo/npc/male01/strider_run.wav"}, {0.80253970623016, "vo/npc/female01/strider_run.wav"} }

SoundList[ "help" ] = {
{0.46748301386833, "vo/npc/male01/help01.wav"},
{1.2301588058472, "vo/streetwar/sniper/male01/c17_09_help01.wav"},
{0.75888890028, "vo/streetwar/sniper/male01/c17_09_help02.wav"},
{1.7047393321991, "vo/canals/arrest_helpme.wav"} }
SoundList[ "halp" ] = SoundList[ "help" ]

SoundList[ "pissing me off" ] = { {1.4620409011841, "vo/k_lab/ba_pissinmeoff.wav"} }
SoundList[ "there he is" ] = { {0.79578238725662, "vo/k_lab/ba_thereheis.wav"} }
SoundList[ "done" ] = { {0.87145131826401, "vo/streetwar/nexus/ba_done.wav"} }
SoundList[ "yes" ] = { {1.0453515052795, "vo/npc/vortigaunt/yes.wav"}, {0.72684812545776, "vo/citadel/al_yes_nr.wav"}, {1, "vo/demoman_yes03.wav"}, {1, "vo/heavy_yes02.wav"}, {1, "vo/medic_yes03.wav"}, {1, "vo/soldier_yes02.wav"}, {1, "vo/spy_yes01.wav"} }

SoundList[ "zombies" ] = {
{1.2224264144897, "vo/npc/male01/zombies01.wav"},
{0.82238101959229, "vo/npc/male01/zombies02.wav"},
{0.88888889551163, "vo/npc/female01/zombies01.wav"},
{0.81995469331741, "vo/npc/female01/zombies02.wav"} }

SoundList[ "thirty" ] = { {0.29634928703308, "npc/metropolice/vo/thirty.wav"} }
SoundList[ "twenty" ] = { {0.29634928703308, "npc/metropolice/vo/twenty.wav"} }
SoundList[ "nineteen" ] = { {0.23219959437847, "npc/metropolice/vo/nineteen.wav"} }
SoundList[ "eighteen" ] = { {0.34859418869019, "npc/metropolice/vo/eighteen.wav"} }
SoundList[ "seventeen" ] = { {0.37743771076202, "npc/metropolice/vo/seventeen.wav"} }
SoundList[ "sixteen" ] = { {0.35333341360092, "npc/metropolice/vo/sixteen.wav"} }
SoundList[ "fifteen" ] = { {0.27809530496597, "npc/metropolice/vo/fifteen.wav"} }
SoundList[ "fourteen" ] = { {0.30922910571098, "npc/metropolice/vo/fourteen.wav"} }
SoundList[ "thirteen" ] = { {0.19031749665737, "npc/metropolice/vo/thirteen.wav"} }
SoundList[ "twelve" ] = { {0.37582769989967, "npc/metropolice/vo/twelve.wav"} }
SoundList[ "eleven" ] = { {0.26176878809929, "npc/metropolice/vo/eleven.wav"} }
SoundList[ "ten" ] = { {0.17299319803715, "npc/metropolice/vo/ten.wav"} }
SoundList[ "nine" ] = { {0.18791389465332, "npc/metropolice/vo/nine.wav"} }
SoundList[ "eight" ] = { {0.13791389763355, "npc/metropolice/vo/eight.wav"} }
SoundList[ "seven" ] = { {0.24111120402813, "npc/metropolice/vo/seven.wav"} }
SoundList[ "six" ] = { {0.2033333927393, "npc/metropolice/vo/six.wav"} }
SoundList[ "five" ] = { {0.26299318671227, "npc/metropolice/vo/five.wav"} }
SoundList[ "four" ] = { {0.2497732937336, "npc/metropolice/vo/four.wav"} }
SoundList[ "three" ] = { {0.21879820525646, "npc/metropolice/vo/three.wav"} }
SoundList[ "two" ] = { {0.23859420418739, "npc/metropolice/vo/two.wav"} }
SoundList[ "one" ] = { {0.16777780652046, "npc/metropolice/vo/one.wav"} }
SoundList[ "zero" ] = { {0.27106580138206, "npc/metropolice/vo/zero.wav"} }

SoundList[ "damn it" ] = {
{0.56412702798843, "vo/eli_lab/al_dogairlock01.wav"},
{0.60920637845993, "vo/npc/barney/ba_damnit.wav"},
{0.37281179428101, "vo/k_lab/ba_getitoff01.wav"} }
SoundList[ "dammit" ] = SoundList[ "damn it" ]
SoundList[ "damnit" ] = SoundList[ "damn it" ]



SoundList[ "get in here" ] = { {0.59145128726959, "vo/eli_lab/al_intoairlock02.wav"} }



SoundList[ "that's it" ] = { {0.61356008052826, "vo/k_lab/al_thatsit.wav"} }
SoundList[ "he's right here" ] = { {0.65469390153885, "vo/eli_lab/al_heshere.wav"} }
SoundList[ "excellent" ] = {
{0.74814057350159, "vo/eli_lab/al_excellent01.wav"},
{0.84414970874786, "vo/k_lab/kl_excellent.wav"} }

SoundList[ "hurry" ] = { {0.80698418617249, "vo/eli_lab/al_intoairlock04.wav"} }
SoundList[ "awesome" ] = { {0.82247167825699, "vo/eli_lab/al_awesome.wav"} }
SoundList[ "what's going on" ] = { {0.88210892677307, "vo/k_lab/al_whatsgoingon.wav"} }
SoundList[ "careful" ] = { {0.96256238222122, "vo/k_lab/al_careful.wav"} }
SoundList[ "where's your ball" ] = { {0.99913841485977, "vo/eli_lab/al_wheresball.wav"} }



SoundList[ "good boy" ] = { {1.0954421758652, "vo/k_lab2/al_goodboy.wav"} }



SoundList[ "hold on" ] = { {1.1046713590622, "vo/novaprospekt/al_holdon.wav"} }
SoundList[ "bullshit" ] = { {2.3707256317139, "vo/novaprospekt/al_enoughbs01.wav"} }
SoundList[ "omg" ] = { {1.2329251766205, "ohmygod.wav"} }
SoundList[ "oh my god" ] = { {1.2329251766205, "ohmygod.wav"} }
SoundList[ "faggot" ] = { {0.4502041041851, "faggot.wav"} }
SoundList[ "faggit" ] = SoundList[ "faggot" ]
SoundList[ "bag it" ] = SoundList[ "faggot" ]

SoundList[ "greetings" ] = { {4.4145579338074, "vo/ravenholm/yard_greetings.wav"} }
SoundList[ "gtho" ] = { {2.4458277225494, "vo/npc/male01/gethellout.wav"} }

SoundList[ "muaha" ] = {
{0.55285722017288, "vo/eli_lab/mo_airlock03.wav"},
{4.9238777160645, "vo/ravenholm/madlaugh03.wav"},
{2.2478458881378, "vo/ravenholm/madlaugh02.wav"},
{2.3548979759216, "vo/ravenholm/madlaugh01.wav"},
{2.3548979759216, "vo/ravenholm/madlaugh04.wav"} }
SoundList[ "muhah" ] = SoundList[ "muaha" ]
SoundList[ "muahah" ] = SoundList[ "muaha" ]
SoundList[ "muahaha" ] = SoundList[ "muaha" ]
SoundList[ "muahahah" ] = SoundList[ "muaha" ]
SoundList[ "muahahaha" ] = SoundList[ "muaha" ]

SoundList[ "hello" ] = {
{0.55285722017288, "vo/eli_lab/mo_airlock03.wav"},
{0.61938780546188, "vo/outland_11a/silo/mag_silo_falsealarms01.wav"},
{0.61938780546188, "vo/aperture_ai/post_escape_bridge_01.wav"},
{0.61938780546188, "vo/aperture_ai/escape_00_part1_nag01-1.wav"}
 }

SoundList[ "hey" ] = {
{0.44507938623428, "vo/streetwar/alyx_gate/al_hey.wav"},
{0.91467130184174, "vo/canals/shanty_hey.wav"},
{0.63999998569489, "vo/outland_11a/silo/eli_silo_heardclose01.wav"} }

SoundList[ "hi" ] = { {0.37807258963585, "vo/npc/female01/hi01.wav"},
{0.31541961431503, "vo/npc/female01/hi02.wav"},
{0.23557829856873, "vo/npc/male01/hi01.wav"},
{0.34301590919495, "vo/npc/male01/hi02.wav"} }
SoundList[ "hai" ] = SoundList[ "hi" ]
SoundList[ "hay" ] = SoundList[ "hi" ]

SoundList[ "rise and shine" ] = { {6.6553115844727, "vo/gman_misc/gman_riseshine.wav"} }
SoundList[ "yeah" ] = {

{0.72489798069, "vo/npc/female01/yeah02.wav"},
{0.87521547079086, "vo/npc/male01/yeah02.wav"} }

SoundList[ "i'm in the middle of a critical test" ] = { {2.4687528610229, "vo/trainyard/kl_whatisit02.wav"} }
SoundList[ "ops" ] = {
{0.43712019920349, "vo/k_lab/ba_whoops.wav"},
{0.48206350207329, "vo/npc/female01/whoops01.wav"},
{0.40922909975052, "vo/npc/male01/whoops01.wav"} }
SoundList[ "oops" ] = SoundList[ "ops" ]

SoundList[ "fiddlesticks" ] = { {2.2442631721497, "vo/k_lab/kl_fiddlesticks.wav"} }
SoundList[ "rest my child" ] = { {2.003356218338, "vo/ravenholm/monk_kill03.wav"} }

SoundList[ "come" ] = {
{1.0060317516327, "vo/ravenholm/engage02.wav"},
{0.98417240381241, "vo/ravenholm/engage03.wav"} }
SoundList[ "cum" ] = SoundList[ "come" ]

SoundList[ "little girls" ] = { {5.6933331489563, "littlegirls.mp3"} }
SoundList[ "littlegirls" ] = SoundList[ "little girls" ]
--SoundList[ "wryyy" ] = { {1.6280000209808, "wryyy.mp3"} }
--SoundList[ "ma boi" ] = { {0.7, "myboy.mp3"} }
--SoundList[ "ma boy" ] = SoundList[ "ma boi" ]
--SoundList[ "my boy" ] = SoundList[ "ma boi" ]
--SoundList[ "mah boi" ] = SoundList[ "ma boi" ]
--SoundList[ "mah boy" ] = SoundList[ "ma boi" ]


SoundList[ "please" ] = { {1.1068707704544, "vo/trainyard/wife_please.wav"} }
SoundList[ "plz" ] = SoundList[ "please" ]
SoundList[ "it's safer here" ] = { {1.2229479551315, "vo/breencast/br_welcome07.wav"} }

SoundList[ "*tf2cheer*" ] = { 
{7.5639004707336, "misc/happy_birthday.wav"}, 
{1.387392282486, "vo/engineer_cheers01.wav"}, 
{1.8808163404465, "vo/engineer_cheers02.wav"}, 
{3.3320634365082, "vo/engineer_cheers07.wav"}, 
{1.3438549041748, "vo/heavy_cheers01.wav"}, 
{1.6428117752075, "vo/heavy_cheers02.wav"}, 
{1.9562811851501, "vo/heavy_cheers04.wav"}, 
{4.4001812934875, "vo/heavy_cheers07.wav"}, 
{6.7105669975281, "vo/heavy_cheers08.wav"}, 
{1.0216780900955, "vo/medic_cheers01.wav"}, 
{1.013333439827, "vo/pyro_cheers01.wav"}, 
{0.79528349637985, "vo/scout_cheers01.wav"}, 
{0.92879819869995, "vo/scout_cheers03.wav"}, 
{0.88235831260681, "vo/scout_cheers06.wav"}, 
{0.98684811592102, "vo/sniper_cheers01.wav"},
{1.5325170755386, "vo/sniper_cheers05.wav"}, 
{1.1493878364563, "vo/sniper_cheers07.wav"}, 
{1.3815873861313, "vo/sniper_cheers08.wav"}, 
{1.1116553544998, "vo/soldier_cheers05.wav"}, 
{1.1232653856277, "vo/soldier_cheers06.wav"} }

SoundList[ "alert" ] = { {1.3508616685867, "vo/announcer_alert.wav"} }
SoundList[ "attention" ] = { {1.6730386018753, "vo/announcer_attention.wav"} }
SoundList[ "attn" ] = SoundList[ "attention" ]
SoundList[ "failure" ] = { {1.8486394882202, "vo/announcer_failure.wav"} }
SoundList[ "fail" ] = SoundList[ "failure" ]
SoundList[ "phail" ] = SoundList[ "failure" ]

SoundList[ "you suck" ] = { {0.6, "vo/test_two.wav"} }
SoundList[ "pick up some stuff and toss it" ] = { {1.1722903251648, "vo/eli_lab/al_pickuptoss.wav"} }
SoundList[ "never" ] = { {0.62045359611511, "vo/citadel/eli_nonever.wav"} }
SoundList[ "oh shit" ] = { {1.2653287649155, "vo/citadel/br_ohshit.wav"} }
SoundList[ "oh shi" ] = SoundList[ "oh shit" ]
SoundList[ "ohshi" ] = SoundList[ "oh shit" ]

SoundList[ "gunship" ] = { 
{0.89698421955109, "vo/coast/barn/male01/lite_gunship02.wav"}, 
{0.83086168766022, "vo/coast/barn/male01/lite_gunship01.wav"}, 
{0.57614517211914, "vo/coast/barn/female01/lite_gunship02.wav"}, 
{0.78802728652954, "vo/coast/barn/female01/lite_gunship01.wav"} }

SoundList[ "take it" ] = { {0.3897733092308, "vo/eli_lab/al_takeit.wav"} }
SoundList[ "oh" ] = { {0.23984129726887, "vo/eli_lab/mo_hereseli01.wav"} }
SoundList[ "sure" ] = { {0.50990927219391, "vo/eli_lab/al_gravgun.wav"} }
SoundList[ "allright" ] = { {0.70283448696136, "vo/eli_lab/al_allright01.wav"} }
SoundList[ "aight" ] = { {0.70283448696136, "vo/eli_lab/al_allright01.wav"} }
SoundList[ "you there" ] = { {0.82335609197617, "vo/coast/bugbait/sandy_youthere.wav"} }
SoundList[ "oh dear" ] = { {0.57646262645721, "vo/k_lab/kl_ohdear.wav"} }
SoundList[ "gee thanks" ] = { {0.83081638813019, "vo/k_lab/ba_geethanks.wav"} }
SoundList[ "fascinating" ] = { {1.5657824277878, "vo/k_lab2/kl_slowteleport01.wav"} }
SoundList[ "great scott" ] = { {1.6252380609512, "vo/k_lab2/kl_greatscott.wav"} }

SoundList[ "demolaugh" ] = { 
{5.0503401756287, "vo/demoman_laughlong02.wav"}, 
{5.2244896888733, "vo/demoman_laughlong01.wav"}, 
{2.3510205745697, "vo/demoman_laughhappy02.wav"}, 
{2.2175056934357, "vo/demoman_laughhappy01.wav"}, 
{2.1130158901215, "vo/demoman_laughevil01.wav"}, 
{2.2929706573486, "vo/demoman_laughevil02.wav"}, 
{2.1594557762146, "vo/demoman_laughevil03.wav"}, 
{1.1261678934097, "vo/demoman_laughevil04.wav"}, 
{1.1842176914215, "vo/demoman_laughevil05.wav"}, 
{1.3409523963928, "vo/demoman_laughshort01.wav"}, 
{1.3061225414276, "vo/demoman_laughshort02.wav"}, 
{0.55292522907257, "vo/demoman_laughshort03.wav"}, 
{0.48471659421921, "vo/demoman_laughshort04.wav"}, 
{1.2625850439072, "vo/demoman_laughshort05.wav"}, 
{0.92589569091797, "vo/demoman_laughshort06.wav"} }

SoundList[ "mediclaugh" ] = { 
{0.91428577899933, "vo/medic_laughevil01.wav"}, 
{0.81560099124908, "vo/medic_laughevil02.wav"}, 
{1.0594104528427, "vo/medic_laughevil03.wav"}, 
{4.2724719047546, "vo/medic_laughevil04.wav"}, 
{3.0882539749146, "vo/medic_laughevil05.wav"}, 
{3.424943447113, "vo/medic_laughhappy01.wav"}, 
{3.0882539749146, "vo/medic_laughhappy02.wav"}, 
{1.9214513301849, "vo/medic_laughhappy03.wav"}, 
{3.7616326808929, "vo/medic_laughlong01.wav"}, 
{6.5596370697021, "vo/medic_laughlong02.wav"}, 
{0.56308400630951, "vo/medic_laughshort01.wav"}, 
{0.71111118793488, "vo/medic_laughshort02.wav"}, 
{0.9462131857872, "vo/medic_laughshort03.wav"} }

SoundList[ "pyrolaugh" ] = { 
{2.3520181179047, "vo/pyro_laughlong01.wav"},
{0.8853514790535, "vo/pyro_laughevil02.wav"},
{0.47467130422592, "vo/pyro_laughevil03.wav"},
{1.1733334064484, "vo/pyro_laughevil04.wav"} }

SoundList[ "sniperlaugh" ] = { 
{3.1927437782288, "vo/sniper_laughlong02.wav"},
{5.2477097511292, "vo/sniper_laughlong01.wav"},
{0.80108851194382, "vo/sniper_laughhappy02.wav"},
{1.1842176914215, "vo/sniper_laughhappy01.wav"},
{1.4396371841431, "vo/sniper_laughevil03.wav"},
{1.904036283493, "vo/sniper_laughevil02.wav"},
{2.1246259212494, "vo/sniper_laughevil01.wav"} }

SoundList[ "heavylaugh" ] = { 
{3.1230840682983, "vo/heavy_laughlong02.wav"}, 
{6.5015873908997, "vo/heavy_laughlong01.wav"}, 
{2.0259411334991, "vo/heavy_laughhappy05.wav"}, 
{1.1551928520203, "vo/heavy_laughhappy01.wav"}, 
{2.1652607917786, "vo/heavy_laughhappy02.wav"}, 
{2.6935148239136, "vo/heavy_laughhappy03.wav"}, 
{1.9446712732315, "vo/heavy_laughhappy04.wav"} }

SoundList[ "scoutlaugh" ] = { 
{4.7717008590698, "vo/scout_laughlong02.wav"}, 
{5.7469387054443, "vo/scout_laughlong01.wav"}, 
{0.96943318843842, "vo/scout_laughhappy01.wav"}, 
{5.3870296478271, "vo/scout_laughhappy02.wav"}, 
{1.4338321685791, "vo/scout_laughhappy03.wav"}, 
{1.448344707489, "vo/scout_laughhappy04.wav"} }

SoundList[ "soliderlaugh" ] = { 
{1.7124717235565, "vo/soldier_laughevil01.wav"},
{1.7531065940857, "vo/soldier_laughevil02.wav"},
{0.67337870597839, "vo/soldier_laughevil03.wav"},
{1.3699773550034, "vo/soldier_laughhappy01.wav"},
{1.22485268116, "vo/soldier_laughhappy02.wav"},
{2.1014058589935, "vo/soldier_laughhappy03.wav"},
{3.4713833332062, "vo/soldier_laughlong01.wav"},
{4.8297505378723, "vo/soldier_laughlong02.wav"},
{4.0867118835449, "vo/soldier_laughlong03.wav"},
{1.1522903442383, "vo/soldier_laughshort01.wav"},
{1.2712925672531, "vo/soldier_laughshort02.wav"},
{0.37732431292534, "vo/soldier_laughshort03.wav"},
{1.0797278881073, "vo/soldier_laughshort04.wav"} }

SoundList[ "spylaugh" ] = { 
{2.0027210712433, "vo/spy_laughevil01.wav"},
{1.4686621427536, "vo/spy_laughevil02.wav"},
{1.8634014129639, "vo/spy_laughhappy01.wav"},
{1.1290702819824, "vo/spy_laughhappy02.wav"},
{1.6660318374634, "vo/spy_laughhappy03.wav"},
{6.4667572975159, "vo/spy_laughlong01.wav"},
{0.77496600151062, "vo/spy_laughshort01.wav"},
{1.2596826553345, "vo/spy_laughshort02.wav"},
{0.87074828147888, "vo/spy_laughshort03.wav"},
{0.88816332817078, "vo/spy_laughshort04.wav"},
{0.7778685092926, "vo/spy_laughshort05.wav"},
{0.63854879140854, "vo/spy_laughshort06.wav"} }

SoundList[ "engineerlaugh" ] = { 
{1.2074377536774, "vo/engineer_laughevil01.wav"},
{2.0027210712433, "vo/engineer_laughevil02.wav"},
{1.1784126758575, "vo/engineer_laughevil03.wav"},
{1.3438549041748, "vo/engineer_laughevil04.wav"},
{0.83591842651367, "vo/engineer_laughevil05.wav"},
{1.8111565113068, "vo/engineer_laughevil06.wav"},
{2.043356180191, "vo/engineer_laughhappy01.wav"},
{1.8401814699173, "vo/engineer_laughhappy02.wav"},
{1.683446764946, "vo/engineer_laughhappy03.wav"},
{4.6207709312439, "vo/engineer_laughlong01.wav"},
{1.5615420341492, "vo/engineer_laughshort01.wav"},
{1.4077098369598, "vo/engineer_laughshort02.wav"},
{1.219047665596, "vo/engineer_laughshort03.wav"},
{0.96362817287445, "vo/engineer_laughshort04.wav"} }

SoundList[ "nope" ] = { {0.36861678957939, "vo/engineer_no01.wav"} }
SoundList[ "nah" ] = { {0.69079369306564, "vo/engineer_no02.wav"} }
SoundList[ "hehe" ] = { {3.1923332214355, "hehe.mp3"} }
SoundList[ "get out" ] = { {0.81616789102554, "vo/canals/shanty_go_nag01.wav"}, {0.96113377809525, "vo/canals/boxcar_go_nag03.wav"} }
SoundList[ "get going" ] = { {0.7626531124115, "vo/canals/matt_go_nag04.wav"} }
SoundList[ "take it" ] = { {0.3897733092308, "vo/eli_lab/al_takeit.wav"} }
SoundList[ "here" ] = { {0.3005442917347, "vo/k_lab/al_buyyoudrink02.wav"} }

SoundList[ "bonk" ] = { {0.44553288817406, "vo/scout_specialcompleted03.wav"}, {0.48036289215088, "vo/scout_specialcompleted02.wav"} }

SoundList[ "serve mankind" ] = { {1.429093003273, "vo/breencast/br_tofreeman12.wav"} }
SoundList[ "i'm talking to you" ] = { {2.1296372413635, "vo/breencast/br_tofreeman02.wav"} }
SoundList[ "get in here" ] = { {0.97451251745224, "vo/canals/matt_getin.wav"} }
SoundList[ "yes!" ] = { {2.2283446788788, "vo/citadel/al_success_yes_nr.wav"} }
SoundList[ "what now" ] = { {0.51780050992966, "vo/npc/female01/gordead_ques16.wav"} }
SoundList[ "wanna bet" ] = { {0.5987074971199, "vo/npc/female01/answer27.wav"} }
SoundList[ "hax" ] = {
{0.60879820585251, "vo/npc/female01/hacks02.wav"},
{0.63782322406769, "vo/npc/female01/hacks01.wav"},
{0.77433109283447, "vo/npc/male01/hacks02.wav"},
{1.2454421520233, "vo/npc/male01/hacks01.wav"} }
SoundList[ "hacks" ] = SoundList[ "hax" ]

SoundList[ "right on" ] = { {0.656893491745, "vo/npc/female01/answer32.wav"} }
SoundList[ "let's go" ] = {
{0.65886628627777, "vo/npc/female01/letsgo01.wav"},
{0.61823129653931, "vo/npc/female01/letsgo02.wav"},
{1.2478004693985, "vo/npc/male01/letsgo01.wav"},
{0.73691612482071, "vo/npc/male01/letsgo02.wav"} }

SoundList[ "nice" ] = {
{0.70240372419357, "vo/npc/female01/nice01.wav"},
{0.7161905169487, "vo/npc/female01/nice02.wav"} }
SoundList[ "watch out" ] = { {0.72707492113113, "vo/npc/female01/watchout.wav"} }
SoundList[ "oh god" ] = { {0.76630389690399, "vo/npc/female01/gordead_ans04.wav"} }
SoundList[ "behind you" ] = { {0.76770979166031, "vo/npc/female01/behindyou01.wav"} }
SoundList[ "same here" ] = { "vo/npc/female01/answer07.wav" }
SoundList[ "now what" ] = { {0.79664397239685, "vo/npc/female01/gordead_ans01.wav"} }
SoundList[ "i'll stay here" ] = { {0.79528349637985, "vo/npc/female01/illstayhere01.wav"} }
SoundList[ "are you sure about that" ] = { "vo/npc/female01/answer38.wav" }
SoundList[ "orgasm" ] = { {0.81850349903107, "vo/npc/female01/pain06.wav"} }
SoundList[ "lead the way" ] = {
{0.83446717262268, "vo/npc/female01/leadtheway01.wav"},
{0.84172338247299, "vo/npc/female01/leadtheway02.wav"},
{0.83761912584305, "vo/npc/male01/leadtheway01.wav"},
{0.66115647554398, "vo/npc/male01/leadtheway02.wav"} }


SoundList[ "good god" ] = {  {0.86784589290619,"vo/npc/female01/goodgod.wav"} }


SoundList[ "fantastic" ] = {
{1.0071655511856, "vo/npc/female01/fantastic01.wav"},
{0.90267580747604, "vo/npc/female01/fantastic02.wav"},
{1.7272336483002, "vo/npc/male01/fantastic01.wav"},
{0.83995467424393, "vo/npc/male01/fantastic02.wav"} }
SoundList[ "get down" ] = {
{0.91573697328568, "vo/npc/female01/getdown02.wav"},
{0.87818598747253, "vo/npc/male01/getdown02.wav"} }
SoundList[ "what's the point" ] = { {0.91585040092468, "vo/npc/female01/gordead_ans12.wav"} }
SoundList[ "finally" ] = { {0.99265307188034, "vo/npc/female01/finally.wav"} }
SoundList[ "this is bullshit" ] = { {1.0009070634842, "vo/npc/female01/question26.wav"} }
SoundList[ "speak english" ] = { {1.0966893434525, "vo/npc/female01/vanswer05.wav"} }
SoundList[ "watch what you're doing" ] = { {1.1290702819824, "vo/npc/female01/watchwhat.wav"} }
SoundList[ "you got that from me" ] = { {1.1538321971893, "vo/npc/female01/vanswer06.wav"} }
SoundList[ "what am i supposed to do about it" ] = { {1.2367347478867, "vo/npc/female01/answer29.wav"} }
SoundList[ "stop you're killing me" ] = { {1.2518141269684, "vo/npc/female01/vanswer13.wav"} }
SoundList[ "i wouldn't say that too loud" ] = {
{1.3513605594635, "vo/npc/female01/answer10.wav"},
{1.8621768951416, "vo/npc/male01/answer10.wav"} }
SoundList[ "run for your life" ] = { {1.4856916666031, "vo/npc/female01/runforyourlife02.wav"} }
SoundList[ "figures" ] = { {0.58519279956818, "vo/npc/male01/answer03.wav"} }
SoundList[ "same here" ] = { {0.7265533208847, "vo/npc/male01/answer07.wav"} }
SoundList[ "i know what you mean" ] = { {0.73981857299805, "vo/npc/male01/answer08.wav"} }
SoundList[ "i'm with you" ] = { {0.76950120925903, "vo/npc/male01/answer13.wav"} }
SoundList[ "you never know" ] = { {0.76256239414215, "vo/npc/male01/answer22.wav"} }
SoundList[ "why are you telling me" ] = { {1.1542631387711, "vo/npc/male01/answer24.wav"} }
SoundList[ "are you sure about that" ] = { {0.71079367399216, "vo/npc/male01/answer37.wav"} }
SoundList[ "damn" ] = { {0.68535149097443, "vo/outland_01/intro/al_rbed_whatnow01.wav"} }
SoundList[ "what was that" ] = { {0.80000001192093, "vo/outland_01/intro/al_rbed_whatthat.wav"} }
SoundList[ "woah" ] = { {0.864013671875, "vo/outland_01/intro/al_rbed_whoa.wav"} }
SoundList[ "my god" ] = { {1.0506802797318, "vo/outland_01/intro/al_transmit_grabbed01.wav"} }
SoundList[ "thank god" ] = { {1.2746713161469, "vo/outland_01/intro/eli_transmit_believe02.wav"} }
SoundList[ "portal storm" ] = { {1.3120181560516, "vo/outland_01/intro/al_rbed_aportalstorm.wav"} }
SoundList[ "i can hardly believe it" ] = { {1.4906803369522, "vo/outland_01/intro/eli_transmit_believe03.wav"} }
SoundList[ "good god" ] = { {1.5466667413712, "vo/outland_01/intro/eli_transmit_goodgod.wav"} }
SoundList[ "you idiot" ] = { {0.88478457927704, "vo/outland_02/sheckley_idiot02.wav"} }
SoundList[ "what" ] = { {0.46850350499153, "vo/outland_02/sheckley_betweenwave_conver2_01.wav"} }


SoundList[ "wow" ] = {
{1.3440136909485, "vo/outland_05/canyon/al_canyon_pissitoff01.wav"},
{0.74458050727844, "vo/outland_11a/silo/al_silo_wow.wav"},
{1.4506802558899, "vo/outland_12a/launch/al_launch_wow.wav"} }


SoundList[ "where are you" ] = { {1.1549206972122, "vo/outland_06a/radio/mag_rad_expectedyou03.wav"} }
SoundList[ "crap" ] = { {1.3440136909485, "vo/outland_06a/radio/al_rad_crap.wav"} }
SoundList[ "sh" ] = { {1.4853514432907, "vo/outland_06a/radio/al_rad_sh.wav"} }
SoundList[ "ssh" ] = { {1.4853514432907, "vo/outland_06a/radio/al_rad_sh.wav"} }
SoundList[ "sshh" ] = { {1.4853514432907, "vo/outland_06a/radio/al_rad_sh.wav"} }
SoundList[ "look" ] = { {0.81736969947815, "vo/outland_07/barn/al_barn_podslaunched01.wav"} }
SoundList[ "ah" ] = { {0.38367348909378, "vo/outland_07/barn/al_barn_lifesupport01.wav"} }
SoundList[ "wow" ] = { {0.84800457954407, "vo/outland_07/barn/al_barn_putusdown01.wav"} }
SoundList[ "life support" ] = { {0.86934250593185, "vo/outland_07/barn/al_barn_lifesupport02.wav"} }
SoundList[ "ah crap" ] = { {1.1120182275772, "vo/outland_08/chopper/al_chop_enginefire02.wav"} }
SoundList[ "shut up" ] = { {1.5573470592499, "vo/outland_08/chopper/reb_chop_shipdown03.wav"} }
SoundList[ "it's a trap" ] = { {1.0026757717133, "vo/outland_10/olde-inne/al_inn_trap.wav"} }

SoundList[ "listen" ] = { {0.73403632640839, "vo/outland_10/olde-inne/al_ambush_listen.wav"} }
SoundList[ "alright" ] = { {0.48102051019669, "vo/outland_11/dogfight/al_str_thanksagain01.wav"} }
SoundList[ "good boy" ] = { {0.83201819658279, "vo/outland_11/dogfight/al_str_goodboy.wav"} }
SoundList[ "good" ] = { {0.84934252500534, "vo/outland_11/dogfight/al_str_good.wav"} }
SoundList[ "check it out" ] = { {0.61036288738251, "vo/outland_11a/magtraining/mirt_brief_yanktrunk01.wav"} }
SoundList[ "shit" ] = { {1.4506802558899, "vo/outland_12/reb1_buildingexplo06.wav"} }
SoundList[ "don't!" ] = { {0.84986400604248, "vo/outland_12a/launch/al_launch_dadimnot02.wav"} }
SoundList[ "unforeseen consequences" ] = { {3.2266666889191, "vo/outland_11a/silo/eli_silo_talk01.wav"} }
SoundList[ "prepare for unforeseen consequences" ] = { {2.8666667938232, "vo/outland_11a/silo/al_silo_prepare02.wav"} }

SoundList[ "headcrabs" ] = {
{0.91501140594482, "vo/npc/female01/headcrabs01.wav"},
{0.83519279956818, "vo/npc/female01/headcrabs02.wav"},
{1.2759183645248, "vo/npc/male01/headcrabs01.wav"},
{0.82399100065231, "vo/npc/male01/headcrabs02.wav"} }

SoundList[ "steamfriends" ] = { {0.47891160845757, "friends/message.wav"} }

SoundList[ "ok let's go" ] = { {1.3682539463043, "radio/go.wav"} }
SoundList[ "gogogo" ] = { {1.3292063474655, "radio/com_go.wav"} }
SoundList[ "go go go" ] = { {1.3292063474655, "radio/com_go.wav"} }
SoundList[ "goodbye" ] = { {0.8475056886673, "npc/turret_floor/turret_retire_1.wav"}, {0.8475056886673, "vo/aperture_ai/15_part1_into_the_fire-5.wav"}  }
SoundList[ "good bye" ] = SoundList[ "goodbye" ]
SoundList[ "bye" ] = SoundList[ "goodbye" ]
SoundList[ "excuse me" ] = { {1.161337852478, "npc/turret_floor/turret_collide_2.wav"} }
SoundList[ "my fault" ] = { {1.2200000286102, "npc/turret_floor/turret_collide_4.wav"} }
SoundList[ "can i help you" ] = { {1.3307030200958, "npc/turret_floor/turret_search_3.wav"} }
SoundList[ "don't shoot" ] = { {1.3653515577316, "npc/turret_floor/turret_shotat_2.wav"} }
SoundList[ "dont shoot" ] = SoundList[ "don't shoot" ]
SoundList[ "stop shooting" ] = { {1.4080046415329, "npc/turret_floor/turret_shotat_3.wav"} }
SoundList[ "good night" ] = { {1.578684926033, "npc/turret_floor/turret_retire_5.wav"} }
SoundList[ "are you still there" ] = { {1.6268254518509, "npc/turret_floor/turret_search_1.wav"} }
SoundList[ "why" ] = { {1.640589594841, "npc/turret_floor/turret_disabled_7.wav"} }
SoundList[ "there you are" ] = {
{1.7066667079926, "npc/turret_floor/turret_active_7.wav"},
{1.9866666793823, "npc/turret_floor/turret_deploy_5.wav"} }

SoundList[ "i don't hate you" ] = { {1.8053514957428, "npc/turret_floor/turret_disabled_6.wav"} }
SoundList[ "who are you" ] = { {1.9626758098602, "npc/turret_floor/turret_pickup_6.wav"} }
SoundList[ "put me down" ] = { {2.0480046272278, "npc/turret_floor/turret_pickup_3.wav"} }
SoundList[ "would you come over here" ] = { {2.5866665840149, "npc/turret_floor/turret_autosearch_6.wav"} }

SoundList[ "lamarr" ] = { 
{2.2307484149933, "vo/k_lab/kl_lamarr.wav"}, 
{1.0708390474319, "/vo/k_lab2/kl_comeoutlamarr.wav"}, 
{1.0055103302002, "vo/k_lab/kl_islamarr.wav"}, 
{3.4874603748322, "vo/k_lab2/kl_lamarrwary02.wav"}, 
{1.8226984739304, "vo/k_lab2/kl_lamarr.wav"},
{3.8101816177368, "vo/k_lab2/kl_cantleavelamarr_b.wav"}  }

SoundList[ "just a minute" ] = { {0.81589567661285, "vo/k_lab2/kl_cantleavelamarr.wav"} }
SoundList[ "just a min" ] = SoundList[ "just a minute" ]
SoundList[ "oh yeah" ] = { {1.4270294904709, "vo/npc/barney/ba_ohyeah.wav"} }
SoundList[ "aah" ] = { {0.73158740997314, "vo/k_lab/kl_ahhhh.wav"} }
SoundList[ "cheers" ] = { {0.77206349372864, "vo/spy_autocappedintelligence03.wav"} }
SoundList[ "gentlemen" ] = { {0.72852611541748, "vo/spy_battlecry01.wav"} }
SoundList[ "move" ] = { {0.57759642601013, "vo/spy_go01.wav"} }
SoundList[ "i never really was on your side" ] = { {1.9446712732315, "vo/spy_specialcompleted07.wav"} }
SoundList[ "need a dispenser here" ] = { {1.1639002561569, "vo/scout_needdispenser01.wav"} }
SoundList[ "yippy" ] = { {3.3320634365082, "vo/engineer_cheers07.wav"} }
--SoundList[ "wtf" ] = { {0.8, "wtf.mp3"} }
SoundList[ "what the fuck" ] = SoundList[ "wtf" ]
--SoundList[ "boom" ] = { {7.4270000457764, "boom.mp3"} }
SoundList[ "booom" ] = SoundList[ "boom" ]
SoundList[ "boooom" ] = SoundList[ "boom" ]
SoundList[ "booooom" ] = SoundList[ "boom" ]
SoundList[ "boooooom" ] = SoundList[ "boom" ]
SoundList[ "booooooom" ] = SoundList[ "boom" ]
SoundList[ "boooooooom" ] = SoundList[ "boom" ]
SoundList[ "booooooooom" ] = SoundList[ "boom" ]
SoundList[ "boooooooooom" ] = SoundList[ "boom" ]

SoundList[ "thank you" ] = { {0.50514739751816, "vo/outland_12a/launch/mag_launch_thankyou03.wav"} }
SoundList[ "indeed" ] = { {0.69655328989029, "vo/outland_12a/launch/mag_launch_indeed.wav"} }
SoundList[ "eugh" ] = { {0.91877561807632, "vo/outland_12a/launch/mag_launch_check12a.wav"} }
SoundList[ "1" ] = { {1.2560091018677, "vo/outland_12a/launch/kl_launch_1.wav"} }
SoundList[ "2" ] = { {0.81333339214325, "vo/outland_12a/launch/kl_launch_2.wav"} }
SoundList[ "3" ] = { {1.109342455864, "vo/outland_12a/launch/kl_launch_3.wav"} }
SoundList[ "4" ] = { {0.93868488073349, "vo/outland_12a/launch/kl_launch_4.wav"} }
SoundList[ "5" ] = { {0.98666667938232, "vo/outland_12a/launch/kl_launch_5.wav"} }
SoundList[ "6" ] = { {1.0666667222977, "vo/outland_12a/launch/kl_launch_6.wav"} }
SoundList[ "7" ] = { {0.91734701395035, "vo/outland_12a/launch/kl_launch_7.wav"} }
SoundList[ "8" ] = { {0.73600912094116, "vo/outland_12a/launch/kl_launch_8.wav"} }
SoundList[ "9" ] = { {1.2053514719009, "vo/outland_12a/launch/kl_launch_9.wav"} }
SoundList[ "at last" ] = { {1.3653515577316, "vo/outland_12a/launch/kl_launch_atlast.wav"} }
SoundList[ "lift off" ] = { {2.6470749378204, "vo/outland_12a/launch/mag_launch_launchsequence08c.wav"} }
SoundList[ "magnusson, did you hear that" ] = { {1.3480045795441, "vo/outland_01/intro/kl_transmit_callmag01.wav"} }
SoundList[ "so um" ] = { {1.1377551555634, "vo/outland_12a/launch/mag_launch_thankyou02.wav"} }
SoundList[ "my rocket works" ] = { {3.5990250110626, "vo/outland_12a/launch/mag_launch_launchsequence09a.wav"} }
SoundList[ "i'm a genius" ] = { {5.1043086051941, "vo/outland_12a/launch/mag_launch_launchsequence09b.wav"} }
SoundList[ "excited" ] = { {8.8584127426147, "vo/outland_12a/launch/mag_launch_launchsequence08d.wav"} }
SoundList[ "steady" ] = { {1.4746031761169, "vo/outland_12a/launch/mag_launch_launchsequence06.wav"} }
SoundList[ "there you go" ] = { {1.1536282300949, "vo/outland_11a/magtraining/mag_tutor_nottoohard01.wav"} }

SoundList[ "burp" ] = {
{0.29750570654869, "vo/burp02.wav"},
{0.37374150753021, "vo/burp03.wav"},
{0.92879819869995, "vo/burp04.wav"},
{2.1618595123291, "vo/burp05.wav"},
{0.29750570654869, "vo/burp02.wav"},
{0.56018149852753, "vo/burp06.wav"},
{0.982312977314, "vo/burp07.wav"} }
SoundList[ "now i've seen everything" ] = { {1.6079819202423, "vo/engineer_autodejectedtie02.wav"} }

SoundList[ "spy sappin my sentry" ] = { {1.8227665424347, "vo/engineer_autoattackedbyspy03.wav"} }
SoundList[ "spy sapping my sentry" ] = SoundList[ "spy sappin my sentry" ]
SoundList[ "spy sappin mah sentry" ] = SoundList[ "spy sappin my sentry" ]
SoundList[ "spy sapping mah sentry" ] = SoundList[ "spy sappin my sentry" ]
SoundList[ "spy sappin ma sentry" ] = SoundList[ "spy sappin my sentry" ]
SoundList[ "spy sapping ma sentry" ] = SoundList[ "spy sappin my sentry" ]
SoundList[ "spy sappin' my sentry" ] = SoundList[ "spy sappin my sentry" ]
SoundList[ "spy sappin' mah sentry" ] = SoundList[ "spy sappin my sentry" ]
SoundList[ "spy sappin' ma sentry" ] = SoundList[ "spy sappin my sentry" ]

SoundList[ "shall we" ] = { {0.63854879140854, "vo/spy_battlecry02.wav"} }
SoundList[ "spy gentlemen" ] = { {1.0042630434036, "vo/spy_cloakedspy03.wav"} }

SoundList[ "moo" ] = { 
{2.507755279541, "ambient/cow1.wav"},
{3.1579139232635, "ambient/cow2.wav"},
{2.6993198394775, "ambient/cow3.wav"}, }
 
--SoundList[ "holy shit" ] = { {2.9013378620148, "vo/outland_12/reb1_sawmillexplo03.wav"} }
SoundList[ "ahh" ] = SoundList[ "aaa" ]

SoundList[ "god damn it" ] = { {4.4373469352722, "vo/outland_12/reb1_lastwaveannounced03.wav"} }
SoundList[ "god damnit" ] = SoundList[ "god damn it" ]
SoundList[ "god dammit" ] = SoundList[ "god damn it" ]
SoundList[ "haha yeah" ] = { {2.6026759147644, "vo/outland_12/reb1_striderdown05.wav"} }

SoundList[ "october fest" ] = {
{1.8750114440918, "vo/medic_cheers06.wav"},
{3.4634921550751, "vo/taunts/medic_taunts16.wav"} }
SoundList[ "oktober fest" ] = SoundList[ "october fest" ]
SoundList[ "octoberfest" ] = SoundList[ "october fest" ]
SoundList[ "oktoberfest" ] = SoundList[ "october fest" ]
SoundList[ "warning" ] = { {1.6599774360657, "vo/announcer_warning.wav"} }

SoundList[ "no" ] = { 
{0.39328798651695, "vo/medic_no02.wav"}, 
{0.51954650878906, "vo/sniper_no01.wav"}, 
{0.42376419901848, "vo/spy_no02.wav"},
{0.52680277824402, "vo/scout_no02.wav"} }

SoundList[ "nein" ] = { {0.53115648031235, "vo/medic_no01.wav"} }
SoundList[ "what are you looking at" ] = { {0.84752839803696, "vo/taunts/scout_taunts10.wav"} }
SoundList[ "spit" ] = {
{1.0100680589676, "vo/taunts/sniper_taunts23.wav"},
{1.4686621427536, "vo/taunts/sniper_taunts01.wav"} }
SoundList[ "spits" ] = {
{1.0100680589676, "vo/taunts/sniper_taunts23.wav"},
{1.4686621427536, "/vo/taunts/sniper_taunts01.wav"} }
SoundList[ "magots" ] = { {1.0158730745316, "vo/taunts/soldier_taunts01.wav"} }
SoundList[ "maggots" ] = SoundList[ "magots" ]
SoundList[ "who wants some of this" ] = { {1.0390930175781, "vo/taunts/scout_taunts07.wav"} }
SoundList[ "you're all losers" ] = { {1.0681179761887, "vo/taunts/scout_taunts13.wav"} }
SoundList[ "i'm running circles around ya" ] = { {1.5557370185852, "vo/taunts/scout_taunts01.wav"} }
SoundList[ "i'm running in circles around you" ] = SoundList[ "i'm running circles around ya" ]
SoundList[ "i'm runnin' in circles around ya" ] = SoundList[ "i'm running circles around ya" ]
SoundList[ "i'm runnin' in circles around you" ] = SoundList[ "i'm running circles around ya" ]

SoundList[ "start praying boy" ] = { {1.6021769046783, "vo/taunts/engineer_taunts08.wav"} }
SoundList[ "whistle" ] = { {1.7298866510391, "vo/taunts/spy_taunts05.wav"} }
SoundList[ "i'm coming for you" ] = { {1.8750114440918, "vo/taunts/spy_taunts10.wav"} }
SoundList[ "not so tough now are you" ] = { {1.9214513301849, "vo/taunts/scout_taunts04.wav"} }
SoundList[ "real scary" ] = { {2.0259411334991, "vo/taunts/scout_taunts02.wav"} }
SoundList[ "say that to my face" ] = { {2.4264853000641, "vo/taunts/scout_taunts03.wav"} }
SoundList[ "who touched my gun" ] = { {2.5251700878143, "vo/taunts/heavy_taunts06.wav"} }
SoundList[ "i'm gonna headbutt ya" ] = { {3.0534241199493, "vo/taunts/scout_taunts05.wav"} }
SoundList[ "i'm gonna headbutt you" ] = SoundList[ "i'm gonna headbutt ya" ]
SoundList[ "i'm gonna headbut ya" ] = SoundList[ "i'm gonna headbutt ya" ]
SoundList[ "i'm gonna headbut you" ] = SoundList[ "i'm gonna headbutt ya" ]

SoundList[ "i appear to have burst into flames" ] = { {1.8401814699173, "vo/spy_autoonfire01.wav"} }
SoundList[ "i do believe i'm on fire" ] = { {1.3612699508667, "vo/spy_autoonfire03.wav"} }

SoundList[ "animorten" ] = {
{1.8227665424347, "vo/engineer_autoattackedbyspy03.wav"},
{0.72489798069, "vo/npc/female01/yeah02.wav"},
{0.87521547079086, "vo/npc/male01/yeah02.wav"} }

SoundList[ "i'm not deaf" ] = { {2.9839682579041, "vo/outland_01/intro/mag_transmit_whatnow.wav"} }
SoundList[ "there is no time to waste" ] = { {1.5469161272049, "vo/outland_01/intro/mag_transmit_nowaste01.wav"} }

SoundList[ "haax" ] = { {1.2454421520233, "vo/npc/male01/hacks01.wav"} }
SoundList[ "haaax" ] = SoundList[ "haax" ]
SoundList[ "haaaax" ] = SoundList[ "haax" ]
SoundList[ "haaaaax" ] = SoundList[ "haax" ]
SoundList[ "haaaaaax" ] = SoundList[ "haax" ]
SoundList[ "haaaaaaax" ] = SoundList[ "haax" ]
SoundList[ "haaaaaaaax" ] = SoundList[ "haax" ]
SoundList[ "haaaaaaaaax" ] = SoundList[ "haax" ]
SoundList[ "haaaaaaaaaax" ] = SoundList[ "haax" ]
SoundList[ "haaaaaaaaaaax" ] = SoundList[ "haax" ]
SoundList[ "haaaaaaaaaaaax" ] = SoundList[ "haax" ]
SoundList[ "haaaaaaaaaaaaax" ] = SoundList[ "haax" ]
SoundList[ "haaaaaaaaaaaaaax" ] = SoundList[ "haax" ]
SoundList[ "haaaaaaaaaaaaaaax" ] = SoundList[ "haax" ]
SoundList[ "haaaaaaaaaaaaaaaax" ] = SoundList[ "haax" ]

SoundList[ "stop that" ] = {
{1.2171429395676, "vo/trainyard/female01/cit_hit02.wav"},
{0.92503410577774, "vo/trainyard/male01/cit_hit02.wav"} }

SoundList[ "cut it out" ] = {
{1.2171655893326, "vo/trainyard/female01/cit_hit01.wav"},
{0.78965991735458, "vo/trainyard/male01/cit_hit01.wav"} }

SoundList[ "listen here magnusson" ] = { {2.5493423938751, "vo/outland_11a/silo/kl_silo_nowmag01.wav"} }
SoundList[ "magnusson is smart" ] = { {5.1202721595764, "vo/outland_11a/silo/vort_silo_maghonor02.wav"} }
SoundList[ "i love you dad" ] = { {1.8347619771957, "vo/outland_12a/launch/al_launch_iloveyoudad.wav"} }
SoundList[ "dad" ] = {
{0.70365077257156, "vo/outland_12a/launch/al_launch_daddad01.wav"},
{0.80557829141617, "vo/outland_12a/launch/al_launch_daddad02.wav"},
{0.56258511543274, "vo/outland_12a/launch/al_launch_dadimnot01.wav"},
{0.56258511543274, "vo/outland_12a/launch/al_launch_dadimnot01.wav"},
{1.8347846269608, "vo/outland_12a/launch/al_launch_dadcry.wav"},
{1.3440817594528, "vo/outland_12a/launch/al_launch_nodad01.wav"} }

SoundList[ "omg no" ] = { {1.8693197965622, "vo/outland_12a/launch/al_launch_impaling01_alt2.wav"} }
SoundList[ "oh my god no" ] = SoundList[ "omg no" ]

SoundList[ "*cries*" ] = {
{1.6687982082367, "vo/outland_12a/launch/al_launch_pieta01d.wav"},
{4.1969842910767, "vo/outland_12a/launch/al_launch_pieta01j.wav"},
{2.576938867569, "vo/outland_12a/launch/al_launch_pieta01q.wav"},
{1.6946258544922, "vo/outland_12a/launch/al_launch_pieta01r.wav"} }
SoundList[ "cries" ] = SoundList[ "*cries*" ]
 
SoundList[ "hmm" ] = { {0.49911570549011, "vo/episode_1/intro/al_fewbolts01.wav"} }

SoundList[ "sex" ] = {
{4.0841045379639, "vo/episode_1/npc/female01/cit_remarks08.wav"},
{3.7851927280426, "vo/episode_1/npc/male01/cit_remarks08.wav"} }

SoundList[ "mate" ] = SoundList[ "sex" ]

--SoundList[ "anime" ] = { {1.3637499809265, "anime.mp3"} }

SoundList[ "cough" ] = {
{1.0567346811295, "ambient/voices/cough1.wav"},
{0.54870748519897, "ambient/voices/cough2.wav"},
{0.61265307664871, "ambient/voices/cough3.wav"},
{0.92707490921021, "ambient/voices/cough4.wav"} }
SoundList[ "*cough*" ] = SoundList[ "cough" ]

SoundList[ "i love you sweetheart" ] = { {1.4729706048965, "vo/outland_12a/launch/eli_launch_iloveyousweet.wav"} }
SoundList[ "only a button" ] = { {5.3406801223755, "vo/outland_12a/launch/mag_launch_onlyabutton.wav"} }

SoundList[ "grenade" ] = {
{1.1414966583252, "vo/npc/barney/ba_grenade01.wav"},
{1.1918368339539, "vo/npc/barney/ba_grenade02.wav"} }

SoundList[ "fire fire fire" ] = { {1.3554649353027, "vo/spy_autoonfire02.wav"} }
SoundList[ "sextender" ] = { {0.81850349903107, "vo/npc/female01/pain06.wav"} }
SoundList[ "head humpers" ] = { {1.2460770606995, "vo/npc/barney/ba_headhumpers.wav"} }
SoundList[ "headhumpers" ] = SoundList[ "head humpers" ]
--SoundList[ "caps" ] = { {1.947, "capsadmin.mp3"} }
--SoundList[ "zpankr" ] = { {2.037, "zpankr.mp3"} }
SoundList[ "capsadmin" ] = SoundList[ "caps" ]
SoundList[ "error" ] = { {0.63777780532837, "buttons/button8.wav"} }
SoundList[ "so what now" ] = { {1.7066667079926, "vo/outland_11a/silo/reb1_idles01.wav"} }
SoundList[ "tea time" ] = { {3.5759863853455, "vo/outland_11a/silo/mag_silo_excuseme01.wav"} }
SoundList[ "hunters with our bare hands" ] = { {10.06934261322, "vo/outland_11a/silo/reb_silo_reb_art10.wav"} }
SoundList[ "quickly" ] = { {0.56160998344421, "vo/outland_11a/silo/mag_silo_followquick04.wav"} }
SoundList[ "thank you baby" ] = { {0.75464862585068, "vo/outland_11a/silo/eli_silo_thankyou02.wav"} }
SoundList[ "sing1" ] = { {2.9383220672607, "vo/eli_lab/al_hums.wav"} }
SoundList[ "sing2" ] = { {4.7082767486572, "vo/eli_lab/al_hums_b.wav"} }
SoundList[ "ar3" ] = { {5.5466666221619, "vo/outland_11a/silo/reb_silo_reb_art2.wav"} }
SoundList[ "there's no such thing as an ar3" ] = { {3.191995382309, "vo/outland_11a/silo/reb_silo_reb_art3.wav"} }
SoundList[ "there is no such thing as an ar3" ] = { {3.191995382309, "vo/outland_11a/silo/reb_silo_reb_art3.wav"} }
SoundList[ "there you go" ] = { {1.1536282300949, "vo/outland_11a/magtraining/mag_tutor_nottoohard01.wav"} }
SoundList[ "had enough" ] = { {1.0288436412811, "vo/outland_11a/magtraining/mag_tutor_hadenough.wav"} }
SoundList[ "check it out" ] = { {0.61036288738251, "vo/outland_11a/magtraining/mirt_brief_yanktrunk01.wav"} }
SoundList[ "anyone" ] = { {0.8982766866684, "vo/outland_11a/silo/mag_silo_falsealarms03.wav"} }
SoundList[ "brb" ] = { {1.0078912258148, "vo/outland_11a/silo/al_silo_keepeye01.wav"} }
SoundList[ "be right back" ] = { {1.7078912258148, "vo/outland_11a/silo/al_silo_keepeye01.wav"} }
--SoundList[ "dinner" ] = { {0.53942848443985, "dinner.mp3"} }
SoundList[ "fuck you" ] = { {5.0, "vo/Streetwar/rubble/ba_tellbreen.wav"} }
SoundList[ "about that beer I owed ya" ] = { {2.0, "vo/trainyard/ba_thatbeer02.wav"} }


SoundList[ "pick up that can" ] = {{1, "npc/metropolice/vo/pickupthecan1.wav"}}	

SoundList[ "pick up the can" ] = {{1.6, "npc/metropolice/vo/pickupthecan2.wav"}}

SoundList[ "I said pick up the can" ] = {{1, "npc/metropolice/vo/pickupthecan3.wav"}}

SoundList[ "I wonder where he's going" ] = { {2.0, "vo/Citadel/al_wonderwhere.wav"} }

SoundList[ "I wonder what's for" ] = { {1.37, "iwonderwhatsfordinner.mp3"} }
--SoundList[ "I wonder whats for" ] = SoundList[ "I wonder what's for" ]
--SoundList[ "Oh boy" ] = { {0.862, "ohboy.mp3"} }


SoundList[ "tf1" ] = { {1, "vo/announcer_ends_1sec.wav"} }
SoundList[ "tf2" ] = { {1, "vo/announcer_ends_2sec.wav"} }
SoundList[ "tf3" ] = { {1, "vo/announcer_ends_3sec.wav"} }
SoundList[ "tf4" ] = { {1, "vo/announcer_ends_4sec.wav"} }
SoundList[ "tf5" ] = { {1, "vo/announcer_ends_5sec.wav"} }
SoundList[ "tf6" ] = { {1, "vo/announcer_ends_6sec.wav"} }
SoundList[ "tf7" ] = { {1, "vo/announcer_ends_7sec.wav"} }
SoundList[ "tf8" ] = { {1, "vo/announcer_ends_8sec.wav"} }
SoundList[ "tf9" ] = { {1, "vo/announcer_ends_9sec.wav"} }
SoundList[ "nix da" ] = { {0.5, "vo/medic_no03.wav"} }

SoundList[ "thanks" ] = {
{1.1414966583252, "vo/soldier_thanks01.wav"},
{1.1918368339539, "vo/soldier_thanks02.wav"}, 
{1.1414966583252, "vo/scout_thanks01.wav"},
{1.1918368339539, "vo/medic_thanks01.wav"},
{1.1414966583252, "vo/heavy_thanks01.wav"},
{1.1918368339539, "vo/heavy_thanks03.wav"},
{1.1414966583252, "vo/sniper_thanks01.wav"},
{1.1918368339539, "vo/demoman_thanks01.wav"}
}
--SoundList[ "boring" ] = {{3.353, "boring.mp3"}}
--SoundList[ "bored" ] = SoundList[ "boring" ]

--SoundList[ "bitch" ] = { {0.633, "bitch.mp3"} }
--SoundList[ "fuck fuck fuck" ] = { {9.5, "fucfuckfuck.mp3"} }
--SoundList[ "bob sagget" ] = { {1.209, "bobsagget.mp3"} }
--SoundList[ "stfu" ] = { {1.209, "stfu.mp3"} }
--SoundList[ "shut the fuck up" ] = SoundList[ "stfu" ]
--SoundList[ "I don't give a dead moose's last shit" ] = { {2.480, "deadmoose.mp3"} }
--SoundList[ "I don't care" ] = SoundList[ "I don't give a dead moose's last shit" ]
--SoundList[ "I dont care" ] = SoundList[ "I don't give a dead moose's last shit" ]
--SoundList[ "I don't give a shit" ] = SoundList[ "I don't give a dead moose's last shit" ]
--SoundList[ "I dont give a shit" ] = SoundList[ "I don't give a dead moose's last shit" ]

--SoundList[ "ass" ] = { {0.640, "ass.mp3"} }
--SoundList[ "piss" ] = { {0.619, "piss.mp3"} }

--SoundList[ "dammit" ] = { {0.550, "dammit.mp3"} }
--SoundList[ "damnit" ] = SoundList[ "dammit" ] 
--SoundList[ "damn it" ] = SoundList[ "dammit" ] 

--SoundList[ "holy shit" ] = { {1.203, "holyshit.mp3"} }

SoundList[ "do do do" ] = { {6.5, "vo/heavy_cheers08.wav" }}
--SoundList[ "f" ] = { {0.1, "annoying.wav" }}
SoundList[ "da da da" ] = { {4.5, "vo/heavy_cheers07.wav" }}

SoundList[ "girlscream" ] = { {0.5, "vo/episode_1/c17/al_elev_zombiesurprise.wav" }}

SoundList[ "again" ] = { {0.5, "vo/episode_1/c17/al_strider_again.wav" }}


SoundList[ "well" ] = { 
{0.5, "vo/episode_1/c17/al_tunnel_noteasy02.wav" },
{0.5, "vo/episode_1/citadel/al_control_heresyourelevator01.wav" },
{0.5, "vo/episode_1/citadel/al_gotwhatineeded.wav" }
}



SoundList[ "right" ] = { {0.5, "vo/episode_1/citadel/al_right.wav" }}

SoundList[ "ready?" ] = { {0.5, "vo/episode_1/c17/al_pb1_ready.wav" }}
SoundList[ "sounds good" ] = { {0.5, "vo/episode_1/c17/al_evac_soundsgood01.wav" }}
SoundList[ "all aboard" ] = { {0.5, "vo/episode_1/c17/al_finale_allaboard.wav" }}
SoundList[ "get in" ] = { {0.5, "vo/episode_1/c17/al_elev_getingetin.wav" }}
SoundList[ "oh great" ] = { {0.5, "vo/episode_1/c17/al_pb1_ohgreat.wav" }}
SoundList[ "phew" ] = { {0.5, "vo/episode_1/c17/al_elev_phew.wav" }}
SoundList[ "weird" ] = { {0.5, "vo/episode_1/citadel/al_core_controlcrazy01.wav" }}
SoundList[ "got it" ] = { {0.5, "vo/episode_1/citadel/al_doorhacks01b.wav" }}
SoundList[ "traitor" ] = { {0.5, "vo/episode_1/citadel/al_traitor.wav" },{0.5, "vo/episode_1/citadel/al_traitor02.wav" }}
SoundList[ "huh" ] = { {0.5, "vo/episode_1/intro/al_hopelessnoaccess02.wav" }}
SoundList[ "any ideas" ] = { {0.5, "vo/episode_1/intro/al_chasm_dogideas03.wav" }}
SoundList[ "I love you" ] = { {0.5, "vo/episode_1/intro/al_dadiloveyou02.wav" }}



SoundList[ "alyxorgasm" ] = {
{1, "vo/episode_1/citadel/al_advisor_pain02.wav"}, 
{1, "vo/episode_1/citadel/al_advisor_pain03.wav"},
{1, "vo/episode_1/citadel/al_advisor_pain04.wav"},
{1, "vo/outland_01/intro/al_rbed_hunter_pain06.wav"},
{1, "vo/episode_1/npc/alyx/al_comingtohelp03.wav"},
{1, "vo/outland_12a/launch/al_launch_nodad01.wav"},
{1, "vo/outland_12a/launch/al_launch_iloveyoudad.wav"},
{1, "vo/episode_1/citadel/al_stalk_godogod01.wav"},
{1, "vo/episode_1/citadel/al_stalk_godogod02.wav"},
{1, "vo/episode_1/citadel/al_stalk_breath01.wav"},
{1, "vo/episode_1/citadel/al_stalk_breath02.wav"},
{1, "vo/episode_1/citadel/al_stalk_breath03.wav"},
{1, "vo/episode_1/citadel/al_stalk_breath04.wav"},

{1, "vo/outland_12a/launch/al_launch_struggle03.wav"},
{1, "vo/outland_12a/launch/al_launch_struggle05.wav"},
{1, "vo/outland_12a/launch/al_launch_struggle06.wav"},
{1, "vo/outland_12a/launch/al_launch_struggle09.wav"},
{1, "vo/outland_12a/launch/al_launch_struggle12.wav"},
{1, "vo/episode_1/c17/al_elev_zombiesurprise.wav"},

{1, "vo/outland_01/intro/al_rbed_hunter_pain07.wav"}
}

SoundList[ "eliorgasm" ] = {
{1, "vo/outland_12a/launch/eli_launch_pain01.wav"}, 
{1, "vo/outland_12a/launch/eli_launch_pain04.wav"},
{1, "vo/outland_12a/launch/eli_launch_pain05.wav"},
{1, "vo/outland_12a/launch/eli_launch_pain06.wav"},
{1, "vo/outland_12a/launch/eli_launch_pain09.wav"},
{1, "vo/outland_12a/launch/eli_launch_pain13.wav"},
{1, "vo/outland_11a/silo/eli_silo_goodback01.wav"},
{1, "vo/outland_12a/launch/eli_launch_iloveyousweet.wav"}
}

SoundList[ "alyxorgasm2" ] = {
{1, "vo/npc/alyx/al_car_crazy02.wav"}, 
{1, "vo/npc/alyx/al_car_crazy04.wav"},
{1, "vo/npc/alyx/al_car_crazy06.wav"},
{1, "vo/npc/alyx/al_car_crazy07.wav"},
{1, "vo/npc/alyx/al_car_crazy08.wav"}
}

SoundList[ "what is that" ] = { {1, "vo/aperture_ai/escape_02_sphere_curiosity-02.wav" }}
SoundList[ "can you hear me" ] = { {1, "vo/aperture_ai/post_escape_bridge_02.wav" }}

SoundList[ "welcome" ] = { {4, "vo/Breencast/br_welcome01.wav" }}
SoundList[ "GutWrenching" ] = { {1.6, "npc/fast_zombie/fz_scream1.wav" }}
SoundList[ "yeargh" ] = SoundList[ "GutWrenching" ]
--SoundList[ "4chan" ] = { {3.200, "4chan.mp3" }}
--SoundList[ "fourchan" ] = SoundList[ "4chan" ]
--SoundList[ "fourchaan" ] = SoundList[ "4chan" ]
--SoundList[ "fourchaaan" ] = SoundList[ "4chan" ]
--SoundList[ "fourchaaaan" ] = SoundList[ "4chan" ]
--SoundList[ "fourchaaaaan" ] = SoundList[ "4chan" ]
--SoundList[ "fourchaaaaaan" ] = SoundList[ "4chan" ]
--SoundList[ "fourchaaaaaaan" ] = SoundList[ "4chan" ]
--SoundList[ "fourchaaaaaaaaan" ] = SoundList[ "4chan" ]
--SoundList[ "fourchaaaaaaaaaan" ] = SoundList[ "4chan" ]

SoundList[ "moanf" ] = {
{1, "vo/npc/female01/moan01.wav"}, 
{1, "vo/npc/female01/moan02.wav"}, 
{1, "vo/npc/female01/moan03.wav"}, 
{1, "vo/npc/female01/moan04.wav"}, 
{1, "vo/npc/female01/moan05.wav"}
}
SoundList[ "moanm" ] = {
{1, "vo/npc/male01/moan01.wav"}, 
{1, "vo/npc/male01/moan02.wav"}, 
{1, "vo/npc/male01/moan03.wav"}, 
{1, "vo/npc/male01/moan04.wav"}, 
{1, "vo/npc/male01/moan05.wav"}
}

--SoundList[ "oh shit" ] = { {1.4, "ohshit.mp3" }}
--SoundList[ "buttfuck" ] = { {1, "buttfuck.mp3" }}
--SoundList[ "chewbaca" ] = { {3.7, "Chewbaca.mp3" }}
SoundList[ "it is sad day" ] = { {2.7, "vo/heavy_jeers05.wav" }}
SoundList[ "moist and delicious" ] = { {3, "vo/heavy_sandwichtaunt02.wav" }}
SoundList[ "sandwich make me strong" ] = { {3, "vo/heavy_sandwichtaunt03.wav" }}
SoundList[ "om nom nom nom" ] = { {2, "vo/SandwichEat09.wav" }}
--SoundList[ "balls" ] = { {0.35, "balls1.mp3" }}
--SoundList[ "balls of steel" ] = { {2, "ballsofsteel1.mp3" }}
--SoundList[ "blow it out your ass" ] = { {1.5, "blowitoutyourass1.mp3" }}


local soundkeys = { }
for k,v in pairs(SoundList) do
	table.insert(soundkeys, k)
end
table.sort(soundkeys, function(a,b) return string.len(a) > string.len(b) end) -- Sort the list into size descending


local function GetList(text)
	local TextList = { }
	for k,v in pairs(soundkeys) do
		if v ~= "" then
			local last_find = 0
			local incpos = 0
			while last_find ~= nil do
				local Find, FindEnd = string.find(string.lower(text), string.lower(v))
				if Find then
					local beforec = string.sub(text, Find-1, Find-1)
					local afterc = string.sub(text, FindEnd+1, FindEnd+1)--EndingOnlyPunctuation
					if k == "%." or (table.HasValue(Punctuation, beforec) and ((table.HasValue(Punctuation, afterc) or table.HasValue(EndingOnlyPunctuation, afterc)) or afterc == string.sub(text, FindEnd, FindEnd))) then
						table.insert(TextList, {Find, v})
						text = string.sub(text, 1, Find-1) .. string.rep(" ", string.len(v)) .. string.sub(text, FindEnd+1)
					else
						FindEnd = nil
					end
				end
				last_find = FindEnd
			end
		end
	end
	return TextList
end

local function DoSound( ply, snd, num )
	if ValidEntity(ply) then
		if MutedPlayers[ply:UniqueID( )] then return; end
		num = num or 0
		local pitch = math.random( 94, 102 )
		for i = 1, num+1 do
			ply:EmitSound(Sound(snd), 90, pitch)
		end
	end
end

local function PlayerSay( ply, text )
	if MutedPlayers[ply:UniqueID( )] then return; end
	local TextList = GetList(text)
	
	if #TextList > 1 then
		table.sort(TextList, function(a, b) return a[1] < b[1] end)
	end
	
	local _, num = string.gsub(text, "[!]", "")
	local Time = 0
	for k,v in pairs(TextList) do
		local sound = SoundList[v[2]][math.random(#SoundList[v[2]])]
		if not sound then return; end
		if sound[2] and sound[2] ~= "" then
			local i
			timer.Simple(Time, DoSound, ply, sound[2], num)
		end
		Time = Time + sound[1]
	end
end
hook.Add("PlayerSay", "ChatSounds2", PlayerSay)

local function PlaySound( ply, c, arg )
	PlayerSay( ply, table.concat(arg, " "))
end
concommand.Add("saysound", PlaySound)


local function MutePlayer( ply, c, arg )
	if not ply:IsAdmin( ) then return; end
	if not arg[1] or not arg[2] then
		ply:PrintMessage(HUD_PRINTCONSOLE, "Usage: chatsounds_mute <player name> <1/0>\n\t1 for muted, 0 for not muted.")
	end
	
	local mutee
	for k,v in pairs(player.GetAll( )) do
		if string.find(string.lower(v:GetName( )), string.lower(arg[1])) then mutee = v; break end
	end
	if not mutee then return end
	
	if arg[2] == "1" then
		ply:PrintMessage( HUD_PRINTTALK, "Muted player: " .. mutee:GetName( ) )
		MutedPlayers[mutee:UniqueID( )] = true; 
	else
		ply:PrintMessage( HUD_PRINTTALK, "Unmuted player: " .. mutee:GetName( ) )
		MutedPlayers[mutee:UniqueID( )] = nil; 
	end
end
concommand.Add("chatsounds_mute", MutePlayer)

local function FindSound( ply, c, arg )
	if not arg[1] then
		ply:PrintMessage(HUD_PRINTCONSOLE, "Usage: chatsounds_find <pattern>\n\tPattern can be either a normal string or a regex pattern, escape char is %. Normal strings may need escaping.")
		return;
	end
	for k, v in pairs(SoundList) do
		if string.find(v, arg[1]) then
			ply:PrintMessage(HUD_PRINTCONSOLE, v)
		end
	end
end
concommand.Add("chatsounds_find", FindSound)

function print_sounds(p,c,a)
    for k,v in pairs(SoundList) do
        p:PrintMessage(HUD_PRINTCONSOLE, k )
    end
end
concommand.Add("print_sounds", print_sounds)