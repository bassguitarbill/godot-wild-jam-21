extends Node2D

onready var player = $Player

var Grapple = preload("res://Grapple.tscn")
var ChainLink = preload("res://ChainLink.tscn")
var grapple

const link_length = 30.0

func _on_Player_fire_grapple(pos, velocity):
	grapple = Grapple.instance()
	grapple.position = pos + player.position
	grapple.set_velocity(velocity)
	add_child(grapple)
	grapple.connect("body_entered", self, "on_grapple_hit")

func on_grapple_hit(_body):
	create_chain(grapple.position, player.position)
	grapple.queue_free()
	grapple = null

func create_chain(start_pos, end_pos):
	var chain = end_pos - start_pos
	var chain_angle = chain.angle()
	var chain_length = chain.length()
	var remaining_length = chain_length
	var current_node = StaticBody2D.new()
	current_node.position = start_pos
	$ChainPieces.add_child(current_node, true)
	var current_node_pos = start_pos.move_toward(end_pos, link_length / 2)
	while remaining_length > link_length:
		var link = ChainLink.instance()
		link.position = current_node_pos.move_toward(end_pos, 3 + (link_length / 2))
		link.rotation = chain_angle + (PI / 2)
		$ChainPieces.add_child(link, true)
		#$ChainPieces.call_deferred("add_child", link, true)
		var joint = PinJoint2D.new()
		joint.set_node_a("../" + current_node.name)
		joint.set_node_b("../" + link.name)
		joint.position = current_node_pos
		joint.disable_collision = true
		$ChainPieces.add_child(joint)
		#$ChainPieces.call_deferred("add_child", joint)
		remaining_length -= link_length
		current_node_pos = current_node_pos.move_toward(end_pos, link_length)
		current_node = link
	var joint = PinJoint2D.new()
	joint.set_node_a("../" + current_node.name)
	joint.set_node_b("../../" + player.name)
	joint.position = current_node_pos
	joint.disable_collision = true
	$ChainPieces.add_child(joint)
	#get_tree().paused = true
