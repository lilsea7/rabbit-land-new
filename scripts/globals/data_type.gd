class_name DataTypes

enum Tools {
	None,
	AxeWood,
	TillGround,
	WaterCrops,
	PlantWheat,
	PlantTomato,
	Plants
}

enum ColisonLayer {
	Ground = 1,
	Player = 2,
	Interactable = 3
}

enum GrowthStates {
	Seed,
	Germination,
	Vegetative,
	Reproduction,
	Maturity,
	Harvesting
}
