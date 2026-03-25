class_name DataTypes

enum Tools {
	None,
	AxeWood,
	TillGround,
	WaterCrops,
	
	# === CÁC HÀNH ĐỘNG TRỒNG CÂY ===
	PlantWheat,
	PlantTomato,
	PlantCarrot,
	PlantCorn,
	PlantRose,
	PlantBroccoli,
	
	Plants          # Dùng để mở PlantsUI
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
