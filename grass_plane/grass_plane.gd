extends Node3D

var _grass_rows := 100
var _grass_columns := 100
var _total_grass := _grass_rows * _grass_columns

var noise = FastNoiseLite.new()

func get_noise(x: float, z: float):
	return (noise.get_noise_2d(x, z) + noise.get_noise_2d(x*5, z*5) / 2 + noise.get_noise_2d(x*25, z*25) / 2)

func in_circle(x: , z) -> Vector2:
	if sqrt(x**2 + z**2) > 1.0:
		return in_circle(randf() * 2 - 1, randf() * 2 - 1)
	return Vector2(x, z)

func _ready():
	$Ground/Terrain.mesh.size.x = 6
	$Ground/Terrain.mesh.size.y = 6
	
	var surface_tool := SurfaceTool.new()
	surface_tool.create_from($Ground/Terrain.mesh, 0)
	
	var data = surface_tool.commit_to_arrays()
	var vertices = data[ArrayMesh.ARRAY_VERTEX]
	
	for i in vertices.size():
		var vertex = vertices[i]
		var vertex_height: float = get_noise(vertex.x, vertex.z)
		vertex_height += min(2.0 - sqrt(vertex.x**2 + vertex.z**2), 0) / 2
		vertices[i].y = vertex_height
	data[ArrayMesh.ARRAY_VERTEX] = vertices
	
	var array_mesh = ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, data)
	
	surface_tool.create_from(array_mesh,0)
	surface_tool.generate_normals()
	
	$Ground/Terrain.mesh = surface_tool.commit()
	$Ground/CollisionShape3D.shape = array_mesh.create_trimesh_shape()
	
	$Ground/Grass.multimesh.instance_count = _total_grass
	for x in range(_grass_columns):
		for z in range(_grass_rows):
			var instance_position = Transform3D()
			var pos_x := ((float(x) / _grass_columns) - 0.5) * 2 + (randf() * 0.05 - 0.025)
			var pos_z := ((float(z) / _grass_columns) - 0.5) * 2 + (randf() * 0.05 - 0.025)
			
			var pos_c := in_circle(pos_x, pos_z)
			pos_x = pos_c.x
			pos_z = pos_c.y
			
			pos_z += 1
			
			var instance_id = x * _grass_rows + z
			var instance_rotation = randf() * TAU;
			var instance_height = noise.get_noise_2d(x, z)
			var instance_data = Color(instance_height, instance_rotation, pos_x, pos_z)
			
			instance_position = instance_position.rotated(Vector3.UP, instance_rotation)
			instance_position = instance_position.translated(Vector3(pos_x, get_noise(pos_x, pos_z), pos_z))
			
			$Ground/Grass.multimesh.set_instance_transform(instance_id, instance_position)
			$Ground/Grass.multimesh.set_instance_custom_data(instance_id, instance_data)

func _process(_delta):
	RenderingServer.global_shader_parameter_set("camera_position", $Ball.position)
