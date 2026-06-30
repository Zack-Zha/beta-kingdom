extends CharacterBody2D

@export var speed: float = 100.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var player: Node2D

func _ready():
	animated_sprite.play("run")
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if player == null:
		return

	var direction := player.global_position - global_position

	if direction.length() > 0:
		direction = direction.normalized()

		if direction.x < 0:
			animated_sprite.flip_h = true
		elif direction.x > 0:
			animated_sprite.flip_h = false

	velocity = direction * speed
	move_and_slide()
