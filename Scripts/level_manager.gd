extends Node2D

const TICK_TIME := 1.0 / 5.0
var tick_accumulator := 0.0

@export var money: float = 0
@export var population: int

func _process(delta):
	tick_accumulator += delta
	
	while tick_accumulator >= TICK_TIME:
		tick()
		tick_accumulator -= TICK_TIME

func tick():
	money += calc_revenue()
	population += calc_reproduction()
	$"../UIMaster/UILevel/HBoxContainer/Money".text = "Money: %.0f" % money
	$"../UIMaster/UILevel/HBoxContainer/Population".text = "Population: " + str(population)
	
func calc_revenue() -> float:
	return 10.0 * TICK_TIME
	
func calc_reproduction() -> int:
	return 1
	
func load_level(level: LevelResource):
	money = level.starting_money
	
	for tower in level.towers:
		var instance = load("res://Scenes/castle.tscn").instantiate()
		add_child(instance)
		instance.assign_resource(tower)
		population += instance.occupants
