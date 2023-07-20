
dual(p::Point3D) = Plane3D(-p[1], -p[2], -p[3], -p[4])
undual(p::Point3D) = Plane3D(p[1], p[2], p[3], p[4])

dual(p::Plane3D) = Point3D(p[1], p[2], p[3], p[4])
undual(p::Plane3D) = Point3D(-p[1], -p[2], -p[3], -p[4])

dual(l::Line3D) = Line3D(l[4], l[5], l[6], l[1], l[2], l[3])
undual(l::Line3D) = dual(l)

dual(m::Motor3D) = Motor3D(m[8], m[5], m[6], m[7], m[2], m[3], m[4], m[1])
undual(m::Motor3D) = dual(m)



