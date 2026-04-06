extends Area2D

@export var tower_id: int
@export var tower_data: TowerResource
@export var health: int
@export var affiliation: TowerResource.Players
@export var type: TowerResource.TowerType

var connections: Array
var enemy_units_in_range: Array

var dragging := false
var level: int = 1
signal press_received(tower)

func _process(delta):
	$ColorRect1.color = Color.ALICE_BLUE
	$ColorRect2.color = Color.ALICE_BLUE
	$ColorRect3.color = Color.ALICE_BLUE
	if level == 3:
		$ColorRect3.show()
	if level >= 2:
		$ColorRect2.show()
	$ColorRect1.show()
	
	if get_available_connections() == 3:
		$ColorRect3.color = Color.AQUA
	if get_available_connections() >= 2:
		$ColorRect2.color = Color.AQUA
	if get_available_connections() >= 1:
		$ColorRect1.color = Color.AQUA
	
	if dragging:
		set_location(get_global_mouse_position()) 

func get_available_connections():
	return level - connections.size()

func assign_resource(resource: TowerResource):
	tower_data = resource
	
	type = tower_data.type
	match type:
		0: init_offensive()
		1: init_defensive()
		2: init_economic()
	
	
	set_location(tower_data.location)
	set_health(tower_data.occupants)
	set_affiliation(tower_data.affiliation) 
	set_level(tower_data.level)

func set_location(pos: Vector2):
	global_position = pos
	tower_data.location = pos
	
func init_offensive():
	$Offensive.show()
	$SpawnTimer.start()

func init_defensive():
	$Defensive.show()
	$DefensiveArea.monitoring = true
	
func init_economic():
	$Economic.show()



func set_affiliation(aff: int):
	affiliation = aff
	match aff:
		0: $HealthBar.set_self_modulate(Color.DARK_BLUE)
		1: $HealthBar.set_self_modulate(Color.GREEN)
		2: $HealthBar.set_self_modulate(Color.DARK_RED)
		3: $HealthBar.set_self_modulate(Color.YELLOW)
		
	enemy_units_in_range.clear()

func spawn_unit(target_tower, unit_level: int):
	var unit = load("res://Components/Units/Unit.tscn").instantiate()
	match unit_level:
		1: unit.assign_resource(load("res://Components/Units/Triangle.tres"))
		2: unit.assign_resource(load("res://Components/Units/Square.tres"))
		3: unit.assign_resource(load("res://Components/Units/Circle.tres"))
	
	unit.affiliation = affiliation
	unit.origin_tower = self
	unit.target_tower = target_tower
	add_child(unit)


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		#print("is pressed")
		emit_signal("press_received", self)

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_MIDDLE:
		dragging = event.pressed


func set_level(num: int):
	if num > 3: 
		return
	level = num
	$HealthBar.max_value = 10 + 20 * num
	$Level.text = "Lv. " + str(level)
	if level == 3:
		$Upgrade.hide()

func set_health(hp: int):
	health = hp
	$HealthBar.value = hp
	$Health.text = str(hp)

func get_max_health():
	return 10 + 20 * level

func interact(unit):
	if unit.affiliation == affiliation:
		set_health(health + unit.attack / 10)
		if health > 10 + 20 * level:
			set_health(10 + 20 * level)
			if connections.size() != 0:
				unit.target_tower = connections[randi() % connections.size()]
				unit.origin_tower = self
			else: 
				unit.queue_free()
		else:
			unit.queue_free()

	else:
		unit.queue_free()
		set_health(health - unit.attack / 10)
		if health < 0:
			set_health(-health)
			set_affiliation(unit.affiliation)
			$"../../../LevelManager".check_win_condition()



func _on_upgrade_pressed() -> void:
	if $"../../../LevelManager".money > 50:
		$"../../../LevelManager".money -= 50
		set_level(level + 1)


func _on_spawn_timer_timeout() -> void:
	for tower in connections:
		spawn_unit(tower, level)

func spawn_bullet(unit):
	
	var instance = load("res://Components/Scenes/bullet.tscn").instantiate()
	instance.target_unit = unit
	instance.affiliation = affiliation
	instance.level = level
	add_child(instance)

func _on_defensive_area_area_entered(area: Area2D) -> void:
	if area.affiliation != affiliation:
		enemy_units_in_range.append(area)
		

func _on_defensive_area_area_exited(area: Area2D) -> void:
	if area.affiliation != affiliation:
		enemy_units_in_range.erase(area)


func _on_shooting_cooldown_timer_timeout() -> void:
	if enemy_units_in_range.size() > 0:
		spawn_bullet(enemy_units_in_range[0])
