extends Resource
class_name TowerResource
enum TowerType{
	DEFENSIVE,
	OFFENSIVE,
	ECONOMY,
}

enum Players {
	BLUE, # Player
	GREEN,
	RED,
	YELLOW,
}

static func match_team(team: String, tower: TowerResource) -> TowerResource:
	match team: 
		"Blue": tower.affiliation = TowerResource.Players.BLUE 
		"Green": tower.affiliation = TowerResource.Players.GREEN
		"Red": tower.affiliation = TowerResource.Players.RED
		"Yellow": tower.affiliation = TowerResource.Players.YELLOW
	return tower
	
static func match_type(type: String, tower: TowerResource) -> TowerResource:
	match type:
		"Offensive": tower.type = TowerResource.TowerType.OFFENSIVE
		"Defensive": tower.type = TowerResource.TowerType.DEFENSIVE
		"Economy": tower.type = TowerResource.TowerType.ECONOMY
		
	return tower
	
@export var type: TowerType
@export var location: Vector2
@export var level: int
@export var occupants: int
@export var affiliation: Players
