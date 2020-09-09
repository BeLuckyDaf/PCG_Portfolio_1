class_name Bullet
extends KinematicBody2D

export var speed : float = 500

var direction : Vector2
var group := "Player_1"

func launch(launch_direction):
	direction = launch_direction

# Called when the node enters the scene tree for the first time.
func _ready():
	direction = Vector2.ZERO

func _draw():
	draw_circle(Vector2.ZERO, 2, Color.red)

func _process(delta):
	if direction.length() > 0:
		var collision = move_and_collide(direction.normalized() * delta * speed)
		if collision is KinematicCollision2D and collision.collider is Node:
			if not collision.collider.is_in_group(group):
				if collision.collider.is_in_group("Destroyable"):
					collision.collider.destroy()
				else:
					collision.collider.call_deferred("queue_free")
			queue_free()
	update()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
