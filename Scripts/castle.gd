extends Area2D

@export var tower_id: int
@export var tower_data: TowerResource
@export var occupants: int
@export var available_connections: int = 2
@export var affiliation: TowerResource.Players
#@export var health: int


var connections: Array[int]
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
	occupants = tower_data.occupants
	affiliation = tower_data.affiliation 


func spawn_unit(target_tower):
	var unit = load("res://Components/Units/Unit.tscn").instantiate()
	match level:
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

func interact(attack, team):
	if team == affiliation:
		occupants += attack / 10
		if occupants < 10:
			level = 1
		elif occupants < 20:
			level = 2
		else:
			level = 3

	else:
		occupants -= attack / 10
		if occupants < 0:
			occupants *= -1
			affiliation = team
