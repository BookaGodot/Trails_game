extends Control

@export var shop_items: Array[ShopItem] = []
@export var shop_item_instance : PackedScene

@onready var food_grid: GridContainer = %food_grid


func _ready() -> void:
	add_items()


func add_items():
	for item in shop_items:
		var item_instance = shop_item_instance.instantiate()
		food_grid.add_child(item_instance)
		item_instance.set_item(item)
		#item_instance.selected.connect(on_item_selected.bind(item))


#func on_item_selected(set_item : ShopItem):
	##show_window()
	##set_info(set_item)
