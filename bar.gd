extends CharacterBody2D
#extends Area2D
#var velocity = Vector2()
func start(x, y, speed):
	position = Vector2(x, y)

	#velocity.x = 0
	#velocity.y = -speed

func _ready():
	$CollisionShape2D.position.x = 20
	

var timecount = 0
var maxcount = 10
#var cnt = 0
#@export var Shotcnt = 1.5 #射出間隔
func _process(delta):

	if Input.is_action_pressed(("ui_select")):
		#cnt += delta
		#if cnt > Shotcnt:
			#cnt -= Shotcnt
			
		if timecount <= maxcount:
			timecount = timecount + 1
				
			rotation = -10 *delta*timecount

		else:
			#timecount = 0
			rotation = 0
		#for i in range(18):
			#rotation = -3*i
	if Input.is_action_just_released(("ui_select")):
		rotation = 0
		pass 
