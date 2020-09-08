extends Node2D

func _input(event):
	if event.is_action_pressed("reload"):
# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
