extends Area2D

# 状態
enum eState {
	IDLE,
	RUN, # 走る
	JUMP, # ジャンプ
	RUNLfet,
	RUNRight,
	run_up,
	run_down,
	run_upLeft,
	run_downLeft	
}
var state = eState.IDLE
var is_left = false # 左を向いているかどうか
var is_up = false # 左を向いているかどうか

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


var weponExe:bool

func _ready():
	position = Vector2(180,400)
	$"../StaticBody2D".position = Vector2(180,400)
	$"../StaticBody2D2".position = Vector2(180,400)
	$"../StaticBody2D3".position = Vector2(180,400)
	$"../StaticBody2D4".position = Vector2(180,400)			
	pass

func _process(delta):

	#----------プレイヤー--------------------
	moveZero = 0 #0の場合固定される。
	MovePlayer(delta)

	MoveArea()

	$"../StaticBody2D".position = position
	$"../StaticBody2D2".position =  position
	$"../StaticBody2D3".position =  position
	$"../StaticBody2D4".position = position		

	#-----------特定のアクション---------------
	#if Input.is_action_pressed(("ui_select")):
	#if state == eState.IDLE:
	weponExe = true
	if weponExe == true:
		#await get_tree().create_timer(1).timeout
		AddBall(delta)
		await get_tree().create_timer(1).timeout
		AddBar(delta)
		await get_tree().create_timer(1).timeout
		#MoveDash(delta)

		pary(delta)
	#--------------スプライト----------------
	# アニメーションタイマー更新
	anim_time += delta
	# スプライトフレームを設定
	$Sprite2D.frame = _get_anim_frame()
	$Sprite2D.flip_h = is_left # 反転する
	$Sprite2D.flip_v = is_up # 反転する
	match state:
		eState.RUNLfet:
			$Sprite2D.rotation = 90*3.14/180

		eState.RUNRight:
			$Sprite2D.rotation = 90*3.14/180
		_:
			$Sprite2D.rotation =0

#plyaerの移動について
var velocity = Vector2.ZERO
var moveZero:float #0の場合には動かない
func MovePlayer(delta):

	upFlag = false
	downFlag = false
	leftFlag = false
	rightFlag = false
	
	MoveTran(delta) #並進移動の実施

	MoveRotate(delta)

	#playerの位置データ
	CommonPlayer.player_X = position.x
	CommonPlayer.player_Y = position.y
	CommonPlayer.player_R = rotation
		
	position += velocity.normalized() * speed * moveZero #動作の程度

var stopTime:float = 0.5
var moveD:float = 0
func MoveTran(delta):
	#移動
	moveD += delta
	if moveD > stopTime:
		velocity.x = 0
		velocity.y = 0
		moveD = 0 #初期化
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1*delta # moveup
		state = eState.run_up
		is_up = false

	if Input.is_action_pressed("ui_down"):
		velocity.y += 1*delta # movedown
		state = eState.run_down
		is_up = true
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1*delta # moveleft
		state = eState.RUNLfet
		is_left = false
		is_up = false
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1*delta # moveright	
		state = eState.RUNRight
		#is_left = true
		is_up = true
	#state = eState.IDLE
#回転の制御
var delayTime:float = 0.0
func MoveRotate(delta):
	print(rotation)
	var priR:float = rotation1
	#await get_tree().create_timer(1).timeout
	#回転
	if Input.is_action_pressed("ui_up"):
		rotation1 = 0
		#await get_tree().create_timer(delayTime).timeout
		rotation = 0*3.14/180
		upFlag = true
		
		#var Drotate = rotation1*3.14/180 - priR 
		
		
	if Input.is_action_pressed("ui_down"):
		rotation1 = 180
		#await get_tree().create_timer(delayTime).timeout
		rotation = 180*3.14/180
		downFlag = true
	if Input.is_action_pressed("ui_left"):
		rotation1 = 270
		#await get_tree().create_timer(delayTime).timeout
		rotation = 270*3.14/180
		leftFlag = true
	if Input.is_action_pressed("ui_right"):
		rotation1 = 90
		#await get_tree().create_timer(delayTime).timeout
		rotation = 90*3.14/180
		rightFlag = true

	#斜め移動時の角度
	if upFlag == true && rightFlag == true:
		rotation1 = 45
		#await get_tree().create_timer(delayTime).timeout
		rotation = 45*3.14/180
	if downFlag == true && rightFlag == true:
		rotation1 = 135
		#await get_tree().create_timer(delayTime).timeout
		rotation = 135*3.14/180
	if downFlag == true && leftFlag == true:
		rotation1 = 225
		#await get_tree().create_timer(delayTime).timeout
		rotation = 225*3.14/180
	if upFlag == true && leftFlag == true:
		rotation1 = 315
		#await get_tree().create_timer(delayTime).timeout
		rotation = 315*3.14/180

#移動範囲
func MoveArea():
	#画面内にとどめる
	if position.x < Window_X:
		position.x = Window_X
	if position.x > Window_W:
		position.x = Window_W
	if position.y < Window_Y:
		position.y = Window_Y
	if position.y > Window_H:
		position.y = Window_H

#アニメーションの追加
var anim_time = 0
#アニメーション速度
var animeSpeed:float = 0.5
# 現在の状態に対するアニメーションフレーム番号を取得する	
func _get_anim_frame() -> int:
	#print(state)
	match state:
		eState.RUNLfet:
			var t = int(anim_time * animeSpeed*8) % 2
			if t == 0:
				t = 1
			else:
				t = 0
			return 0 + t
		eState.RUNRight:
			var t = int(anim_time * animeSpeed*8) % 2
			if t == 0:
				t = 1
			else:
				t = 0
			return 0 + t
		eState.IDLE:
			var t = int(anim_time * animeSpeed*8) % 2
			if t == 0:
				t = 2
			else:
				t = 3
			return 0 + t	
		eState.run_up:
			var t = int(anim_time * animeSpeed*10) % 2
			if t == 0:
				t = 4
			else:
				t = 5
			return 0 + t			
		eState.run_down:
			var t = int(anim_time * animeSpeed*10) % 2
			if t == 0:
				t = 2
			else:
				t = 3
			return 0 + t
		eState.run_upLeft:
			var t = int(anim_time * animeSpeed*10) % 2
			if t == 0:
				t = 10
			else:
				t = 11
			return 0 + t			

		eState.run_downLeft:
			var t = int(anim_time * animeSpeed*10) % 2
			if t == 0:
				t = 12
			else:
				t = 13
			return 0 + t			
			
		eState.JUMP:
			var t = int(anim_time * animeSpeed*20) % 2
			if t == 0:
				t = 6
			elif t == 2:
				t = 7
			elif t == 2:
				t = 8
			else:
				t = 9
			return 0 + t
		_:
			return 2



#ボールを出現
@export var speed = 5
@export var Shotcnt = 0.5 #射出間隔
@export var ShotSpeed = 1000 #速度
var cnt = 0
const Ball = preload("res://ball.tscn") #ballシーンのプリロード

func AddBall(delta):
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

#棒を出現させる
@export var Barcnt = 0.5 #射出間隔
var cnt2 = 0
const bar = preload("res://bar.tscn") #ballシーンのプリロード
var barcount:int = 0

func AddBar(delta):
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

#ダッシュ
var cnt3 = 0
var Dashcnt:float = 0.5
func MoveDash(delta):
	#方向ダッシュ
		cnt3 += delta
		if cnt3 > Dashcnt:
			cnt3 -= Dashcnt	
				#await get_tree().create_timer(1).timeout
			position.x = position.x + sin(rotation)*50
			position.y = position.y - cos(rotation)*50
		

#パリィ
func pary(delta):
	#方向入力して、しばらくは無敵になる、もしくは打ち消す
	#感知用のstaticbodyを使って、判定受け入れ開始。
	#その後、方向入力があった場合に無敵または削除を行う。
	
	pass
