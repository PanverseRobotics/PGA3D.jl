using PGA3D, Test, SafeTestsets, Logging, StaticArrays, Random, LinearAlgebra

@safetestset "Duals and repeated products" begin
    using PGA3D, Test, SafeTestsets, Logging, StaticArrays, Random, LinearAlgebra
    Random.seed!(1)
    atol = 1e-10
    for i in 1:1000
        tpoint1 = Point3D(randn(3)...)
        tpoint2 = Point3D(randn(3)...)
        tpoint3 = Point3D(randn(3)...)

        tplane1 = dual(tpoint1)
        tplane2 = dual(tpoint2)
        tplane3 = dual(tpoint3)

        @test tpoint1 ∨ tpoint1 ≈ Line3D(zeros(6)...) atol = atol
        @test tplane1 ∧ tplane1 ≈ Line3D(zeros(6)...) atol = atol

        pointline12 = tpoint1 ∨ tpoint2
        planeline12 = tplane1 ∧ tplane2

        @test dual(pointline12) ≈ planeline12 atol = atol
        @test pointline12 ≈ undual(planeline12) atol = atol

        @test pointline12 ∨ tpoint2 ≈ Plane3D(zeros(4)...) atol = atol
        @test planeline12 ∧ tplane2 ≈ Point3D(zeros(4)...) atol = atol

        pointplane123 = pointline12 ∨ tpoint3
        planepoint123 = planeline12 ∧ tplane3

        @test dual(pointplane123) ≈ planepoint123 atol = atol
        @test pointplane123 ≈ undual(planepoint123) atol = atol
    end

end