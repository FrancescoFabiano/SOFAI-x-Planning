; Optimality lenght is (:optlen -1)

(define (problem DLOG-3-3-6)
	(:domain driverlog)
	(:objects
	driver1 - driver
	driver2 - driver
	driver3 - driver
	truck1 - truck
	truck2 - truck
	truck3 - truck
	package1 - obj
	package2 - obj
	package3 - obj
	package4 - obj
	package5 - obj
	package6 - obj
	s0 - location
	s1 - location
	s2 - location
	s3 - location
	s4 - location
	s5 - location
	p1-3 - location
	p1-4 - location
	p2-5 - location
	p3-4 - location
	p3-5 - location
	p4-5 - location
	p5-0 - location
	p5-1 - location
	)
	(:init
	(at driver1 s2)
	(at driver2 s3)
	(at driver3 s1)
	(at truck1 s1)
	(empty truck1)
	(at truck2 s3)
	(empty truck2)
	(at truck3 s3)
	(empty truck3)
	(at package1 s2)
	(at package2 s1)
	(at package3 s3)
	(at package4 s3)
	(at package5 s1)
	(at package6 s3)
	(path s1 p1-3)
	(path p1-3 s1)
	(path s3 p1-3)
	(path p1-3 s3)
	(path s1 p1-4)
	(path p1-4 s1)
	(path s4 p1-4)
	(path p1-4 s4)
	(path s2 p2-5)
	(path p2-5 s2)
	(path s5 p2-5)
	(path p2-5 s5)
	(path s3 p3-4)
	(path p3-4 s3)
	(path s4 p3-4)
	(path p3-4 s4)
	(path s3 p3-5)
	(path p3-5 s3)
	(path s5 p3-5)
	(path p3-5 s5)
	(path s4 p4-5)
	(path p4-5 s4)
	(path s5 p4-5)
	(path p4-5 s5)
	(path s5 p5-0)
	(path p5-0 s5)
	(path s0 p5-0)
	(path p5-0 s0)
	(path s5 p5-1)
	(path p5-1 s5)
	(path s1 p5-1)
	(path p5-1 s1)
	(link s1 s0)
	(link s0 s1)
	(link s1 s2)
	(link s2 s1)
	(link s1 s3)
	(link s3 s1)
	(link s1 s4)
	(link s4 s1)
	(link s2 s0)
	(link s0 s2)
	(link s2 s3)
	(link s3 s2)
	(link s3 s0)
	(link s0 s3)
	(link s4 s0)
	(link s0 s4)
	(link s4 s5)
	(link s5 s4)
	(link s5 s1)
	(link s1 s5)
	(link s5 s2)
	(link s2 s5)
	(link s5 s3)
	(link s3 s5)
)
	(:goal (and
	(at driver1 s1)
	(at driver2 s4)
	(at driver3 s2)
	(at truck1 s4)
	(at truck2 s2)
	(at truck3 s2)
	(at package2 s1)
	(at package3 s4)
	(at package4 s2)
	(at package5 s5)
	(at package6 s2)
	))


)
