extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	#var level: LevelResource = load("res://LevelData/Level1.tres")
	#$LevelManager.load_level(level)
	pass
	
	


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_select_level_index_pressed(index: int) -> void:
	var level: LevelResource = load("res://LevelData/Level" + str(index + 1) + ".tres")
	$LevelManager.load_level(level)
