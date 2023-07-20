using PGA3D, StaticArrays, Random
Random.seed!(1)

#m = Motor3D(0.0, 1, 0, 0, 1, 2, 3, 0)
#p = Point3D(randn(3)...)

#mat = get_transform_matrix(m)
#
#m2 = motor_from_transform(mat)


#@info m
#@info m2
#@info mat


rot1 = SA[
    1.0 0 0 1
    0 -1 0 2
    0 0 -1 3
    0 0 0 1
]
rot1sm = SA[
    1.0 0 0
    0 -1 0
    0 0 -1
]

@info rot1
rotm1 = motor_from_transform(rot1)
rot2 = get_transform_matrix(rotm1)
@info rot2

@info rotm1
#@info mat ≈ rot1


#rotm2 = PGA3D.motor_from_rotation(rot1sm)
#@info rotm2





