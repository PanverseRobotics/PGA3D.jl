
struct Point3D{T<:Real} <: AbstractVector4D{T}
    x::T
    y::T
    z::T
end

Point3D(x::Real, y::Real, z::Real) = Point3D(promote(x, y, z)...)

get_x(p::Point3D) = p.x
get_y(p::Point3D) = p.y
get_z(p::Point3D) = p.z
get_w(::Point3D{T}) where {T<:Real} = one(T)

