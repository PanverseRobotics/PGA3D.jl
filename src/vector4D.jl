
struct Vector4D{T<:Number} <: AbstractVector4D{T}
    vec::SVector{4,T}

    function Vector4D(x::Number, y::Number, z::Number, w::Number)
        T = promote_type(eltype(x), eltype(y), eltype(z), eltype(w))
        vec = SVector{4,T}(promote(x, y, z, w)...)
        new{T}(vec)
    end

    function Vector4D(vec::SVector{4,T}) where {T<:Number}
        new{T}(vec)
    end

end

internal_vec(v::Vector4D) = v.vec

get_e032(v::Vector4D) = v[1]
get_e013(v::Vector4D) = v[2]
get_e021(v::Vector4D) = v[3]
get_e123(v::Vector4D) = v[4]

Vector4D(el::AbstractPGA3DElement{T}) where {T<:Number} = Base.convert(Vector4D{T}, el)

# Define the basic arithmetic operations for Vector4D
# I think this interface prevents broadcast fusion from happening but we can fix that later if we need the extra performance.
Base.:(+)(a::Vector4D, b::Vector4D) = Vector4D((internal_vec(a) .+ internal_vec(b))...)
Base.:(-)(a::Vector4D, b::Vector4D) = Vector4D((internal_vec(a) .- internal_vec(b))...)
LinearAlgebra.:(⋅)(a::Vector4D, b::Vector4D) = internal_vec(a) ⋅ internal_vec(b)
#LinearAlgebra.dot(a::Vector4D, b::Vector4D) = a ⋅ b
Base.:(-)(a::Vector4D) = Vector4D(-internal_vec(a))
Base.:(*)(a::Vector4D, b::Real) = Vector4D((internal_vec(a) .* b)...)
Base.:(*)(a::Real, b::Vector4D) = Vector4D((a .* internal_vec(b))...)

#Vector4D(el::AbstractPGA3DElement{T}) where {T<:Real} = convert(Vector4D{T}, el)

bulk_norm(v::Vector4D) = norm(SA[v[1], v[2], v[3]])
weight_norm(v::Vector4D) = abs(get_w(v))
unitize(v::Vector4D) = Vector4D(internal_vec(v) .* (1 / get_w(v)))


