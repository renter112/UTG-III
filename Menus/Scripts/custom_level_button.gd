extends Button

var level_to_load = []
# Called when the node enters the scene tree for the first time.
func _ready():
	print(level_to_load)
	if not level_to_load[3].is_empty():
		add_theme_color_override("font_color",Color(0,1,0))
	pass # Replace with function body.


@onready var name_label = get_node("../../../../MarginContainer/VBoxContainer/NameLabel")
@onready var author_label = get_node("../../../../MarginContainer/VBoxContainer/AuthorLabel")
@onready var beaten_label = get_node("../../../../MarginContainer/VBoxContainer/BeatenLabel")


func _on_pressed():
	Global.current_level = level_to_load
	name_label.text = level_to_load[1]
	author_label.text = level_to_load[4]
	if not level_to_load[3].is_empty():
		beaten_label.text = str("Time: ",level_to_load[3])
	else:
		beaten_label.text = "Not Beaten"
	pass # Replace with function body.
