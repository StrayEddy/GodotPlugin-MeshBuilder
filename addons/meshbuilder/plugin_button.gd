# Button to activate the painting and show the paint panel

@tool
extends Button

class_name PluginButton

var root :Node
var parent :MeshInstance3D

# Show button in UI, untoggled
func show_button(root: Node, parent :MeshInstance3D):
	self.root = root
	self.parent = parent
	show()

# Hide button in UI, untoggled
func hide_button():
	hide()

func _on_PluginButton_pressed() -> void:
	add_csg()

func add_csg():
	var cone = CSG.cone()
	var cube = CSG.cube()
	var translated_cube = CSG.cube(Vector3(0.5,0.5,0))
	var big_cube = CSG.cube(Vector3(0,0,0), 1.5)
	var cylinder = CSG.cylinder()
	var sphere = CSG.sphere()
	
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var start_time = Time.get_ticks_msec()
#	var csg_info = big_cube.subtract(sphere)
#	var csg_info = sphere.subtract(translated_cube)
#	var csg_info = sphere.subtract(big_cube)
	var csg_info = big_cube.intersect(sphere)
	print(Time.get_ticks_msec() - start_time)
#	csg_info.print_1()
	
	var real_poly_count = 0
	
	for poly in csg_info.polygons:
		poly.vertices.reverse()
		for i in len(poly.vertices)-2:
			st.add_vertex(poly.vertices[0].pos)
			st.add_vertex(poly.vertices[i+1].pos)
			st.add_vertex(poly.vertices[i+2].pos)
#			st.set_smooth_group(real_poly_count)
			real_poly_count += 1
	
	st.index()
	st.generate_normals()
	var mesh = st.commit()
	parent.mesh = mesh
