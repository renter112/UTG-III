extends TextureRect

var s1 = preload("res://Items/Assets/gun_1.png")
var s2 = preload("res://Items/Assets/gun_2.png")
var s3 = preload("res://Items/Assets/gun_3.png")

func _ready():
	var speed = Global.upgrade_list.get("gun")
	if speed == 1:
		texture = s1
	elif speed == 2 :
		texture = s2
	elif speed == 3:
		texture = s3
