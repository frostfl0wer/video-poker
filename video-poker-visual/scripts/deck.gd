extends Node2D

var deck_ref : DeckBase
@export var text : String
@export var hide : bool

func _ready() -> void:
	if hide:
		$bg_Sprite2D.visible=false
	
	$Control/Label.text = text

func create(deck : DeckBase):
	deck_ref = deck

func _process(_delta: float) -> void:
	$Control/Label.text = text + "\n(" + str(len(deck_ref.cards)) + ")"
