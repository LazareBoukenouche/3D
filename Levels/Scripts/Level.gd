extends Node3D

var start_menu = preload("res://Menus/Scenes/StartMenu.tscn")


var instance = start_menu.instantiate()
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_gui_input(event):
	if event is InputEventJoypadButton:
		if event.button_index == JOY_BUTTON_START and event.pressed:
			
			get_node(".").reparent(start_menu.instantiate())


	


