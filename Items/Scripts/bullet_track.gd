extends Area2D

var speed = 5
var tank
@onready var nav: NavigationAgent2D = $NavigationAgent2D

func _ready():
	tank =  get_node("../tank_hull")

func _physics_process(delta):
	nav.target_position = tank.global_position
	var direction = Vector3()
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	rotation = direction.angle()
	position += direction *2
	

			
func _on_area_entered(area):
	if area.name != "tank_collision":
		queue_free()
	pass # Replace with function body.



func _on_body_entered(body):
	if body.name == "tank_hull" || body.name == "tank_collision" || body.name == "tank_turret":
		body.visible = false
	elif body.get_node_or_null("turret"):
		body.queue_free()
		Global.enemies -= 1
	elif body.get_node_or_null("tank"):
		body.queue_free()
		Global.enemies -=1

	queue_free()
	pass # Replace with function body.
