#!/usr/bin/env bash

# =-=-=-=-=-=-=-=[ EMOJIS ]-=-=-=-=-=-=-=-=
# Search: EMOJIS
emoji_data=$(cat <<'EMOJI_EOF'
😀 | Grinning Face
😃 | Grinning with Big Eyes
😄 | Grinning with Smiling Eyes
😁 | Beaming with Smiling Eyes
😅 | Grinning with Sweat
😂 | Face with Tears of Joy
🤣 | Rolling on Floor Laughing
😊 | Smiling with Smiling Eyes
😇 | Smiling with Halo
🙂 | Slightly Smiling
😉 | Winking
😌 | Relieved
😍 | Heart Eyes
🥰 | Smiling with Hearts
😘 | Face Blowing a Kiss
😗 | Kissing
😋 | Face Savoring Food
😛 | Face with Tongue
😜 | Winking with Tongue
🤪 | Zany Face
😝 | Squinting with Tongue
🤑 | Money-Mouth
🤗 | Hugging
🤭 | Hand Over Mouth
🤫 | Shushing
🤔 | Thinking
🤐 | Zipper-Mouth
😐 | Neutral
😑 | Expressionless
😶 | Face Without Mouth
😏 | Smirking
😒 | Unamused
🙄 | Face with Rolling Eyes
😬 | Grimacing
😮 | Face with Open Mouth
😯 | Hushed
😲 | Astonished
😳 | Flushed
🥺 | Pleading
😢 | Crying
😭 | Loudly Crying
😤 | Face with Steam From Nose
😠 | Angry
😡 | Pouting
🤬 | Face with Symbols on Mouth
💀 | Skull
☠️ | Skull and Crossbones
💩 | Pile of Poo
🤡 | Clown
👹 | Ogre
👺 | Goblin
👻 | Ghost
👽 | Alien
🤖 | Robot
😺 | Grinning Cat
😸 | Grinning Cat with Smiling Eyes
😹 | Cat with Tears of Joy
😻 | Cat with Heart Eyes
😼 | Cat with Wry Smile
😽 | Kissing Cat
🙀 | Weary Cat
😿 | Crying Cat
😾 | Pouting Cat
🙈 | See-No-Evil Monkey
🙉 | Hear-No-Evil Monkey
🙊 | Speak-No-Evil Monkey
💋 | Kiss Mark
💌 | Love Letter
💘 | Heart with Arrow
💝 | Heart with Ribbon
💖 | Sparkling Heart
💗 | Growing Heart
💓 | Beating Heart
💞 | Revolving Hearts
💕 | Two Hearts
💟 | Heart Decoration
❣️ | Heart Exclamation
💔 | Broken Heart
❤️ | Red Heart
🧡 | Orange Heart
💛 | Yellow Heart
💚 | Green Heart
💙 | Blue Heart
💜 | Purple Heart
🤎 | Brown Heart
🖤 | Black Heart
🤍 | White Heart
💯 | Hundred Points
💢 | Anger Symbol
💬 | Speech Balloon
👋 | Waving Hand
🤚 | Raised Back of Hand
✋ | Raised Hand
🖐️ | Hand with Fingers Splayed
✌️ | Victory Hand
🤞 | Crossed Fingers
🤟 | Love-You Gesture
🤘 | Sign of the Horns
🤙 | Call Me Hand
👌 | OK Hand
👍 | Thumbs Up
👎 | Thumbs Down
✊ | Raised Fist
👊 | Oncoming Fist
🤛 | Left-Facing Fist
🤜 | Right-Facing Fist
👏 | Clapping Hands
🙌 | Raising Hands
👐 | Open Hands
🤲 | Palms Up Together
🤝 | Handshake
🙏 | Folded Hands
✍️ | Writing Hand
💪 | Flexed Biceps
🦵 | Leg
🦶 | Foot
👀 | Eyes
👁️ | Eye
👅 | Tongue
👄 | Mouth
🦷 | Tooth
👂 | Ear
👃 | Nose
🧠 | Brain
🗣️ | Speaking Head
👤 | Bust in Silhouette
👥 | Busts in Silhouette
👶 | Baby
🧒 | Child
👦 | Boy
👧 | Girl
🧑 | Person
👨 | Man
👩 | Woman
🧔 | Beard
👴 | Old Man
👵 | Old Woman
🧓 | Older Person
👲 | Man with Skullcap
👳 | Person with Turban
👮 | Police Officer
🕵️ | Detective
💂 | Guard
🥷 | Ninja
👷 | Construction Worker
🤴 | Prince
👸 | Princess
👳‍♂️ | Man with Turban
👳‍♀️ | Woman with Turban
👮‍♂️ | Man Police Officer
👮‍♀️ | Woman Police Officer
🕵️‍♂️ | Man Detective
🕵️‍♀️ | Woman Detective
💂‍♂️ | Man Guard
💂‍♀️ | Woman Guard
👷‍♂️ | Man Construction Worker
👷‍♀️ | Woman Construction Worker
🤵 | Person in Tuxedo
👰 | Person with Veil
🤰 | Pregnant Woman
🤱 | Breast-Feeding
👼 | Baby Angel
🎅 | Santa Claus
🤶 | Mrs. Claus
🦸 | Superhero
🦹 | Supervillain
🧙 | Mage
🧚 | Fairy
🧛 | Vampire
🧜 | Merperson
🧝 | Elf
🧞 | Genie
🧟 | Zombie
💆 | Person Getting Massage
💇 | Person Getting Haircut
🚶 | Person Walking
🧍 | Person Standing
🧎 | Person Kneeling
🏃 | Person Running
💃 | Woman Dancing
🕺 | Man Dancing
👯 | People with Bunny Ears
🧖 | Person in Steamy Room
🧗 | Person Climbing
🤸 | Person Cartwheeling
🏌️ | Person Golfing
🏄 | Person Surfing
🚣 | Person Rowing Boat
🏊 | Person Swimming
🤽 | Person Playing Water Polo
🤾 | Person Playing Handball
🤹 | Person Juggling
🧘 | Person in Lotus Position
🛀 | Person Taking Bath
🛌 | Person in Bed
👑 | Crown
👒 | Woman's Hat
🎩 | Top Hat
🎓 | Graduation Cap
🧢 | Billed Cap
⛑️ | Rescue Worker's Helmet
💄 | Lipstick
💍 | Ring
💎 | Gem Stone
🐶 | Dog Face
🐱 | Cat Face
🐭 | Mouse Face
🐹 | Hamster
🐰 | Rabbit Face
🦊 | Fox
🐻 | Bear
🐼 | Panda
🐨 | Koala
🐯 | Tiger Face
🦁 | Lion
🐮 | Cow Face
🐷 | Pig Face
🐸 | Frog
🐵 | Monkey Face
🐔 | Chicken
🐧 | Penguin
🐦 | Bird
🐤 | Baby Chick
🦆 | Duck
🦅 | Eagle
🦉 | Owl
🦇 | Bat
🐺 | Wolf
🐗 | Boar
🐴 | Horse Face
🦄 | Unicorn
🐝 | Honeybee
🐛 | Bug
🦋 | Butterfly
🐌 | Snail
🐞 | Lady Beetle
🐜 | Ant
🦟 | Mosquito
🦗 | Cricket
🕷️ | Spider
🦂 | Scorpion
🦀 | Crab
🐍 | Snake
🦎 | Lizard
🦖 | T-Rex
🦕 | Sauropod
🐢 | Turtle
🐳 | Spouting Whale
🐋 | Whale
🐬 | Dolphin
🐟 | Fish
🐠 | Tropical Fish
🐡 | Blowfish
🦈 | Shark
🐙 | Octopus
🐚 | Spiral Shell
🌺 | Hibiscus
🌸 | Cherry Blossom
🌼 | Blossom
🌻 | Sunflower
🌹 | Rose
🌷 | Tulip
🌱 | Seedling
🌲 | Evergreen Tree
🌳 | Deciduous Tree
🌴 | Palm Tree
🌵 | Cactus
🌾 | Sheaf of Rice
🌿 | Herb
☘️ | Shamrock
🍀 | Four Leaf Clover
🍁 | Maple Leaf
🍂 | Fallen Leaf
🍃 | Leaf Fluttering in Wind
🍇 | Grapes
🍈 | Melon
🍉 | Watermelon
🍊 | Tangerine
🍋 | Lemon
🍌 | Banana
🍍 | Pineapple
🥭 | Mango
🍎 | Red Apple
🍏 | Green Apple
🍐 | Pear
🍑 | Peach
🍒 | Cherries
🍓 | Strawberry
🫐 | Blueberries
🥝 | Kiwi
🍅 | Tomato
🥥 | Coconut
🥑 | Avocado
🍆 | Eggplant
🥔 | Potato
🥕 | Carrot
🌽 | Ear of Corn
🌶️ | Hot Pepper
🥒 | Cucumber
🥬 | Leafy Green
🥦 | Broccoli
🧄 | Garlic
🧅 | Onion
🍄 | Mushroom
🥜 | Peanuts
🌰 | Chestnut
🍞 | Bread
🥐 | Croissant
🥖 | Baguette Bread
🥨 | Pretzel
🥯 | Bagel
🥞 | Pancakes
🧇 | Waffle
🧀 | Cheese Wedge
🍖 | Meat on Bone
🍗 | Poultry Leg
🥩 | Cut of Meat
🥓 | Bacon
🍔 | Hamburger
🍟 | French Fries
🍕 | Pizza
🌭 | Hot Dog
🥪 | Sandwich
🌮 | Taco
🌯 | Burrito
🥙 | Stuffed Flatbread
🧆 | Falafel
🥚 | Egg
🍳 | Cooking
🥘 | Shallow Pan of Food
🍲 | Pot of Food
🥣 | Bowl with Spoon
🥗 | Green Salad
🍿 | Popcorn
🧈 | Butter
🧂 | Salt
🥫 | Canned Food
🍱 | Bento Box
🍘 | Rice Cracker
🍙 | Rice Ball
🍚 | Cooked Rice
🍛 | Curry Rice
🍜 | Steaming Bowl
🍝 | Spaghetti
🍠 | Roasted Sweet Potato
🍢 | Oden
🍣 | Sushi
🍤 | Fried Shrimp
🍥 | Fish Cake with Swirl
🥮 | Moon Cake
🍡 | Dango
🥟 | Dumpling
🦪 | Oyster
🍦 | Soft Ice Cream
🍧 | Shaved Ice
🍨 | Ice Cream
🍩 | Doughnut
🍪 | Cookie
🎂 | Birthday Cake
🍰 | Shortcake
🧁 | Cupcake
🥧 | Pie
🍫 | Chocolate
🍬 | Candy
🍭 | Lollipop
🍮 | Custard
🍯 | Honey Pot
🍼 | Baby Bottle
🥛 | Glass of Milk
☕ | Hot Beverage
🫖 | Teapot
🍵 | Teacup Without Handle
🍶 | Sake
🍾 | Bottle with Popping Cork
🍷 | Wine Glass
🍸 | Cocktail Glass
🍹 | Tropical Drink
🍺 | Beer Mug
🍻 | Clinking Beer Mugs
🥂 | Clinking Glasses
🥃 | Tumbler Glass
🥤 | Cup with Straw
🧋 | Bubble Tea
🧃 | Beverage Box
🧉 | Mate
🧊 | Ice
🌍 | Globe Showing Europe-Africa
🌎 | Globe Showing Americas
🌏 | Globe Showing Asia-Australia
🌐 | Globe with Meridians
🗺️ | World Map
⛰️ | Mountain
🏔️ | Snow-Capped Mountain
🌋 | Volcano
🗻 | Mount Fuji
🏠 | House
🏡 | House with Garden
🏢 | Office Building
🏣 | Japanese Post Office
🏤 | Post Office
🏥 | Hospital
🏦 | Bank
🏪 | Convenience Store
🏫 | School
🏬 | Department Store
🏭 | Factory
🏯 | Japanese Castle
🏰 | Castle
💒 | Wedding
🗼 | Tokyo Tower
🗽 | Statue of Liberty
⛪ | Church
🕌 | Mosque
🛕 | Hindu Temple
🕍 | Synagogue
⛩️ | Shinto Shrine
⌚ | Watch
📱 | Mobile Phone
📲 | Mobile Phone with Arrow
💻 | Laptop
⌨️ | Keyboard
🖥️ | Desktop Computer
🖨️ | Printer
🖱️ | Computer Mouse
🖲️ | Trackball
💽 | Computer Disk
💾 | Floppy Disk
💿 | Optical Disk
📀 | DVD
🧮 | Abacus
📷 | Camera
📸 | Camera with Flash
📹 | Video Camera
📼 | Videocassette
🔍 | Magnifying Glass Tilted Left
🔎 | Magnifying Glass Tilted Right
🕯️ | Candle
💡 | Light Bulb
🔦 | Flashlight
🏮 | Red Paper Lantern
📔 | Notebook with Decorative Cover
📕 | Closed Book
📖 | Open Book
📗 | Green Book
📘 | Blue Book
📙 | Orange Book
📚 | Books
📓 | Notebook
📒 | Ledger
📃 | Page with Curl
📜 | Scroll
📄 | Page Facing Up
📰 | Newspaper
🗞️ | Rolled-Up Newspaper
📑 | Bookmark Tabs
🔖 | Bookmark
🏷️ | Label
💰 | Money Bag
💴 | Yen Banknote
💵 | Dollar Banknote
💶 | Euro Banknote
💷 | Pound Banknote
💸 | Money with Wings
💳 | Credit Card
🧾 | Receipt
✉️ | Envelope
📧 | E-Mail
📨 | Incoming Envelope
📩 | Envelope with Arrow
📤 | Outbox Tray
📥 | Inbox Tray
📦 | Package
📫 | Closed Mailbox with Raised Flag
📪 | Closed Mailbox with Lowered Flag
📬 | Open Mailbox with Raised Flag
📭 | Open Mailbox with Lowered Flag
📮 | Postbox
📝 | Memo
💼 | Briefcase
📁 | File Folder
📂 | Open File Folder
🗂️ | Card Index Dividers
📅 | Calendar
📆 | Tear-Off Calendar
📇 | Card Index
📈 | Chart Increasing
📉 | Chart Decreasing
📊 | Bar Chart
📋 | Clipboard
📌 | Pushpin
📍 | Round Pushpin
📎 | Paperclip
🖇️ | Linked Paperclips
📐 | Triangular Ruler
📏 | Straight Ruler
🔗 | Link
🔒 | Locked
🔓 | Unlocked
🔑 | Key
🗝️ | Old Key
🔨 | Hammer
🪓 | Axe
⛏️ | Pick
⚒️ | Hammer and Pick
🛠️ | Hammer and Wrench
🗡️ | Dagger
⚔️ | Crossed Swords
🔫 | Water Pistol
🛡️ | Shield
🔧 | Wrench
🔩 | Nut and Bolt
⚙️ | Gear
🗜️ | Clamp
⚖️ | Balance Scale
🦯 | White Cane
⛓️ | Chains
🧰 | Toolbox
🧲 | Magnet
⚗️ | Alembic
🧪 | Test Tube
🧫 | Petri Dish
🧬 | DNA
🔬 | Microscope
🔭 | Telescope
📡 | Satellite Antenna
💉 | Syringe
🩸 | Drop of Blood
💊 | Pill
🩹 | Adhesive Bandage
🚑 | Ambulance
🚒 | Fire Engine
🚓 | Police Car
🚔 | Oncoming Police Car
🚕 | Taxi
🚗 | Automobile
🚙 | Sport Utility Vehicle
🚌 | Bus
🚎 | Trolleybus
🏎️ | Racing Car
🚐 | Minibus
🚚 | Delivery Truck
🚛 | Articulated Lorry
🚜 | Tractor
🏍️ | Motorcycle
🛵 | Motor Scooter
🛴 | Kick Scooter
🚲 | Bicycle
🛹 | Skateboard
🛼 | Roller Skate
🚏 | Bus Stop
🛣️ | Motorway
🛤️ | Railway Track
⛽ | Fuel Pump
🚨 | Police Car Light
🚥 | Horizontal Traffic Light
🚦 | Vertical Traffic Light
🛑 | Stop Sign
🚧 | Construction
⚓ | Anchor
⛵ | Sailboat
🛶 | Canoe
🚤 | Speedboat
🛳️ | Passenger Ship
⛴️ | Ferry
🛥️ | Motor Boat
🚢 | Ship
✈️ | Airplane
🛩️ | Small Airplane
🛫 | Airplane Departure
🛬 | Airplane Arrival
🪂 | Parachute
💺 | Seat
🚁 | Helicopter
🚟 | Suspension Railway
🚠 | Mountain Cableway
🚡 | Aerial Tramway
🛰️ | Satellite
🚀 | Rocket
🛸 | Flying Saucer
🌠 | Shooting Star
⭐ | Star
🌟 | Glowing Star
🌌 | Milky Way
☀️ | Sun
🌤️ | Sun Behind Small Cloud
⛅ | Sun Behind Cloud
🌥️ | Sun Behind Large Cloud
🌦️ | Sun Behind Rain Cloud
☁️ | Cloud
🌧️ | Cloud with Rain
⛈️ | Cloud with Lightning and Rain
🌩️ | Cloud with Lightning
🌨️ | Cloud with Snow
❄️ | Snowflake
☃️ | Snowman
⛄ | Snowman Without Snow
🔥 | Fire
💥 | Collision
⚡ | High Voltage
🌈 | Rainbow
☔ | Umbrella with Rain Drops
💧 | Droplet
🌊 | Water Wave
🎃 | Jack-O-Lantern
🎄 | Christmas Tree
🎆 | Fireworks
🎇 | Sparkler
🧨 | Firecracker
✨ | Sparkles
🎈 | Balloon
🎉 | Party Popper
🎊 | Confetti Ball
🎋 | Tanabata Tree
🎍 | Pine Decoration
🎎 | Japanese Dolls
🎏 | Carp Streamer
🎐 | Wind Chime
🎑 | Moon Viewing Ceremony
🧧 | Red Envelope
🎀 | Ribbon
🎁 | Wrapped Gift
🎗️ | Reminder Ribbon
🎟️ | Admission Tickets
🎫 | Ticket
🎖️ | Military Medal
🏆 | Trophy
🏅 | Sports Medal
🥇 | 1st Place Medal
🥈 | 2nd Place Medal
🥉 | 3rd Place Medal
⚽ | Soccer Ball
⚾ | Baseball
🥎 | Softball
🏀 | Basketball
🏐 | Volleyball
🏈 | American Football
🏉 | Rugby Football
🎾 | Tennis
🥏 | Flying Disc
🎳 | Bowling
🏏 | Cricket Game
🏑 | Field Hockey
🏒 | Ice Hockey
🥍 | Lacrosse
🏓 | Ping Pong
🏸 | Badminton
🥊 | Boxing Glove
🥋 | Martial Arts Uniform
🥅 | Goal Net
⛳ | Flag in Hole
⛸️ | Ice Skate
🎣 | Fishing Pole
🤿 | Diving Mask
🎽 | Running Shirt
🎿 | Skis
🛷 | Sled
🥌 | Curling Stone
🎯 | Bullseye
🎱 | Pool 8 Ball
🎮 | Video Game
🕹️ | Joystick
🎰 | Slot Machine
🎲 | Game Die
🧩 | Puzzle Piece
🧸 | Teddy Bear
♠️ | Spade Suit
♥️ | Heart Suit
♦️ | Diamond Suit
♣️ | Club Suit
♟️ | Chess Pawn
🃏 | Joker
🀄 | Mahjong Red Dragon
🎴 | Flower Playing Cards
🎭 | Performing Arts
🎨 | Artist Palette
🧵 | Thread
🧶 | Yarn
👓 | Glasses
🕶️ | Sunglasses
🥽 | Goggles
🥼 | Lab Coat
🦺 | Safety Vest
👔 | Necktie
👕 | T-Shirt
👖 | Jeans
🧣 | Scarf
🧤 | Gloves
🧥 | Coat
🧦 | Socks
👗 | Dress
👘 | Kimono
🥻 | Sari
🩱 | One-Piece Swimsuit
🩲 | Briefs
🩳 | Shorts
👙 | Bikini
👚 | Woman's Clothes
👛 | Purse
👜 | Handbag
👝 | Clutch Bag
🎒 | Backpack
👞 | Man's Shoe
👟 | Running Shoe
🥾 | Hiking Boot
🥿 | Flat Shoe
👠 | High-Heeled Shoe
👡 | Woman's Sandal
👢 | Woman's Boot
🎤 | Microphone
🎧 | Headphone
🎷 | Saxophone
🎸 | Guitar
🎹 | Musical Keyboard
🎺 | Trumpet
🎻 | Violin
🥁 | Drum
🎬 | Clapper Board
🎵 | Musical Note
🎶 | Musical Notes
🎙️ | Studio Microphone
🎚️ | Level Slider
🎛️ | Control Knobs
📻 | Radio
📯 | Postal Horn
🎼 | Musical Score
📢 | Loudspeaker
📣 | Megaphone
🔔 | Bell
🔕 | Bell with Slash
🪕 | Banjo
⌛ | Hourglass Done
⏳ | Hourglass Not Done
⏰ | Alarm Clock
🕐 | One O'Clock
🕑 | Two O'Clock
🕒 | Three O'Clock
🕓 | Four O'Clock
🕔 | Five O'Clock
🕕 | Six O'Clock
🕖 | Seven O'Clock
🕗 | Eight O'Clock
🕘 | Nine O'Clock
🕙 | Ten O'Clock
🕚 | Eleven O'Clock
🕛 | Twelve O'Clock
🧭 | Compass
💈 | Barber Pole
⚰️ | Coffin
⚱️ | Funeral Urn
🔮 | Crystal Ball
🕳️ | Hole
🗿 | Moai
♻️ | Recycling Symbol
📛 | Name Badge
🔰 | Japanese Symbol for Beginner
⚠️ | Warning
🚸 | Children Crossing
⛔ | No Entry
🚫 | Prohibited
🚳 | No Bicycles
🚭 | No Smoking
🚯 | No Littering
🚱 | Non-Potable Water
🚷 | No Pedestrians
🔞 | No One Under Eighteen
☢️ | Radioactive
☣️ | Biohazard
📵 | No Mobile Phones
🔚 | END Arrow
🔙 | BACK Arrow
🔛 | ON! Arrow
🔜 | SOON Arrow
🔝 | TOP Arrow
🛐 | Place of Worship
⚛️ | Atom Symbol
🕉️ | Om
✡️ | Star of David
☸️ | Wheel of Dharma
☯️ | Yin Yang
✝️ | Latin Cross
☦️ | Orthodox Cross
☪️ | Star and Crescent
☮️ | Peace Symbol
🕎 | Menorah
🔯 | Dotted Six-Pointed Star
♈ | Aries
♉ | Taurus
♊ | Gemini
♋ | Cancer
♌ | Leo
♍ | Virgo
♎ | Libra
♏ | Scorpio
♐ | Sagittarius
♑ | Capricorn
♒ | Aquarius
♓ | Pisces
⛎ | Ophiuchus
🆔 | ID Button
🆚 | VS Button
📶 | Antenna Bars
📳 | Vibration Mode
📴 | Mobile Phone Off
🅰️ | A Button
🅱️ | B Button
🆎 | AB Button
🅾️ | O Button
💠 | Diamond with a Dot
♿ | Wheelchair Symbol
🚹 | Men's Room
🚺 | Women's Room
🚻 | Restroom
🚼 | Baby Symbol
🚾 | Water Closet
🛂 | Passport Control
🛃 | Customs
🛄 | Baggage Claim
🛅 | Left Luggage
🚰 | Potable Water
🚿 | Shower
🛁 | Bathtub
🧴 | Lotion Bottle
🧷 | Safety Pin
🧹 | Broom
🧺 | Basket
🧻 | Roll of Paper
🧼 | Soap
🧽 | Sponge
🧯 | Fire Extinguisher
🛒 | Shopping Cart
🚬 | Cigarette
🧿 | Nazar Amulet
🪄 | Magic Wand
🪅 | Piñata
🪆 | Nesting Dolls
🪡 | Sewing Needle
🪢 | Knot
🪣 | Bucket
🪤 | Mouse Trap
🪥 | Toothbrush
🪦 | Headstone
🪧 | Placard
🪪 | Identification Card
🪫 | Low Battery
🪬 | Hamsa
🪩 | Mirror Ball
🪨 | Rock
🪴 | Potted Plant
🪵 | Wood
🪶 | Feather
🪸 | Coral
🪹 | Empty Nest
🪺 | Nest with Eggs
🪻 | Hyacinth
🪼 | Jellyfish
🪽 | Wing
🪾 | Tree
🪿 | Goose
🫀 | Anatomical Heart
🫁 | Lungs
🫂 | People Hugging
🫃 | Pregnant Man
🫄 | Pregnant Person
🫅 | Person with Crown
🫆 | Fingerprint
🫎 | Moose
🫏 | Donkey
🫐 | Blueberries
🫑 | Bell Pepper
🫒 | Olive
🫓 | Flatbread
🫔 | Tamale
🫕 | Fondue
🫗 | Pouring Liquid
🫘 | Beans
🫙 | Jar
🫚 | Ginger Root
🫛 | Pea Pod
🫠 | Melting Face
🫡 | Saluting Face
🫢 | Face with Open Eyes and Hand Over Mouth
🫣 | Face with Peeking Eye
🫤 | Face with Diagonal Mouth
🫥 | Dotted Line Face
🫦 | Biting Lip
🫧 | Bubbles
🫨 | Shaking Face
EMOJI_EOF
)

# =-=-=-=-=-=-=-=[ ASCII ART ]-=-=-=-=-=-=-=-=
# Search: ASCII
ascii_data=$(cat <<'ASCII_EOF'
(╯°□°)╯︵ ┻━┻ | Table Flip
┬──┬ ノ( ゜-゜ノ) | Put Back Table
¯\_(ツ)_/¯ | Shrug
( ͡° ͜ʖ ͡°) | Lenny Face
ʕ•ᴥ•ʔ | Bear Face
(•_•) | Neutral
(•_•) >⌐■-■ | Sunglasses on
(⌐■_■) | Cool Guy
ಠ_ಠ | Disapproval
◉_◉ | Stare
(◕‿◕) | Happy
(◕‿◕✿) | Flower Happy
(︺︹︺) | Displeased
(╯°□°)╯ | Raised Arms
(╮°-°)╮ | Shrug Arms
(╥﹏╥) | Crying
(╥_╥) | Sad
(︺︹︺) | Meh
(｡◕‿◕｡) | Cute Happy
(｡◕‿‿◕｡) | Double Happy
(▰˘◡˘▰) | Blush
(◠‿◠✿) | Cute Flower
(¬‿¬) | Suspicious
(¬_¬) | Side Eye
(°ロ°) | Shocked
(°▽°) | Excited
(⊙_☉) | Wide Eye
(⊙_⊙) | O_O
(;;;・_・) | Nervous
(>_<) | Squeeze
(>_>) | Look Right
(<_<) | Look Left
ゞ( ́・ω・`) | Hidden Happy
(;′Д`) | Tear
(×_×) | X Eyes
(×﹏×) | Pain
(◕‿‿◕) | Close Happy
(｡◕‿◕｡) | Cute
(ｏ・_・)ノ | Wave
(ｏ・_・)ノﾞ | Big Wave
(￣▽￣) | Satisfied
(￣ω￣) | Complacent
(￣В￣) | Bashful
(￣^￣) | Proud
(￣‥￣) | Grumpy
(￣.￣) | Flat
(￣▽￣)ノ | Happy wave
(ノ°ο°)ノ | Panic
(˘_˘) | Dull
(˘̩‿˘̩) | Content
(˘⌣˘) | Mellow
(˘ε˘) | Frisky
(˘̩‿‿˘̩) | Content 2
(˘▽˘) | Happy
(˘ω˘) | Relax
(ฅ´ω`ฅ) | Cat happy
(ฅ·ω·ฅ) | Cat
(ฅ>ω<ฅ) | Cat excited
(ฅ^ω^ฅ) | Cat love
(´･ω･`) | Acknowledge
(´-ω-`) | Unfocus
(´∀`) | Acceptance
(´Д`) | Aghast
(´～`) | Sad
(´ο_｀) | Sleepy
(´；ω；`) | Tear
(´ゝω・) | Wink
(´ΘωΘ`) | Sleepy cat
(๑•̀ㅂ•́)و✧ | Determined
(๑>ᴗ<๑) | Cute happy
(๑◕‿◕๑) | Kind
(๑✧◡✧๑) | Starry
(๑´ㅂ`๑) | Blush
(๑´ڡ`๑) | Yum
(๑´•ω•) | Love
(๑¯ω¯๑) | Smug
(๑•̀ㅁ•́ฅ) | Cat determined
(๑ᵔ⌔ᵔ๑) | Soft happy
(๑•̀ω•́)ノ | Wave
(๑´ㅂ`๑) | Shy
(๑ᵔ⤙ᵔ๑) | Content
(ᵔᴥᵔ) | Doggy
(ᵒ̤̑ ₀̑ ᵒ̤̑) | Sad eyes
(ᵒ̤̑ɔɔɘ̑) | Cat curious
(◍•ᴗ•◍) | Shining
(◔_◔) | Susp
(◔‿◔) | Happy side
(◉‿◉) | Big happy
(◉ _ ◉) | Shock
(◕ᴗ◕) | Soft
(◕‿◕) | Standard happy
(◕‿◕)♡ | Heart happy
(◕★‿★◕) | Starry
(✿◠‿◠) | Flower cute
(✿◠‿◠✿) | Cute
(✿>‿✿) | Big cute
(✿^‿^) | Happy flower
(✿^‿^✿) | Double happy
(✿ᵔ‿ᵔ) | Soft flower
(✿□‿□) | Big eyes
(✿◕‿◕✿) | Flower happy
(✿◡‿◡) | Blush flower
(✿´‿`) | Content flower
(＞▽＜) | Happy
(＞▽＜)ノ | Happy wave
(＞ω<) | Squee happy
(＞ｗ＜) | Cute sq
(＞ωωω<) | Level 2 sq
(＾▽＾) | Big happy
(＾ω＾) | Soft happy
(＾▽＾)ノ | Wave happy
(＾∀＾) | Very happy
(＾○＾)○ | Zero happy
(＾▽＾)∼★ | Star!
(＾～＾) | Small happy
(＾◡＾) | Cute
(⊃ • ʖ • )⊃ | Hug
(⊃｡•́‿•̀｡)⊃ | Cosy hug
(⊃ ‿ ⊂) | Hug through
(⊃・ω・)⊃ | Comfy
(⊃。ω。)⊃ | Sleepy hug
(⊃❍‿❍)⊃ | Surprise hug
(⊃☉д☉)⊃ | Oh my!
(⊃*°▽°*)⊃ | Woah!
(⊃ಠ_ಠ)⊃ | Suspicious hug
(⊃◇◇)⊃ | Happy hug
~\(≧▽≦)/~ | Yay!
\o/ | Arms up
o/ | Half wave
\o | Half wave other
o7 | Salute
( ÒωÓ)ノ | Fist pump
( ╹▽╹ ) | Cute face
(⏓‿⏓) | Squish happy
(⏒‿⏒) | Content
(⏓‿‿⏓) | Squish double
(⏒ ⏒) | Sleepy
(⏒ᴗ⏒) | Sweet
(❤ω❤) | Heart eyes
(♥‿♥) | Love
(♡‿♡) | Love
(♡ω♡) | Weak
(♥_♥) | Love love
(♥‿｡) | Tender
(♥д♥) | Heart eyes
♡(◕ᴗ◕✿) | Cute love
♡(✿◕‿◕✿) | Double love
♥(✿◠‿◠) | Love flower
♡(˘▽˘) | Love happy
♡(◉ᴗ◉✿) | Starry love
♥(❤ω❤) | MAXIMUM
♡(♥ω♥✿) | Super love
♡(ᴗ◕✿) | Soft love
♥(◡‿◡✿) | Pink cute
♡(◠‿◠✿) | Happy love
♥(❁´◡`❁} | Blush love
♡(˙ᗜ˙✿) | Excited love
♥(✧ω✧) | Star love
⤜(◔‿‿◔)⤎ | Watcher
⤜(⏓‿⏓)⤎ | Squish watcher
⤜(♥ω♥)⤎ | Love watcher
⤜(◉‿‿◉)⤎ | Wide watcher
⤜(⏒ᴗ⏒)⤎❤ | Sweet watcher
⤜( ✧‿✧)⤎ | Starry watcher
⤜( ˘ ³ ˘)⤎ | Kissy watcher
⤜(⏒ ⏒)⤎ | Sleepy watcher
⤜(>ω<)⤎ | Cute watcher
⤜( ͡° ͜ʖ ͡°)⤎ | Lenny watcher
⤜(⌐■_■)⤎ | Cool watcher
⤜(◕‿◕)⤎ | Watcher
⤜(⚆_⚆)⤎ | Conscious watcher
ʎɐpǝp | Upside down
sʇᴉ lɐuoıʇɐu | Normal stuff
˙ʇı sʎɐʍʎlɐ | Upside down things
₃᷀ ᷁ ᷁ ᷁ ᷁ ᷁᷁᷁ ᷁ ﾊﾘ ハハ | Hug
⊂ ◉ ᴗ ◉ ⊂ ͜つ ッ "" | Boombox dance
ASCII_EOF
)

chosen=$(
  (echo "$emoji_data"; echo ""; echo "$ascii_data") \
    | fuzzel --dmenu --lines=15 --prompt="🔍 > " \
    | cut -d'|' -f1 \
    | sed 's/ *$//'
)

[ -n "$chosen" ] && wl-copy "$chosen"
