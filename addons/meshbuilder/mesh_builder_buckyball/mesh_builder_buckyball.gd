@tool
extends CSGMesh3D
class_name MeshBuilderBuckyball
@icon("res://addons/meshbuilder/mesh_builder_buckyball/small-icon.svg")

const C0:float = 0.809016994374947424102293417183
const C1:float = 0.850650808352039932181540497063
const C2:float = 1.025731112119133606025669084848
const C3:float = 1.659667802726987356283833914246
const C4:float = 1.87638192047117353820720958191
const C5:float = 2.159667802726987356283833914246
const C6:float = 2.18539891484612096230950299909
const C7:float = 2.68539891484612096230950299909
 
var points:PackedVector3Array = PackedVector3Array([
	Vector3( 0.0,   C2,   C7),
	Vector3( 0.0,   C2,  -C7),
	Vector3( 0.0,  -C2,   C7),
	Vector3( 0.0,  -C2,  -C7),
	Vector3(  C7,  0.0,   C2),
	Vector3(  C7,  0.0,  -C2),
	Vector3( -C7,  0.0,   C2),
	Vector3( -C7,  0.0,  -C2),
	Vector3(  C2,   C7,  0.0),
	Vector3(  C2,  -C7,  0.0),
	Vector3( -C2,   C7,  0.0),
	Vector3( -C2,  -C7,  0.0),
	Vector3(  C1,  0.5,   C7),
	Vector3(  C1,  0.5,  -C7),
	Vector3(  C1, -0.5,   C7),
	Vector3(  C1, -0.5,  -C7),
	Vector3( -C1,  0.5,   C7),
	Vector3( -C1,  0.5,  -C7),
	Vector3( -C1, -0.5,   C7),
	Vector3( -C1, -0.5,  -C7),
	Vector3(  C7,   C1,  0.5),
	Vector3(  C7,   C1, -0.5),
	Vector3(  C7,  -C1,  0.5),
	Vector3(  C7,  -C1, -0.5),
	Vector3( -C7,   C1,  0.5),
	Vector3( -C7,   C1, -0.5),
	Vector3( -C7,  -C1,  0.5),
	Vector3( -C7,  -C1, -0.5),
	Vector3( 0.5,   C7,   C1),
	Vector3( 0.5,   C7,  -C1),
	Vector3( 0.5,  -C7,   C1),
	Vector3( 0.5,  -C7,  -C1),
	Vector3(-0.5,   C7,   C1),
	Vector3(-0.5,   C7,  -C1),
	Vector3(-0.5,  -C7,   C1),
	Vector3(-0.5,  -C7,  -C1),
	Vector3(  C3,   C0,   C6),
	Vector3(  C3,   C0,  -C6),
	Vector3(  C3,  -C0,   C6),
	Vector3(  C3,  -C0,  -C6),
	Vector3( -C3,   C0,   C6),
	Vector3( -C3,   C0,  -C6),
	Vector3( -C3,  -C0,   C6),
	Vector3( -C3,  -C0,  -C6),
	Vector3(  C6,   C3,   C0),
	Vector3(  C6,   C3,  -C0),
	Vector3(  C6,  -C3,   C0),
	Vector3(  C6,  -C3,  -C0),
	Vector3( -C6,   C3,   C0),
	Vector3( -C6,   C3,  -C0),
	Vector3( -C6,  -C3,   C0),
	Vector3( -C6,  -C3,  -C0),
	Vector3(  C0,   C6,   C3),
	Vector3(  C0,   C6,  -C3),
	Vector3(  C0,  -C6,   C3),
	Vector3(  C0,  -C6,  -C3),
	Vector3( -C0,   C6,   C3),
	Vector3( -C0,   C6,  -C3),
	Vector3( -C0,  -C6,   C3),
	Vector3( -C0,  -C6,  -C3),
	Vector3( 0.0,   C4,   C5),
	Vector3( 0.0,   C4,  -C5),
	Vector3( 0.0,  -C4,   C5),
	Vector3( 0.0,  -C4,  -C5),
	Vector3(  C5,  0.0,   C4),
	Vector3(  C5,  0.0,  -C4),
	Vector3( -C5,  0.0,   C4),
	Vector3( -C5,  0.0,  -C4),
	Vector3(  C4,   C5,  0.0),
	Vector3(  C4,  -C5,  0.0),
	Vector3( -C4,   C5,  0.0),
	Vector3( -C4,  -C5,  0.0),
	Vector3(  C3,   C3,   C3),
	Vector3(  C3,   C3,  -C3),
	Vector3(  C3,  -C3,   C3),
	Vector3(  C3,  -C3,  -C3),
	Vector3( -C3,   C3,   C3),
	Vector3( -C3,   C3,  -C3),
	Vector3( -C3,  -C3,   C3),
	Vector3( -C3,  -C3,  -C3)
])
 
var faces:Array = [
	[ points[72],points[ 36],points[ 64],points[  4],points[ 20],points[ 44] ],
	[ points[72],points[ 44],points[ 68],points[  8],points[ 28],points[ 52] ],
	[ points[72],points[ 52],points[ 60],points[  0],points[ 12],points[ 36] ],
	[ points[73],points[ 37],points[ 13],points[  1],points[ 61],points[ 53] ],
	[ points[73],points[ 53],points[ 29],points[  8],points[ 68],points[ 45] ],
	[ points[73],points[ 45],points[ 21],points[  5],points[ 65],points[ 37] ],
	[ points[74],points[ 38],points[ 14],points[  2],points[ 62],points[ 54] ],
	[ points[74],points[ 54],points[ 30],points[  9],points[ 69],points[ 46] ],
	[ points[74],points[ 46],points[ 22],points[  4],points[ 64],points[ 38] ],
	[ points[75],points[ 39],points[ 65],points[  5],points[ 23],points[ 47] ],
	[ points[75],points[ 47],points[ 69],points[  9],points[ 31],points[ 55] ],
	[ points[75],points[ 55],points[ 63],points[  3],points[ 15],points[ 39] ],
	[ points[76],points[ 40],points[ 16],points[  0],points[ 60],points[ 56] ],
	[ points[76],points[ 56],points[ 32],points[ 10],points[ 70],points[ 48] ],
	[ points[76],points[ 48],points[ 24],points[  6],points[ 66],points[ 40] ],
	[ points[77],points[ 41],points[ 67],points[  7],points[ 25],points[ 49] ],
	[ points[77],points[ 49],points[ 70],points[ 10],points[ 33],points[ 57] ],
	[ points[77],points[ 57],points[ 61],points[  1],points[ 17],points[ 41] ],
	[ points[78],points[ 42],points[ 66],points[  6],points[ 26],points[ 50] ],
	[ points[78],points[ 50],points[ 71],points[ 11],points[ 34],points[ 58] ],
	[ points[78],points[ 58],points[ 62],points[  2],points[ 18],points[ 42] ],
	[ points[79],points[ 43],points[ 19],points[  3],points[ 63],points[ 59] ],
	[ points[79],points[ 59],points[ 35],points[ 11],points[ 71],points[ 51] ],
	[ points[79],points[ 51],points[ 27],points[  7],points[ 67],points[ 43] ],
	[ points[ 2],points[ 14],points[ 12],points[  0],points[ 16],points[ 18] ],
	[ points[ 3],points[ 19],points[ 17],points[  1],points[ 13],points[ 15] ],
	[ points[ 4],points[ 22],points[ 23],points[  5],points[ 21],points[ 20] ],
	[ points[ 7],points[ 27],points[ 26],points[  6],points[ 24],points[ 25] ],
	[ points[ 8],points[ 29],points[ 33],points[ 10],points[ 32],points[ 28] ],
	[ points[ 9],points[ 30],points[ 34],points[ 11],points[ 35],points[ 31] ],
	[ points[60],points[ 52],points[ 28],points[ 32],points[ 56] ],
	[ points[61],points[ 57],points[ 33],points[ 29],points[ 53] ],
	[ points[62],points[ 58],points[ 34],points[ 30],points[ 54] ],
	[ points[63],points[ 55],points[ 31],points[ 35],points[ 59] ],
	[ points[64],points[ 36],points[ 12],points[ 14],points[ 38] ],
	[ points[65],points[ 39],points[ 15],points[ 13],points[ 37] ],
	[ points[66],points[ 42],points[ 18],points[ 16],points[ 40] ],
	[ points[67],points[ 41],points[ 17],points[ 19],points[ 43] ],
	[ points[68],points[ 44],points[ 20],points[ 21],points[ 45] ],
	[ points[69],points[ 47],points[ 23],points[ 22],points[ 46] ],
	[ points[70],points[ 49],points[ 25],points[ 24],points[ 48] ],
	[ points[71],points[ 50],points[ 26],points[ 27],points[ 51] ]
]

func init(params=[0]):
	self.operation = params[0]
	build()
	return self
 
func triangles_from_hexa(hexa:PackedVector3Array) -> PackedVector3Array:
	var tri_arr:PackedVector3Array = []
	var mid:Vector3 = (hexa[0] + hexa[1] + hexa[2] + hexa[3] + hexa[4] + hexa[5]) / 6.0

	for i in range(hexa.size()):
		var inext:int = wrapi(i+1, 0, hexa.size())
		tri_arr.append(mid)
		tri_arr.append(hexa[inext])
		tri_arr.append(hexa[i])
	return tri_arr
 
func triangles_from_penta(penta:PackedVector3Array) -> PackedVector3Array:
	var tri_arr:PackedVector3Array = []
	var mid:Vector3 = (penta[0] + penta[1] + penta[2] + penta[3] + penta[4]) / 5.0
 
	for i in range(penta.size()):
		var inext:int = wrapi(i+1, 0, penta.size())
		tri_arr.append(mid)
		tri_arr.append(penta[inext])
		tri_arr.append(penta[i])
	return tri_arr
	
func build() -> void:
	# Convert hexagons and pentagons to triangles
	var hex_points1:PackedVector3Array = []
	var hex_points2:PackedVector3Array = []
	var penta_points:PackedVector3Array = []
	for face in faces:
		if face.size() == 6:
			if randf() > .5:
				hex_points1 += triangles_from_hexa(face)
			else:
				hex_points2 += triangles_from_hexa(face)
		elif face.size() == 5:
			penta_points += triangles_from_penta(face)
		else:
			assert(false)
			
	# Create array meshes
	var hex_mesharr1 = []
	hex_mesharr1.resize(ArrayMesh.ARRAY_MAX)
	hex_mesharr1[ArrayMesh.ARRAY_VERTEX] = hex_points1
	var hex_mesharr2 = []
	hex_mesharr2.resize(ArrayMesh.ARRAY_MAX)
	hex_mesharr2[ArrayMesh.ARRAY_VERTEX] = hex_points2
	var pent_mesharr = []
	pent_mesharr.resize(ArrayMesh.ARRAY_MAX)
	pent_mesharr[ArrayMesh.ARRAY_VERTEX] = penta_points
 
	# Create the Mesh.
	var arr_mesh = ArrayMesh.new()
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, hex_mesharr1)
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, hex_mesharr2)
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, pent_mesharr)
	self.mesh = arr_mesh

func to_json():
	var children = []
	for child in get_children():
		children.append(child.to_json())
	var json = {
		"name": "Buckyball",
		"params": [operation],
		"children": children
	}
	
	if scale != Vector3.ONE:
		json["scale"] = [snapped(scale.x,0.001), snapped(scale.y,0.001), snapped(scale.z,0.001)]
	if rotation != Vector3.ZERO:
		json["rotation"] = [snapped(rotation.x,0.001), snapped(rotation.y,0.001), snapped(rotation.z,0.001)]
	if position != Vector3.ZERO:
		json["position"] = [snapped(position.x,0.001), snapped(position.y,0.001), snapped(position.z,0.001)]
	
	return json
