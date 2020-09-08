extends Node2D

func _input(event):
	if event.is_action_pressed("reload"):
# warning-ignore:return_value_discarded
		$CenterContainer.set_size(OS.window_size)
		$CenterContainer.visible = true
		$ReloadTimer.start(0.1)


func _on_Timer_timeout():
	get_tree().reload_current_scene()
