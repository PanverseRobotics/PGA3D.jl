using Test, SafeTestsets, Logging, PrettyPrinting

@safetestset "Constructor" begin
    using Test, SafeTestsets, Logging, PrettyPrinting

    @safetestset "Default Constructor" begin
        using PGA3D, Test, SafeTestsets, Logging, StaticArrays, Random, LinearAlgebra

        @testset "Vector3D Int" begin
            testvector = Vector3D(1, 2, 3)
            @test testvector isa Vector3D{Int}
            @test get_e032(testvector) === 1
            @test get_e013(testvector) === 2
            @test get_e021(testvector) === 3
        end

        @testset "Vector3D Double" begin
            testvector = Vector3D(1.0, 2.0, 3.0)
            @test testvector isa Vector3D{Float64}
            @test get_e032(testvector) === 1.0
            @test get_e013(testvector) === 2.0
            @test get_e021(testvector) === 3.0
        end

        @testset "Vector3D Float" begin
            testvector = Vector3D(1.0f0, 2.0f0, 3.0f0)
            @test testvector isa Vector3D{Float32}
            @test get_e032(testvector) === 1.0f0
            @test get_e013(testvector) === 2.0f0
            @test get_e021(testvector) === 3.0f0
        end

        @testset "Vector3D Promoted" begin
            testvector = Vector3D(1, 2.0f0, 3.0)
            @test testvector isa Vector3D{Float64}
            @test get_e032(testvector) === 1.0
            @test get_e013(testvector) === 2.0
            @test get_e021(testvector) === 3.0
        end

        @testset "Vector3D StaticArray" begin
            testvector = Vector3D(SA[1, 2.0f0, 3.0])
            @test testvector isa Vector3D{Float64}
            @test get_e032(testvector) === 1.0
            @test get_e013(testvector) === 2.0
            @test get_e021(testvector) === 3.0
        end

    end

end