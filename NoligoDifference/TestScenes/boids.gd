extends Node2D

@onready var marker_2d = $Marker2D

# Boid의 유형을 나타내는 배열입니다.
var boid_type = ["농민", "중기병", "궁병"]

# Boid가 이동할 목표 위치를 설정하는 변수입니다.
@export
var target_position : Vector2

# 정렬 규칙의 가중치를 설정하는 변수입니다. 정렬 규칙은 Boid가 그룹의 평균 방향으로 이동하려는 경향을 나타냅니다.
@export
var alignment_weight = 1.0

# 응집 규칙의 가중치를 설정하는 변수입니다. 응집 규칙은 Boid가 그룹의 중심으로 이동하려는 경향을 나타냅니다.
@export
var cohesion_weight = 1.0

# 분리 규칙의 가중치를 설정하는 변수입니다. 분리 규칙은 Boid가 서로 너무 가까워지지 않도록 하는 경향을 나타냅니다.
@export
var separation_weight = 1.2

# 추적 규칙의 가중치를 설정하는 변수입니다. 추적 규칙은 Boid가 목표 위치를 향하도록 하는 경향을 나타냅니다.
@export
var seek_weight = 1.0

func _ready():
	# 초기 목표 위치를 설정합니다.
	target_position = marker_2d.position
	
	# Boids 그룹에 속한 모든 Boid를 가져옵니다.
	var boids = get_tree().get_nodes_in_group("Boids")
	for i in range(boids.size()):
		# 각 Boid의 유형을 설정합니다.
		boids[i].type = boid_type[i % 3]

func _process(delta):
	# Boids 그룹에 속한 모든 Boid를 가져옵니다.
	var boids = get_tree().get_nodes_in_group("Boids")
	for boid in boids:
		# 각 Boid의 속도를 업데이트합니다. 이때, 정렬, 응집, 분리, 추적 규칙의 가중치를 고려합니다.
		boid.velocity += alignment_weight * alignment(boid, boids) + cohesion_weight * cohesion(boid, boids) + separation_weight * separation(boid, boids) + seek_weight * seek(boid)
		# 각 Boid의 위치를 업데이트합니다.
		boid.position += boid.velocity * delta

# 정렬 규칙을 계산하는 함수입니다. 이 함수는 Boid가 그룹의 평균 방향으로 이동하려는 경향을 나타냅니다.
func alignment(boid, boids):
	var velocity = Vector2()
	for other in boids:
		if other != boid and other.type == boid.type:
			velocity += other.velocity
	return velocity / (boids.size() - 1)

# 응집 규칙을 계산하는 함수입니다. 이 함수는 Boid가 그룹의 중심으로 이동하려는 경향을 나타냅니다.
func cohesion(boid, boids):
	var center = Vector2()
	for other in boids:
		if other != boid and other.type == boid.type:
			center += other.position
	center /= (boids.size() - 1)
	return (center - boid.position) * 0.01

# 분리 규칙을 계산하는 함수입니다. 이 함수는 Boid가 서로 너무 가까워지지 않도록 하는 경향을 나타냅니다.
func separation(boid, boids):
	var c = Vector2()
	for other in boids:
		if other != boid and other.type == boid.type:
			var direction = boid.position - other.position
			var distance = direction.length()
			c += direction.normalized() / distance
	return c

# 추적 규칙을 계산하는 함수입니다. 이 함수는 Boid가 목표 위치를 향하도록 하는 경향을 나타냅니다.
func seek(boid):
	var desired_velocity = (target_position - boid.position).normalized() * boid.max_speed
	return (desired_velocity - boid.velocity) * 0.01

# 목표 위치를 설정하는 함수입니다.
func setPosition(new_position):
	target_position = new_position
