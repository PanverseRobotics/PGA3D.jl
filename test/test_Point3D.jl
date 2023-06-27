using Test, SafeTestsets

@safetestset "Constructor" begin
    using Test, SafeTestsets

    @safetestset "Default 4 arg Constructor" begin
        using PGA3D
        using Test, SafeTestsets

        @testset "Point Int" begin
            pointint = Point3D(1, 2, 3, 4)
            @test pointint isa Point3D{Int}
            @test pointint.x === 1
            @test pointint.y === 2
            @test pointint.z === 3
            @test pointint.w === 4
        end

        @testset "Point Double" begin
            pointdouble = Point3D(1.0, 2.0, 3.0, 4.0)
            @test pointdouble isa Point3D{Float64}
            @test pointdouble.x === 1.0
            @test pointdouble.y === 2.0
            @test pointdouble.z === 3.0
            @test pointdouble.w === 4.0
        end

        @testset "Point Float" begin
            pointfloat = Point3D(1.0f0, 2.0f0, 3.0f0, 4.0f0)
            @test pointfloat isa Point3D{Float32}
            @test pointfloat.x === 1.0f0
            @test pointfloat.y === 2.0f0
            @test pointfloat.z === 3.0f0
            @test pointfloat.w === 4.0f0
        end

        @testset "Point Promoted" begin
            pointpromoted = Point3D(1, 2.0f0, 3.0, 4.0)
            @test pointpromoted isa Point3D{Float64}
            @test pointpromoted.x === 1.0
            @test pointpromoted.y === 2.0
            @test pointpromoted.z === 3.0
            @test pointpromoted.w === 4.0
        end

    end

    @safetestset "3 arg Constructor" begin
        using PGA3D
        using Test, SafeTestsets

        @testset "Point Int" begin
            pointint = Point3D(1, 2, 3)
            @test pointint isa Point3D{Int}
            @test pointint.x === 1
            @test pointint.y === 2
            @test pointint.z === 3
            @test pointint.w === 1
        end

        @testset "Point Double" begin
            pointdouble = Point3D(1.0, 2.0, 3.0)
            @test pointdouble isa Point3D{Float64}
            @test pointdouble.x === 1.0
            @test pointdouble.y === 2.0
            @test pointdouble.z === 3.0
            @test pointdouble.w === 1.0
        end

        @testset "Point Float" begin
            pointfloat = Point3D(1.0f0, 2.0f0, 3.0f0)
            @test pointfloat isa Point3D{Float32}
            @test pointfloat.x === 1.0f0
            @test pointfloat.y === 2.0f0
            @test pointfloat.z === 3.0f0
            @test pointfloat.w === 1.0f0
        end

        @testset "Point Promoted" begin
            pointpromoted = Point3D(1, 2.0f0, 3.0)
            @test pointpromoted isa Point3D{Float64}
            @test pointpromoted.x === 1.0
            @test pointpromoted.y === 2.0
            @test pointpromoted.z === 3.0
            @test pointpromoted.w === 1.0
        end

    end

end
