extends Control


const level2 = preload("res://Levels/Scenes/Level2.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	var _start = $Container/Start
	
	var _quit = $Container/Quit
	
	_start.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	pass




func _on_button_pressed():
	get_tree().change_scene_to_packed(level2)
	

	
	




func _on_start_gui_input(event):
	if event is InputEventJoypadButton:
		if event.button_index == JOY_BUTTON_A and event.pressed:
			get_tree().change_scene_to_packed(level2)


func _on_quit_gui_input(event):
	if event is InputEventJoypadButton:
		if event.button_index == JOY_BUTTON_A and event.pressed:
			get_tree().quit()
	
