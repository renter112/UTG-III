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
	queue_free()


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


func _on_area_2d_body_entered(body):
	print(body)
	pass # Replace with function body.
