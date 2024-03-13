extends Area2D

var speed = 250

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.x * speed * delta
	pass


func _on_body_entered(body):
	if body.name == "tank_hull":
		body.visible = false
	queue_free()
	pass # Replace with function body.
