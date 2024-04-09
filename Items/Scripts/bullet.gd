extends Area2D

var speed = 250
var l
func _ready():
	l = get_parent()

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_Bullet_body_entered(body):
	if body.name == "tank_hull" || body.name == "tank_collision" || body.name == "tank_turret":
		body.visible = false
	elif body.get_node_or_null("turret"):
		body.queue_free()
		Global.score += (200 * Global.adventure_mode_diff_selected[6])
		l.update_score()
		Global.enemies -= 1
	#if body.name == "Map":
	queue_free()


func _on_area_entered(area):
	if area.name != "tank_collision":
		queue_free()
	pass # Replace with function body.
