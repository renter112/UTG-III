extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():

	pass # Replace with function body.


func _on_pressed():
	Global.level = text
	Global.goto_scene("res://LevelTools/level.tscn")
	pass # Replace with function body.