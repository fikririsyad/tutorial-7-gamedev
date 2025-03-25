extends CharacterBody3D

@export var speed: float = 8.0
@export var acceleration: float = 5.0
@export var gravity: float = 9.8
@export var jump_power: float = 4.0
@export var mouse_sensitivity: float = 0.3

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D

var camera_x_rotation: float = 0.0
var camera_height: float = 0.0
var is_crouching: bool = false
var is_sprinting: bool = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera_height = camera.position.y

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		head.rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		
		var x_delta = event.relative.y * mouse_sensitivity
		camera_x_rotation = clamp(camera_x_rotation + x_delta, -90.0, 90.0)
		camera.rotation_degrees.x = -camera_x_rotation

func _physics_process(delta):
	var movement_vector = Vector3.ZERO

	if Input.is_action_pressed("movement_forward"):
		movement_vector -= head.basis.z
	if Input.is_action_pressed("movement_backward"):
		movement_vector += head.basis.z
	if Input.is_action_pressed("movement_left"):
		movement_vector -= head.basis.x
	if Input.is_action_pressed("movement_right"):
		movement_vector += head.basis.x
		
	movement_vector = movement_vector.normalized()
	
	# Handle crouch
	if Input.is_action_pressed("crouch"):
		if not is_crouching:
			is_crouching = true
			camera.position.y = camera_height - 0.5
	else:
		if is_crouching:
			is_crouching = false
			camera.position.y = camera_height
	
	# Handle sprint
	if Input.is_action_pressed("sprint") and not is_crouching:
		is_sprinting = true
	else:
		is_sprinting = false
	
	# Adjust speed
	var movement_speed = speed
	if is_crouching:
		movement_speed = speed / 2.0
	elif is_sprinting:
		movement_speed = speed * 2.0
	
	velocity.x = lerp(velocity.x, movement_vector.x * movement_speed, acceleration * delta)
	velocity.z = lerp(velocity.z, movement_vector.z * movement_speed, acceleration * delta)

	# Apply gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_power

	move_and_slide()
