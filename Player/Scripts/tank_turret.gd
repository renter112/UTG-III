extends Area2D

var bullet = preload("res://Items/bullet.tscn")
var bullet_delay = 0.5
var b_timer = bullet_delay
var bullet_speed = 250
# Called when the node enters the scene tree for the first time.

func _ready():
	pass # Replace with function body.


func _process(_delta):
	b_timer = b_timer - _delta
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("shoot") && b_timer < 0:
		shoot()
		b_timer = bullet_delay
	pass

func shoot():
	print(bullet_delay)
	$AudioStreamPlayer2D.play()
	Global.shots_taken += 1
	var b = bullet.instantiate()
	b.speed = bullet_speed
	get_tree().get_root().get_node("/root/level").add_child(b)
	b.transform = $Marker2D.global_transform
