extends CharacterBody3D

@export var MOVE_SPEED: float = 5.0
@export var SLIDE_SPEED: float = .01

const JUMP_VELOCITY: float = 4.5

@export var POWER: float = 0

@onready var power_display: HBoxContainer = get_tree().root.get_child(0).find_child("DebugUI").find_child("VBoxContainer").find_child("PowerDisplay")
@onready var velocity_display: HBoxContainer = get_tree().root.get_child(0).find_child("DebugUI").find_child("VBoxContainer").find_child("VelocityDisplay")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	## TRADITIONAL MOVEMENT
	#regular_movement()
	#rotate_movement(delta)
	
	## POWER SLIDE MOVEMENT
	power_movement(delta)
	#power_movement_zero_velocity(delta)
	
	display_labels()
	

func display_labels():
	power_display.find_child("PowerUpdate").text = str(POWER)
	velocity_display.find_child("VelocityUpdate").text = str(velocity)

func regular_movement():
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * MOVE_SPEED
		velocity.z = direction.z * MOVE_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SLIDE_SPEED)
		velocity.z = move_toward(velocity.z, 0, SLIDE_SPEED)

	move_and_slide()

func rotate_movement(delta):
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(0, 0, input_dir.y)).normalized()
	
	player_rotation(delta)
	
	if direction:
		velocity.x = direction.x * MOVE_SPEED
		velocity.z = direction.z * MOVE_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SLIDE_SPEED)
		velocity.z = move_toward(velocity.z, 0, SLIDE_SPEED)

	move_and_slide()

func power_movement(delta):
	#var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction: Vector3 = Vector3.ZERO
	 
	if Input.is_action_pressed("ui_accept"):
		POWER += 5 * delta
		POWER = clamp(POWER, 0, 100)
		
	if Input.is_action_just_released("ui_accept"):
		direction = (transform.basis * Vector3(0, 0, -1)).normalized()
		
	player_rotation(delta)
	
	if direction:
		velocity.x += direction.x * POWER
		velocity.z += direction.z * POWER
		POWER = 0
	else:
		velocity.x = move_toward(velocity.x, 0, SLIDE_SPEED)
		velocity.z = move_toward(velocity.z, 0, SLIDE_SPEED)
	
	
	move_and_slide()

func power_movement_zero_velocity(delta):
	var direction = Vector3.ZERO
	 
	if Input.is_action_pressed("ui_accept"):
		POWER += 5 * delta
		POWER = clamp(POWER, 0, 100)
		
	if Input.is_action_just_released("ui_accept") and velocity.is_equal_approx(Vector3.ZERO):
		direction = (transform.basis * Vector3(0, 0, -1)).normalized()
		
	player_rotation(delta)
	
	if direction:
		velocity.x += direction.x * POWER
		velocity.z += direction.z * POWER
		POWER = 0
	else:
		velocity.x = move_toward(velocity.x, 0, SLIDE_SPEED * 10)
		velocity.z = move_toward(velocity.z, 0, SLIDE_SPEED * 10)
	
	
	move_and_slide()

func player_rotation(delta):
	if Input.is_action_pressed("ui_right"):
		rotation.y -= 2 * delta
	if Input.is_action_pressed("ui_left"):
		rotation.y += 2 * delta
