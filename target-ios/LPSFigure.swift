struct LPSFigure: Equatable, Hashable {
    let name: String
    let imageName: String
}

let lpsFigures: [String: LPSFigure] = [
    // WAVE 1
    // #1 Panda
    "26123101ES": LPSFigure(name: "#1 Panda", imageName: "1_panda"),
    "23324301ES": LPSFigure(name: "#1 Panda", imageName: "1_panda"),
    "22824801ES": LPSFigure(name: "#1 Panda", imageName: "1_panda"),
    "21524501ES": LPSFigure(name: "#1 Panda", imageName: "1_panda"),
    "31023001ES": LPSFigure(name: "#1 Panda", imageName: "1_panda"),
    
    // #2 Poodle
    "26123102ES": LPSFigure(name: "#2 Poodle", imageName: "2_poodle"),
    "23324302ES": LPSFigure(name: "#2 Poodle", imageName: "2_poodle"),
    "22824802ES": LPSFigure(name: "#2 Poodle", imageName: "2_poodle"),
    "21524502ES": LPSFigure(name: "#2 Poodle", imageName: "2_poodle"),
    "31023002ES": LPSFigure(name: "#2 Poodle", imageName: "2_poodle"),
    
    // #3 Clydesdale
    "23324303ES": LPSFigure(name: "#3 Clydesdale", imageName: "3_clydesdale"),
    "26123103ES": LPSFigure(name: "#3 Clydesdale", imageName: "3_clydesdale"),
    "22824803ES": LPSFigure(name: "#3 Clydesdale", imageName: "3_clydesdale"),
    "21524503ES": LPSFigure(name: "#3 Clydesdale", imageName: "3_clydesdale"),
    "31023003ES": LPSFigure(name: "#3 Clydesdale", imageName: "3_clydesdale"),
    
    // #4 Himalayan kitten
    "26123104ES": LPSFigure(name: "#4 Himalayan kitten", imageName: "4_kitten"),
    "23324304ES": LPSFigure(name: "#4 Himalayan kitten", imageName: "4_kitten"),
    "22824804ES": LPSFigure(name: "#4 Himalayan kitten", imageName: "4_kitten"),
    "21524504ES": LPSFigure(name: "#4 Himalayan kitten", imageName: "4_kitten"),
    "31023004ES": LPSFigure(name: "#4 Himalayan kitten", imageName: "4_kitten"),
    
    // #5 The bull
    "26123105ES": LPSFigure(name: "#5 Bull", imageName: "5_bull"),
    "23324305ES": LPSFigure(name: "#5 Bull", imageName: "5_bull"),
    "22824805ES": LPSFigure(name: "#5 Bull", imageName: "5_bull"),
    "21524505ES": LPSFigure(name: "#5 Bull", imageName: "5_bull"),
    "31023005ES": LPSFigure(name: "#5 Bull", imageName: "5_bull"),
    
    // #6 Centipede
    "21524506ES": LPSFigure(name: "#6 Centipede", imageName: "6_centipede"),
    "26123106ES": LPSFigure(name: "#6 Centipede", imageName: "6_centipede"),
    "23324306ES": LPSFigure(name: "#6 Centipede", imageName: "6_centipede"),
    "22824806ES": LPSFigure(name: "#6 Centipede", imageName: "6_centipede"),
    "31023006ES": LPSFigure(name: "#6 Centipede", imageName: "6_centipede"),
    
    // #7 Otter
    "26123107ES": LPSFigure(name: "#7 Otter", imageName: "7_otter"),
    "22824807ES": LPSFigure(name: "#7 Otter", imageName: "7_otter"),
    "23324307ES": LPSFigure(name: "#7 Otter", imageName: "7_otter"),
    "21524507ES": LPSFigure(name: "#7 Otter", imageName: "7_otter"),
    "31023007ES": LPSFigure(name: "#7 Otter", imageName: "7_otter"),
    
    // #8 Bunny
    "26123108ES": LPSFigure(name: "#8 Bunny", imageName: "8_bunny"),
    "23324308ES": LPSFigure(name: "#8 Bunny", imageName: "8_bunny"),
    "22824808ES": LPSFigure(name: "#8 Bunny", imageName: "8_bunny"),
    "21524508ES": LPSFigure(name: "#8 Bunny", imageName: "8_bunny"),
    "31023008ES": LPSFigure(name: "#8 Bunny", imageName: "8_bunny"),
    
    // #9 Bird
    "26123109ES": LPSFigure(name: "#9 Bird", imageName: "9_bird"),
    "23324309ES": LPSFigure(name: "#9 Bird", imageName: "9_bird"),
    "22824809ES": LPSFigure(name: "#9 Bird", imageName: "9_bird"),
    "21524509ES": LPSFigure(name: "#9 Bird", imageName: "9_bird"),
    "31023009ES": LPSFigure(name: "#9 Bird", imageName: "9_bird"),
    
    // #10 Spaniel
    "26123110ES": LPSFigure(name: "#10 Spaniel", imageName: "10_spaniel"),
    "23324310ES": LPSFigure(name: "#10 Spaniel", imageName: "10_spaniel"),
    "22824810ES": LPSFigure(name: "#10 Spaniel", imageName: "10_spaniel"),
    "21524510ES": LPSFigure(name: "#10 Spaniel", imageName: "10_spaniel"),
    "31023010ES": LPSFigure(name: "#10 Spaniel", imageName: "10_spaniel"),
    
    // #11 Pelican
    "26123111ES": LPSFigure(name: "#11 Pelican", imageName: "11_pelican"),
    "23324311ES": LPSFigure(name: "#11 Pelican", imageName: "11_pelican"),
    "22824811ES": LPSFigure(name: "#11 Pelican", imageName: "11_pelican"),
    "21524511ES": LPSFigure(name: "#11 Pelican", imageName: "11_pelican"),
    "31023011ES": LPSFigure(name: "#11 Pelican", imageName: "11_pelican"),
    
    // #12 Corgi
    "26123112ES": LPSFigure(name: "#12 Corgi", imageName: "12_corgi"),
    "23324312ES": LPSFigure(name: "#12 Corgi", imageName: "12_corgi"),
    "22824812ES": LPSFigure(name: "#12 Corgi", imageName: "12_corgi"),
    "21524512ES": LPSFigure(name: "#12 Corgi", imageName: "12_corgi"),
    "31023012ES": LPSFigure(name: "#12 Corgi", imageName: "12_corgi"),
    
    // #13 Chameleon
    "26123113ES": LPSFigure(name: "#13 Chameleon", imageName: "13_chameleon"),
    "23324313ES": LPSFigure(name: "#13 Chameleon", imageName: "13_chameleon"),
    "22824813ES": LPSFigure(name: "#13 Chameleon", imageName: "13_chameleon"),
    "21524513ES": LPSFigure(name: "#13 Chameleon", imageName: "13_chameleon"),
    "31023013ES": LPSFigure(name: "#13 Chameleon", imageName: "13_chameleon"),
    
    // #14 Shark
    "26123114ES": LPSFigure(name: "#14 Shark", imageName: "14_shark"),
    "23324314ES": LPSFigure(name: "#14 Shark", imageName: "14_shark"),
    "22824814ES": LPSFigure(name: "#14 Shark", imageName: "14_shark"),
    "21524514ES": LPSFigure(name: "#14 Shark", imageName: "14_shark"),
    "31023014ES": LPSFigure(name: "#14 Shark", imageName: "14_shark"),
    
    // #15 Anteater
    "26123115ES": LPSFigure(name: "#15 Anteater", imageName: "15_anteater"),
    "23324315ES": LPSFigure(name: "#15 Anteater", imageName: "15_anteater"),
    "22824815ES": LPSFigure(name: "#15 Anteater", imageName: "15_anteater"),
    "21524515ES": LPSFigure(name: "#15 Anteater", imageName: "15_anteater"),
    "31023015ES": LPSFigure(name: "#15 Anteater", imageName: "15_anteater"),
    
    // #16 Panda
    "26123116ES": LPSFigure(name: "#16 Panda", imageName: "16_purple_panda"),
    "23324316ES": LPSFigure(name: "#16 Panda", imageName: "16_purple_panda"),
    "22824816ES": LPSFigure(name: "#16 Panda", imageName: "16_purple_panda"),
    "21524516ES": LPSFigure(name: "#16 Panda", imageName: "16_purple_panda"),
    "31023016ES": LPSFigure(name: "#16 Panda", imageName: "16_purple_panda"),
    
    // #17 Walrus
    "26123117ES": LPSFigure(name: "#17 Walrus", imageName: "17_walrus"),
    "23324317ES": LPSFigure(name: "#17 Walrus", imageName: "17_walrus"),
    "22824817ES": LPSFigure(name: "#17 Walrus", imageName: "17_walrus"),
    "21524517ES": LPSFigure(name: "#17 Walrus", imageName: "17_walrus"),
    "31023017ES": LPSFigure(name: "#17 Walrus", imageName: "17_walrus"),
    
    // #18 Lioness
    "26123118ES": LPSFigure(name: "#18 Lioness", imageName: "18_lioness"),
    "23324318ES": LPSFigure(name: "#18 Lioness", imageName: "18_lioness"),
    "22824818ES": LPSFigure(name: "#18 Lioness", imageName: "18_lioness"),
    "21524518ES": LPSFigure(name: "#18 Lioness", imageName: "18_lioness"),
    "31023018ES": LPSFigure(name: "#18 Lioness", imageName: "18_lioness"),

    // WAVE 2
    // #70 Panda
    "150240082ES": LPSFigure(name: "#70 Panda", imageName: "70_panda"),
    "190240086ES": LPSFigure(name: "#70 Panda", imageName: "70_panda"),
    "281241087ES": LPSFigure(name: "#70 Panda", imageName: "70_panda"),
    "131241081ES": LPSFigure(name: "#70 Panda", imageName: "70_panda"),
    "165245088ES": LPSFigure(name: "#70 Panda", imageName: "70_panda"),
    
    // #71 Llama
    "150240083ES": LPSFigure(name: "#71 Llama", imageName: "71_llama"),
    "281241088ES": LPSFigure(name: "#71 Llama", imageName: "71_llama"),
    "131241082ES": LPSFigure(name: "#71 Llama", imageName: "71_llama"),
    "165245089ES": LPSFigure(name: "#71 Llama", imageName: "71_llama"),
    "190240087ES": LPSFigure(name: "#71 Llama", imageName: "71_llama"),
    
    // #72 Goldfish
    "150240084ES": LPSFigure(name: "#72 Goldfish", imageName: "72_goldfish"),
    "281241089ES": LPSFigure(name: "#72 Goldfish", imageName: "72_goldfish"),
    "131241083ES": LPSFigure(name: "#72 Goldfish", imageName: "72_goldfish"),
    "165245090ES": LPSFigure(name: "#72 Goldfish", imageName: "72_goldfish"),
    "190240088ES": LPSFigure(name: "#72 Goldfish", imageName: "72_goldfish"),
    
    // #73 German shepherd
    "150240085ES": LPSFigure(name: "#73 German shepherd", imageName: "73_german_shepherd"),
    "28124109ES": LPSFigure(name: "#73 German shepherd", imageName: "73_german_shepherd"),
    "131241084ES": LPSFigure(name: "#73 German shepherd", imageName: "73_german_shepherd"),
    "165245091ES": LPSFigure(name: "#73 German shepherd", imageName: "73_german_shepherd"),
    "190240089ES": LPSFigure(name: "#73 German shepherd", imageName: "73_german_shepherd"),
    
    // #74 Cat
    "150240086ES": LPSFigure(name: "#74 Cat", imageName: "74_cat"),
    "190240090ES": LPSFigure(name: "#74 Cat", imageName: "74_cat"),
    "281241091ES": LPSFigure(name: "#74 Cat", imageName: "74_cat"),
    "131241085ES": LPSFigure(name: "#74 Cat", imageName: "74_cat"),
    "165245092ES": LPSFigure(name: "#74 Cat", imageName: "74_cat"),
    
    // #75 Woodpecker
    "150240087ES": LPSFigure(name: "#75 Woodpecker", imageName: "75_woodpecker"),
    "190240091ES": LPSFigure(name: "#75 Woodpecker", imageName: "75_woodpecker"),
    "281241092ES": LPSFigure(name: "#75 Woodpecker", imageName: "75_woodpecker"),
    "132241086ES": LPSFigure(name: "#75 Woodpecker", imageName: "75_woodpecker"),
    "165245093ES": LPSFigure(name: "#75 Woodpecker", imageName: "75_woodpecker"),
    
    // #76 Bunny
    "150240088ES": LPSFigure(name: "#76 Bunny", imageName: "76_bunny"),
    "281241093ES": LPSFigure(name: "#76 Bunny", imageName: "76_bunny"),
    "131241087ES": LPSFigure(name: "#76 Bunny", imageName: "76_bunny"),
    "165245094ES": LPSFigure(name: "#76 Bunny", imageName: "76_bunny"),
    "190240092ES": LPSFigure(name: "#76 Bunny", imageName: "76_bunny"),
    
    // #77 Pomeranian
    "150240089ES": LPSFigure(name: "#77 Pomeranian", imageName: "77_pomeranian"),
    "281241094ES": LPSFigure(name: "#77 Pomeranian", imageName: "77_pomeranian"),
    "131241088ES": LPSFigure(name: "#77 Pomeranian", imageName: "77_pomeranian"),
    "165245095ES": LPSFigure(name: "#77 Pomeranian", imageName: "77_pomeranian"),
    "190240093ES": LPSFigure(name: "#77 Pomeranian", imageName: "77_pomeranian"),
    
    // #78 Seagull
    "150240090ES": LPSFigure(name: "#78 Seagull", imageName: "78_seagull"),
    "281241095ES": LPSFigure(name: "#78 Seagull", imageName: "78_seagull"),
    "131241089ES": LPSFigure(name: "#78 Seagull", imageName: "78_seagull"),
    "165245096ES": LPSFigure(name: "#78 Seagull", imageName: "78_seagull"),
    "190240094ES": LPSFigure(name: "#78 Seagull", imageName: "78_seagull"),
    
    // #79 Wolfcat
    "150240091ES": LPSFigure(name: "#79 Wolfcat", imageName: "79_wolfcat"),
    "190240095ES": LPSFigure(name: "#79 Wolfcat", imageName: "79_wolfcat"),
    "248248099ES": LPSFigure(name: "#79 Wolfcat", imageName: "79_wolfcat"),
    "281241096ES": LPSFigure(name: "#79 Wolfcat", imageName: "79_wolfcat"),
    "131241090ES": LPSFigure(name: "#79 Wolfcat", imageName: "79_wolfcat"),
    "165245097ES": LPSFigure(name: "#79 Wolfcat", imageName: "79_wolfcat"),
    
    // #80 Axolotl
    "150240092ES": LPSFigure(name: "#80 Axolotl", imageName: "80_axolotl"),
    "281241097ES": LPSFigure(name: "#80 Axolotl", imageName: "80_axolotl"),
    "131241091ES": LPSFigure(name: "#80 Axolotl", imageName: "80_axolotl"),
    "165245098ES": LPSFigure(name: "#80 Axolotl", imageName: "80_axolotl"),
    "190240096ES": LPSFigure(name: "#80 Axolotl", imageName: "80_axolotl"),
    
    // #81 Scottish terrier
    "150240093ES": LPSFigure(name: "#81 Scottish terrier", imageName: "81_scottish_terrier"),
    "281241098ES": LPSFigure(name: "#81 Scottish terrier", imageName: "81_scottish_terrier"),
    "131241092ES": LPSFigure(name: "#81 Scottish terrier", imageName: "81_scottish_terrier"),
    "165245099ES": LPSFigure(name: "#81 Scottish terrier", imageName: "81_scottish_terrier"),
    "190240097ES": LPSFigure(name: "#81 Scottish terrier", imageName: "81_scottish_terrier"),
    
    // #82 Kiwi bird
    "150240094ES": LPSFigure(name: "#82 Kiwi bird", imageName: "82_kiwi_bird"),
    "281241099ES": LPSFigure(name: "#82 Kiwi bird", imageName: "82_kiwi_bird"),
    "131241093ES": LPSFigure(name: "#82 Kiwi bird", imageName: "82_kiwi_bird"),
    "165245100ES": LPSFigure(name: "#82 Kiwi bird", imageName: "82_kiwi_bird"),
    "190240098ES": LPSFigure(name: "#82 Kiwi bird", imageName: "82_kiwi_bird"),
    
    // #83 Iguana
    "150240095ES": LPSFigure(name: "#83 Iguana", imageName: "83_iguana"),
    "28124100ES": LPSFigure(name: "#83 Iguana", imageName: "83_iguana"),
    "131241094ES": LPSFigure(name: "#83 Iguana", imageName: "83_iguana"),
    "165245101ES": LPSFigure(name: "#83 Iguana", imageName: "83_iguana"),
    "190240099ES": LPSFigure(name: "#83 Iguana", imageName: "83_iguana"),
    
    // #84 Goat
    "150240096ES": LPSFigure(name: "#84 Goat", imageName: "84_goat"),
    "281241101ES": LPSFigure(name: "#84 Goat", imageName: "84_goat"),
    "131241095ES": LPSFigure(name: "#84 Goat", imageName: "84_goat"),
    "165245102ES": LPSFigure(name: "#84 Goat", imageName: "84_goat"),
    "190240100ES": LPSFigure(name: "#84 Goat", imageName: "84_goat"),
    
    // #85 Monkey
    "150240097ES": LPSFigure(name: "#85 Monkey", imageName: "85_monkey"),
    "281241102ES": LPSFigure(name: "#85 Monkey", imageName: "85_monkey"),
    "131241096ES": LPSFigure(name: "#85 Monkey", imageName: "85_monkey"),
    "165245103ES": LPSFigure(name: "#85 Monkey", imageName: "85_monkey"),
    "190240101ES": LPSFigure(name: "#85 Monkey", imageName: "85_monkey"),
    
    // #86 Opossum
    "150240098ES": LPSFigure(name: "#86 Opossum", imageName: "86_opossum"),
    "281241103ES": LPSFigure(name: "#86 Opossum", imageName: "86_opossum"),
    "131241097ES": LPSFigure(name: "#86 Opossum", imageName: "86_opossum"),
    "165245104ES": LPSFigure(name: "#86 Opossum", imageName: "86_opossum"),
    "190240102ES": LPSFigure(name: "#86 Opossum", imageName: "86_opossum"),
    
    // #87 Donkey
    "150240099ES": LPSFigure(name: "#87 Donkey", imageName: "87_donkey"),
    "281241104ES": LPSFigure(name: "#87 Donkey", imageName: "87_donkey"),
    "131241098ES": LPSFigure(name: "#87 Donkey", imageName: "87_donkey"),
    "165245105ES": LPSFigure(name: "#87 Donkey", imageName: "87_donkey"),
    "190240103ES": LPSFigure(name: "#87 Donkey", imageName: "87_donkey"),
    
    // WAVE 3
    // #131 Panda
    "335245148ES": LPSFigure(name: "#131 Panda", imageName: "131_panda"),
    "309249149ES": LPSFigure(name: "#131 Panda", imageName: "131_panda"),
    "256246150ES": LPSFigure(name: "#131 Panda", imageName: "131_panda"),
    "337247150ES": LPSFigure(name: "#131 Panda", imageName: "131_panda"),
    "281241148ES": LPSFigure(name: "#131 Panda", imageName: "131_panda"),
    
    // #132 Cat
    "335245149ES": LPSFigure(name: "#132 Cat", imageName: "132_cat"),
    "309249150ES": LPSFigure(name: "#132 Cat", imageName: "132_cat"),
    "281241149ES": LPSFigure(name: "#132 Cat", imageName: "132_cat"),
    "256246151ES": LPSFigure(name: "#132 Cat", imageName: "132_cat"),
    "337247151ES": LPSFigure(name: "#132 Cat", imageName: "132_cat"),
    
    // #133 Turtle
    "335245150ES": LPSFigure(name: "#133 Turtle", imageName: "133_turtle"),
    "309249151ES": LPSFigure(name: "#133 Turtle", imageName: "133_turtle"),
    "281241150ES": LPSFigure(name: "#133 Turtle", imageName: "133_turtle"),
    "256246152ES": LPSFigure(name: "#133 Turtle", imageName: "133_turtle"),
    "337247152ES": LPSFigure(name: "#133 Turtle", imageName: "133_turtle"),
    
    // #134 Ant
    "335245151ES": LPSFigure(name: "#134 Ant", imageName: "134_ant"),
    "309249152ES": LPSFigure(name: "#134 Ant", imageName: "134_ant"),
    "281241151ES": LPSFigure(name: "#134 Ant", imageName: "134_ant"),
    "256246153ES": LPSFigure(name: "#134 Ant", imageName: "134_ant"),
    "337247153ES": LPSFigure(name: "#134 Ant", imageName: "134_ant"),
    
    // #135 Goldendoodle
    "335245152ES": LPSFigure(name: "#135 Goldendoodle", imageName: "135_goldendoodle"),
    "309249153ES": LPSFigure(name: "#135 Goldendoodle", imageName: "135_goldendoodle"),
    "281241152ES": LPSFigure(name: "#135 Goldendoodle", imageName: "135_goldendoodle"),
    "256246154ES": LPSFigure(name: "#135 Goldendoodle", imageName: "135_goldendoodle"),
    "337247154ES": LPSFigure(name: "#135 Goldendoodle", imageName: "135_goldendoodle"),
    
    // #137 Owl
    "335245154ES": LPSFigure(name: "#137 Owl", imageName: "137_owl"),
    "309249155ES": LPSFigure(name: "#137 Owl", imageName: "137_owl"),
    "281241154ES": LPSFigure(name: "#137 Owl", imageName: "137_owl"),
    "256246156ES": LPSFigure(name: "#137 Owl", imageName: "137_owl"),
    "337247156ES": LPSFigure(name: "#137 Owl", imageName: "137_owl"),
    
    // #138 Emo Goldfish
    "335245155ES": LPSFigure(name: "#138 Emo Goldfish", imageName: "138_emo_goldfish"),
    "309249156ES": LPSFigure(name: "#138 Emo Goldfish", imageName: "138_emo_goldfish"),
    "281241155ES": LPSFigure(name: "#138 Emo Goldfish", imageName: "138_emo_goldfish"),
    "256246157ES": LPSFigure(name: "#138 Emo Goldfish", imageName: "138_emo_goldfish"),
    "337247157ES": LPSFigure(name: "#138 Emo Goldfish", imageName: "138_emo_goldfish"),
    
    // #139 Sloth
    "335245156ES": LPSFigure(name: "#139 Sloth", imageName: "139_sloth"),
    "309249157ES": LPSFigure(name: "#139 Sloth", imageName: "139_sloth"),
    "281241156ES": LPSFigure(name: "#139 Sloth", imageName: "139_sloth"),
    "256246158ES": LPSFigure(name: "#139 Sloth", imageName: "139_sloth"),
    "337247158ES": LPSFigure(name: "#139 Sloth", imageName: "139_sloth"),
    
    // #140 Himalayan kitten
    "335245157ES": LPSFigure(name: "#140 Himalayan kitten", imageName: "140_himalayan_kitten"),
    "309249158ES": LPSFigure(name: "#140 Himalayan kitten", imageName: "140_himalayan_kitten"),
    "281241157ES": LPSFigure(name: "#140 Himalayan kitten", imageName: "140_himalayan_kitten"),
    "256246159ES": LPSFigure(name: "#140 Himalayan kitten", imageName: "140_himalayan_kitten"),
    "337247159ES": LPSFigure(name: "#140 Himalayan kitten", imageName: "140_himalayan_kitten"),
    
    // #141 Rhino
    "335245158ES": LPSFigure(name: "#141 Rhino", imageName: "141_rhino"),
    "309249159ES": LPSFigure(name: "#141 Rhino", imageName: "141_rhino"),
    "281241158ES": LPSFigure(name: "#141 Rhino", imageName: "141_rhino"),
    "256246160ES": LPSFigure(name: "#141 Rhino", imageName: "141_rhino"),
    "337247160ES": LPSFigure(name: "#141 Rhino", imageName: "141_rhino"),
    
    // #142 Axolotl (no name given)
    "335245159ES": LPSFigure(name: "#142 Axolotl", imageName: "142_axolotl"),
    "309249160ES": LPSFigure(name: "#142 Axolotl", imageName: "142_axolotl"),
    "281241159ES": LPSFigure(name: "#142 Axolotl", imageName: "142_axolotl"),
    "256246161ES": LPSFigure(name: "#142 Axolotl", imageName: "142_axolotl"),
    "337247161ES": LPSFigure(name: "#142 Axolotl", imageName: "142_axolotl"),
    
    // #143 Capybara
    "335245160ES": LPSFigure(name: "#143 Capybara", imageName: "143_capybara"),
    "309249161ES": LPSFigure(name: "#143 Capybara", imageName: "143_capybara"),
    "281241160ES": LPSFigure(name: "#143 Capybara", imageName: "143_capybara"),
    "256246162ES": LPSFigure(name: "#143 Capybara", imageName: "143_capybara"),
    "337247162ES": LPSFigure(name: "#143 Capybara", imageName: "143_capybara"),
    
    // #144 Lhasa Apso dog
    "335245161ES": LPSFigure(name: "#144 Lhasa Apso dog", imageName: "144_lhasa_apso"),
    "309249162ES": LPSFigure(name: "#144 Lhasa Apso dog", imageName: "144_lhasa_apso"),
    "281241161ES": LPSFigure(name: "#144 Lhasa Apso dog", imageName: "144_lhasa_apso"),
    "256246163ES": LPSFigure(name: "#144 Lhasa Apso dog", imageName: "144_lhasa_apso"),
    "337247163ES": LPSFigure(name: "#144 Lhasa Apso dog", imageName: "144_lhasa_apso"),
    
    // #145 Walrus
    "335245162ES": LPSFigure(name: "#145 Walrus", imageName: "145_walrus"),
    "309249163ES": LPSFigure(name: "#145 Walrus", imageName: "145_walrus"),
    "281241162ES": LPSFigure(name: "#145 Walrus", imageName: "145_walrus"),
    "256246164ES": LPSFigure(name: "#145 Walrus", imageName: "145_walrus"),
    "337247164ES": LPSFigure(name: "#145 Walrus", imageName: "145_walrus"),
    
    // #146 Jack Russell
    "335245163ES": LPSFigure(name: "#146 Jack Russell", imageName: "146_jack_russell"),
    "309249164ES": LPSFigure(name: "#146 Jack Russell", imageName: "146_jack_russell"),
    "281241163ES": LPSFigure(name: "#146 Jack Russell", imageName: "146_jack_russell"),
    "256246165ES": LPSFigure(name: "#146 Jack Russell", imageName: "146_jack_russell"),
    "337247165ES": LPSFigure(name: "#146 Jack Russell", imageName: "146_jack_russell"),
    
    // #147 Quail
    "335245164ES": LPSFigure(name: "#147 Quail", imageName: "147_quail"),
    "309249165ES": LPSFigure(name: "#147 Quail", imageName: "147_quail"),
    "281241164ES": LPSFigure(name: "#147 Quail", imageName: "147_quail"),
    "256246166ES": LPSFigure(name: "#147 Quail", imageName: "147_quail"),
    "337247166ES": LPSFigure(name: "#147 Quail", imageName: "147_quail"),
    
    // #148 Wolf
    "335245165ES": LPSFigure(name: "#148 Wolf", imageName: "148_wolf"),
    "309249166ES": LPSFigure(name: "#148 Wolf", imageName: "148_wolf"),
    "281241165ES": LPSFigure(name: "#148 Wolf", imageName: "148_wolf"),
    "256246167ES": LPSFigure(name: "#148 Wolf", imageName: "148_wolf"),
    "337247167ES": LPSFigure(name: "#148 Wolf", imageName: "148_wolf"),
    
    // WAVE 4
    // #225 Panda
    "104254237ES": LPSFigure(name: "#225 Panda", imageName: "225_panda"),
    "139259245ES": LPSFigure(name: "#225 Panda", imageName: "225_panda"),
    
    // #226 Owl
    "104254238ES": LPSFigure(name: "#226 Owl", imageName: "226_owl"),
    "139259246ES": LPSFigure(name: "#226 Owl", imageName: "226_owl"),
    
    // #227 Pug
    "104254239ES": LPSFigure(name: "#227 Pug", imageName: "227_pug"),
    "139259247ES": LPSFigure(name: "#227 Pug", imageName: "227_pug"),
    
    // #228 Chihuahua
    "104254240ES": LPSFigure(name: "#228 Chihuahua", imageName: "228_chihuahua"),
    "139259248ES": LPSFigure(name: "#228 Chihuahua", imageName: "228_chihuahua"),
    
    // #229 Cat
    "104254241ES": LPSFigure(name: "#229 Cat", imageName: "229_cat"),
    "139259249ES": LPSFigure(name: "#229 Cat", imageName: "229_cat"),
    
    // #230 Panda
    "104254242ES": LPSFigure(name: "#230 Panda", imageName: "230_panda"),
    "139259250ES": LPSFigure(name: "#230 Panda", imageName: "230_panda"),
    
    // #231 Octopus
    "104254243ES": LPSFigure(name: "#231 Octopus", imageName: "231_octopus"),
    "139259251ES": LPSFigure(name: "#231 Octopus", imageName: "231_octopus"),
    
    // #232 Peacock
    "104254244ES": LPSFigure(name: "#232 Peacock", imageName: "232_peacock"),
    "139259252ES": LPSFigure(name: "#232 Peacock", imageName: "232_peacock"),
    
    // #233 Cow
    "104254245ES": LPSFigure(name: "#233 Cow", imageName: "233_cow"),
    "139259253ES": LPSFigure(name: "#233 Cow", imageName: "233_cow"),
    
    // #234 Rabbit
    "104254246ES": LPSFigure(name: "#234 Rabbit", imageName: "234_rabbit"),
    "139259254ES": LPSFigure(name: "#234 Rabbit", imageName: "234_rabbit"),
    
    // #235 Crab
    "104254247ES": LPSFigure(name: "#235 Crab", imageName: "235_crab"),
    "139259255ES": LPSFigure(name: "#235 Crab", imageName: "235_crab"),
    
    // #236 Deer
    "104254248ES": LPSFigure(name: "#236 Deer", imageName: "236_deer"),
    "139259256ES": LPSFigure(name: "#236 Deer", imageName: "236_deer"),
    
    // #237 Koala
    "104254249ES": LPSFigure(name: "#237 Koala", imageName: "237_koala"),
    "139259257ES": LPSFigure(name: "#237 Koala", imageName: "237_koala"),
    
    // #238 Giraffe
    "104254250ES": LPSFigure(name: "#238 Giraffe", imageName: "238_giraffe"),
    "139259258ES": LPSFigure(name: "#238 Giraffe", imageName: "238_giraffe"),
    
    // #239 Leopard
    "104254251ES": LPSFigure(name: "#239 Leopard", imageName: "239_leopard"),
    "139259259ES": LPSFigure(name: "#239 Leopard", imageName: "239_leopard"),
    
    // #240 Husky
    "104254252ES": LPSFigure(name: "#240 Husky", imageName: "240_husky"),
    "139259260ES": LPSFigure(name: "#240 Husky", imageName: "240_husky"),
    
    // #241 Fox
    "104254253ES": LPSFigure(name: "#241 Fox", imageName: "241_fox"),
    "139259261ES": LPSFigure(name: "#241 Fox", imageName: "241_fox"),
    
    // #242 Dachshund
    "104254254ES": LPSFigure(name: "#242 Dachshund", imageName: "242_dachshund"),
    "139259262ES": LPSFigure(name: "#242 Dachshund", imageName: "242_dachshund"),
]
