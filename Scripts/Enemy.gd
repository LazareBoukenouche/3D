extends CharacterBody3D


const SPEED = 5.0
var pos: Vector2 = Vector2(50,50)
var go_left: bool = true
var go_right: bool = false



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	
func _process(delta):
	
	rotate(Vector3(0,10,0).normalized(),2.0 * delta)
		
	pass
	
			
