extends Node2D

onready var player = preload("res://Player/Player.tscn")

var players_positions : Array = []
var alive : Array = []
var map : Array = []
var mul = 1

func _input(event):
	if event.is_action_pressed("respawn"):
		while alive.size() <= event.device:
			alive.append(false)
		while players_positions.size() <= event.device:
			var free_position = find_free_position()
			var map_end = find_map_end()
			var mirrored_position = map_end - free_position
			players_positions.append(free_position)
			players_positions.append(mirrored_position)
		if not alive[event.device]:
			alive[event.device] = true
			var player_instance = player.instance()
			player_instance.position = players_positions[event.device]
			player_instance.initialize_group(event.device)
			player_instance.connect("on_player_died", self, "remove_alive")
			add_child(player_instance)

func find_map_end():
	if map.size() == 0:
		return Vector2.ZERO
	return Vector2(map.size(), map[0].size())*mul

func find_free_position():
	if map.size() == 0:
		return Vector2.ZERO
	randomize()
	var y = round(rand_range(0, map.size()-1))
	var x = round(rand_range(0, map[0].size()-1))
	while map[y][x] != 0:
		y = round(rand_range(0, map.size()-1))
		x = round(rand_range(0, map[0].size()-1))
	return Vector2(x, y)*mul

func remove_alive(player_id):
	alive[player_id] = false

func _on_Drawer_on_map_updated(new_map):
	map = new_map

func _on_Drawer_on_map_drawn(multiplier):
	mul = multiplier
