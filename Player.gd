extends Area2D

@export var speed = 5
@export var Shotcnt = 0.5 #射出間隔
@export var ShotSpeed = 1000 #速度
var cnt = 0
const Ball = preload("res://ball.tscn") #ballシーンのプリロード

#ウィンドウ範囲の指定
const Window_X = 32  
const Window_Y = 32  
const Window_W = 360 -32
const Window_H = 720 -32 

func _process(delta):

	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1 # moveup
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1 # movedown
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1 # moveleft
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1 # moveright

	position += velocity.normalized() * speed
	
	#画面内にとどめる
	if position.x < Window_X:
		position.x = Window_X
	if position.x > Window_W:
		position.x = Window_W
	if position.y < Window_Y:
		position.y = Window_Y
	if position.y > Window_H:
		position.y = Window_H
	
	#ballを作成する　スペースを押すとボールが作成されます。
	if Input.is_action_pressed(("ui_select")):
		cnt += delta
		if cnt > Shotcnt:
			cnt -= Shotcnt
		
			# ball 
			var Ball = Ball.instantiate()
			Ball.position = position
			
			# ballの位置と速度
			Ball.start(position.x, position.y, ShotSpeed)
			
			#ルートにインスタンスを追加
			var mainNode = get_owner()
			mainNode.add_child(Ball)
