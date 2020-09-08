extends Node2D

onready var player = preload("res://Player/Player.tscn")

export var id : int = 0
export var max_players : int = 2

var players_positions : Array = []
var alive : Array = []

func _input(event):
	if event.is_action_pressed("click") and id < max_players:
		var player_instance = player.instance()
		players_positions.append(get_global_mouse_position())
		alive.append(true)
		player_instance.position = players_positions[id]
		player_instance.initialize_group(id)
		add_child(player_instance)
		player_instance.connect("on_player_died", self, "remove_alive")
		id += 1
	
	if alive.size() > event.device and event.is_action_pressed("respawn") and not alive[event.device]:
		alive[event.device] = true
		var player_instance = player.instance()
		player_instance.position = players_positions[event.device]
		player_instance.initialize_group(event.device)
		player_instance.connect("on_player_died", self, "remove_alive")
		add_child(player_instance)

func remove_alive(id):
	alive[id] = false
