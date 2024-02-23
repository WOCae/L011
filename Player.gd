extends Area2D

@export var speed = 5
@export var Shotcnt = 0.5 #射出間隔
@export var ShotSpeed = 1000 #速度
var cnt = 0
const Ball = preload("res://ball.tscn") #ballシーンのプリロード

#棒を出現させる
@export var Barcnt = 0.5 #射出間隔
var cnt2 = 0
const bar = preload("res://bar.tscn") #ballシーンのプリロード
var barcount:int = 0

#ウィンドウ範囲の指定
const Window_X = 32  
const Window_Y = 32  
const Window_W = 800 -32
const Window_H = 720 -32 

#playerの方向を8方向に
var upFlag:bool = false
var downFlag:bool = false
var leftFlag:bool = false
var rightFlag:bool = false

var rotation1:float

#ダッシュ
var cnt3 = 0
var Dashcnt:float = 0.5


func _ready():
	position = Vector2(180,400)

func _process(delta):

	var velocity = Vector2.ZERO
	upFlag = false
	downFlag = false
	leftFlag = false
	rightFlag = false
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1*delta # moveup
		rotation1 = 0
		rotation = 0*3.14/180
		upFlag = true
		#downFlag = false
		#leftFlag = false
		#rightFlag = false
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1*delta # movedown
		rotation1 = 180
		rotation = 180*3.14/180
		downFlag = true
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1*delta # moveleft
		rotation1 = 270
		rotation = 270*3.14/180
		leftFlag = true
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1*delta # moveright
		rotation1 = 90
		rotation = 90*3.14/180
		rightFlag = true

	if upFlag == true && rightFlag == true:
		rotation1 = 45
		rotation = 45*3.14/180
	if downFlag == true && rightFlag == true:
		rotation1 = 135
		rotation = 135*3.14/180
	if downFlag == true && leftFlag == true:
		rotation1 = 225
		rotation = 225*3.14/180
	if upFlag == true && leftFlag == true:
		rotation1 = 315
		rotation = 315*3.14/180
		
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
	
	#playerの位置データ
	CommonPlayer.player_X = position.x
	CommonPlayer.player_Y = position.y
	CommonPlayer.player_R = rotation
	

	if Input.is_action_pressed(("ui_select")):
		
	#ballを作成する　スペースを押すとボールが作成されます。		
		cnt += delta
		if cnt > Shotcnt:
			cnt -= Shotcnt
		
			# ball 
			var Ball = Ball.instantiate()
			Ball.position = position
			
			# ballの位置と速度,角度
			Ball.start(position.x, position.y, ShotSpeed,rotation1)
			
			#ルートにインスタンスを追加
			var mainNode = get_owner()
			mainNode.add_child(Ball)
			
	#バーの作成		
		cnt2 += delta
		if cnt2 > Barcnt:
			cnt2 -= Barcnt
			# bar 
			if barcount == 0:
				for i in range(1):
					var bar = bar.instantiate()
					barcount = 1
					bar.position.x = position.x + sin(rotation)*i*10
					bar.position.y = position.y + cos(rotation)*i*10
					
					# ballの位置と速度
					#bar.start(position.x+10, position.y, ShotSpeed)
					
					#ルートにインスタンスを追加
					var mainNode2 = get_owner()
					mainNode2.add_child(bar)
					
					await get_tree().create_timer(0.5).timeout
					bar.queue_free()
					barcount = 0

	#方向ダッシュ
		cnt3 += delta
		if cnt3 > Dashcnt:
			cnt3 -= Dashcnt	
				#await get_tree().create_timer(1).timeout
			position.x = position.x + sin(rotation)*50
			position.y = position.y - cos(rotation)*50
		
