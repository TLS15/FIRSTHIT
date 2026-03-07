extends Node2D

@export var money: float = 0
@export var population: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func  _process(delta: float) -> void:
	money += calc_revenue()
	$"../UIMaster/UILevel/HBoxContainer/Money".text = "Money: %.0f" % money
	print(money)
	
	
func calc_revenue() -> float:
	return 1.0 / 60.0 # assuming  60 ticks per second
	
func load_level(level: LevelResource):
	money = level.starting_money
	
	for tower in level.towers:
		var instance = load("res://Scenes/castle.tscn").instantiate()
		add_child(instance)
		instance.assign_resource(tower)
		population += instance.occupants
