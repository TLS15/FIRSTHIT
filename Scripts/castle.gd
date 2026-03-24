extends Node2D

@export var tower_id: int
@export var tower_data: TowerResource
@export var occupants: int
@export var available_connections: int = 50
@export var affiliation: TowerResource.Players
var connections: Array[int]
var dragging := false

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
	


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		print("is pressed")
		emit_signal("press_received", tower_id)

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		dragging = event.pressed
