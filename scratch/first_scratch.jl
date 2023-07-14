using PGA3D, Random, LinearAlgebra, StaticArrays
from = Point3D(1.0, 0, 0)
to = Point3D(0, 1.0, 0)
mft = motor_fromto(from, to)

transformed_from = transform(from, mft)
trans_mat, inv_trans_mat = get_transform_and_inv_matrices(mft)
trans_mat * internal_vec(from)

#testfrom = Point3D(normalize(randn(3))...)
testfrom = from
#testto = Point3D(normalize(randn(3))...)
testto = to
testfromar = SA[testfrom[1], testfrom[2], testfrom[3]]
testtoar = SA[testto[1], testto[2], testto[3]]
# calculate the angle between them in the plane they span
y = cross(testfromar, testtoar)
x = dot(testfromar, testtoar)
angle = atan(norm(y), x)
# create a unitized line from the origin to the cross product of the two points
testline = line_fromto(Point3D(0.0, 0.0, 0.0), Point3D(y...))
# now generate the screw that rotates from to to
mft_rot = motor_screw(testline, angle, 0)
rot_mat, inv_rot_mat = get_transform_and_inv_matrices(mft_rot)
# and verify that the rotation works as intended
rotatedfrom = transform(testfrom, mft_rot)
#@assert rotatedfrom ≈ testto