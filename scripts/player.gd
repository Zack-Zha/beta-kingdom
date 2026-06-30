extends CharacterBody2D

@export var speed: float = 200.0
@export var projectile_scene: PackedScene
@export var attack_interval: float = 0.8
@export var attack_range: float = 500.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var attack_timer: float = 0.0

func _ready():
	animated_sprite.play("idle")

func _physics_process(delta):
	handle_movement()
	handle_attack(delta)

func handle_movement():
	var direction := Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1

	if direction.length() > 0:
		direction = direction.normalized()
		animated_sprite.play("run")

		if direction.x < 0:
			animated_sprite.flip_h = true
		elif direction.x > 0:
			animated_sprite.flip_h = false
	else:
		animated_sprite.play("idle")

	velocity = direction * speed
	move_and_slide()

func handle_attack(delta):
	attack_timer -= delta

	if attack_timer > 0:
		return

	var target := get_nearest_enemy()
	if target == null:
		return

	shoot_projectile(target)
	attack_timer = attack_interval

func get_nearest_enemy() -> Node2D:
	var enemies := get_tree().get_nodes_in_group("enemy")

	var nearest_enemy: Node2D = null
	var nearest_distance := attack_range

	for enemy in enemies:
		if enemy is Node2D:
			var distance := global_position.distance_to(enemy.global_position)

			if distance < nearest_distance:
				nearest_distance = distance
				nearest_enemy = enemy

	return nearest_enemy

func shoot_projectile(target: Node2D):
	if projectile_scene == null:
		return

	var projectile = projectile_scene.instantiate()
	get_parent().add_child(projectile)

	projectile.global_position = global_position

	var shoot_direction := target.global_position - global_position
	projectile.setup(shoot_direction)
