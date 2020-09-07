extends Node2D

onready var player = preload("res://Player.tscn")

var id : int = 1

func _input(event):
	if event.is_action_pressed("click") and id < 3:
		var player_instance = player.instance()
		player_instance.position = get_global_mouse_position()
		player_instance.initialize_group(id)
		add_child(player_instance)
		id += 1
