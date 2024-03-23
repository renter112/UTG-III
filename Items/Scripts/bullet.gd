extends Area2D

var speed = 250

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_Bullet_body_entered(body):
	get_tree().call_group("level", "play_bullet_play")
	if body.name == "tank_hull" || body.name == "tank_collision" || body.name == "tank_turret":
		body.visible = false
	elif body.get_node_or_null("turret"):
		body.queue_free()
		Global.enemies -= 1
	#if body.name == "Map":
	if body.name == "Map":
		call_deferred("updateT",body)
	queue_free()

func updateT(body):
	queue_free()
	var b = body as TileMap
	var bp = b.local_to_map($col_Marker.global_position)
	if b.get_cell_atlas_coords(1,bp) == Vector2i(5,2):
		b.call_deferred("erase_cell", 1,bp)
		if Global.osaka_mode_on:
			b.call_deferred("set_cell",0,bp,1,Vector2i(2,2),0)
		else:
			b.call_deferred("set_cell",0,bp,0,Vector2i(2,2),0)
			
func _on_area_entered(area):
	if area.name != "tank_collision":
		get_tree().call_group("level", "play_bullet_play")
		queue_free()
	pass # Replace with function body.
