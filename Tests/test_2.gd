extends GutTest

var tower
var friendly_tower
var enemy_tower
func before_each():
	tower = preload("res://Components/Scenes/castle.tscn").instantiate()
	friendly_tower = preload("res://Components/Scenes/castle.tscn").instantiate()
	enemy_tower = preload("res://Components/Scenes/castle.tscn").instantiate() 
	add_child(tower)
	add_child(enemy_tower)
	add_child(friendly_tower)
	
	# Minimal required setup to avoid crashes
	tower.connections = []
	tower.enemy_units_in_range = []

func after_each():
	tower.queue_free()
	enemy_tower.queue_free()
	friendly_tower.queue_free()

func test_available_connections():
	tower.level = 3
	tower.connections = [1, 2]
	
	var result = tower.get_available_connections()
	
	assert_eq(result, 1)

func test_set_level_caps_at_3():
	tower.set_level(5)
	assert_ne(tower.level, 5, "Level should not exceed 3")

func test_set_level_updates_value():
	tower.set_level(2)
	assert_eq(tower.level, 2)

func test_get_max_health():
	tower.level = 2
	
	var max_hp = tower.get_max_health()
	
	assert_eq(max_hp, 10 + 20 * 2)

func test_set_health():
	tower.set_health(42)
	
	assert_eq(tower.health, 42)

func test_interact_capture_tower():
	var unit = load("res://Components/Units/Unit.tscn").instantiate()
	unit.affiliation = 2
	unit.attack = 1000
	
	tower.affiliation = 1
	tower.set_health(1)
	
	tower.interact(unit)
	
	assert_eq(tower.affiliation, 2, "Tower should switch affiliation when health < 0")
