extends Area2D
signal talk(text, responses)
signal stop_talking
var dialogue: Dictionary[int, Line] = {}
var dialogue_responses: Dictionary[int, Response] = {}
var current_dialogue = 0
var current_sentence = 0
var type = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	var overlapping_node = get_overlapping_areas()
	if len(overlapping_node) == 0:
		return
	
	# Check if the player is not currently talking to an NPC and if they aren't
	# allow interact key (e) to initiate dialogue
	if Global.currently_talking == false:
		if Input.is_action_just_pressed("interact"):
			Global.currently_talking = true
			var responses = get_responses()
			talk.emit(dialogue.get(current_dialogue).TextList[current_sentence], responses)

# Function to get the list of response text from the dialogue_responses dictionary
# aka "yes", "no", etc.
func get_responses():
	var responses = []
	var response_ids = []
	var current_line = dialogue.get(current_dialogue)
	response_ids = current_line.Responses
	if not is_last_sentence():
		responses.append(">...")
		return responses
		
	for response_id in response_ids:
		responses.append(dialogue_responses.get(response_id).Text)
	
	return responses

# Function to determine if we are one the last sentence in a line of dialogue
# Returns true if we are one the last sentence, false otherwise
func is_last_sentence():
	var current_line = dialogue.get(current_dialogue)
	return current_sentence == current_line.TextList.size() - 1

# Function which receives the dialogue_choice signal from main and emits the next line
# to be displayed depending on dialogue choice, or exits dialogue if that was chosen
func _on_dialogue_choice(choice: int):
	var overlapping_node = get_overlapping_areas()
	if len(overlapping_node) == 0:
		return
		
	if Global.currently_talking == false:
		return
	
	# If there are strings remaining in the current line, display the next string and replace
	# The linked responses list with a generic continue response
	if not is_last_sentence():
		current_sentence += 1
		var responses = get_responses()
		talk.emit(dialogue.get(current_dialogue).TextList[current_sentence], responses)
		return
	
	current_sentence = 0
	var current = dialogue.get(current_dialogue)
	var response_id = current.Responses[choice]
	var response = dialogue_responses.get(response_id)
	var next_line = dialogue.get(response.LineId)
	
	# If the chosen dialogue choice exits the dialogue, hide text and reset the dialogue tree
	# Also waits to receive input to prevent dialogue immediately being restarted
	if response.Exits == true:
		stop_talking.emit()
		current_dialogue = 0
		await get_tree().create_timer(0.1).timeout
		Global.currently_talking = false
		return
	
	current_dialogue = response.LineId
	var responses = get_responses()
	talk.emit(next_line.TextList[current_sentence], responses)
