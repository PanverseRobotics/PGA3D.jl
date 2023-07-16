using PGA3D, Test, SafeTestsets, Logging, PrettyPrinting, StaticArrays, Random

@safetestset "Point3D" begin
    using PGA3D, Test, SafeTestsets, Logging, PrettyPrinting, StaticArrays, Random

    @safetestset "Identity" begin
        using PGA3D, Test, SafeTestsets, Logging, PrettyPrinting, StaticArrays, Random
        for i in 1:100
            testpoint = Point3D(randn(3)...)
            motoridentity = identity_motor()
            @test transform(testpoint, motoridentity) ≈ testpoint
        end
    end

    @safetestset "Motor From To" begin
        using PGA3D, Test, SafeTestsets, Logging, PrettyPrinting, StaticArrays, Random, LinearAlgebra
        for i in 1:100
            testfrom = Point3D(randn(3)...)
            testto = Point3D(randn(3)...)
            mft = motor_fromto(testfrom, testto)
            @test transform(testfrom, mft) ≈ testto
        end
    end

    @safetestset "Motor Screw Displacement" begin
        using PGA3D, Test, SafeTestsets, Logging, PrettyPrinting, StaticArrays, Random, LinearAlgebra
        for i in 1:100
            # generate two random points
            testfrom = Point3D(randn(3)...)
            testto = Point3D(randn(3)...)
            dist = norm(internal_vec(testfrom) - internal_vec(testto))
            testline = line_fromto(testfrom, testto)
            mft = motor_screw(testline, 0, dist)
            @test transform(testfrom, mft) ≈ testto
        end
    end

    @safetestset "Motor Screw Rotation" begin
        using PGA3D, Test, SafeTestsets, Logging, PrettyPrinting, StaticArrays, Random, LinearAlgebra
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
            rotatedfrom = transform(testfrom, mft)
            @test rotatedfrom ≈ testto
        end
    end

    @safetestset "Motor to and from TransformMatrix" begin
        using PGA3D, Test, SafeTestsets, Logging, PrettyPrinting, StaticArrays, Random, LinearAlgebra
        motor_identity = identity_motor()
        for i in 1:1000
            testfrom = Point3D(randn(3)...)
            testto = Point3D(randn(3)...)
            testline = line_fromto(testfrom, testto)
            testangle = randn()
            testdisp = randn()
            testmotor = motor_screw(testline, testangle, testdisp)
            testmatrix = get_transform_matrix(testmotor)
            testmatrixinv = get_inv_transform_matrix(testmotor)
            testmatrix2, testmatrixinv2 = get_transform_and_inv_matrices(testmotor)

            testmatrixneg = get_transform_matrix(-testmotor)
            @test testmatrixneg ≈ testmatrix

            @test testmatrix ≈ testmatrix2
            @test testmatrixinv ≈ testmatrixinv2
            SAI = SA[1.0 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1]
            @test testmatrix * testmatrixinv ≈ SAI
            @test testmatrixinv * testmatrix ≈ SAI
            testpoint = Point3D(randn(3)...)
            transformedpt = transform(testpoint, testmotor)
            matrixedpt = testmatrix * internal_vec(testpoint)
            @test internal_vec(transformedpt) ≈ matrixedpt
            @test testmatrixinv * matrixedpt ≈ internal_vec(testpoint)
            invmatrixedpt = testmatrixinv * internal_vec(testpoint)
            invtransformedpt = transform(testpoint, PGA3D.reverse(testmotor))
            @test internal_vec(invtransformedpt) ≈ invmatrixedpt

            # there are two motors per transform matrix (m and -m), so we need to test that it is generated as one of the two
            testmotor2 = motor_from_transform(testmatrix)
            @test testmotor2 ≈ testmotor || testmotor2 ≈ -testmotor
            testmotorrev2 = motor_from_transform(testmatrixinv)
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
        motor_identity = identity_motor()
        for i in 1:1000
            testfrom = Point3D(randn(3)...)
            testto = Point3D(randn(3)...)
            testline = line_fromto(testfrom, testto)
            testangle = rand()
            testdisp = rand()
            testmotor = normalize(motor_screw(testline, testangle, testdisp))

            testbv = log(testmotor)

            testmotorexp = normalize(exp(testbv))

            @test testmotorexp ≈ testmotor || testmotorexp ≈ -testmotor

            testbvha = Line3D(internal_vec(testbv) .* 0.5)
            testmotorexpha = normalize(exp(testbvha))
            testmotorexpha2 = normalize(testmotorexpha * testmotorexpha)


            #@info "testmotor: $testmotor"
            #@info "testmotorexpha: $testmotorexpha"
            #@info "testmotorexpha2: $testmotorexpha2"
            @test isapprox(testmotorexpha2, testmotor; atol=0.1) || isapprox(testmotorexpha2, -testmotor; atol=0.1)

            ≈
        end
    end
end