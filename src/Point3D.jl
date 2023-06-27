
struct Point3D{T<:Real} <: AbstractVector{T}
    x::T
    y::T
    z::T
    w::T
end

Point3D(x::Real, y::Real, z::Real, w::Real) = Point3D(promote(x, y, z, w)...)
Point3D(x::Real, y::Real, z::Real) = Point3D(x, y, z, 1)

