extends Node2D
var level_manager_instance
var levels_archive

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_select_level_index_pressed(index: int) -> void:
	load_level_at_path("res://Data/LevelData", index)


func load_level_at_path(path: String, index: int):
	levels_archive = path
	var level: LevelResource = load(levels_archive + "/Level" + str(index + 1) + ".tres")
	level_manager_instance = load("res://Components/Scenes/level_manager.tscn").instantiate()
	add_child(level_manager_instance)
	level_manager_instance.load_level(level)
	$UIMaster/MainMenu/VBoxContainer.hide()
	$UIMaster/MainMenu/MainMenu.show()
	$UIMaster/NextLevel.show()


func _on_level_maker_pressed() -> void:
	#load_level_at_path("res://Data/TestLevels/", 0)
	level_manager_instance = load("res://Components/LevelMaker/level_tester.tscn").instantiate()
	add_child(level_manager_instance)
	$UIMaster/MainMenu/VBoxContainer.hide()
	$UIMaster/MainMenu/MainMenu.show()


func back_to_mainmenu():
	level_manager_instance.queue_free()
	$UIMaster/MainMenu/VBoxContainer.show()
	$UIMaster/MainMenu/MainMenu.hide()
	$UIMaster/NextLevel.hide()


func _on_tutorial_pressed() -> void:
	load_level_at_path("res://Data/TutorialLevels", 0)


func _on_next_level_pressed() -> void:
	var levels_available: int = ResourceLoader.list_directory(levels_archive).size()

	var index: int = level_manager_instance.level_index 
	if levels_available - 1 <= index:
		index = levels_available - 2
	back_to_mainmenu()
	load_level_at_path(levels_archive, index + 1)
