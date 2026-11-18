class_name CardBase

var suit : int
var value : int
var title:String

func _init(s:int, v:int) -> void:
	suit = s
	value = v
	
	var names = ["Ace", "2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King"]
	var suits = ["Spades", "Hearts", "Diamonds", "Clubs"]
	title = names[v] + " of " + suits[suit]
