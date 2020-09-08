extends Particles2D

func _ready():
	emitting = true
	($Timer as Timer).start(3)

func _on_Timer_timeout():
	queue_free()
