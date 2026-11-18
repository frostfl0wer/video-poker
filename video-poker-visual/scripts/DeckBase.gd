class_name DeckBase

var cards : Array[CardBase]

func _init(full:bool) -> void:
	if full:
		for suit in 4:
			for value in 13:
				cards.append(CardBase.new(suit,value))
		shuffle()

func remove_card(pos:int) -> CardBase:
	return cards.pop_at(pos)

func add_card(card:CardBase):
	cards.append(card)

func shuffle():
	var shuffled_cards : Array[CardBase]
	while len(cards) > 0:
		shuffled_cards.append(cards.pop_at(randi_range(0,len(cards)-1)))
	cards=shuffled_cards

func add_deck_to(other:DeckBase):
	for each in cards:
		other.cards.append(cards[cards.find(each)])
	cards=[]
	other.shuffle()

func printout() -> String:
	var val = "This deck contains:\n"
	for each in cards:
		val += each.title + "\n"
	return val
