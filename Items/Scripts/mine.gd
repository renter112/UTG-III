extends Node2D

var green_sprite = preload("res://Items/Assets/mine.png")
var red_sprite = preload("res://Items/Assets/mine_explode.png")
var counter = 0

func _ready():
	pass
	
func _process(_delta):
	pass

func explode():
	get_tree().call_group("player","mine_boom")
	$explosion.visible = true
	$explosion.monitoring = true
	$explosion.monitorable = true
	print("KABOOM")
	


func _on_timer_timeout():
	counter +=1
	if counter >7:
		explode()
	if counter % 2 == 0:
		$Area2D/Sprite2D.texture = green_sprite
		$Timer.start(.8)
	else :
		$Area2D/Sprite2D.texture = red_sprite
		$Timer.start(.2)
	pass # Replace with function body.




func _on_explosion_body_entered(body):
	if body.name == "tank_hull" || body.name == "tank_collision" || body.name == "tank_turret":
		body.visible = false
	elif body.get_node_or_null("turret"):
		body.queue_free()
		Global.enemies -= 1
	queue_free()
	pass # Replace with function body.


func _on_explosion_area_entered(area):
	if area.name != "tank_collision":
		queue_free()
	pass # Replace with function body.


func _on_area_2d_body_entered(body):
	if body.get_node_or_null("turret"):
		explode()
	pass # Replace with function body.
