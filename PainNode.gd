extends GraphNode


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _sort_children():
	custom_minimum_size=Vector2(get_child(0).get_size().x,0)
