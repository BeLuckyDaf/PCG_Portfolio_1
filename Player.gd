class_name Player
extends KinematicBody2D

onready var bullet = preload("res://Bullet.tscn")

export var speed : float = 100
export var player_id : int = 1

var up_str = "p1_up"
var down_str = "p1_down"
var left_str = "p1_left"
var right_str = "p1_right"
var shoot_str = "p1_shoot"

var move : Vector2
var last_move : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	move = Vector2.ZERO

func _draw():
	draw_circle(Vector2.ZERO, 4, Color.green)

func _input(event):
	if event.is_action_pressed(down_str):
		move.y = event.get_action_strength(down_str)
	elif event.is_action_pressed(up_str):
		move.y = -event.get_action_strength(up_str)
	elif event.is_action_pressed(right_str):
		move.x = event.get_action_strength(right_str)
	elif event.is_action_pressed(left_str):
		move.x = -event.get_action_strength(left_str)
	
	if event.is_action_released(down_str) and event.is_action_released(up_str):
		if move.y != 0:
			last_move.y = move.y
		move.y = 0
	if event.is_action_released(right_str) and event.is_action_released(left_str):
		if move.x != 0:
			last_move.x = move.x
		move.x = 0
	
	if event.is_action_pressed(shoot_str):
		if move.length() == 0:
			if last_move.length() == 0:
				last_move = Vector2.RIGHT
			spawn_bullet(last_move.normalized())
		else:
			spawn_bullet(move.normalized())

func initialize_group(id):
	player_id = id
	add_to_group("Player_%d" % player_id)
	up_str = "p%d_up" % player_id
	down_str = "p%d_down" % player_id
	left_str = "p%d_left" % player_id
	right_str = "p%d_right" % player_id
	shoot_str = "p%d_shoot" % player_id

func spawn_bullet(direction):
	var instance = bullet.instance()
	instance.position = position + direction
	instance.group = "Player_%d" % player_id
	get_tree().root.add_child(instance)
	instance.launch(direction)

func _process(delta):
	move_and_collide(move.normalized() * delta * speed)
	update()
