struct Plane3D{T<:Number} <: AbstractPGA3DElement{T}
    vec::SVector{4,T}

    function Plane3D(e1::Number, e2::Number, e3::Number, e0::Number)
        T = promote_type(eltype(e1), eltype(e2), eltype(e3), eltype(e0))
        vec = SVector{4,T}(promote(e1, e2, e3, e0)...)
        new{T}(vec)
    end

    function Plane3D(vec::SVector{4,T}) where {T<:Number}
        new{T}(vec)
    end
end

internal_vec(p::Plane3D) = p.vec

get_e1(p::Plane3D) = p[1]
get_e2(p::Plane3D) = p[2]
get_e3(p::Plane3D) = p[3]
get_e0(p::Plane3D) = p[4]

const special_planes = SA[
    Plane3D(0, 0, 0, 0),
    Plane3D(1, 0, 0, 0), Plane3D(-1, 0, 0, 0),
    Plane3D(0, 1, 0, 0), Plane3D(0, -1, 0, 0),
    Plane3D(0, 0, 1, 0), Plane3D(0, 0, -1, 0),
    Plane3D(0, 0, 0, 1), Plane3D(0, 0, 0, -1)
]

Base.:(+)(a::Plane3D, b::Plane3D) = Plane3D((internal_vec(a) .+ internal_vec(b)))
Base.:(-)(a::Plane3D, b::Plane3D) = Plane3D((internal_vec(a) .- internal_vec(b)))
Base.:(-)(a::Plane3D) = Plane3D(-internal_vec(a))
Base.:(*)(a::Plane3D, b::Real) = Plane3D((internal_vec(a) .* b))
Base.:(*)(a::Real, b::Plane3D) = Plane3D((a .* internal_vec(b)))

function LinearAlgebra.normalize(p::Plane3D)
    direction_normsq = p[1] * p[1] + p[2] * p[2] + p[3] * p[3]
    if direction_normsq ≈ 0
        throw(DomainError(p, "Plane3D must have a non-zero direction to normalize."))
    else
        direction_inv_norm = 1 / sqrt(direction_normsq)
        return p * direction_inv_norm
    end
end

function Base.inv(p::Plane3D)
    direction_normsq = p[1] * p[1] + p[2] * p[2] + p[3] * p[3]
    if direction_normsq ≈ 0
        throw(DomainError(p, "Plane3D must have a non-zero direction to invert."))
    else
        direction_inv_normsq = 1 / direction_normsq
        return p * direction_inv_normsq
    end
end


