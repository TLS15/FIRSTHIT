extends Control

signal tower_configured(towerData: TowerResource)

var team: String = "Blue"
var towerType: String = "Offensive"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_add_pressed() -> void:
	$Window.show()


func _on_confirm_pressed() -> void:
	#if not valid data
	var towerData: TowerResource = TowerResource.new()
	TowerResource.match_team(team, towerData)
	TowerResource.match_type(towerType, towerData)
		
		
	towerData.occupants = $Window/VBoxContainer/Occupants.value
	towerData.level = $Window/VBoxContainer/Level.value
	towerData.location = Vector2($Window/VBoxContainer/PositionX.value, $Window/VBoxContainer/PositionY.value)
	
		
	
	emit_signal("tower_configured", towerData)
	$Window.hide()


func _on_close_pressed() -> void:
	$Window.hide()

#
func _on_teams_item_selected(index: int) -> void:
	team = $Window/Teams.get_item_text(index)


func _on_tower_type_item_selected(index: int) -> void:
	towerType = $Window/TowerType.get_item_text(index)
