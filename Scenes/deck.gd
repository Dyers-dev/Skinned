extends Node2D

const CARD_SCENE_PATH = "res://Scenes/Card.tscn"
const DRAW_SPEED = 0.28
const INITIAL_ROOM_SIZE = 4
const ALL_CARDS = [
	#{name = "Joker", type = "Special"},
	{name = "HeartsJ", type = "Potion", Heal = 12},
	{name = "Hearts5", type = "Potion", Heal = 5},
	{name = "Diamonds5", type = "Weapon", Damage = 5},
	{name = "Diamonds5", type = "Weapon", Damage = 5},
	{name = "Diamonds5", type = "Weapon", Damage = 5},
	{name = "Clubs8", type = "Enemy", HP = 8},
	{name = "Clubs8", type = "Enemy", HP = 8},
	{name = "Clubs8", type = "Enemy", HP = 8},
	{name = "Spades2", type = "Enemy",  HP = 2},
	{name = "Spades2", type = "Enemy",  HP = 2},
	{name = "Spades2", type = "Enemy",  HP = 2},
	{name = "SpadesQ", type = "Enemy", HP = 12},
	{name = "SpadesQ", type = "Enemy", HP = 12},
] 

var player_deck = []
var viewed_cards = []
var dead_cards = []
var table_cards = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$DeckCount.text = str(player_deck.size())
	randomize_cards()
	draw_room()
	pass # Replace with function body.
	

func randomize_cards():
	var avaliables = []
	for i in range(ALL_CARDS.size()):
		if not viewed_cards.has(i):
			avaliables.append(i)
			
	avaliables.shuffle()
	
	while player_deck.size() < INITIAL_ROOM_SIZE:
		var card_index = avaliables.pop_front()
		player_deck.append(card_index)
		viewed_cards.append(card_index)
		
	

func draw_room():
	for i in range(player_deck.size()):
		var selected_card = player_deck[i]
		print(viewed_cards)
		var card_infos = ALL_CARDS[selected_card]
		print(selected_card)
		if not table_cards.has(selected_card):
			table_cards.append(selected_card)
			var card_scene = preload(CARD_SCENE_PATH)
			var new_card = card_scene.instantiate()

			$"../CardManager".add_child(new_card)

			new_card.name = card_infos.name
			new_card.card_type = card_infos.type
			new_card.card_index = selected_card
			new_card.get_node(card_infos.name).visible = true
			$"../PlayerHand".add_card_to_hand(new_card, DRAW_SPEED) 

	
func get_deck():
	return ALL_CARDS
	
var total_health_points = 20

func restore_health(amount):
	total_health_points += amount
	if total_health_points > 20:
		total_health_points = 20
	$"../Health Points".get_node("HP").text=str(total_health_points)
		
func lose_health(amount):
	total_health_points -= amount
	if total_health_points < 0:
		total_health_points = 0
	$"../Health Points".get_node("HP").text=str(total_health_points)
	
func set_dead_card(name):
	dead_cards.append(name)
	
func clear_dead_cards():
	for i in range(dead_cards.size()-1, -1, -1):
		dead_cards[i].queue_free()
		dead_cards.remove_at(i)


func check_reset_room():
	if player_deck.size() == 1:
		clear_dead_cards()
		randomize_cards()
		draw_room()
