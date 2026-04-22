extends CanvasLayer
signal dialogue_choice(int)
var selected_option = 0
var labels: Array[Node] = []

# Function which displays given dialogue text as well as possible given responses
func show_text(text, responses):
	$Dialogue.text = text
	$Dialogue.show()
	hide_labels()
	labels = []
	var position_y = 70
	for response in responses:
		create_label(response, Vector2(19, position_y))
		position_y += 30
	show_labels()

# Function which hides text and deletes all current label objects
func hide_text():
	$Dialogue.hide()
	for i: Node in labels:
		i.free()
	labels = []

func show_labels():
	for label in labels:
		label.show()

func hide_labels():
	for label in labels:
		label.hide()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Dialogue.hide()
	$DialogueOptions.hide()

# Function to create a label object based on given text and position
# Also sets up LabelSettings object for each label
func create_label(text, position):
	var label = $DialogueOptions.duplicate(15)
	
	label.text = text
	label.position = position
	
	label.label_settings = LabelSettings.new()
	label.label_settings.font_size = 32
	label.label_settings.outline_color = Color(0.0, 0.0, 0.949, 1.0)
	
	add_child(label)
	
	labels.append(label)
	
	return label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# If a label is the selected_option, it is highlighted in blue and up and down inputs
	# can be used to change the selected dialogue option. If interact key is pressed,
	# the selected dialogue option is sent to the NPC
	if Global.currently_talking == true:
		for i in range(labels.size()):
			if i == selected_option:
				labels[i].label_settings.outline_size = 5
			else:
				labels[i].label_settings.outline_size = 0
		if Input.is_action_just_pressed("move_down"):
			selected_option += 1
		if Input.is_action_just_pressed("move_up"):
			selected_option -= 1
		selected_option = clamp(selected_option, 0, labels.size() - 1)
		if Input.is_action_just_pressed("interact"):
			dialogue_choice.emit(selected_option)
