extends Node2D


func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_select_level_index_pressed(index: int) -> void:
	var level: LevelResource = load("res://Data/LevelData/Level" + str(index + 1) + ".tres")
	$LevelManager.load_level(level)
	$LevelManager.process_mode=Node.PROCESS_MODE_INHERIT


func _on_level_maker_pressed() -> void:
	
	add_child(load("res://Components/LevelMaker/level_tester.tscn").instantiate())
	$UIMaster.hide()
	
