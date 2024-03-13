extends Area2D

var velocity = Vector2()

const Window_X = 32  
const Window_Y = 32  
const Window_W = 800 -32
const Window_H = 720 -32 

#時間で弾が消える場合
var delBallTime:float = 0.2
var ballTime:float = 0
func _physics_process(delta):
	if isInScreen(self) == false:

		queue_free() #out
	ballTime += delta
	if delBallTime < ballTime:
		print(ballTime)
		queue_free()
		ballTime = 0

	position += velocity * delta

func isInScreen(ball):
	# out
	if ball.position.x < Window_X:
		return false
	if ball.position.y < Window_Y:
		return false
	if ball.position.x > Window_W:
		return false
	if ball.position.y > Window_H:
		return false
	
	return true #in
	

func start(x, y, speed,r):
	position = Vector2(x, y)
	velocity.x = speed*sin(r*3.14/180)
	velocity.y = -speed*cos(r*3.14/180)
	#print(r)
	#print(sin(r),cos(r))


#func _on_area_entered(area):
	#if area is Enemy or area is Boss:
		#area.hit(1) # 敵に1ダメージ
		#queue_free()		
	#pass # Replace with function body.
