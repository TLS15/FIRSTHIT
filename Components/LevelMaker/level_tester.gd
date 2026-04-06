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
	$LevelManager.load_level(level)
	$LevelManager.process_mode=Node.PROCESS_MODE_INHERIT


#func _process(delta):
	## Debug mouse position
	#$UIMaster/UILevel/MousePosition.text = "Mouse Position: x: %.0f y: %.0f" % [
		#get_global_mouse_position().x,
		#get_global_mouse_position().y
	#]
#
	#tick_accumulator += delta
	#
	#while tick_accumulator >= TICK_TIME:
		#tick()
		#tick_accumulator -= TICK_TIME
#
#
#func tick():
	#money += calc_revenue()
	#population += calc_reproduction()
#
	#$UIMaster/UILevel/HBoxContainer/Money.text = "Money: %.0f" % money
	#$UIMaster/UILevel/HBoxContainer/Population.text = "Population: %d" % population
#
	#check_win_condition()
#
#
#func calc_revenue() -> float:
	#return 10.0 * TICK_TIME
#
#
#func calc_reproduction() -> int:
	#var result = 0
	#for tower in towers:
		#result += tower.occupants
	#return result - population
#
#
## ========================
## LEVEL LOADING
## ========================
#
#func load_level(level: LevelResource):
	#money = level.starting_money
	#population = 0
	#towers_assigned = 0
#
	## Clear towers
	#for child in $Towers.get_children():
		#child.queue_free()
#
	#towers.clear()
	#tower_connections.clear()
	#connection_lines.clear()
#
	#for tower in level.towers:
		#load_tower(tower)
#
#
#func load_tower(tower: TowerResource):
	#var instance = load("res://Components/Scenes/castle.tscn").instantiate()
	#$Towers.add_child(instance)
	#
	#instance.tower_id = towers_assigned
	#instance.assign_resource(tower)
	#
	#instance.press_received.connect(on_tower_press_received)
#
	#towers.append(instance)
	#towers_assigned += 1
	#population += instance.occupants
#
#
## ========================
## CONNECTION SYSTEM (FULL)
## ========================
#
#func on_tower_press_received(id: int):
	##print("press received")
#
	## Step 1: start connection
	#if id_awaiting_connection == -1:
		#_start_connection(id)
		#return
#
	## Step 2: prevent self-connection
	#if id_awaiting_connection == id:
		#_cancel_current_connection()
		#return
#
	## Step 3: finalize
	#_finalize_connection(id)
#
#
#func _start_connection(id: int):
	#id_awaiting_connection = id
#
	#var instance = preload("res://Components/Scenes/Connection_Line.tscn").instantiate()
	#add_child(instance)
	#connection_lines.append(instance)
#
#
#func _finalize_connection(target_id: int):
	#var origin_id = id_awaiting_connection
	#var line = connection_lines.back()
#
	#line.dragging = false
	#line.id_origin = origin_id
	#line.id_target = target_id
#
	#var connected: Array = tower_connections.get_or_add(origin_id, [])
#
	#if connected.has(target_id):
		#_remove_connection(origin_id, target_id)
		#_cancel_current_connection()
	#else:
		#_add_connection(origin_id, target_id)
#
		#if towers[origin_id].available_connections < 0:
			#_remove_connection(origin_id, target_id)
#
	#id_awaiting_connection = -1
#
#
#func _add_connection(origin_id: int, target_id: int):
	#towers[origin_id].available_connections -= 1
	#tower_connections[origin_id].append(target_id)
#
#
#func _remove_connection(origin_id: int, target_id: int):
	#tower_connections[origin_id].erase(target_id)
	#towers[origin_id].available_connections += 1
#
	#for i in connection_lines.size():
		#var line = connection_lines[i]
		#if line.id_origin == origin_id and line.id_target == target_id:
			#line.queue_free()
			#connection_lines.remove_at(i)
			#break
#
#
#func _cancel_current_connection():
	#if connection_lines.size() > 0:
		#var last = connection_lines.pop_back()
		#last.queue_free()
#
	#id_awaiting_connection = -1
#
#
## ========================
## INPUT
## ========================
#
#func _input(event):
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			#cancel_action()
#
#
#func cancel_action():
	#print("cancel action")
#
	#if id_awaiting_connection != -1:
		#_cancel_current_connection()
#
#
## ========================
## GAME LOOP EVENTS
## ========================
#
#func _on_timer_timeout() -> void:
	#for tower in towers:
		#for target_id in tower_connections.get_or_add(tower.tower_id, []):
			#tower.spawn_unit(towers[target_id].position)
#
#
## ========================
## WIN CONDITION
## ========================
#
#func check_win_condition() -> bool:
	#var fulfilled = true
#
	#for tower in towers:
		#if tower.affiliation != TowerResource.Players.BLUE:
			#fulfilled = false
#
	#return fulfilled


# ========================
# EDITOR / UI FUNCTIONS
# ========================


func _on_add_tower_tower_configured(towerData: TowerResource) -> void:
	towerData.resource_local_to_scene = true
	level.towers.append(towerData) 
	$LevelManager.load_tower(towerData)


func _on_save_level_pressed() -> void:
	$UIMaster/SaveLevel/SaveFolderSelection.show()
	


func _on_quit_pressed() -> void:
	get_tree().quit()


func reload_level() -> void:
	$LevelManager.load_level(level)


func _on_load_custom_level_pressed() -> void:
	$UIMaster/LoadLevel/FileDialog.show()


func _on_file_dialog_file_selected(path: String) -> void:
	level = load(path)
	$LevelManager.load_level(level)


func _on_save_folder_selection_file_selected(path: String) -> void:
	level.starting_money = $UIMaster/SaveLevel/StartingMoney.value
	ResourceSaver.save(level, path)


func reset_tower_index():
	$LevelManager.towers_assigned = towers.size()
	var i = 0
	for tower in towers:
		tower.tower_id = i
		i += 1


func _on_remove_tower_area_entered(area: Area2D) -> void:
	print("remove tower")
	for i in range($LevelManager.towers.size()):
		if $LevelManager.towers[i].tower_id == area.tower_id:
			$LevelManager.towers.remove_at(i)
			level.towers.remove_at(i)
			reset_tower_index()
			break
	
	
	area.queue_free()


func _on_create_terrain_pressed() -> void:
	$UIMaster.hide()
	$StopTerrain.show()
	$CatchInput.mouse_filter = Control.MouseFilter.MOUSE_FILTER_STOP


func _on_stop_terrain_pressed() -> void:
	$UIMaster.show()
	$StopTerrain.hide()
	$CatchInput.mouse_filter = Control.MouseFilter.MOUSE_FILTER_IGNORE


func _on_catch_input_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		$LevelManager.holding_mouse_button = true
		#$LevelManager.create_obstacle(get_global_mouse_position())
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and !event.is_pressed():
		$LevelManager.holding_mouse_button = false
