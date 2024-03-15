extends Area2D

var speed = 250

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.x * speed * delta
	if position.x > 2000 || position.x < 0 || position.y < 0 || position.y > 2000:
		queue_free()
	pass


func _on_body_entered(body):
	if body.name == "tank_hull" || body.name == "tank_collision" || body.name == "tank_turret":
		body.visible = false
	queue_free()
	pass # Replace with function body.
