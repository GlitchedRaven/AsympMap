extends RigidBody2D
	
onready var vel = Vector2()
var accel = 0.5
var FRICTION = 0.01

onready var coll = false
onready var facingDir = Vector2(cos(self.transform.get_rotation()), sin(self.transform.get_rotation())) 

func _physics_process(delta):
	facingDir = Vector2(cos(self.transform.get_rotation()), sin(self.transform.get_rotation())) 
	#vel = Vector2()
	
	# inputs
	if Input.is_action_pressed("move_up"):
		 self.apply_impulse(facingDir,Vector2(0,1) *accel)
		 vel += facingDir+Vector2(0,1) *accel
		
	if Input.is_action_pressed("move_down"):
		self.apply_impulse(facingDir, Vector2(0,-1) *accel)
		vel += facingDir+Vector2(0,-1) *accel
		
	if Input.is_action_pressed("move_left"):
		self.apply_torque_impulse(2*PI)

		
	if Input.is_action_pressed("move_right"):
		self.apply_torque_impulse(-2*PI )

func _process(delta):
	update()
func draw_force(origin, vec):
	draw_line(origin, origin+Vector2(0.01,0), Color.red)
	

func _draw():
	draw_force(self.transform.origin,vel)
