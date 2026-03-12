extends Node2D

const TICK_TIME := 1.0 / 5.0
var tick_accumulator := 0.0
var towers_assigned: int = 0
var id_awaiting_connection = -1
var tower_connections := {}
var connection_lines = []
var towers = []

@export var money: float = 0
@export var population: int
@export var level: LevelResource

func _ready() -> void:
	load_level(level)

func _process(delta):
	tick_accumulator += delta
	
	while tick_accumulator >= TICK_TIME:
		tick()
		tick_accumulator -= TICK_TIME

func tick():
	money += calc_revenue()
	population += calc_reproduction()
	$"UIMaster/UILevel/HBoxContainer/Money".text = "Money: %.0f" % money
	$"UIMaster/UILevel/HBoxContainer/Population".text = "Population: " + str(population)
	check_win_condition()
	
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
		instance.tower_id = towers_assigned
		towers_assigned += 1
		instance.press_received.connect(on_tower_press_received)
		towers.append(instance)
		population += instance.occupants
		
func on_tower_press_received(id: int):
	print("print received")
	if id_awaiting_connection == -1:
		id_awaiting_connection = id
		var instance = load("res://Scenes/Connection_Line.tscn").instantiate()
		add_child(instance)
		connection_lines.append(instance)
		
	else:
		connection_lines[-1].dragging = false
		var tower_key_value = tower_connections.get_or_add(id_awaiting_connection, [])
		if tower_key_value.has(id):
			tower_key_value.erase(id)
		else:
			tower_key_value.append(id)
		id_awaiting_connection = -1
		
func check_win_condition() -> bool:
	# Conquered all towers
	var fulfilled = true
	for tower in towers:
		if tower.affiliation  != TowerResource.Players.BLUE:
			fulfilled = false
	print(fulfilled)
	
	return fulfilled
