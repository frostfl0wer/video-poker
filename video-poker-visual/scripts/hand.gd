extends Node2D

var selection : int = 0
var hand_size := 5#just assume this because i'm a lazy chuddd
var hand_ref : HandBase
var cards_to_discard : Array[CardBase]

func _process(_delta: float) -> void:
	if Auto.state == Auto.States.GET_PLAYER_DISCARDS:
		if Input.is_action_just_pressed("left"):
			selection-=1
		if Input.is_action_just_pressed("right"):
			selection+=1
		if selection >= hand_size:
			selection=0
		if selection < 0: 
			selection = hand_size-1
		
		$AnimatedSprite2D.modulate=Color8(255,255,255,255)
	else:
		$AnimatedSprite2D.modulate=Color8(255,255,255,100)
	if Auto.state == Auto.States.CLEAR_HAND:
		selection=0
	$AnimatedSprite2D.position = $AnimatedSprite2D.position.move_toward(Vector2(-200+100*selection, 80), abs(-200+100*selection - $AnimatedSprite2D.position.x)/5+1+abs(80 - $AnimatedSprite2D.position.y)/5)

func create(hand : HandBase):#i love tight coupling
	hand_ref = hand#if i was smart this would not be how i would do this but extends is too complicated for me atm i dont have time to learn
