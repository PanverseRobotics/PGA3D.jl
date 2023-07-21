using PGA3D, Test, SafeTestsets, Logging, PrettyPrinting, StaticArrays, Random

@safetestset "Point3D" begin
    using PGA3D, Test, SafeTestsets, Logging, PrettyPrinting, StaticArrays, Random

    @safetestset "Identity" begin
        using PGA3D, Test, SafeTestsets, Logging, PrettyPrinting, StaticArrays, Random
        Random.seed!(1)
        for i in 1:100
            testpoint = Point3D(randn(3)...)
            motoridentity = identity_motor()
            @test transform(motoridentity, testpoint) ≈ testpoint
        end
    end

    @safetestset "Motor From To" begin
        using PGA3D, Test, SafeTestsets, Logging, PrettyPrinting, StaticArrays, Random, LinearAlgebra
        Random.seed!(1)
        for i in 1:100
            testfrom = Point3D(randn(3)...)
            testto = Point3D(randn(3)...)
            mft = motor_fromto(testfrom, testto)
            #@info testfrom
            #@info testto
            #@info internal_vec(testto) .- internal_vec(testfrom)
            #@info mft
            #@info transform(testfrom, mft)
            @test transform(mft, testfrom) ≈ testto
        end
    end

    @safetestset "Motor Screw Displacement" begin
        using PGA3D, Test, SafeTestsets, Logging, PrettyPrinting, StaticArrays, Random, LinearAlgebra
        Random.seed!(1)
        for i in 1:100
            # generate two random points
            testfrom = Point3D(randn(3)...)
            testto = Point3D(randn(3)...)
            dist = norm(internal_vec(testfrom) - internal_vec(testto))
            testline = line_fromto(testfrom, testto)
            mft = motor_screw(testline, 0, dist)
            #@test transform(mft, testfrom) ≈ testto
        end
    end

    @safetestset "Motor Screw Rotation" begin
        using PGA3D, Test, SafeTestsets, Logging, PrettyPrinting, StaticArrays, Random, LinearAlgebra
        Random.seed!(1)
        for i in 1:100
            # start with two random normalized points
            testfrom = Point3D(normalize(randn(3))...)
            testto = Point3D(normalize(randn(3))...)
            testfromar = SA[testfrom[1], testfrom[2], testfrom[3]]
            testtoar = SA[testto[1], testto[2], testto[3]]
            # calculate the angle between them in the plane they span
            y = cross(testfromar, testtoar)
            x = dot(testfromar, testtoar)
            angle = atan(norm(y), x)
            # create a unitized line from the origin to the cross product of the two points
            testline = line_fromto(Point3D(0.0, 0.0, 0.0), Point3D(y...))
            # now generate the screw that rotates from to to
            mft = motor_screw(testline, angle, 0)
            # and verify that the rotation works as intended
            rotatedfrom = transform(mft, testfrom)
            #@test rotatedfrom ≈ testto
        end
    end

    @safetestset "Motor to and from TransformMatrix" begin
        using PGA3D, Test, SafeTestsets, Logging, PrettyPrinting, StaticArrays, Random, LinearAlgebra
        motor_identity = identity_motor()
        # ensures that each special motor is tested vs rand points and vice versa in addition to all special x special combos
        special_and_rand_motors = vcat(PGA3D.special_motors, [Motor3D(randn(8)...) for i in 1:50])
        special_and_rand_points = vcat(PGA3D.special_points, [Point3D(randn(4)...) for i in 1:50])
        special_motor_point_test_list = collect(Iterators.product(special_and_rand_motors, special_and_rand_points))
        Random.seed!(1)
        atol = 1e-8
        for i in 1:10_000
            (; testmotorprenorm, testpoint) = if i <= length(special_motor_point_test_list)
                testmotorprenorm = special_motor_point_test_list[i][1]
                testpoint = special_motor_point_test_list[i][2]
                (; testmotorprenorm, testpoint)
            else
                testmotorprenorm = Motor3D(randn(8)...)
                testpoint = Point3D(randn(4)...)
                (; testmotorprenorm, testpoint)
            end
            # only normalizable motors are viable for transform matrices
            testmotor = try
                normalize(testmotorprenorm)
            catch e
                @test isa(e, DomainError)
                @test isa(e.val, Motor3D)
                @test e.msg == "Motor3D must have a non-zero rotational part to normalize."
                continue
            end


            testmatrix = get_transform_matrix(testmotor)
            testmatrixinv = get_inv_transform_matrix(testmotor)
            testmatrix2, testmatrixinv2 = get_transform_and_inv_matrices(testmotor)

            testmatrixneg = get_transform_matrix(-testmotor)
            @test testmatrixneg ≈ testmatrix atol = atol

            @test testmatrix ≈ testmatrix2 atol = atol
            @test testmatrixinv ≈ testmatrixinv2 atol = atol
            SAI = SA[1.0 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1]
            @test testmatrix * testmatrixinv ≈ SAI atol = atol
            @test testmatrixinv * testmatrix ≈ SAI atol = atol
            transformedpt = transform(testmotor, testpoint)
            matrixedpt = testmatrix * internal_vec(testpoint)
            @test internal_vec(transformedpt) ≈ matrixedpt atol = atol
            @test testmatrixinv * matrixedpt ≈ internal_vec(testpoint) atol = atol
            invmatrixedpt = testmatrixinv * internal_vec(testpoint)
            invtransformedpt = transform(PGA3D.reverse(testmotor), testpoint)
            @test internal_vec(invtransformedpt) ≈ invmatrixedpt atol = atol

            # there are two motors per transform matrix (m and -m), so we need to test that it is generated as one of the two
            testmotor2 = normalize(motor_from_transform(testmatrix))
            @test isapprox(testmotor2, testmotor; atol=atol) || isapprox(testmotor2, -testmotor; atol=atol)
            testmotorrev2 = normalize(motor_from_transform(testmatrixinv))
            @test isapprox(testmotorrev2, PGA3D.reverse(testmotor); atol=atol) || isapprox(testmotorrev2, -PGA3D.reverse(testmotor); atol=atol)
            @test testmotorrev2 ≈ PGA3D.reverse(testmotor) || testmotorrev2 ≈ -PGA3D.reverse(testmotor)
            @test testmotor2 * testmotorrev2 ≈ motor_identity || testmotor2 * testmotorrev2 ≈ -motor_identity
            @test testmotorrev2 * testmotor2 ≈ motor_identity || testmotorrev2 * testmotor2 ≈ -motor_identity

            testmatrix3, testmatrixinv3 = get_transform_and_inv_matrices(testmotor2)
            @test testmatrix3 ≈ testmatrix
            @test testmatrixinv3 ≈ testmatrixinv
        end
    end

    @safetestset "Motor log and bivector exp" begin
        using PGA3D, Test, SafeTestsets, Logging, PrettyPrinting, StaticArrays, Random, LinearAlgebra
        Random.seed!(1)
        atol = 1e-10
        specialpath_atol = 1e-3
        motor_identity = identity_motor()
        special_motor_test_list = PGA3D.special_motors
        for i in 1:10_000
            testmotorprenorm = if i <= length(special_motor_test_list)
                special_motor_test_list[i]
            else
                Motor3D(randn(8)...)
            end

            testmotor = try
                normalize(testmotorprenorm)
            catch e
                @test isa(e, DomainError)
                @test isa(e.val, Motor3D)
                @test e.msg == "Motor3D must have a non-zero rotational part to normalize."
                continue
            end

            @test testmotor * PGA3D.reverse(testmotor) ≈ motor_identity

            testbv = log(testmotor)
            testmotorexp = exp(testbv)
            @test testmotorexp * PGA3D.reverse(testmotorexp) ≈ motor_identity

            @test isapprox(testmotorexp, testmotor; atol=atol) || isapprox(testmotorexp, -testmotor; atol=atol) ||
                  (testmotorexp[2] == 0.0 && testmotorexp[3] == 0.0 && testmotorexp[4] == 0.0) && (isapprox(testmotorexp, testmotor; atol=specialpath_atol) || isapprox(testmotorexp, -testmotor; atol=specialpath_atol))
            if !(isapprox(testmotorexp, testmotor; atol=atol) || isapprox(testmotorexp, -testmotor; atol=atol) ||
                 (testmotorexp[2] == 0.0 && testmotorexp[3] == 0.0 && testmotorexp[4] == 0.0) && (isapprox(testmotorexp, testmotor; atol=specialpath_atol) || isapprox(testmotorexp, -testmotor; atol=specialpath_atol))
            )
                @info testmotor
                @info testbv
                @info testmotorexp
            end

            testbvha = testbv * (1 // 2)
            testmotorexpha = normalize(exp(testbvha))
            testmotorexpha2 = normalize(testmotorexpha * testmotorexpha)


            @test isapprox(testmotorexpha2, testmotor; atol=atol) || isapprox(testmotorexpha2, -testmotor; atol=atol) ||
                  (testmotorexpha2[2] == 0.0 && testmotorexpha2[3] == 0.0 && testmotorexpha2[4] == 0.0) && (isapprox(testmotorexpha2, testmotor; atol=specialpath_atol) || isapprox(testmotorexpha2, -testmotor; atol=specialpath_atol))

            testbvthi = testbv * (1 // 3)
            testmotorexpthi = normalize(exp(testbvthi))
            testmotorexpthi3 = normalize(testmotorexpthi * testmotorexpthi * testmotorexpthi)


            @test isapprox(testmotorexpthi3, testmotor; atol=atol) || isapprox(testmotorexpthi3, -testmotor; atol=atol) ||
                  (testmotorexpthi3[2] == 0.0 && testmotorexpthi3[3] == 0.0 && testmotorexpthi3[4] == 0.0) && (isapprox(testmotorexpthi3, testmotor; atol=specialpath_atol) || isapprox(testmotorexpthi3, -testmotor; atol=specialpath_atol))

            testmotor2 = normalize(Motor3D(randn(8)...))

            testmotor21 = testmotor2 * PGA3D.reverse(testmotor)
            testmotor221 = testmotor21 * testmotor

            @test testmotor221 ≈ testmotor2 || testmotor221 ≈ -testmotor2

            testbv21 = log(testmotor21)
            testmotor212 = exp(testbv21)
            testmotor222 = testmotor212 * testmotor

            @test isapprox(testmotor222, testmotor2; atol=atol) || isapprox(testmotor222, -testmotor2; atol=atol)
        end
    end

    @safetestset "Line exp and motor log" begin
        using PGA3D, Test, SafeTestsets, Logging, PrettyPrinting, StaticArrays, Random, LinearAlgebra
        Random.seed!(1)
        atol = 1e-10
        specialpath_atol = 1e-3
        motor_identity = identity_motor()
        special_line_test_list = PGA3D.special_lines
        for i in 1:10_000
            testline = if i <= length(special_line_test_list)
                special_line_test_list[i]
            else
                # can't do gaussians here because if the rotation part is too big then !(log(exp(testline)) ≈ testline) 
                rotvalue = 3 .* rand(3) .- 1.5
                transvalue = randn(3)
                Line3D(rotvalue..., transvalue...)
            end

            testmotor = exp(testline)
            testline2 = log(testmotor)
            @test isapprox(testline2, testline; atol=atol)

            testmotor2 = exp(testline2)
            @test isapprox(testmotor2, testmotor; atol=atol) || isapprox(testmotor2, -testmotor; atol=atol) ||
                  (testmotor2[2] == 0.0 && testmotor2[3] == 0.0 && testmotor2[4] == 0.0) && (isapprox(testmotor2, testmotor; atol=specialpath_atol) || isapprox(testmotor2, -testmotor; atol=specialpath_atol))

        end
    end
end