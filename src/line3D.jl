struct Line3D{T<:Number} <: AbstractPGA3DElement{T}
    vec::SVector{6,T}

    function Line3D(vx::Number, vy::Number, vz::Number, mx::Number, my::Number, mz::Number)
        T = promote_type(eltype(vx), eltype(vy), eltype(vz), eltype(mx), eltype(my), eltype(mz))
        vec = SVector{6,T}(promote(vx, vy, vz, mx, my, mz)...)
        new{T}(vec)
    end

    function Line3D(vec::SVector{6,T}) where {T<:Number}
        new{T}(vec)
    end
end

internal_vec(a::Line3D) = a.vec

Base.length(::Line3D) = 6
Base.size(::Line3D) = (6,)

get_e23(a::Line3D) = a[1]
get_e31(a::Line3D) = a[2]
get_e12(a::Line3D) = a[3]
get_e01(a::Line3D) = a[4]
get_e02(a::Line3D) = a[5]
get_e03(a::Line3D) = a[6]

const special_lines = SA[
    Line3D(0, 0, 0, 0, 0, 0),
    Line3D(1, 0, 0, 0, 0, 0), Line3D(-1, 0, 0, 0, 0, 0),
    Line3D(0, 1, 0, 0, 0, 0), Line3D(0, -1, 0, 0, 0, 0),
    Line3D(0, 0, 1, 0, 0, 0), Line3D(0, 0, -1, 0, 0, 0),
    Line3D(0, 0, 0, 1, 0, 0), Line3D(0, 0, 0, -1, 0, 0),
    Line3D(0, 0, 0, 0, 1, 0), Line3D(0, 0, 0, 0, -1, 0),
    Line3D(0, 0, 0, 0, 0, 1), Line3D(0, 0, 0, 0, 0, -1)
]

line_vector(a::Line3D) = SA[a[1], a[2], a[3]]
line_moment(a::Line3D) = SA[a[4], a[5], a[6]]

Base.:(+)(a::Line3D, b::Line3D) = Line3D((internal_vec(a) .+ internal_vec(b)))
Base.:(-)(a::Line3D, b::Line3D) = Line3D((internal_vec(a) .- internal_vec(b)))
Base.:(-)(a::Line3D) = Line3D(-internal_vec(a))
Base.:(*)(a::Line3D, b::Real) = Line3D((internal_vec(a) .* b))
Base.:(*)(a::Real, b::Line3D) = Line3D((a .* internal_vec(b)))

weight_norm(a::Line3D) = norm(SA[a[1], a[2], a[3]])
bulk_norm(a::Line3D) = norm(SA[a[4], a[5], a[6]])

unitize(a::Line3D) = Line3D(internal_vec(a) .* (1 / weight_norm(a)))

function LinearAlgebra.normalize(a::Line3D)
    a1a4 = a[1] * a[4]
    a2a5 = a[2] * a[5]
    a3a6 = a[3] * a[6]
    l = norm(SA[a[1], a[2], a[3]])
    if l ≈ 0
        throw(DomainError(a, "Line3D must have a non-zero direction to normalize."))
    else
        l3 = l * l * l
        l4 = l * l * l * l
        return Line3D((a[1]) / (l),
            (a[2]) / (l),
            (a[3]) / (l),
            (l3 * a[4] - l * a1a4 * a[1] - l * a[1] * a2a5 - l * a[1] * a3a6) / (l4),
            (l3 * a[5] - l * a1a4 * a[2] - l * a2a5 * a[2] - l * a[2] * a3a6) / (l4),
            (l3 * a[6] - l * a1a4 * a[3] - l * a2a5 * a[3] - l * a3a6 * a[3]) / (l4))
    end
end

