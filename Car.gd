extends KinematicBody2D



puppet var puppet_vel = Vector2()
puppet var puppet_rot = 0
puppet var puppet_pos = Vector2()


var wheel_base = 20  # Distance from front to rear wheel
var steering_angle = 50 # Amount that front wheel turns, in degrees
var velocity = Vector2.ZERO
var steer_angle

var engine_power = 200 # Forward acceleration force.
var friction = -0.9 
var drag = -0.0015 

var braking = -70
var max_speed_reverse = 500

var slip_speed = 200  # Speed where traction is reduced
var traction_fast = 0.1  # High-speed traction
var traction_slow = 0.7  # Low-speed traction



var acceleration = Vector2.ZERO

func _ready():
	if is_network_master():
		$Camera2D.current = true
	else:
		$Camera2D.current = false
	puppet_rot = rotation
	puppet_pos = position
func _physics_process(delta):
	if is_network_master():
		acceleration = Vector2.ZERO
		get_input()
		apply_friction()
		calculate_steering(delta)
		rset("puppet_rot", rotation)
		velocity += acceleration * delta
		rset("puppet_vel", velocity)
		
	else:
		rotation = puppet_rot
		velocity= puppet_vel
		
	velocity = move_and_slide(velocity)
	if is_network_master():
		rset("puppet_pos", position)
	else:
		position = puppet_pos
		
		
	
	
	
func get_input():
	var turn = 0
	if Input.is_action_pressed("move_right"):
		turn += 1
	if Input.is_action_pressed("move_left"):
		turn -= 1
	steer_angle = turn * deg2rad(steering_angle)
	if Input.is_action_pressed("move_up"):
		acceleration = transform.x * engine_power
	
	if Input.is_action_pressed("move_down"):
		acceleration = transform.x * braking
		
func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_angle) * delta
	var new_heading = (front_wheel - rear_wheel).normalized()
	
	var traction = traction_slow
	if velocity.length() > slip_speed:
		traction = traction_fast
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = velocity.linear_interpolate(new_heading * velocity.length(), traction)
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	rotation = new_heading.angle()
	
func apply_friction():
	#if velocity.length() < 5:
	#	velocity = Vector2.ZERO

	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag
	if velocity.length() < 100:
		friction_force *= 3
	acceleration += drag_force + friction_force
