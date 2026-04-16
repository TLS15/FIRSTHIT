extends GutTest

# LevelManager

func before_all():
	add_child(load("res://Components/Scenes/level_manager.tscn").instantiate())

func after_all():
	$LevelManager.queue_free()

func test_example():
	assert_eq(1, 1)

func test_cancel_action_resets_connection():
	$LevelManager.tower_connecting = Node.new()
	$LevelManager.preview_line = Node.new()
	add_child($LevelManager.preview_line)
	
	$LevelManager.cancel_action()
	
	assert_null($LevelManager.tower_connecting)

func test_add_connection():
	var a = load("res://Components/Scenes/castle.tscn").instantiate()
	$LevelManager/Towers.add_child(a)
	var b = load("res://Components/Scenes/castle.tscn").instantiate()
	$LevelManager/Towers.add_child(b)
	
	a.connections = []
	
	
	$LevelManager.add_connection(a, b)
	
	assert_true(a.connections.has(b), "Connection should be added")

func test_remove_connection():
	var a = load("res://Components/Scenes/castle.tscn").instantiate()
	$LevelManager/Towers.add_child(a)
	var b = load("res://Components/Scenes/castle.tscn").instantiate()
	$LevelManager/Towers.add_child(b)
	
	a.connections = [b]
	
	$LevelManager.remove_connection(a, b)
	
	assert_false(a.connections.has(b), "Connection should be removed")

func test_win_condition_all_blue():
	for i in range(3):
		var tower = load("res://Components/Scenes/castle.tscn").instantiate()
		tower.affiliation = TowerResource.Players.BLUE
		$LevelManager/Towers.add_child(tower)
	
	var result = $LevelManager.check_win_condition()
	
	assert_true(result, "Should win when all towers are BLUE")

func test_create_obstacle():
	var pos = Vector2i(5, 5)
	$LevelManager.create_obstacle(pos)
	
	var cell = $LevelManager/TileMapLayer.get_cell_source_id(
		$LevelManager/TileMapLayer.local_to_map(pos)
	)
	
	assert_ne(cell, -1, "Tile should exist after placing obstacle")
