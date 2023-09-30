struct Translator3D{T<:Number} <: AbstractPGA3DElement{T}
    vec::SVector{4,T}

    function Translator3D(e01::Number, e02::Number, e03::Number)
        T = promote_type(eltype(e01), eltype(e02), eltype(e03))
        vec = SVector{4,T}(promote(1, e01, e02, e03)...)
        return new{T}(vec)
    end

    function Translator3D(vec::SVector{3,T}) where {T<:Number}
        one_cat_vec = SVector{4,T}(promote(1, vec...)...)
        return new{T}(one_cat_vec)
    end

    function Translator3D(vec::SVector{4,T}) where {T<:Number}
        return new{T}(vec)
    end
end

internal_vec(a::Translator3D) = a.vec

Base.length(::Translator3D) = 4
Base.size(::Translator3D) = (4,)


get_scalar(a::Translator3D) = a[1]
get_e01(a::Translator3D) = a[2]
get_e02(a::Translator3D) = a[3]
get_e03(a::Translator3D) = a[4]
