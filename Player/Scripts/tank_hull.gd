extends CharacterBody2D

@export var speed = 150
@export var rotation_speed = 2.0
signal level_finish()
var rotation_dir = 0
var controls_classic = Global.tank_controls_classic
var mine = preload("res://Items/mine.tscn")
var mine_amount = 0
var side_armour = preload("res://Items/side_armour_upgrade.tscn")

func _ready():
	if Global.upgrade_list.get("side_armor") == 1:
		var s = side_armour.instantiate()
		add_child(s)
func get_input():
	if controls_classic:
		rotation_dir = Input.get_axis("move_left","move_right")
		velocity = transform.x * Input.get_axis("move_down","move_up") * speed
	else:
		var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		velocity = input_direction * speed
	if Input.is_anything_pressed():
		$Sprite2D.play()
	if Input.is_action_pressed("mine") && mine_amount < 4 && $Timer.is_stopped():
		$Timer.start(1)
		var m = mine.instantiate()
		m.position = $MineMarker.global_position
		get_tree().get_root().get_node("/root/level").add_child(m)
		mine_amount += 1

func _physics_process(delta):
	get_input()
	if controls_classic :
		rotation += rotation_dir * rotation_speed * delta
	move_and_slide()

func _process(_delta):
	if visible == false:
		killed()
	pass
	
func killed():
	emit_signal("level_finish")

func mine_boom():
	mine_amount -= 1
