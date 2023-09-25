extends CharacterBody3D

signal can_interact

signal can_not_interact



const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var hold_object: bool = false

var mouse_sensitivity := 0.010
var horizontal_pivot_input := 0.0
var vertical_pivot_input := 0.0

@onready var player = get_node(".")
@onready var horizontal_pivot = $Horizontal_pivot
@onready var vertical_pivot = $Horizontal_pivot/Vertical_pivot
@onready var camera = $Horizontal_pivot/Vertical_pivot/Camera3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)	

		
func _physics_process(delta):
	
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_up", "move_down")
	
	var camera_input := Vector3.ZERO
	camera_input.x = Input.get_axis("move_camera_left", "move_camera_right")
	camera_input.z = Input.get_axis("move_camera_up", "move_camera_down")
	horizontal_pivot.rotate_y(horizontal_pivot_input)
	vertical_pivot.rotate_x(vertical_pivot_input)
	vertical_pivot.rotation.x = clamp(vertical_pivot.rotation.x, 
		deg_to_rad(-30), 
		deg_to_rad(30)
	)
#
	horizontal_pivot_input = 0.0
	vertical_pivot_input = 0.0
	vertical_pivot.rotation.x = clamp(vertical_pivot.rotation.x, 
	deg_to_rad(-30), 
	deg_to_rad(30)
)
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	
		
	if Input.is_action_just_pressed("take"):
		# Check if object in area has the property : interactable
		# make the object a child of self
		var interactables = Array()
		
		for elem in get_node("Area3D").get_overlapping_bodies():
			if "interactable" in elem:
				interactables.append(elem)
			
		if interactables.size() > 0:
			if interactables.size() == 1:
				interactables[0].reparent(self)	
			elif interactables.size() > 1:
				var selected_node = null
				var shortest_distance = -1
				for elem in interactables:
					if elem.position.distance_to(self.position) < shortest_distance or shortest_distance == -1:
						selected_node = elem
				selected_node.reparent(self)
		
	if move_and_slide():
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			if collision.get_collider().name == "Sword":
				pass
				
	if not is_on_floor():
		velocity.y -= gravity * delta
		

	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		$AnimationPlayer.play("Jump_Start")
		if $AnimationPlayer.is_playing():
			velocity.y = JUMP_VELOCITY
		
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = (horizontal_pivot.basis * input).normalized()
#
	if direction:
		
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		$AnimationPlayer.play('Walking_B')

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		

	move_and_slide()
	
func _unhandled_input(event: InputEvent) -> void:
	
	if event is InputEventJoypadMotion:
		
		var direction = Input.get_vector("move_camera_left", "move_camera_right", "move_camera_up", "move_camera_down")
		
#		if event.get_axis() == JOY_AXIS_RIGHT_Y:
		if direction != Vector2.ZERO:
			
			var vertical_joypad_axis_value = Input.get_axis("move_camera_up", "move_camera_down")
			vertical_pivot_input -= vertical_joypad_axis_value * 0.1
			var horizontal_joypad_axis_value =Input.get_axis("move_camera_left", "move_camera_right")
			horizontal_pivot_input -= horizontal_joypad_axis_value * 0.1
#
		
			
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if event is InputEventMouseMotion:
			if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
				horizontal_pivot_input = - event.relative.x * mouse_sensitivity
				vertical_pivot_input = - event.relative.y * mouse_sensitivity
				
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
				
func _input(_event):
	if Input.is_action_just_pressed("attack"):
		$AnimationPlayer.play("1H_Melee_Attack_Chop")
		
		
func _on_area_3d_body_entered(body):
	
	if body == get_node("."):
		return
	if "interactable" in body:
		if body.interactable == true:
			
			get_node("Label3D").set_text(body.to_string()) 
			get_node("Label3D").visible = true
		
func _on_area_3d_body_exited(body):
	if "interactable" in body:
		pass
	for elem in get_node("Area3D").get_overlapping_bodies():
		if "interactable" in elem:
			if elem.interactable == true:
				return 
	get_node("Label3D").set_text(body.to_string()) 
	get_node("Label3D").visible = false
	

