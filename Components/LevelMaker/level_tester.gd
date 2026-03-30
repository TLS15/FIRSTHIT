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
	$UIMaster/UILevel/MousePosition.text = "Mouse Position: x: %.0f " % get_global_mouse_position()[0] + "y: %.0f" % get_global_mouse_position()[1]
	tick_accumulator += delta
	
	while tick_accumulator >= TICK_TIME:
		tick()
		tick_accumulator -= TICK_TIME

func tick():
	money += calc_revenue()
	population += calc_reproduction()
	$"UIMaster/UILevel/HBoxContainer/Money".text = "Money: %.0f" % money
	$"UIMaster/UILevel/HBoxContainer/Population".text = "Population: " + str(population)
	#check_win_condition()

	
func calc_revenue() -> float:
	return 10.0 * TICK_TIME
	
func calc_reproduction() -> int:
	return 1
	
func load_level(level: LevelResource):
	
	money = level.starting_money
	
	for child in $Towers.get_children():
		child.queue_free()
	population = 0
	for tower in level.towers:
		load_tower(tower)
		
func load_tower(tower: TowerResource):
		var instance = load("res://Components/Scenes/castle.tscn").instantiate()
		$Towers.add_child(instance)
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
		var instance = load("res://Components/Scenes/Connection_Line.tscn").instantiate()
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


func _on_editor_state_changed() -> void:
	request_ready()


func _on_property_list_changed() -> void:
	request_ready()


func _on_add_tower_tower_configured(towerData: TowerResource) -> void:
	level.towers.append(towerData)
	load_tower(towerData)
	


func _on_save_level_pressed() -> void: # Cant save to res
	level.starting_money = $UIMaster/SaveLevel/StartingMoney.value
	ResourceSaver.save(level, "res://Data/LevelData/Level1.tres")


func _on_quit_pressed() -> void:
	get_tree().quit()


func reload_level() -> void:
	load_level(level)


func _on_load_custom_level_pressed() -> void:
	$UIMaster/LoadLevel/FileDialog.show()


func _on_file_dialog_file_selected(path: String) -> void:
	level = load(path)
	load_level(level)
	
