extends CharacterBody3D
## This class handle the player character infos and inputs, as well as 
## the animations

signal can_interact
signal can_not_interact

const SPEED = 5.0
const CAMERA_SPEED = 0.05
const JUMP_VELOCITY = 4.5

var hold_object: bool = false
var mouse_sensitivity := 0.010

@onready var player = get_node(".")
@onready var spatial = get_node("Spatial")
@onready var player_direction := Vector3.ZERO
@onready var player_rotation = spatial.get_rotation()
@onready var player_is_rotated := false
@onready var look_at_direction_player = Vector3.ZERO
@onready var player_rot_x = 0.0
@onready var player_rot_y = 0.0

@onready var camera_pivot = $SpringArm3D
@onready var camera_direction := Vector3.ZERO
@onready var camera_rotation = camera_pivot.get_rotation()
@onready var camera_is_rotated := false
@onready var look_at_direction_camera := Vector3.ZERO
@onready var camera_rot_x = 0.0
@onready var camera_rot_y = 0.0


@onready var animation_tree = $AnimationTree
@onready var state_machine = $AnimationTree.get("parameters/playback")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

## this function hide the mouse from the screen when the game start
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

## loop every frame and update the game accordingly
func _physics_process(delta):
	
	velocity.y -= gravity * delta
	camera_pivot.rotation.z = 0
	camera_pivot.transform.basis = Basis()
	camera_pivot.rotate_object_local(Vector3(0, 1, 0), camera_rot_x) # first rotate in Y
	camera_pivot.rotate_object_local(Vector3(1, 0, 0), camera_rot_y) # then rotate in X
	
	if camera_direction:
		camera_rot_x += camera_direction.x * CAMERA_SPEED
		camera_rot_y += camera_direction.y * CAMERA_SPEED
		
	elif camera_direction and  player_direction:
		pass
		
	elif player_direction:
		velocity.z = player_direction.y * SPEED
		velocity.x = player_direction.x * SPEED	
		player_rot_x = player_direction.x * CAMERA_SPEED
		player_rot_y = player_direction.y * CAMERA_SPEED
		look_at_direction_player = Vector3(player_rot_x,0,player_rot_y)
		spatial.look_at(spatial.global_transform.origin + look_at_direction_player.normalized(), Vector3.UP) 
	else:
		velocity.z = 0.0
		velocity.x = 0.0

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	update_animation_parameters()
	move_and_slide()
	
## handle the player inputs
func _unhandled_input(event: InputEvent) -> void:
	
	
	if event is InputEventJoypadMotion:
		var dir_velocity = Input.get_vector("move_left","move_right","move_forward","move_backward",0.6)
		var camera_dir_velocity = Input.get_vector("move_camera_left","move_camera_right","move_camera_up","move_camera_down",0.6)
		camera_dir_velocity.normalized()
		camera_direction.y = camera_dir_velocity.y
		camera_direction.x = camera_dir_velocity.x
		dir_velocity.normalized()
		player_direction.y = dir_velocity.y
		player_direction.x = dir_velocity.x

	if event is InputEventJoypadButton:
		# press R3 to recenter camera behind player
		if event.is_action_pressed("recentre_camera"):
			pass
			
	# Quit game when pressing Triangle
	if event.is_action_pressed("cancel"):
		get_tree().quit()


func update_animation_parameters():
	if is_on_floor():
		animation_tree.set("parameters/conditions/grounded", true)

	animation_tree.set("parameters/IWR/blend_position",player_direction)
	
func _on_animation_tree_animation_started():
	print("Debut :",state_machine.get_current_node())
	
func _on_animation_tree_animation_finished():
	print("Fin :",state_machine.get_current_node())
	
	
#func _on_area_3d_body_entered(body):
#
#	if body == get_node("."):
#		return
#	if "interactable" in body:
#		if body.interactable == true:
#
#			get_node("Label3D").set_text(body.to_string()) 
#			get_node("Label3D").visible = true
#
#func _on_area_3d_body_exited(body):
#	if "interactable" in body:
#		pass
#	for elem in get_node("Area3D").get_overlapping_bodies():
#		if "interactable" in elem:
#			if elem.interactable == true:
#				return 
#	get_node("Label3D").set_text(body.to_string()) 
#	get_node("Label3D").visible = false
#
