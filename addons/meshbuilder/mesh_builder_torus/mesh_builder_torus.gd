@tool
extends MeshBuilderShape
class_name MeshBuilderTorus

@export var innerR :float = 0.5
@export var outerR :float = 1.0
@export var stacks :int = 8
@export var slices :int = 6
var current_values :Array = [innerR, outerR, stacks, slices]

# Called when the node enters the scene tree for the first time.
func _ready():
	csg = CSG.torus(innerR, outerR, stacks, slices)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.current_values != [innerR, outerR, stacks, slices]:
		self.current_values = [innerR, outerR, stacks, slices]
		change_transform()
		emit_signal("csg_change")
	super._process(delta)

func change_transform():
	csg = CSG.torus(innerR, outerR, stacks, slices).scale(scale).rotate(rotation).translate(position)
	super.change_transform()
