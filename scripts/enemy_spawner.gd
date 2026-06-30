extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_interval: float = 1.5
@export var max_enemies: int = 6
@export var spawn_radius: float = 350.0

var timer: float = 0.0

func _physics_process(delta):
	timer -= delta
	if timer > 0:
		return

	var enemies := get_tree().get_nodes_in_group("enemy")
	if enemies.size() < max_enemies:
		spawn_enemy()

	timer = spawn_interval

func spawn_enemy():
	if enemy_scene == null:
		return

	var player := get_tree().get_first_node_in_group("player")
	if player == null:
		return

	var enemy = enemy_scene.instantiate()

	var entities = get_tree().current_scene.get_node_or_null("Entities")
	if entities:
		entities.add_child(enemy)
	else:
		get_parent().add_child(enemy)

	var angle := randf_range(0.0, TAU)
	var offset := Vector2.RIGHT.rotated(angle) * spawn_radius
	enemy.global_position = player.global_position + offset
