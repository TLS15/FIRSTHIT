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

func _process(delta):
	tick_accumulator += delta
	
	while tick_accumulator >= TICK_TIME:
		tick()
		tick_accumulator -= TICK_TIME

func tick():
	money += calc_revenue()
	population += calc_reproduction()
	$"../LevelManager/UIMaster/UILevel/HBoxContainer/Money".text = "Money: %.0f" % money
	$"../LevelManager/UIMaster/UILevel/HBoxContainer/Population".text = "Population: " + str(population)
	check_win_condition()
	
func calc_revenue() -> float:
	return 10.0 * TICK_TIME
	
func calc_reproduction() -> int:
	var result = 0
	for tower in towers:
		result += tower.occupants
		
	return result - population
	
func load_level(level: LevelResource):
	money = level.starting_money
	population = 0
	towers_assigned = 0

	# Clear towers
	for child in $Towers.get_children():
		child.queue_free()

	towers.clear()
	tower_connections.clear()
	for connection_line in connection_lines:
		connection_line.queue_free()
	connection_lines.clear()

	for tower in level.towers:
		load_tower(tower)

func load_tower(tower: TowerResource):
	var instance = load("res://Components/Scenes/castle.tscn").instantiate()
	$Towers.add_child(instance)
	
	instance.tower_id = towers_assigned
	instance.assign_resource(tower)
	
	instance.press_received.connect(on_tower_press_received)

	towers.append(instance)
	towers_assigned += 1
	population += instance.occupants
		
func on_tower_press_received(id: int):
	#print("print received")

	# Step 1: start connection
	if id_awaiting_connection == -1:
		_start_connection(id)
		return

	# Step 2: prevent self-connection
	if id_awaiting_connection == id:
		_cancel_current_connection()
		return

	# Step 3: finalize connection
	_finalize_connection(id)
	
func _start_connection(id: int):
	id_awaiting_connection = id

	var instance = preload("res://Components/Scenes/Connection_Line.tscn").instantiate() # should center the connection line
	add_child(instance)
	connection_lines.append(instance)
		
func _finalize_connection(target_id: int):
	var origin_id = id_awaiting_connection
	var line = connection_lines.back()
	
	line.dragging = false
	line.id_origin = origin_id
	line.id_target = target_id

	var connected_towers_array: Array = tower_connections.get_or_add(origin_id, [])

	if connected_towers_array.has(target_id):
		_remove_connection(origin_id, target_id)
		_cancel_current_connection()
	else:
		_add_connection(origin_id, target_id)
		if towers[origin_id].available_connections < 0:
			_remove_connection(origin_id, target_id)
		

	id_awaiting_connection = -1
	
func _add_connection(origin_id: int, target_id: int):
	towers[origin_id].available_connections -= 1
	tower_connections[origin_id].append(target_id)
	
func _remove_connection(origin_id: int, target_id: int):
	tower_connections[origin_id].erase(target_id)
	towers[origin_id].available_connections += 1

	for i in connection_lines.size():
		var line = connection_lines[i]
		if line.id_origin == origin_id and line.id_target == target_id:
			line.queue_free()
			connection_lines.remove_at(i)
			break

func _cancel_current_connection():
	if connection_lines.size() > 0:
		var last = connection_lines.pop_back()
		last.queue_free()

	id_awaiting_connection = -1
	
func check_win_condition() -> bool:
	# Conquered all towers
	var fulfilled = true
	for tower in towers:
		if tower.affiliation  != TowerResource.Players.BLUE:
			fulfilled = false
	#print(fulfilled)
	# Reached Money Goal (!TODO)
	
	return fulfilled
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			cancel_action()

func cancel_action():
	print("cancel action")
	# Cancel Line connection
	if id_awaiting_connection != -1:
		connection_lines[-1].queue_free()
		connection_lines.remove_at(-1)
		id_awaiting_connection = -1


func _on_timer_timeout() -> void:
	for tower in towers:
		for target_id in tower_connections.get_or_add(tower.tower_id, []):
			tower.spawn_unit(towers[target_id].position)
