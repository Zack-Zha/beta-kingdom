extends CharacterBody2D

@export var speed: float = 100.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_range: Area2D = $AttackRange

var player: Node2D

func _ready():
	animated_sprite.play("run")
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if player == null:
		return

	var direction := player.global_position - global_position

	if direction.x < 0:
		animated_sprite.flip_h = true
	elif direction.x > 0:
		animated_sprite.flip_h = false

	if is_player_in_attack_range():
		velocity = Vector2.ZERO
		animated_sprite.play("attack")
	else:
		direction = direction.normalized()
		velocity = direction * speed
		animated_sprite.play("run")

	move_and_slide()

func is_player_in_attack_range() -> bool:
	var bodies := attack_range.get_overlapping_bodies()

	for body in bodies:
		if body.is_in_group("player"):
			return true

	return false
