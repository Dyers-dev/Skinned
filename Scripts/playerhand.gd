extends Node2D

const CARD_WIDTH = 150
const HAND_Y_POSITION = 350

var player_hand = []
var center_screen_x

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	center_screen_x = get_viewport().size.x / 2
	


func add_card_to_hand(card, speed = 0.1):
	if card not in player_hand:
		player_hand.insert(0, card)
		update_hand_positions()
	else:
		update_hand_positions(speed)
		#animate_card_to_position(card, card.position)


func update_hand_positions(speed = 0.1):
	for i in range(player_hand.size()):
		# Get new card position based on index
		var new_position = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		var card = player_hand[i]
		#print(self.position.x, self.position.y)
		#card.position = self.position
		animate_card_to_position(card, new_position, speed)
		
		


func calculate_card_position(index):
	var total_width = (player_hand.size() -1) * CARD_WIDTH
	var x_offset = center_screen_x + index * CARD_WIDTH - total_width / 2
	return x_offset
	
func calculate_dead_position(index):
	var total_width = (4) * CARD_WIDTH 
	var x_offset = center_screen_x + index * CARD_WIDTH - (total_width / 2.0) + 310
	return x_offset


func animate_card_to_position(card, new_position, speed = 0.1):
	var tween = get_tree().create_tween()
	var draw_speed = speed
	tween.tween_property(card, "position", new_position, draw_speed)
	

func remove_card_from_hand(card):
	if card in player_hand:
		player_hand.erase(card)
		update_hand_positions()
