using Test, SafeTestsets, Logging

@safetestset "Constructor" begin
    using Test, SafeTestsets, Logging


    @safetestset "Default Constructor" begin
        using PGA3D, Test, SafeTestsets, Logging, StaticArrays, Random, LinearAlgebra

        @testset "Plane Int" begin
            testplane = Plane3D(1, 2, 3, 4)
            @test testplane isa Plane3D{Int}
            @test get_e1(testplane) === 1
            @test get_e2(testplane) === 2
            @test get_e3(testplane) === 3
            @test get_e0(testplane) === 4
        end

        @testset "Plane Double" begin
            testplane = Plane3D(1.0, 2.0, 3.0, 4.0)
            @test testplane isa Plane3D{Float64}
            @test get_e1(testplane) === 1.0
            @test get_e2(testplane) === 2.0
            @test get_e3(testplane) === 3.0
            @test get_e0(testplane) === 4.0
        end

        @testset "Plane Float" begin
            testplane = Plane3D(1.0f0, 2.0f0, 3.0f0, 4.0f0)
            @test testplane isa Plane3D{Float32}
            @test get_e1(testplane) === 1.0f0
            @test get_e2(testplane) === 2.0f0
            @test get_e3(testplane) === 3.0f0
            @test get_e0(testplane) === 4.0f0
        end

        @testset "Plane Promoted" begin
            testplane = Plane3D(1, 2.0f0, 3.0, 4)
            @test testplane isa Plane3D{Float64}
            @test get_e1(testplane) === 1.0
            @test get_e2(testplane) === 2.0
            @test get_e3(testplane) === 3.0
            @test get_e0(testplane) === 4.0
        end

        @testset "Plane StaticArray" begin
            testplane = Plane3D(SA[1, 2.0f0, 3.0, 4])
            @test testplane isa Plane3D{Float64}
            @test get_e1(testplane) === 1.0
            @test get_e2(testplane) === 2.0
            @test get_e3(testplane) === 3.0
            @test get_e0(testplane) === 4.0
        end
    end

end
