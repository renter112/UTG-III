extends Control

func _ready():
	$Label.text = Global.notif_message
	Global.notif_message = ""

func _on_timer_timeout():
	queue_free()
	pass # Replace with function body.
