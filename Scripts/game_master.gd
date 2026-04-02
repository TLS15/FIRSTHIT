extends Node2D
var node_instance

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_select_level_index_pressed(index: int) -> void:
	var level: LevelResource = load("res://Data/LevelData/Level" + str(index + 1) + ".tres")
	node_instance = load("res://Components/Scenes/level_manager.tscn").instantiate()
	add_child(node_instance)
	node_instance.load_level(level)
	$UIMaster/MainMenu/VBoxContainer.hide()
	$UIMaster/MainMenu/MainMenu.show()


func _on_level_maker_pressed() -> void:
	node_instance = load("res://Components/LevelMaker/level_tester.tscn").instantiate()
	add_child(node_instance)
	$UIMaster/MainMenu/VBoxContainer.hide()
	$UIMaster/MainMenu/MainMenu.show()

func back_to_mainmenu():
	$UIMaster/MainMenu/VBoxContainer.show()
	$UIMaster/MainMenu/MainMenu.hide()
	node_instance.queue_free()
