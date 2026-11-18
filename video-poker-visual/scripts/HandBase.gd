class_name HandBase

var cards : Array[CardBase]
var value : int#the worth of the hand
var capacity : int

func _init():
	value = -1
	capacity = 5

func add_top_card(deck:DeckBase) -> void:#wow i don't even need a loop for this in godot
	if len(cards)<capacity:
		cards.append(deck.cards[0])
		deck.cards.pop_front()

func move_card_up(selection:int) -> void:
	cards[selection]

func overwrite_card(pos:int, card:CardBase) -> void:
	cards[pos]=card

func organize_ascending():
	for i in range(capacity):#lets see how many times i remember to use capacity instead of just 5
		if i!=0:
			if cards[i].value < cards[i-1].value:
				var hold = cards[i-1]
				cards[i-1]=cards[i]
				cards[i]=hold 
				organize_ascending()#i guess bro

func printout() -> String:
	var val = "This hand contains:\n"
	for each in cards:
		val += each.title + "\n"
	return val


func score():
	organize_ascending()
	value = -1
	
	var same_suit = true
	var increasing_by_one = true
	var suit = cards[0].suit
	var vals = []
	var groups = [false, false, false, false]
	var value_of_pair = -1
	
	for i in range(capacity):
		if cards[i].suit != suit:
			same_suit = false
		if i!=0 and cards[i].value != cards[i-1].value+1:
			increasing_by_one = false
		
		vals.append(cards[i].value+1)
		
		var rep_num = number_of_repetitions(vals, vals[i])
		
		if rep_num == 2 and value_of_pair == -1:
			groups[0]=true
			value_of_pair=vals[i]
		if rep_num == 2 and value_of_pair != vals[i]:
			groups[1]=true
		if rep_num == 3:
			groups[2]=true
			if value_of_pair == vals[i]:
				value_of_pair=-1
				groups[0]=false
			groups[1]=false
		if rep_num==4:
			groups[3]=true
			groups[0]=false
			groups[1]=false
		
	if same_suit:
		if vals == [1, 10, 11, 12, 13]:
			value=250
		elif increasing_by_one:
			value = 50
		else:
			value = 5
	else:
		if groups[3]:
			value=25
		elif groups[0] and groups[2]:
			value=6
		elif increasing_by_one || vals == [1, 10, 11, 12, 13]:
			value=4
		elif groups[2]:
			value = 3
		elif groups[0] and groups[1]:
			value = 2
		elif groups[0]:
			value = 1

func name_of_score() -> String:
	match value:
		-1:
			return "No pair"
		1:
			return "Pair"
		2:
			return "Two pairs"
		3:
			return "Three of a kind"
		4:
			return "Straight"
		5:
			return "Flush"
		6:
			return "Full house"
		25:
			return "Four of a kind"
		50:
			return "Straight flush"
		250:
			return "Royal flush"
	return "Error"

func number_of_repetitions(arr, num):
	var count = 0
	for each in arr:
		if num == each:
			count += 1
	return count

func debug_add_card(card:CardBase):
	cards.append(card)
