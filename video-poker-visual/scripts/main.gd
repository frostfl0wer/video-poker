extends Node2D

var card_ref = preload("res://scenes/card.tscn")
var hand_ref = preload("res://scenes/hand.tscn")

var main_deck : DeckBase = DeckBase.new(true)
var discard_deck : DeckBase = DeckBase.new(false)

var hand : HandBase = HandBase.new()
var cards_in_hand = []
var cards_to_discard = []
var locations_to_discard = []
var card_refs_in_discard_deck = []
var tokens := 20

func _ready() -> void:
	$hand.create(hand)
	$deck.create(main_deck)
	$deck2.create(discard_deck)
	
	$Control2.visible=false

func _process(_delta: float) -> void:
	$Control/Label.text = "Tokens: " + str(tokens)
	
	if tokens >= 50:
		$VideoStreamPlayer.visible=true
	if Input.is_action_just_pressed("debug_key"):
		$Tutorials/Label.text = ""
	match $Tutorials/Label.text:
		"Use the arrow keys to select":
			if Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right"):
				$Tutorials/Label.text = "Press [z] to select discards"
		"Press [z] to select discards":
			if Input.is_action_just_pressed("confirm"):
				$Tutorials/Label.text = "Press down and [z] to confirm discards"
		"Press down and [z] to confirm discards":
			if Input.is_action_just_pressed("down"):
				$Tutorials/Label.text = ""
	
	#this is so unbelievably cursed do not ever write code like this again oh my god
	match Auto.state:#this is not how you normally structure a state machine but for this case it's just supposed to make the game run like a while loop so whatever
		Auto.States.ADD_CARDS:
			for i in range(5):
				var c = card_ref.instantiate()
				c.position = $deck.position
				cards_in_hand.append(c)
				if len(main_deck.cards)>0:
					c.create(main_deck.cards[0], Vector2(-200+100*i, 80))
				else:
					move_discard_deck_over()
					c.create(main_deck.cards[0], Vector2(-200+100*i, 80))
				add_child(c)
				hand.add_top_card(main_deck)
			
			Auto.state = Auto.States.GET_PLAYER_DISCARDS
		
		Auto.States.GET_PLAYER_DISCARDS:
			if Input.is_action_just_pressed("confirm"):
				if cards_in_hand[$hand.selection] not in cards_to_discard:
					cards_to_discard.append(cards_in_hand[$hand.selection])
					cards_in_hand[$hand.selection].move_up()
					locations_to_discard.append($hand.selection)
				else:
					cards_to_discard.pop_at(cards_to_discard.find(cards_in_hand[$hand.selection]))
					cards_in_hand[$hand.selection].move_down()
					locations_to_discard.pop_at(locations_to_discard.find($hand.selection))
			
			if Input.is_action_just_pressed("deny") and cards_in_hand[$hand.selection] in cards_to_discard:
				cards_to_discard.pop_at(cards_to_discard.find(cards_in_hand[$hand.selection]))
				cards_in_hand[$hand.selection].move_down()
				locations_to_discard.pop_at(locations_to_discard.find($hand.selection))
				
			if Input.is_action_just_pressed("down"):
				Auto.state = Auto.States.CONFIRM_PLAYER_DISCARDS
		
		Auto.States.CONFIRM_PLAYER_DISCARDS:
			$confirm_button.modulate=Color.YELLOW
			if Input.is_action_just_pressed("up") || Input.is_action_just_pressed("deny"):
				$confirm_button.modulate=Color.WHITE
				Auto.state = Auto.States.GET_PLAYER_DISCARDS
			if Input.is_action_just_pressed("confirm"):
				Auto.state = Auto.States.DISCARD_AND_REDRAW
		
		Auto.States.DISCARD_AND_REDRAW:
			for i in range(hand.capacity):
				if i in locations_to_discard:
					if len(main_deck.cards)>0:
						discard_deck.cards.append(hand.cards[i])
						hand.overwrite_card(i, main_deck.remove_card(0))
					else:
						move_discard_deck_over()
						discard_deck.cards.append(hand.cards[i])
						hand.overwrite_card(i, main_deck.remove_card(0))
					cards_in_hand[i].move_to_location($deck2.position, 10)
					cards_in_hand[i].face_up=false
					card_refs_in_discard_deck.append(cards_in_hand[i])
			
			#print(hand.cards)
			for i in range(hand.capacity):#sure bro whatever works atp
				if i in locations_to_discard:
					var c = card_ref.instantiate()
					c.position = $deck.position
					cards_in_hand[i]=c
					c.create(hand.cards[i], Vector2(-200+100*i, 80))
					add_child(c)
			locations_to_discard=[]
			cards_to_discard=[]
			Auto.state = Auto.States.SCORE
		
		Auto.States.SCORE:
			$confirm_button.modulate = Color.WHITE
			hand.score()
			display_earning_text()
			$Control/Label.text = "Tokens: " + str(tokens+hand.value)#can't assign this every frame so this is the totally not awful solution to that
			for each in cards_in_hand:
				each.modulate = Color8(150,150,150,255)
			
			if Input.is_action_just_pressed("confirm"):
				stop_displaying_text()
				tokens+=hand.value
				Auto.state = Auto.States.CLEAR_HAND
		
		Auto.States.CLEAR_HAND:
			var done = true
			for i in range(hand.capacity):
				cards_in_hand[i].move_to_location($deck2.position, 10)
				cards_in_hand[i].face_up=false
				cards_in_hand[i].modulate = Color8(255,255,255,255)#okay sure i guess this override works #i love bad practice i love bad practice i love bad practice
				if cards_in_hand[i].position != $deck2.position:
					done=false
			
			if done:
				for i in range(hand.capacity):
					discard_deck.add_card(cards_in_hand[i].card_ref)
					card_refs_in_discard_deck.append(cards_in_hand[i])
				cards_in_hand=[]
				hand.cards=[]
				Auto.state = Auto.States.ADD_CARDS


func move_discard_deck_over():
	print("called!\n\n")
	for each in discard_deck.cards:
		print(each.title)
	discard_deck.add_deck_to(main_deck)
	
	for i in range(len(card_refs_in_discard_deck)):
		card_refs_in_discard_deck[i].target_position = $deck.position
		await get_tree().create_timer(0.1).timeout

func display_earning_text():
	$Control2.visible=true
	$confirm_button/Label.text = hand.name_of_score() + ": " + str(hand.value)
func stop_displaying_text():
	$Control2.visible=false
	$confirm_button/Label.text="Confirm"
