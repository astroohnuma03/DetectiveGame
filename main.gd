extends Node
signal dialogue_choice

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Upon receiving talk signal from NPC, tell HUD to display text
func _on_npc_talk(text: Variant, responses: Variant) -> void:
	$HUD.show_text(text, responses)

# Upon receiving stop talking signal from NPC, tell HUD to hide text
func _on_npc_stop_talking() -> void:
	$HUD.hide_text()

# Receive dialogue_choice signal from HUD and emit signal to NPC
func _on_hud_dialogue_choice(choice: int) -> void:
	dialogue_choice.emit(choice)
