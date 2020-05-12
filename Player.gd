extends KinematicBody2D

onready var raycast = $RayCast2D

export var grapple_angle_speed = 3.0

var Grapple = preload("res://Grapple.tscn")

var grapple_aiming = false
var grapple_pressed = false
var other_button_pressed = false
var grapple_angle = PI * 3 / 2
var grapple_aim_direction = -1

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
			grapple_aiming = true
			grapple_angle = PI * 3 / 2
			raycast.enabled = true

func fire_grapple():
	var grapple_vector = Vector2(-1 * sin(grapple_angle), cos(grapple_angle))
	var grapple = Grapple.instance()
	grapple.position = grapple_vector * 75.0
	grapple.apply_central_impulse(grapple_vector * 700.0)
	add_child(grapple)
	grapple.connect("body_entered", self, "on_grapple_hit")
	
func on_grapple_hit(body):
	print(body)
