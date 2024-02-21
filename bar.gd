extends Area2D

var velocity = Vector2()
func start(x, y, speed):
	position = Vector2(x, y)

	#velocity.x = 0
	#velocity.y = -speed

func _ready():
	$CollisionShape2D.position.x = 20
	

var timecount = 0
var maxcount = 10

func _process(delta):
	
	if timecount <= maxcount:
		timecount = timecount + 1
			
		rotation = -10*delta*timecount
