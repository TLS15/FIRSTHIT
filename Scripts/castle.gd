extends Area2D

@export var tower_id: int
@export var tower_data: TowerResource
@export var health: int
@export var available_connections: int = 1
@export var affiliation: TowerResource.Players



var connections: Array

var dragging := false
var level: int = 1
signal press_received(tower_id)

func _process(delta):

	if dragging:
		tower_data.location = get_global_mouse_position()
		global_position = tower_data.location # This keeps them synced 

func assign_resource(resource: TowerResource):
	tower_data = resource
	position = tower_data.location
	set_health(tower_data.occupants)
	set_affiliation(tower_data.affiliation) 
	

func set_affiliation(aff: int):
	affiliation = aff
	match aff:
		0: $HealthBar.set_self_modulate(Color.DARK_BLUE)
		1: $HealthBar.set_self_modulate(Color.GREEN)
		2: $HealthBar.set_self_modulate(Color.DARK_RED)
		3: $HealthBar.set_self_modulate(Color.YELLOW)

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
		emit_signal("press_received", tower_id)

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_MIDDLE:
		dragging = event.pressed


func set_level(num: int):
	level = num
	available_connections = num
	$HealthBar.max_value = 10 + 20 * num
	if level == 3:
		$Upgrade.hide()

func set_health(hp: int):
	health = hp
	$HealthBar.value = hp
	$Health.text = str(hp)

func interact(unit):
	if unit.affiliation == affiliation:
		set_health(health + unit.attack / 10)
		if health > 10 + 20 * level:
			set_health(10 + 20 * level)
			if connections.size() != 0:
				unit.target_tower = connections[randi() % connections.size()] # idk if origin updated
				unit.origin_tower = self
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
