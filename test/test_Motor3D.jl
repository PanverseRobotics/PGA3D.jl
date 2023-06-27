using PGA3D
using SafeTestsets, Test

@safetestset "Constructor" begin
    Motor3D(1, 2, 3, 4, 5, 6, 7, 8)
end
