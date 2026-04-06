extends Node2D

const TICK_TIME := 1.0 / 5.0
var tick_accumulator := 0.0
var towers_assigned: int = 0
var id_awaiting_connection = -1

var tower_connecting = null

var connection_lines = []
var towers = []
var preview_line

var holding_mouse_button = false

@export var money: float = 0
@export var population: int

func _process(delta):
	if holding_mouse_button:
		create_obstacle(get_global_mouse_position())
	tick_accumulator += delta
	
	while tick_accumulator >= TICK_TIME:
		tick()
		tick_accumulator -= TICK_TIME

func tick():
	money += calc_revenue()
	population += calc_reproduction()
	$"./UILevel/HBoxContainer/Money".text = "Money: %.0f" % money
	$"./UILevel/HBoxContainer/Population".text = "Population: " + str(population)
	
func calc_revenue() -> float:
	return 10.0 * TICK_TIME
	
func calc_reproduction() -> int:
	var result = 0
	for tower in towers:
		result += tower.health
		
	return result - population
	
func load_level(level: LevelResource):
	money = level.starting_money
	population = 0
	towers_assigned = 0

	# Clear towers
	for child in $Towers.get_children():
		child.queue_free()

	towers.clear()
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
	population += instance.health

func create_preview_line(origin):
	var line = preload("res://Components/Scenes/Connection_Line.tscn").instantiate()
	
	line.origin = origin

	add_child(line)
	
	preview_line = line

func line_is_colliding(origin, target):
	$RayCast2D.position = origin.position
	$RayCast2D.target_position = target.position - origin.position
	$RayCast2D.clear_exceptions()
	$RayCast2D.add_exception(origin)
	$RayCast2D.add_exception(target)
	$RayCast2D.force_raycast_update()
	return $RayCast2D.is_colliding()

func on_tower_press_received(tower):
	# results: create preview line, destroy preview, create permenant connection, remove permenant connection, do nothing 
	
	# If it isn't blue return
	if (tower.affiliation != TowerResource.Players.BLUE and tower_connecting == null) or (tower_connecting == tower):
		return
	
	# Begin connection
	if tower_connecting == null and tower.affiliation == TowerResource.Players.BLUE:
		tower_connecting = tower
		create_preview_line(tower_connecting)
		return
	
	# Either create or destroy permenant connection
	if tower_connecting != null and tower_connecting != tower:
		preview_line.queue_free()
		if tower_connecting.connections.has(tower):
			remove_connection(tower_connecting, tower)
		elif (tower_connecting.get_available_connections() < 1):
			cancel_action()
		else:

			if line_is_colliding(tower, tower_connecting):
				cancel_action()
			else:
				add_connection(tower_connecting, tower)
		tower_connecting = null

func add_connection(origin, target):
	var line = preload("res://Components/Scenes/Connection_Line.tscn").instantiate()

	line.origin = origin
	line.target = target
	line.dragging = false
	connection_lines.append(line)
	add_child(line)

	origin.connections.append(target)

func remove_connection(origin, target):
	for line in connection_lines:
		if line.origin == origin and line.target == target:
			connection_lines.erase(line)
			line.queue_free()
	
	origin.connections.erase(target)

#func _start_connection(id: int):
	#id_awaiting_connection = id
#
	#var instance = preload("res://Components/Scenes/Connection_Line.tscn").instantiate() # should center the connection line
	#add_child(instance)
	#preview_line = instance
	#instance.set_point_position(0, get_tower_through_id(id).position)
		#
#func _finalize_connection(target_id: int):
	#var origin_id = id_awaiting_connection
	#var line = preview_line
	#
	#line.dragging = false
	#line.id_origin = origin_id
	#line.id_target = target_id
	#
	#line.set_point_position(1, get_tower_through_id(target_id).position)
	#connection_lines.append(preview_line) # This might interfere with the ai connection through data races
	#var connected_towers_array: Array = tower_connections.get_or_add(origin_id, [])
#
	#if connected_towers_array.has(target_id):
		#_remove_connection(origin_id, target_id)
		#_cancel_current_connection()
	#else:
		#_add_connection(origin_id, target_id)
		#if towers[origin_id].available_connections < 0:
			#_remove_connection(origin_id, target_id)
		#
#
	#id_awaiting_connection = -1
	#
#func _add_connection(origin_id: int, target_id: int):
	#towers[origin_id].available_connections -= 1
	#tower_connections[origin_id].append(target_id)
	#towers[origin_id].connections.append(get_tower_through_id(target_id))	
#
#
##func ai_add_connection(origin_id: int, target_id: int):
	##var instance = preload("res://Components/Scenes/Connection_Line.tscn").instantiate() # should center the connection line
	##add_child(instance)
	##connection_lines.append(instance)
	##instance.set_point_position(0, get_tower_through_id(origin_id).position)
	##
	##var line = connection_lines.back()
	##
	##line.dragging = false
	##line.id_origin = origin_id
	##line.id_target = target_id
	##
	##line.set_point_position(1, get_tower_through_id(target_id).position)
	##
	##towers[origin_id].available_connections -= 1
	##tower_connections.get_or_add(origin_id, [])
	##tower_connections[origin_id].append(target_id)
	##towers[origin_id].connections.append(get_tower_through_id(target_id))
#
##func _remove_connection(origin_id: int, target_id: int):
	##towers[origin_id].available_connections += 1
	##tower_connections[origin_id].erase(target_id)
	##towers[origin_id].connections.erase(get_tower_through_id(target_id))
	##
	##for i in connection_lines.size():
		##var line = connection_lines[i]
		##if line.id_origin == origin_id and line.id_target == target_id:
			##line.queue_free()
			##connection_lines.remove_at(i)
			##break
##
##func _cancel_current_connection():
	##if connection_lines.size() > 0:
		##var last = connection_lines.pop_back()
		##last.queue_free()
	##
	##id_awaiting_connection = -1
	##

func cancel_action():
	print("cancel action")
	# Cancel Line connection
	if tower_connecting != null:
		preview_line.queue_free()
		tower_connecting = null

func get_tower_through_id(id: int):
	for tower in towers:
		if tower.tower_id == id:
			return tower

func check_win_condition() -> bool:
	# Conquered all towers
	var fulfilled = true
	for tower in towers:
		if tower.affiliation  != TowerResource.Players.BLUE:
			fulfilled = false
	print(fulfilled)
	# Reached Money Goal (!TODO)
	if fulfilled:
		$GameOverWindow.show()
		
	return fulfilled
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			cancel_action()

func create_obstacle(coords: Vector2i):
	$TileMapLayer.set_cell($TileMapLayer.local_to_map(coords) ,0,Vector2i(1,1))
