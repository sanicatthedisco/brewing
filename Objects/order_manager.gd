extends Node2D

@export var serving_mat: ServingMat
@export var character_scenes: Array[PackedScene]
@export var glass: IngredientContainer

var character: Character
var char_idx := 0
var character_spawn_pos := Vector2(-130, -20)

func _ready():
	serving_mat.item_served.connect(_serve_order)
	_spawn_active_character()

func _enable_orders():
	serving_mat.active = true

func _serve_order(item: IngredientContainer):
	character.recieve_order(item)

func _on_order_complete():
	_remove_active_character()
	char_idx += 1
	_spawn_active_character()

func _clear_drink():
	serving_mat.clear_item()

func _spawn_active_character():
	character = character_scenes[char_idx].instantiate()
	add_child(character)
	character.position = character_spawn_pos
	
	character.ready_for_order.connect(_enable_orders)
	character.order_complete.connect(_on_order_complete)
	character.took_drink.connect(_clear_drink)

func _remove_active_character():
	character.ready_for_order.disconnect(_enable_orders)
	character.order_complete.disconnect(_on_order_complete)
	character.took_drink.disconnect(_clear_drink)
	character.queue_free()
