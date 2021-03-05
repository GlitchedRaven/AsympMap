extends KinematicBody2D
	
onready var vel = Vector2()
var accel = 0.1
var FRICTION = 0.01

onready var coll = false
onready var facingDir = Vector2()
	
func _physics_process(delta):
	facingDir = Vector2(cos(self.transform.get_rotation() + PI/2), sin(self.transform.get_rotation()+ PI/2))
	#vel = Vector2()
	
	# inputs
	if Input.is_action_pressed("move_up"):
		vel += 1 * facingDir *accel

		
	if Input.is_action_pressed("move_down"):
		vel += -1 *  facingDir*accel

		
	if Input.is_action_pressed("move_left"):
		if vel.length_squared()>0:
			self.rotate(-vel.length()*delta)
		

		
	if Input.is_action_pressed("move_right"):
		if vel.length_squared()>0:
			self.rotate(vel.length()*delta)


	vel -= vel * FRICTION
	#vel = vel.normalized()
	
	# move the player
	coll = move_and_collide(vel)
	if coll:
		vel = Vector2()
