extends Node

enum States {ADD_CARDS, GET_PLAYER_DISCARDS, CONFIRM_PLAYER_DISCARDS, DISCARD_AND_REDRAW, SCORE, CLEAR_HAND}
var state = States.ADD_CARDS

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
