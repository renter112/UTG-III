extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$RichTextLabel.position.y -= 1.0
	if $RichTextLabel.position.y <= -10000 :
		Global.goto_scene("res://Menus/options_menu.tscn")
	pass

func _input(event):
	if event.is_action_pressed("pause"):
		Global.goto_scene("res://Menus/options_menu.tscn")
