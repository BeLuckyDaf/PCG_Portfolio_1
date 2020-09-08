extends Node2D

onready var player = preload("res://Player/Player.tscn")

export var id : int = 0
export var max_players : int = 2

func _input(event):
	if event.is_action_pressed("click") and id < max_players:
		var player_instance = player.instance()
		player_instance.position = get_global_mouse_position()
		player_instance.initialize_group(id)
		add_child(player_instance)
		id += 1
