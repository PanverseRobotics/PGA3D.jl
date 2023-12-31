
abstract type AbstractPGA3DElement{T<:Number} <: Number end

"""
AbstractPGA3Element are backed by an internal StaticVector so that they can be isbits and leverage high performance small arrays.
"""
function internal_vec(::AbstractPGA3DElement)
    throw("internal_vec is not implemented for type $(typeof(v)).  This function is required for subtypes of AbstractPGA3Element.")
end

# Provide an AbstractArray interface even though we're not subtyping it. 
# Most subtypes will override the size and length for ease of compiler constant propagation/inference but not the getindex.
Base.getindex(el::AbstractPGA3DElement, i::Integer) = internal_vec(el)[i]
Base.getindex(el::AbstractPGA3DElement, i) = internal_vec(el)[i]
Base.size(el::AbstractPGA3DElement) = size(internal_vec(el))
Base.length(el::AbstractPGA3DElement) = length(internal_vec(el))
Base.isapprox(a::AbstractPGA3DElement, b::AbstractPGA3DElement; kwargs...) = isapprox(internal_vec(a), internal_vec(b); kwargs...)
Base.isequal(a::AbstractPGA3DElement, b::AbstractPGA3DElement) = isequal(internal_vec(a), internal_vec(b))

# if the types are the same then we can easily define addition, subtraction, negation, and scalar multiplication
# we can probably define more general versions of this but the type math gets a little trickier
Base.:(+)(a::P, b::P) where {P<:AbstractPGA3DElement} = P((internal_vec(a) .+ internal_vec(b)))
Base.:(-)(a::P, b::P) where {P<:AbstractPGA3DElement} = P((internal_vec(a) .- internal_vec(b)))
Base.:(-)(a::P) where {P<:AbstractPGA3DElement} = P(-internal_vec(a))
Base.:(*)(a::P, b::Real) where {P<:AbstractPGA3DElement} = P((internal_vec(a) .* b))
Base.:(*)(a::Real, b::P) where {P<:AbstractPGA3DElement} = P((a .* internal_vec(b)))

