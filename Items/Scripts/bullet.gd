extends Area2D

var speed = 250

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_Bullet_body_entered(body):
	print(body.name)
	if body.name == "tank_hull":
		body.queue_free()
	elif body.get_node_or_null("turret"):
		body.queue_free()
		Global.enemies -= 1
	queue_free()


func _on_area_entered(area):
	print(area)
	queue_free()
	pass # Replace with function body.
