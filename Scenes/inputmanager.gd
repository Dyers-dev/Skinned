
extends Node2D

signal left_mouse_button_clicked
signal left_mouse_button_released

const DEAD_CARDS_POSITION = 616.0
const COLLISION_MASK_CARD = 1
const COLLISION_MASK_DECK = 4

var all_cards 
var card_manager_reference
var deck_reference
var last_damage = 20

func _ready() -> void:
	card_manager_reference = $"../CardManager"
	deck_reference = $"../Deck"
	all_cards = $"../Deck".get_deck()


func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			emit_signal("left_mouse_button_clicked")
			raycast_at_cursor()
		else:
			emit_signal("left_mouse_button_released")

func move_dead_card(card_found, card_index):
	var index = $"../Deck".dead_cards.size()
	print("Movendo" , index)
	var new_position = $"../PlayerHand".calculate_dead_position(index)
	$"../Deck".player_deck.erase(card_index)
	$"../PlayerHand".player_hand.erase(card_found)
	$"../PlayerHand".animate_card_to_position(card_found, Vector2(new_position, DEAD_CARDS_POSITION))
	$"../Deck".set_dead_card(card_found)
	$"../Deck".check_reset_room()
	
	
func raycast_at_cursor():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		var result_collision_mask = result[0].collider.collision_mask
		if result_collision_mask == COLLISION_MASK_CARD:
			# Card clicked
			var card_found = result[0].collider.get_parent()
			var card_selected = $"../CardSlot".card_index
			if $"../Deck".dead_cards.has(card_found):
				return
			if card_found && card_found.card_type == "Potion":
				var potion_infos = all_cards[card_found.card_index]
				$"../Deck".restore_health(potion_infos.Heal)
				move_dead_card(card_found, card_found.card_index)
				pass
			if  card_selected == 0:
				if card_found:
					card_manager_reference.start_drag(card_found)
			else:
				if card_found.card_type == "Enemy":
					print("pé na cabeça do ribeiro")
					var enemy_infos = all_cards[card_found.card_index]
					var weapon_infos = all_cards[card_selected]
					if last_damage > enemy_infos.HP && weapon_infos.Damage < enemy_infos.HP:
						$"../Deck".lose_health(enemy_infos.HP - weapon_infos.Damage)
					
					last_damage = enemy_infos.HP
					
						
					move_dead_card(card_found, card_found.card_index)
		#elif result_collision_mask == COLLISION_MASK_DECK:
			
			#Deck clicked
			#deck_reference.draw_card()
		
