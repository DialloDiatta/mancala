extends Bead
class_name RandomBead

@export var variations: Array[Texture2D]
@export var random_rotation: bool = false

func pick_random_variation() -> Texture2D:
    return variations.pick_random()
