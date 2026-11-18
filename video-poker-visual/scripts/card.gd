extends Node2D#this script will just handle the visuals i guess?

var suit : int#spade, heart, diamond, clove
var value : int
var face_up : bool = true

var card_ref : CardBase
var MAIN_REF = preload("res://scenes/main.tscn")
var target_position : Vector2
var speed = 20

func create(card:CardBase, target_pos:Vector2) -> void:
	card_ref = card
	suit = card.suit
	value = card.value
	target_position = target_pos

func _process(delta: float) -> void:
	if face_up:
		var suit_chars = ["s", "h", "d", "c"]
		$card_Sprite2D.play(suit_chars[suit] + "_" + str(value+1))
	else:
		$card_Sprite2D.play("face_down")
	position = position.move_toward(target_position, speed)#because that's good practice

func move_to_location(loc, spd):
	speed=spd
	target_position = loc
func move_up():
	speed=4
	target_position = Vector2(position.x, 60)
func move_down():
	speed=4
	target_position = Vector2(position.x, 80)
