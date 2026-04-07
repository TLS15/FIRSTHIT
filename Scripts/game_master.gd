extends Node2D
var level_manager_instance
var levels_archive

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_select_level_index_pressed(index: int) -> void:
	levels_archive = "res://Data/LevelData"
	var level: LevelResource = load(levels_archive + "/Level" + str(index + 1) + ".tres")
	level_manager_instance = load("res://Components/Scenes/level_manager.tscn").instantiate()
	add_child(level_manager_instance)
	level_manager_instance.load_level(level)
	$UIMaster/MainMenu/VBoxContainer.hide()
	$UIMaster/MainMenu/MainMenu.show()
	$UIMaster/NextLevel.show()


func _on_level_maker_pressed() -> void:
	level_manager_instance = load("res://Components/LevelMaker/level_tester.tscn").instantiate()
	add_child(level_manager_instance)
	$UIMaster/MainMenu/VBoxContainer.hide()
	$UIMaster/MainMenu/MainMenu.show()

func back_to_mainmenu():
	$UIMaster/MainMenu/VBoxContainer.show()
	$UIMaster/MainMenu/MainMenu.hide()
	$UIMaster/NextLevel.hide()
	level_manager_instance.queue_free()


func _on_tutorial_pressed() -> void:
	levels_archive = "res://Data/TutorialLevels"
	_on_select_level_index_pressed(0)


func _on_next_level_pressed() -> void:
	var levels_available: int = ResourceLoader.list_directory(levels_archive).size()

	var index: int = level_manager_instance.level_index 
	if levels_available - 1 <= index:
		index = levels_available - 2
	back_to_mainmenu()
	_on_select_level_index_pressed(index + 1)
