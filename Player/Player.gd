class_name Player
extends KinematicBody2D

signal on_player_died(id)

onready var timer := $Timer
onready var bullet = preload("res://Player/Bullet.tscn")

export var speed : float = 100
export var player_id : int = 0
export var reload_time : float = 0.1

var move_up_str = "p_mup"
var move_down_str = "p_mdown"
var move_left_str = "p_mleft"
var move_right_str = "p_mright"
var look_up_str = "p_lup"
var look_down_str = "p_ldown"
var look_left_str = "p_lleft"
var look_right_str = "p_lright"
var shoot_str = "p_shoot"

var move : Vector2
var look : Vector2

var can_shoot : bool = true
var shooting : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	move = Vector2.ZERO
	add_to_group("Destroyable")

func _draw():
	draw_circle(Vector2.ZERO, 4, Color.green)
	draw_line(Vector2.ZERO, look.normalized()*10, Color.orange, 2)

func _input(event):
	if event.device != player_id:
		return
	if event.is_action_pressed(move_down_str):
		move.y = event.get_action_strength(move_down_str)
	elif event.is_action_pressed(move_up_str):
		move.y = -event.get_action_strength(move_up_str)
	elif event.is_action_pressed(move_right_str):
		move.x = event.get_action_strength(move_right_str)
	elif event.is_action_pressed(move_left_str):
		move.x = -event.get_action_strength(move_left_str)

	if event.is_action_released(move_down_str) and event.is_action_released(move_up_str):
		move.y = 0
	if event.is_action_released(move_right_str) and event.is_action_released(move_left_str):
		move.x = 0
	
	if event.is_action_pressed(look_down_str):
		look.y = event.get_action_strength(look_down_str)
	elif event.is_action_pressed(look_up_str):
		look.y = -event.get_action_strength(look_up_str)
	elif event.is_action_pressed(look_right_str):
		look.x = event.get_action_strength(look_right_str)
	elif event.is_action_pressed(look_left_str):
		look.x = -event.get_action_strength(look_left_str)
	
	if event.is_action_released(look_down_str) and event.is_action_released(look_up_str):
		look.y = 0
	if event.is_action_released(look_right_str) and event.is_action_released(look_left_str):
		look.x = 0
	
	if event.is_action_pressed(shoot_str):
		shooting = true
	if event.is_action_released(shoot_str):
		shooting = false

func initialize_group(id):
	player_id = id
	add_to_group("Player_%d" % player_id)

func spawn_bullet(direction):
	var instance = bullet.instance()
	instance.position = position + direction * 8
	instance.group = "Player_%d" % player_id
	get_tree().root.add_child(instance)
	instance.launch(direction)

func shoot():
	if look.length() > 0 and can_shoot:
		spawn_bullet(look.normalized())
		can_shoot = false
		timer.start(reload_time)

func _process(delta):
# warning-ignore:return_value_discarded
	move_and_collide(move * delta * speed)
	shoot()
	update()

func destroy():
	emit_signal("on_player_died", player_id)
	queue_free()

func _on_Timer_timeout():
	can_shoot = true
