extends Node3D

var MENU = preload("res://Menus/Scenes/Menu.tscn")
var menu = MENU.instantiate()

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().change_scene_to_packed(MENU)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
		
