extends Area2D

@export var speed = 400 # Player Speed
var screen_size # Size of the screen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	position = Vector2(575, 343)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Handles player movement when the "wasd" keys are pressed
	var velocity = Vector2.ZERO
	if Global.currently_talking == false:
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1
	
	# Normalize speed of Player, play walking animations when moving, and correctly
	# calculate position of player based on movement
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
		$AnimatedSprite2D.animation = "walk"
	else:
		$AnimatedSprite2D.animation = "stand"
		$AnimatedSprite2D.stop()
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
