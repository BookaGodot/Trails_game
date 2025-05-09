extends Resource
class_name ShopItem

@export var id : String
@export var name : String
@export_enum("BASIC", "RARE", "UNIQUE", "FAVORITE") var type : String = "BASIC"
@export var icon : Texture2D
@export var price : int
@export_multiline var description : String
