extends Area2D

var velocity = Vector2.ZERO

func _process(delta):
	position += velocity * delta

func set_velocity(v):
	velocity = v
