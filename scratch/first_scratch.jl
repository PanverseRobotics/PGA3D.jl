using PGA3D
from = Point3D(1, 0, 0)
to = Point3D(0, 0, 0)
mft = motor_fromto(from, to)

transformed_from = transform(from, mft)