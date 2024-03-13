extends Area2D

var bullet = preload("res://Items/bullet.tscn")
var bullet_delay = 0.2
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(_delta):
	bullet_delay = bullet_delay - _delta
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("shoot") && bullet_delay < 0:
		shoot()
		bullet_delay = 0.2
	pass

func shoot():
	Global.shots += 1
	var b = bullet.instantiate()
	get_tree().get_root().get_node("/root/level").add_child(b)
	b.transform = $Marker2D.global_transform
