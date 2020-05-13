extends RigidBody2D

signal fire_grapple
signal start_aiming_grapple

onready var raycast : RayCast2D = $RayCast2D

export var grapple_angle_speed : float = 3.0


var grapple_aiming : bool = false
var grapple_pressed : bool = false
var other_button_pressed : bool = false
var grapple_angle : float = PI * 3 / 2
var grapple_aim_direction : int = -1

func _ready():
	raycast.enabled = false
	
func _physics_process(delta):
	get_input()
	process_grapple(delta)

func get_input():
	grapple_pressed = false
	other_button_pressed = false
	
	if Input.is_action_pressed("ui_accept"):
		grapple_pressed = true
	
	if Input.is_action_pressed("ui_cancel"):
		other_button_pressed = true

func process_grapple(delta):
	if grapple_aiming:
		if grapple_pressed:
			grapple_angle -= (grapple_angle_speed * delta * grapple_aim_direction)
			if grapple_angle < PI / 2 || grapple_angle > PI * 3 / 2:
				grapple_aim_direction *= -1
			raycast.rotation = grapple_angle
		else:
			grapple_aiming = false
			raycast.enabled = false
			fire_grapple()
	else:
		if grapple_pressed:
			emit_signal("start_aiming_grapple")
			grapple_aiming = true
			grapple_angle = PI * 3 / 2
			raycast.enabled = true

func fire_grapple():
	var grapple_vector = Vector2(-1 * sin(grapple_angle), cos(grapple_angle))
	var grapple_position = grapple_vector * 75.0
	var grapple_velocity = grapple_vector * 700.0
	emit_signal("fire_grapple", grapple_position, grapple_velocity)
