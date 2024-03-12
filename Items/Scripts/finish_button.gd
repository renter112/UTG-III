extends Area2D

var good = false


signal level_finish()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Global.get_enemies() <= 0:
		$Sprite2D.texture = preload("res://Items/Assets/finishButton.png")
		good = true
	pass


func _on_area_entered(area):
	if area.get_parent().name == "tank_hull" && good:
		emit_signal("level_finish")
	pass # Replace with function body.
