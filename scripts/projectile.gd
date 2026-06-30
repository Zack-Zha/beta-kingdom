extends Area2D

@export var start_speed: float = 40.0
@export var max_speed: float = 850.0
@export var acceleration_time: float = 0.18
@export var lifetime: float = 2.0
@export var explosion_scene: PackedScene

var direction: Vector2 = Vector2.RIGHT
var target: Node2D
var age: float = 0.0

func _ready():
	body_entered.connect(_on_body_entered)

func setup(new_direction: Vector2, new_target: Node2D = null):
	direction = new_direction.normalized()
	target = new_target
	update_rotation()

func _physics_process(delta):
	age += delta

	if is_instance_valid(target):
		var target_direction := target.global_position - global_position

		if target_direction.length() > 0:
			direction = target_direction.normalized()

	var speed := get_current_speed()
	global_position += direction * speed * delta
	update_rotation()

	lifetime -= delta
	if lifetime <= 0:
		queue_free()

func get_current_speed() -> float:
	var t: float = clampf(age / acceleration_time, 0.0, 1.0)

	# ease out cubic：前期加速很快，后期接近最高速
	var curve_t := 1.0 - pow(1.0 - t, 3.0)

	return lerp(start_speed, max_speed, curve_t)

func update_rotation():
	# 这张火球图默认朝右上，所以加 45 度修正。
	rotation = direction.angle() + PI / 4.0

func _on_body_entered(body):
	if body.is_in_group("enemy"):
		spawn_explosion()
		queue_free()

func spawn_explosion():
	if explosion_scene == null:
		return

	var explosion = explosion_scene.instantiate()

	var effects = get_tree().current_scene.get_node_or_null("Effects")
	if effects:
		effects.add_child(explosion)
	else:
		get_parent().add_child(explosion)
	explosion.global_position = global_position
