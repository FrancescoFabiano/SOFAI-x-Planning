; Optimality lenght is (:optlen -1)

(define (problem DLOG-4-4-8)
	(:domain driverlog)
	(:objects
	driver1 - driver
	driver2 - driver
	driver3 - driver
	driver4 - driver
	truck1 - truck
	truck2 - truck
	truck3 - truck
	truck4 - truck
	package1 - obj
	package2 - obj
	package3 - obj
	package4 - obj
	package5 - obj
	package6 - obj
	package7 - obj
	package8 - obj
	s0 - location
	s1 - location
	s2 - location
	s3 - location
	s4 - location
	s5 - location
	p0-4 - location
	p1-0 - location
	p2-1 - location
	p3-0 - location
	p3-5 - location
	p4-3 - location
	p5-0 - location
	p5-1 - location
	p5-2 - location
	)
	(:init
	(at driver1 s1)
	(at driver2 s2)
	(at driver3 s5)
	(at driver4 s5)
	(at truck1 s0)
	(empty truck1)
	(at truck2 s3)
	(empty truck2)
	(at truck3 s2)
	(empty truck3)
	(at truck4 s5)
	(empty truck4)
	(at package1 s5)
	(at package2 s5)
	(at package3 s1)
	(at package4 s1)
	(at package5 s2)
	(at package6 s4)
	(at package7 s4)
	(at package8 s2)
	(path s0 p0-4)
	(path p0-4 s0)
	(path s4 p0-4)
	(path p0-4 s4)
	(path s1 p1-0)
	(path p1-0 s1)
	(path s0 p1-0)
	(path p1-0 s0)
	(path s2 p2-1)
	(path p2-1 s2)
	(path s1 p2-1)
	(path p2-1 s1)
	(path s3 p3-0)
	(path p3-0 s3)
	(path s0 p3-0)
	(path p3-0 s0)
	(path s3 p3-5)
	(path p3-5 s3)
	(path s5 p3-5)
	(path p3-5 s5)
	(path s4 p4-3)
	(path p4-3 s4)
	(path s3 p4-3)
	(path p4-3 s3)
	(path s5 p5-0)
	(path p5-0 s5)
	(path s0 p5-0)
	(path p5-0 s0)
	(path s5 p5-1)
	(path p5-1 s5)
	(path s1 p5-1)
	(path p5-1 s1)
	(path s5 p5-2)
	(path p5-2 s5)
	(path s2 p5-2)
	(path p5-2 s2)
	(link s0 s1)
	(link s1 s0)
	(link s0 s2)
	(link s2 s0)
	(link s0 s5)
	(link s5 s0)
	(link s1 s2)
	(link s2 s1)
	(link s1 s5)
	(link s5 s1)
	(link s2 s3)
	(link s3 s2)
	(link s2 s5)
	(link s5 s2)
	(link s3 s0)
	(link s0 s3)
	(link s3 s1)
	(link s1 s3)
	(link s4 s0)
	(link s0 s4)
	(link s4 s3)
	(link s3 s4)
	(link s5 s3)
	(link s3 s5)
	(link s5 s4)
	(link s4 s5)
)
	(:goal (and
	(at driver3 s2)
	(at truck1 s0)
	(at truck3 s0)
	(at truck4 s3)
	(at package1 s0)
	(at package2 s2)
	(at package3 s4)
	(at package4 s0)
	(at package5 s0)
	(at package6 s0)
	(at package7 s0)
	(at package8 s3)
	))


)
