extends Node
@export var npc_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_npc(
		{
			0: Line.new(["...What do you want?"], [0, 1, 2] as Array[int]),
			1: Line.new(["My name is uh...Bob. Just Bob."], [1, 5, 2] as Array[int]),
			2: Line.new(["Well, talking to you of course!"], [3, 0, 5, 2] as Array[int]),
			3: Line.new(["I don't know anything about a crime being commited...",
						"Definitely nothing at all..."], [4, 5, 2] as Array[int]),
			4: Line.new(["...I gotta go."], [2] as Array[int])
		},
		{
			0: Response.new("What is your name?", 1, false),
			1: Response.new("What are you doing here?", 2, false),
			2: Response.new("Leave Conversation", 0, true),
			3: Response.new("Have you heard or seen anything suspicious?", 3, false),
			4: Response.new("I never mentioned any crime", 4, false),
			5: Response.new("Let's talk about something else", 0, false)
		}, 
		"suspicious", Vector2(300, 300)
	)
	create_npc(
		{
			0: Line.new(["Hello detective. Is there something I can do for you?"], [0, 1, 2] as Array[int]),
			1: Line.new(["My name is John Clark."], [1, 3, 2] as Array[int]),
			2: Line.new([
				"I was walking home from work when I heard the commotion.",
				"I live nearby so I figured I should check it out, make sure everything was okay."
				], [4, 0, 3, 2] as Array[int]
			),
			3: Line.new([
				"Like I said, heard the commotion on the way home. By the time I got here,
				there were already a couple people crowded around.",
				"I didn't see anything directly, but that shady character over there
				has been hanging around for a bit.",
				"Since the police showed up, he's been looking real nervous and kind of fidgety.",
				"When I tried talking to him, he kinda blew up at me and asked me to shove off."
				], [0, 3, 2] as Array[int]
			)
		},
		{
			0: Response.new("What is your name?", 1, false),
			1: Response.new("What are you doing here?", 2, false),
			2: Response.new("Leave Conversation", 0, true),
			3: Response.new("Let's talk about something else", 0, false),
			4: Response.new("Have you heard or seen anything suspicious?", 3, false)
		},
		"helpful", Vector2(900, 300)
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass

# Function which creates an NPC object when given am input of lines, responses, type, and 
# position. Also creates signals needed for each NPC object
func create_npc(lines: Dictionary[int, Line], responses: Dictionary[int, Response], type, position):
	var npc = npc_scene.instantiate()
	
	npc.dialogue = lines
	npc.dialogue_responses = responses
	npc.type = type
	npc.position = position
	
	npc.talk.connect(get_parent()._on_npc_talk)
	npc.stop_talking.connect(get_parent()._on_npc_stop_talking)
	
	get_parent().dialogue_choice.connect(npc._on_dialogue_choice)
	
	add_child(npc)
	
