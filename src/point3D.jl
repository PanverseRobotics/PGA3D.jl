struct Point3D{T<:Number} <: AbstractPGA3DElement{T}
    vec::SVector{4,T}

    function Point3D(e032::Number, e013::Number, e021::Number)
        T = promote_type(eltype(e032), eltype(e013), eltype(e021))
        vec = SVector{4,T}(promote(e032, e013, e021, one(T))...)
        new{T}(vec)
    end

    function Point3D(e032::Number, e013::Number, e021::Number, e123::Number)
        T = promote_type(eltype(e032), eltype(e013), eltype(e021), eltype(e123))
        vec = SVector{4,T}(promote(e032, e013, e021, e123)...)
        new{T}(vec)
    end

    function Point3D(vec::SVector{4,T}) where {T<:Number}
        new{T}(vec)
    end

    function Point3D(vec::SVector{3,T}) where {T<:Number}
        new{T}(SA[vec[1], vec[2], vec[3], one(T)])
    end
end

internal_vec(p::Point3D) = p.vec

const special_points = SA[
    Point3D(0, 0, 0, 0),
    Point3D(1, 0, 0, 0), Point3D(-1, 0, 0, 0),
    Point3D(0, 1, 0, 0), Point3D(0, -1, 0, 0),
    Point3D(0, 0, 1, 0), Point3D(0, 0, -1, 0),
    Point3D(0, 0, 0, 1), Point3D(0, 0, 0, -1),
    Point3D(1, 0, 0, 1), Point3D(-1, 0, 0, 1),
    Point3D(0, 1, 0, 1), Point3D(0, -1, 0, 1),
    Point3D(0, 0, 1, 1), Point3D(0, 0, -1, 1)
]

get_e032(p::Point3D) = p[1]
get_e013(p::Point3D) = p[2]
get_e021(p::Point3D) = p[3]
get_e123(p::Point3D) = p[4]

Base.:(+)(a::Point3D, b::Point3D) = Point3D((internal_vec(a) .+ internal_vec(b)))
Base.:(-)(a::Point3D, b::Point3D) = Point3D((internal_vec(a) .- internal_vec(b)))
Base.:(-)(a::Point3D) = Point3D(-internal_vec(a))
Base.:(*)(a::Point3D, b::Real) = Point3D((internal_vec(a) .* b))
Base.:(*)(a::Real, b::Point3D) = Point3D((a .* internal_vec(b)))

function LinearAlgebra.normalize(p::Point3D)
    if p[4] ≈ 0
        throw(DomainError(p, "Point3D must not be at infinity to normalize."))
    else
        return Point3D(p[1] / p[4], p[2] / p[4], p[3] / p[4])
    end
end

function Base.inv(a::Point3D)
    D2 = a[4]
    if D2 ≈ 0
        throw(DomainError(a, "Point3D must not be at infinity to invert."))
    else
        D1 = a[4] * a[4]
        return Point3D(
            (-a[1]) / (D1),
            (-a[2]) / (D1),
            (-a[3]) / (D1),
            (-1) / (D2))
    end

end

