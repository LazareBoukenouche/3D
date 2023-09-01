extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var hold_object: bool = false

signal can_interact

signal can_not_interact

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
		
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
func _process(_delta):
	
	
	if Input.is_action_just_pressed("attack"):
		print("attack")
		
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
			
	
	
	

func _input(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if event is InputEventMouseMotion:
#			get_node("Camera_pivot").rotation
			
			
			if event.relative[0] < -2:
				get_node("Camera_pivot").rotation.y += 0.1
			if event.relative[0] > 2:
				get_node("Camera_pivot").rotation.y -= 0.1
			if event.relative[1] > 2:
				get_node("Camera_pivot").rotation.x -= 0.1
			if event.relative[1] < -2:
				get_node("Camera_pivot").rotation.x += 0.1

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
	
