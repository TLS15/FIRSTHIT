extends Node2D

@export var tower_id: int
@export var tower_data: TowerResource
@export var occupants: int
@export var available_connections: int = 2
@export var affiliation: TowerResource.Players
#@export var health: int

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
	$CastleHitbox.set_collision_mask_value(tower_id + 1, false) # This will break with ca. 16 towers or more 
	
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		print("is pressed")
		emit_signal("press_received", tower_id)

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_MIDDLE:
		dragging = event.pressed

func _on_area_2d_area_entered(area: Area2D) -> void:
	print("castle entered")
	if area.affiliation != affiliation:
		occupants -= 1
	else:  
		occupants += 1
		
	area.queue_free()
		
func spawn_unit(target_position: Vector2):
	var unit = load("res://Components/Units/Unit.tscn").instantiate()
	unit.set_collision_layer_value(tower_id + 1, true)
	unit.affiliation = affiliation
	unit.target_position = target_position
	add_child(unit)
