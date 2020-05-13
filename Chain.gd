extends Sprite

var player : RigidBody2D
var grapple_point : Vector2

func _physics_process(_delta):
	var chain_length = (grapple_point - player.position).length()
	position = grapple_point.move_toward(player.position, chain_length / 2)
	rotation = player.position.angle_to_point(grapple_point)
	scale = Vector2(chain_length, 1)
