extends Control

const level = preload("res://Scenes/Levels/Level.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var _button = get_node("Button")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	pass




func _on_button_pressed():
	get_tree().change_scene_to_packed(level)
