extends Area2D

@export var speed: float = 400.0
@export var lifetime: float = 2.0

var direction: Vector2 = Vector2.RIGHT

func _ready():
	body_entered.connect(_on_body_entered)

func setup(new_direction: Vector2):
	direction = new_direction.normalized()

	# 这张火球图默认朝右上，所以加 45 度修正。
	rotation = direction.angle() + PI / 4.0

func _physics_process(delta):
	global_position += direction * speed * delta

	lifetime -= delta
	if lifetime <= 0:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("enemy"):
		queue_free()
