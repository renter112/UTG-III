extends Node2D

var health = 2
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_armour_left_body_entered(body):
	print(body)
	$ArmourLeft.queue_free()
	health -= 1
	check_alive()
	pass # Replace with function body.


func check_alive():
	if health == 0:
		queue_free()


func _on_armor_right_body_entered(area):
	$ArmorRight.queue_free()
	health -= 1
	check_alive()
	pass # Replace with function body.
