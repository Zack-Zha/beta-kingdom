extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	animated_sprite.play("explode")
	animated_sprite.animation_finished.connect(_on_animation_finished)

func _on_animation_finished():
	queue_free()
