extends AnimationTree



# Called when the node enters the scene tree for the first time.
func _ready():
	var animation_tree = $AnimationTree
	var state_machine = animation_tree.get("parameters/playback")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
