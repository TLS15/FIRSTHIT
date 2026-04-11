extends Node2D


var id_awaiting_connection = -1


@export var money: float = 0
@export var population: int
@export var level: LevelResource


func _ready() -> void:
	$LevelManager.load_level(level)
	$LevelManager.process_mode=Node.PROCESS_MODE_INHERIT
	$LevelManager/AI.process_mode = Node.PROCESS_MODE_DISABLED


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
	level.terrain_data = $LevelManager/TileMapLayer.tile_map_data
	ResourceSaver.save(level, path + ".tres")


func _on_remove_tower_area_entered(area: Area2D) -> void:
	print("remove tower")

	level.towers.erase(area.tower_data)
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
		$LevelManager.holding_left_mouse_button = true
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and !event.is_pressed():
		$LevelManager.holding_left_mouse_button = false
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
		$LevelManager.holding_right_mouse_button = true
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and !event.is_pressed():
		$LevelManager.holding_right_mouse_button = false


func _on_toggle_ai_pressed() -> void:
	if $LevelManager/AI.process_mode == Node.PROCESS_MODE_INHERIT:
		$LevelManager/AI.process_mode = Node.PROCESS_MODE_DISABLED
	else:
		$LevelManager/AI.process_mode = Node.PROCESS_MODE_INHERIT
