extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	AudioStreamPlayer2d.playing = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$RichTextLabel.position.y -= 0.5
	if $RichTextLabel.position.y <= -8700 :
		AudioStreamPlayer2d.playing = true
		Global.goto_scene("res://Menus/main_menu.tscn")
	pass

func _input(event):
	if event.is_action_pressed("pause"):
		AudioStreamPlayer2d.playing = true
		Global.goto_scene("res://Menus/main_menu.tscn")
