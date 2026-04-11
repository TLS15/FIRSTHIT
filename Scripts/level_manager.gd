extends Node2D

const TICK_TIME := 1.0 / 5.0
var tick_accumulator := 0.0
var id_awaiting_connection = -1
var level_index: int

var tower_connecting = null


var preview_line

var holding_left_mouse_button = false
var holding_right_mouse_button = false

@export var money: float = 0
@export var population: int

func _process(delta):
	if holding_left_mouse_button:
		create_obstacle(get_global_mouse_position())
	if holding_right_mouse_button: 
		delete_obstacle(get_global_mouse_position())
	tick_accumulator += delta
	
	while tick_accumulator >= TICK_TIME:
		tick()
		tick_accumulator -= TICK_TIME

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			cancel_action()

func tick():
	money += calc_revenue()
	population += calc_reproduction()
	$"./UILevel/HBoxContainer/Money".text = "Money: %.0f" % money
	$"./UILevel/HBoxContainer/Population".text = "Population: " + str(population)
	
func calc_revenue() -> float:
	return 10.0 * TICK_TIME

func calc_reproduction() -> int:
	var result = 0
		
	return result - population
	
func load_level(level: LevelResource):
	level_index = level.level_index
	money = level.starting_money
	population = 0

	$TileMapLayer.tile_map_data = level.terrain_data
	# Clear towers
	for child in $Towers.get_children():
		child.queue_free()

	
	for line in $ConnectionLines.get_children():
		line.queue_free()
	

	for tower in level.towers:
		load_tower(tower)

func load_tower(tower: TowerResource):
	var instance = load("res://Components/Scenes/castle.tscn").instantiate()
	$Towers.add_child(instance)
	
	instance.tower_id = $Towers.get_children().size() - 1
	instance.assign_resource(tower)
	
	instance.press_received.connect(on_tower_press_received)

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
	
	# Begin connection, create preview line
	if tower_connecting == null and tower.affiliation == TowerResource.Players.BLUE:
		tower_connecting = tower
		create_preview_line(tower_connecting)
		return
	
	#  create or destroy permenant connection, or destroy preview line
	if tower_connecting != null and tower_connecting != tower:
		preview_line.queue_free()
		if tower_connecting.connections.has(tower):
			remove_connection(tower_connecting, tower) # destroy permenant connection
		elif (tower_connecting.get_available_connections() < 1) or (line_is_colliding(tower, tower_connecting)): # Destroy preview line
			cancel_action()
		else:
			add_connection(tower_connecting, tower) # add permenant connection
		tower_connecting = null

func add_connection(origin, target):
	var line = preload("res://Components/Scenes/Connection_Line.tscn").instantiate()

	line.origin = origin
	line.target = target
	line.dragging = false
	
	$ConnectionLines.add_child(line)

	origin.connections.append(target)

func remove_connection(origin, target):
	for line in $ConnectionLines.get_children():
		if line.origin == origin and line.target == target:
			line.queue_free()
	
	origin.connections.erase(target)

func cancel_action():
	print("cancel action")
	# Cancel Line connection
	if tower_connecting != null:
		preview_line.queue_free()
		tower_connecting = null

func get_tower_through_id(id: int):
	for tower in $Towers.get_children():
		if tower.tower_id == id:
			return tower

func check_win_condition() -> bool:
	# Conquered all towers
	var fulfilled = true
	for tower in $Towers.get_children():
		if tower.affiliation  != TowerResource.Players.BLUE:
			fulfilled = false
	print(fulfilled)
	# Reached Money Goal (!TODO)
	if fulfilled:
		$GameOverWindow.show()
		
	return fulfilled

func create_obstacle(coords: Vector2i):
	$TileMapLayer.set_cell($TileMapLayer.local_to_map(coords) ,0,Vector2i(1,1))

func delete_obstacle(coords: Vector2i):
	$TileMapLayer.erase_cell($TileMapLayer.local_to_map(coords))
